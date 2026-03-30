---
name: pdtf-connector
description: "Connect to any PDTF-compliant MCP server for property transaction data. Use when: listing property transactions, checking transaction status, viewing PDTF state or claims, tracing data provenance, uploading documents, vouching verified data, checking form completion progress, raising or managing enquiries, describing PDTF schema paths, or any interaction with property transaction data. Triggers on: 'transactions', 'property status', 'PDTF state', 'what transactions do I have', 'show me the property', 'claims', 'provenance', 'where did this data come from', 'upload document', 'form progress', 'TA6 completion', 'vouch', 'enquiries', 'raise enquiry', 'respond to enquiry', 'schema', 'describe path'. NOT for: interpreting risk flags or diligence findings (use moverly-diligence). NOT for: risk intelligence, processing queue status, or risk history (use moverly-diligence)."
---

# PDTF Connector

Connect to any Property Data Trust Framework (PDTF) compliant MCP server. The PDTF MCP specification defines a standard protocol for property transaction data — any system that implements it (Moverly, NPTN, or others) can be connected using this skill.

MCP JSON-RPC over Streamable HTTP. PAT auth.

## Setup

- PAT: `~/.openclaw/credentials/moverly-staging-pat` (format: `mvly_pat_<64hex>`)
- Endpoint: `https://api-staging.moverly.com/mcpService/mcp`
- Override with env vars: `MOVERLY_MCP_ENDPOINT`, `MOVERLY_PAT_FILE`
- To connect to a different PDTF-compliant server, set `MOVERLY_MCP_ENDPOINT` to its URL

## Making Calls

All MCP calls go through `scripts/mcp-call.sh`:

```bash
# Initialize session (required first call)
scripts/mcp-call.sh initialize '{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"openclaw","version":"1.0"}}'

# Call a tool
scripts/mcp-call.sh tools/call '{"name":"moverly_list_transactions","arguments":{"status":"all"}}'

# Parse tool result
scripts/mcp-call.sh tools/call '...' | jq -r '.result.content[0].text' | jq .
```

## PDTF Standard Tools (14 tools)

These tools are part of the PDTF MCP specification. Any compliant server implements them.

### Transaction Data

| Tool | Purpose |
|------|---------|
| `list_transactions` | Browse portfolio with readiness data |
| `get_status` | Transaction overview: address, participants, risk summary |
| `get_state` | Full PDTF state — all verified claims composed |
| `get_claims` | Verified claims with provenance (who, when, how verified) |
| `get_provenance` | Trace evidence chain at a specific PDTF path |

### Data Submission

| Tool | Purpose |
|------|---------|
| `vouch` | Submit verified data at a PDTF path (strict schema validation) |
| `upload_document` | Upload a document linked to a PDTF schema location |

### Schema

| Tool | Purpose |
|------|---------|
| `describe_path` | Get strict JSON subschema for any PDTF path |
| `list_overlays` | Available schema overlays |

### Enquiries

| Tool | Purpose |
|------|---------|
| `raise_enquiry` | Raise a pre-contract enquiry |
| `list_enquiries` | List enquiries with status and direction filters |
| `respond_enquiry` | Reply to an enquiry with optional status update |

## Tool Reference

### list_transactions
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_list_transactions","arguments":{"status":"all","limit":20}}'
```
- `status`: For sale | Under offer | Sold subject to contract | active | all (default: all)
- `limit`: default 20, max 100
- Returns: `{transactions: [{id, address, status, callerRole, participants, riskSummary, readiness, updatedAt}], showing, totalAvailable}`
- `readiness` object: ntsCompletion, ta6Completion, ta7Completion, ta10Completion, participantVerification, searchesCollector, idvReports, contractSignature

### get_status
Transaction overview: address, participants, risk summary counts.
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_get_status","arguments":{"transactionId":"<id>"}}'
```

### get_state
Full PDTF state — all verified claims, EPC, flood, planning, title, searches. Large response.
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_get_state","arguments":{"transactionId":"<id>"}}'
```

### get_claims
Get all verified claims with full provenance.
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_get_claims","arguments":{"transactionId":"<id>","path":"/propertyPack/ownership"}}'
```
- `path`: optional PDTF path prefix filter
- `source`: collector | participant | document | all (default: all)
- `since`: ISO timestamp, only claims after this time
- Returns: `{claims: [{timestamp, paths, source, verification: {evidence, trust_framework}}]}`

