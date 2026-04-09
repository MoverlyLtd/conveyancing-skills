---
name: agentic-diligence
version: 1.1.0
description: Run a risk resolution loop against a live Moverly transaction via MCP. Connects to the Moverly MCP server, retrieves transaction state and diligence flags, and guides the user through resolving each risk — highest priority first — until risk is at an acceptable level. This is the core agentic diligence workflow. Use when a conveyancer asks "what do I need to do on this transaction?", "what have I missed?", "what's blocking exchange?", or wants to work through risks systematically.
---

# Agentic Diligence Loop

Connect to a live Moverly transaction and drive risk to resolution.

## Response Rules — Always Include

**DO:**
- **If you already know the transactionId**, go straight to `moverly_get_insights`. Only fall back to `moverly_find_transaction` (cheap, single-transaction lookup by address/UPRN) or `moverly_list_transactions` (full portfolio) when the id is unknown.
- Present flags in **priority order** (highest risk score first, then by `evidenceBasis`).
- For each flag, show: the risk title, severity, what the DE found, and the **specific action** needed to resolve it.
- When a flag has `actions` with a `targetPath`, tell the user exactly what to vouch/upload/enquire about at that path — see *"Resolving a flag: which tool?"* below for the routing rule.
- After any resolution action, call `moverly_get_insights` again to confirm the flag resolved or dropped in severity. If you uploaded a document, also poll `moverly_get_queue` until processing completes before re-reading insights.
- Track resolution progress: "Started with N flags, M resolved, K remaining".
- When flags remain but are low-severity (risk ≤ 3) or `evidenceBasis` is `no-data`, tell the user these are acceptable to carry — explain why.
- Use `moverly_get_state` to check what data already exists before asking the user for information the transaction already has. Pass a `path` to keep the response small.
- Use `moverly_get_form_progress` to identify incomplete seller forms and guide the user through them.
- **Stop the loop** when: all flags are resolved, OR remaining flags are below the user's stated risk tolerance, OR remaining flags require external action (e.g. waiting for a search result or a seller-conveyancer reply to an enquiry).

**DON'T:**
- Don't just list all flags at once without prioritisation — that's a report, not a workflow.
- Don't skip re-checking after a resolution action — the DE may cascade (resolving one flag can resolve others).
- Don't tell the user to "check" something without specifying which MCP tool call would verify it.
- Don't hallucinate flag details — always quote from the actual `moverly_get_insights` response.
- Don't invent a tool name. The only live write tools are `moverly_vouch`, `moverly_upload_document`, `moverly_raise_enquiry`, and `moverly_respond_enquiry`. There is no `handle_flag` tool (it is defined in the schema but not yet implemented).
- Don't continue the loop if the user says they're comfortable with remaining risk.

## Prerequisites

This skill requires a connection to the Moverly MCP server. The agent needs:
- A valid MCP endpoint (staging: `https://api-staging.moverly.com/mcpService/mcp`)
- A Personal Access Token (`mvly_pat_` prefix) with access to the relevant organisation
- The transaction must exist and have diligence engine results

If any of these are missing, tell the user what's needed and how to get it.

## Tool Catalogue

Tool names below are exactly as the MCP server exposes them. Each bullet shows the tool name and when to reach for it in the loop. There are 20 live tools grouped by purpose; two additional names (`moverly_handle_flag`, `moverly_get_risk_history`) appear in `tools/list` but are not yet implemented — do not call them.

### Discovery
- `moverly_find_transaction` — single-transaction lookup by address or UPRN. Cheap. Use this first when you just need one property.
- `moverly_list_transactions` — full portfolio view with risk summaries and readiness indicators. Use when you need to browse or compare.
- `moverly_get_status` — lightweight readiness snapshot: form completion percentages, milestones, completeness score. Use to answer "is this ready to work on?" without pulling state.

