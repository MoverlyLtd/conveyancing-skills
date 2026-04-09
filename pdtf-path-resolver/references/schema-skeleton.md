# PDTF Schema Skeleton — Path Resolution Reference

Use this to map natural language subjects to PDTF paths. All paths are under the transaction root.

## Key Concept: Attachment Paths

Many schema nodes have an `attachments` property for uploading documents directly to the relevant data point. When resolving a document upload, always target the most specific `attachments` path — e.g. a building regs certificate for a loft conversion goes to:
`/propertyPack/alterationsAndChanges/loftConversion/buildingRegApproval/attachments`
NOT `/propertyPack/alterationsAndChanges/loftConversion` or `/propertyPack/documents`.

---

## Title & Ownership
- `/propertyPack/titlesToBeSold` — title registers, title numbers, proprietors, charges, restrictions, covenants
- `/propertyPack/ownership` — sellers count, mortgage, help-to-buy, first registration, limited company
- `/propertyPack/ownership/ownershipsToBeTransferred` — freehold/leasehold details per ownership (array)
- `/propertyPack/legalOwners` — names of legal owners
- `/propertyPack/legalBoundaries` — boundary ownership, flying freehold, title plan discrepancies, adjacent land
  - `.../ownership/uniformBoundaries/left` — left boundary owner (Seller/Shared/Neighbour/Not known)
  - `.../ownership/uniformBoundaries/right` — right boundary owner
  - `.../ownership/uniformBoundaries/rear` — rear boundary owner
  - `.../ownership/uniformBoundaries/front` — front boundary owner
  - `.../ownership/attachments` — boundary plan (when boundaries are non-uniform)
  - `.../boundariesDifferFromTitlePlan/attachments` — evidence of boundary differences
  - `.../haveBoundaryFeaturesMoved` — boundary features moved in last 10 years
  - `.../flyingFreehold` — part of property overhangs neighbour's land

## Tenure & Leasehold
Leasehold branch lives at `/propertyPack/ownership/ownershipsToBeTransferred/[]/leaseholdInformation/`:
- `.../consents/changesInTermOfLease/attachments` — consent to lease term changes
- `.../consents/landlordConsents/attachments` — landlord consent documents
- `.../ownershipAndManagement/sellerOwnership/attachments` — share certificate / management company membership
- `.../buildingSafetyAct/deedOfCertificateServed/attachments` — Leaseholder Deed of Certificate
- `.../buildingSafetyAct/landlordsCertificateServed/attachments` — Landlord's Certificate
- `.../alterations/sellerAwareOfAlterations/landlordConsentObtained/attachments` — landlord consent for alterations
- `.../enfranchisement/sellerServedNoticeOnLandlord/attachments` — enfranchisement notice
- `.../enfranchisement/sellerAwareOfNoticeOfCollectivePurchase/attachments` — collective purchase notice
- `.../enfranchisement/sellerAwareOfResponse/attachments` — enfranchisement response
- `.../requiredDocuments/noticeOfSale/attachments` — notice of sale to landlord
- `.../requiredDocuments/noticeOfBuildingCondition/attachments` — building condition notice
- `.../transferAndRegistration/deedOfCovenantRequired` — is a deed of covenant required?
- `.../requiredDocuments/deedOfCovenant` — deed of covenant (document details)
- `.../additionalInformation/attachments` — additional leasehold info

## Alterations & Building Works
Base: `/propertyPack/alterationsAndChanges/`

Each alteration type has a consistent pattern with sub-paths for documents, planning, building regs, listed building consent, and deed restriction consent — each with their own `attachments`:

| Alteration | Base Path | Has `documents` | Has `planningPermission/attachments` | Has `buildingRegApproval/attachments` | Has `listedBuildingConsent/attachments` | Has `deedRestrictionConsent/attachments` |
|---|---|---|---|---|---|---|
| `hasStructuralAlterations` | `.../hasStructuralAlterations/` | ❌ | ✅ | ✅ | ✅ | ✅ |
| `changeOfUse` | `.../changeOfUse/` | ❌ | ✅ | ✅ | ✅ | ✅ |
| `nonResidentialPurposes` | `.../nonResidentialPurposes/` | ❌ (has top-level `attachments`) | — | — | — | — |
| `windowReplacementsSince2002` | `.../windowReplacementsSince2002/` | ✅ | ✅ | ✅ | ✅ | ✅ |
| `extension` | `.../extension/` | ✅ | ✅ | ✅ | ❌ | ❌ |
| `hasAddedConservatory` | `.../hasAddedConservatory/` | ✅ | ✅ | ✅ | ✅ | ✅ |
| `loftConversion` | `.../loftConversion/` | ✅ | ✅ | ✅ | ❌ | ❌ |
| `garageConversion` | `.../garageConversion/` | ✅ | ✅ | ✅ | ❌ | ❌ |
| `removalOfInternalWalls` | `.../removalOfInternalWalls/` | ✅ | ✅ | ✅ | ❌ | ❌ |
| `removalOfChimneyBreast` | `.../removalOfChimneyBreast/` | ✅ | ✅ | ✅ | ❌ | ❌ |
| `insulation` | `.../insulation/` | ✅ | ✅ | ✅ | ❌ | ❌ |
| `otherBuildingWorksOrChangesToTheProperty` | `.../otherBuildingWorksOrChangesToTheProperty/` | ✅ | ✅ | ✅ | ❌ | ❌ |

