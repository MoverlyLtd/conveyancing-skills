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

The skills above add **domain knowledge** — they make the model smarter about a topic. A second category we're now building adds **safety**: guardrail skills that constrain *how* the model behaves on every turn, regardless of topic. An advisory skill is judged on whether it gives the right answer; a guardrail skill is judged on precision/recall — does it catch what it should without crying wolf. This is the "risk-averse AI" layer — the thing that lets a compliance lead say yes to their team using AI at all.

| Skill | Type | Notes |
|-------|------|-------|
| Data-protection guard | Guardrail | Pre-flight PII / GDPR check that **coaches rather than punishes** when someone is about to paste sensitive client data into a prompt. Make-or-break design constraint: public-register data (owner names on a title, lessees in a lease) must **not** be flagged — only the client's own personal/financial details. Positioned as the "if you do nothing else, install this" skill. In-session coaching works anywhere; any audit-trail / line-manager reporting needs a managed deployment — a skill on its own has no backend. |
| Safe-AI gate | Guardrail | Two parts. (1) **Scope awareness** — warn when asked something a validated skill covers but that skill isn't loaded ("I answered from memory; don't rely on it — load the skill for an accurate answer"). (2) **Provenance labelling** — tag each output as computed-by-validated-skill / consistent-with-cited-source / model-knowledge-only. A prompt-only skill can nudge and label; it cannot truly enforce "nothing leaves unverified" — hard enforcement needs a host/platform wrapper. |

Both need a **new benchmark scoring mode**: precision/recall over a labelled set that includes *negatives* (e.g. a title full of owner names that must not trip the PII guard). The current scorecard only scores correctness of an answer, so this is new eval work, not just new skills.

### Enforcement & delivery

A note on a real limitation. Like any skill, a guardrail loads based on its description, so a host won't necessarily invoke it on every turn. For *advisory* skills that's a quality trade-off; for *guardrail* skills it matters more — a check that only runs sometimes gives a false sense of safety. So a guardrail skill is best understood in two parts:

- **The open skill = the detection logic and the spec** — what "good" looks like, free for anyone to read, run, and improve.
- **Reliable, always-on enforcement = a property of the runtime**, not the skill. Running the check unconditionally on every input (and keeping any audit record) needs a managed environment — e.g. system-prompt-level provisioning, an MCP gateway, or a case-management integration.

The open toolkit is the right home for the *what*; guaranteeing the *when* is a deployment concern. We're explicit about this so nobody mistakes an unenforced guardrail for a compliance control.

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
