# Safe AI environments for conveyancing firms

### What a skill can enforce, what it can't, and where the audit trail actually comes from

---

## Start from the obligation, not the tool

A firm adopting AI already holds the duties that govern it. Three of them decide what a safe AI environment has to do:

- **Accountability** (UK GDPR Article 5(2)) — you must be able to *demonstrate* compliance, not merely achieve it. A firm that cannot describe its own AI use — what data went to which tool, and whether it stayed within approved bounds — has failed this even if every individual use was lawful.
- **Security** (Article 32) — appropriate measures for confidential client data, which sensibly includes knowing who accessed what and controlling which tools client data can reach.
- **Processor governance** (Article 28) — where a third party processes client data, a written agreement must govern it; so client data may flow only to vendors the firm has actually vetted.

Two things worth stating plainly, because they are widely misread. A **lawful basis** (Article 6) is a standing determination made once — at the retainer, in the firm's processing record — not something re-established each time a fee-earner uses a tool. And a **processing agreement** with a vendor is settled once, at onboarding. Neither is a per-use event. So the recurring failure with ad-hoc AI use is rarely "no lawful basis in the abstract" — it is narrower and more practical: **data reaching a tool outside the approved set, with nothing recording that it happened.** That is the accountability-and-security gap above.

This is worth being precise about, because it determines what kind of thing fixes it. It is not a prompting problem. It is not solved by a better model, a longer policy document, or an annual training session. It is not even solved by *having* a lawful basis, which the firm may well have had. **It is a logging and access-control problem** — being able to show that AI use stayed inside approved bounds — and those are properties of the *environment* the AI runs in, not of the AI, and not of the instructions you give it.

Which brings us to an uncomfortable admission about AI skills, including the ones in this repository.

---

## What a skill can and cannot do

A "skill" — in ChatGPT, Claude, Cursor or anywhere else — is a markdown file with instructions and reference data. It loads when the host decides it is relevant, and it shapes how the model answers.

That makes skills genuinely good at some things and structurally incapable of others:

| A skill **can** | A skill **cannot** |
|---|---|
| Give the model current, correct domain data (rates, lender rules, thresholds) | Guarantee it runs on any particular turn — the host decides |
| Notice sensitive client data in an input and coach the user about it | Block the data from being sent — it sees the input only after it has arrived |
| Label an answer's provenance and warn when it is unverified | Withhold or quarantine an output |
| Tell the user what good practice looks like | Write a record of what happened — a markdown file has no backend |

That last row is the important one. **A skill cannot produce an audit trail.** It has nowhere to write one.

So any guardrail skill — ours included — is a *coach*, not a *control*. It builds a habit. It does not discharge an obligation. Anyone selling you a governance skill that claims otherwise is selling you a document that will not be there when you need it.

The fix is not a better skill. It is putting the skill in an environment that can enforce and record.

---

## The enforcement gradient

Firms are not choosing between "compliant" and "non-compliant". They sit somewhere on a gradient, and each step up buys a specific, nameable capability. Knowing where you are is most of the work.

### Tier 0 — Personal accounts, no configuration

Staff use consumer ChatGPT or Claude on their own logins. Data is pasted in by hand.

- **Enforcement:** none.
- **Audit trail:** none. You cannot answer "has anyone put client data into an AI tool?" — the honest answer is you don't know.
- **What guardrail skills give you:** nothing, because nobody installed them.

Most firms that believe they have "banned AI" are actually here.

### Tier 1 — Managed host, provisioned skills

The firm uses an admin-managed business or enterprise tier (Claude for Work, ChatGPT Enterprise, Microsoft 365 Copilot). Accounts are firm-owned. Guardrail skills are pushed to everyone rather than installed by the curious.

- **Enforcement:** partial. You control who has access, what training/retention settings apply, and which skills are present. You do not control whether a skill fires on a given turn.
- **Audit trail:** host-level. You can generally see that a user held a conversation, and administer retention. You typically **cannot** see which client data was in it.
- **What guardrail skills give you:** real value — coaching is reliably *present* rather than accidental.

This is the biggest single jump in practice, and it is mostly a procurement and configuration exercise. Most firms should be here before doing anything cleverer.

### Tier 2 — Managed host + a permissioned connector

The AI is connected to the firm's actual systems of record over a controlled interface (MCP, or an equivalent tool/connector layer), instead of being fed by copy-paste.

This is the step that changes the shape of the problem, for a reason that is easy to miss:

> **People paste files into chatbots because the model has no other way to see the matter.**

Give the model a governed route to the matter and the paste stops being necessary. That single change delivers, *architecturally* rather than by exhortation:

- **Data minimisation** — the connector returns the fields the task needs, not the whole file.
- **Access control** — the connector enforces the user's role and permissions. A model asking on behalf of a fee-earner gets what that fee-earner is entitled to see, and no more.
- **A known processor** — data goes to one contracted vendor with a DPA and a disclosed subprocessor chain, instead of whatever service an individual signed up for.
- **A real audit trail** — every request is a logged event: who, when, which matter, which fields, which model.

That last point is the prize. At tier 2, the compliance record stops being a spreadsheet somebody is supposed to maintain and becomes **a by-product of using the system**. Registers that are maintained by hand decay; registers that are generated do not.

- **Enforcement:** yes, at the connector — it decides what is releasable.
- **Audit trail:** data-level, and exportable into the register formats a DPIA or AI management system expects.

### Tier 3 — No general-purpose surface at all

The AI runs inside the case management or transaction platform itself. There is no chat box to paste into; the analysis is produced against data the system already holds, under the firm's existing processing terms.