Other alteration paths:
- `.../worksUnfinished/attachments` — unfinished works evidence
- `.../planningPermissionBreaches/attachments` — breach evidence
- `.../unresolvedPlanningIssues/attachments` — unresolved planning evidence

### Resolution Examples
| Document | Target Path |
|---|---|
| Building regs cert for loft conversion | `.../loftConversion/buildingRegApproval/attachments` |
| Planning permission for extension | `.../extension/planningPermission/attachments` |
| Listed building consent for window replacement | `.../windowReplacementsSince2002/listedBuildingConsent/attachments` |
| Completion certificate for garage conversion | `.../garageConversion/buildingRegApproval/attachments` |
| General docs bundle for chimney removal | `.../removalOfChimneyBreast/documents` |

## Environmental & Location
- `/propertyPack/environmentalIssues` — flooding, radon, contaminated land, ground stability, coal mining, coastal erosion, climate risk
  - `.../contaminatedLand` — contaminated land (structured data)
  - `.../coalMining` — coal mining risk
  - `.../groundStability` — ground stability
  - `.../flooding/floodRiskReport/attachments` — flood risk report
  - `.../radon/radonTest/attachments` — radon test report
- `/propertyPack/location` — lat/lng, BNG coordinates
- `/propertyPack/localAuthority` — council name, search turnaround

## Listing & Conservation
- `/propertyPack/listingAndConservation/isListed/attachments` — listed building evidence
- `/propertyPack/listingAndConservation/isConservationArea/attachments` — conservation area evidence
- `/propertyPack/listingAndConservation/hasTreePreservationOrder/workCarriedOut/attachments` — TPO work documentation

## Construction & Safety
- `/propertyPack/typeOfConstruction` — standard construction, loft type, spray foam, accessibility
  - `.../buildingSafety/attachments` — building safety / cladding / EWS1
  - `.../sprayFoamInsulation/attachments` — spray foam evidence

## Energy & Services
- `/propertyPack/energyEfficiency` — EPC rating, green deal
  - `.../certificate` — EPC certificate (data + attachments)
  - `.../greenDealLoan/hasGreenDealLoan/attachments` — Green Deal documentation
- `/propertyPack/electricity`
  - `.../mainsElectricity/electricityMeter/attachments` — meter photo
  - `.../solarPanels/panelsOwnedOutright/attachments` — solar ownership docs
  - `.../solarPanels/panelProviderLease/attachments` — panel lease agreement
  - `.../solarPanels/photovoltaicMeterPanelLocation/attachments` — PV meter photo
  - `.../solarPanels/maintenanceAgreement/attachments` — maintenance agreement
  - `.../solarPanels/photovoltaicBatteries/attachments` — battery location photo
  - `.../solarPanels/nationalGrid/fitOrSegInPlace/attachments` — FIT/SEG evidence
  - `.../heatPump/attachments` — heat pump building regs / MCS certificate
- `/propertyPack/heating`
  - `.../heatingSystem/centralHeatingDetails/centralHeatingFuel/gasMeter/attachments` — gas meter photo
  - `.../heatingSystem/centralHeatingDetails/boilerInstallationCertificate/attachments` — boiler installation cert
  - `.../heatingSystem/centralHeatingDetails/replacementOtherThanBoiler/attachments` — heating replacement compliance
- `/propertyPack/waterAndDrainage`
  - `.../drainage/publicSewerWithin100ft` — public sewer within 100 feet
  - `.../water/mainsWater/stopcock/attachments` — stopcock photo
  - `.../water/mainsWater/waterMeter/attachments` — water meter photo
  - `.../drainage/mainsFoulDrainage/offMainsDrainageSystem/plantOnOtherLand/attachments` — drainage location plan
  - `.../drainage/mainsFoulDrainage/offMainsDrainageSystem/plantRegistered/attachments` — discharge permit
  - `.../drainage/mainsFoulDrainage/offMainsDrainageSystem/attachments` — drainage building regs
  - `.../maintenanceAgreements/attachments` — drainage maintenance agreements

