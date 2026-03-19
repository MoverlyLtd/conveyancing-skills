# Conveyancing Skills for AI Agents

Open-source skills that give AI agents accurate conveyancing knowledge. Built by [Moverly](https://moverly.com).

## What Are Skills?

Skills are instruction packs for AI agents. Each skill teaches an agent how to perform a specific task — calculating stamp duty, explaining title registers, running property diligence. The agent reads the skill's instructions, uses the bundled scripts and references, and gives the user a reliable answer.

Skills work with [OpenClaw](https://github.com/openclaw/openclaw), [Claude Code](https://docs.anthropic.com/en/docs/claude-code), and any agent platform that supports tool use.

## Available Skills

### Standalone (no account needed)

| Skill | Description |
|-------|-------------|
| [`sdlt-calculator`](skills/sdlt-calculator/) | Calculate Stamp Duty Land Tax for residential purchases in England & Northern Ireland. Standard rates, first-time buyer relief, additional property surcharge, non-resident surcharge. |

### Moverly-Connected (requires [Moverly](https://moverly.com) account)

| Skill | Description |
|-------|-------------|
| [`moverly-connect`](skills/moverly-connect/) | Connect to Moverly's property intelligence API. List transactions, check status, validate your connection. |
| [`moverly-diligence`](skills/moverly-diligence/) | Property risk intelligence — flags, evidence-based insights, action recommendations across 37 risk categories and 323 checks. |
| [`moverly-upload`](skills/moverly-upload/) | Upload case documents for automated diligence analysis. "PDF in, intelligence out" — title registers, searches, TA forms, leases. |

## Quick Start

### OpenClaw

Copy the skill folder into your agent's skills directory:

```bash
cp -r skills/sdlt-calculator ~/.openclaw/skills/
```

Or install from [ClawHub](https://clawhub.com):

```bash
npx clawhub install sdlt-calculator
```

### Claude Code

Skills work as project context. Copy the skill folder into your project:

```bash
cp -r skills/sdlt-calculator ./skills/
```

Then reference it in your `.claude/settings.json` or mention the skill directory in your system prompt.

### Any Agent Platform

Each skill is a self-contained directory with:
- `SKILL.md` — instructions for the agent (when to use, how to use, what to present)
- `scripts/` — deterministic tools the agent calls
- `references/` — detailed knowledge the agent can consult

Point your agent at the SKILL.md and it'll know what to do.

## Why Deterministic Skills?

LLMs are good at understanding questions and explaining answers. They're unreliable at remembering exact tax bands, legal thresholds, and regulatory rules. Skills solve this by giving the agent a script to run — the LLM handles the conversation, the script handles the calculation.

An agent without the SDLT skill might hallucinate old tax rates or forget the first-time buyer cap. With the skill, it runs `sdlt-calc.sh 425000 --ftb` and gets **£6,250** every time.

## Coming Soon

- `hmlr-explainer` — Decode HM Land Registry title registers in plain English
- `leasehold-toolkit` — Lease extension calculator, service charge analysis, Section 42 guidance
- `search-pack-guide` — What each property search covers and when to order extras
- `completion-checklist` — Exchange-to-completion tasks with deadlines
- `moverly-enquiries` — Raise and respond to pre-contract enquiries

## Moverly Connection Setup

The `moverly-connect` and `moverly-diligence` skills require a Moverly Personal Access Token (PAT).

1. Log in to your Moverly account
2. Go to **My Account → API Access**
3. Generate a new access token
4. Set it as an environment variable:

```bash
export MOVERLY_PAT="mvly_pat_your_token_here"
```

See [setup/openclaw.md](setup/openclaw.md) for OpenClaw-specific configuration, or [setup/claude-code.md](setup/claude-code.md) for Claude Code / `.mcp.json` setup.

## Contributing

We welcome contributions — new skills, improvements to existing ones, bug fixes. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT — use these skills however you like.

---

Built by [Moverly](https://moverly.com) — property intelligence infrastructure for the agentic era.
