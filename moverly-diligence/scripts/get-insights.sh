#!/usr/bin/env bash
# Get evidenced diligence insights for a transaction
# Usage: get-insights.sh <transactionId> [evidenceBasis] [minRisk]
# Example: get-insights.sh P5hk6QfHhm8D3MgxySdpeM evidence-incomplete
# Example: get-insights.sh P5hk6QfHhm8D3MgxySdpeM evidence-incomplete 5

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MCP="$SCRIPT_DIR/../../moverly-connect/scripts/mcp-call.sh"

if [[ ! -x "$MCP" ]]; then
  echo "Error: moverly-connect skill not found at $MCP" >&2
  echo "Install moverly-connect skill first." >&2
  exit 1
fi

TXN_ID="${1:?Usage: get-insights.sh <transactionId> [evidenceBasis] [minRisk]}"
EVIDENCE="${2:-}"
MIN_RISK="${3:-}"

# Build arguments
ARGS="{\"transactionId\":\"$TXN_ID\""
[[ -n "$EVIDENCE" ]] && ARGS="$ARGS,\"evidenceBasis\":\"$EVIDENCE\""
[[ -n "$MIN_RISK" ]] && ARGS="$ARGS,\"minRisk\":$MIN_RISK"
ARGS="$ARGS}"

RESULT=$("$MCP" tools/call "{\"name\":\"moverly_get_insights\",\"arguments\":$ARGS}")

# Parse and format
echo "$RESULT" | jq -r '.result.content[0].text' | jq '
  {
    summary,
    insights: [.insights[] | {
      category,
      check,
      title,
      risk: .riskScore,
      evidence: .evidenceBasis,
      description: (.description // .rationale | .[:120]),
      actions: (.actions | length)
    }] | sort_by(-.risk)
  }
'
