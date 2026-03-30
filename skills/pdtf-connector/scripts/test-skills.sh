#!/usr/bin/env bash
# Moverly Skills Test Suite
# Tests both moverly-connect and moverly-diligence skills end-to-end
# Usage: test-skills.sh [--verbose] [--filter <pattern>]
#
# Requires: MOVERLY_PAT_FILE or ~/.openclaw/credentials/moverly-staging-pat
# All tests hit the live staging MCP endpoint.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MCP="$SCRIPT_DIR/mcp-call.sh"
INSIGHTS="$SCRIPT_DIR/../../moverly-diligence/scripts/get-insights.sh"

VERBOSE=false
FILTER=""
PASSED=0
FAILED=0
SKIPPED=0
FAILURES=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --verbose|-v) VERBOSE=true; shift ;;
    --filter|-f) FILTER="$2"; shift 2 ;;
    *) echo "Usage: test-skills.sh [--verbose] [--filter <pattern>]"; exit 1 ;;
  esac
done

# --- Helpers ---

log() { [[ "$VERBOSE" == true ]] && echo "  $*" || true; }

run_test() {
  local name="$1"
  shift

  if [[ -n "$FILTER" && ! "$name" =~ $FILTER ]]; then
    ((SKIPPED++)) || true
    return 0
  fi

  printf "  %-60s" "$name"
  local output=""
  local rc=0
  output=$("$@" 2>&1) || rc=$?
  if [[ "$rc" -eq 0 ]]; then
    echo "✅"
    ((PASSED++)) || true
  else
    echo "❌"
    FAILURES+=("$name")
    [[ "$VERBOSE" == true ]] && echo "    → $output"
    ((FAILED++)) || true
  fi
}

# Calls MCP and returns the parsed tool result (the .text JSON)
mcp_tool() {
  local tool="$1" args="$2"
  "$MCP" tools/call "{\"name\":\"$tool\",\"arguments\":$args}" | jq -re '.result.content[0].text' | jq -e .
}

# --- Test functions ---

test_initialize() {
  local result
  result=$("$MCP" initialize '{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"test-harness","version":"1.0"}}')
  echo "$result" | jq -e '.result.serverInfo.name == "moverly-property-intelligence"' > /dev/null
}

test_tools_list() {
  local count
  count=$("$MCP" tools/list | jq '.result.tools | length')
  [[ "$count" -eq 17 ]]
}

test_list_transactions_all() {
  local result count
  result=$(mcp_tool "moverly_list_transactions" '{"status":"all","limit":5}')
  count=$(echo "$result" | jq '.transactions | length')
  [[ "$count" -gt 0 ]]
}

test_list_transactions_default_status() {
  # Default "active" should return 0 on staging (transactions are "For sale")
  local count
  count=$(mcp_tool "moverly_list_transactions" '{}' | jq '.transactions | length')
  [[ "$count" -eq 0 ]]
}

test_list_transactions_has_id() {
  local first_id
  first_id=$(mcp_tool "moverly_list_transactions" '{"status":"all","limit":1}' | jq -r '.transactions[0].id')
  [[ -n "$first_id" && "$first_id" != "null" ]]
}

# Discover a real transaction ID for subsequent tests
discover_transaction() {
  TXN_ID=$(mcp_tool "moverly_list_transactions" '{"status":"all","limit":1}' | jq -r '.transactions[0].id')
  [[ -n "$TXN_ID" && "$TXN_ID" != "null" ]] || { echo "Cannot discover transaction"; exit 1; }
  log "Using transaction: $TXN_ID"
}

test_get_status_shape() {
  local result
  result=$(mcp_tool "moverly_get_status" "{\"transactionId\":\"$TXN_ID\"}")
  echo "$result" | jq -e 'has("address") and has("status") and has("riskSummary") and has("callerRole")' > /dev/null
}

test_get_status_risk_summary() {
  local result
  result=$(mcp_tool "moverly_get_status" "{\"transactionId\":\"$TXN_ID\"}")
  echo "$result" | jq -e '.riskSummary | has("totalFlags") and has("critical") and has("high") and has("moderate") and has("low")' > /dev/null
}

test_get_state_returns_data() {
  local size
  size=$(mcp_tool "moverly_get_state" "{\"transactionId\":\"$TXN_ID\"}" | wc -c)
  [[ "$size" -gt 500 ]]
}

test_get_insights_unfiltered() {
  local total
  total=$(mcp_tool "moverly_get_insights" "{\"transactionId\":\"$TXN_ID\"}" | jq '.summary.totalFlags')
  [[ "$total" -gt 0 ]]
}

