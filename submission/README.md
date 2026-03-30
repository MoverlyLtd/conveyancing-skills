# UK Conveyancing Toolkit

The open-source AI toolkit for UK residential conveyancing. Free forever, MIT licensed.

Built and maintained by [Moverly](https://moverly.com). Open to contributions from everyone.

This toolkit will always be free and open source. Better tools for conveyancers benefits everyone.

## Three layers

### Standalone tools (no setup required)

| Tool | What it does |
|------|-------------|
| `sdlt-calculator` | Stamp Duty Land Tax — standard, first-time buyer, additional property, non-UK resident |
| `lenders-handbook-prescreen` | Full UK Finance Lender's Handbook Part 1 pre-screen (90+ checks, 24 categories) plus Part 2 data for 60+ lenders |
| `lender-comparison` | Compare lender requirements simultaneously — spawns parallel agents, returns suitability matrix |
| `lease-impact-advisor` | Leasehold saleability assessment — risk banding, lender eligibility for 13 major lenders, extension cost estimates, marriage value analysis |
| `conveyancing-protocol-checklist` | Law Society Conveyancing Protocol compliance checklists |
| `ca-protocol-compliance` | Conveyancing Association Protocol (5th Edition) compliance tracking with legal thresholds |
| `cqs-practice-standards` | CQS practice management standards for SRA-regulated firms |
| `clc-compliance-tracker` | CLC regulatory compliance for Council of Licensed Conveyancers firms |
| `property-law-reference` | Curated directory of 100+ authoritative legal sources with fetch-and-cite instructions |

### PDTF Connector (any compliant MCP server)

The PDTF MCP specification defines a standard protocol for property transaction data. This connector works with any system that implements it — Moverly, NPTN, or others.

| Tool | What it does |
|------|-------------|
| `pdtf-connector` | Transaction data, PDTF state, verified claims, provenance, vouch, document upload, schema queries, form progress, enquiry management |

### Moverly Intelligence (proprietary)

| Tool | What it does |
|------|-------------|
| `moverly-diligence` | Deterministic risk analysis — 37 categories, 323 checks, 2,215 scenarios. Document processing status, risk history, flag management |
| `report-on-title` | Generate buyer's conveyancer Reports on Title from verified data and risk flags |

## About

Built on the [Property Data Trust Framework (PDTF)](https://github.com/property-data-standards-co/schemas) — the UK's emerging standard for structured property data, and live implementations of those standards like the National Property Transaction Network, already carrying thousands of transactions between participants.

## Source

[github.com/MoverlyLtd/conveyancing-toolkit](https://github.com/MoverlyLtd/conveyancing-toolkit)

## License

MIT — free forever.
