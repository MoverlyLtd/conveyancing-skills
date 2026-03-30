---
name: moverly-diligence
description: "Moverly's proprietary property risk intelligence — deterministic diligence engine analysis, document processing status, and risk management. Use when: analysing property risks, explaining risk flags, interpreting diligence findings, summarising what needs attention, checking document processing status, viewing risk history, handling or resolving flags, explaining issues in plain English, comparing risk across a caseload, identifying what blocks exchange. Triggers on: 'risk flags', 'what are the issues', 'any problems', 'diligence', 'risk analysis', 'what needs attention', 'explain this flag', 'what's blocking', 'portfolio risk', 'caseload', 'processing status', 'queue', 'risk history'. Requires pdtf-connector skill for MCP access."
---

# Moverly Diligence

Moverly's proprietary risk intelligence layer. The deterministic diligence engine evaluates property risk across 37 categories, 323 checks, 2,215 scenarios — deterministic, auditable, with full evidence provenance. This skill covers the Moverly-specific tools that sit on top of the PDTF standard data layer.

Depends on `pdtf-connector` for MCP transport.

## Moverly Intelligence Tools (5 tools)

| Tool | Purpose |
|------|---------|
| `get_insights` | Diligence engine risk flags with rationale and actions |
| `get_queue` | Document processing pipeline status (classification, summarisation) |
| `get_risk_history` | Historical risk timeline for a transaction |
| `handle_flag` | Mark a flag as accepted, mitigated, or escalated |
| `get_form_progress` | Seller form completion status across all categories (flag-based) |
| `describe_form_path` | Form-specific schema with question refs, filtered by transaction overlay |
| Report on Title | Generated from DE flags + PDTF state (see report-on-title skill) |

## Evidence Basis — the key concept

Every flag has an `evidenceBasis`. Default to showing only evidenced flags:

| Basis | Meaning | Show by default? |
|-------|---------|-----------------|
| `data-driven` | Definitive finding from verified data | ✅ Yes |
| `evidence-incomplete` | Partial data, needs more info | ✅ Yes |
| `no-data` | Nothing available to assess | ❌ Noise |
| `clear` | Checked, no issues | ❌ Unless asked |

## Risk Scores

- [critical] (9-10): Must resolve before exchange
- [high] (7-8): Significant, may need specialist input
- [moderate] (4-6): Notable, manageable with action
- [low] (1-3): Minor or informational

For full category details → read `references/flag-categories.md`.

## Evidence Provenance

Each flag includes provenance fields:

| Field | Purpose |
|-------|---------|
| `evidencePaths` | Array of `{path, label, section}` — PDTF claim paths that contributed |
| `legalContext` | Check-level legal framework (legislation, section numbers, thresholds) |
| `legalDetail` | Scenario-specific legal application |
| `rationale` | Step-by-step reasoning chain with `step` and `basis` fields |

When explaining a flag, cite `legalContext` for authoritative legal references. Use `evidencePaths` to show exactly which data drove the finding. Never fabricate legislation or section numbers.

## Tool Reference

### get_insights
Diligence engine flags: 37 categories, 323 checks, 2,215 scenarios.
```bash
MCP=~/.openclaw/skills/pdtf-connector/scripts/mcp-call.sh

# Definitive findings
$MCP tools/call '{"name":"moverly_get_insights","arguments":{"transactionId":"<id>","evidenceBasis":"data-driven"}}'

# Gaps needing follow-up
$MCP tools/call '{"name":"moverly_get_insights","arguments":{"transactionId":"<id>","evidenceBasis":"evidence-incomplete"}}'

# High-risk only
$MCP tools/call '{"name":"moverly_get_insights","arguments":{"transactionId":"<id>","minRisk":7}}'
```
- `evidenceBasis`: data-driven | evidence-incomplete | no-data | clear
- `minRisk`: 1-10 (minimum risk score)
- Returns: `{insights: [{category, check, title, riskScore, evidenceBasis, evidencePaths, legalContext, legalDetail, description, actions}], summary: {totalFlags, byRisk, byEvidence}}`

Or use the helper: `scripts/get-insights.sh <transactionId> [evidenceBasis] [minRisk]`

### get_queue
Check document processing pipeline status after upload.
```bash
$MCP tools/call '{"name":"moverly_get_queue","arguments":{"transactionId":"<id>"}}'
```
- Returns: `{summary: {totalItems, pending, completed}, pending: [...], recentlyCompleted: [...]}`
- Tracks: file classification, AI summarisation, claims extraction, DE re-evaluation

### get_risk_history
Historical risk timeline for a transaction.
```bash
$MCP tools/call '{"name":"moverly_get_risk_history","arguments":{"transactionId":"<id>"}}'
```

