# Reference architecture: a governed AI environment for a conveyancing firm

### How to build tier 2 — where the guardrails become enforceable and the audit trail writes itself

---

This is the implementation companion to [Safe AI Environments](safe-ai-environments.md), which sets out why a skill can coach but cannot enforce, and describes a four-tier enforcement gradient. Read that first if you haven't.

**Who this is for:** the COLP, COFA, practice manager or IT partner who has decided that "we have a policy" is not the same as "we have evidence", and wants to know what to actually build.

**Prerequisite:** tier 1 — firm-owned accounts on an admin-managed plan, retention and training settings configured, a written AI policy naming approved tools. If you haven't done that, do it first. It is procurement rather than engineering, and it is the larger share of the benefit.

**Scope note:** this describes a pattern, not a product. It is written to be implementable against whichever AI host and case-management system a firm already has. Where a specific vendor is named it is as a worked example, and one section discloses our own commercial interest.

---

## 1. The shape of it

```
    Fee-earner
        │  (authenticates as themselves)
        ▼
┌───────────────────────┐
│  Managed AI host      │   Firm-owned accounts, SSO, admin policy
│  + provisioned skills │   Guardrail skills pushed to everyone
└───────────┬───────────┘
            │  tool call, carrying the USER's identity
            ▼
┌───────────────────────────────────────────────┐
│  CONNECTOR  (MCP or equivalent)               │  ◀── the enforcement point
│                                               │
│   authenticate → authorise → minimise → log   │
└───────────┬───────────────────────┬───────────┘
            │                       │
            ▼                       ▼
┌───────────────────────┐   ┌───────────────────┐
│  Systems of record    │   │  Event log        │
│  case mgmt, matter    │   │  every request,   │
│  data, transaction    │   │  every release    │
│  platform             │   └─────────┬─────────┘
└───────────────────────┘             │
                                      ▼
                            ┌───────────────────┐
                            │  Evidence export  │
                            │  → DPIA, ROPA,    │
                            │    AI use register│
                            └───────────────────┘
```

Everything hangs off one idea: **there is exactly one path from the AI to client data, and that path checks and records every transit.** Copy-paste is not a second path so much as a hole where the path should be — closing it is the point of the exercise.

---

## 2. Components

### 2.1 Identity and host

Firm-owned accounts on an admin-managed tier, ideally federated to the firm's existing identity provider so that joiners and leavers are handled once. This is not a governance nicety: **every downstream control in this document depends on knowing which human is asking.** If identity stops at the front door, the rest of the architecture is decoration.

### 2.2 Skill provisioning

Push skills at the organisation level rather than leaving them to individual installation — domain skills for accuracy, guardrail skills for coaching. Maintain the list; a skill registry that has drifted from what people actually use is worse than none, because it makes the policy look maintained when it isn't.

Guardrail skills remain best-effort. They are here to build habits, and they are the visible surface staff experience as "the firm has thought about this". They are not the control.

### 2.3 The connector — the enforcement point

This is where governance stops being aspirational. Four jobs, in order, on every single request:

**Authenticate.** Establish which human is asking. See §3.1 — this is the rule most implementations get wrong, and getting it wrong voids both of the benefits you are buying.

**Authorise.** Deny by default. Scope to the matters that user works on and the roles they hold. The correct mental model is not "the AI has access to the case management system" — it is "the AI can see exactly what this fee-earner can see, and nothing else". If the connector can reach data the user couldn't open themselves, you have built a privilege-escalation route with a chat interface on it.

**Minimise.** Return fields, not files. A summarisation task needs the chronology's events, not the client's bank details that happen to sit three pages later in the same document. Field-level responses are what turn "data minimisation" from a policy sentence into an enforced property — and they are also, usefully, cheaper and more accurate, because the model isn't wading through irrelevance.

**Log.** Record the request and what was released. §4 covers the fields.

### 2.4 Systems of record

Whatever holds the matter — case management (LEAP, Clio, Osprey, Proclaim), a transaction platform, a document store. The connector reads from these; it should not become a second copy of them (§3.6).

### 2.5 Evidence export

A scheduled or on-demand export from the event log into whatever register the firm maintains. The design goal is that **nobody types into the register.** A register maintained by hand decays between audits; one generated from events does not.

---

## 3. Design rules that make or break it

These are the decisions that determine whether you end up with a governed environment or an expensively-packaged version of the same problem.

### 3.1 Authenticate as the user, never as a service account

**This is the one.** The tempting shortcut is to give the connector a single API token with broad access to the case management system, and let the AI use it for everybody. It is faster to build and it destroys both benefits at once:

