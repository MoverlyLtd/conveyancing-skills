#!/usr/bin/env bash
# LLM-as-judge grader for conveyancing toolkit evals
# Usage: bash llm-grade.sh <iteration-dir>
# Grades each eval's with_skill and without_skill responses against expectations
# using an LLM judge, then produces a benchmark summary.
#
# Requires: ANTHROPIC_API_KEY env var

set -euo pipefail

ITER_DIR="${1:?Usage: llm-grade.sh <iteration-dir>}"
EVALS_JSON="$(dirname "$0")/evals.json"
MODEL="${EVAL_JUDGE_MODEL:-claude-sonnet-4-5-20250514}"
OUTPUT_FILE="$ITER_DIR/benchmark-llm-judge.md"
RESULTS_JSON="$ITER_DIR/grading-results.json"

if [ ! -f "$EVALS_JSON" ]; then
  echo "ERROR: evals.json not found at $EVALS_JSON"
  exit 1
fi

echo "Grading evals in $ITER_DIR using $MODEL..."
echo '{"results": []}' > "$RESULTS_JSON"

# Get all eval directories
for eval_dir in "$ITER_DIR"/eval-*/; do
  [ -d "$eval_dir" ] || continue
  
  # Extract eval ID from directory name (e.g., eval-4-lease-impact-advisor -> 4)
  dir_name=$(basename "$eval_dir")
  eval_id=$(echo "$dir_name" | sed 's/eval-\([0-9]*\).*/\1/')
  
  # Get eval details from evals.json
  eval_data=$(python3 -c "
import json, sys
with open('$EVALS_JSON') as f:
    data = json.load(f)
for e in data['evals']:
    if e['id'] == $eval_id:
        print(json.dumps(e))
        break
")
  
  if [ -z "$eval_data" ]; then
    echo "  SKIP: No eval definition for ID $eval_id"
    continue
  fi
  
  prompt=$(echo "$eval_data" | python3 -c "import json,sys; print(json.load(sys.stdin)['prompt'])")
  skill=$(echo "$eval_data" | python3 -c "import json,sys; print(json.load(sys.stdin)['skill'])")
  expectations=$(echo "$eval_data" | python3 -c "import json,sys; print(json.dumps(json.load(sys.stdin)['expectations']))")
  
  echo "  Grading eval-$eval_id ($skill)..."
  
  for variant in with_skill without_skill; do
    response_file="$eval_dir/$variant/outputs/response.md"
    if [ ! -f "$response_file" ]; then
      echo "    SKIP: $variant (no response file)"
      continue
    fi
    
    response=$(cat "$response_file")
    
    # Build grading prompt
    grade_prompt=$(cat <<GRADING_EOF
You are an expert grader evaluating AI responses about UK conveyancing.

## Task
Grade this response against each expectation. For each, output PASS or FAIL with a brief reason.

## Original Prompt
$prompt

## Response to Grade
$response

## Expectations
$expectations

## Output Format
Return ONLY a JSON object with this structure:
{
  "grades": [
    {"expectation": "...", "pass": true/false, "reason": "brief reason"}
  ],
  "total_pass": <number>,
  "total_expectations": <number>,
  "score_pct": <number 0-100>
}

Be strict but fair. A PASS means the response clearly satisfies the expectation. Partial or vague coverage is a FAIL. The response does not need to use the exact same words — semantic equivalence counts.
GRADING_EOF
)
    
    # Call Anthropic API
    result=$(curl -sf https://api.anthropic.com/v1/messages \
      -H "x-api-key: $ANTHROPIC_API_KEY" \
      -H "anthropic-version: 2023-06-01" \
      -H "content-type: application/json" \
      -d "$(python3 -c "
import json, sys
msg = {
    'model': '$MODEL',
    'max_tokens': 2000,
    'messages': [{'role': 'user', 'content': sys.stdin.read()}]
}
print(json.dumps(msg))
" <<< "$grade_prompt")" 2>/dev/null)
    
    # Extract text from response
    grade_text=$(echo "$result" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    for block in data.get('content', []):
        if block.get('type') == 'text':
            # Extract JSON from response (may have markdown wrapping)
            text = block['text']
            # Find JSON object
            import re
            m = re.search(r'\{.*\}', text, re.DOTALL)
            if m:
                parsed = json.loads(m.group())
                print(json.dumps(parsed))
                break
except Exception as e:
    print(json.dumps({'error': str(e), 'total_pass': 0, 'total_expectations': 0, 'score_pct': 0}))
")
    
    if [ -z "$grade_text" ]; then
      echo "    ERROR: Failed to grade $variant"
      continue
    fi
    
    score=$(echo "$grade_text" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('score_pct', 0))")
    passes=$(echo "$grade_text" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('total_pass', 0))")
    total=$(echo "$grade_text" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('total_expectations', 0))")
    
    echo "    $variant: $passes/$total ($score%)"
    
    # Append to results
    python3 -c "
import json
with open('$RESULTS_JSON') as f:
    data = json.load(f)
data['results'].append({
    'eval_id': $eval_id,
    'skill': '$skill',
    'variant': '$variant',
    'passes': $passes,
    'total': $total,
    'score_pct': $score,
    'grades': json.loads('$grade_text').get('grades', [])
})
with open('$RESULTS_JSON', 'w') as f:
    json.dump(data, f, indent=2)
"
  done
done

echo ""
echo "Generating benchmark summary..."

# Generate markdown benchmark
python3 << 'PYEOF'
import json

RESULTS = "$RESULTS_JSON"
OUTPUT = "$OUTPUT_FILE"

with open(RESULTS) as f:
    data = json.load(f)

# Group by eval_id
evals = {}
for r in data['results']:
    eid = r['eval_id']
    if eid not in evals:
        evals[eid] = {'skill': r['skill']}
    evals[eid][r['variant']] = r

lines = []
lines.append("# Conveyancing Toolkit — LLM-as-Judge Benchmark\n")
lines.append(f"**Judge model:** {open('/dev/stdin').read().strip()}\n" if False else "")
lines.append("## Results\n")
lines.append("| ID | Skill | With Skill | Baseline | Delta |")
lines.append("|-----|-------|-----------|----------|-------|")

total_with = 0
total_without = 0
count_with = 0
count_without = 0

for eid in sorted(evals.keys()):
    e = evals[eid]
    ws = e.get('with_skill', {})
    wo = e.get('without_skill', {})
    ws_score = ws.get('score_pct', '-')
    wo_score = wo.get('score_pct', '-')
    
    if isinstance(ws_score, (int, float)):
        total_with += ws_score
        count_with += 1
    if isinstance(wo_score, (int, float)):
        total_without += wo_score
        count_without += 1
    
    delta = ''
    if isinstance(ws_score, (int, float)) and isinstance(wo_score, (int, float)):
        d = ws_score - wo_score
        delta = f"+{d:.0f}%" if d >= 0 else f"{d:.0f}%"
    
    ws_str = f"{ws_score}%" if isinstance(ws_score, (int, float)) else '-'
    wo_str = f"{wo_score}%" if isinstance(wo_score, (int, float)) else '-'
    
    lines.append(f"| {eid} | {e['skill']} | {ws_str} | {wo_str} | {delta} |")

lines.append("")
if count_with > 0 and count_without > 0:
    avg_with = total_with / count_with
    avg_without = total_without / count_without
    lines.append(f"**Average: With skill {avg_with:.0f}% vs Baseline {avg_without:.0f}% (delta +{avg_with - avg_without:.0f}%)**\n")

with open(OUTPUT, 'w') as f:
    f.write('\n'.join(lines))

print(f"Written to {OUTPUT}")
PYEOF

echo "Done! Results at $OUTPUT_FILE"
