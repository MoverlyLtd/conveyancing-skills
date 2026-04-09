# Contributing to Conveyancing Toolkit

Thank you for helping build better tools for conveyancing. Every contribution makes AI more useful for the profession.

## The basics

1. **Fork** this repo
2. **Create** your tool in `your-tool-name/`
3. **Test** it by using it with an AI agent
4. **Submit** a pull request

## Tool structure

Every tool needs a `SKILL.md` — the instruction file that AI agents read:

```
your-tool-name/
├── SKILL.md              # Required — the agent reads this
├── scripts/              # Optional — helper scripts for deterministic work
│   └── calculate.sh
└── references/           # Optional — reference data loaded on demand
    └── rates.md
```

### SKILL.md format

```markdown
---
name: your-tool-name
description: What it does and when to use it. Be specific — this is how agents find your tool.
---

# Your Tool Name

Instructions for the agent...
```

The `description` field is critical. Include all trigger phrases an agent might match on.

### Guidelines

- **Keep SKILL.md under 500 lines.** Move detailed content to `references/`.
- **Be imperative.** "Calculate the tax" not "You might want to calculate the tax."
- **Don't trust LLM maths.** Use bash scripts for calculations.
- **Include error handling.** Tell the agent what to do when inputs are missing or invalid.
- **Test by using.** Install your tool and try real tasks. Fix where the agent gets confused.

## What makes a good contribution

- **Useful on day one.** A conveyancer should be able to use it immediately.
- **Accurate.** Legal and regulatory content must be correct. Cite sources.
- **Maintained.** If requirements change (tax rates, regulations), updates are needed.
- **Self-contained.** Standalone tools should work without external accounts.

## Types of contributions we're looking for

### CMS integrations
Connectors for practice management systems — LEAP, Clio, Osprey, Proclaim. Even read-only matter listing would be valuable.

### Checklists and workflows
Firm-specific or general checklists: pre-exchange, post-completion, new-build, remortgage, transfer of equity. The more specific the better.

### Calculators
Apportionment calculators, completion statement checkers, key dates calculators, service charge estimators.

### Regulatory tools
SRA compliance checks, AML procedure guides, specialist area workflows (leasehold enfranchisement, commercial, agricultural).

### Reference materials
Curated legal references with fetch-and-cite instructions. Not copied text — URLs and guidance on what to look for.

## Licensing

All contributions are MIT-licensed. By submitting a PR, you agree your contribution will be available under the MIT licence, free forever.

We will never relicense contributions or put them behind a paywall.

## Code of conduct

Be professional. Be helpful. Remember that the people using these tools are handling some of the most important transactions of their clients' lives.

## Questions?

Open an issue or reach out at [ed@moverly.com](mailto:ed@moverly.com).
