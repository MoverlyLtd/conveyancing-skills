#!/usr/bin/env python3
"""LLM-as-judge grader for conveyancing toolkit evals.

Usage: python3 llm-judge.py <iteration-dir>
Env: ANTHROPIC_API_KEY, EVAL_JUDGE_MODEL (default: claude-sonnet-4-5-20250514)
"""

import json, os, re, sys, time
from pathlib import Path
from urllib.request import Request, urlopen
from urllib.error import HTTPError

EVALS_JSON = Path(__file__).parent / "evals.json"
MODEL = os.environ.get("EVAL_JUDGE_MODEL", "claude-sonnet-4-20250514")
API_KEY = os.environ["ANTHROPIC_API_KEY"]

def call_anthropic(prompt: str) -> str:
    body = json.dumps({
        "model": MODEL,
        "max_tokens": 2000,
        "messages": [{"role": "user", "content": prompt}]
    }).encode()
    req = Request(
        "https://api.anthropic.com/v1/messages",
        data=body,
        headers={
            "x-api-key": API_KEY,
            "anthropic-version": "2023-06-01",
            "content-type": "application/json",
        },
    )
    for attempt in range(3):
        try:
            with urlopen(req, timeout=60) as resp:
                data = json.loads(resp.read())
                for block in data.get("content", []):
                    if block.get("type") == "text":
                        return block["text"]
                return ""
        except HTTPError as e:
            if e.code == 429 and attempt < 2:
                wait = int(e.headers.get("retry-after", 10))
                print(f"    Rate limited, waiting {wait}s...")
                time.sleep(wait)
            else:
                raise
    return ""

def extract_json(text: str) -> dict:
    m = re.search(r'\{.*\}', text, re.DOTALL)
    if m:
        return json.loads(m.group())
    return {}

def grade_response(prompt: str, response: str, expectations: list[str]) -> dict:
    judge_prompt = f"""You are an expert grader evaluating AI responses about UK conveyancing.

## Task
Grade this response against each expectation. For each, output PASS or FAIL with a brief reason.

## Original Prompt
{prompt}

## Response to Grade
{response}

## Expectations
{json.dumps(expectations)}

## Output Format
Return ONLY a JSON object:
{{
  "grades": [
    {{"expectation": "...", "pass": true, "reason": "brief reason"}}
  ],
  "total_pass": <number>,
  "total_expectations": <number>,
  "score_pct": <number 0-100>
}}

Be strict but fair. PASS means clearly satisfied. Partial or vague = FAIL. Semantic equivalence counts."""

    text = call_anthropic(judge_prompt)
    return extract_json(text)

def main():
    iter_dir = Path(sys.argv[1])
    with open(EVALS_JSON) as f:
        evals_data = json.load(f)
    
    eval_lookup = {e["id"]: e for e in evals_data["evals"]}
    results = []
    
    for eval_dir in sorted(iter_dir.glob("eval-*")):
        if not eval_dir.is_dir():
            continue
        # Extract ID: eval-12-cqs-practice-standards -> 12
        parts = eval_dir.name.split("-")
        try:
            eval_id = int(parts[1])
        except (IndexError, ValueError):
            continue
        
        if eval_id not in eval_lookup:
            print(f"  SKIP: No eval definition for ID {eval_id}")
            continue
        
        ev = eval_lookup[eval_id]
        print(f"  Grading eval-{eval_id} ({ev['skill']})...")
        
        for variant in ["with_skill", "without_skill"]:
            resp_file = eval_dir / variant / "outputs" / "response.md"
            if not resp_file.exists():
                print(f"    SKIP: {variant} (no response file)")
                continue
            
            response = resp_file.read_text()
            result = grade_response(ev["prompt"], response, ev["expectations"])
            
            passes = result.get("total_pass", 0)
            total = result.get("total_expectations", len(ev["expectations"]))
            score = result.get("score_pct", 0)
            
            print(f"    {variant}: {passes}/{total} ({score}%)")
            
            results.append({
                "eval_id": eval_id,
                "skill": ev["skill"],
                "variant": variant,
                "passes": passes,
                "total": total,
                "score_pct": score,
                "grades": result.get("grades", []),
            })
            
            # Small delay to avoid rate limits
            time.sleep(1)
    
    # Save raw results
    results_file = iter_dir / "grading-results.json"
    with open(results_file, "w") as f:
        json.dump({"model": MODEL, "results": results}, f, indent=2)
    
    # Generate benchmark markdown
    generate_benchmark(iter_dir, results)
    print(f"\nDone! Results at {iter_dir}/benchmark-llm-judge.md")

