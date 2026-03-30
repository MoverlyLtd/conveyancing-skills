#!/usr/bin/env bash
# MCP JSON-RPC call helper for PDTF-compliant MCP servers
# Usage: mcp-call.sh <method> [params_json]
set -euo pipefail

PAT_FILE="${MOVERLY_PAT_FILE:-$HOME/.openclaw/credentials/moverly-staging-pat}"
ENDPOINT="${MOVERLY_MCP_ENDPOINT:-https://api-staging.moverly.com/mcpService/mcp}"

if [ ! -f "$PAT_FILE" ]; then
  echo "Error: PAT file not found at $PAT_FILE" >&2
  echo "Set MOVERLY_PAT_FILE or place token at default path" >&2
  exit 1
fi

PAT=$(cat "$PAT_FILE")
METHOD="${1:?Usage: mcp-call.sh <method> [params_json]}"

if [ $# -ge 2 ]; then
  PARAMS="$2"
else
  PARAMS='{}'
fi

cat <<JSONRPC | curl -s -X POST "$ENDPOINT" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $PAT" \
  -d @-
{"jsonrpc":"2.0","id":1,"method":"$METHOD","params":$PARAMS}
JSONRPC
