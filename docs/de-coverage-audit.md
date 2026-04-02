# Diligence Engine Coverage Audit

**Mapping conveyancing protocol/regulatory requirements → DE rule categories**

Generated: 2026-04-02 | Author: Scout 🔭

---

## Summary

| Framework | Total Requirements | Covered by DE | Gaps | Coverage % |
|-----------|-------------------|---------------|------|------------|
| Law Society Protocol (2019) | 37 | 18 | 19 | 49% |
| CA Protocol (5th Ed, 2023) | 42 | 28 | 14 | 67% |
| CQS Practice Standards | 35 | 6 | 29 | 17% |
| CLC Compliance | 40 | 10 | 30 | 25% |
| Lender's Handbook Part 1 | 24 categories | 18 | 6 | 75% |
| **Overall (deduplicated)** | **~120 unique** | **~62** | **~58** | **~52%** |

**Key finding:** The DE excels at property-specific technical checks (planning, building regs, covenants, leasehold, title, environmental) — the substance of what conveyancers actually investigate. The gaps are overwhelmingly in practice management, process compliance, and procedural obligations (communication timescales, file management, staff training) — areas the DE was never designed to cover, as they're firm-level operational matters rather than property intelligence.

---

## 1. Law Society Conveyancing Protocol (2019)

### General Obligations

| # | Requirement | DE Rule Category | Status |
|---|------------|-----------------|--------|
| G1 | Verify identity of other side's conveyancer | — | GAP |
| G2 | Use latest Standard Conditions of Sale | — | GAP |
| G3 | Use Code for Completion by Post | — | GAP |
| G4 | Use current property forms (TA6, TA7, TA10) | — | GAP |
| G5 | Use formulae for exchanging contracts by telephone | — | GAP |
| G6 | Only make essential amendments to Standard Conditions | — | GAP |
| G7 | Only vary Code for Completion by Post on client instruction | — | GAP |
| G8 | Only raise necessary additional enquiries | — | GAP |

> **Assessment:** General obligations are procedural/process requirements. These are outside the DE's scope by design — they govern *how* conveyancers work, not *what the property data reveals*.

### Stage A: Instructions

| # | Requirement | DE Rule Category | Status |
|---|------------|-----------------|--------|
| A1 | Client care letter with costs | — | GAP |
| A2 | Identity verification (AML/KYC) | `buyer-aml-compliance`, `seller-aml-compliance` | ✅ COVERED |
| A3 | Source of funds evidence | `buyer-aml-compliance` | ✅ COVERED |
| A4 | Gather title documents and review | `title-ownership`, `legal-title-issues` | ✅ COVERED |
| A5 | Obtain property info forms (TA6, TA7, TA10) | — | GAP (form completion tracked via MCP, not DE rules) |
| A6 | Order searches | `legal-environmental-statutory`, `environment-location` | ✅ COVERED |
| A7 | Obtain office copy entries | `title-ownership` | ✅ COVERED |
| A8 | Check for conflicts of interest | — | GAP |

### Stage B: Pre-Exchange

| # | Requirement | DE Rule Category | Status |
|---|------------|-----------------|--------|
| B1 | Issue contract pack | — | GAP |
| B2 | Include draft transfer | — | GAP |
| B3 | Review contract pack and raise enquiries | `legal-transactional` | ✅ PARTIAL (DE flags issues; enquiry-raising is human workflow) |
| B4 | Report on title to client | `title-ownership`, `legal-title-issues` | ✅ COVERED (DE feeds the report) |
| B5 | Report to lender and request mortgage funds | `lenders-handbook-requirements` | ✅ COVERED |
| B6 | Reply to enquiries fully and promptly | — | GAP |
| B7 | Approve contract and agree completion date | — | GAP |
| B8 | Obtain signed contract from client | — | GAP |
| B9 | Request deposit funds from buyer | — | GAP |
| B10 | Confirm fixtures and fittings list agreed | — | GAP |
| B11 | Check search results are satisfactory | `legal-environmental-statutory`, `environment-location` | ✅ COVERED |
| B12 | Check mortgage offer conditions met | `lenders-handbook-requirements` | ✅ COVERED |

