# Skills Roadmap

## Published ✅

| Skill | Type | Status |
|-------|------|--------|
| `sdlt-calculator` | Standalone | ✅ Live — rates from 1 Apr 2025, daily GOV.UK verification |
| `lease-impact-advisor` | Standalone | ✅ Live — risk bands, lender eligibility, marriage value |
| `lenders-handbook-prescreen` | Standalone | ✅ Live — Part 1 (90+ checks) + Part 2 (67 lenders) |
| `restrictive-covenant-advisor` | Standalone | ✅ Live — Hepworth v Pickles 20-year rule, indemnity, s.84 LPA 1925 |
| `title-defect-advisor` | Standalone | ✅ Live — HM Land Registry Official Copy Register analysis |

## Governance & guardrail skills 🛡️

Most skills here add **domain knowledge**. A second category adds **safety**: guardrail skills that check *how* the model is being used rather than answering a topic. Two are in draft:

| Skill | Type | Notes |
|-------|------|-------|
| Data-protection guard | Guardrail | Pre-flight PII / GDPR check that coaches (rather than punishes) when sensitive client data is about to be entered. It must *not* flag public-register data — proprietor names, price paid, a registered lease — only the client's own personal or financial details. |
| Safe-AI gate | Guardrail | Labels each answer by how it was produced — a validated tool, a cited source, or general model knowledge — and warns when a question would be better served by a validated skill. |

Guardrails are scored differently from advisory skills: on **precision/recall** over a labelled set that deliberately includes *negatives* (e.g. a title full of owner names that must not trip the guard), not on a single right answer. One honest caveat: a skill only runs when the host invokes it, so reliable always-on enforcement depends on the environment running it — an unenforced guardrail is a helpful coach, not a compliance control.

Contributions and test cases welcome.

## Planned 🔜

Skills we're building or actively considering. Contributions welcome on any of these.

| Skill | Type | Notes |
|-------|------|-------|
| Building Regulations Advisor | Standalone | Approval routes, enforcement timelines, competent person schemes |
| AML / Source of Funds | Standalone | Per-element evidence requirements, SAR obligations |
| Lender Comparison | Standalone | Side-by-side Part 2 comparison across multiple lenders |
| Search Report Analyser | Standalone | Local authority, environmental, drainage, mining search interpretation |
| Protocol Compliance Checker | Standalone | Law Society / CA Protocol step tracking |
| Completion Statement Calculator | Standalone | Apportionments, adjustments, net proceeds |
| Key Dates Calculator | Standalone | Exchange → completion timeline, search expiry, priority periods |
| Enquiry Drafter | Standalone | Generate pre-contract enquiries from property data |
| Enquiry Responder | Standalone | Match and draft responses to raised enquiries |

## Ideas — community input welcome

- CMS integrations (LEAP, Clio, Osprey, Proclaim)
- SRA/CLC regulatory compliance
- LSAG compliance tracking
- Specialist area skills (commercial, agricultural, new-build)
- Title register interpreter
- Ground rent / service charge analyser

Open an issue or PR if you want to build any of these.
