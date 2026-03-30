# Architecture — How It All Fits Together

## Three layers

```
┌─────────────────────────────────────────────────────┐
│                    AI Agent                          │
│        (Claude Code / Cowork / OpenClaw)             │
│                                                      │
│  Reads SKILL.md → understands capabilities →         │
│  calls tools → presents results                      │
└───────────┬──────────────┬──────────────┬───────────┘
            │              │              │
    ┌───────▼───────┐ ┌────▼────────┐ ┌───▼──────────┐
    │  Standalone   │ │   PDTF      │ │   Moverly    │
    │   Tools       │ │  Connector  │ │ Intelligence │
    │               │ │             │ │              │
    │ • SDLT calc   │ │ • Standard  │ │ • get_insights│
    │ • Lender HB   │ │   protocol  │ │ • get_queue  │
    │ • Protocols   │ │ • Any MCP   │ │ • handle_flag│
    │ • Lease impact│ │   server    │ │ • risk_history│
    │ • Citations   │ │ • Claims,   │ │ • Report on  │
    │               │ │   vouch,    │ │   Title      │
    │               │ │   enquiries │ │              │
    └───────────────┘ └──────┬──────┘ └──────┬───────┘
                             │               │
                    ┌────────▼───────────────▼────────┐
                    │   PDTF-compliant MCP Server     │
                    │                                  │
                    │  Moverly · NPTN · others          │
                    └──────────┬───────────────────────┘
                               │
                    ┌──────────▼──────────┐
                    │   PDTF State        │
                    │                     │
                    │ • Verified claims    │
                    │ • Full provenance   │
                    │ • Role-based access  │
                    │ • Evidence chains   │
                    └─────────────────────┘
```

## Standalone tools

These run entirely within the AI agent — no external API, no account needed. They're self-contained instructions and scripts that the agent reads and executes.

**How they work:**
1. Agent reads `SKILL.md` — this is the instruction manual
2. SKILL.md tells the agent what it can do, what inputs it needs, and how to present results
3. Some skills include helper scripts (e.g. `sdlt-calc.sh` for deterministic calculations)
4. Some include reference data (e.g. `references/lenders/*.md` for Part 2 requirements)

**Examples:** SDLT calculator, lender pre-screen, lease impact advisor, protocol checklists, property law reference.

## PDTF Connector

The PDTF MCP specification defines a standard protocol for property transaction data. Any system that implements it — Moverly, NPTN, or others — can be connected using this skill. This is the industry standard layer.

**12 standard tools:**

| Category | Tools | Purpose |
|----------|-------|---------|
| Transaction data | `list_transactions`, `get_state`, `get_status`, `get_claims`, `get_provenance` | Read transaction data |
| Data submission | `vouch`, `upload_document` | Write verified data |
| Schema | `describe_path`, `list_overlays` | PDTF schema introspection |
| Enquiries | `raise_enquiry`, `list_enquiries`, `respond_enquiry` | Pre-contract enquiry management |

**Connection:** Single endpoint using Streamable HTTP transport. Authentication via Personal Access Token (PAT) in the Authorization header.

**How it works:**
1. Agent initialises MCP connection (JSON-RPC handshake)
2. Agent discovers available tools via `tools/list`
3. Agent calls tools with structured arguments
4. Server validates input, checks role-based access, returns structured JSON with full provenance

The PDTF Connector is server-agnostic. Set the endpoint URL and PAT for whichever PDTF-compliant system you're connecting to.

## Moverly Intelligence

Moverly's proprietary layer on top of the PDTF standard. These tools only work with Moverly's MCP server and require a Moverly API token.

**7 proprietary tools:**

| Tool | Purpose |
|------|---------|
| `get_insights` | Diligence Engine risk flags — 37 categories, 323 checks, 2,215 deterministic scenarios |
| `get_queue` | Document processing pipeline status (classification, AI summarisation, claims extraction) |
| `get_risk_history` | Historical risk timeline for a transaction |
| `handle_flag` | Mark a flag as accepted, mitigated, or escalated |
| `get_form_progress` | Seller form completion status (flag-based validation system) |
| `describe_form_path` | Form-specific schema filtered by transaction overlay, with question reference numbers |
| Report on Title | Generated from DE flags + PDTF state (uses report-on-title skill) |

### Diligence Engine

The core intelligence — a deterministic rule engine. Not an LLM. Not probabilistic. Every scenario has a defined set of inputs, conditions, and outputs.

**Key properties:**
- **Deterministic:** Same data → same flags, every time
- **Provenance:** Every flag includes `evidencePaths` (which PDTF claims were evaluated) and `legalContext` (the legal basis)
- **Evidence basis:** Each flag is classified as `data-driven`, `evidence-incomplete`, `no-data`, or `clear`
- **Actions:** Each flag includes recommended actions with `targetPath` and `canExecute` hints
- **<1ms evaluation** across all 37 categories

## PDTF (Property Data Trust Framework)

The data standard underpinning everything. PDTF defines the schema for structured property data — from addresses and title information to seller disclosures and search results.

**Key concepts:**
- **Claims:** Verified data points with provenance (who provided it, when, how it was verified)
- **State:** The composed view of all claims for a transaction (latest value per path)
- **Overlays:** Schema extensions that define which fields are required for specific contexts (e.g. TA6 Edition 6)
- **Terms of use:** Per-claim access control (public, restricted, confidential)

We're adding the MCP server specification to the PDTF standard — any platform that implements it will be compatible with this toolkit out of the box.

## Data flow: upload to resolution

```
Document uploaded via PDTF Connector
        │
        ▼
File classifier (AI) → determines document type         ┐
        │                                                │
        ▼                                                │
Document summariser (AI) → extracts structured data      │ Moverly
        │                                                │ Intelligence
        ▼                                                │
Claims mapper → writes PDTF claims with provenance       │
        │                                                │
        ▼                                                │
Diligence Engine re-evaluates all 37 categories          ┘
        │
        ▼
Flags updated (some resolved, some new)
        │
        ▼
Agent calls get_insights → sees updated risk picture
```

Upload is a PDTF standard operation. Everything that happens after — classification, summarisation, risk analysis — is Moverly's proprietary intelligence layer. The whole pipeline runs automatically within minutes.
