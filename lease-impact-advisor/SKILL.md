---
name: lease-impact-advisor
description: Assess leasehold property saleability and mortgage impact. Use when an estate agent or property professional asks about lease length impact, whether a lease is too short, which lenders will accept a lease, lease extension costs, marriage value, or saleability of a leasehold property. Also triggers on questions about short leases, lease expiry, buyer pool restrictions, or price impact of lease length.
---

# Lease Impact Advisor

## Response Rules — Always Include

**DO:**
- When discussing lease extension for leases ABOVE 80 years: always state that **no marriage value applies** (marriage value only kicks in below 80 years per Leasehold Reform Act 1993)
- Always mention **specific lender thresholds** by name — not just "most lenders require X". Key: Halifax 70yr, Nationwide 55yr, Barclays 70yr, Santander 55yr
- When the lease is above most lender thresholds: always note that extension is **still worthwhile for future value protection** (lease continues to depreciate; extending now is cheaper than later)
- Always discuss **all lease extension options**: statutory Section 42 claim (90-year extension, ground rent to peppercorn), informal/voluntary negotiation, and assigning the benefit of the claim to the buyer

**DON'T:**
- Don't claim marriage value applies for leases above 80 years — it only applies below 80
- Don't say "lenders typically require 70+ years" without naming specific lenders
- Don't treat safe-for-lending leases as requiring no action — always advise on future value protection

Assess the impact of lease length on property saleability, mortgage availability, and value — from an estate agent's perspective.

## When to use

- Estate agent valuing or listing a leasehold property
- Vendor asking whether to extend before marketing
- Buyer asking about mortgage availability on a short lease
- Anyone asking "will this lease length be a problem?"

## Required inputs

Ask the user for:
1. **Current unexpired lease term** (years remaining) — REQUIRED
2. **Property value** (£) — needed for extension cost estimate
3. **Mortgage term** (years, default 25) — for lender eligibility
4. **Property type** — flat or house (affects some lender rules)

If the user only gives years remaining, provide the saleability assessment and lender summary. Ask for property value if they want extension cost estimates.

## Assessment process

### Step 1: Run the calculator

```bash
bash scripts/lease-calc.sh <years_remaining> [property_value] [mortgage_term]
```

This returns: risk band, lender eligibility, extension cost estimate, and saleability impact.

### Step 2: Interpret for the audience

Frame everything from the estate agent's perspective — saleability, buyer pool, pricing impact.

**DO NOT** give legal advice. Frame recommendations as "your conveyancer should advise on..." or "we'd recommend discussing with a specialist lease extension solicitor."

### Step 3: Lender eligibility detail

Cross-reference years remaining against lender thresholds. For each major lender, state clearly: ELIGIBLE, MARGINAL (may need referral), or INELIGIBLE.

If years remaining minus mortgage term is the binding constraint, say so: "With a 25-year mortgage, the lease would have [X] years at redemption — below [Lender]'s minimum of [Y] years at end of term."

### Step 4: Extension guidance

If extension is advisable, explain:
- **Statutory route** (Section 42 notice) — requires 2 years ownership, adds 90 years, reduces ground rent to peppercorn
- **Informal route** — negotiate with freeholder, no ownership requirement, terms negotiable
- **Assign benefit** — seller starts statutory process, assigns to buyer on completion
- **Cost components**: diminution in landlord's interest + 50% marriage value (if under 80 years) + landlord's costs
- **Leasehold and Freehold Reform Act 2024** — now law but not fully in force. Marriage value is set to be abolished but hasn't taken effect yet. Advise based on current law.

## Risk bands

| Band | Years remaining | Impact |
|------|----------------|--------|
| **GREEN** | 90+ years | No impact. All lenders accept. Full buyer pool. |
| **AMBER** | 80–89 years | Most lenders accept but approaching thresholds. No marriage value. Recommend extending before it drops below 80. |
| **RED** | 70–79 years | Marriage value applies. Buyer pool restricted. Some lenders decline. Price discount 5-15%. Extension strongly advised before marketing. |
| **CRITICAL** | Under 70 years | Most lenders decline. Severe buyer pool restriction — cash buyers or specialist lenders only. Price discount 15-30%+. Extension essential. |
| **UNMORTGAGEABLE** | Under 55 years | Virtually no mainstream lenders. Cash buyers only. Significant price discount. Some properties become functionally unsaleable without extension. |

## Lender thresholds (Part 2 data)

These are the minimum unexpired lease terms from the UK Finance Lender's Handbook Part 2. The script has these built in, but for reference:

| Lender | Minimum at completion | End-of-term requirement | Notes |
|--------|----------------------|------------------------|-------|
| Nationwide | 55 years (90 for >85% LTV second-hand flat) | 30 years at end of term | Most flexible mainstream |
| NatWest | No fixed minimum | Mortgage term + 30 years | Effectively ~55 for 25yr mortgage |
| HSBC | 50 years after mortgage term | Must refer if <85 years | Subject to valuer opinion |
| Barclays | 70 years | — | Prestige London estates may get discretion |
| Halifax | 70 years | — | — |
| Lloyds | 70 years | — | — |
| TSB | 70 years | 30 years at end of term | — |
| Santander | Varies | 30 years (repayment), 50 years (interest-only) at end | Complex — must refer if <82 years |
| Coventry BS | 70 years (80 for lifetime/equity release) | — | — |
| Virgin Money | 85 years | — | Must extend before completion if shorter |

## Key legal context

- **Marriage value**: applies when lease is under 80 years. Leaseholder pays freeholder 50% of the increase in property value from the extension. Can add thousands to the cost. Set to be abolished by Leasehold and Freehold Reform Act 2024 but NOT YET in force.
- **Two-year rule**: statutory right to extend (Section 42) requires 2 years ownership. Informal negotiation has no such requirement.
- **Ground rent**: new leases post-June 2022 must be peppercorn. Existing ground rent provisions (especially doubling clauses) affect lender appetite. Draft Leasehold and Commonhold Reform Bill proposes £250 cap.
- **Building Safety Act 2022**: qualifying leaseholders in buildings over 11m may have protections against remediation costs. Doesn't directly affect lease length but affects overall lender appetite.
