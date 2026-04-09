---
name: enquiry-renderer
description: Render current open enquiries from a Moverly transaction as formatted text suitable for sending to the other side's conveyancer. Use when a conveyancer needs to send outstanding enquiries to the seller's solicitor, or wants a summary of what's still unanswered.
---

# Enquiry Renderer

Render open enquiries from MCP as professional text ready to send.

## Response Rules — Always Include

**DO:**
- Fetch enquiries using `list_enquiries` from MCP
- Filter to show only **open/unanswered** enquiries by default (user can request all)
- Group enquiries by PDTF category (title, alterations, environment, etc.) for readability
- Number enquiries sequentially for easy reference
- Include any previous messages in the enquiry thread as context
- Format as a professional letter/email ready to copy-paste
- Include a header with property address, transaction reference, and date
- Add "chaser" language for enquiries that have been open longer than a configurable threshold

**DON'T:**
- Don't include internal notes or DE flag details — this is external-facing text
- Don't include PDTF paths in the output — conveyancers don't use PDTF terminology
- Don't reword the original enquiry — preserve the original text

## Workflow

### Step 1: Fetch Enquiries

```
Call: list_enquiries(transactionId: "<id>", status: "open")
```

### Step 2: Organise and Format

Group by subject area, number sequentially:

```
Dear [Seller's Conveyancer],

Re: [Address] — Our client: [Buyer name]

We write regarding the following outstanding enquiries on the above property:

Title & Ownership
1. [Original enquiry text]
2. [Original enquiry text]

Alterations & Building Works  
3. [Original enquiry text]

Environmental
4. [Original enquiry text]

We should be grateful for your early response to enable us to progress this matter.

Yours faithfully,
[Buyer's conveyancer details]
```

### Step 3: Chaser Mode

If enquiries have been open for more than 7 working days (configurable), add chaser language:

> "We note that enquiries 1, 3 and 4 were first raised on [date] and remain unanswered. We would appreciate your urgent attention to these matters as our client is anxious to proceed."

### Options

- `--all` — include answered enquiries too (with responses shown)
- `--chaser` — force chaser language regardless of age
- `--format letter|email|list` — output format (default: email)
- `--group-by category|date|priority` — grouping strategy
