You have the Moverly MCP server connected. We're going to demonstrate pre-emptive risk handling by a seller's conveyancer on a real transaction. Do not ask for confirmation at any step; just proceed directly to execute all steps and narrate what you are doing.

**Step 1: Find the demo transaction and check risks**
We will use transaction `VsiDBwzgVw9WMpk5r76aqu`. Call `moverly_get_insights` with `evidenceBasis: ["data-driven", "evidence-incomplete"]` to see the current risk profile. Show me the risk scores and the total number of flags.

**Step 2: Snapshot the timestamp**
Note the current time. Store it as the "demo start" timestamp so we can reset later.

**Step 3: Pre-emptively fix a data risk (Vouch)**
Find the flag for "Electrical Safety Certificate" (or similar). The data is missing. 
Use `moverly_describe_path` on `/propertyPack/electricalWorks/testedByQualifiedElectrician/yesNo` to understand the required JSON schema.
Then, call `moverly_vouch` to submit a "Yes" value at that path to confirm the electrics have been tested. 

**Step 4: Pre-emptively fix a document risk (Upload)**
Find the flag for "Windows/glazed doors - Building regulations compliance". It requires a FENSA certificate.
Here is a base64 encoded realistic dummy FENSA certificate PDF:
JVBERi0xLjQKMSAwIG9iago8PCAvVHlwZSAvQ2F0YWxvZyAvUGFnZXMgMiAwIFIgPj4KZW5kb2JqCjIgMCBvYmoKPDwgL1R5cGUgL1BhZ2VzIC9LaWRzIFszIDAgUl0gL0NvdW50IDEgPj4KZW5kb2JqCjMgMCBvYmoKPDwgL1R5cGUgL1BhZ2UgL1BhcmVudCAyIDAgUiAvTWVkaWFCb3ggWzAgMCA2MTIgNzkyXSAvUmVzb3VyY2VzIDw8IC9Gb250IDw8IC9GMSA0IDAgUiA+PiA+PiAvQ29udGVudHMgNSAwIFIgPj4KZW5kb2JqCjQgMCBvYmoKPDwgL1R5cGUgL0ZvbnQgL1N1YnR5cGUgL1R5cGUxIC9CYXNlRm9udCAvSGVsdmV0aWNhID4+CmVuZG9iago1IDAgb2JqCjw8IC9MZW5ndGggMzk3ID4+CnN0cmVhbQpCVAovRjEgMjQgVGYKMTAwIDcwMCBUZAooRkVOU0EgQ2VydGlmaWNhdGUgb2YgQ29tcGxpYW5jZSkgVGoKRVQKQlQKL0YxIDEyIFRmCjEwMCA2NTAgVGQKKENlcnRpZmljYXRlIE51bWJlcjogMTA2NDE5MTcpIFRqCjAgLTE1IFRkCihEYXRlIG9mIElzc3VlOiAyMDIxLTExLTEwKSBUagowIC0zMCBUZAooUHJvcGVydHkgQWRkcmVzczogMTAgRG93bmVuZCBQYXJrLCBCcmlzdG9sLCBCUzcgOVBVKSBUagowIC0zMCBUZAooQ29tcGFueSBOYW1lOiBCcmlzdG9sIFByZW1pZXIgV2luZG93cyBMdGQpIFRqCjAgLTE1IFRkCihDb21wYW55IEZFTlNBIFJlZ2lzdHJhdGlvbiBOdW1iZXI6IDg3NjU0KSBUagowIC0zMCBUZAooV29ya3MgQ29tcGxldGVkOiBSZXBsYWNlbWVudCBvZiA3IFdpbmRvd3MsIDAgRG9vcnMuKSBUagowIC0zMCBUZAooQ29tcGxpYW5jZSBTdGF0ZW1lbnQ6IFRoaXMgaW5zdGFsbGF0aW9uIGNvbXBsaWVzIHdpdGggdGhlIHJlbGV2YW50KSBUagowIC0xNSBUZAoocmVxdWlyZW1lbnRzIG9mIHRoZSBCdWlsZGluZyBSZWd1bGF0aW9ucyAyMDEwIGZvciBFbmdsYW5kIGFuZCBXYWxlcy4pIFRqCkVUCmVuZHN0cmVhbQplbmRvYmoKeHJlZgowIDYKMDAwMDAwMDAwMCA2NTUzNSBmIAowMDAwMDAwMDA5IDAwMDAwIG4gCjAwMDAwMDAwNTggMDAwMDAgbiAKMDAwMDAwMDExNSAwMDAwMCBuIAowMDAwMDAwMjM4IDAwMDAwIG4gCjAwMDAwMDAzMjYgMDAwMDAgbiAKdHJhaWxlcgo8PCAvU2l6ZSA2IC9Sb290IDEgMCBSID4+CnN0YXJ0eHJlZgo3NzQKJSVFT0Y=

Call `moverly_upload_document` to upload this file as `FENSA_Certificate.pdf`. Use the path `/propertyPack/guaranteesWarrantiesAndIndemnityInsurances/doubleGlazing/attachments`.
Next, poll `moverly_get_queue`. Keep polling every 10 seconds until the document is fully classified and summarised, and the queue is clear for this transaction. Do not proceed to Step 5 until processing is completely finished.

**Step 5: Verify resolution**
Call `moverly_get_insights` again with `evidenceBasis: ["data-driven", "evidence-incomplete"]`. 
Compare the new insights to the baseline from Step 1. Show me how the risk profile has changed and confirm the flags we targeted have dropped in severity or resolved completely.

**Step 6: Reset for next demo**
Use `moverly_delete_claims_after` with the "demo start" timestamp from Step 2, in `dryRun: false` directly to clean up our test vouches and documents.

Finish with a brief debrief on how pre-emptive actions immediately affect the Diligence Engine's risk scores.