### Transaction state
- `moverly_get_state` — composed PDTF property pack. Pass `path` to scope the response to a subtree. This is the main read tool.
- `moverly_get_claims` — raw verified claims (provenance view, not the composed view). Use when you need the full submission history rather than the merged picture.
- `moverly_get_form_progress` — hierarchical form progress per form and section (NTS, TA6, TA7, TA10).
- `moverly_get_insights` — diligence engine risk flags with rationales, evidence basis, and suggested actions. **The heart of this loop.**
- `moverly_get_provenance` — full evidence chain for a single PDTF path: who vouched what, when, how verified. Use for "where did this come from?" and audit.
- `moverly_describe_path` — JSON subschema + human-readable description for any PDTF path. Call this before any `moverly_vouch` so you know the exact shape required.
- `moverly_describe_form_path` — same idea but overlay-filtered for the transaction's active forms.

### Resolution (write) tools
- `moverly_vouch` — submit a verified claim at a PDTF path. Data action.
- `moverly_upload_document` — upload a document, auto-classified and extracted into claims. Processing is async — poll `moverly_get_queue` afterwards.
- `moverly_raise_enquiry` — raise a pre-contract enquiry with threading, role attribution, and status tracking. Use when the action is conversational (`advise-…`, `request-…`, `confirm-…`) or the resolution requires the other side to disclose something.
- `moverly_respond_enquiry` — thread a response under an existing enquiry (and optionally update its status).
- `moverly_list_enquiries` — check for inbound enquiries that need a response, or monitor the status of enquiries you've raised. The current live server returns the full `messages[]` array per enquiry. MR !3298 changes this so the default is a compact summary (`messageCount`, `lastMessage` preview, `lastMessageAt`) and callers who actually need the full thread have to pass `includeMessages: true`. Either way, prefer the summary fields if you only need to know how many enquiries exist and their high-level status.

### Admin / utility (not part of the main loop)
- `moverly_get_queue` — check processing status after `moverly_upload_document`.
- `moverly_download_document` — fetch a document by `fileId` (URL or base64 content).
- `moverly_list_overlays` — list available PDTF validation overlays.
- `moverly_create_transaction` — create a new case from an address or UPRN.
- `moverly_delete_claims_after` — destructive cleanup tool for demo resets. Do not call during a real diligence loop.

## Resolving a flag: which tool?

When a flag has `actions` in its `actions[]` array, the action entry tells you everything you need to route to the right write tool. The rule is deterministic:

1. **Vouch** — `targetPath` is set **and** `documentTypes` is empty. The action is a data assertion. Use `moverly_describe_path` first if you are unsure of the exact shape, then call `moverly_vouch(transactionId, path, value)`.
2. **Upload a document** — `targetPath` is set **and** `documentTypes` is non-empty. Pick one of the allowed document types and call `moverly_upload_document(transactionId, fileContent, fileName)` — the backend auto-classifies, extracts claims, and links them to the target path. Poll `moverly_get_queue` until processing completes, then re-read `moverly_get_insights`.
3. **Raise an enquiry** — `targetPath` is `null`, **or** the action is a conversational verb (`advise-…`, `request-…`, `confirm-…`, `disclose-…`, `negotiate-…`). Call `moverly_raise_enquiry(transactionId, subject, messageText, destinationRole)`. After the other side replies you check with `moverly_list_enquiries` and resolve via `moverly_respond_enquiry`.
4. **None of the above** — the action is advisory to a non-conveyancer role (e.g. something only the buyer or seller can do). Surface the guidance to the user without trying to execute a tool call.

This replaces any older "vouch or upload" framing. Enquiries are a first-class resolution channel.

## The Resolution Loop

### Step 1: Find the transaction

If the user gave you a transactionId, skip to Step 2.

If they gave you an address or UPRN:
```
Call: moverly_find_transaction(address: "<address>")   // or { uprn: "<uprn>" }
```

If they were vague ("the Bristol property", "my next completion"), fall back to:
```
Call: moverly_list_transactions(status: "all")
```
…and match on address, UPRN, or readiness indicators. If multiple transactions match, ask which one.

### Step 2: Get the current risk picture

```
Call: moverly_get_insights(
  transactionId: "<id>",
  evidenceBasis: ["data-driven", "evidence-incomplete"]
)
```

