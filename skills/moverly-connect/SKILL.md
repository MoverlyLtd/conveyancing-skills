---
name: moverly-connect
description: "Connect to Moverly's property intelligence MCP server. Use when: listing property transactions, checking transaction status, viewing PDTF state or claims, tracing data provenance, querying Moverly data, looking up a property address, uploading documents for analysis, checking processing queue status, checking form completion progress, or any interaction with the Moverly platform. Triggers on: 'transactions', 'property status', 'PDTF state', 'Moverly', 'what transactions do I have', 'show me the property', 'claims', 'provenance', 'where did this data come from', 'upload document', 'processing status', 'queue', 'form progress', 'TA6 completion', address lookups. NOT for: interpreting risk flags, explaining diligence findings, or managing enquiries (use moverly-diligence). NOT for: guided multi-document upload workflows (use moverly-upload)."
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

## Tool Inventory (16 live, 3 pending)

| Tool | Status | Purpose |
|------|--------|---------|
| `list_transactions` | ✅ | Browse portfolio |
| `get_status` | ✅ | Transaction overview |
| `get_state` | ✅ | Full PDTF state |
| `get_insights` | ✅ | DE risk flags |
| `get_claims` | ✅ | Verified claims with provenance |
| `get_provenance` | ✅ | Trace data lineage at a path |
| `upload_document` | ✅ | Upload for AI analysis |
| `get_queue` | ✅ | Check processing status |
| `describe_path` | ✅ | Get strict schema for a path |
| `vouch` | ✅ | Submit verified data |
| `get_form_progress` | ✅ | Seller form completion status |
| `describe_form_path` | ✅ | Form-specific schema with question refs |
| `raise_enquiry` | ✅ | Raise pre-contract enquiry |
| `list_enquiries` | ✅ | List enquiries on transaction |
| `respond_enquiry` | ✅ | Reply to an enquiry |
| `handle_flag` | ❌ | Mark flag as accepted/mitigated |
| `get_risk_history` | ❌ | Historical risk timeline |
| `list_overlays` | ❌ | Available schema overlays |
| `download_document` | ❌ | Download file content |

## Core Tools

### moverly_list_transactions
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_list_transactions","arguments":{"status":"all","limit":20}}'
```
- `status`: For sale | Under offer | Sold subject to contract | active | all (default: all)
- `limit`: default 20, max 100
- Returns: `{transactions: [{id, address, status, callerRole, participants, riskSummary, readiness, updatedAt}], showing, totalAvailable}`
- `readiness` object: ntsCompletion, ta6Completion, ta7Completion, ta10Completion, participantVerification, searchesCollector, idvReports, contractSignature

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
- `evidenceBasis`: data-driven | evidence-incomplete | no-data | clear
- `minRisk`: 1-10 (minimum risk score)
- Returns: `{insights: [{category, check, title, riskScore, evidenceBasis, evidencePaths, legalContext, legalDetail, description, actions}], summary: {totalFlags, byRisk, byEvidence}}`

### moverly_get_claims
Get all verified claims with full provenance (who vouched, when, how verified).
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_get_claims","arguments":{"transactionId":"<id>","path":"/propertyPack/ownership"}}'
```
- `path`: optional PDTF path prefix filter
- `source`: collector | participant | document | all (default: all)
- `since`: ISO timestamp, only claims after this time
- Returns: `{claims: [{timestamp, paths, source, verification: {evidence, trust_framework}}]}`

### moverly_get_provenance
Trace the evidence chain for data at a specific path.
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_get_provenance","arguments":{"transactionId":"<id>","path":"/propertyPack/ownership"}}'
```
- `path`: PDTF path to trace (required)
- Returns chronological list of claims that wrote to this path or child paths, with full verification evidence

## Document Tools

### moverly_upload_document
Upload a document for AI-powered analysis. Pipeline: classify → summarise → extract claims → DE re-evaluation.
```bash
FILE_B64=$(base64 -w0 document.pdf)
scripts/mcp-call.sh tools/call "{\"name\":\"moverly_upload_document\",\"arguments\":{\"transactionId\":\"<id>\",\"fileContent\":\"${FILE_B64}\",\"fileName\":\"title-register.pdf\"}}"
```
- `fileContent`: base64-encoded file (required, max 30MB)
- `fileName`: original filename with extension (required)
- `pdtfPath`: optional, links document to a schema location (creates vouch-attributed claim)
- Returns: `{fileId, fileName, mimeType, sizeBytes, status: "processing"}`

### moverly_get_queue
Check processing status after upload.
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_get_queue","arguments":{"transactionId":"<id>"}}'
```
- Returns: `{summary: {totalItems, pending, completed}, pending: [...], recentlyCompleted: [...]}`

## Schema & Vouch Tools

