# Conveyancing Toolkit

Free, open-source AI skills for UK residential conveyancing.

Built by [Moverly](https://moverly.com). Open to everyone.

---

## What this is

AI skills that give conveyancers instant access to structured property intelligence — lender requirements, SDLT calculations, lease assessments — through the AI tools you already use.

Every skill is **free, open source, and MIT-licensed**. No subscription. No API key. No vendor lock-in.

## Skills

| Skill | What it does |
|-------|-------------|
| **[SDLT Calculator](sdlt-calculator/)** | Stamp Duty Land Tax — standard, first-time buyer, additional property, non-UK resident. Uses live rates, updated automatically. |
| **[Lease Impact Advisor](lease-impact-advisor/)** | Leasehold saleability assessment — risk banding, lender eligibility for 13 major lenders, extension cost estimates. |
| **[Lenders Handbook Pre-Screen](lenders-handbook-prescreen/)** | Full UK Finance Lender's Handbook Part 1 (90+ checks) plus Part 2 requirements for 67 individual lenders. |

More skills are coming — search report analysers, protocol compliance checkers, building regulations advisors, and more. [Tell us what you need.](https://github.com/MoverlyLtd/conveyancing-toolkit/issues)

---

## How to install

### ChatGPT

As of April 2026, ChatGPT supports skills natively (currently in beta for Business, Enterprise, Edu, and Teachers plans).

1. Go to **Settings** → **Features** and enable **Skills**
2. In your chat, type `/skill add` and paste the GitHub URL of the skill you want to use (e.g., `https://github.com/MoverlyLtd/conveyancing-toolkit/tree/master/sdlt-calculator`)
3. ChatGPT will automatically load the instructions and data
4. Ask your question naturally

For more details, see OpenAI's [Skills in ChatGPT guide](https://help.openai.com/en/articles/20001066-skills-in-chatgpt).

### Claude (claude.ai)

Claude now supports skills natively in both chats and Projects.

1. In your chat or Project, click the **Plus icon** (+) next to the text box
2. Select **Skills** > **Add skill**
3. Select **Add from GitHub** and paste the URL of the skill folder (e.g., `https://github.com/MoverlyLtd/conveyancing-toolkit/tree/master/lease-impact-advisor`)
4. Ask your question

For more details, see Anthropic's [Use Skills in Claude guide](https://support.claude.com/en/articles/12512180-use-skills-in-claude).

### Claude Code (terminal)

If you use Claude Code, just clone the repo and work from the directory:

```bash
git clone https://github.com/MoverlyLtd/conveyancing-toolkit.git
cd conveyancing-toolkit
claude
```

Claude Code will automatically read the skill files when relevant to your question.

### Cursor

Add the toolkit folder to your Cursor workspace. Cursor reads the `SKILL.md` files automatically and uses the reference data and scripts when you ask relevant questions.

### Other AI tools

These skills work with any AI tool that can read files or supports the Model Context Protocol (MCP). Each skill is just a markdown file with instructions, plus helper scripts and reference data — no special integration required.

---

## What can I ask?

Once you've loaded a skill, just ask questions in plain English:

**SDLT Calculator:**
- "What's the stamp duty on a £650,000 house?"
- "SDLT for a £300,000 first-time buyer purchase"
- "Calculate stamp duty on a £950,000 second home"

**Lease Impact Advisor:**
- "This flat has 68 years on the lease — can they get a mortgage?"
- "Which lenders accept a 72-year lease?"
- "What's the estimated cost to extend a 65-year lease on a £350,000 flat?"

**Lenders Handbook Pre-Screen:**
- "Pre-screen this property against Nationwide's handbook requirements"
- "Does HSBC need to be notified about Japanese knotweed?"
- "What does Santander's Part 2 say about new-build properties?"

---

## Why skills, not just asking the AI?

AI models are trained on data that goes stale. Tax rates change on budget day. Lender thresholds change quarterly.

When we tested SDLT calculations across five leading models, **three out of five got it wrong** — the same wrong answer, confidently delivered:

| Model | Without Skill | With Skill |
|-------|:---:|:---:|
| Claude Opus 4 | ✅ Correct | ✅ Correct |
| GPT-5.4 Mini | ✅ Correct | ✅ Correct |
| GPT-5.2 | ❌ Wrong | ✅ Correct |
| Gemini 3 Flash | ❌ Wrong | ✅ Correct |
| Gemini 2.5 Pro | ❌ Wrong | ✅ Correct |

Skills fix this because they give the AI live, structured data instead of relying on its training. When rates change, the skill is updated and every user gets the right answer immediately.

---

## Contributing

We want this to become the profession's toolkit — not just ours.

**Ideas for new skills:**
- Pre-exchange checklists
- Completion statement calculators
- Search report analysers
- Protocol compliance checkers
- Building regulations advisors

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add a skill. Every contribution stays MIT-licensed and free forever.

---

## About

Built and maintained by [Moverly](https://moverly.com) · [MIT License](LICENSE) · [Documentation](docs/)
