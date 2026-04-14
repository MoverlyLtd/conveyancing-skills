# Building Custom Skills

Skills are instruction files that AI agents read and follow. No SDK, no framework, no build step. Just a markdown file called `SKILL.md`.

## Minimal skill

```markdown
---
name: my-firm-checklist
description: Pre-exchange checklist for [Firm Name]. Use when preparing for exchange of contracts.
---

# Pre-Exchange Checklist

When asked to run a pre-exchange check, verify each item:

1. Title reviewed and reported
2. Searches received and current (within 6 months)
3. Enquiries all resolved or accepted
4. Mortgage offer confirmed and conditions satisfied
5. Deposit arrangements confirmed
6. Insurance arranged from completion date
7. Completion date agreed
8. Contract signed by client
9. Certificate of title issued (if acting for buyer)
10. Completion statement prepared

Report status of each item. Flag any that are not confirmed.
```

That's a working skill. Save it as `SKILL.md` in a directory and point your agent at it.

## Adding helper scripts

For deterministic calculations (don't leave maths to the LLM):

```
my-skill/
├── SKILL.md
├── scripts/
│   └── calculate.sh
└── references/
    └── rates.md
```

SKILL.md references the script:

```markdown
## Calculation

Run `scripts/calculate.sh` with the required arguments:

\`\`\`bash
bash scripts/calculate.sh --price 425000 --buyer-type ftb
\`\`\`
```

## Adding reference data

For data the agent should consult but not hold in context all the time:

```markdown
## Reference data

When checking lender-specific requirements, read the relevant file from `references/lenders/`:

- Nationwide: `references/lenders/nationwide.md`
- Halifax: `references/lenders/halifax.md`
```

The agent loads the reference on demand — keeping context lean.

## Best practices

- **Description field is everything.** The agent matches your skill based on the description in the YAML frontmatter. Include all trigger phrases.
- **Keep SKILL.md under 500 lines.** Move detailed content to `references/` — the agent reads it on demand.
- **Be imperative.** "Fetch the page" not "You might want to fetch the page."
- **Include error handling.** Tell the agent what to do when things fail.
- **Test by using.** Install the skill and try real tasks. Notice where the agent gets confused. Fix the instructions.

## Publishing

### Claude Code Plugin Directory
Add a `.claude-plugin/plugin.json` to your skill directory.

### OpenClaw ClawHub
```bash
npx clawhub@latest publish
```

### GitHub
Push to a public repo. Users install via `/plugin marketplace add your-org/your-repo`.