### moverly_describe_path
Get the strict JSON subschema at any PDTF path.
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_describe_path","arguments":{"path":"/propertyPack/alterationsAndChanges","overlay":"ta6ed6"}}'
```
- `path`: PDTF schema path starting with / (required)
- `overlay`: optional form overlay (e.g. `ta6ed6`) — adds `required` constraints
- Returns: `{path, title, hierarchy, schema, overlay}`

**Schema notes:**
- `additionalProperties: false` at every object level
- `discriminator` and `oneOf` for conditional dependencies (Yes → more fields required)
- `required` arrays populated only when overlay specified
- `enum: ["Attached", "To follow", "Not applicable"]` = attachment point

### moverly_vouch
Submit verified data at a PDTF path.
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_vouch","arguments":{"transactionId":"<id>","path":"/propertyPack/specialistIssues/japaneseKnotweed","value":{"hasKnotweed":"Yes","knotweedDetails":"..."}}}'
```
- `transactionId`, `path`, `value`: required
- `overlay`: optional, applies overlay validation
- `confidentialityLevel`: public | restricted (default) | confidential
- ✅ Returns: `{status: "accepted"}` — triggers DE re-evaluation
- ❌ Returns validation errors with paths

## Form Progress Tools (Seller Interview Mode)

### moverly_get_form_progress
Check completion status across all applicable forms.
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_get_form_progress","arguments":{"transactionId":"<id>"}}'
```
Returns per-form completion percentages and per-section status (complete/incomplete/not-started):
- `forms`: [{name, category, percentComplete, overlay, sections: [{name, path, status, validationErrors}]}]
- Categories: listing (NTS), property-questions (TA6), leasehold-questions (TA7), fittings-and-contents (TA10), sale-ready

### moverly_describe_form_path
Get form-specific schema with question reference numbers (e.g. "5.1b").
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_describe_form_path","arguments":{"transactionId":"<id>","path":"/propertyPack/alterationsAndChanges"}}'
```
- Returns schema filtered to overlay-referenced properties only
- Each property annotated with `formRef` (question number like "5.1b")
- Overlay resolved from transaction settings, not agent-chosen

**Seller interview workflow:**
1. `get_form_progress` → find incomplete sections
2. `describe_form_path(transactionId, sectionPath)` → get schema with question refs
3. Walk discriminator/oneOf conversationally ("Did you make any structural alterations?")
4. `vouch` collected data → confirms section
5. `get_form_progress` → verify completion moved

## Enquiry Tools

### moverly_raise_enquiry
Raise a pre-contract enquiry.
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_raise_enquiry","arguments":{"transactionId":"<id>","subject":"Loft conversion building regs","messageText":"Please provide...","destinationRole":"Seller'\''s Conveyancer"}}'
```
- `subject`: topic of enquiry (required)
- `messageText`: enquiry text (required)
- `destinationRole`: Seller | Seller's Conveyancer | Buyer | Buyer's Conveyancer | Estate Agent (required)
- `relatedFlagId`: optional, links to a risk flag
- `pdtfPath`: optional, hints where response data should be stored

### moverly_list_enquiries
List enquiries on a transaction.
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_list_enquiries","arguments":{"transactionId":"<id>","status":"pending","direction":"inbound"}}'
```
- `status`: pending | open | resolved | resolvedWithCondition | withdrawn | all
- `direction`: inbound | outbound | all
- Returns: `{enquiries: [{id, subject, status, originatorRole, destinationRole, messages, createdAt}]}`

### moverly_respond_enquiry
Reply to an enquiry.
```bash
scripts/mcp-call.sh tools/call '{"name":"moverly_respond_enquiry","arguments":{"transactionId":"<id>","enquiryId":"<eid>","messageText":"The building regulations certificate...","updateStatus":"resolved"}}'
```
- `enquiryId`: which enquiry to reply to (required)
- `messageText`: response text (required)
- `updateStatus`: open | resolved | resolvedWithCondition (optional)
- `pdtfPath`: optional, hints where structured data should be stored

## Key Workflows

**Describe → Vouch loop:**
1. `get_insights` → find flag with `evidenceBasis: "evidence-incomplete"` and `targetPath`
2. `describe_path(targetPath)` → get strict schema
3. Collect data following discriminator/oneOf branching
4. `vouch` → validates and submits
5. `get_insights` → verify flag resolved

**Document resolution:**
1. `get_insights` → find flag with `documentTypes` in actions
2. `upload_document(pdtfPath=targetPath)` → upload linked to schema location
3. `get_queue` → wait for processing
4. `vouch(path=targetPath, value="Attached")` → confirm attachment
5. `get_insights` → verify flag resolved

**Provenance check:**
1. `get_insights` → see a data-driven flag
2. Read `evidencePaths` array from the flag
3. `get_provenance(path=evidencePaths[0])` → trace who provided the data, when, how verified

## Error Codes

| Code | Meaning |
|------|---------|
| -32602 | Invalid params (missing required field) |
| -32601 | Tool not yet implemented |
| -32000 | Transaction not found |
| -32001 | Access denied |
| -32003 | Rate limited (1,000 req/hour) |
