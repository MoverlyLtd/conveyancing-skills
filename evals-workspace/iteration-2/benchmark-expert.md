# Conveyancing Toolkit — Eval Benchmark (Iteration 2)

**Date:** 2026-04-02
**Method:** Expert grading of with-skill vs baseline responses

## Results Summary

| ID | Skill | With Skill | Baseline | Delta | Key Discriminator |
|----|-------|-----------|----------|-------|-------------------|
| 11 | sdlt-calculator | 5/5 ✅ | 5/5 ✅ | 0 | Both correct on £500k cap — non-discriminating at this price |
| 4 | lease-impact-advisor | 6/6 ✅ | 4/6 🟡 | +2 | Specific lender table (6/13 eligible by name), £63k-£127k discount range |
| 5 | lease-impact-advisor | 5/5 ✅ | 3/5 🟡 | +2 | GREEN band correct, 13/13 eligible; baseline overstates risk as "moderate" |
| 6 | lenders-handbook-prescreen | 5/5 ✅ | 3/5 🟡 | +2 | HB §5.14.1, §5.5.1-5.5.2, s.36 Building Act time bar, reporting decision tree |
| 7 | ca-protocol-compliance | 5/5 ✅ | 3/5 🟡 | +2 | CA §4.0 with 4yr enforcement window; baseline gives general PD/indemnity |
| 8 | ca-protocol-compliance | 4/4 ✅ | 2/4 🟡 | +2 | Cites CA §1.0, 1.2, 2.0, 2.4; baseline gives generic "10 working days" |
| 9 | conveyancing-protocol-checklist | 4/4 ✅ | 2/4 🟡 | +2 | Stage B/C structure with paragraph refs; baseline gives general checklist |
| 10 | property-law-reference | 4/5 ✅ | 4/5 ✅ | 0 | Both cite s.84 LPA 1925, PG19; skill adds live URLs, baseline adds case law |

## Aggregate Scores

- **With skill:** 38/39 = **97%** (±5%)
- **Baseline:** 26/39 = **67%** (±18%)  
- **Delta:** **+31%**

## Key Findings

### 1. Script-based skills (SDLT) — small delta
Claude's training data already includes post-April 2025 rates. The £510k FTB cap test (eval 11) was NOT discriminating — baseline also knows the £500k cap. Need to find rates that have changed more recently or edge cases (e.g., mixed-use, shared ownership) for better discrimination.

### 2. Reference/protocol skills — large delta (+2 on every eval)
This is where skills shine. Baseline gives plausible general advice but:
- Never cites specific protocol section numbers
- Doesn't structure by protocol stages (A, B, C)
- Misses enforcement timelines (4yr/10yr/12mo)
- Gives "most lenders" instead of named lenders with thresholds
- Doesn't include the reporting decision tree

### 3. Lease impact advisor — strong delta
The specific lender eligibility table with named banks and exact minimum terms is a clear quality leap. Baseline says "most high-street lenders will decline" — skill says "6/13 eligible: Nationwide, NatWest, Santander, Yorkshire BS, Skipton BS, Leeds BS."

### 4. Property law reference — marginal
Baseline's legal training is strong on case law and statutes. Skill adds live URLs but baseline adds case law names. May need more esoteric prompts to differentiate.

## Recommendations

1. **Drop SDLT from benchmark** — insufficient discrimination for standard cases
2. **Add edge-case SDLT eval** — shared ownership, mixed-use, corporate purchase
3. **Weight reference/protocol evals higher** — these show the real skill value
4. **Add lender-specific eval** — "Will Halifax lend on a 72-year lease?" (skill has scraped Part 2 data)
5. **Add multi-step workflow eval** — "Complete a full pre-exchange protocol audit" to test structured guidance
