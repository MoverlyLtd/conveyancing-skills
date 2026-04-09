#!/bin/bash
# Run PDTF path resolver evals using Anthropic API directly
source ~/.bashrc 2>/dev/null || true
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
EVALS_FILE="$SCRIPT_DIR/path-resolver-evals.json"
SKILL_DIR="$SCRIPT_DIR/../pdtf-path-resolver"
RESULTS_DIR="$SCRIPT_DIR/path-resolver-results"
mkdir -p "$RESULTS_DIR"

SKELETON=$(cat "$SKILL_DIR/references/schema-skeleton.md")
SKILL=$(cat "$SKILL_DIR/SKILL.md")

SYSTEM_WITH="You are a PDTF path resolver. Given a document or data subject, return the exact PDTF schema path where it belongs. Be as specific as possible — always target the deepest applicable path (e.g. the /attachments sub-path for documents). Return ONLY the path, nothing else.

$SKILL

---

$SKELETON"

SYSTEM_WITHOUT="You are a property data expert familiar with UK residential conveyancing. Given a document or data subject, suggest the most logical schema path where this data would be stored in a structured property transaction schema called PDTF. Use forward-slash notation like /propertyPack/section/subsection/field. Be as specific as possible. Return ONLY the path, nothing else."

call_anthropic() {
    local model="$1"
    local system="$2"
    local user_msg="$3"

    local payload
    payload=$(jq -n \
        --arg model "$model" \
        --arg system "$system" \
        --arg user "$user_msg" \
        '{model: $model, max_tokens: 300, system: $system, messages: [{role: "user", content: $user}]}')

    local response
    response=$(curl -sS https://api.anthropic.com/v1/messages \
        -H "x-api-key: $ANTHROPIC_API_KEY" \
        -H "anthropic-version: 2023-06-01" \
        -H "content-type: application/json" \
        -d "$payload")

    # Prefer content, otherwise surface the API error message for debugging
    echo "$response" | jq -r '.content[0].text // .error.message // "ERROR"'
}

call_openai() {
    local model="$1"
    local system="$2"
    local user_msg="$3"
    
    local payload
    payload=$(jq -n \
        --arg model "$model" \
        --arg system "$system" \
        --arg user "$user_msg" \
        '{model: $model, max_completion_tokens: 300, messages: [{role: "system", content: $system}, {role: "user", content: $user}]}')
    
    local response
    response=$(curl -s https://api.openai.com/v1/chat/completions \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -H "content-type: application/json" \
        -d "$payload")
    
    echo "$response" | jq -r '.choices[0].message.content // "ERROR"'
}

check_path() {
    local response="$1"
    local expected="$2"
    
    # Strip array notation and normalise
    local norm_expected="${expected//\[\]/}"
    norm_expected="${norm_expected//\/\//\/}"  # collapse double slashes
    
    # Strip backticks from response for matching
    local clean_response
    clean_response=$(echo "$response" | tr -d '\`' | tr '\n' ' ')
    
    # Try exact expected (with [] if present)
    if echo "$clean_response" | grep -qF "$expected"; then
        echo "1"
        return
    fi
    
    # Try normalised (without [])
    if echo "$clean_response" | grep -qF "$norm_expected"; then
        echo "1"
        return
    fi
    
    echo "0"
}

run_model() {
    local model_key="$1"
    local provider="$2"
    local model_id="$3"
    
    local with_correct=0
    local without_correct=0
    local total=0
    local failures=""
    
    local num_evals
    num_evals=$(jq length "$EVALS_FILE")
    
    for i in $(seq 0 $((num_evals - 1))); do
        local eval_id eval_input eval_expected
        eval_id=$(jq -r ".[$i].id" "$EVALS_FILE")
        eval_input=$(jq -r ".[$i].input" "$EVALS_FILE")
        eval_expected=$(jq -r ".[$i].expected" "$EVALS_FILE")
        total=$((total + 1))
        
        # Check cache
        local cache_with="$RESULTS_DIR/${model_key}_${eval_id}_with.txt"
        local cache_without="$RESULTS_DIR/${model_key}_${eval_id}_without.txt"
        
        # WITH skill
        if [ -f "$cache_with" ]; then
            response_with=$(cat "$cache_with")
        else
            if [ "$provider" = "anthropic" ]; then
                response_with=$(call_anthropic "$model_id" "$SYSTEM_WITH" "$eval_input")
            else
                response_with=$(call_openai "$model_id" "$SYSTEM_WITH" "$eval_input")
            fi
            echo "$response_with" > "$cache_with"
            sleep 1.2
        fi
        
        # WITHOUT skill
        if [ -f "$cache_without" ]; then
            response_without=$(cat "$cache_without")
        else
            if [ "$provider" = "anthropic" ]; then
                response_without=$(call_anthropic "$model_id" "$SYSTEM_WITHOUT" "$eval_input")
            else
                response_without=$(call_openai "$model_id" "$SYSTEM_WITHOUT" "$eval_input")
            fi
            echo "$response_without" > "$cache_without"
            sleep 1.2
        fi
        
        local correct_with correct_without
        correct_with=$(check_path "$response_with" "$eval_expected")
        correct_without=$(check_path "$response_without" "$eval_expected")
        
        with_correct=$((with_correct + correct_with))
        without_correct=$((without_correct + correct_without))
        
        local mark_w mark_wo
        [ "$correct_with" = "1" ] && mark_w="✅" || mark_w="❌"
        [ "$correct_without" = "1" ] && mark_wo="✅" || mark_wo="❌"
        
        echo "  $eval_id: with=$mark_w without=$mark_wo"
        
        if [ "$correct_with" = "0" ]; then
            failures="$failures\n  $eval_id: expected $eval_expected"
            failures="$failures\n           got: $(echo "$response_with" | head -1 | cut -c1-120)"
        fi
    done
    
    local delta=$((with_correct - without_correct))
    echo ""
    echo "$model_key: with=$with_correct/$total ($(( 100 * with_correct / total ))%) | without=$without_correct/$total ($(( 100 * without_correct / total ))%) | delta=+$delta"
    
    if [ -n "$failures" ]; then
        echo -e "Failures with skill:$failures"
    fi
    echo ""
}

echo "PDTF Path Resolver Eval"
echo "======================="
echo "40 evals across $(jq length "$EVALS_FILE") test cases"
echo ""

# Default: run sonnet
MODEL="${1:-sonnet}"

case "$MODEL" in
    sonnet) run_model "sonnet" "anthropic" "claude-sonnet-4-20250514" ;;
    haiku)  run_model "haiku" "anthropic" "claude-3-haiku-20240307" ;;
    gpt54m) run_model "gpt54m" "openai" "gpt-5.4-mini" ;;
    all)
        run_model "sonnet" "anthropic" "claude-sonnet-4-20250514"
        run_model "haiku" "anthropic" "claude-3-haiku-20240307"
        run_model "gpt54m" "openai" "gpt-5.4-mini"
        ;;
    *) echo "Usage: $0 [sonnet|haiku|gpt54m|all]" ;;
esac