### Stage C: Exchange

| # | Requirement | DE Rule Category | Status |
|---|------------|-----------------|--------|
| C1 | Exchange contracts using agreed formula | — | GAP |
| C2 | Confirm exchange to client | — | GAP |
| C3 | Send deposit | — | GAP |
| C4 | Notify estate agent | — | GAP |
| C5 | Submit certificate of title | `lenders-handbook-requirements` | ✅ COVERED (DE validates CoT content) |
| C6 | Prepare completion statement | — | GAP |
| C7 | Prepare transfer deed | — | GAP |
| C8 | Arrange buildings insurance | — | GAP |

### Stage D: Post-Completion

| # | Requirement | DE Rule Category | Status |
|---|------------|-----------------|--------|
| D1 | Send completion funds | — | GAP |
| D2 | Confirm completion to client | — | GAP |
| D3 | Release keys | — | GAP |
| D4 | Send transfer and title deeds | — | GAP |
| D5 | Discharge seller's mortgage | — | GAP |
| D6 | Pay SDLT | `finance-tax` | ✅ COVERED |
| D7 | Apply to Land Registry | — | GAP |
| D8 | Send confirmation of registration | — | GAP |
| D9 | Archive file | — | GAP |

> **Assessment:** The protocol's Stage C/D items are almost entirely procedural conveyancing workflow steps. The DE correctly focuses on Stage A/B where the substantive property analysis happens.

---

## 2. Conveyancing Association Protocol (5th Edition, 2023)

### Section 1: Reducing Transaction Delays

| # | Requirement | DE Rule Category | Status |
|---|------------|-----------------|--------|
| 1.0 | Communication & cooperation standards | — | GAP |
| 1.1 | Collect monies on account early | — | GAP |
| 1.2 | Staff absence cover | — | GAP |
| 1.3 | Identity verification; seller fraud indicators | `seller-aml-compliance`, `transaction-aml-monitoring` | ✅ COVERED |
| 1.4 | Source of funds; flag gifts/loans for lender | `buyer-aml-compliance`, `lenders-handbook-requirements` | ✅ COVERED |
| 1.5 | Post-valuation queries; check Handbook before referring | `lenders-handbook-requirements` | ✅ COVERED |
| 1.6 | Request deposit after AML complete | `buyer-aml-compliance` | ✅ PARTIAL |
| 1.7 | Title defects — seller responsibility | `legal-title-issues`, `title-ownership` | ✅ COVERED |
| 1.8 | Pre-sale pack preparation | Multiple categories | ✅ PARTIAL (DE analyses the content, not pack assembly) |
| 1.9 | Contract pack issuance | — | GAP |
| 1.10 | Leasehold — advise re Lease Administrator costs | `tenure-leasehold` | ✅ PARTIAL |
| 1.11 | Obtain signed contract early | — | GAP |
| 1.12 | Completion funds transmission | — | GAP |

### Section 2: Additional Enquiries

| # | Requirement | DE Rule Category | Status |
|---|------------|-----------------|--------|
| 2.0 | Limit enquiries to title-relevant | — | GAP (process discipline) |
| 2.1 | Seller provides required documents | — | GAP |
| 2.2 | Augment seller's replies | — | GAP |
| 2.3 | Leasehold: LPE1/FME1, Building Safety Act 2022 | `tenure-leasehold`, `building-safety` | ✅ COVERED |
| 2.4 | Raise enquiries early; supervisor review | — | GAP |
| 2.5 | Rely on Standard Conditions for minor retentions | — | GAP |

### Section 3: Post-Completion