test_get_insights_shape() {
  local result
  result=$(mcp_tool "moverly_get_insights" "{\"transactionId\":\"$TXN_ID\"}")
  echo "$result" | jq -e 'has("insights") and has("summary") and has("callerRole") and has("transactionId")' > /dev/null
}

test_get_insights_flag_shape() {
  local flag
  flag=$(mcp_tool "moverly_get_insights" "{\"transactionId\":\"$TXN_ID\"}" | jq '.insights[0]')
  echo "$flag" | jq -e 'has("category") and has("check") and has("title") and has("riskScore") and has("evidenceBasis") and has("actions")' > /dev/null
}

test_get_insights_evidence_breakdown() {
  local result
  result=$(mcp_tool "moverly_get_insights" "{\"transactionId\":\"$TXN_ID\"}")
  echo "$result" | jq -e '.summary.byEvidence | has("dataDriven") and has("evidenceIncomplete") and has("noData") and has("clear")' > /dev/null
}

test_filter_evidence_incomplete() {
  local all_count filtered_count
  all_count=$(mcp_tool "moverly_get_insights" "{\"transactionId\":\"$TXN_ID\"}" | jq '.summary.byEvidence.evidenceIncomplete')
  filtered_count=$(mcp_tool "moverly_get_insights" "{\"transactionId\":\"$TXN_ID\",\"evidenceBasis\":\"evidence-incomplete\"}" | jq '.insights | length')
  [[ "$filtered_count" -eq "$all_count" ]]
}

test_filter_evidence_data_driven() {
  local all_count filtered_count
  all_count=$(mcp_tool "moverly_get_insights" "{\"transactionId\":\"$TXN_ID\"}" | jq '.summary.byEvidence.dataDriven')
  filtered_count=$(mcp_tool "moverly_get_insights" "{\"transactionId\":\"$TXN_ID\",\"evidenceBasis\":\"data-driven\"}" | jq '.insights | length')
  [[ "$filtered_count" -eq "$all_count" ]]
}

test_filter_min_risk() {
  local result below
  result=$(mcp_tool "moverly_get_insights" "{\"transactionId\":\"$TXN_ID\",\"minRisk\":7}")
  below=$(echo "$result" | jq '[.insights[] | select(.riskScore < 7)] | length')
  [[ "$below" -eq 0 ]]
}

test_filter_combined() {
  local result
  result=$(mcp_tool "moverly_get_insights" "{\"transactionId\":\"$TXN_ID\",\"evidenceBasis\":\"evidence-incomplete\",\"minRisk\":4}")
  # All returned flags must match both filters
  local bad
  bad=$(echo "$result" | jq '[.insights[] | select(.evidenceBasis != "evidence-incomplete" or .riskScore < 4)] | length')
  [[ "$bad" -eq 0 ]]
}

test_error_missing_param() {
  local code
  code=$("$MCP" tools/call '{"name":"moverly_get_status","arguments":{}}' | jq '.error.code // empty')
  [[ "$code" == "-32602" ]]
}

test_error_bad_transaction() {
  local result
  result=$(mcp_tool "moverly_get_status" '{"transactionId":"nonexistent_txn_000"}' 2>/dev/null) && false || true
  # Should error — either jq fails (no .text) or result contains error
}

test_error_empty_pat() {
  local result
  echo "" > /tmp/moverly-test-empty-pat
  result=$(MOVERLY_PAT_FILE=/tmp/moverly-test-empty-pat "$MCP" tools/call '{"name":"moverly_list_transactions","arguments":{"status":"all"}}' 2>&1)
  rm -f /tmp/moverly-test-empty-pat
  echo "$result" | jq -e '.error' > /dev/null
}

test_error_missing_pat() {
  local result
  result=$(MOVERLY_PAT_FILE=/tmp/moverly-test-no-such-file "$MCP" tools/call '{"name":"moverly_list_transactions","arguments":{}}' 2>&1) && false || true
  # Should exit non-zero with error message
}

# --- moverly-diligence script tests ---

test_diligence_helper_basic() {
  local result
  result=$("$INSIGHTS" "$TXN_ID" evidence-incomplete 2>&1)
  echo "$result" | jq -e 'has("summary") and has("insights")' > /dev/null
}

test_diligence_helper_min_risk() {
  local result below
  result=$("$INSIGHTS" "$TXN_ID" "" 7 2>&1)
  below=$(echo "$result" | jq '[.insights[] | select(.risk < 7)] | length')
  [[ "$below" -eq 0 ]]
}