def generate_benchmark(iter_dir: Path, results: list[dict]):
    # Group by eval_id
    evals = {}
    for r in results:
        eid = r["eval_id"]
        if eid not in evals:
            evals[eid] = {"skill": r["skill"]}
        evals[eid][r["variant"]] = r
    
    lines = [
        "# Conveyancing Toolkit — LLM-as-Judge Benchmark\n",
        f"**Judge model:** {MODEL}",
        f"**Date:** {time.strftime('%Y-%m-%d')}\n",
        "## Results\n",
        "| ID | Skill | With Skill | Baseline | Delta |",
        "|-----|-------|-----------|----------|-------|",
    ]
    
    total_with = total_without = 0
    count_with = count_without = 0
    
    for eid in sorted(evals.keys()):
        e = evals[eid]
        ws = e.get("with_skill", {})
        wo = e.get("without_skill", {})
        ws_p = f"{ws.get('passes', '?')}/{ws.get('total', '?')}"
        wo_p = f"{wo.get('passes', '?')}/{wo.get('total', '?')}"
        ws_pct = ws.get("score_pct", None)
        wo_pct = wo.get("score_pct", None)
        
        if ws_pct is not None:
            total_with += ws_pct
            count_with += 1
        if wo_pct is not None:
            total_without += wo_pct
            count_without += 1
        
        delta = ""
        if ws_pct is not None and wo_pct is not None:
            d = ws_pct - wo_pct
            delta = f"+{d:.0f}%" if d >= 0 else f"{d:.0f}%"
        
        ws_str = f"{ws_p} ({ws_pct}%)" if ws_pct is not None else "-"
        wo_str = f"{wo_p} ({wo_pct}%)" if wo_pct is not None else "-"
        
        lines.append(f"| {eid} | {e['skill']} | {ws_str} | {wo_str} | {delta} |")
    
    lines.append("")
    if count_with > 0 and count_without > 0:
        avg_with = total_with / count_with
        avg_without = total_without / count_without
        lines.append(f"**Average: With skill {avg_with:.0f}% vs Baseline {avg_without:.0f}% (Δ +{avg_with - avg_without:.0f}%)**\n")
    
    # Per-skill summary
    skills = {}
    for r in results:
        s = r["skill"]
        if s not in skills:
            skills[s] = {"with": [], "without": []}
        if r["variant"] == "with_skill":
            skills[s]["with"].append(r["score_pct"])
        else:
            skills[s]["without"].append(r["score_pct"])
    
    lines.append("## Per-Skill Summary\n")
    lines.append("| Skill | With Skill (avg) | Baseline (avg) | Delta |")
    lines.append("|-------|-----------------|----------------|-------|")
    
    for skill in sorted(skills.keys()):
        ws_avg = sum(skills[skill]["with"]) / len(skills[skill]["with"]) if skills[skill]["with"] else 0
        wo_avg = sum(skills[skill]["without"]) / len(skills[skill]["without"]) if skills[skill]["without"] else 0
        d = ws_avg - wo_avg
        delta = f"+{d:.0f}%" if d >= 0 else f"{d:.0f}%"
        lines.append(f"| {skill} | {ws_avg:.0f}% | {wo_avg:.0f}% | {delta} |")
    
    output = iter_dir / "benchmark-llm-judge.md"
    output.write_text("\n".join(lines) + "\n")

if __name__ == "__main__":
    main()
