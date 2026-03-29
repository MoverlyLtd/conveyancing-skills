# FAQ — AI in Conveyancing

## Is this legal advice?

No. These tools provide information, analysis, and automation — not legal advice. Every output is grounded in verified data and cites its sources, but a qualified conveyancer must review and apply professional judgment before acting. The tools are designed to make that judgment faster and better-informed, not to replace it.

## Will this replace conveyancers?

No. The work splits roughly 70/30: about 70% of conveyancing is intelligence work (gathering data, checking requirements, chasing documents, compiling reports) and about 30% is genuine professional judgment (interpreting edge cases, advising clients, negotiating terms, managing risk). These tools handle the 70% so conveyancers can focus on the 30% that actually requires their expertise.

## Does this just flag risks, or does it tell me what they mean?

Both. The toolkit goes beyond risk scores to provide commercial impact — what an issue costs, how it affects saleability, and which lenders will and won't accept it. For example, the Lease Impact Advisor doesn't just say "short lease, high risk." It tells you that a 68-year lease restricts the buyer pool to 6 out of 13 major lenders, carries a 15-30% price discount, and will cost £45,000-£88,000 to extend. This commercial intelligence layer is being built into every scenario across the Diligence Engine.

## How accurate is the risk analysis?

The Moverly Diligence Engine is deterministic — it applies the same 2,215 rule-based scenarios consistently every time, across 37 risk categories and 323 individual checks. It doesn't guess or hallucinate. Every flag includes an evidence basis (data-driven, evidence-incomplete, or no-data) and full provenance showing exactly what data led to each conclusion.

## What data do you use?

All intelligence comes from verified, provenanced sources: title registers, property searches, seller information forms (TA6/TA7/TA10), EPCs, planning records, flood data, and other standard conveyancing data. Every data point has a full audit trail showing who provided it, when, and how it was verified. The system uses the Property Data Trust Framework (PDTF) — the UK's emerging standard for structured property data.

## Can I use this without a Moverly account?

Yes. Most tools work standalone with no account or API key:

- **SDLT Calculator** — accurate calculations for all buyer types
- **Lender Pre-Screen** — UK Finance Handbook Part 1 + Part 2 for 60+ lenders
- **Lease Impact Advisor** — saleability assessment, lender eligibility, extension costs
- **Protocol Compliance** — Law Society, CA, CQS, and CLC checklists
- **Property Law Reference** — authoritative citations from GOV.UK, HMLR, LEASE Advisory

For live transaction intelligence (risk flags, document processing, enquiry management), you need a Moverly account with API access.

## Is my client data safe?

All data is processed under Moverly's existing security infrastructure — the same platform already used by LMS (the UK's largest conveyancing panel manager) and firms like Connells. Data is encrypted in transit and at rest, access is role-based per transaction, and every action is audited. AI processing uses Claude (Anthropic) with data handling agreements in place. No client data is used for model training.

## Which AI platforms does this work with?

- **Claude Code** (Anthropic) — full plugin marketplace support
- **Claude Cowork** (Anthropic) — custom MCP connector via OAuth
- **OpenClaw** — native skill installation
- **Any MCP-compatible platform** — Cursor, Perplexity Computer, etc.

The standalone skills work in any Claude environment. The Moverly-connected skills work with any platform that supports MCP (Model Context Protocol).

## How do I get started?

See the [Getting Started guide](getting-started.md). Setup takes about 2 minutes for standalone skills. For Moverly-connected skills, you'll need to generate an API token from your Moverly account settings.

## What about professional indemnity insurance?

The Diligence Engine is designed to be insurable. Because it's deterministic (not probabilistic), insurers can assess the risk profile of its outputs. Moverly is working toward bundling liability insurance with risk assessments. In the meantime, the tools support — not replace — the conveyancer's professional judgment, so existing PI cover applies to the decisions you make using the information provided.

## Can I customise the skills for my firm?

Yes. Skills are open-source (MIT licence) and designed to be forked. You can:
- Add your firm's template to the Report on Title skill
- Adjust protocol checklists to your internal procedures
- Create custom skills that combine multiple tools for your workflow
- Set up firm-specific lender shortlists

## How fresh is the data?

- **Lender Handbook data** — refreshed weekly via automated pipeline, diffs committed only when content changes
- **SDLT rates** — updated when HMRC publishes new thresholds
- **Protocol checklists** — updated when new editions are published
- **Live Moverly data** — real-time from verified sources, no caching
