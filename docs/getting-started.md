# Getting Started with the UK Conveyancing Toolkit

## Quick setup (2 minutes)

### Claude Code (terminal)

```bash
# Add the Moverly marketplace
/plugin marketplace add MoverlyLtd/conveyancing-toolkit

# Install what you need
/plugin install sdlt-calculator@conveyancing-toolkit
/plugin install lenders-handbook-prescreen@conveyancing-toolkit
/plugin install lease-impact-advisor@conveyancing-toolkit
/plugin install ca-protocol-compliance@conveyancing-toolkit
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

These tools work immediately — no Moverly account, no API key, no configuration:

- **Calculate SDLT** for any residential purchase
- **Pre-screen lender requirements** against UK Finance Handbook (Part 1 + Part 2 for 60+ lenders)
- **Compare lenders** in parallel for a specific property
- **Assess lease impact** — saleability, lender eligibility, extension costs, buyer pool restriction
- **Audit protocol compliance** against Law Society, CA, CQS, or CLC standards
- **Cite authoritative sources** from 100+ curated legal references

### With Moverly API access

Connect to live transaction intelligence:

- **View transaction risk flags** with evidence provenance and commercial impact
- **Upload documents** for automated classification and analysis
- **Raise and manage enquiries** linked to specific risk flags
- **Generate Reports on Title** from verified data
- **Vouch data** into PDTF-structured claims with full audit trail

## First things to try

**Estate agent listing a leasehold property:**
> "This property has 68 years on the lease and is worth about £425,000. What's the impact on saleability?"

**Conveyancer starting a new file:**
> "Pre-screen this property against Nationwide and Barclays Part 2 requirements — it's a leasehold flat with 82 years remaining and a doubling ground rent clause."

**Running a CA Protocol audit:**
> "Check my transaction against the CA Protocol 5th Edition. We have title, TA6 and TA7 are complete, local search is back but environmental is outstanding."

**Quick SDLT check:**
> "Calculate SDLT on a £425,000 purchase for a first-time buyer."
