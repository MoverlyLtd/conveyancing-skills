# Conveyancing Toolkit

The open-source AI toolkit for UK residential conveyancing. Free forever.

Built and maintained by [Moverly](https://moverly.com). Open to contributions from everyone.

---

## What this is

A collection of AI-ready tools that give conveyancers, estate agents, and property professionals instant access to structured property intelligence through Claude, OpenClaw, or any AI platform that supports the Model Context Protocol.

Every tool in this toolkit is **free, open source, and MIT-licensed**.

We believe the conveyancing profession deserves better tools. We're building them in the open and we want your help.

## Tools

### Standalone — works immediately, no setup

| Tool | What it does |
|------|-------------|
| **SDLT Calculator** | Stamp Duty Land Tax — standard, first-time buyer, additional property, non-UK resident. Deterministic script with live rate updates. [3 out of 5 models get SDLT wrong without this tool.](#why-skills-not-model-knowledge) |
| **Lender Pre-Screen** | Full UK Finance Lender's Handbook Part 1 (90+ checks, 24 categories) plus Part 2 requirements for 60+ individual lenders. |
| **Lender Comparison** | Compare requirements across multiple lenders simultaneously — spawns parallel agents, returns a suitability matrix in seconds. |
| **Lease Impact Advisor** | Saleability assessment for leasehold properties — risk banding, lender eligibility matrix (13 lenders), extension cost estimates, marriage value analysis. |
| **AML Source of Funds** | Per-element evidence requirements, SAR obligations, record-keeping periods. |
| **Building Regulations** | Approval routes, enforcement timelines, competent person schemes, the "before any approach" rule. |
| **Restrictive Covenant Advisor** | s84 LPA 1925 grounds, indemnity insurance, modification applications, visibility risk assessment. |

### PDTF Connector — standard property data

The PDTF MCP specification defines a standard protocol for property transaction data. Any system that implements it — Moverly, NPTN, or others — can be connected using this skill.

| Tool | What it does |
|------|-------------|
| **PDTF Connector** | Transaction data, PDTF state, verified claims, provenance, vouch, document upload, schema queries, form progress, enquiry management. Works with any PDTF-compliant MCP server. |

### Moverly Intelligence — proprietary risk analysis

These tools connect to Moverly's proprietary diligence engine. They require a [Moverly](https://moverly.com) API token.

| Tool | What it does |
|------|-------------|
| **Moverly Diligence** | Risk flags from the Diligence Engine (37 categories, 323 checks, 2,215 scenarios), document processing status, risk history, flag management. |
| **Report on Title** | Generate buyer's conveyancer Reports on Title from verified transaction data and diligence engine risk flags. |

## The three layers

```
┌─────────────────────────────────────────────────────────┐
│  Standalone Tools          No connection needed          │
│  SDLT · Lender Pre-Screen · Protocol Checklists · ...   │
├─────────────────────────────────────────────────────────┤
│  PDTF Connector            Any compliant MCP server     │
│  Claims · Provenance · Vouch · Upload · Enquiries       │
├─────────────────────────────────────────────────────────┤
│  Moverly Intelligence      Proprietary                  │
│  Risk Flags · Processing Queue · Risk History · RoT     │
└─────────────────────────────────────────────────────────┘
```

The **PDTF Connector** speaks the industry standard. We're adding the MCP server specification to the PDTF standard — any platform that implements it (Moverly, NPTN, or new entrants) will be compatible with this toolkit out of the box.

**Moverly Intelligence** is the proprietary layer on top. Deterministic risk analysis across 37 categories using 2,215 rule-based scenarios, with full evidence provenance and commercial impact analysis. Not an LLM. Not probabilistic.

## Quick start

### Claude Code

```bash
# Clone and point Claude at any tool
git clone https://github.com/MoverlyLtd/conveyancing-toolkit.git

# Then ask Claude:
# "Calculate SDLT on a £425,000 purchase for a first-time buyer"
# "Pre-screen this property against Nationwide's Part 2 requirements"
# "This property has 68 years on the lease — what's the impact on saleability?"
```

### OpenClaw

```bash
# Install individual tools
npx clawhub@latest install moverly/sdlt-calculator
npx clawhub@latest install moverly/lenders-handbook-prescreen
```

### Any MCP-compatible platform

Point your agent at the `skills/` directory. Each tool has a `SKILL.md` that the agent reads for instructions.

## Documentation

- **[Getting Started](docs/getting-started.md)** — 2-minute setup
- **[Use Cases](docs/use-cases.md)** — 8 real workflows with examples
- **[Conveyancer Journey](docs/conveyancer-journey.md)** — a complete purchase, start to finish
- **[Architecture](docs/architecture.md)** — how the layers fit together
- **[MCP Reference](docs/mcp-reference.md)** — all MCP tools
- **[Authentication](docs/authentication.md)** — PAT, OAuth, platform configs
- **[Building Tools](docs/building-skills.md)** — create your own
- **[FAQ](docs/faq.md)** — common questions

## Contributing

We want this to become the industry standard toolkit for AI-assisted conveyancing. That means it needs more than just Moverly's perspective.

**What we'd love to see:**

- 🔧 **CMS integrations** — connectors for LEAP, Clio, Osprey, Proclaim, or any other practice management system
- 📋 **Firm-specific checklists** — your pre-exchange checklist, your completion checklist, your new-build workflow
- 📊 **Calculators** — apportionment calculators, completion statement checkers, key dates calculators
- 🏛️ **Regulatory tools** — SRA compliance, LSAG guidance, specialist area checklists
- 🔗 **Platform integrations** — search providers, identity verification, Land Registry
- 📚 **Reference materials** — curated legal references, practice notes, worked examples
- 🌐 **PDTF implementations** — if you're building a PDTF-compliant MCP server, contribute a connector profile

**How to contribute:**

1. Fork this repo
2. Create your tool in `your-tool-name/SKILL.md`
3. Add helper scripts in `scripts/` and reference data in `references/` if needed
4. Submit a PR

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

Every contribution stays MIT-licensed and free forever.

## Why skills, not model knowledge

AI models are trained on data that goes stale. Tax rates change on budget day. Lender thresholds change quarterly. Protocol editions get updated. When we tested SDLT calculations across five models, **three out of five got it £11,250 wrong** on a straightforward first-time buyer purchase — including frontier models — because their training data still had the old temporary thresholds.

| Model | Without Skill | With Skill |
|-------|:---:|:---:|
| Claude Opus 4 | ✅ £15,500 | ✅ £15,500 |
| GPT-5.4 Mini | ✅ £15,500 | ✅ £15,500 |
| GPT-5.2 | ❌ £4,250 | ✅ £15,500 |
| Gemini 3 Flash | ❌ £4,250 | ✅ £15,500 |
| Gemini 2.5 Pro | ❌ £4,250 | ✅ £15,500 |

Skills guarantee correctness because they use deterministic scripts with live-updated rate configurations, not model memory. When rates change, the skill is updated once and every user gets the correct answer immediately — no retraining, no waiting for the next model release.

For reference and protocol skills, the delta is even larger. Models give plausible general advice but miss specific section numbers, enforcement timelines, and named lender thresholds that practitioners need. Our evals show a **+31% improvement** when skills are used.

## Our promise

This toolkit will always be free and open source. Better tools for conveyancers benefits everyone.

## About

The toolkit is built on the [Property Data Trust Framework (PDTF)](https://github.com/property-data-standards-co/schemas) — the UK's emerging standard for structured property data, and live implementations of those standards like the National Property Transaction Network, already carrying thousands of transactions between participants.

Built and maintained by [Moverly](https://moverly.com) · [Documentation](docs/) · [MIT License](LICENSE)
