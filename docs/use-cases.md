# Use Cases — What You Can Do With This

Real workflows, not feature lists. Each example is a conversation you'd have with Claude, Cursor, or any AI tool with the toolkit loaded.

---

## 1. Lease impact assessment at instruction

**You say:**
> I'm valuing a flat with 68 years on the lease. It's worth about £425,000. What's the saleability picture?

**What happens:**
The AI runs the Lease Impact Advisor:

> **LEASE IMPACT ASSESSMENT — 68 years, £425,000**
>
> **Risk band: [CRITICAL]** — Most mainstream lenders decline. Cash buyers or specialist lenders only.
>
> **Lender eligibility:** 6 of 13 major lenders accept (Nationwide, NatWest, Santander, Yorkshire BS, Skipton BS, Leeds BS). 7 decline (Barclays, Halifax, Lloyds, HSBC, TSB, Coventry BS, Virgin Money).
>
> **Price impact:** Estimated 15-30% discount vs equivalent freehold — roughly £63,750-£127,500 off achievable price.
>
> **Extension cost:** £42,500-£88,000 including professional fees. Marriage value applies (lease is under 80 years).
>
> **Recommendation:** Extension essential before marketing. Three routes available: statutory (Section 42, requires 2 years ownership, adds 90 years), informal negotiation (faster, no ownership requirement), or assign benefit to buyer.

**What you tell the vendor:** "We can list this, but the short lease significantly limits who can buy it. Only about half of mainstream lenders will accept it, which means fewer mortgage buyers and lower offers. I'd strongly recommend starting a lease extension before we go to market."

**Time saved:** An hour of handbook checking → 15 seconds.

---

## 2. Lender pre-screen

**You say:**
> My buyer wants a leasehold flat, 72 years on the lease, £280k. They're first-time buyers on a 25-year mortgage. Which lenders will work?

**What happens:**
The AI checks Part 2 requirements for each major lender:

> | Lender | Verdict | Reason |
> |--------|---------|--------|
> | Nationwide | ✅ | 55-year minimum. 72 years passes. |
> | NatWest | ✅ | Requires term + 30 years. 72 − 25 = 47, exceeds 30. |
> | Santander | ⚠️ | Eligible but complex rules — refer if under 82 years. |
> | Barclays | ⚠️ | 70-year minimum — close to threshold, may need referral. |
> | Halifax | ⚠️ | 70-year minimum — marginal. |
> | HSBC | ❌ | Requires 75 years at completion. |
> | Virgin Money | ❌ | Requires 85 years at completion. |
>
> **Summary:** 6 eligible, 5 marginal, 2 ineligible. Nationwide, NatWest, and Santander are your cleanest options.

Then for each eligible lender, the Lenders Handbook Pre-Screen runs through the full Part 1 requirements, cross-referenced with that lender's Part 2 answers — flagging what needs reporting and what can be certified.

**Time saved:** 2-3 hours of manual handbook checking → seconds.

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

The calculation uses deterministic scripts with rates verified daily against GOV.UK — not model memory that may be months out of date.

---

## 4. Combined workflow

The real power is combining skills in a single conversation:

**You say:**
> I've got a new instruction — leasehold flat, 72 years on the lease, £425,000. First-time buyer, 25-year mortgage with Nationwide. Give me the full picture: lease impact, lender eligibility, SDLT, and flag anything that needs attention.

The AI chains all three skills and returns a single briefing covering saleability risk, lender compatibility, tax liability, and recommended next steps — with named thresholds and specific reasoning for each point.

That's what we mean by the agentic transformation of conveyancing. Not replacing professional judgment — equipping it.