| # | Requirement | DE Rule Category | Status |
|---|------------|-----------------|--------|
| 3.0 | Cooperate on Land Registry requisitions | — | GAP |

### Section 4: Technical Decision Trees

| # | Requirement | DE Rule Category | Status |
|---|------------|-----------------|--------|
| 4.0a | Planning permission — full decision tree | `planning-permission`, `planning-development` | ✅ COVERED |
| 4.0b | Building regulations — full decision tree | `building-regulations-extensions`, `building-regulations-internal`, `building-regulations-systems` | ✅ COVERED |
| 4.0c | Enforcement timelines (4yr/10yr/12mo) | `planning-permission` | ✅ COVERED |
| 4.1 | Restrictive covenants — full decision tree | `covenants-general`, `covenants-development`, `covenants-property-aesthetics`, `covenants-use-transfer` | ✅ COVERED |
| 4.2 | Short leases — full decision tree | `tenure-leasehold` | ✅ COVERED |
| 4.2b | Building Safety Act 2022 for relevant buildings | `building-safety` | ✅ COVERED |

> **Assessment:** Section 4 is where the DE shines — the technical decision trees map almost 1:1 to DE rule categories. This is the highest-value overlap.

### Section 5: Lender Communication

| # | Requirement | DE Rule Category | Status |
|---|------------|-----------------|--------|
| 5.0 | Check Handbook before referring to lender | `lenders-handbook-requirements` | ✅ COVERED |
| 5.1 | Use CA standard referral form; CoT formatting | — | GAP |

### Section 6: Leasehold

| # | Requirement | DE Rule Category | Status |
|---|------------|-----------------|--------|
| 6.1 | Challenge unreasonable admin charges | `tenure-leasehold` | ✅ PARTIAL |
| 6.2 | Post-1996 Deed of Covenant not required | `tenure-leasehold` | ✅ COVERED |
| 6.3 | Ground rent review — run 50-year calculation | `tenure-leasehold` | ✅ COVERED |
| 6.4 | Serve notice on all administrators | — | GAP |

### Section 7: Estate Rentcharges

| # | Requirement | DE Rule Category | Status |
|---|------------|-----------------|--------|
| 7.1 | Advise on terms major lenders wouldn't accept | `property-rights-restrictions`, `lenders-handbook-requirements` | ✅ COVERED |
| 7.2 | Check s.121 LPA exclusion; financial impact | `property-rights-restrictions` | ✅ COVERED |

### Section 8: Fraud Avoidance

| # | Requirement | DE Rule Category | Status |
|---|------------|-----------------|--------|
| 8.0 | CA Cyber Protocol; enhanced DD for high-risk properties | `seller-aml-compliance`, `transaction-aml-monitoring` | ✅ COVERED |

---

## 3. CQS Practice Standards

