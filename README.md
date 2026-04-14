# Conveyancing Toolkit

The open-source AI toolkit for UK residential conveyancing. Free forever.

Built and maintained by [Moverly](https://moverly.com). Open to contributions from everyone.

---

## What this is

A growing collection of AI-ready skills that give conveyancers, estate agents, and property professionals instant access to structured property intelligence through Claude, Cursor, or any AI platform that supports skills.

Every skill in this toolkit is **free, open source, and MIT-licensed**.

We believe the conveyancing profession deserves better tools. We're building them in the open — and we're just getting started.

## Skills

| Skill | What it does |
|-------|-------------|
| **[SDLT Calculator](sdlt-calculator/)** | Stamp Duty Land Tax — standard, first-time buyer, additional property, non-UK resident. Deterministic script with live rate updates. [3 out of 5 models get SDLT wrong without this skill.](#why-skills-not-model-knowledge) |
| **[Lease Impact Advisor](lease-impact-advisor/)** | Saleability assessment for leasehold properties — risk banding, lender eligibility matrix (13 major lenders), extension cost estimates, marriage value analysis. |
| **[Lenders Handbook Pre-Screen](lenders-handbook-prescreen/)** | Full UK Finance Lender's Handbook Part 1 (90+ checks, 24 categories) plus Part 2 requirements for 67 individual lenders. |

More skills are coming. We want to build SDLT edge-case handling, search report analysers, protocol compliance checkers, building regulations advisors, restrictive covenant tools, and dozens more.

If you know what's missing, [tell us](https://github.com/MoverlyLtd/conveyancing-toolkit/issues). Better yet, [build it with us](#contributing).

## Quick start

### Claude / Claude Code

```bash
git clone https://github.com/MoverlyLtd/conveyancing-toolkit.git

# Then ask Claude:
# "Calculate SDLT on a £425,000 purchase for a first-time buyer"
# "This property has 72 years on the lease — which lenders will lend?"
# "Pre-screen this property against Nationwide's Part 2 requirements"
```

### Cursor

Add the toolkit as a workspace, then ask questions naturally. Cursor will read the SKILL.md files and use the reference data and scripts automatically.

### Any MCP-compatible platform

Point your agent at the skill directories. Each skill has a `SKILL.md` that the agent reads for instructions, plus `scripts/` for deterministic calculations and `references/` for structured data.

## Why skills, not model knowledge

AI models are trained on data that goes stale. Tax rates change on budget day. Lender thresholds change quarterly. Protocol editions get updated.

When we tested SDLT calculations across five leading models, **three out of five got it wrong** on a straightforward first-time buyer purchase — the same wrong answer of £4,250 instead of the correct £15,500:

| Model | Without Skill | With Skill |
|-------|:---:|:---:|
| Claude Opus 4 | ✅ £15,500 | ✅ £15,500 |
| GPT-5.4 Mini | ✅ £15,500 | ✅ £15,500 |
| GPT-5.2 | ❌ £4,250 | ✅ £15,500 |
| Gemini 3 Flash | ❌ £4,250 | ✅ £15,500 |
| Gemini 2.5 Pro | ❌ £4,250 | ✅ £15,500 |

Skills fix this because they use deterministic scripts with live-updated data, not model memory. When rates change, the skill is updated once and every user gets the correct answer immediately.

The pattern holds across the toolkit. For lease assessments and lender requirements, models give plausible general advice ("most lenders require 70-80 years") but miss the specific thresholds that practitioners need (Nationwide accepts 55 years — one of the most permissive major lenders — while Virgin Money requires 85).

## Contributing

We want this to become the profession's toolkit. That means it needs more than just Moverly's perspective.

**What we'd love to see:**

- 📋 **Practice checklists** — your pre-exchange checklist, completion workflow, new-build process
- 📊 **Calculators** — apportionment, completion statement, key dates
- 🏛️ **Regulatory tools** — SRA compliance, CLC requirements, LSAG guidance
- 🔧 **CMS integrations** — connectors for LEAP, Clio, Osprey, Proclaim
- 📚 **Reference materials** — curated legal references, practice notes, worked examples

**How to contribute:**

1. Fork this repo
2. Create your skill directory with a `SKILL.md`
3. Add helper scripts in `scripts/` and reference data in `references/`
4. Submit a PR

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

Every contribution stays MIT-licensed and free forever.

## Our promise

This toolkit will always be free and open source. Better tools for conveyancers benefits everyone.

## About

Built and maintained by [Moverly](https://moverly.com) · [Documentation](docs/) · [MIT License](LICENSE)
