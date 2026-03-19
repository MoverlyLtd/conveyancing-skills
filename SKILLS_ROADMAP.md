# Skills Roadmap

## Published ✅

| Skill | Type | Status |
|-------|------|--------|
| `sdlt-calculator` | Standalone | ✅ Live — 20/20 tests, rates from 1 Apr 2025 |
| `moverly-connect` | Moverly | ✅ Live — MCP connection, transaction listing |
| `moverly-diligence` | Moverly | ✅ Live — risk flags, evidence filtering |

## Next Up 🔨

### Standalone Checklists
| Skill | Description | Complexity |
|-------|-------------|------------|
| `pre-exchange-checklist` | Everything before exchange: searches, enquiries, mortgage offer, deposit, insurance, completion date, report on title, contract | Low |
| `post-completion-checklist` | SDLT return (14 days), LR application (priority period), notice to landlord, management co, utility transfers | Low |
| `new-build-checklist` | NHBC/warranty, CML new-build requirements, snagging, longstop date, reservation agreement | Low |

### Standalone Calculators & Tools
| Skill | Description | Complexity |
|-------|-------------|------------|
| `leasehold-calculator` | Lease extension costs (marriage value, capitalisation rates, deferment rates), statutory vs voluntary routes, ground rent escalation | Medium |
| `key-dates-calculator` | SDLT filing deadline, LR priority periods, search expiry, exchange-to-completion timeline | Low |
| `completion-statement-checker` | Verify completion statement maths: purchase price ± adjustments, apportionments, fees | Medium |

### Standalone Intelligence
| Skill | Description | Complexity |
|-------|-------------|------------|
| `lender-prescreen` | Flag common Part 1 handbook issues from property data alone — short lease, non-standard construction, knotweed, flood zone 3, missing EWS1, restrictive covenants | Medium |
| `hmlr-explainer` | Explain title register entries — restriction types (Form A/J/K), charge entries, classes of title, easement/covenant implications | Low |
| `search-pack-guide` | What each property search covers, when to order extras, what results mean | Low |

### Moverly-Connected (Phase 2+)
| Skill | Description | Complexity |
|-------|-------------|------------|
| `moverly-enquiries` | Raise and respond to pre-contract enquiries via MCP | Medium |
| `moverly-documents` | Upload docs, monitor processing, retrieve structured data | Medium |
| `moverly-lender-check` | Full lender-specific evaluation — property + borrower + Part 2 rules via DE | Medium |
| `moverly-portfolio` | Caseload dashboard — risk overview across all active transactions | Low |

### CMS Integration Skills
| Skill | Description | Complexity |
|-------|-------------|------------|
| `leap-connector` | Push/pull case data from Leap Legal Software | High — needs API research |
| `proclaim-connector` | Push/pull case data from Proclaim (Eclipse) | High — needs API research |
| `osprey-connector` | Push/pull case data from Osprey Approach | High — needs API research |
| `land-registry-portal` | Interact with HMLR Business Gateway / Portal | High — needs API research |

## Ideas / Backlog 💡

- Conveyancing quiz / training skill (test knowledge of process)
- AML/IDV checklist
- Chain management tracker
- Contract review assistant (flag unusual clauses)
- Stamp duty for Scotland (LBTT) and Wales (LTT)
- Commercial property SDLT (different rates)
- Ground rent analyser (escalation clauses, peppercorn conversion)

## Design Principles

1. **Deterministic over probabilistic** — if there's a calculation, write a script
2. **Standalone first** — build trust without requiring a Moverly account
3. **Agent-native** — write for AI agents, not human developers
4. **Accurate and sourced** — cite legislation, effective dates, official sources
5. **Self-contained** — no external dependencies beyond standard shell tools

---
*Last updated: 2026-03-19*
