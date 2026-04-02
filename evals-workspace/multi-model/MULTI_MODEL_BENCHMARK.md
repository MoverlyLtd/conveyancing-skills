# Conveyancing Toolkit — Multi-Model Benchmark

**Judge model:** claude-sonnet-4-20250514
**Date:** 2026-04-02

## Model Comparison (averaged across all evals)

| Model | With Skill | Baseline | Δ | Skill Helps? |
|-------|:----------:|:--------:|:-:|:------------:|
| Claude 3 Haiku | 75% | 31% | +44% | ✅ Yes |
| Claude Sonnet 4 | 100% | 41% | +59% | ✅ Yes |
| Gemini 3 Flash | 100% | 65% | +35% | ✅ Yes |
| GPT-5.2 | 98% | 57% | +41% | ✅ Yes |
| GPT-5.4 Mini | 100% | 49% | +51% | ✅ Yes |

## Skill × Model Matrix (with_skill score)

| Skill | Claude 3 Haiku | Claude Sonnet 4 | Gemini 3 Flash | GPT-5.2 | GPT-5.4 Mini |
|-------|:---:|:---:|:---:|:---:|:---:|
| ca-protocol-compliance | 90% | 100% | 100% | 100% | 100% |
| clc-compliance-tracker | 65% | 100% | 100% | 100% | 100% |
| conveyancing-protocol-checklist | 100% | 100% | 100% | 100% | 100% |
| cqs-practice-standards | 64% | 100% | 100% | 100% | 100% |
| lease-impact-advisor | 82% | 100% | 100% | 100% | 100% |
| lenders-handbook-prescreen | 80% | 100% | 100% | 100% | 100% |
| property-law-reference | 80% | 100% | 100% | 100% | 100% |
| sdlt-calculator | 40% | 100% | - | 80% | 100% |

## Skill × Model Matrix (baseline score)

| Skill | Claude 3 Haiku | Claude Sonnet 4 | Gemini 3 Flash | GPT-5.2 | GPT-5.4 Mini |
|-------|:---:|:---:|:---:|:---:|:---:|
| ca-protocol-compliance | 22% | 22% | 65% | 45% | 32% |
| clc-compliance-tracker | 25% | 45% | 64% | 74% | 45% |
| conveyancing-protocol-checklist | 50% | 100% | 75% | 100% | 75% |
| cqs-practice-standards | 64% | 74% | 74% | 90% | 82% |
| lease-impact-advisor | 36% | 54% | 100% | 84% | 74% |
| lenders-handbook-prescreen | 20% | 20% | 80% | 30% | 30% |
| property-law-reference | 0% | 0% | 0% | 0% | 0% |
| sdlt-calculator | 20% | 0% | 0% | 0% | 40% |

## Skill × Model Delta (with_skill − baseline)

| Skill | Claude 3 Haiku | Claude Sonnet 4 | Gemini 3 Flash | GPT-5.2 | GPT-5.4 Mini |
|-------|:---:|:---:|:---:|:---:|:---:|
| ca-protocol-compliance | 🟢 +68% | 🟢 +78% | 🟢 +35% | 🟢 +55% | 🟢 +68% |
| clc-compliance-tracker | 🟢 +40% | 🟢 +55% | 🟢 +36% | 🟢 +26% | 🟢 +55% |
| conveyancing-protocol-checklist | 🟢 +50% | 🔴 +0% | 🟢 +25% | 🔴 +0% | 🟢 +25% |
| cqs-practice-standards | 🔴 +0% | 🟢 +26% | 🟢 +26% | 🟡 +10% | 🟢 +18% |
| lease-impact-advisor | 🟢 +45% | 🟢 +46% | 🔴 +0% | 🟢 +16% | 🟢 +26% |
| lenders-handbook-prescreen | 🟢 +60% | 🟢 +80% | 🟢 +20% | 🟢 +70% | 🟢 +70% |
| property-law-reference | 🟢 +80% | 🟢 +100% | 🟢 +100% | 🟢 +100% | 🟢 +100% |
| sdlt-calculator | 🟢 +20% | 🟢 +100% | - | 🟢 +80% | 🟢 +60% |

## Recommendations

Skills to **keep** (consistent positive delta across models):
Skills to **improve** (positive delta on some models, not others):
Skills to **remove or rework** (zero or negative delta):

*Review delta matrix above to populate these categories.*