## Electrical
- `/propertyPack/electricalWorks/testedByQualifiedElectrician/attachments` — electrical test certificate
- `/propertyPack/electricalWorks/electricalWorkSince2005/suppliedCertificate/attachments` — Part P certificate

## Specialist Issues
- `/propertyPack/specialistIssues/dryRotEtcTreatment/attachments` — treatment report
- `/propertyPack/specialistIssues/containsAsbestos/attachments` — asbestos report
- `/propertyPack/specialistIssues/japaneseKnotweed/knotweedSurveyCarriedOut/attachments` — knotweed survey
- `/propertyPack/specialistIssues/japaneseKnotweed/attachments` — knotweed management plan + insurance
- `/propertyPack/specialistIssues/subsidenceOrStructuralFault/attachments` — subsidence report
- `/propertyPack/specialistIssues/ongoingHealthOrSafetyIssue/attachments` — health/safety evidence

## Guarantees, Warranties & Indemnity
Base: `/propertyPack/guaranteesWarrantiesAndIndemnityInsurances/`
- `.../newHomeWarranty/attachments` — NHBC / equivalent warranty
- `.../roofingWork/attachments` — roofing guarantee
- `.../dampProofingTreatment/attachments` — damp proofing guarantee
- `.../timberRotOrInfestationTreatment/attachments` — timber treatment guarantee
- `.../centralHeatingAndorPlumbing/attachments` — heating/plumbing guarantee
- `.../doubleGlazing/attachments` — double glazing guarantee
- `.../electricalRepairOrInstallation/attachments` — electrical work guarantee
- `.../subsidenceWork/attachments` — subsidence work guarantee
- `.../insulation/attachments` — insulation guarantee
- `.../solarPanels/attachments` — solar panel guarantee
- `.../otherGuarantees/attachments` — other guarantees
- `.../outstandingClaimsOrApplications/attachments` — outstanding claims evidence
- `.../titleDefectInsurance/attachments` — title defect indemnity policy

## Notices
Base: `/propertyPack/notices/`
- `.../neighbourDevelopment/attachments` — neighbour development notice
- `/propertyPack/notices/planningApplication` — planning application that may affect the property (has attachments)
- `/propertyPack/notices/requiredMaintenance` — notice requiring maintenance/repairs (has attachments)
- `.../planningApplication/attachments` — planning application notice attachments
- `.../requiredMaintenance/attachments` — maintenance notice attachments
- `.../listedBuildingApplication/attachments` — listed building application
- `.../infrastructureProject/attachments` — infrastructure project notice
- `.../partyWallAct/attachments` — party wall notice/agreement
- `.../otherNotices/attachments` — other notices

## Rights & Access
- `/propertyPack/rightsAndInformalArrangements/neighbouringLandRights/attachments` — neighbouring land evidence
- `/propertyPack/rightsAndInformalArrangements/rightsOrArrangements/publicRightOfWay/attachments` — right of way plan
- `/propertyPack/servicesCrossing/pipesWiresCablesDrainsToProperty/attachments` — services to property evidence
- `/propertyPack/servicesCrossing/pipesWiresCablesDrainsFromProperty/attachments` — services from property evidence
- `/propertyPack/servicesCrossing/formalOrInformalAgreements/attachments` — shared services agreement

## Occupiers
- `/propertyPack/occupiers/othersAged17OrOver/vacantPossession/attachments` — tenancy agreement / notice to quit
- `.../vacantPossession/aged17OrOverWillSignToConfirmWillVacate/attachments` — evidence property will be vacant
- `/propertyPack/occupiers/sellerLivesAtProperty` — does the seller live at the property?

## Other Issues
- `/propertyPack/otherIssues/excessiveNoise/attachments`
- `/propertyPack/otherIssues/crime/attachments`
- `/propertyPack/otherIssues/cautionOrConviction/attachments`
- `/propertyPack/otherIssues/failedTransactionsInLast12Months/attachments`

## Additional Information
- `/propertyPack/additionalInformation/consents/attachments`
- `/propertyPack/additionalInformation/furtherInformation/attachments`
- `/propertyPack/additionalInformation/restrictionsOnUseNotCompliedWith/attachments`
- `/propertyPack/additionalInformation/otherMaterialIssue/attachments`

