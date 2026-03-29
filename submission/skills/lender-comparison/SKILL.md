---
name: lender-comparison
description: >
  Compare lender requirements across multiple lenders for a specific property.
  Spawns parallel subagents to check each lender's Part 2 requirements simultaneously.
  Use when asked to compare lenders, check multiple lender requirements at once,
  find which lenders will accept a property, or produce a lender suitability matrix.
  Triggers on: 'compare lenders', 'which lenders', 'lender comparison', 'multi-lender check',
  'will [lender] accept', 'lender matrix', 'check all lenders', 'lender suitability'.
---

# Lender Comparison — Parallel Multi-Lender Check

## When to use

When the user wants to check a property against multiple lenders' requirements simultaneously. Much faster than checking one at a time.

## How it works

1. Gather property details from the user (or from Moverly MCP if connected)
2. Spawn parallel `lender-checker` subagents — one per lender
3. Collate results into a comparison matrix
4. Highlight which lenders pass, which have issues, and what the issues are

## Step 1: Gather property details

You need these details before spawning checkers. Ask the user for anything missing:

| Detail | Required | Example |
|--------|----------|---------|
| Property type | Yes | House, Flat, Maisonette, Bungalow |
| Tenure | Yes | Freehold, Leasehold |
| Lease remaining (if leasehold) | Yes | 68 years |
| Purchase price | Yes | £425,000 |
| Mortgage amount / LTV | Helpful | £340,000 / 80% LTV |
| New build? | Yes | Yes / No |
| Ex-local authority? | Helpful | Yes / No |
| Flying freehold? | Helpful | Yes / No / Partial |
| Known issues | Helpful | Short lease, Japanese knotweed, flood zone, etc. |

**If Moverly MCP is connected:** Call `moverly_get_state` and `moverly_get_insights` to auto-populate property details and known risk flags. This gives you a much richer property profile.

## Step 2: Select lenders

Ask which lenders to check. Common options:

**Tier 1 (top 10):** Nationwide, Halifax, Barclays, HSBC, Santander, NatWest, Lloyds, Virgin Money, TSB, Coventry BS

**Quick check:** "Check the top 10" → spawn 10 parallel agents

**Specific:** User names 2-5 lenders they're considering

## Step 3: Spawn parallel subagents

For each selected lender, spawn a `lender-checker` subagent with:
- The lender's Part 2 data (from `references/lenders/{slug}.md` in lenders-handbook-prescreen skill)
- The gathered property details

**Spawn them in parallel** — this is the whole point. Don't wait for one to finish before starting the next.

## Step 4: Collate and present

Once all subagents return, present a comparison matrix:

```
## Lender Suitability — 14 Oakwood Terrace, BS6 7QP

| Lender | Verdict | Issues | Key Concern |
|--------|---------|--------|-------------|
| Nationwide | ✅ Pass | 0 | — |
| Halifax | ⚠️ Issues | 2 | Lease < 70 years |
| Barclays | ⚠️ Issues | 1 | Lease < 75 years |
| HSBC | ❌ Fail | 3 | Min lease 70 years at end of term |
| Santander | ✅ Pass | 0 | — |

### Detail: Halifax
- **[5.14.2]** Unexpired lease term: requires 70 years at completion. Property has 68 years. **Report to lender.**
- **[6.7.1]** EPC rating: requires minimum D for new lending. Property is C. **Pass.**

### Detail: HSBC
...
```

## Tips

- If a user asks about a single lender, use the `lenders-handbook-prescreen` skill instead (no subagent needed)
- Maximum ~10 parallel agents is practical — beyond that, batch in groups
- If checking against Moverly flags, mention which DE flag triggered each lender concern
- Always note GAPS — things that couldn't be checked due to missing data