### handle_flag
Mark a flag as accepted, mitigated, or escalated.
```bash
$MCP tools/call '{"name":"moverly_handle_flag","arguments":{"transactionId":"<id>","flagId":"<fid>","action":"accept","reason":"Client accepts flood risk"}}'
```

### get_form_progress
Seller form completion status — built on Moverly's propertyPackTasks validation flags.
```bash
$MCP tools/call '{"name":"moverly_get_form_progress","arguments":{"transactionId":"<id>"}}'
```
- Returns: `{forms: [{name, category, percentComplete, overlay, sections: [{name, path, status, validationErrors}]}]}`
- Categories: listing (NTS), property-questions (TA6), leasehold-questions (TA7), fittings-and-contents (TA10), sale-ready

### describe_form_path
Form-specific schema filtered by the transaction's overlay, with question reference numbers.
```bash
$MCP tools/call '{"name":"moverly_describe_form_path","arguments":{"transactionId":"<id>","path":"/propertyPack/alterationsAndChanges"}}'
```
- Returns schema filtered to overlay-referenced properties only
- Each property annotated with `formRef` (question number like "5.1b")
- Overlay resolved server-side from transaction settings, not agent-chosen
- discriminator/oneOf preserved for conditional branching (Yes → more fields)

## Presenting Flags

Lead with plain English, not category codes. Use severity tags:

> [critical] **Short lease — 68 years remaining** (risk: 10/10)
> Most lenders won't lend below 70-80 years and the value drops significantly. The seller should start a Section 42 lease extension or assign the benefit to the buyer. Must resolve before exchange.
> Source: HMLR title register, DE analysis

For each flag: severity tag + plain description → why it matters → what happens next → who acts. Always cite the data source from `evidencePaths`.

## Workflow Recipes

**"What needs attention?"**
1. `get_status` (pdtf-connector) → overview + risk summary counts
2. `get_insights` with `evidenceBasis: "data-driven"` → definitive issues
3. `get_insights` with `evidenceBasis: "evidence-incomplete"` → gaps
4. Combine, sort by risk descending, group by theme

**"Explain to a buyer"**
Same as above but translate each flag: what it means for them, what happens next, who handles it. Use `legalContext` for authoritative citations. Never recommend legal action — always "your conveyancer should consider".

**"What's blocking exchange?"**
`get_insights` with `minRisk: 7` → list unresolved actions as a checklist with owners.

**"Compare my caseload"**
`list_transactions` (pdtf-connector) → for each, `get_status` gives `riskSummary` → sort by total risk score.

**Upload → Analyse cycle:**
1. `upload_document` (pdtf-connector) → upload the file
2. `get_queue` → wait for classification + summarisation to complete
3. `get_insights` → see what the engine found

**Seller interview (form completion):**
1. `get_form_progress` → find incomplete sections
2. `describe_form_path(transactionId, sectionPath)` → get schema with question refs
3. Walk discriminator/oneOf conversationally
4. `vouch` (pdtf-connector) collected data → confirms section
5. `get_form_progress` → verify completion moved

## Resolving Flags

When a flag has actions with `targetPath`, combine PDTF connector + diligence tools:

**Data resolution (describe → vouch):**
1. `get_insights` → find flag with `evidenceBasis: "evidence-incomplete"` and `targetPath`
2. `describe_path(targetPath)` (pdtf-connector) → get strict schema
3. Collect data following discriminator/oneOf branching
4. `vouch` (pdtf-connector) → validates and submits
5. `get_insights` → verify flag resolved

**Document resolution:**
1. `get_insights` → find flag with `documentTypes` in actions
2. `upload_document(pdtfPath=targetPath)` (pdtf-connector) → upload linked to schema location
3. `get_queue` → wait for processing
4. `vouch(path=targetPath, value="Attached")` (pdtf-connector) → confirm
5. `get_insights` → verify flag resolved

**Provenance check:**
1. `get_insights` → see a data-driven flag
2. Read `evidencePaths` array
3. `get_provenance(path=evidencePaths[0])` (pdtf-connector) → trace who provided the data

## When to Raise Enquiries vs Vouch Directly

| Situation | Action | Skill |
|-----------|--------|-------|
| You have the data/document | `vouch` directly | pdtf-connector |
| You need data from another party | `raise_enquiry` | pdtf-connector |
| Flag action says "raise enquiry" | `raise_enquiry` with `relatedFlagId` | pdtf-connector |
| Flag action says "collect data" | describe → vouch loop | pdtf-connector |
| Need to check processing status | `get_queue` | moverly-diligence |
| Need to interpret risk findings | `get_insights` | moverly-diligence |