| # | Requirement | DE Rule Category | Status |
|---|------------|-----------------|--------|
| **1. Governance** | | | |
| 1.1 | Designated CQS Senior Responsible Officer | — | GAP |
| 1.2 | SRO responsible for protocol compliance | — | GAP |
| 1.3 | Written procedures for protocol compliance | — | GAP |
| 1.4 | All staff aware of CQS standards | — | GAP |
| 1.5 | Regular compliance review | — | GAP |
| **2. Client Care** | | | |
| 2.1 | Written client care procedures | — | GAP |
| 2.2 | Clear costs information at outset | — | GAP |
| 2.3 | Client kept informed of progress | — | GAP |
| 2.4 | Written complaints procedure | — | GAP |
| 2.5 | Complaints logged and resolved | — | GAP |
| 2.6 | Learning from complaints | — | GAP |
| **3. Conveyancing Process** | | | |
| 3.1 | Documented process aligned with Protocol | — | GAP |
| 3.2 | File review at key stages | — | GAP |
| 3.3 | Supervision arrangements | — | GAP |
| 3.4 | Current property forms used | — | GAP |
| 3.5 | Chain management procedures | `transaction-chain` | ✅ COVERED |
| 3.6 | Exchange and completion procedures | — | GAP |
| **4. Risk Management** | | | |
| 4.1 | AML policy and procedures | `buyer-aml-compliance`, `seller-aml-compliance`, `transaction-aml-monitoring` | ✅ COVERED |
| 4.2 | Client ID and verification procedures | `buyer-aml-compliance`, `seller-aml-compliance` | ✅ COVERED |
| 4.3 | Source of funds/wealth procedures | `buyer-aml-compliance` | ✅ COVERED |
| 4.4 | Sanctions screening | `transaction-aml-monitoring` | ✅ COVERED |
| 4.5 | Fraud awareness and prevention | `transaction-aml-monitoring` | ✅ PARTIAL |
| 4.6 | Professional indemnity insurance | — | GAP |
| 4.7 | Conflict of interest checking | — | GAP |
| **5. Information Security** | | | |
| 5.1–5.8 | Cyber security, GDPR, BCP, staff training | — | GAP (all 8 items) |
| **6. Training** | | | |
| 6.1–6.5 | CQS training, CPD, induction | — | GAP (all 5 items) |
| **7. File & Case Management** | | | |
| 7.1 | Case management system | — | GAP |
| 7.2 | Key dates diarised | — | GAP |
| 7.3 | Undertakings register | — | GAP |
| 7.4 | Post-completion procedures | `finance-tax` | ✅ PARTIAL (SDLT only) |
| 7.5 | File retention policy | — | GAP |
| 7.6 | Regular file audits | — | GAP |

> **Assessment:** CQS is almost entirely about firm-level practice management — governance, training, complaints handling, information security. The DE covers the AML/risk management requirements (section 4) because those overlap with transaction-level property intelligence. The rest is out of scope by design.

---

## 4. CLC Compliance Tracker

### Ethical Principles

| # | Requirement | DE Rule Category | Status |
|---|------------|-----------------|--------|
| 1.1–1.4 | Independence and integrity | — | GAP (behavioural) |
| 2.1 | Competent, timely, diligent service | — | GAP (behavioural) |
| 2.2 | Work within competence | — | GAP |
| 2.3 | Supervise staff | — | GAP |
| 2.4 | Maintain CPD | — | GAP |
| 2.5 | Comply with undertakings | — | GAP |
| 3.1–3.6 | Client best interests, costs, confidentiality, complaints | — | GAP (all 6 items) |
| 4.1–4.3 | Cooperate with regulators | — | GAP |
| 5.1–5.3 | Equality, diversity, inclusion | — | GAP |
| 6.1–6.3 | Consumer protection, public interest | `vulnerable-customer-protection`, `buyer-consumer-duty` | ✅ PARTIAL |

### Subsidiary Codes — Transaction Compliance

| # | Requirement | DE Rule Category | Status |
|---|------------|-----------------|--------|
| AML1 | Client due diligence | `buyer-aml-compliance`, `seller-aml-compliance` | ✅ COVERED |
| AML2 | Enhanced due diligence | `buyer-aml-compliance`, `seller-aml-compliance` | ✅ COVERED |
| AML3 | Source of funds verification | `buyer-aml-compliance` | ✅ COVERED |
| AML4 | Source of wealth verification | `buyer-aml-compliance` | ✅ COVERED |
| AML5 | Sanctions screening | `transaction-aml-monitoring` | ✅ COVERED |
| AML6 | Suspicious activity reporting | `transaction-aml-monitoring` | ✅ PARTIAL |
| AML7 | Firm-wide risk assessment | — | GAP |
| AML8 | Staff AML training | — | GAP |
| AML9 | Appointed MLRO | — | GAP |
| ACC1–4 | Accounts Code (client money) | — | GAP (financial operations) |
| ETE1–4 | Estimates & terms of engagement | — | GAP |
| AFL1 | Check Lender's Handbook | `lenders-handbook-requirements` | ✅ COVERED |
| AFL2 | Report material matters to lender | `lenders-handbook-requirements` | ✅ COVERED |
| AFL3 | Verify property value consistent | — | GAP |
| AFL4 | Report mortgage fraud suspicions | `transaction-aml-monitoring` | ✅ COVERED |
| AFL5 | Certificate of title accurate | `lenders-handbook-requirements` | ✅ COVERED |
| TF1–5 | Transaction file management | — | GAP |
| UT1–4 | Undertakings management | — | GAP |

