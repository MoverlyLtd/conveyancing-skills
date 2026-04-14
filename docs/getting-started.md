# Getting Started

Setup takes about 2 minutes.

## Option 1: Claude Code / Claude

```bash
git clone https://github.com/MoverlyLtd/conveyancing-toolkit.git
cd conveyancing-toolkit
```

Then start Claude and ask a question:

```
"Calculate SDLT on a £510,000 first-time buyer purchase"
"I have a flat with 72 years on the lease, worth £425,000. What's the impact?"
"Pre-screen a 72-year lease against Nationwide's Part 2 requirements"
```

Claude reads the `SKILL.md` files automatically and uses the scripts and reference data.

## Option 2: Cursor

1. Open the `conveyancing-toolkit` directory as a workspace in Cursor
2. Ask questions naturally — Cursor reads the skill files and uses them

## Option 3: Any AI tool that supports skills/custom instructions

Each skill has:
- `SKILL.md` — instructions the AI reads to understand the task
- `scripts/` — deterministic calculation scripts (bash/python)
- `references/` — structured data files (lender thresholds, rates, checklists)

Point your AI tool at the relevant skill directory.

## What's included

| Skill | What it does |
|-------|-------------|
| **sdlt-calculator** | SDLT for all buyer types. Deterministic script, rates verified daily against GOV.UK. |
| **lease-impact-advisor** | Saleability assessment, lender eligibility across 13 major lenders, extension cost estimates. |
| **lenders-handbook-prescreen** | Part 1 checklist (90+ checks) plus Part 2 data for 67 lenders. |

No API key. No account. No configuration. Just clone and ask.
