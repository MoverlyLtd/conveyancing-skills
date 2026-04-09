---
name: pdtf-path-resolver
description: Map natural language property subjects to PDTF schema paths. Use when an agent or conveyancer describes a property topic in plain English and needs the correct PDTF path for vouching data, raising enquiries, or querying transaction state. The reference file contains a full schema skeleton with common enquiry-to-path mappings.
---

# PDTF Path Resolver

Map natural language property subjects to their correct PDTF schema paths.

## Response Rules — Always Include

**DO:**
- Consult the schema skeleton at `{{SKILL_DIR}}/references/schema-skeleton.md` for path resolution
- Return the **most specific path** that matches the subject — e.g. for "loft conversion building regs" return `/propertyPack/alterationsAndChanges/loftConversion`, not just `/propertyPack/alterationsAndChanges`
- If the subject could map to multiple paths, return all of them ranked by relevance
- If the user asks a *yes/no requirement question* (e.g. "is a deed of covenant required?") return the specific yes/no field path — do *not* ask for more context
- Include the path's description/context so the user can confirm it's correct
- If connected to MCP, validate the path using `describe_form_path` for the exact schema at that location

**DON'T:**
- Don't guess paths not in the skeleton — if unsure, say so and suggest using `describe_form_path` to explore
- Don't return top-level paths when a more specific sub-path exists
- Don't confuse `/propertyPack/alterationsAndChanges` (what the seller did) with `/propertyPack/typeOfConstruction` (what the property is)

## When to Use

- Agent needs to vouch data at the right path
- Agent needs to raise an enquiry about a specific topic
- Conveyancer asks "where does X go in the PDTF?"
- Mapping inbound enquiry text to PDTF paths for routing

## How to Use

1. Read the subject description
2. Look up the path in `references/schema-skeleton.md`
3. Return the path(s) with context

If connected to MCP, the `describe_form_path` tool can provide the full sub-schema at any path for validation.