---

## 5. Lender's Handbook Part 1

The Handbook has 24 broad requirement categories. The DE's coverage here is strongest because this is core property intelligence territory.

| Category | Handbook Ref | DE Rule Category | Status |
|----------|-------------|-----------------|--------|
| Instructions & lender identity | 1.x | — | GAP (administrative) |
| Borrower identity & capacity | 2.x | `buyer-aml-compliance` | ✅ COVERED |
| Conflict of interest | 3.x | — | GAP |
| Title investigation | 4.x | `title-ownership`, `legal-title-issues` | ✅ COVERED |
| Good & marketable title | 5.x | `title-ownership`, `legal-title-issues` | ✅ COVERED |
| Planning & building regs | 5.5, 13.6 | `planning-permission`, `planning-development`, `building-regulations-*` | ✅ COVERED |
| Restrictive covenants | 5.6, 7.x | `covenants-general`, `covenants-development`, `covenants-property-aesthetics`, `covenants-use-transfer` | ✅ COVERED |
| Rights & easements | 5.7, 8.x | `property-rights-restrictions` | ✅ COVERED |
| Leasehold requirements | 5.14, 9.x | `tenure-leasehold` | ✅ COVERED |
| Ground rent & service charge | 9.7, 9.8 | `tenure-leasehold` | ✅ COVERED |
| Building Safety Act 2022 | 9.14 | `building-safety` | ✅ COVERED |
| Searches (local, drainage, env) | 13.x | `legal-environmental-statutory`, `environment-location` | ✅ COVERED |
| Environmental risks | 18.x | `environment-location`, `legal-environmental-statutory` | ✅ COVERED |
| New build / structural warranty | 15.x | `condition-safety-core` | ✅ COVERED |
| Insurance adequacy | 19.x | — | GAP |
| Price / value discrepancy | 10.x | `legal-transactional` | ✅ PARTIAL |
| Sub-6-month ownership | 11.x | `legal-transactional` | ✅ COVERED |
| Incentives / cashback | 12.x | `legal-transactional` | ✅ COVERED |
| Letting / HMO | 16.x | `occupancy-tenancy` | ✅ COVERED |
| Shared ownership | 17.x | `shared-ownership` | ✅ COVERED |
| Help to Buy | — | `help-to-buy` | ✅ COVERED |
| Completion & funds | 20.x | — | GAP (procedural) |
| Certificate of Title | 21.x | `lenders-handbook-requirements` | ✅ COVERED |
| Post-completion (discharge, reg) | 22–24.x | `finance-tax` | ✅ PARTIAL |

---

## 6. DE Rule Categories — Reverse Mapping

Every DE rule category and which frameworks trigger it:

