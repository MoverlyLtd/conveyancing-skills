# Conveyancing Toolkit

The open-source AI toolkit for UK residential conveyancing. Free forever.

Built and maintained by [Moverly](https://moverly.com). Open to contributions from everyone.

---

## What this is

A collection of AI-ready tools that give conveyancers, estate agents, and property professionals instant access to structured property intelligence through Claude, OpenClaw, or any AI platform that supports the Model Context Protocol.

Every tool in this toolkit is **free, open source, and MIT-licensed**. The standalone tools work without any account or API key. The Moverly-connected tools require a Moverly API token for live transaction intelligence.

We believe the conveyancing profession deserves better tools. We're building them in the open and we want your help.

## Tools

### Standalone — works immediately, no setup

| Tool | What it does |
|------|-------------|
| **SDLT Calculator** | Stamp Duty Land Tax — standard, first-time buyer, additional property, non-UK resident. Deterministic bash script, no LLM maths. |
| **Lender Pre-Screen** | Full UK Finance Lender's Handbook Part 1 (90+ checks, 24 categories) plus Part 2 requirements for 60+ individual lenders. |
| **Lender Comparison** | Compare requirements across multiple lenders simultaneously — spawns parallel agents, returns a suitability matrix in seconds. |
| **Law Society Protocol** | Conveyancing Protocol compliance checklists by stage. |
| **CA Protocol** | Conveyancing Association Protocol (5th Edition) — the most transaction-specific compliance tool. |
| **CQS Standards** | CQS Core Practice Management Standards for SRA-regulated firms. |
| **CLC Compliance** | Council of Licensed Conveyancers regulatory framework tracker. |
| **Lease Impact Advisor** | Saleability assessment for leasehold properties — risk banding, lender eligibility matrix (13 lenders), extension cost estimates, marriage value analysis. The estate agent's "should we list this?" tool. |
| **Property Law Reference** | Curated directory of 100+ authoritative sources — GOV.UK, HMLR Practice Guides, LEASE Advisory Service, Law Commission reports. Fetch-and-cite, not hallucinate. |

### Moverly-connected — live transaction intelligence

These tools connect to Moverly's MCP server for real-time, verified property intelligence. They require a [Moverly](https://moverly.com) API token.

| Tool | What it does |
|------|-------------|
| **Moverly Connect** | Transaction data, PDTF state, verified claims with full provenance. |
| **Moverly Diligence** | Risk flags from the Diligence Engine (37 categories, 323 checks, 2,215 scenarios), evidence trails, pre-contract enquiry management. |
| **Moverly Upload** | Upload case documents for automated classification, extraction, and risk analysis. |
| **Report on Title** | Generate buyer's conveyancer Reports on Title from verified transaction data and risk flags. |

## Quick start

### Claude Code

```bash
# Clone and point Claude at any tool
git clone https://github.com/MoverlyLtd/conveyancing-toolkit.git

# Then ask Claude:
# "Calculate SDLT on a £425,000 purchase for a first-time buyer"
# "Pre-screen this property against Nationwide's Part 2 requirements"
# "Run a CA Protocol compliance check"
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
- **[Use Cases](docs/use-cases.md)** — 7 real workflows with examples
- **[Conveyancer Journey](docs/conveyancer-journey.md)** — a complete purchase, start to finish
- **[Architecture](docs/architecture.md)** — how the layers fit together
- **[MCP Reference](docs/mcp-reference.md)** — all 19 Moverly MCP tools
- **[Authentication](docs/authentication.md)** — PAT, OAuth, platform configs
- **[Building Tools](docs/building-skills.md)** — create your own
- **[FAQ](docs/faq.md)** — common questions

## Contributing

We want this to become the industry standard toolkit for AI-assisted conveyancing. That means it needs more than just Moverly's perspective.

**What we'd love to see:**

- 🔧 **CMS integrations** — connectors for LEAP, Clio, Osprey, Proclaim, or any other practice management system
- 📋 **Firm-specific checklists** — your pre-exchange checklist, your completion checklist, your new-build workflow
- 📊 **Calculators** — apportionment calculators, completion statement checkers, key dates calculators
- 🏛️ **Regulatory tools** — SRA compliance, LSAG guidance, specialist area checklists (new-build, leasehold enfranchisement, commercial)
- 🔗 **Platform integrations** — search providers (InfoTrack, SearchFlow), identity verification, Land Registry
- 📚 **Reference materials** — curated legal references, practice notes, worked examples

**How to contribute:**

1. Fork this repo
2. Create your tool in `skills/your-tool-name/SKILL.md`
3. Add helper scripts in `scripts/` and reference data in `references/` if needed
4. Submit a PR

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

Every contribution stays MIT-licensed and free forever. No contributor agreements, no relicensing. What you give stays open.

## Our promise

This toolkit will always be free and open source. Better tools for conveyancers benefits everyone.

## About

The toolkit is built on the [Property Data Trust Framework (PDTF)](https://github.com/property-data-standards-co/schemas) — the UK's emerging standard for structured property data, already carrying thousands of transactions through the National Property Transaction Network (NPTN).

Moverly's Diligence Engine provides the intelligence layer — a deterministic rule engine that evaluates property risk across 37 categories, producing consistent, auditable results with full evidence provenance. Not an LLM. Not probabilistic. Every scenario has defined inputs, conditions, and outputs.

Built and maintained by [Moverly](https://moverly.com) · [Documentation](docs/) · [MIT License](LICENSE)
