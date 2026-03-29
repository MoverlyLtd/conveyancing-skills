# Use Cases — What Conveyancers Actually Do With This

Real workflows, not feature lists. Each example is a conversation you'd have with Claude.

---

## 1. Morning caseload review

**You say:**
> I've got 35 active purchases. What needs my attention today?

**What happens:**
Claude connects to Moverly, pulls your transaction list, filters to data-driven flags at risk 4+, and gives you a prioritised briefing:

> You have 3 transactions that need attention this morning:
>
> **12 Maple Drive, BS3** — [critical] Very short lease (62 years). Lender requires minimum 70 at completion. Lease extension notice needed before exchange. Your seller's conveyancer hasn't responded to the enquiry raised on Thursday.
>
> **Flat 8, Victoria Court, BA1** — [high] Building regulations certificate missing for 2023 bathroom refit. Document request sent to seller — still waiting. Consider indemnity as fallback if not received by Friday.
>
> **27 Church Lane, GL7** — [moderate] Environmental search shows former industrial use within 250m. Contaminated land assessment recommended. 3 documents uploaded overnight and classified — search results now incorporated.
>
> The other 32 are on track. 4 had flags resolve overnight from document uploads.

**Time saved:** 45 minutes of checking each transaction manually → 30 seconds.

---

## 2. Lender pre-screen before recommending a mortgage

**You say:**
> My client wants to buy a leasehold flat, 72 years on the lease, ex-council, £280k. They're first-time buyers looking at 90% LTV. Which of the main lenders will have a problem with this?

**What happens:**
Claude spawns parallel subagents to check Part 2 requirements for the top 10 lenders simultaneously:

> | Lender | Verdict | Key issue |
> |--------|---------|-----------|
> | Nationwide | ⚠️ | Requires 55 years unexpired at end of mortgage term. At 72 years with a 25yr term, you'd have 47 years. **Fails.** |
> | Halifax | ✅ | Min 70 years at completion. 72 passes. Ex-LA accepted. |
> | Barclays | ✅ | Min 70 years. Accepted. |
> | HSBC | ⚠️ | Requires 70 years at end of term. 72 - 25 = 47. **Fails.** |
> | Santander | ✅ | Min 55 years at end of term with 25yr mortgage = 47 years. **Borderline — check.** |
> | NatWest | ✅ | Min 30 years beyond mortgage term. 72 - 25 = 47, needs 55. **Fails.** |
> | ...
>
> **Summary:** 4 of 10 lenders have issues with this lease length. Halifax, Barclays, and Lloyds are your cleanest options. Consider advising your client to negotiate a lease extension as a condition of purchase — it would open up all lenders.

**Time saved:** 2-3 hours of manual handbook checking → 15 seconds.

---

## 3. SDLT calculation with scenarios

**You say:**
> Calculate SDLT on £425,000. My client is a first-time buyer. Also show me what it would be if they weren't, and if they already owned another property.

**What happens:**

> | Scenario | SDLT | Effective rate |
> |----------|------|---------------|
> | First-time buyer | £6,250 | 1.47% |
> | Standard purchase | £11,250 | 2.65% |
> | Additional property (+5%) | £32,500 | 7.65% |
>
> **FTB relief saves your client £5,000.** The property is under the £500,000 FTB cap so full relief applies. First £300,000 at 0%, remainder at 5%.

---

## 4. Pre-exchange protocol compliance check

**You say:**
> I'm about to exchange on 15 Birch Avenue. Run through the CA Protocol checklist — what have I missed?

**What happens:**
Claude pulls the transaction state from Moverly and audits against the CA Protocol 5th Edition:

> **CA Protocol Compliance — 15 Birch Avenue**
>
> ✅ **Identity verification** — Digital ID verified for both seller and buyer
> ✅ **Pre-sale preparation** — Title, searches, property info all in contract pack
> ✅ **Signed contracts** — Both parties signed
> ✅ **Deposit** — 10% confirmed, held by seller's solicitor
>
> ⚠️ **Section 4.0 — Extensions & alterations:** The rear extension has planning permission but building regulations approval shows "Not known." CA Protocol requires either: (a) building regs certificate, (b) completion certificate from local authority, or (c) indemnity insurance if works are 10+ years old. Works completed 2019 — **indemnity route available.** Consider obtaining before exchange.
>
> ⚠️ **Section 1.10 — Completion arrangements:** Code for Completion by post not yet confirmed with other side. CA Protocol recommends confirming at least 5 working days before completion.
>
> ❌ **Section 2.5 — Proportionality of retentions:** £500 retention proposed for missing garden boundary fence. CA Protocol says rely on Standard Conditions rather than retentions under £200. At £500 the retention is proportionate, but **document the justification.**

---

## 5. Overnight document processing

**You say (Friday evening):**
> I've received the environmental search, local authority search, and drainage search for 22 Oak Street. Upload and analyse them.

**What happens:**
Claude uploads all three documents via Moverly MCP. The classification and extraction pipeline runs automatically. By Monday morning:

> **Weekend processing complete — 22 Oak Street:**
>
> 📄 **Environmental search** — Classified, extracted, 3 flags updated:
> - Flood Zone 1 (low risk) → flag resolved ✅
> - No contaminated land entries → flag resolved ✅
> - Radon affected area (intermediate probability) → [moderate] new flag raised, recommend radon test
>
> 📄 **Local authority search** — Classified, extracted, 5 flags updated:
> - No planning enforcement notices → 2 planning flags resolved ✅
> - Tree Preservation Order on front garden oak → [low] new flag, inform buyer
> - Smoke control area → noted, no action needed
>
> 📄 **Drainage search** — Classified, extracted:
> - Mains drainage confirmed → drainage flag resolved ✅
> - Public sewer within 3m of rear extension → [moderate] Build-over agreement may be needed
>
> **Net result:** 5 flags resolved, 2 new flags raised. Outstanding data-driven flags dropped from 8 to 5.

---

## 6. Drafting enquiry responses

**You say:**
> The buyer's solicitor has raised an enquiry about the loft conversion building regs. My client says it was done in 2018 and they don't have the certificate. Draft a response.

**What happens:**

> **Draft enquiry response — Loft conversion building regulations**
>
> The loft conversion was carried out in 2018. Our client does not hold a building regulations completion certificate for these works.
>
> We note that as the works were completed more than 6 years ago, enforcement action by the local authority under section 36 of the Building Act 1984 is statute-barred (the limitation period being 12 months from completion of non-compliant work, with a longstop of 6 years for latent defects under the Limitation Act 1980).
>
> We are instructed to offer indemnity insurance to cover the residual risk. A policy is available at a one-off premium of approximately £80-150, to be provided prior to completion.
>
> Please confirm whether your client and their lender are content to proceed on this basis, or whether they require any further information.
>
> *Source: CA Protocol 4.0 — the 10-year threshold for building regulations enforcement applies to works post-1985. Works completed 2018 are within the 10-year window but statute-barred under the 6-year limitation period for enforcement proceedings.*

---

## 7. Report on Title generation

**You say:**
> Generate a Report on Title for 14 Oakwood Terrace for my client Sarah Chen.

**What happens:**
Claude pulls the full PDTF state and DE flags, maps to the standard report template, and generates a comprehensive report covering title, searches, property information, encumbrances, and risk flags — all cited to verified data sources. Your firm's template and tone are used. You review, amend where professional judgment applies, and send.

**Time saved:** 3-4 hours of manual drafting → 20 minutes of review and refinement.