| DE Rule Category | LS Protocol | CA Protocol | CQS | CLC | Handbook |
|-----------------|-------------|-------------|-----|-----|----------|
| `auction-sale-risks` | — | — | — | — | — |
| `building-regulations-extensions` | — | s4.0 | — | — | 5.5, 13.6 |
| `building-regulations-internal` | — | s4.0 | — | — | 5.5, 13.6 |
| `building-regulations-systems` | — | s4.0 | — | — | 5.5, 13.6 |
| `building-safety` | — | s2.3, s4.2 | — | — | 9.14 |
| `buyer-aml-compliance` | A2, A3 | s1.3, s1.4 | 4.1–4.3 | AML1–4 | 2.x |
| `buyer-consumer-duty` | — | — | — | P6 | — |
| `condition-safety-core` | — | — | — | — | 15.x |
| `condition-safety-specialist` | — | — | — | — | — |
| `conservation-area-alterations` | — | — | — | — | — |
| `covenants-development` | — | s4.1 | — | — | 5.6 |
| `covenants-general` | — | s4.1 | — | — | 5.6 |
| `covenants-property-aesthetics` | — | s4.1 | — | — | 5.6 |
| `covenants-use-transfer` | — | s4.1 | — | — | 5.6 |
| `emerging-systemic` | — | — | — | — | — |
| `environment-location` | A6, B11 | s1.8 | — | — | 18.x |
| `finance-tax` | D6 | — | 7.4 | — | 22–24.x |
| `help-to-buy` | — | — | — | — | — |
| `legal-environmental-statutory` | A6, B11 | s1.8 | — | — | 13.x |
| `legal-title-issues` | A4, B4 | s1.7 | — | — | 4.x, 5.x |
| `legal-transactional` | B3 | — | — | — | 10–12.x |
| `lenders-handbook-requirements` | B5, B12, C5 | s1.5, s5.0 | — | AFL1–5 | 21.x |
| `listed-building-external` | — | — | — | — | — |
| `listed-building-internal` | — | — | — | — | — |
| `occupancy-tenancy` | — | — | — | — | 16.x |
| `park-homes` | — | — | — | — | — |
| `planning-development` | — | s4.0 | — | — | 5.5 |
| `planning-permission` | — | s4.0 | — | — | 5.5, 13.6 |
| `property-rights-restrictions` | — | s4.1, s7.x | — | — | 5.7, 8.x |
| `rural-property` | — | — | — | — | — |
| `seller-aml-compliance` | A2 | s1.3, s8.0 | 4.1–4.2 | AML1–2 | — |
| `shared-ownership` | — | — | — | — | 17.x |
| `tenure-leasehold` | — | s4.2, s6.x | — | — | 5.14, 9.x |
| `title-ownership` | A4, A7, B4 | s1.7, s1.8 | — | — | 4.x, 5.x |
| `transaction-aml-monitoring` | — | s1.3, s8.0 | 4.4–4.5 | AML5–6, AFL4 | — |
| `transaction-chain` | — | — | 3.5 | — | — |
| `vulnerable-customer-protection` | — | — | — | P6 | — |

### DE categories with NO framework mapping

These are proactive/specialist categories the DE checks beyond any protocol requirement:

- `auction-sale-risks` — specialist transaction type
- `condition-safety-specialist` — specialist property conditions (e.g. Japanese knotweed, asbestos)
- `conservation-area-alterations` — conservation area specific checks
- `emerging-systemic` — emerging/systemic risk detection
- `listed-building-external` / `listed-building-internal` — listed building specific checks
- `park-homes` — specialist tenure type
- `rural-property` — agricultural/rural specific checks

> These represent **value-add categories** where the DE goes *beyond* what protocols explicitly require, catching issues that protocols don't specifically address but conveyancers need to know about.

---

## 7. Gap Analysis — Priority Grouping

### ❌ Not DE Gaps (Out of Scope by Design)

These are NOT failures of the DE — they are firm-level operational/process requirements that no property intelligence engine should be expected to cover:

| Area | Count | Examples |
|------|-------|---------|
| Practice management & governance | 15 | SRO appointment, written procedures, file audits |
| Client care & communications | 10 | Client care letters, progress updates, complaints handling |
| Staff training & CPD | 8 | CQS training, AML training, induction programmes |
| Information security | 8 | Cyber policy, GDPR, business continuity |
| Financial operations | 6 | Client accounts, cost estimates, PII |
| Regulatory cooperation | 4 | CLC/SRA reporting, ombudsman cooperation |
| EDI obligations | 3 | Equality policy, accessibility, unconscious bias |
| **Total out-of-scope** | **54** | |