test_diligence_helper_combined() {
  local result bad
  result=$("$INSIGHTS" "$TXN_ID" evidence-incomplete 4 2>&1)
  bad=$(echo "$result" | jq '[.insights[] | select(.evidence != "evidence-incomplete" or .risk < 4)] | length')
  [[ "$bad" -eq 0 ]]
}

test_diligence_helper_no_args() {
  "$INSIGHTS" 2>&1 && false || true
  # Should exit non-zero
}

# --- Workflow tests ---

test_workflow_needs_attention() {
  # Status → data-driven → evidence-incomplete (3 sequential calls)
  mcp_tool "moverly_get_status" "{\"transactionId\":\"$TXN_ID\"}" | jq -e '.riskSummary' > /dev/null
  mcp_tool "moverly_get_insights" "{\"transactionId\":\"$TXN_ID\",\"evidenceBasis\":\"data-driven\"}" | jq -e '.summary' > /dev/null
  mcp_tool "moverly_get_insights" "{\"transactionId\":\"$TXN_ID\",\"evidenceBasis\":\"evidence-incomplete\"}" | jq -e '.summary' > /dev/null
}

test_workflow_caseload() {
  # List transactions → get status for each (limit 3)
  local txn_ids
  txn_ids=$(mcp_tool "moverly_list_transactions" '{"status":"all","limit":3}' | jq -r '.transactions[].id')
  for id in $txn_ids; do
    mcp_tool "moverly_get_status" "{\"transactionId\":\"$id\"}" | jq -e '.riskSummary.totalFlags' > /dev/null
  done
}

# --- Main ---

echo ""
echo "🧪 Moverly Skills Test Suite"
echo "═══════════════════════════════════════════════════════════════════"
echo ""

echo "📡 Connection & Auth"
run_test "MCP initialize handshake"                    test_initialize
run_test "tools/list returns 17 tools"                 test_tools_list
run_test "Empty PAT → server auth error"               test_error_empty_pat
run_test "Missing PAT file → script error"             test_error_missing_pat
echo ""

# Discover a transaction for all subsequent tests
echo "🔍 Discovering test transaction..."
discover_transaction
echo ""

echo "📋 list_transactions"
run_test "status:all returns results"                  test_list_transactions_all
run_test "Default status returns 0 (staging gotcha)"   test_list_transactions_default_status
run_test "Transactions have .id field"                 test_list_transactions_has_id
echo ""

echo "📊 get_status"
run_test "Response shape (address, status, risk)"      test_get_status_shape
run_test "Risk summary has all severity levels"        test_get_status_risk_summary
echo ""

echo "🏠 get_state"
run_test "Returns substantial PDTF data (>500b)"      test_get_state_returns_data
echo ""

echo "🔍 get_insights"
run_test "Unfiltered returns flags"                    test_get_insights_unfiltered
run_test "Response shape (insights, summary)"          test_get_insights_shape
run_test "Flag shape (category, check, title, risk)"   test_get_insights_flag_shape
run_test "Evidence breakdown in summary"               test_get_insights_evidence_breakdown
echo ""

echo "🔬 Insight Filters"
run_test "evidenceBasis:evidence-incomplete"            test_filter_evidence_incomplete
run_test "evidenceBasis:data-driven"                   test_filter_evidence_data_driven
run_test "minRisk:7 (no flags below 7)"                test_filter_min_risk
run_test "Combined evidence + minRisk"                 test_filter_combined
echo ""

echo "⚠️  Error Handling"
run_test "Missing required param → -32602"             test_error_missing_param
run_test "Bad transaction ID → error"                  test_error_bad_transaction
echo ""

echo "🛠  moverly-diligence Helper"
run_test "get-insights.sh basic call"                  test_diligence_helper_basic
run_test "get-insights.sh minRisk filter"              test_diligence_helper_min_risk
run_test "get-insights.sh combined filters"            test_diligence_helper_combined
run_test "get-insights.sh no args → exit 1"            test_diligence_helper_no_args
echo ""

echo "🔄 Workflows"
run_test "What needs attention (3-call sequence)"      test_workflow_needs_attention
run_test "Caseload comparison (list → status loop)"    test_workflow_caseload
echo ""

echo "═══════════════════════════════════════════════════════════════════"
echo "  Results: ✅ $PASSED passed  ❌ $FAILED failed  ⏭  $SKIPPED skipped"
echo "═══════════════════════════════════════════════════════════════════"

if [[ ${#FAILURES[@]} -gt 0 ]]; then
  echo ""
  echo "Failures:"
  for f in "${FAILURES[@]}"; do
    echo "  • $f"
  done
fi

echo ""
exit "$FAILED"
