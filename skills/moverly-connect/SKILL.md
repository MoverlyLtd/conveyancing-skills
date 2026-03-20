---
name: moverly-connect
description: "Connect to Moverly's property intelligence MCP server. Use when: listing property transactions, checking transaction status, viewing PDTF state or claims, querying Moverly data, looking up a property address, uploading documents for analysis, checking processing queue status, or any interaction with the Moverly platform. Triggers on: 'transactions', 'property status', 'PDTF state', 'Moverly', 'what transactions do I have', 'show me the property', 'claims', 'upload document', 'processing status', 'queue', address lookups. NOT for: interpreting risk flags, explaining diligence findings, or drafting enquiries (use moverly-diligence). NOT for: guided multi-document upload workflows (use moverly-upload)."
---

# Moverly Connect

MCP JSON-RPC over Streamable HTTP. PAT auth.

## Setup

- PAT: `~/.openclaw/credentials/moverly-staging-pat` (format: `mvly_pat_<64hex>`)
- Endpoint: `https://api-staging.moverly.com/mcpService/mcp`
- Override with env vars: `MOVERLY_MCP_ENDPOINT`, `MOVERLY_PAT_FILE`

## Making Calls

All MCP calls go through `scripts/mcp-call.sh`:

```bash
# Initialize session (required first call)
scripts/mcp-call.sh initialize '{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"openclaw","version":"1.0"}}'

# Call a tool
scripts/mcp-call.sh tools/call '{"name":"moverly_list_transactions","arguments":{"status":"all"}}'

# Parse tool result (results are JSON inside JSON-RPC envelope)
scripts/mcp-call.sh tools/call '...' | jq -r '.result.content[0].text' | jq .
```

## Phase 1 Tools (live)

### moverly_list_transactions
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_list_transactions","arguments":{"status":"all","limit":20}}'
```
- `status`: active | completed | all (default: active — note: staging transactions are "For sale" not "active", use "all")
- `limit`: default 20
- Returns: `{transactions: [{id, address, status, callerRole, participants, riskSummary, updatedAt}]}`

### moverly_get_status
Transaction overview: address, participants, risk summary counts.
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_get_status","arguments":{"transactionId":"<id>"}}'
```

### moverly_get_state
Full PDTF state — all verified claims, EPC, flood, planning, title, searches. Large response.
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_get_state","arguments":{"transactionId":"<id>"}}'
```

### moverly_get_insights
Diligence engine flags: 37 categories, 323 checks, 2,215 scenarios.
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_get_insights","arguments":{"transactionId":"<id>","evidenceBasis":"data-driven","minRisk":5}}'
```
- `evidenceBasis`: data-driven | evidence-incomplete | no-data | clear (filter to evidenced flags)
- `minRisk`: 1-10 (minimum risk score)
- Returns: `{insights: [{category, check, title, riskScore, evidenceBasis, description, actions}], summary: {totalFlags, byRisk, byEvidence}}`

## Phase 2 Tools (live)

### moverly_upload_document
Upload a document for AI-powered analysis. Pipeline: classify → summarise → extract claims → DE re-evaluation.
```bash
# Base64-encode a PDF and upload
FILE_B64=$(base64 -w0 document.pdf)
scripts/mcp-call.sh tools/call "{\"name\":\"moverly_upload_document\",\"arguments\":{\"transactionId\":\"<id>\",\"fileContent\":\"${FILE_B64}\",\"fileName\":\"title-register.pdf\"}}"
```
- `fileContent`: base64-encoded file (required, max 30MB)
- `fileName`: original filename with extension (required)
- `mimeType`: optional, inferred from extension if omitted
- `description`: optional, human-readable note
- Returns: `{fileId, fileName, mimeType, sizeBytes, status: "processing"}`

### moverly_get_queue
Check processing status after upload. Poll until pending reaches 0.
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_get_queue","arguments":{"transactionId":"<id>"}}'
```
- Returns: `{summary: {totalItems, pending, completed, classifying, summarising}, pending: [...], recentlyCompleted: [...]}`

### Upload → Insights workflow
1. Upload document → get fileId
2. Poll get_queue until `summary.pending === 0`
3. Call get_insights to see updated risk picture
4. Check `evidenceBasis: "data-driven"` flags for new findings

## Error Codes

| Code | Meaning |
|------|---------|
| -32602 | Invalid params (missing required field) |
| -32601 | Tool not yet implemented |
| -32000 | Transaction not found |
| -32001 | Access denied |
| -32003 | Rate limited (1,000 req/hour) |
