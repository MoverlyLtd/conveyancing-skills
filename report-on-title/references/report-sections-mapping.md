# Report on Title — Section to PDTF/DE Mapping

This maps each section of the Report on Title precedent (Ian's template, Jan 2026)
to the PDTF state paths and DE flag categories that supply the data.

## 1. Overview
- Address → `get_status` → address fields
- Tenure → `get_state` → `/propertyPack/ownershipsToBeTransferred[0]` (freehold/leasehold)
- Purchase price → not in PDTF (contract terms, from CMS/instructions)
- Seller/Buyer → `get_status` → participants
- Client objective → from instructions (not PDTF)
- **Major Issues** → `get_insights` evidenceBasis=data-driven,evidence-incomplete, minRisk=7

## 2. The Property
- Address → title register / `get_state` → `/propertyPack/address`
- Title number → title register claim
- Registered/unregistered → `/propertyPack/ownershipsToBeTransferred[0]/titleRegistration`

## 3. Boundaries and Structures
- Title plan → document (attached to report)
- Boundary ownership → TA6 Q1.1 → `/propertyPack/legalBoundaries`
- Data source citations: TA6, property register, estate agent particulars, client inspection
- DE category: `property-rights-restrictions`

## 4. The Title
- Freehold/leasehold + title class → `/propertyPack/ownershipsToBeTransferred[0]`
- Good leasehold / qualified / possessory → title class
- Lease term remaining → `/propertyPack/ownershipsToBeTransferred[0]/leaseholdInformation`
- Registered proprietor → title register
- Previous purchase price/date → title register
- DE categories: `tenure-leasehold`, `title-ownership`

## 5. Encumbrances & Rights Benefiting the Property
- Easements granted → title register entries
- Easements reserved → title register entries
- Repair/maintenance obligations → rentcharges
- Restrictive covenants benefiting → charges register
- Positive covenants benefiting → title deeds
- DE categories: `property-rights-restrictions`, `legal-title-issues`

## 6. Easements & Rights Adversely Affecting the Property
- Easements burdening → title register / charges register
- Restrictive covenants burdening → charges register
- Positive covenants burdening → title deeds
- Breach of covenant risk → DE `legal-title-issues`
- Defective title insurance options
- DE categories: `property-rights-restrictions`, `legal-title-issues`

## 7. Other Rights and Client Inspection
- Overriding interests → `/propertyPack/occupiers`
- Unregistered rights → TA6 seller declarations
- Client inspection checklist
- DE category: `property-rights-restrictions`

## 8. Protection of Interests
- Notices on charges register → title register
- Restrictions on proprietorship register → title register
- Overriding interests → occupiers, tenancies, prescriptive easements

## 9. The TA Forms (Seller Information)
- TA6 property information → `/propertyPack/alterationsAndChanges`, `/propertyPack/disputes`, `/propertyPack/rightsAndInformalArrangements`, `/propertyPack/guaranteesAndWarranties`
- TA7 leasehold information → `/propertyPack/ownershipsToBeTransferred[0]/leaseholdInformation`
- TA10 fixtures & fittings → `/propertyPack/fixturesAndContents`
- Building works/alterations → `/propertyPack/alterationsAndChanges`
- DE categories: `building-regulations-extensions`, `building-regulations-internal`, `planning-permission`

## 10. Mines, Minerals and Airspace
- Mines/minerals exclusion → title register
- Airspace restrictions → title register
- DE category: `legal-title-issues`

## 11. Survey and Valuation
- Survey findings → not in PDTF (external document, reference only)
- RICS Level 3 recommendation
- DE category: `condition-safety-core`

## 12. Energy Performance Certificate
- EPC rating → `/propertyPack/energyPerformance` / EPC claim
- Energy Act 2011 letting restrictions
- DE category: `condition-safety-core` (epc-certificate check)

## 13. Searches
### a. Local Land Charges + Local Authority
- Planning designations → `/propertyPack/searches/localAuthority`
- Highway status → local authority search
- Conservation area → `/propertyPack/listingAndConservation/isConservationArea`
- Tree preservation orders → local authority search
- Listed building → `/propertyPack/listingAndConservation/isListed`
- Article 4 directions → local authority search
- Planning permissions → `/propertyPack/planningPermissions`
- Building regulation approvals → local authority search
- Enforcement notices → local authority search
- DE categories: `listed-building`, `conservation-area`, `planning-permission`, `planning-development`, `legal-environmental-statutory`

### b. Drainage and Water
- Foul/surface water drainage → `/propertyPack/waterAndDrainage`
- Public sewer map → water search
- Water supply (mains/private) → water search
- Metered/unmetered → water search
- Internal flooding risk → water search
- Low pressure risk → water search
- DE category: `environment-location`

### c. Environmental and Flood
- Contamination risk → environmental search
- Flood risk → `/propertyPack/environmentalIssues/flooding`
- DE categories: `environment-location`, `insurance-availability`

### d. Other Searches
- Mining, chancel, radon, rail, highways, tin mining, Cheshire brine, SIM
- DE categories: `environment-location`, `emerging-systemic`

## 14. The Contract
- Purchase price, deposit, completion → contract terms (not PDTF)
- Vacant possession → contract
- Insurance obligation → contract
- Notice to complete provisions → standard contract terms
- Apportionment → contract / TA10

## 15. Mortgage and Funding
- Lender, loan amount, rate, term → mortgage offer (not PDTF)
- Lender obligations → UK Finance Mortgage Lenders' Handbook
- DE category: `lenders-handbook`

## 16. Co-ownership
- Joint tenants vs tenants in common → from instructions (not PDTF)

## 17. SDLT
- Purchase price → contract
- First-time buyer status → from instructions
- Apportionment → contract / TA10
- Standalone SDLT calculator skill available

## Data Source Annotations
Ian's precedent consistently cites data sources inline:
- "Data Source – TA6 Reply to Question 1.1"
- "Source – estate agents particulars, survey or valuation, contract, property register"
- "Data Source – feedback from client after property inspection"

The skill should replicate this pattern, citing PDTF claim paths and provenance.