- **Access control is gone.** The token's permissions apply, not the user's. Every fee-earner can now reach every matter, including the ones they are conflicted out of.
- **The audit trail is worthless.** Every row says the service account did it. You can prove an AI touched a matter; you cannot say who asked, which is the only fact anyone will want.

The requirement is that the user's identity travels with the call and the connector resolves permissions against *that* user. Where a supplier's token model is scoped to the organisation rather than the individual, the firm must supply the user identity at the host or gateway layer and have the connector honour it — and should treat that as a procurement question, not an implementation detail. **Ask every supplier: does your audit log name the individual, or the token?**

### 3.2 Read paths before write paths

Ship read access first. Let the AI fetch matter data, summarise, draft, check. Only then consider letting it write back — and when you do, require the same authorisation checks plus an explicit human confirmation step for anything that leaves the firm or alters a record. Read access has a bounded failure mode. Write access does not.

### 3.3 Configure the lawful basis once, stamp it every time

Determine the Article 6 basis (and any Article 9 condition) per deployment, with the DPO or counsel, and record it in the connector's configuration. Every logged event then carries it. This is the practical answer to "did the fee-earner know the lawful basis?" — the honest answer is that they didn't and shouldn't have to. Encode the decision once, at the layer that can apply it consistently, rather than expecting recall at the point of use.

Be clear about what the per-event stamp is *for*. The processing is lawful because of the standing basis — the retainer, the processing record, the privacy notice — **not** because a row was written to a log. Article 6 is a once-per-purpose determination, not a per-click one, and no one should read this design as re-establishing lawfulness on every call. The stamp does something narrower and still useful: it makes the exported register **self-describing** (each row states the basis that applied, without a join back to configuration), and it evidences **accountability** under Article 5(2) — the ability to *demonstrate* the basis was applied — rather than creating the lawfulness itself. Don't let a compliance document claim the log is what makes the processing lawful; it isn't.

### 3.4 Log the response scope, not just the request

"User X called get_matter at 14:32" is a start. "User X requested the chronology for matter Y and received fields A, B, C — 400 tokens, no financial fields, no special-category fields" is evidence. The second form is what lets you answer *what was disclosed*, which is the question clause 8.3 and a DPIA both actually pose.

### 3.5 Make refusals loud and useful

When the connector declines, the user must see why and what to do instead. A silent denial teaches people that the governed route doesn't work, and the fastest way to recreate shadow AI is to make the compliant path feel broken. Refusal messages are a retention feature.

### 3.6 Don't let the connector become a second data store

Cache for performance if you must; do not accumulate. Every persisted copy is new retention, new breach surface and a new answer owed on a DPIA. The connector should be a controlled window onto systems of record, not a warehouse beside them.

### 3.7 Treat the guardrail skills as UX, the connector as control

Keep the coaching layer — it is what makes the environment feel supportive rather than surveilled, and it catches the paste that happens anyway. Just never let it appear in a compliance document as a control. Two layers, two claims, honestly labelled.

---

## 4. What the event log needs to carry

One row per release of data. The right-hand column is why each field exists — if a field can't earn a place there, don't collect it.

| Field | Answers |
|---|---|
| Timestamp | When |
| **User identity** | **Who — the individual, not the token (§3.1)** |
| Matter / transaction reference | Which client's data |
| Tool or operation called | What was asked |
| Fields or paths released | **What was actually disclosed** |
| Data classes touched | Whether special-category or financial data was involved |
| Lawful basis (+ Art. 9 condition) | GDPR Art. 6 / Art. 9, from configuration (§3.3) |
| Model and provider invoked | Which processor received it — GDPR Art. 28 |
| Outcome | Released, partially released, or denied and why |

Aggregate that and you have, without anyone maintaining a spreadsheet: a processing record, the per-use evidence a clause 8.3 review expects, a defensible answer on processors and transfers, and — usefully — a picture of what your firm is actually using AI for.

That last one is worth more than it sounds. Most firms cannot answer it, and it turns out to be the input a sensible AI strategy needs.

---

## 5. Worked example — Claude Desktop / Claude for Work

Named because it is currently the fastest route from nothing to a working tier-2 environment for a small or mid-sized firm: admin-managed connectors, organisation-level skills, and an MCP client built in. The pattern is not specific to it (§6).

