# MCP API Reference

## Connection

- **Endpoint:** `https://api-staging.moverly.com/mcpService/mcp` (Moverly staging)
- **Transport:** Streamable HTTP (MCP 2025-06-18 spec)
- **Auth:** Bearer token with PAT (`mvly_pat_...`)
- For other PDTF-compliant servers, set endpoint and auth per their documentation

## PDTF Standard Tools

These tools are defined by the PDTF MCP specification. Any compliant server implements them.

### Transaction Data

#### `moverly_list_transactions`

List transactions accessible to your account.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| status | string | No | Filter: "active" (non-cancelled, default), "For sale", "Under offer", "Sold subject to contract", "Completed", "Cancelled", "all" |
| limit | integer | No | Max results (default 20, max 100) |

Returns: transactions with address, status, participants, riskSummary, readiness (form completion, searches, IDV status), showing/totalAvailable counts.

#### `moverly_get_state`

Get the composed PDTF state — the current view of all verified data.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| transactionId | string | Yes | Transaction ID |

Returns: full PDTF state object filtered by your role's access level.

#### `moverly_get_status`

Quick status overview of a transaction.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| transactionId | string | Yes | Transaction ID |

Returns: address, status, callerRole, riskSummary, participants.

#### `moverly_get_claims`

Get verified claims with full provenance.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| transactionId | string | Yes | Transaction ID |
| path | string | No | PDTF path prefix filter |
| source | string | No | Filter: "collector", "participant", "document", "all" (default) |
| since | string | No | ISO datetime — only claims after this time |

Returns: array of claims with verification evidence (trust framework, voucher identity, electronic record sources, attachments).

#### `moverly_get_provenance`

Trace the evidence chain for a specific PDTF path.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| transactionId | string | Yes | Transaction ID |
| path | string | Yes | PDTF path to trace |

Returns: chronological list of claims affecting that path with full provenance.

---

### Data Submission

#### `moverly_vouch`

Submit verified data at a PDTF path.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| transactionId | string | Yes | Transaction ID |
| path | string | Yes | PDTF path |
| data | object | Yes | Data conforming to the schema at that path |

Validates against PDTF schema with strict `additionalProperties: false`. Returns detailed validation errors on failure. Use `describe_path` first to understand the expected shape.

#### `moverly_upload_document`

Upload a document linked to a PDTF schema location.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| transactionId | string | Yes | Transaction ID |
| fileContent | string | Yes | Base64-encoded file content |
| fileName | string | Yes | File name with extension |
| mimeType | string | No | MIME type |
| pdtfPath | string | No | PDTF schema path for document linking |
| description | string | No | Description |

---

### Schema

#### `moverly_describe_path`

Get the PDTF subschema at any path.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| path | string | Yes | PDTF path |

Returns: strict schema with `additionalProperties: false` at every level. Includes discriminator/oneOf for conditional dependencies.

#### `moverly_describe_form_path`

Get form-specific schema with question reference numbers.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| transactionId | string | Yes | Transaction ID |
| path | string | Yes | PDTF path for the form section |

Returns: schema filtered to overlay-referenced properties with formRef annotations (e.g. "5.1b").

#### `moverly_list_overlays`

List available PDTF schema overlays.

---

### Forms

#### `moverly_get_form_progress`

Get completion status for all applicable property information forms.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| transactionId | string | Yes | Transaction ID |

Returns: per-form completion percentage, overlay, per-section status (complete/incomplete/not-started).

---

### Enquiries

#### `moverly_raise_enquiry`

Raise a new enquiry, optionally linked to a risk flag.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| transactionId | string | Yes | Transaction ID |
| subject | string | Yes | Enquiry subject |
| messageText | string | Yes | Enquiry message |
| destinationRole | string | Yes | Target role (e.g. "Seller's Conveyancer") |
| relatedFlagId | string | No | Link to a specific risk flag |
| pdtfPath | string | No | PDTF path hint for where resolution data should go |

#### `moverly_list_enquiries`

List enquiries for a transaction.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| transactionId | string | Yes | Transaction ID |
| status | string | No | Filter: "pending", "open", "resolved", "all" |
| direction | string | No | "raised" or "received" |

#### `moverly_respond_enquiry`

Respond to an existing enquiry.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| transactionId | string | Yes | Transaction ID |
| enquiryKey | string | Yes | Enquiry ID |
| messageText | string | Yes | Response message |
| status | string | No | Update: "open", "resolved", "resolvedWithCondition" |
| resolutionCondition | string | No | Condition text |
| pdtfPath | string | No | PDTF path hint |

---

## Moverly Intelligence Tools

These tools are proprietary to Moverly's MCP server.

### `moverly_get_insights`

Get Diligence Engine risk analysis — flags with evidence trails and recommended actions.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| transactionId | string | Yes | Transaction ID |
| minRisk | integer | No | Minimum risk score (1-10) |
| evidenceBasis | string | No | Filter: "data-driven", "evidence-incomplete", "no-data", "clear" |

Returns per flag: category, check, scenario, riskScore, evidenceBasis, rationale, legalContext, evidencePaths, actions (with targetPath).

**Evidence basis:**
- `data-driven` — Definitive finding from verified data
- `evidence-incomplete` — Partial data, needs more info
- `no-data` — Nothing available to evaluate
- `clear` — Checked, no issues

### `moverly_get_queue`

Check document processing and collector pipeline status.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| transactionId | string | Yes | Transaction ID |

Returns: processing items grouped by state, classification and summarisation progress.

### `moverly_get_risk_history`

Historical risk timeline for a transaction.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| transactionId | string | Yes | Transaction ID |

### `moverly_handle_flag`

Manage a risk flag.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| transactionId | string | Yes | Transaction ID |
| flagId | string | Yes | Flag ID |
| action | string | Yes | Action to take |

---

## Error codes

| Code | Meaning |
|------|---------|
| -32600 | Invalid request |
| -32601 | Tool not found / not yet implemented |
| -32602 | Invalid parameters |
| -32000 | Transaction not found |
| -32001 | Access denied |
| -32002 | Schema validation failed (vouch) |
| -32003 | Rate limited |