## Other Top-Level Paths
- `/propertyPack/buildInformation/roomDimensions/attachments` — room dimension plans
- `/propertyPack/buildInformation/isNewBuild` — is the property a new build?
- `/propertyPack/buildInformation/isHMO` — is the property a House in Multiple Occupation?
- `/propertyPack/delayFactors/hasDelayFactors/attachments` — delay evidence
- `/propertyPack/councilTax/councilTaxBand` — council tax band
- `/propertyPack/councilTax/councilTaxAffectingAlterations/attachments` — council tax alteration evidence
- `/propertyPack/connectivity` — broadband, mobile, TV
- `/propertyPack/connectivity/broadband` — broadband availability/speed
- `/propertyPack/parking` — parking arrangements, ULEZ, EV charging
- `/propertyPack/parking/controlledParking` — controlled parking zone
- `/propertyPack/parking/electricVehicleChargingPoint` — EV charging point
- `/propertyPack/fixturesAndFittings` — included/excluded items
- `/propertyPack/fixturesAndFittings/itemsToRemove` — items seller intends to remove
- `/propertyPack/priceInformation` — price, disposal type
- `/propertyPack/completionAndMoving` — chain status, move dates, mortgage sufficiency
- `/propertyPack/completionAndMoving/moveRestrictionDates` — dates seller cannot move
- `/propertyPack/completionAndMoving/sufficientToRepayAllMortgages` — will sale proceeds clear mortgages?
- `/propertyPack/disputesAndComplaints` — past and potential disputes
- `/propertyPack/disputesAndComplaints/hasDisputesAndComplaints` — disputes/complaints
- `/propertyPack/disputesAndComplaints/leadingToDisputesAndComplaints` — potential future disputes
- `/propertyPack/smartHomeSystems` — smart home systems
- `/propertyPack/smartHomeSystems/hasSmartHomeSystems` — does the property have smart home systems?
- `/propertyPack/insurance` — insurance difficulties
- `/propertyPack/insurance/difficultiesObtainingInsurance` — difficulties obtaining buildings insurance
- `/propertyPack/consumerProtectionRegulationsDeclaration` — CPR compliance
- `/propertyPack/address` — full address
- `/propertyPack/uprn` — UPRN
- `/propertyPack/residentialPropertyFeatures` — bedrooms, bathrooms, receptions
- `/propertyPack/documents` — general uploaded documents (use specific attachment paths when possible)

## Enquiries
- `/enquiries` — transaction enquiries between conveyancers (key-value map, each with messages array and externalIds)

## Milestones & Chain
- `/milestones` — listing, SSTC, searches, enquiries, exchange, completion
- `/chain/onwardPurchase` — linked transactions

## Common Document → Path Quick Reference

