# Claude Code / Claude Cowork Setup

## Skills as Project Context

Copy skills into your project and they'll be available as context:

```bash
cp -r sdlt-calculator ./skills/
```

Claude Code will see the SKILL.md and scripts when working in your project.

## Moverly MCP Server

For `moverly-connect` and `moverly-diligence`, configure the MCP server in `.mcp.json` (project root or `~/.claude/.mcp.json`):

```json
{
  "mcpServers": {
    "moverly": {
      "url": "https://mcp.moverly.com/v1/mcp",
      "headers": {
        "Authorization": "Bearer ${MOVERLY_API_TOKEN}"
      }
    }
  }
}
```

Set your token as an environment variable:

```bash
export MOVERLY_API_TOKEN="mvly_pat_your_token_here"
```

## Claude Cowork (Web)

Claude Cowork requires OAuth for MCP connectors. In your Moverly account:

1. Go to **My Account → API Access → Connector Credentials**
2. Create a new connector credential
3. In Claude Cowork, add a custom MCP connector:
   - **Server URL:** `https://mcp.moverly.com/v1/mcp`
   - **Client ID:** (from step 2)
   - **Client Secret:** (from step 2)
   - **Authorization URL:** `https://mcp.moverly.com/v1/oauth/authorize`
   - **Token URL:** `https://mcp.moverly.com/v1/oauth/token`

The connector will prompt you to authorise access on first use.

## Verify

Ask Claude:

> "What are my active Moverly transactions?"

It should call the `moverly_list_transactions` MCP tool and return your transaction list.
