---
name: agentic-diligence
description: Run a risk resolution loop against a live Moverly transaction via MCP. Connects to the Moverly MCP server, retrieves transaction state and diligence flags, and guides the user through resolving each risk — highest priority first — until risk is at an acceptable level. This is the core agentic diligence workflow. Use when a conveyancer asks "what do I need to do on this transaction?", "what have I missed?", "what's blocking exchange?", or wants to work through risks systematically.
---

# Agentic Diligence Loop

Connect to a live Moverly transaction and drive risk to resolution.

## Response Rules — Always Include

**DO:**
- **Always start by calling `list_transactions`** to find the transaction, then `get_insights` to get current flags
- Present flags in **priority order** (highest risk score first, then by evidenceBasis)
- For each flag, show: the risk title, severity, what the DE found, and the **specific action** needed to resolve it
- When a flag has `actions` with `targetPath`, tell the user exactly what to vouch/upload at that path
- After any resolution action, call `get_insights` again to confirm the flag resolved or dropped in severity
- Track resolution progress: "Started with N flags, M resolved, K remaining"
- When flags remain but are low-severity (risk ≤ 3) or evidence-basis is `no-data`, tell the user these are acceptable to carry — explain why
- Use `get_state` to check what data already exists before asking the user for information the transaction already has
- Use `get_form_progress` to identify incomplete seller forms and guide the user through them
- **Stop the loop** when: all flags are resolved, OR remaining flags are below the user's stated risk tolerance, OR remaining flags require external action (e.g. waiting for a search result)

**DON'T:**
- Don't just list all flags at once without prioritisation — that's a report, not a workflow
- Don't skip re-checking after a resolution action — the DE may cascade (resolving one flag can resolve others)
- Don't tell the user to "check" something without specifying which MCP tool call would verify it
- Don't hallucinate flag details — always quote from the actual `get_insights` response
- Don't continue the loop if the user says they're comfortable with remaining risk

## Prerequisites

This skill requires a connection to the Moverly MCP server. The agent needs:
- A valid MCP endpoint (staging: `https://api-staging.moverly.com/mcpService/mcp`)
- A Personal Access Token (`mvly_pat_` prefix) with access to the relevant organisation
- The transaction must exist and have diligence engine results

If any of these are missing, tell the user what's needed and how to get it.

## The Resolution Loop

### Step 1: Find the Transaction

```
Call: list_transactions(status: "all")
```

If the user gave an address or UPRN, match it. If multiple transactions exist, ask which one.

### Step 2: Get Current Risk Picture

```
Call: get_insights(transactionId: "<id>", evidenceBasis: "data-driven")
```

This returns only flags backed by actual evidence (not "no-data" placeholders). Count them, note the severity distribution.

**Opening summary:**
> "This transaction has **N data-driven flags**. X are critical (risk 8-10), Y are high (risk 5-7), Z are moderate (risk 3-4). Let me walk you through the highest-priority items first."

### Step 3: Work the Highest-Priority Flag

For the top flag:

1. **Explain what the DE found** — quote the flag title, category, and risk score
2. **Show the evidence basis** — what data drove this finding
3. **Present the resolution path:**
   - If the flag has `actions` with a `targetPath`: "To resolve this, you need to upload/vouch [X] at path `[targetPath]`"
   - If it needs a document: "Upload the [document type] using `upload_document`"
   - If it needs seller information: "This needs the seller to complete [form section] — check `get_form_progress` for status"
   - If it needs external data (search results, certificates): "This is waiting on [X] — mark as blocked and move to the next flag"
4. **After resolution:** Call `get_insights` again. Report what changed:
   > "Flag resolved ✓ — down to N-1 flags. [Any cascading resolutions?] Next highest: [flag title]"

### Step 4: Repeat Until Done

Keep working flags in priority order. The loop ends when:
- **All clear:** No flags remain above risk threshold → "Transaction is clean. All diligence items resolved."
- **Acceptable risk:** Remaining flags are low-severity or no-data → "N low-severity items remain. These are [explain why they're acceptable]. Ready for exchange subject to [any caveats]."
- **Blocked:** Remaining flags need external action → "M items are waiting on external data. Here's what's outstanding: [list with who needs to do what]."
- **User satisfied:** User says they're comfortable → "Understood. Recording current risk acceptance. N flags remain at [severity distribution]."

## Working with Forms

When flags relate to incomplete seller information:

```
Call: get_form_progress(transactionId: "<id>")
```

This shows completion percentage per form (TA6, TA7, TA10, etc.) and which sections are incomplete.

For incomplete sections:
```
Call: describe_form_path(transactionId: "<id>", formRef: "ta6", section: "<section>")
```

This returns the schema for that section — use it to guide the seller through what's needed.

## Working with Documents

When a flag needs a document:

1. Check `get_state` for existing documents at the relevant path
2. If missing, tell the user what to upload:
   ```
   Call: upload_document(transactionId: "<id>", document: "<base64>", filename: "building-regs-cert.pdf")
   ```
3. The document will be auto-classified and linked to the right PDTF path
4. After upload, call `get_insights` to check if the flag resolved

## Risk Tolerance Guidance

Help the user calibrate their risk tolerance:

- **Pre-exchange minimum:** No critical (8-10) or high (5-7) flags with `data-driven` evidence basis. These represent known, evidenced risks.
- **Lender requirement:** Lender-specific flags (from `lenders-handbook-requirements` category) are non-negotiable — the lender won't complete with these outstanding.
- **Acceptable to carry:** `no-data` flags (risk of unknown) and low-severity (≤3) flags are typically acceptable, especially if the conveyancer has addressed them through other means not captured in PDTF.
- **Buyer's decision:** Some moderate flags (4-5) are genuinely a buyer decision — e.g. flood zone proximity, short lease awareness. Surface these clearly but don't insist on resolution.

## Example Session

```
User: "What's the status on the Bristol property?"

Agent: Let me check.
[Calls list_transactions → finds BcGQfqCEVb7Dz1Naxgbjnd]
[Calls get_insights with evidenceBasis: "data-driven"]

This transaction has 13 data-driven flags:
- 2 critical (risk 8-10): very short lease, loft conversion without building regs
- 4 high (risk 5-7): flood zone 2, missing EPC, incomplete TA6, planning query
- 7 moderate (risk 3-4): various minor items

Let's start with the critical items.

**1. Very Short Lease (risk 10)**
The lease has 68 years remaining. This is below the 80-year threshold where
mortgage lenders typically won't lend, and below 70 years where marriage value
applies. The seller should serve a Section 42 notice before completion.

Actions needed:
- Confirm current lease length with get_state
- Check lender-specific thresholds (most require 70+ years at end of mortgage term)
- If seller can extend: vouch the new lease term
- If not: flag to buyer as unmortgageable without extension

Shall I check the lender requirements, or move to the next critical item?
```

## Auditing Against Protocols

After working through all flags, the user may ask "have I missed anything the protocol requires?" 

The DE's 37 rule categories cover the substantive requirements of:
- Law Society Conveyancing Protocol
- CQS Practice Standards  
- CA Protocol (5th Edition)
- CLC Practice Requirements
- UK Finance Lenders' Handbook

If the DE has no flags in a category, it means either:
1. The data shows compliance (positive finding), or
2. No data exists for that category (would show as `no-data` flags if configured)

The loop IS the checklist — worked in priority order rather than sequential order.