### get_provenance
Trace the evidence chain for data at a specific path.
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_get_provenance","arguments":{"transactionId":"<id>","path":"/propertyPack/ownership"}}'
```
- `path`: PDTF path to trace (required)
- Returns chronological list of claims with full verification evidence

### vouch
Submit verified data at a PDTF path.
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_vouch","arguments":{"transactionId":"<id>","path":"/propertyPack/specialistIssues/japaneseKnotweed","value":{"hasKnotweed":"Yes","knotweedDetails":"..."}}}'
```
- `transactionId`, `path`, `value`: required
- `overlay`: optional, applies overlay validation
- `confidentialityLevel`: public | restricted (default) | confidential
- ✅ Returns: `{status: "accepted"}` — triggers re-evaluation
- ❌ Returns validation errors with paths

**Schema behaviour:**
- `additionalProperties: false` at every object level
- `discriminator` and `oneOf` for conditional dependencies (Yes → more fields required)
- `required` arrays populated only when overlay specified
- `enum: ["Attached", "To follow", "Not applicable"]` = attachment point

### upload_document
Upload a document linked to a PDTF schema location.
```bash
FILE_B64=$(base64 -w0 document.pdf)
scripts/mcp-call.sh tools/call "{\"name\":\"moverly_upload_document\",\"arguments\":{\"transactionId\":\"<id>\",\"fileContent\":\"${FILE_B64}\",\"fileName\":\"title-register.pdf\",\"pdtfPath\":\"/propertyPack/titlesToBeSold/0/titleRegister/attachments\"}}"
```
- `fileContent`: base64-encoded file (required, max 30MB)
- `fileName`: original filename with extension (required)
- `pdtfPath`: optional, links document to a PDTF schema location (vouch-attributed)
- Returns: `{fileId, fileName, mimeType, sizeBytes, status: "processing"}`

### describe_path
Get the strict JSON subschema at any PDTF path.
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_describe_path","arguments":{"path":"/propertyPack/alterationsAndChanges","overlay":"ta6ed6"}}'
```
- `path`: PDTF schema path starting with / (required)
- `overlay`: optional form overlay (e.g. `ta6ed6`) — adds `required` constraints
- Returns: `{path, title, hierarchy, schema, overlay}`

### raise_enquiry
Raise a pre-contract enquiry.
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_raise_enquiry","arguments":{"transactionId":"<id>","subject":"Loft conversion building regs","messageText":"Please confirm...","destinationRole":"Seller'\''s Conveyancer"}}'
```
- `subject`, `messageText`, `destinationRole`: required
- `relatedFlagId`: optional, links to a risk flag
- `pdtfPath`: optional, hints where response data should be stored

### list_enquiries
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_list_enquiries","arguments":{"transactionId":"<id>","status":"pending","direction":"inbound"}}'
```
- `status`: pending | open | resolved | resolvedWithCondition | withdrawn | all
- `direction`: inbound | outbound | all

### respond_enquiry
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_respond_enquiry","arguments":{"transactionId":"<id>","enquiryId":"<eid>","messageText":"The building regs certificate...","updateStatus":"resolved"}}'
```
- `updateStatus`: open | resolved | resolvedWithCondition (optional)
- `pdtfPath`: optional, hints where structured data should be stored

## Key Workflows

**Describe → Vouch loop:**
1. `describe_path(targetPath)` → get strict schema
2. Collect data following discriminator/oneOf branching
3. `vouch` → validates and submits
4. Verify via `get_state` or `get_claims`

**Document upload with linking:**
1. `upload_document(pdtfPath=targetPath)` → upload linked to schema location
2. `vouch(path=targetPath, value="Attached")` → confirm attachment
3. Verify via `get_state` at targetPath

**Enquiry → Response → Vouch:**
1. `raise_enquiry` with subject and destination role
2. Other party responds via `respond_enquiry`
3. If response includes structured data: `vouch` at the `pdtfPath`

**Provenance check:**
1. `get_claims(path="/some/path")` → see who vouched what, when
2. `get_provenance(path="/some/path")` → full evidence chain

## Error Codes

| Code | Meaning |
|------|---------|
| -32602 | Invalid params (missing required field) |
| -32601 | Tool not yet implemented |
| -32000 | Transaction not found |
| -32001 | Access denied |
| -32003 | Rate limited |
