#!/usr/bin/env python3
"""Multi-model eval runner for conveyancing toolkit.

Runs each eval prompt against multiple models with and without skill context,
then grades all responses with LLM-as-judge.

Usage: python3 multi-model-eval.py [--models claude-opus,gpt-54,gpt-52,...] [--evals 4,5,6,...] [--grade-only]
Env: ANTHROPIC_API_KEY, OPENAI_API_KEY, GOOGLE_API_KEY
"""

import json, os, re, sys, time, argparse
from pathlib import Path
from urllib.request import Request, urlopen
from urllib.error import HTTPError

EVALS_JSON = Path(__file__).parent / "evals.json"
SKILLS_ROOT = Path(__file__).parent.parent
OUTPUT_ROOT = Path(__file__).parent.parent / "evals-workspace" / "multi-model"

ANTHROPIC_KEY = os.environ.get("ANTHROPIC_API_KEY", "")
OPENAI_KEY = os.environ.get("OPENAI_API_KEY", "")
GOOGLE_KEY = os.environ.get("GOOGLE_API_KEY", "")

MODELS = {
    "claude-opus": {"provider": "anthropic", "model": "claude-opus-4-0-20250514", "label": "Claude Opus 4"},
    "claude-sonnet": {"provider": "anthropic", "model": "claude-sonnet-4-20250514", "label": "Claude Sonnet 4"},
    "claude-haiku": {"provider": "anthropic", "model": "claude-3-haiku-20240307", "label": "Claude 3 Haiku"},
    "gpt-54": {"provider": "openai", "model": "gpt-5.4", "label": "GPT-5.4"},
    "gpt-54-mini": {"provider": "openai", "model": "gpt-5.4-mini", "label": "GPT-5.4 Mini"},
    "gpt-52": {"provider": "openai", "model": "gpt-5.2", "label": "GPT-5.2"},
    "gemini-3-flash": {"provider": "google", "model": "gemini-3-flash-preview", "label": "Gemini 3 Flash"},
    "gemini-25-pro": {"provider": "google", "model": "gemini-2.5-pro-preview-05-06", "label": "Gemini 2.5 Pro"},
}

JUDGE_MODEL = "claude-sonnet-4-20250514"

def call_anthropic(model: str, prompt: str, system: str = "") -> str:
    msgs = [{"role": "user", "content": prompt}]
    body = {"model": model, "max_tokens": 4000, "messages": msgs}
    if system:
        body["system"] = system
    req = Request(
        "https://api.anthropic.com/v1/messages",
        data=json.dumps(body).encode(),
        headers={
            "x-api-key": ANTHROPIC_KEY,
            "anthropic-version": "2023-06-01",
            "content-type": "application/json",
        },
    )
    return _call_with_retry(req)

def call_openai(model: str, prompt: str, system: str = "") -> str:
    msgs = []
    if system:
        msgs.append({"role": "system", "content": system})
    msgs.append({"role": "user", "content": prompt})
    body = {"model": model, "max_completion_tokens": 4000, "messages": msgs}
    req = Request(
        "https://api.openai.com/v1/chat/completions",
        data=json.dumps(body).encode(),
        headers={
            "Authorization": f"Bearer {OPENAI_KEY}",
            "content-type": "application/json",
        },
    )
    return _call_with_retry(req, extract_openai=True)

def call_google(model: str, prompt: str, system: str = "") -> str:
    full_prompt = f"{system}\n\n{prompt}" if system else prompt
    body = {"contents": [{"parts": [{"text": full_prompt}]}]}
    url = f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={GOOGLE_KEY}"
    req = Request(url, data=json.dumps(body).encode(), headers={"content-type": "application/json"})
    return _call_with_retry(req, extract_google=True)

def _call_with_retry(req, extract_openai=False, extract_google=False, retries=3) -> str:
    for attempt in range(retries):
        try:
            with urlopen(req, timeout=120) as resp:
                data = json.loads(resp.read())
                if extract_openai:
                    return data["choices"][0]["message"]["content"]
                elif extract_google:
                    return data["candidates"][0]["content"]["parts"][0]["text"]
                else:  # anthropic
                    for block in data.get("content", []):
                        if block.get("type") == "text":
                            return block["text"]
                    return ""
        except HTTPError as e:
            if e.code == 429 and attempt < retries - 1:
                wait = int(e.headers.get("retry-after", 15))
                print(f"      Rate limited, waiting {wait}s...")
                time.sleep(wait)
            else:
                body = e.read().decode() if hasattr(e, 'read') else str(e)
                print(f"      HTTP {e.code}: {body[:200]}")
                raise
    return ""