- **Enforcement:** total, within that workflow.
- **Trade-off:** it only covers the workflows someone has built. It does nothing for the long tail of ad-hoc work — which is exactly where the risky paste happens.

**Tiers 2 and 3 are complements, not alternatives.** Tier 3 industrialises the routine; tier 2 governs the improvisation. A firm that only does tier 3 has automated its known processes and left its unknown ones entirely ungoverned.

---

## What each tier actually discharges

Mapped against the three duties from the top of this page — note that lawful basis (Article 6) is deliberately absent as a column, because it is a once-per-purpose determination, not a capability a tier delivers:

| | Accountability — Art. 5(2): can the firm *demonstrate* what its AI use touched? | Security & access control — Art. 32: is the data flow controlled and visible? | Processor governance — Art. 28: does data reach only vetted vendors? |
|---|---|---|---|
| **Tier 0** | ✗ — no record exists | ✗ — uncontrolled, invisible | ✗ — whatever a person signed up for |
| **Tier 1** | Partial — host-level logs, not data-level | Partial — firm-owned accounts, but paste is unconstrained | ✓ — enterprise terms with the host |
| **Tier 2** | ✓ — each release logged: who, what, which tool | ✓ — access enforced per user, per matter | ✓ — one vendor, disclosed subprocessors |
| **Tier 3** | ✓ | ✓ | ✓ |

Two caveats on reading this. First, a standing **lawful basis** (Article 6) still has to exist and be documented — it simply sits at the retainer, once, rather than moving tier by tier. Second, ISO/IEC 42001 is a **voluntary** management standard. Very few conveyancing firms will certify against it and most have no need to. Its value here is as a ready-made skeleton for a question firms are increasingly being asked in plain English — *what is your AI policy, and can you evidence it?* — by PII insurers, lender panels, corporate clients and, in time, regulators. Answering that well is the goal. Certification is optional.

**A note on the EU AI Act.** It is EU law, and the UK has not adopted it — the UK still relies on existing law and sector regulators rather than a cross-cutting AI statute. So for a UK firm handling UK transactions, the EU AI Act does not apply: the output is used in the UK, not the EU, which is the test its extraterritorial provision turns on. It becomes relevant only where a firm's AI-produced output is used *within* the EU — for example an Irish or EU-based practice, or a supplier selling into the EU. Even then, decision-support diligence of this kind is unlikely to fall in its "high-risk" tier, and the principal obligation — telling people when they are receiving AI-produced output — is already good practice under UK law. Treat it as an emerging reference standard to track, not a current UK obligation, and be wary of any supplier who markets it as one to a UK-only firm.

---

## Practical steps, in order

1. **Find out what tier you are on.** Ask, without blame, what staff are actually using. The answer is almost always "more than you think", and a firm that punishes the answer will never get an accurate one again.
2. **Get to tier 1.** Firm-owned accounts on an admin-managed plan, training/retention settings configured, a short written AI policy naming approved tools. This is procurement, not engineering.
3. **Install coaching guardrails and understand their limits.** This repository has two in draft — a [data-protection guard](../data-protection-guard/) and a [safe-AI gate](../safe-ai-gate/). Both state plainly what they cannot enforce. Treat them as habit-formers.
4. **Close the paste gap for your highest-volume matter data.** This is the tier-2 step, and it is where a connector to your case management or transaction platform earns its place. Start with the data people paste most. The [reference architecture](reference-architecture.md) sets out how to build it, and the design rules that decide whether it works.
5. **Export the log into your register.** Whatever you are keeping — a DPIA, a processing record, an AI management system — have it populated from the connector's events rather than from memory.
6. **Accept that you cannot cover everything.** Then say so in the policy, which is far more defensible than a policy that pretends otherwise.

---

## Honest limits

Some things this architecture does not fix, stated plainly because a governance document that oversells itself is worse than none:

- **It does not stop shadow AI.** Nobody can prevent a person opening a browser on their own phone. Tier 2 removes much of the *motive* to paste — it does not remove the *ability*. Firms that acknowledge this and manage it as a culture problem do better than firms that claim a technical solution.
- **It does not make the answers right.** Access control and audit logging are orthogonal to accuracy. An AI can be perfectly governed and confidently wrong. Those need separate evidence — validated tools, cited sources, and measurement against expert judgement.
- **It does not transfer the obligation.** The firm remains the data controller. A good connector makes the evidence cheap to produce; it does not make the DPIA, the legitimate interests assessment, or the sign-off somebody else's job.
- **Vendor claims deserve the same scrutiny.** Including ours. Ask any AI supplier what their subprocessors are, where data is processed, whether it trains on your data, what their audit export looks like, and what external assurance they actually hold — as opposed to what standard they say they are "aligned to".

---

## About this document

Published by [Moverly](https://moverly.com) as part of the open-source [Conveyancing Toolkit](https://github.com/MoverlyLtd/conveyancing-toolkit). It is deliberately vendor-neutral: the enforcement gradient applies whichever AI host and case-management system a firm uses, and the tier-1 advice is the same regardless of who supplies tier 2.

In the interests of the scrutiny recommended above — Moverly holds **Cyber Essentials**. We structure our own AI management documentation against ISO/IEC 42001 and maintain a DPIA, but we hold **no ISO/IEC 42001 or SOC 2 certification** and make no claim to one. We build a permissioned, logged connector of the kind described at tier 2, which is our commercial interest in this subject, disclosed here so you can weight the argument accordingly.

Corrections and contributions welcome — [open an issue](https://github.com/MoverlyLtd/conveyancing-toolkit/issues).
