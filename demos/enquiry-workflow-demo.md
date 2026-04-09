# Enquiry Workflow Demo — Claude Cowork

## Setup

1. Open Claude Cowork (claude.ai)
2. Connect the Moverly MCP server:
   - Settings → Connectors → Moverly (should already be configured)
3. Start a new conversation
4. Paste the prompt below to begin

---

## Demo Prompt

Paste this into a new Cowork conversation:

---

You have the Moverly MCP server connected. We're going to walk through a complete enquiry lifecycle on a real transaction.

**Step 1: Find the demo transaction**

Call `moverly_list_transactions` to find the transaction for 10 Downend Park, Bristol BS7 9PU. Show me the transaction ID and current status.

The expected transaction ID is `D2YHMFAZ4n8oJ3puvxUjqA`.

**Step 2: Snapshot the timestamp**

Note the current time — we'll use this to reset after the demo. Store it as the "demo start" timestamp.

**Step 3: Receive inbound enquiries**

The buyer's conveyancer has sent the following email. Extract each enquiry, resolve the PDTF path, and present them for my approval before logging:

```
Dear Sirs,

Re: 10 Downend Park, Bristol BS7 9PU — Our client: Mr James Harrison
Our ref: SJ/2024/1234

We write further to receipt of the contract pack and raise the following additional enquiries:

1. Please confirm the remaining lease term and provide a copy of the lease.

2. We note from the TA6 that a rear extension was carried out in 2019. Please confirm whether building regulations approval was obtained and provide the completion certificate.

3. The environmental search indicates the property is in Flood Zone 2. Please confirm whether the seller has experienced any flooding and provide details of any flood insurance claims.

4. We note a restrictive covenant on the title prohibiting alterations to the front elevation. Please confirm this has not been breached by the replacement windows noted in the TA6.

5. Please provide details of the management company including current service charge levels and any planned major works.

We look forward to hearing from you.

Yours faithfully,
Sarah Chen
Smith & Jones Solicitors
```

For each enquiry:
- Extract the subject
- Resolve the exact PDTF leaf path where the answer/document should be vouched (e.g. `.../buildingRegApproval/attachments` or `.../ownershipsToBeTransferred/0/leaseholdInformation/leaseTerm`). Do NOT guess short paths; use `moverly_describe_path` to explore if needed.
  - *Hint for this demo, use these exact paths:*
  - Enquiry 1: `/propertyPack/ownership/ownershipsToBeTransferred/0/leaseholdInformation/leaseTerm`
  - Enquiry 2: `/propertyPack/alterationsAndChanges/extension/0/buildingRegApproval/attachments`
  - Enquiry 3: `/propertyPack/environmentalIssues/flooding/sellerExperience`
  - Enquiry 4: `/propertyPack/alterationsAndChanges/windowReplacementsSince2002/deedRestrictionConsent/attachments`
  - Enquiry 5: `/propertyPack/ownership/ownershipsToBeTransferred/0/leaseholdInformation/serviceCharge`
- Show me the mapping in a table
- Ask me to confirm before pushing to MCP

When I confirm, use `moverly_raise_enquiry` for each, with:
- `subject`: a short title for the enquiry
- `messageText`: the full enquiry text
- `destinationRole`: "Seller's Conveyancer" (exact enum value, with apostrophe)
- `externalIds`: `{"email": "SJ/2024/1234", "enquiryNumber": "1"}` (incrementing)
- `pdtfPath`: the resolved PDTF path for the subject

**Step 4: Check what was logged**

Call `moverly_list_enquiries` and show me the 5 enquiries we just raised.

**Step 5: Render a chaser**

Imagine it's been 10 days. Render the outstanding enquiries as a professional email I can send to the seller's conveyancer, with appropriate chaser language.

**Step 6: Handle responses**

The seller's conveyancer has replied:

```
Dear Ms Chen,

Re: 10 Downend Park — Our client: Mrs Patricia Webb
Your ref: SJ/2024/1234

In response to your additional enquiries:

1. The lease has 87 years remaining from an original 125-year term granted in 1961. A copy of the lease is enclosed.

2. Building regulations approval was obtained for the rear extension. The completion certificate is enclosed.

3. The seller has not experienced any flooding at the property during 8 years of ownership. No insurance claims have been made.

4. We will take instructions on this point and revert.

5. The management company is Oakwood Management Ltd. Current service charge is £1,200 per annum. We are not aware of any planned major works. The latest accounts are enclosed.

Yours faithfully,
David Roberts
Roberts & Co Solicitors
```

Match each response to the original enquiry, identify:
- Which are fully answered (mark as resolved)
- Which are holding responses (leave open)
- Any documents mentioned for upload
- Any data that could be vouched to the PDTF state

Present your matches and ask me to confirm before pushing.

When I confirm, use `moverly_respond_enquiry` for each matched response.

**Step 7: Status check**

Call `moverly_list_enquiries` again and show me the updated status — what's resolved, what's still open.

**Step 8: Reset for next demo**

Use `moverly_delete_claims_after` with the "demo start" timestamp from Step 2, in `dryRun: true` first to show what would be deleted, then actually delete when I confirm.

---

## What This Demonstrates

1. **Enquiry extraction** from natural language email → structured PDTF enquiries with path resolution
2. **Approval gates** at every step — agent proposes, human confirms
3. **externalIds** for cross-system linking (email reference → PDTF enquiry key)
4. **Enquiry rendering** as professional correspondence
5. **Response matching** — identifying answered vs holding vs unanswered
6. **Document identification** — flagging attachments for upload
7. **Vouch opportunities** — structured data from responses (lease term, service charge) that could be vouched
8. **Demo reset** — clean state for repeated demonstrations

## Expected MCP Calls

| Step | Tool | Count |
|------|------|-------|
| 1 | `list_transactions` | 1 |
| 3 | `raise_enquiry` | 5 |
| 4 | `list_enquiries` | 1 |
| 6 | `respond_enquiry` | 4 (not #4 — holding) |
| 7 | `list_enquiries` | 1 |
| 8 | `delete_claims_after` | 2 (dryRun + real) |
| **Total** | | **14 calls** |

## Notes

- Demo transaction: `D2YHMFAZ4n8oJ3puvxUjqA` (10 Downend Park, Bristol BS7 9PU) on staging
- All 4 MCP tools live on staging as of 2026-04-08 (MR !3282 merged)
- If the demo transaction doesn't have matching lease/leasehold data, adjust the email content to match what's actually there
- Known issue: The agent might look for `totalCount` when checking enquiries. The correct field is `total`. Ensure it reads the array length or the `total` field correctly.
- The demo works best when the conveyancer reads the agent's proposals carefully and edits/confirms — this is the approval gate in action
