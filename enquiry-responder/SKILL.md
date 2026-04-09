---
name: enquiry-responder
description: Handle enquiry responses — parse reply text from the other side's conveyancer and push responses to the correct enquiries via MCP. Use when a conveyancer receives a reply to their raised enquiries and wants to log each response against the original enquiry.
---

# Enquiry Responder

Parse enquiry reply text and push responses to the correct enquiries in Moverly.

## Response Rules — Always Include

**DO:**
- Match each response in the reply text to the **original enquiry** it answers — use numbering, quoting, or subject matching
- Present matches for user confirmation before pushing
- Use `respond_to_enquiry` MCP call with the matched enquiry key and response text. If the enquiry has `externalIds`, you can look it up using `externalSystem` + `externalId` instead of the PDTF key — useful when the CMS knows its own reference but not the PDTF key.
- If the reply text answers an enquiry AND provides new information (e.g. "planning permission was obtained, certificate attached"), flag this for potential vouching at the relevant PDTF path
- Identify any enquiries that were NOT answered in the reply and highlight them as still open
- If the reply raises NEW enquiries (counter-enquiries), extract those separately

**DON'T:**
- Don't push responses without confirming the match to the original enquiry
- Don't assume sequential numbering matches — conveyancers sometimes skip numbers or reorder
- Don't mark an enquiry as "answered" if the response is "we will revert" or "to follow" — that's a holding response, not an answer

## Workflow

### Step 1: Fetch Existing Enquiries

```
Call: list_enquiries(transactionId: "<id>")
```

Get the list of raised enquiries with their keys, text, and current status.

### Step 2: Parse the Reply

User pastes the reply text. Match each response to the original enquiry by:
1. **Numbering** — "In response to enquiry 3..."
2. **Quoting** — the reply restates or quotes the original
3. **Subject** — the reply discusses the same topic

### Step 3: Present Matches

```
Matched 6 of 8 enquiries:

 #  Original Enquiry                    Response                               Match
 1  "Confirm remaining lease term..."   "The lease has 87 years remaining..."  ✅ High
 2  "Building regs for extension..."    "Certificate enclosed as attachment"   ✅ High (+ vouch opportunity)
 3  "Flooding history..."               "No flooding has occurred..."          ✅ High
 4  "Restrictive covenant breach..."    "We will revert on this point"         ⚠️ Holding response
 5  "Management company details..."     [Not addressed in reply]               ❌ Still open
 6  "Service charge arrears..."         [Not addressed in reply]               ❌ Still open

2 enquiries not answered. 1 holding response.
Shall I push the 3 substantive responses?
```

### Step 4: Push Responses and Flag Actions

On confirmation:
```
Call: respond_to_enquiry(transactionId, enquiryKey, message) × N
```

For responses that contain new data (like enquiry 2 above — "certificate enclosed"):
- Flag for vouching: "Response to enquiry 2 mentions a building regs certificate. Upload and vouch at `/propertyPack/alterationsAndChanges/extension` to resolve the related DE flag."

### Step 5: Report Outstanding

After pushing:
```
Pushed 3 responses.

Still outstanding:
- Enquiry 4: Holding response — chase after 5 working days
- Enquiry 5: Management company — not addressed
- Enquiry 6: Service charge — not addressed

Shall I render a chaser for the outstanding items?
```

## Integration with Other Skills

- **enquiry-extractor**: extracts inbound enquiries → this skill handles the responses
- **enquiry-renderer**: renders outstanding enquiries for chasing
- **agentic-diligence**: the resolution loop may trigger enquiries that this skill then processes responses for
- **pdtf-path-resolver**: used to identify vouch opportunities from response content
