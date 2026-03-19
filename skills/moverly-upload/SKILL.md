---
name: moverly-upload
description: "Upload case documents to Moverly for property diligence analysis. Use when: uploading property documents, sending case files for analysis, 'PDF in intelligence out', document processing, case document set upload, title register upload, search results upload, TA6 TA7 TA10 form upload, lease upload, property pack upload, running diligence on documents. Requires Moverly PAT and an active transaction."
---

# Moverly Document Upload & Analysis

Upload case documents to a Moverly transaction for automated diligence analysis. The diligence engine evaluates documents against 37 risk categories (323 checks, 2,215 scenarios) and returns actionable intelligence.

## Prerequisites

- `MOVERLY_PAT` environment variable set (Moverly Personal Access Token)
- An active Moverly transaction (use `moverly-connect` skill to list transactions)
- `{{SKILL_DIR}}/scripts/mcp-call.sh` available (shared with moverly-connect)

## When to Use

Use this skill when a user wants to:
- Upload property documents for diligence analysis
- Send a case document set (title register, searches, forms, lease) to Moverly
- Run "PDF in, intelligence out" — submit documents and get risk flags back
- Process individual documents and check what the diligence engine finds
- Build up an evidence base across multiple documents for a transaction

## Core Concept

Diligence intelligence is cumulative. A single document gives some insight, but the real risk picture builds up over the whole collection. Each document adds evidence that the engine evaluates against all 37 categories. Upload the title register and you get tenure flags. Add the searches and flood/environmental flags resolve. Add the TA6 and building regulations, planning, alterations flags light up. The more evidence, the sharper the analysis.

## Document Types

The diligence engine processes these document categories. When collecting documents from the user, explain what each provides:

| Document | What It Tells The Engine |
|----------|-------------------------|
| **Title Register** (OC1/OC2) | Tenure, ownership, restrictions, charges, easements, covenants |
| **Title Plan** | Property boundaries, extent of title |
| **Local Authority Search** | Planning history, building control, conservation area, listed building, highways |
| **Environmental Search** | Flood risk, contaminated land, subsidence, radon, mining |
| **Water & Drainage Search** | Drainage connections, water supply, sewer proximity |
| **TA6 (Property Information Form)** | Seller disclosures — alterations, boundaries, disputes, services, environmental issues |
| **TA7 (Leasehold Information Form)** | Lease details, service charges, management company, ground rent |
| **TA10 (Fittings and Contents Form)** | What's included/excluded in sale |
| **Lease** | Lease terms, ground rent escalation, restrictions, forfeiture clauses |
| **EPC Certificate** | Energy rating, recommendations, assessor details |
| **Management Pack** | Service charges, reserve fund, planned works, insurance |
| **Mortgage Offer** | Lender requirements, special conditions |
| **Property Pack / HIP** | Bundled upfront information pack |

## Workflow

### Step 1: Identify the Transaction

```bash
# List available transactions
bash {{SKILL_DIR}}/scripts/mcp-call.sh tools/call \
  '{"name": "moverly_list_transactions", "arguments": {"status": "all"}}'
```

Ask the user which transaction to upload documents to. If they don't have one yet, they need to create a transaction in Moverly first (or use the sandbox).

### Step 2: Collect Documents

Ask the user what documents they have available. Guide them on priority order:

**Start with these (highest intelligence value):**
1. Title Register — establishes tenure, ownership, restrictions
2. Local Authority Search — planning, building control, conservation
3. TA6 — seller disclosures on alterations, issues, disputes

**Then add:**
4. Environmental Search — flood, contamination, subsidence
5. Lease (if leasehold) — terms, ground rent, restrictions
6. TA7 (if leasehold) — service charges, management

**Complete the picture:**
7. Water & Drainage Search
8. EPC Certificate
9. Management Pack (if leasehold)
10. TA10, Mortgage Offer, Title Plan

### Step 3: Upload Each Document

For each document the user provides:

```bash
# Upload a document
bash {{SKILL_DIR}}/scripts/mcp-call.sh tools/call \
  '{"name": "moverly_upload_document", "arguments": {
    "transactionId": "<TRANSACTION_ID>",
    "file": "<BASE64_ENCODED_FILE>",
    "filename": "<FILENAME>",
    "documentType": "<TYPE>"
  }}'
```

Document type values: `title-register`, `title-plan`, `local-search`, `environmental-search`, `water-drainage-search`, `ta6`, `ta7`, `ta10`, `lease`, `epc`, `management-pack`, `mortgage-offer`, `property-pack`, `other`

After each upload, the engine processes the document asynchronously.

### Step 4: Monitor Processing

```bash
# Check processing queue
bash {{SKILL_DIR}}/scripts/mcp-call.sh tools/call \
  '{"name": "moverly_get_queue", "arguments": {
    "transactionId": "<TRANSACTION_ID>"
  }}'
```

Wait for queue items to complete before checking insights. Typical processing time: 10-30 seconds per document.

### Step 5: Check Intelligence

After documents are processed, retrieve the updated risk analysis:

```bash
# Get evidenced flags only (skip noise)
bash {{SKILL_DIR}}/scripts/mcp-call.sh tools/call \
  '{"name": "moverly_get_insights", "arguments": {
    "transactionId": "<TRANSACTION_ID>",
    "evidenceBasis": "data-driven"
  }}'
```

```bash
# Also check evidence-incomplete flags (need more docs to resolve)
bash {{SKILL_DIR}}/scripts/mcp-call.sh tools/call \
  '{"name": "moverly_get_insights", "arguments": {
    "transactionId": "<TRANSACTION_ID>",
    "evidenceBasis": "evidence-incomplete"
  }}'
```

### Step 6: Present Results

Present the analysis to the user in this structure:

**Risk Summary:**
- Total flags found, broken down by severity (critical/high/moderate/low)
- Evidence basis breakdown (how many flags are data-driven vs need more evidence)

**Key Findings (data-driven flags):**
For each flag with evidenceBasis "data-driven":
- Category and check name
- Risk score and severity
- What the engine found (rationale)
- Recommended actions

**Needs More Evidence (evidence-incomplete flags):**
For each flag with evidenceBasis "evidence-incomplete":
- What document or information would resolve this flag
- Map the flag category to the document type that would provide evidence (see Document Types table above)

**Recommended Next Upload:**
Based on the evidence-incomplete flags, recommend which document to upload next for maximum intelligence gain.

## Example Session

User: "I've got the title register and TA6 for 14 Oakwood Terrace, can you run diligence on them?"

Agent flow:
1. List transactions → find 14 Oakwood Terrace
2. Upload title register → wait for processing
3. Upload TA6 → wait for processing
4. Get insights (data-driven) → present key findings
5. Get insights (evidence-incomplete) → "To resolve the flood risk flag, upload the environmental search. To resolve building regulations flags, the local authority search would confirm approval status."

## Notes

- The `upload_document` and `get_queue` MCP tools require Phase 2 deployment. If these tools return "not yet implemented", inform the user and suggest checking back or using the Moverly web interface.
- Large documents (>10MB) may take longer to process.
- The engine re-evaluates all 37 categories after each new document — intelligence is cumulative.
- For sandbox transactions, collectors (HMLR, EPC auto-fetch) are suppressed. Only uploaded documents and manually added claims feed the engine.
