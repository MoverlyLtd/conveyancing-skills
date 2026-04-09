# OpenClaw Setup

## Install Skills

Copy the skills you want into your OpenClaw skills directory:

```bash
# Standalone skills (no account needed)
cp -r sdlt-calculator ~/.openclaw/skills/

# Moverly-connected skills (needs PAT)
cp -r moverly-connect ~/.openclaw/skills/
cp -r moverly-diligence ~/.openclaw/skills/
```

## Moverly MCP Connection (optional)

For the `moverly-connect` and `moverly-diligence` skills, you need a Moverly PAT. Add this to your `openclaw.yaml`:

```yaml
mcp:
  servers:
    moverly:
      transport: streamable-http
      url: https://mcp.moverly.com/v1/mcp
      headers:
        Authorization: Bearer ${MOVERLY_PAT}
```

Then set your PAT:

```bash
export MOVERLY_PAT="mvly_pat_your_token_here"
```

Or store it in a credentials file and reference it in your agent's environment.

## Verify Connection

Ask your agent:

> "List my Moverly transactions"

It should use the `moverly-connect` skill to call `list_transactions` via the MCP server.

## Skill Discovery

OpenClaw automatically discovers skills in `~/.openclaw/skills/`. Each skill's `SKILL.md` description tells the agent when to activate it. No additional configuration needed beyond copying the folder.
