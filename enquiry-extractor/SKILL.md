---
name: enquiry-extractor
description: Extract individual enquiries from inbound email text (e.g. from buyer's conveyancer) and push each to the correct PDTF path via MCP. Use when a conveyancer receives an email or letter containing numbered enquiries and wants to log them against the transaction automatically.
---

# Enquiry Extractor

Parse inbound enquiry emails and route each enquiry to the correct PDTF path in Moverly.

## Response Rules — Always Include

**DO:**
- Parse the email text to extract **each individual enquiry** as a separate item
- For each enquiry, determine the **PDTF path** it relates to using the schema skeleton (see pdtf-path-resolver skill or `{{SKILL_DIR}}/references/schema-skeleton.md`)
- Present the extracted enquiries in a numbered table: number, enquiry text, proposed PDTF path, confidence
- **Ask the user to confirm** the path mappings before pushing to MCP — path resolution is a best-effort match
- When pushing via MCP, use `raise_enquiry` with the enquiry text, resolved `pdtfPath`, and `externalIds`
- Always set `externalIds` to link back to the source — e.g. `{"email": "<message-id>", "reference": "SJ/2024/1234"}` for email, `{"leap": "ENQ-12345"}` for CMS. This prevents duplicate enquiries when continuations arrive.
- If the email contains a participant name/firm, extract that for the `from` field
- Preserve the original enquiry wording — don't paraphrase

**DON'T:**
- Don't push enquiries without user confirmation of the path mappings
- Don't merge multiple enquiries into one — each numbered point is a separate enquiry
- Don't strip context that makes the enquiry meaningful (e.g. "further to our search results" is useful context)
- Don't invent responses — this skill is for *receiving and logging* enquiries, not answering them

## Workflow

### Step 1: Parse the Email

User pastes email text. Extract:
- **Sender details:** firm name, conveyancer name, reference number
- **Individual enquiries:** split on numbering, bullet points, or clear topic boundaries
- **Context:** any preamble that applies to all enquiries (e.g. "with reference to the title register...")

### Step 2: Map to PDTF Paths

For each enquiry, determine the most relevant PDTF path. Common mappings:

| Enquiry Subject | PDTF Path |
|----------------|-----------|
| Lease/ground rent | `/propertyPack/ownership/ownershipsToBeTransferred` |
| Building works/alterations | `/propertyPack/alterationsAndChanges/*` |
| Planning permission | `/propertyPack/alterationsAndChanges/planningPermissionBreaches` |
| Boundaries | `/propertyPack/legalBoundaries` |
| Flooding | `/propertyPack/environmentalIssues/flooding` |
| Title restrictions | `/propertyPack/titlesToBeSold` |
| Rights of way | `/propertyPack/rightsAndInformalArrangements` |
| Drainage/services | `/propertyPack/waterAndDrainage` |
| Occupiers | `/propertyPack/occupiers` |
| Covenants | `/propertyPack/titlesToBeSold` |

If unsure, mark as "needs manual mapping" and suggest the user check with `describe_form_path`.

### Step 3: Confirm with User

Present:
```
Extracted 8 enquiries from Smith & Jones (ref: SJ/2024/1234):

 #  Enquiry                                          Path                                    Confidence
 1  "Please confirm the remaining lease term..."     /propertyPack/ownership/...              High
 2  "Was planning permission obtained for the..."    /propertyPack/alterationsAndChanges/...   High  
 3  "We note a restriction on the title..."          /propertyPack/titlesToBeSold              High
 4  "Please clarify the drainage arrangements..."    /propertyPack/waterAndDrainage/drainage   Medium
 ...

Shall I push these to the transaction? (I'll use raise_enquiry for each)
```

### Step 4: Push to MCP

On confirmation:
```
Call: raise_enquiry(transactionId, message, pdtfPath, from, externalIds) × N
```

Report: "8 enquiries logged. The seller's conveyancer will see these in their transaction."

## Example Input

```
Dear Sirs,

Re: 14 Oakwood Terrace, Bristol BS6 7QP — Our client: Mr James Harrison

We write further to receipt of the contract pack and raise the following additional enquiries:

1. Please confirm the remaining lease term and provide a copy of the lease.
2. We note from the TA6 that a rear extension was carried out in 2019. Please confirm whether building regulations approval was obtained and provide the completion certificate.
3. The environmental search indicates the property is in Flood Zone 2. Please confirm whether the seller has experienced any flooding and provide details of any flood insurance claims.
4. We note a restrictive covenant on the title prohibiting alterations to the front elevation. Please confirm this has not been breached by the replacement windows.
5. Please provide details of the management company including current service charge levels and any planned major works.

We look forward to hearing from you.

Yours faithfully,
Sarah Chen
Smith & Jones Solicitors
```
