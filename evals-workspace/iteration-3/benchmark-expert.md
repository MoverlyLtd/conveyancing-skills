# SDLT Multi-Model Eval — Iteration 3

**Date:** 2026-04-02
**Test:** £510,000 FTB purchase (post-April 2025 rates)
**Correct answer:** £15,500 (no FTB relief above £500k, standard rates)

## Results

| Model | Tier | Without Skill | With Skill | Delta |
|-------|------|:---:|:---:|---|
| Claude Opus 4 | Frontier | ✅ £15,500 | ✅ £15,500 | Non-discriminating |
| GPT-5.4 Mini | Mid | ✅ £15,500 | ✅ £15,500 | Non-discriminating |
| GPT-5.2 | Older | ❌ £4,250 | ✅ £15,500 | **+£11,250** |
| Gemini 3 Flash | Mid | ❌ £4,250 | ✅ £15,500 | **+£11,250** |
| Gemini 2.5 Pro | Frontier | ❌ £4,250 | ✅ £15,500 | **+£11,250** |

## Key Findings

1. **3/5 models get it wrong without the skill** — including Gemini 2.5 Pro (a frontier model)
2. **5/5 models get it right with the skill** — the bash script enforces correct rates
3. **The error pattern is identical**: all use the temporary COVID-era thresholds (£625k cap, £425k nil band) that reverted on 1 April 2025
4. **Only models with very recent training cutoffs** (Opus 4, GPT-5.4 Mini) have the current rates
5. **The skill value proposition is clear**: rates change, training data doesn't

## Error Analysis

The stale models calculate:
- 0% on first £425,000 = £0 (should be £125,000 at 0%)
- 5% on £85,000 = £4,250 (should be £125k at 2% + £260k at 5%)
- Total: £4,250 (should be £15,500)

The client would be told they owe £4,250 when they actually owe £15,500. In a real transaction, this could cause:
- Completion day cash shortfall
- Failed completions
- Professional negligence claims
- Interest and penalties on late SDLT returns

## Recommendation

Upgrade SDLT skill to fetch current rates from GOV.UK at runtime, with baked-in rates as fallback. This guarantees correctness even if rates change between skill updates.
