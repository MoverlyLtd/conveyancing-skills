# UK Conveyancing

Property intelligence and compliance skills for UK residential conveyancing.

## What's included

### Standalone tools (no setup required)

| Skill | What it does |
|-------|-------------|
| `/uk-conveyancing:sdlt-calculator` | Calculate Stamp Duty Land Tax — standard, first-time buyer, additional property, non-UK resident |
| `/uk-conveyancing:lenders-handbook-prescreen` | Exhaustive UK Finance Lender's Handbook Part 1 pre-screen (90+ checks, 24 categories) plus Part 2 data for 60+ lenders |
| `/uk-conveyancing:conveyancing-protocol-checklist` | Law Society Conveyancing Protocol compliance checklists |
| `/uk-conveyancing:ca-protocol-compliance` | Conveyancing Association Protocol (5th Edition) compliance tracking |
| `/uk-conveyancing:cqs-practice-standards` | CQS practice management standards for SRA-regulated firms |
| `/uk-conveyancing:clc-compliance-tracker` | CLC regulatory compliance for Council of Licensed Conveyancers firms |

### Parallel intelligence (subagent-powered)

| Skill | What it does |
|-------|-------------|
| `/uk-conveyancing:lender-comparison` | Compare lender requirements across multiple lenders simultaneously — spawns parallel subagents to check each lender's Part 2, returns a suitability matrix |

### Moverly-connected intelligence (requires Moverly API access)

| Skill | What it does |
|-------|-------------|
| `/uk-conveyancing:moverly-connect` | Connect to Moverly's property intelligence MCP server — transaction data, PDTF state, claims, provenance |
| `/uk-conveyancing:moverly-diligence` | Risk intelligence, evidence provenance, and pre-contract enquiry management |
| `/uk-conveyancing:moverly-upload` | Upload case documents for automated diligence analysis |
| `/uk-conveyancing:report-on-title` | Generate buyer's conveyancer Reports on Title from verified transaction data |

## Who this is for

- **Conveyancers** — protocol compliance, lender pre-screening, risk analysis
- **Estate agents** — transaction monitoring, portfolio risk overview
- **Legal tech teams** — property intelligence integration via Moverly MCP
- **Anyone buying property in England & Wales** — SDLT calculations, understanding risk flags

## About Moverly

[Moverly](https://moverly.com) builds property intelligence infrastructure for the UK residential market. Our deterministic diligence engine evaluates 37 risk categories across 323 checks and 2,215 scenarios, providing verified, provenanced risk analysis for every transaction.

The standalone skills in this plugin work without any Moverly account. The connected skills require a Moverly API token — see [moverly.com](https://moverly.com) for access.

## Source

[github.com/MoverlyLtd/conveyancing-skills](https://github.com/MoverlyLtd/conveyancing-skills)

## License

MIT
