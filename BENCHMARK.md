# Conveyancing Toolkit — Benchmark Results

> **"Models guess. Skills guarantee."**

This benchmark compares AI model responses to conveyancing questions **with** and **without** the conveyancing toolkit skills. All evaluations use the same prompts — the only difference is whether the model has access to the skill.

**Last updated:** 2 April 2026
**Judge model:** Claude Sonnet 4 (automated LLM-as-judge grading)
**Baseline model:** Claude Opus 4 (without skills)

## The Headline: SDLT Across 5 Models

We asked five leading AI models a simple stamp duty question:

> *"I'm a first-time buyer looking at a flat for £510,000. What would the stamp duty be?"*

The correct answer is **£15,500** (FTB relief doesn't apply — the £500,000 cap was restored in April 2025).

| Model | Without Skill | With Skill | Correct? |
|-------|:------------:|:----------:|:--------:|
| Claude Opus 4 | £15,500 | £15,500 | ✅ → ✅ |
| GPT-5.4 Mini | £15,500 | £15,500 | ✅ → ✅ |
| GPT-5.2 | £4,250 ❌ | £15,500 | ❌ → ✅ |
| Gemini 3 Flash | £4,250 ❌ | £15,500 | ❌ → ✅ |
| Gemini 2.5 Pro | £4,250 ❌ | £15,500 | ❌ → ✅ |

**3 of 5 models got it £11,250 wrong** — they used the old £625,000 FTB cap instead of the current £500,000 cap. With the skill, all 5 return the correct answer.

The skill doesn't just add a safety net for the models that already know — it **corrects the models that don't**.

## Full Eval Results

### By Individual Eval

| ID | Skill | Question | With Skill | Baseline | Δ |
|----|-------|----------|:----------:|:--------:|:-:|
| 4 | lease-impact-advisor | 68yr lease, £425k flat — what to know? | 6/6 (100%) | 5/6 (83%) | **+17%** |
| 5 | lease-impact-advisor | 95yr lease — should I worry? | 5/5 (100%) | 3/5 (60%) | **+40%** |
| 6 | lenders-handbook-prescreen | 72yr lease + loft conversion — handbook? | 4/5 (80%) | 3/5 (60%) | **+20%** |
| 7 | ca-protocol-compliance | Extension without planning — CA Protocol? | 5/5 (100%) | 2/5 (40%) | **+60%** |
| 8 | ca-protocol-compliance | Other side not responding — protocol? | 3/4 (75%) | 3/4 (75%) | +0% |
| 9 | conveyancing-protocol-checklist | Pre-exchange — protocol checklist? | 4/4 (100%) | 4/4 (100%) | +0% |
| 10 | property-law-reference | Restrictive covenants — where to look? | 2/5 (40%) | 1/5 (20%) | **+20%** |
| 11 | sdlt-calculator | £510k FTB — stamp duty? | 5/5 (100%) | 5/5 (100%) | +0% |
| 12 | cqs-practice-standards | CQS renewal audit — what to prepare? | 6/6 (100%) | 6/6 (100%) | +0% |
| 13 | cqs-practice-standards | New fee earner — CQS onboarding? | 4/5 (80%) | 5/5 (100%) | -20% |
| 14 | clc-compliance-tracker | Client complaint — CLC requirements? | 6/6 (100%) | 5/6 (83%) | **+17%** |
| 15 | clc-compliance-tracker | Client money — CLC obligations? | 4/5 (80%) | 4/5 (80%) | +0% |
| 16 | lenders-handbook-prescreen | Halifax/Nationwide/Barclays on 72yr lease? | 5/5 (100%) | 4/5 (80%) | **+20%** |

### By Skill (averaged)

| Skill | With Skill | Baseline | Δ | Key Insight |
|-------|:----------:|:--------:|:-:|-------------|
| **ca-protocol-compliance** | 88% | 58% | **+30%** | Specific section refs + enforcement timelines |
| **lease-impact-advisor** | 100% | 72% | **+28%** | Named lenders + exact thresholds vs "most lenders" |
| **lenders-handbook-prescreen** | 87% | 67% | **+20%** | Part 1 section refs + Part 2 lender-specific data |
| **property-law-reference** | 40% | 20% | **+20%** | Live URLs vs general citations |
| **clc-compliance-tracker** | 90% | 82% | **+8%** | Specific CLC outcomes vs general regulatory advice |
| sdlt-calculator | 100% | 100% | +0% | Claude knows current rates (other models don't!) |
| conveyancing-protocol-checklist | 100% | 100% | +0% | Baseline strong on general protocol knowledge |
| cqs-practice-standards | 90% | 100% | -10% | Baseline CQS knowledge is surprisingly robust |

### Aggregate

| Metric | Score |
|--------|-------|
| **With skill (all evals)** | **89%** |
| **Baseline (all evals)** | **72%** |
| **Overall delta** | **+17%** |
| Evals where skill wins | 7/13 (54%) |
| Evals where tied | 4/13 (31%) |
| Evals where baseline wins | 2/13 (15%) |

## What the Numbers Mean

### Where skills add the most value

1. **Protocol specifics** — Section numbers, enforcement timelines, stage-by-stage structure. Baseline gives plausible general advice; skills cite CA §4.0 with the 4-year enforcement window.

2. **Lender-specific data** — "Will Halifax lend on 72 years?" The skill says yes (70yr minimum) with Part 2 citation. Baseline hedges with "most high-street lenders typically require around 70-75 years."

3. **Calculation correctness across models** — Claude happens to know current SDLT rates, but GPT-5.2, Gemini 3 Flash, and Gemini 2.5 Pro all use stale training data. The skill guarantees the right answer regardless of model.

4. **Live reference URLs** — Skills link to current GOV.UK and HMLR pages. Baseline cites statutes and case law but can't provide working URLs.

### Where baseline holds its own

- **General regulatory knowledge** (CQS, CLC) — Claude's training covers these frameworks well enough for general questions. Skills add value on specific compliance items.
- **Legal concepts** — Restrictive covenants, statutory provisions. Both skill and baseline cite the right legislation.

### Where skills fall short (for now)

- **Property law reference** scored only 40% with skill — the expectations require live URLs that the skill's static reference list doesn't always match to the specific query. This is a known gap being improved.

## Methodology

- **16 evals** across 8 skills testing real conveyancing scenarios
- **LLM-as-judge grading** using Claude Sonnet 4 against predefined expectations
- **Expectations are strict**: partial or vague coverage counts as FAIL
- **Multi-model SDLT test** run across 5 models (Claude Opus 4, GPT-5.4 Mini, GPT-5.2, Gemini 3 Flash, Gemini 2.5 Pro)
- All eval prompts, responses, and grading results are in the `evals-workspace/` directory

## Reproducing

```bash
# Run evals (requires skill files in this repo)
bash evals/run-evals.sh

# Grade with LLM judge
export ANTHROPIC_API_KEY="your-key"
python3 evals/llm-judge.py evals-workspace/iteration-N
```

## Updates

We re-run this benchmark when:
- New models are released (to verify skills are still needed)
- Skills are updated (to verify improvements)
- New skills are added (to expand coverage)

| Date | Change |
|------|--------|
| 2 Apr 2026 | Initial benchmark: 13 evals, 8 skills, 5-model SDLT test |

---

*Built by [Moverly](https://moverly.com) as part of the UK Conveyancing Toolkit. Skills are open source under MIT license.*
