---
name: moverly-diligence
description: "Property risk intelligence, diligence analysis, and enquiry management via Moverly's deterministic engine. Use when: analysing property risks, explaining risk flags, interpreting diligence findings, summarising what needs attention on a transaction, drafting enquiries from flags, raising or responding to pre-contract enquiries, explaining issues in plain English to buyers or sellers, comparing risk across a caseload, identifying what blocks exchange, or monitoring transaction progress. Triggers on: 'risk flags', 'what are the issues', 'any problems', 'diligence', 'risk analysis', 'what needs attention', 'explain this flag', 'draft an enquiry', 'raise an enquiry', 'respond to enquiry', 'check enquiries', 'what's blocking', 'portfolio risk', 'caseload', 'provenance', 'where did this come from'. Requires moverly-connect skill for MCP access."
---

# Moverly Diligence

Interpret risk intelligence from the deterministic diligence engine (37 categories, 323 checks, 2,215 scenarios). Manage pre-contract enquiries. Depends on `moverly-connect` for MCP calls.

## Evidence Basis — the key concept

Every flag has an `evidenceBasis`. Default to showing only evidenced flags:

| Basis | Meaning | Show by default? |
|-------|---------|-----------------|
| `data-driven` | Definitive finding from verified data | ✅ Yes |
| `evidence-incomplete` | Partial data, needs more info | ✅ Yes |
| `no-data` | Nothing available to assess | ❌ Noise |
| `clear` | Checked, no issues | ❌ Unless asked |

## Risk Scores

- 🔴 Critical (9-10): Must resolve before exchange
- 🟠 High (7-8): Significant, may need specialist input
- 🟡 Moderate (4-6): Notable, manageable with action
- 🟢 Low (1-3): Minor or informational

For full category details → read `references/flag-categories.md`.

## Evidence Provenance

Each flag includes provenance fields:

| Field | Purpose |
|-------|---------|
| `evidencePaths` | Array of `{path, label, section}` — PDTF claim paths that contributed to this finding |
| `legalContext` | Check-level legal framework (legislation names, section numbers, thresholds) |
| `legalDetail` | Scenario-specific legal application |
| `rationale` | Step-by-step reasoning chain with `step` and `basis` fields |

When explaining a flag to a user, cite `legalContext` for authoritative legal references. Use `evidencePaths` to show exactly which data drove the finding. Never fabricate legislation or section numbers — only cite what appears in `legalContext`/`legalDetail`.

**Tracing provenance:**
```bash
# Get the evidence paths from a flag, then trace who provided the data
$MCP tools/call '{"name":"moverly_get_provenance","arguments":{"transactionId":"<id>","path":"/propertyPack/ownership/ownershipsToBeTransferred/0/leaseholdInformation"}}'
```
Returns chronological list of claims that wrote to this path: voucher name/organisation, timestamp, verification method (vouch or electronic_record), linked documents.

## Fetching Insights

Use moverly-connect's `mcp-call.sh`:

```bash
MCP=~/.openclaw/skills/moverly-connect/scripts/mcp-call.sh

# Definitive findings
$MCP tools/call '{"name":"moverly_get_insights","arguments":{"transactionId":"<id>","evidenceBasis":"data-driven"}}' | jq -r '.result.content[0].text' | jq .

# Gaps needing follow-up
$MCP tools/call '{"name":"moverly_get_insights","arguments":{"transactionId":"<id>","evidenceBasis":"evidence-incomplete"}}' | jq -r '.result.content[0].text' | jq .

# High-risk only
$MCP tools/call '{"name":"moverly_get_insights","arguments":{"transactionId":"<id>","minRisk":7}}' | jq -r '.result.content[0].text' | jq .
```

Or use the helper: `scripts/get-insights.sh <transactionId> [evidenceBasis] [minRisk]`

## Presenting Flags

Lead with plain English, not category codes. Use severity tags:

> [critical] **Short lease — 68 years remaining** (risk: 10/10)
> Most lenders won't lend below 70-80 years and the value drops significantly. The seller should start a Section 42 lease extension or assign the benefit to the buyer. Must resolve before exchange.
> Source: HMLR title register, DE analysis

For each flag: severity tag + plain description → why it matters → what happens next → who acts (from `canExecute`). Always cite the data source from `evidencePaths`.

## Enquiry Management

Three tools for PDTF-native pre-contract enquiries:

### Raising Enquiries

When a flag suggests raising an enquiry (rather than collecting data directly):

```bash
$MCP tools/call '{"name":"moverly_raise_enquiry","arguments":{
  "transactionId":"<id>",
  "subject":"Loft conversion building regulations",
  "messageText":"Please confirm whether building regulations approval was obtained for the loft conversion. If so, please provide the completion certificate.",
  "destinationRole":"Seller'\''s Conveyancer",
  "relatedFlagId":"flag_abc123",
  "pdtfPath":"/propertyPack/alterationsAndChanges/hasStructuralAlterations"
}}'
```

- `subject`: clear topic (required)
- `messageText`: professional enquiry text (required)
- `destinationRole`: Seller | Seller's Conveyancer | Buyer | Buyer's Conveyancer | Estate Agent (required)
- `relatedFlagId`: links enquiry to the flag that prompted it (optional)
- `pdtfPath`: hints where response data should be stored (optional)

### Checking Enquiries