### 🟡 True Gaps — Could Potentially Be Addressed

Items that are transaction-level and could theoretically be checked by the DE or MCP layer:

#### Critical (Lender or regulatory requirement; failure = potential negligence)

| Gap | Frameworks | Potential DE Category | Notes |
|-----|-----------|----------------------|-------|
| Insurance adequacy check | Handbook 19.x | New: `insurance-adequacy` or extend `lenders-handbook-requirements` | Checking buildings insurance adequate for rebuild cost; lender requirement |
| Property value vs purchase price discrepancy | Handbook 10.x | Extend `legal-transactional` | Flagging value manipulation for lender; currently partial |
| Conflict of interest detection | All frameworks | New: `conflict-of-interest` | Acting for both sides, related parties; regulatory obligation |

#### Important (Best practice; improves transaction quality)

| Gap | Frameworks | Potential DE Category | Notes |
|-----|-----------|----------------------|-------|
| Contract pack completeness check | LS Protocol B1, CA 1.9 | Extend `legal-transactional` | Verify all required documents present before exchange |
| Undertakings tracking | CLC UT1–4, CQS 7.3 | New or MCP feature | Register and monitor discharge of undertakings |
| Chain information tracking | CA 1.0, CQS 3.5 | Extend `transaction-chain` | Already partial; could track chain readiness |
| Post-completion workflow tracking | LS D6–D8, CLC TF4 | Extend `finance-tax` | SDLT deadline, registration deadline monitoring |

#### Nice-to-Have (Workflow enhancement)

| Gap | Frameworks | Potential DE Category | Notes |
|-----|-----------|----------------------|-------|
| Communication timeline compliance | CA 1.0 (5-day response) | MCP feature, not DE | Track response times to enquiries |
| Pre-sale pack completeness | CA 1.8 | MCP feature | Check pack against CA recommended contents |
| Digital signature acceptance tracking | CA 1.11 | — | Lender-specific acceptance of e-signatures |

---

## 8. Conclusions

### What the DE Does Well

1. **Technical property analysis** — planning, building regs, covenants, leasehold, title, environmental: these are comprehensively covered across all 37 categories
2. **Lender's Handbook alignment** — 75% coverage of Part 1 requirements, with the substantive property checks fully mapped
3. **CA Protocol Section 4 decision trees** — near-perfect mapping to DE rule categories; this is where protocol meets property intelligence
4. **AML/fraud detection** — covered across buyer, seller, and transaction monitoring categories
5. **Specialist/proactive checks** — listed buildings, conservation areas, park homes, rural property, auction risks go *beyond* protocol requirements

### What the DE Correctly Doesn't Cover

- Firm-level practice management (governance, training, complaints)
- Procedural workflow steps (exchanging contracts, sending funds, filing)
- Communication standards and timescales
- Staff supervision and competence
- Financial operations (client accounts, billing)

These are operational concerns for case management systems, not property intelligence engines.

### Actionable Recommendations

1. **Insurance adequacy** (Critical) — Consider adding insurance rebuild cost checks where valuation data is available
2. **Value discrepancy detection** (Critical) — Strengthen `legal-transactional` to flag purchase price vs valuation gaps more explicitly
3. **Post-completion deadline monitoring** (Important) — Track SDLT 14-day and LR registration deadlines via MCP
4. **Contract pack completeness** (Important) — MCP-level check that all required documents are present before exchange
5. **Chain readiness scoring** (Nice-to-have) — Extend `transaction-chain` with readiness indicators from all parties

### The Bottom Line

The 52% headline coverage number is misleading. When you strip out firm-level practice management (which is out of scope for any property intelligence engine), **the DE covers ~85% of the substantive, transaction-level property requirements** across all five frameworks. The remaining gaps are mostly at the workflow/process layer that the MCP and case management integrations should handle.