| Document Type | Target Path |
|---|---|
| Building regs cert (any alteration) | `.../alterationsAndChanges/{alteration}/buildingRegApproval/attachments` |
| FENSA certificate (replacement windows) | `/propertyPack/alterationsAndChanges/windowReplacementsSince2002/buildingRegApproval/attachments` |
| Planning permission (any alteration) | `.../alterationsAndChanges/{alteration}/planningPermission/attachments` |
| Listed building consent | `.../alterationsAndChanges/{alteration}/listedBuildingConsent/attachments` |
| Deed restriction consent | `.../alterationsAndChanges/{alteration}/deedRestrictionConsent/attachments` |
| EWS1 / cladding safety | `.../typeOfConstruction/buildingSafety/attachments` |
| NHBC warranty | `.../guaranteesWarrantiesAndIndemnityInsurances/newHomeWarranty/attachments` |
| Title defect indemnity | `.../guaranteesWarrantiesAndIndemnityInsurances/titleDefectInsurance/attachments` |
| Electrical test cert | `.../electricalWorks/testedByQualifiedElectrician/attachments` |
| Part P cert | `.../electricalWorks/electricalWorkSince2005/suppliedCertificate/attachments` |
| Boiler installation cert | `.../heating/heatingSystem/centralHeatingDetails/boilerInstallationCertificate/attachments` |
| Gas safety cert | `.../heating/heatingSystem/centralHeatingDetails/centralHeatingFuel/gasMeter/attachments` |
| Flood risk report | `.../environmentalIssues/flooding/floodRiskReport/attachments` |
| Radon test | `.../environmentalIssues/radon/radonTest/attachments` |
| Knotweed survey | `.../specialistIssues/japaneseKnotweed/knotweedSurveyCarriedOut/attachments` |
| Knotweed management plan | `.../specialistIssues/japaneseKnotweed/attachments` |
| Asbestos report | `.../specialistIssues/containsAsbestos/attachments` |
| Subsidence report | `.../specialistIssues/subsidenceOrStructuralFault/attachments` |
| Lease extension notice | `.../ownership/.../enfranchisement/sellerServedNoticeOnLandlord/attachments` |
| Landlord consent | `.../ownership/.../consents/landlordConsents/attachments` |
| Party wall agreement | `.../notices/partyWallAct/attachments` |
| Tenancy agreement | `.../occupiers/othersAged17OrOver/vacantPossession/attachments` |
| Green Deal disclosure | `.../energyEfficiency/greenDealLoan/hasGreenDealLoan/attachments` |
| Solar panel lease | `.../electricity/solarPanels/panelProviderLease/attachments` |
| Damp proofing guarantee | `.../guaranteesWarrantiesAndIndemnityInsurances/dampProofingTreatment/attachments` |
| Double glazing guarantee | `.../guaranteesWarrantiesAndIndemnityInsurances/doubleGlazing/attachments` |
| Consents under covenants for alterations | `/propertyPack/additionalInformation/consents/attachments` |
| Shared driveway / shared costs / jointly-used services | `/propertyPack/rightsAndInformalArrangements/sharedContributions` |
| Rights of light | `/propertyPack/rightsAndInformalArrangements/rightsOrArrangements/rightsOfLight` |
| Chancel repair liability | `/propertyPack/rightsAndInformalArrangements/rightsOrArrangements/churchChancel` |
| Chain position / onward purchase | `/propertyPack/completionAndMoving/otherPropertyInChain` |
| Lease extension notice on landlord | `/propertyPack/ownership/ownershipsToBeTransferred/[]/leaseholdInformation/enfranchisement/sellerServedNoticeOnLandlord/attachments` |
| Landlord consent for leasehold alterations | `/propertyPack/ownership/ownershipsToBeTransferred/[]/leaseholdInformation/alterations/sellerAwareOfAlterations/landlordConsentObtained/attachments` |
| Rights of support | `/propertyPack/rightsAndInformalArrangements/rightsOrArrangements/rightsOfSupport` |
| Prescriptive / customary rights | `/propertyPack/rightsAndInformalArrangements/rightsOrArrangements/rightsCreatedThroughCustom` |
| Mines and minerals | `/propertyPack/rightsAndInformalArrangements/rightsOrArrangements/minesAndMinerals` |
| Access restriction attempts | `/propertyPack/rightsAndInformalArrangements/accessRestrictionAttempts` |
| Broadband availability/speed | `/propertyPack/connectivity/broadband` |
| Controlled parking zone | `/propertyPack/parking/controlledParking` |
| EV charging point | `/propertyPack/parking/electricVehicleChargingPoint` |
| Council tax band | `/propertyPack/councilTax/councilTaxBand` |
| Smart home systems present? | `/propertyPack/smartHomeSystems/hasSmartHomeSystems` |
| Seller lives at property? | `/propertyPack/occupiers/sellerLivesAtProperty` |
| Dates seller cannot move | `/propertyPack/completionAndMoving/moveRestrictionDates` |
| Sale proceeds clear mortgages? | `/propertyPack/completionAndMoving/sufficientToRepayAllMortgages` |
| Disputes/complaints | `/propertyPack/disputesAndComplaints/hasDisputesAndComplaints` |
| Boundary dispute with neighbour | `/propertyPack/disputesAndComplaints/hasDisputesAndComplaints` (NOT `legalBoundaries/*`) |
| Potential future disputes | `/propertyPack/disputesAndComplaints/leadingToDisputesAndComplaints` |
| Difficulty obtaining buildings insurance | `/propertyPack/insurance/difficultiesObtainingInsurance` |
| EPC certificate | `/propertyPack/energyEfficiency/certificate` |
| New build? | `/propertyPack/buildInformation/isNewBuild` |
| HMO? | `/propertyPack/buildInformation/isHMO` |
| Septic tank: public sewer within 100ft | `/propertyPack/waterAndDrainage/drainage/publicSewerWithin100ft` |
| Services crossing (burdening): neighbour services on this property | `/propertyPack/servicesCrossing/pipesWiresCablesDrainsFromProperty` |
| Services crossing (benefitting): services to this property on neighbour land | `/propertyPack/servicesCrossing/pipesWiresCablesDrainsToProperty` |
| Deed of covenant required? (leasehold) | `/propertyPack/ownership/ownershipsToBeTransferred/[]/leaseholdInformation/transferAndRegistration/deedOfCovenantRequired` |
