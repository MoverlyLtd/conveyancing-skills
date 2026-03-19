#!/usr/bin/env bash
# MCP JSON-RPC call to Moverly staging endpoint
# Usage: mcp-call.sh <method> [params_json]
# Example: mcp-call.sh tools/call '{"name":"moverly_list_transactions","arguments":{"status":"all"}}'

set -euo pipefail

ENDPOINT="${MOVERLY_MCP_ENDPOINT:-https://api-staging.moverly.com/mcpService/mcp}"
PAT_FILE="${MOVERLY_PAT_FILE:-$HOME/.openclaw/credentials/moverly-staging-pat}"

if [[ ! -f "$PAT_FILE" ]]; then
  echo "Error: PAT file not found at $PAT_FILE" >&2
  echo "Generate a token from My Account → API Access, save to $PAT_FILE" >&2
  exit 1
fi

PAT=$(cat "$PAT_FILE")
METHOD="${1:?Usage: mcp-call.sh <method> [params_json]}"
DEFAULT_PARAMS='{}'
PARAMS="${2:-$DEFAULT_PARAMS}"

# Build JSON body safely via jq to avoid shell escaping issues
BODY=$(printf '%s' "$PARAMS" | jq -c --arg method "$METHOD" \
  '{"jsonrpc":"2.0","method":$method,"params":.,"id":1}')

curl -s -X POST "$ENDPOINT" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $PAT" \
  -H "Accept: application/json" \
  -d "$BODY"