`evidenceBasis` is an **array** filter (the tool schema expects a JSON array, not a string). `["data-driven", "evidence-incomplete"]` is the recommended starting filter for actionable findings — it excludes `"clear"` (no issues) and `"no-data"` (nothing to evaluate). Narrow to just `["data-driven"]` if the user only wants evidenced risks. Count the results and note the severity distribution.

**Opening summary:**
> "This transaction has **N data-driven flags**. X are critical (risk 8-10), Y are high (risk 5-7), Z are moderate (risk 3-4). Let me walk you through the highest-priority items first."

Also consider calling `moverly_list_enquiries(transactionId: "<id>", direction: "inbound", status: "open")` once up-front so you can surface any inbound enquiries that need a response as part of the loop rather than missing them.

### Step 3: Work the highest-priority flag

For the top flag:

1. **Explain what the DE found** — quote the flag title, category, and risk score.
2. **Show the evidence basis** — what data drove this finding.
3. **Present the resolution path** using the routing rule above:
   - *Vouch path:* "To resolve this, vouch `<value shape>` at path `<targetPath>`. Let me check the schema first with `moverly_describe_path(path)` and then call `moverly_vouch`."
   - *Document path:* "This needs a `<documentType>`. Call `moverly_upload_document` with the file, then I'll poll `moverly_get_queue` and re-read insights."
   - *Enquiry path:* "This one needs the seller conveyancer to confirm / disclose / advise. Let me raise it with `moverly_raise_enquiry`. We can't close it until they reply."
   - *Form-driven:* "This needs the seller to complete `<form section>`. Check `moverly_get_form_progress` for the current state and guide them through it."
   - *External / blocked:* "This is waiting on `<thing>` — mark it blocked and move to the next flag."
4. **After resolution:** Call `moverly_get_insights` again (after `moverly_get_queue` if you uploaded a document). Report what changed:
   > "Flag resolved ✓ — down to N-1 flags. [Any cascading resolutions?] Next highest: [flag title]"

### Step 4: Repeat until done

Keep working flags in priority order. Also sweep inbound enquiries (`moverly_list_enquiries` with `direction: "inbound"`) once per pass so nothing from the other side is forgotten. The loop ends when:
- **All clear:** No flags remain above risk threshold → "Transaction is clean. All diligence items resolved."
- **Acceptable risk:** Remaining flags are low-severity or `no-data` → "N low-severity items remain. These are [explain why they're acceptable]. Ready for exchange subject to [any caveats]."
- **Blocked:** Remaining flags need external action → "M items are waiting on external data or enquiry responses. Here's what's outstanding: [list with who needs to do what]."
- **User satisfied:** User says they're comfortable → "Understood. Recording current risk acceptance. N flags remain at [severity distribution]."

## Working with forms

When flags relate to incomplete seller information:
```
Call: moverly_get_form_progress(transactionId: "<id>")
```
This shows completion percentage per form (TA6, TA7, TA10, NTS) and which sections are incomplete.

For incomplete sections, get the transaction-specific overlay-filtered schema:
```
Call: moverly_describe_form_path(transactionId: "<id>", path: "<pdtf path>")
```
Use this to guide the seller through exactly what's needed — the overlay trims the schema to properties that actually matter for this transaction.

Before vouching against a raw PDTF path (not a form), prefer `moverly_describe_path(path)` — it returns the strict subschema (`additionalProperties: false`) so you can build a value the server will accept first time.

## Working with documents

When a flag needs a document:

1. Check `moverly_get_state(transactionId, path)` for any existing document at the relevant path.
2. If missing, tell the user what to upload:
   ```
   Call: moverly_upload_document(
     transactionId: "<id>",
     fileContent: "<base64>",
     fileName: "building-regs-cert.pdf"
   )
   ```
3. Poll `moverly_get_queue(transactionId)` until the document is processed.
4. Call `moverly_get_insights` again to check if the flag resolved.
5. If you need to audit the result, `moverly_get_provenance(transactionId, path)` shows the full chain: who vouched what, when, and how it was verified.

## Working with enquiries

The enquiry tools shipped in MR !3282 — they are the resolution channel for any flag whose action is conversational or where the `targetPath` is `null`.

