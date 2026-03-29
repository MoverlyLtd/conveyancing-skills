# Getting Started with UK Conveyancing in Claude

## Quick setup (2 minutes)

### Claude Code (terminal)

```bash
# Add the Moverly marketplace
/plugin marketplace add MoverlyLtd/conveyancing-skills

# Install what you need
/plugin install sdlt-calculator@conveyancing-skills
/plugin install lenders-handbook-prescreen@conveyancing-skills
/plugin install ca-protocol-compliance@conveyancing-skills
```

### Claude Cowork (web)

Go to **Settings → Connectors → Add Custom Connector** and enter:
- **Name:** Moverly
- **URL:** `https://api-staging.moverly.com/mcpService/mcp`
- **Auth:** OAuth (generate credentials from your Moverly account under API Access)

### OpenClaw

Add to your `openclaw.yaml`:
```yaml
skills:
  - name: moverly-connect
    path: ~/.openclaw/skills/moverly-connect
  - name: moverly-diligence
    path: ~/.openclaw/skills/moverly-diligence
```

---

## What you can do right now

### No setup needed

These skills work immediately — no Moverly account, no API key, no configuration:

- **Calculate SDLT** for any residential purchase
- **Pre-screen lender requirements** against UK Finance Handbook (Part 1 + Part 2 for 60+ lenders)
- **Compare lenders** in parallel for a specific property
- **Audit protocol compliance** against Law Society, CA, CQS, or CLC standards

### With Moverly API access

Connect to live transaction intelligence:

- **View transaction risk flags** with evidence provenance
- **Upload documents** for automated classification and analysis
- **Raise and manage enquiries** linked to specific risk flags
- **Generate Reports on Title** from verified data
- **Vouch data** into PDTF-structured claims with full audit trail