def call_model(model_key: str, prompt: str, system: str = "") -> str:
    m = MODELS[model_key]
    if m["provider"] == "anthropic":
        return call_anthropic(m["model"], prompt, system)
    elif m["provider"] == "openai":
        return call_openai(m["model"], prompt, system)
    elif m["provider"] == "google":
        return call_google(m["model"], prompt, system)
    else:
        raise ValueError(f"Unknown provider: {m['provider']}")

def load_skill_context(skill_name: str) -> str:
    """Load the SKILL.md content for a given skill."""
    # Search for the skill
    for skill_dir in SKILLS_ROOT.glob(f"**/{skill_name}/SKILL.md"):
        content = skill_dir.read_text()
        # Also load references if they exist
        refs_dir = skill_dir.parent / "references"
        if refs_dir.exists():
            for ref_file in sorted(refs_dir.glob("*.md"))[:3]:  # Limit to 3 ref files
                ref_content = ref_file.read_text()
                if len(ref_content) < 20000:  # Don't include huge files
                    content += f"\n\n## Reference: {ref_file.name}\n{ref_content}"
        return content
    return ""

def grade_response(prompt: str, response: str, expectations: list) -> dict:
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

Be strict but fair. PASS means clearly satisfied. Partial/vague = FAIL. Semantic equivalence counts."""

    text = call_anthropic(JUDGE_MODEL, judge_prompt)
    m = re.search(r'\{.*\}', text, re.DOTALL)
    if m:
        return json.loads(m.group())
    return {"total_pass": 0, "total_expectations": len(expectations), "score_pct": 0}

def run_eval(eval_data: dict, model_key: str, with_skill: bool) -> dict:
    """Run a single eval for a model/skill combination."""
    skill_name = eval_data["skill"]
    prompt = eval_data["prompt"]
    
    if with_skill:
        skill_content = load_skill_context(skill_name)
        system = f"You have access to the following skill for answering conveyancing questions:\n\n{skill_content}"
    else:
        system = "Answer this UK conveyancing question using your training knowledge. Be as specific and detailed as you can."
    
    response = call_model(model_key, prompt, system)
    return {
        "eval_id": eval_data["id"],
        "skill": skill_name,
        "model": model_key,
        "model_label": MODELS[model_key]["label"],
        "variant": "with_skill" if with_skill else "without_skill",
        "response": response,
    }

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--models", default="claude-sonnet,claude-haiku,gpt-54-mini,gpt-52,gemini-3-flash",
                       help="Comma-separated model keys")
    parser.add_argument("--evals", default=None, help="Comma-separated eval IDs (default: all)")
    parser.add_argument("--grade-only", action="store_true", help="Only grade existing responses")
    parser.add_argument("--skip-grade", action="store_true", help="Only generate responses, skip grading")
    args = parser.parse_args()
    
    model_keys = args.models.split(",")
    
    with open(EVALS_JSON) as f:
        all_evals = json.load(f)["evals"]
    
    if args.evals:
        eval_ids = [int(x) for x in args.evals.split(",")]
        evals = [e for e in all_evals if e["id"] in eval_ids]
    else:
        evals = all_evals
    
    OUTPUT_ROOT.mkdir(parents=True, exist_ok=True)
    
    # Load existing results
    results_file = OUTPUT_ROOT / "results.json"
    if results_file.exists():
        with open(results_file) as f:
            all_results = json.load(f)
    else:
        all_results = {"runs": []}
    
    if not args.grade_only:
        print(f"Running {len(evals)} evals × {len(model_keys)} models × 2 variants = {len(evals) * len(model_keys) * 2} calls\n")
        
        for model_key in model_keys:
            if model_key not in MODELS:
                print(f"  SKIP unknown model: {model_key}")
                continue
            
            # Check API key
            provider = MODELS[model_key]["provider"]
            if provider == "anthropic" and not ANTHROPIC_KEY:
                print(f"  SKIP {model_key}: no ANTHROPIC_API_KEY"); continue
            if provider == "openai" and not OPENAI_KEY:
                print(f"  SKIP {model_key}: no OPENAI_API_KEY"); continue
            if provider == "google" and not GOOGLE_KEY:
                print(f"  SKIP {model_key}: no GOOGLE_API_KEY"); continue
            
            print(f"  Model: {MODELS[model_key]['label']}")
            
            for ev in evals:
                for with_skill in [True, False]:
                    variant = "with_skill" if with_skill else "without_skill"
                    
                    # Check if already done
                    out_dir = OUTPUT_ROOT / model_key / f"eval-{ev['id']}-{ev['skill']}" / variant / "outputs"
                    resp_file = out_dir / "response.md"
                    if resp_file.exists():
                        print(f"    eval-{ev['id']} {variant}: cached")
                        continue
                    
                    print(f"    eval-{ev['id']} {variant}...", end=" ", flush=True)
                    try:
                        result = run_eval(ev, model_key, with_skill)
                        out_dir.mkdir(parents=True, exist_ok=True)
                        resp_file.write_text(result["response"])
                        print("✓")
                        time.sleep(2)  # Rate limit buffer
                    except Exception as e:
                        print(f"✗ ({e})")
                        time.sleep(5)
    
    if args.skip_grade:
        print("\nSkipping grading (--skip-grade)")
        return
    
    # Grade everything
    print("\nGrading all responses...")
    graded_results = []
    
    for model_key in model_keys:
        if model_key not in MODELS:
            continue
        model_dir = OUTPUT_ROOT / model_key
        if not model_dir.exists():
            continue
        
        print(f"\n  Model: {MODELS[model_key]['label']}")
        
        for ev in evals:
            for variant in ["with_skill", "without_skill"]:
                resp_file = model_dir / f"eval-{ev['id']}-{ev['skill']}" / variant / "outputs" / "response.md"
                grade_file = model_dir / f"eval-{ev['id']}-{ev['skill']}" / variant / "grading.json"
                
                if not resp_file.exists():
                    continue
                
                if grade_file.exists():
                    with open(grade_file) as f:
                        grade = json.load(f)
                    print(f"    eval-{ev['id']} {variant}: {grade.get('total_pass','?')}/{grade.get('total_expectations','?')} (cached)")
                else:
                    response = resp_file.read_text()
                    print(f"    eval-{ev['id']} {variant}...", end=" ", flush=True)
                    try:
                        grade = grade_response(ev["prompt"], response, ev["expectations"])
                        grade_file.parent.mkdir(parents=True, exist_ok=True)
                        with open(grade_file, "w") as f:
                            json.dump(grade, f, indent=2)
                        print(f"{grade.get('total_pass', '?')}/{grade.get('total_expectations', '?')} ({grade.get('score_pct', '?')}%)")
                        time.sleep(1)
                    except Exception as e:
                        print(f"✗ ({e})")
                        grade = {"total_pass": 0, "total_expectations": len(ev["expectations"]), "score_pct": 0}
                        time.sleep(5)
                
                graded_results.append({
                    "eval_id": ev["id"],
                    "skill": ev["skill"],
                    "model": model_key,
                    "model_label": MODELS[model_key]["label"],
                    "variant": variant,
                    **grade,
                })
    
    # Save graded results
    with open(OUTPUT_ROOT / "graded-results.json", "w") as f:
        json.dump({"judge_model": JUDGE_MODEL, "results": graded_results}, f, indent=2)
    
    # Generate benchmark
    generate_matrix_benchmark(graded_results)

def generate_matrix_benchmark(results: list):
    """Generate a multi-model benchmark markdown."""
    lines = [
        "# Conveyancing Toolkit — Multi-Model Benchmark\n",
        f"**Judge model:** {JUDGE_MODEL}",
        f"**Date:** {time.strftime('%Y-%m-%d')}\n",
    ]
    
    # Collect all models and skills
    models_seen = {}
    skills_seen = {}
    
    for r in results:
        models_seen[r["model"]] = r["model_label"]
        skills_seen[r["skill"]] = True
    
    # Model × variant averages
    model_avgs = {}
    for r in results:
        key = (r["model"], r["variant"])
        if key not in model_avgs:
            model_avgs[key] = []
        model_avgs[key].append(r.get("score_pct", 0))
    
    lines.append("## Model Comparison (averaged across all evals)\n")
    lines.append("| Model | With Skill | Baseline | Δ | Skill Helps? |")
    lines.append("|-------|:----------:|:--------:|:-:|:------------:|")
    
    for model_key in sorted(models_seen.keys()):
        ws = model_avgs.get((model_key, "with_skill"), [])
        wo = model_avgs.get((model_key, "without_skill"), [])
        ws_avg = sum(ws) / len(ws) if ws else 0
        wo_avg = sum(wo) / len(wo) if wo else 0
        delta = ws_avg - wo_avg
        helps = "✅ Yes" if delta > 5 else ("➖ Marginal" if delta > 0 else "❌ No")
        lines.append(f"| {models_seen[model_key]} | {ws_avg:.0f}% | {wo_avg:.0f}% | {delta:+.0f}% | {helps} |")
    
    # Per-skill × model matrix
    lines.append("\n## Skill × Model Matrix (with_skill score)\n")
    model_keys = sorted(models_seen.keys())
    header = "| Skill | " + " | ".join(models_seen[m] for m in model_keys) + " |"
    sep = "|-------|" + "|".join(":---:" for _ in model_keys) + "|"
    lines.append(header)
    lines.append(sep)
    
    # Group by skill
    skill_model_scores = {}
    for r in results:
        if r["variant"] == "with_skill":
            key = (r["skill"], r["model"])
            if key not in skill_model_scores:
                skill_model_scores[key] = []
            skill_model_scores[key].append(r.get("score_pct", 0))
    
    for skill in sorted(skills_seen.keys()):
        row = f"| {skill} |"
        for model_key in model_keys:
            scores = skill_model_scores.get((skill, model_key), [])
            avg = sum(scores) / len(scores) if scores else None
            if avg is not None:
                row += f" {avg:.0f}% |"
            else:
                row += " - |"
        lines.append(row)
    
    # Baseline matrix
    lines.append("\n## Skill × Model Matrix (baseline score)\n")
    lines.append(header)
    lines.append(sep)
    
    skill_model_baseline = {}
    for r in results:
        if r["variant"] == "without_skill":
            key = (r["skill"], r["model"])
            if key not in skill_model_baseline:
                skill_model_baseline[key] = []
            skill_model_baseline[key].append(r.get("score_pct", 0))
    
    for skill in sorted(skills_seen.keys()):
        row = f"| {skill} |"
        for model_key in model_keys:
            scores = skill_model_baseline.get((skill, model_key), [])
            avg = sum(scores) / len(scores) if scores else None
            if avg is not None:
                row += f" {avg:.0f}% |"
            else:
                row += " - |"
        lines.append(row)
    
    # Delta matrix
    lines.append("\n## Skill × Model Delta (with_skill − baseline)\n")
    lines.append(header)
    lines.append(sep)
    
    for skill in sorted(skills_seen.keys()):
        row = f"| {skill} |"
        for model_key in model_keys:
            ws = skill_model_scores.get((skill, model_key), [])
            wo = skill_model_baseline.get((skill, model_key), [])
            if ws and wo:
                ws_avg = sum(ws) / len(ws)
                wo_avg = sum(wo) / len(wo)
                d = ws_avg - wo_avg
                emoji = "🟢" if d > 10 else ("🟡" if d > 0 else "🔴")
                row += f" {emoji} {d:+.0f}% |"
            else:
                row += " - |"
        lines.append(row)
    
    lines.append("\n## Recommendations\n")
    lines.append("Skills to **keep** (consistent positive delta across models):")
    lines.append("Skills to **improve** (positive delta on some models, not others):")
    lines.append("Skills to **remove or rework** (zero or negative delta):")
    lines.append("\n*Review delta matrix above to populate these categories.*\n")
    
    output = OUTPUT_ROOT / "MULTI_MODEL_BENCHMARK.md"
    output.write_text("\n".join(lines) + "\n")
    print(f"\nBenchmark written to {output}")

if __name__ == "__main__":
    main()