1. **Move the firm onto a managed plan.** Firm-owned accounts, SSO to your identity provider, retention and training settings configured to your policy.
2. **Provision skills at the organisation level** — the domain skills your team needs, plus the [data-protection guard](../data-protection-guard/) and [safe-AI gate](../safe-ai-gate/).
3. **Add your connectors at the admin level, not per-user.** Admin-managed means staff cannot quietly add an ungoverned one, which is the whole point.
4. **Wire the connector to your systems of record** with per-user authorisation (§3.1) and field-level responses (§2.3). Read-only to begin (§3.2).
5. **Turn on the event log and check a real row.** Do this before rollout: run a genuine query and read what was written. If the row doesn't name the individual and the fields released, fix that before anyone relies on it.
6. **Point your register at the export** (§4), and record the lawful basis in the connector config (§3.3).
7. **Roll out with the refusal path tested** (§3.5) and tell people plainly what is logged. An environment people trust and use beats a stricter one they route around.

Realistic effort: steps 1–3 are configuration, days rather than weeks. Step 4 is the engineering, and its size depends entirely on whether your case-management vendor exposes a permissioned API. That question is worth asking before anything else on this list.

---

## 6. The same pattern elsewhere

What transfers, and what to check:

| Host | Transfers | Check |
|---|---|---|
| **ChatGPT Enterprise** | Admin-managed connectors, org-provisioned skills, the whole connector layer unchanged | Connector governance is admin-controlled, not user-added |
| **Microsoft 365 Copilot / Copilot Studio** | Identity and access control are strong here — it's already federated to your tenant | Whether agent actions log the *data* released, not just the invocation |
| **Cursor / IDE and CLI agents** | Connector layer unchanged | Local configuration files can add ungoverned connectors — this is the weakest host for enforcement, and a poor fit for client data |
| **Anything else speaking MCP** | Connector layer unchanged | Same three questions: admin-managed? per-user identity? data-level logs? |

The portability is the point. **The connector is the control; the host is a preference.** Architect so that a firm switching AI vendor changes its front end and keeps its governance — anything else is a lock-in you're building for yourself.

---

## 7. Anti-patterns

- **The shared service account.** §3.1. The most common and most damaging.
- **The connector that mirrors the whole matter file** because field-level scoping was harder. You have built a second, less-governed copy of your case management system.
- **Logging the prompt.** Tempting, and it puts client data into a new store with its own retention and breach exposure. Log the *fields released*, not the free text.
- **Guardrail skills cited as controls** in a DPIA. They will not survive a competent auditor's first question, and the rest of the document loses credibility with them.
- **Governing the platform, ignoring the ad-hoc.** Automating your known workflows while the improvised long tail runs on personal accounts leaves the actual exposure untouched — that is where the risky ad-hoc paste lives.
- **Enforcement so tight nobody uses it.** Shadow AI is the failure mode, and it is invisible until it isn't.

---

## 8. Questions to ask any supplier

Including us. Print this.

1. Does your audit log identify the **individual user**, or only the token / organisation?
2. Does it record **which fields were released**, or only that a call happened?
3. Can we scope access **per user and per matter**, and is it deny-by-default?
4. Can we **export the log** into our own register, on a schedule, in a documented format?
5. Who are your **subprocessors**, where is data processed, and under what transfer mechanism?
6. Do you **train on our data**? Is that contractual, or a setting someone can change?
7. What is your **retention** for prompts, responses and logs, and can we set it?
8. What **external assurance** do you actually hold — as distinct from what standard you are "aligned to"?

Question 8 is the one that separates suppliers, and the honest answer is often "none yet". That is fine. Being told it plainly is the signal worth having.

---

## 9. Limits, and a disclosure

This architecture makes AI use **governable and evidenced**. It does not:

- **Stop shadow AI.** It removes most of the motive to paste, not the ability.
- **Make the answers correct.** Access control and accuracy are orthogonal. A perfectly governed system can be confidently wrong; that needs separate evidence — validated tools, cited sources, measurement against expert judgement.
- **Transfer the obligation.** The firm remains controller. This makes the evidence cheap to produce; the DPIA, the LIA and the sign-off stay yours.

**Disclosure:** this document is published by [Moverly](https://moverly.com), and we build a connector of exactly the kind described at §2.3 — for property transaction data specifically, not for the whole case file. That is our commercial interest, stated so you can weight the argument. We hold **Cyber Essentials**; we structure our AI management documentation against ISO/IEC 42001 and maintain a DPIA, but we hold **no ISO/IEC 42001 or SOC 2 certification** and claim none. The pattern above is deliberately written so that it works with any supplier who can answer §8 well.

Corrections and contributions welcome — [open an issue](https://github.com/MoverlyLtd/conveyancing-toolkit/issues).