**Raising an enquiry:**
```
Call: moverly_raise_enquiry(
  transactionId: "<id>",
  subject: "<short subject>",
  messageText: "<body>",
  destinationRole: "Seller's Conveyancer"   // exact enum value from the tool schema
)
```

The `destinationRole` must be one of the exact enum values from the tool schema: `"Seller"`, `"Seller's Conveyancer"`, `"Buyer"`, `"Buyer's Conveyancer"`, `"Estate Agent"`, `"Lender"`, `"Surveyor"`, `"Mortgage Broker"`. The apostrophe is a plain ASCII `'` (U+0027), not a typographic one, and the string must match exactly including capitalisation. The call will fail validation if you drop the apostrophe, substitute a curly quote, or use a different form like `"Seller Conveyancer"`.

**Checking for responses:**
```
Call: moverly_list_enquiries(transactionId: "<id>", direction: "inbound", status: "open")
```
Default response is a compact summary per enquiry (`messageCount`, `lastMessage` preview, `lastMessageAt`). Pass `includeMessages: true` only when you actually need the full thread.

**Responding to an enquiry:**
```
Call: moverly_respond_enquiry(
  transactionId: "<id>",
  enquiryId: "<id>",
  messageText: "<body>",
  updateStatus: "resolved"   // optional
)
```

Enquiries that are still `open` after your resolution pass should be reported as blocked — the loop cannot close them.

## Risk tolerance guidance

Help the user calibrate their risk tolerance:

- **Pre-exchange minimum:** No critical (8-10) or high (5-7) flags with `data-driven` evidence basis. These represent known, evidenced risks.
- **Lender requirement:** Lender-specific flags (from `lenders-handbook-requirements` category) are non-negotiable — the lender won't complete with these outstanding.
- **Acceptable to carry:** `no-data` flags (risk of unknown) and low-severity (≤3) flags are typically acceptable, especially if the conveyancer has addressed them through other means not captured in PDTF.
- **Buyer's decision:** Some moderate flags (4-5) are genuinely a buyer decision — e.g. flood zone proximity, short lease awareness. Surface these clearly but don't insist on resolution.

## Example Session

```
User: "What's the status on 10 Downend Park?"

Agent:
[Calls moverly_find_transaction(address: "10 Downend Park, Bristol BS7 9PU")
 → returns transactionId: D2YHMFAZ4n8oJ3puvxUjqA]
[Calls moverly_get_insights(transactionId: "D2YHMFAZ4n8oJ3puvxUjqA",
                            evidenceBasis: ["data-driven", "evidence-incomplete"])]
[Calls moverly_list_enquiries(transactionId: "D2YHMFAZ4n8oJ3puvxUjqA",
                              direction: "inbound", status: "open")]

This transaction has **N data-driven flags**. [summarise severity distribution.]
[If any inbound enquiries are open, surface them here as well.]

Let's start with the highest-priority item.

**1. <flag title> (risk <score>)**
<DE finding quoted from get_insights response>

Resolution: the flag's action is "<actionId>" against path
`<targetPath>` with documentTypes=[<list>]. That means this is a
<vouch | upload | enquiry> action — I'll <describe next call>.

Shall I proceed, or move to the next item?
```

The demo transaction used in Moverly's own end-to-end tests is `D2YHMFAZ4n8oJ3puvxUjqA` (10 Downend Park, Bristol BS7 9PU). Use it when you want a sanity-check session against real data on staging.

## Auditing against protocols

After working through all flags, the user may ask "have I missed anything the protocol requires?"

The DE's 37 rule categories cover the substantive requirements of:
- Law Society Conveyancing Protocol
- CQS Practice Standards
- CA Protocol (5th Edition)
- CLC Practice Requirements
- UK Finance Lenders' Handbook

If the DE has no flags in a category, it means either:
1. The data shows compliance (positive finding), or
2. No data exists for that category (would show as `no-data` flags if configured).

The loop IS the checklist — worked in priority order rather than sequential order. If the user wants a sequential tick-off, pair this skill with the relevant protocol checklist skill.
