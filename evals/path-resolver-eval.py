#!/usr/bin/env python3
"""Evaluate pdtf-path-resolver skill accuracy across models.

Tests whether models can find the exact PDTF path for common conveyancing documents.
Runs with and without the skill's schema-skeleton.md reference.
"""

import json
import os
import sys
import time
import anthropic
import openai

EVALS_FILE = os.path.join(os.path.dirname(__file__), "path-resolver-evals.json")
SKILL_DIR = os.path.join(os.path.dirname(__file__), "..", "pdtf-path-resolver", "skills", "pdtf-path-resolver")
SKILL_FILE = os.path.join(SKILL_DIR, "SKILL.md")
SKELETON_FILE = os.path.join(SKILL_DIR, "references", "schema-skeleton.md")
RESULTS_DIR = os.path.join(os.path.dirname(__file__), "path-resolver-results")

MODELS = {
    "sonnet": {"provider": "anthropic", "model": "claude-sonnet-4-20250514"},
    "haiku": {"provider": "anthropic", "model": "claude-3-haiku-20240307"},
    "gpt54m": {"provider": "openai", "model": "gpt-5.4-mini"},
}

def load_skill_context():
    with open(SKILL_FILE) as f:
        skill = f.read()
    with open(SKELETON_FILE) as f:
        skeleton = f.read()
    return f"{skill}\n\n---\n\n{skeleton}"

def call_anthropic(model, system, user_msg):
    client = anthropic.Anthropic()
    resp = client.messages.create(
        model=model,
        max_tokens=500,
        system=system,
        messages=[{"role": "user", "content": user_msg}],
    )
    return resp.content[0].text

def call_openai(model, system, user_msg):
    client = openai.OpenAI()
    resp = client.chat.completions.create(
        model=model,
        max_completion_tokens=500,
        messages=[
            {"role": "system", "content": system},
            {"role": "user", "content": user_msg},
        ],
    )
    return resp.choices[0].message.content

def call_model(provider, model, system, user_msg):
    if provider == "anthropic":
        return call_anthropic(model, system, user_msg)
    elif provider == "openai":
        return call_openai(model, system, user_msg)

def check_path(response, expected):
    """Check if the expected path appears in the response."""
    # Normalise: strip trailing slashes, handle [] array notation
    norm_expected = expected.rstrip("/")
    norm_response = response.rstrip("/")
    
    # Direct containment check
    if norm_expected in norm_response:
        return True
    
    # Without array notation
    no_array_expected = norm_expected.replace("/[]", "")
    if no_array_expected in norm_response:
        return True
    
    return False

def run_eval(eval_item, model_key, model_info, with_skill=True):
    cache_dir = os.path.join(RESULTS_DIR, model_key)
    os.makedirs(cache_dir, exist_ok=True)
    
    suffix = "with" if with_skill else "without"
    cache_file = os.path.join(cache_dir, f"{eval_item['id']}_{suffix}.json")
    
    if os.path.exists(cache_file):
        with open(cache_file) as f:
            return json.load(f)
    
    if with_skill:
        system = "You are a PDTF path resolver. Given a document or data subject, return the exact PDTF schema path. Be as specific as possible — always target the deepest applicable path (e.g. the attachments sub-path for documents).\n\n" + load_skill_context()
    else:
        system = "You are a property data expert. Given a document or data subject related to UK residential property conveyancing, suggest the most logical schema path where this data would be stored in a structured property transaction schema. Use forward-slash notation like /propertyPack/section/subsection. Be as specific as possible."
    
    try:
        response = call_model(model_info["provider"], model_info["model"], system, eval_item["input"])
        correct = check_path(response, eval_item["expected"])
    except Exception as e:
        response = f"ERROR: {e}"
        correct = False
    
    result = {
        "id": eval_item["id"],
        "input": eval_item["input"],
        "expected": eval_item["expected"],
        "response": response,
        "correct": correct,
        "model": model_key,
        "with_skill": with_skill,
    }
    
    with open(cache_file, "w") as f:
        json.dump(result, f, indent=2)
    
    return result

def main():
    with open(EVALS_FILE) as f:
        evals = json.load(f)
    
    os.makedirs(RESULTS_DIR, exist_ok=True)
    
    # Run subset or all
    model_filter = sys.argv[1] if len(sys.argv) > 1 else None
    
    models_to_run = {k: v for k, v in MODELS.items() if not model_filter or k == model_filter}
    
    results = {}
    total = len(evals) * len(models_to_run) * 2
    done = 0
    
    for model_key, model_info in models_to_run.items():
        results[model_key] = {"with": [], "without": []}
        
        for eval_item in evals:
            for with_skill in [True, False]:
                done += 1
                suffix = "with" if with_skill else "without"
                print(f"[{done}/{total}] {model_key} {suffix} {eval_item['id']}...", end=" ", flush=True)
                
                result = run_eval(eval_item, model_key, model_info, with_skill)
                results[model_key][suffix].append(result)
                
                mark = "✅" if result["correct"] else "❌"
                print(mark)
                
                time.sleep(0.3)
    
    # Summary
    print("\n" + "=" * 60)
    print("PDTF Path Resolver Eval Results")
    print("=" * 60)
    
    for model_key in models_to_run:
        with_correct = sum(1 for r in results[model_key]["with"] if r["correct"])
        without_correct = sum(1 for r in results[model_key]["without"] if r["correct"])
        n = len(evals)
        delta = with_correct - without_correct
        print(f"\n{model_key}:")
        print(f"  With skill:    {with_correct}/{n} ({100*with_correct//n}%)")
        print(f"  Without skill: {without_correct}/{n} ({100*without_correct//n}%)")
        print(f"  Delta:         +{delta} ({100*delta//n}%)")
        
        # Show failures with skill
        failures = [r for r in results[model_key]["with"] if not r["correct"]]
        if failures:
            print(f"  Failures with skill:")
            for f in failures:
                print(f"    {f['id']}: expected {f['expected']}")
                print(f"           got: {f['response'][:120]}...")
    
    # Save summary
    summary = {}
    for model_key in models_to_run:
        n = len(evals)
        summary[model_key] = {
            "with_skill": sum(1 for r in results[model_key]["with"] if r["correct"]),
            "without_skill": sum(1 for r in results[model_key]["without"] if r["correct"]),
            "total": n,
            "failures_with_skill": [
                {"id": r["id"], "expected": r["expected"], "response": r["response"][:200]}
                for r in results[model_key]["with"] if not r["correct"]
            ],
        }
    
    with open(os.path.join(RESULTS_DIR, "summary.json"), "w") as f:
        json.dump(summary, f, indent=2)
    
    print(f"\nResults saved to {RESULTS_DIR}/")

if __name__ == "__main__":
    main()
