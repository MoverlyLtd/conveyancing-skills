# Diligence Engine Flag Categories

37 risk categories, each with playbook rules and structured scenarios.

## Evidence Basis

Every flag has an `evidenceBasis` indicating data quality:
- **data-driven** — Sufficient evidence for definitive assessment. Actionable.
- **evidence-incomplete** — Some data but not enough for certainty. Needs follow-up.
- **no-data** — No information available to evaluate. May need searches/documents.
- **clear** — Checked and no issues found.

For agent views, filter to `data-driven` + `evidence-incomplete` to show only evidenced findings.

## Risk Scores

- 🔴 **Critical** (9-10): Must resolve before exchange. Blocks progress.
- 🟠 **High** (7-8): Significant risk requiring attention. May need specialist input.
- 🟡 **Moderate** (4-6): Notable finding, manageable with appropriate action.
- 🟢 **Low** (1-3): Minor issue, informational or easily resolved.

## Categories

### Title & Ownership
- title-ownership — Proprietor verification, title defects, co-ownership
- legal-title-issues — Restrictive covenants, easements, development potential

### Tenure
- tenure-leasehold — Lease length, ground rent, service charges, forfeiture risk
- shared-ownership — Shared ownership terms, staircasing
- park-homes — Park home specific regulations

### Building & Planning
- building-regulations-extensions — Extensions, conservatories, outbuildings
- building-regulations-internal — Loft conversions, internal alterations, bathrooms
- planning-permission — Planning consent status for all works
- planning-development — Local development, s106, CIL
- listed-building — Listed status, conservation area, heritage
- conservation-area — Conservation area restrictions

### Environment & Location
- environment-location — Flood risk, contamination, subsidence, radon
- emerging-systemic — Climate risk, infrastructure changes

### Condition & Safety
- condition-safety-core — EPC, structural condition, asbestos
- condition-safety-specialist — Japanese knotweed, trees, boundaries

### Legal & Transactional
- legal-environmental-statutory — Local authority search interpretation
- legal-transactional — Chain position, timelines, completion
- property-rights-restrictions — Rights of way, boundaries, occupiers

### Finance & Insurance
- finance-tax — SDLT, capital gains, tax implications
- insurance-availability — Buildings insurance, flood insurance
- lenders-handbook — Lender handbook compliance checks

### Specialist
- seller-consumer-duty — Consumer duty obligations (rules pending)
- transaction-aml-monitoring — AML/identity checks (rules pending)
- vulnerable-customer-protection — Vulnerability indicators

## Flag Actions

Each flag includes actions with:
- `targetPath` — PDTF schema path for the data needed
- `canExecute` — Whether the caller's role can perform this action
- `description` — What needs to happen
- `category` — raise-enquiry, request-document, instruct-search, notify-party, etc.