```bash
# All enquiries on a transaction
$MCP tools/call '{"name":"moverly_list_enquiries","arguments":{"transactionId":"<id>"}}'

# Just pending inbound (need your response)
$MCP tools/call '{"name":"moverly_list_enquiries","arguments":{"transactionId":"<id>","status":"pending","direction":"inbound"}}'

# Just outbound you raised
$MCP tools/call '{"name":"moverly_list_enquiries","arguments":{"transactionId":"<id>","direction":"outbound"}}'
```

Returns: `{enquiries: [{id, subject, status, originatorRole, destinationRole, messages, pdtfPath, createdAt}]}`

Statuses: `pending` (awaiting first response), `open` (in discussion), `resolved`, `resolvedWithCondition`, `withdrawn`

### Responding to Enquiries

```bash
$MCP tools/call '{"name":"moverly_respond_enquiry","arguments":{
  "transactionId":"<id>",
  "enquiryId":"enq_xyz789",
  "messageText":"Building regulations approval was not obtained. The seller is obtaining an indemnity insurance quote.",
  "updateStatus":"open",
  "pdtfPath":"/propertyPack/alterationsAndChanges/hasStructuralAlterations"
}}'
```

- `enquiryId`: which enquiry to respond to (required)
- `messageText`: your response (required)
- `updateStatus`: `open` (still discussing), `resolved` (done), `resolvedWithCondition` (done with caveats)
- `pdtfPath`: where structured data should be stored alongside this reply

**Response + Vouch pattern:**
When responding with structured data, both reply to the enquiry AND vouch the data:
1. `respond_enquiry` with the narrative response
2. `vouch` at the `pdtfPath` with the structured PDTF data
3. This creates a complete audit trail: enquiry → response → verified claim

## Workflow Recipes

**"What needs attention?"**
1. `get_status` → overview + risk summary counts
2. `get_insights` with `evidenceBasis: "data-driven"` → definitive issues
3. `get_insights` with `evidenceBasis: "evidence-incomplete"` → gaps
4. Combine, sort by risk descending, group by theme

**"Explain to a buyer"**
Same as above but translate each flag: what it means for them, what happens next, who handles it. Use `legalContext` for authoritative citations. Never recommend legal action — always "your conveyancer should consider".

**"What's blocking exchange?"**
`get_insights` with `minRisk: 7` → list unresolved actions as a checklist with owners.

**"Compare my caseload"**
`list_transactions` → for each, `get_status` gives `riskSummary` → sort by total risk score.

**"Check for inbound enquiries"**
`list_enquiries(status: "pending", direction: "inbound")` → prioritise by age and risk.

**"Chase outstanding enquiries"**
`list_enquiries(status: "pending", direction: "outbound")` → identify what's waiting for response.

## Resolving Flags — the describe → vouch loop

When a flag has actions with `targetPath`, the agent can collect data and resolve it directly:

1. Read the action's `targetPath` (e.g. `/propertyPack/alterationsAndChanges`)
2. Call `moverly_describe_path` with that path (+ overlay like `ta6ed6` for required fields) → get strict schema
3. The schema uses `discriminator` and `oneOf` for conditional dependencies — the valid shape changes based on answers. When a user says "Yes" to a top-level question (e.g. "Has Japanese knotweed been found?"), new detail fields become required. Collect data step by step, following the schema's branching logic.
4. If any property has `enum: ["Attached", "To follow", "Not applicable"]` and the user has the document, upload it via `moverly_upload_document` with `pdtfPath` first, then set the property to `"Attached"`
5. Call `moverly_vouch` with the collected data → strict validation, no extra properties
6. Call `get_insights` → verify the flag resolved or shifted evidenceBasis

This is the core agentic diligence loop — the agent sees a gap, knows the exact data shape needed, collects it conversationally from the user, validates, submits, and confirms resolution.

## Resolving Flags — the document resolution loop

When a flag action specifies `documentTypes` (acceptable document types) alongside `targetPath`:

1. `get_insights` → identify the flag action with `documentTypes` and `targetPath`
2. `describe_path(targetPath)` → understand what the attachments field expects
3. `upload_document(pdtfPath=targetPath)` → upload the file, linked to the schema location
4. `get_queue` → wait for classification + summarisation to complete
5. `vouch(path=targetPath, value="Attached")` → confirm the attachment
6. `get_insights` → verify the flag resolved

**If the uploaded document type doesn't match** what the flag requires (e.g. uploaded a survey when a building regs certificate was needed), the scenario won't change — the flag persists. Upload the correct document type.

**Linking unlinked documents:** Documents uploaded without `pdtfPath` sit in `/propertyPack/documents[]` unlinked. Check their classified `documentType` via `get_state` at `/propertyPack/documents`, match against outstanding flag actions needing that type, and vouch the `pdtfPath` on the document to link it. An agent can do this proactively to tidy up bulk uploads.

**Structured extraction bonus:** For documents like title registers, EPCs, and search reports, the summariser automatically extracts structured data and pushes it as verified claims. This happens in the background — it may resolve additional flags beyond the one that prompted the upload.

## When to Raise Enquiries vs Vouch Directly

| Situation | Action |
|-----------|--------|
| You have the data/document | `vouch` directly (faster, immediate resolution) |
| You need data from another party | `raise_enquiry` (formal request, audit trail) |
| Seller needs to provide info | `raise_enquiry` to Seller's Conveyancer |
| Response will include structured data | `respond_enquiry` + `vouch` at `pdtfPath` |
| Flag action says "raise enquiry" | Use `raise_enquiry` with `relatedFlagId` |
| Flag action says "collect data" | Use describe → vouch loop |
