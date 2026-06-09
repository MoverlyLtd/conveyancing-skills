# CLAUDE.md

Notes for Claude Code (and any agent) working in this repo. This is **not** a re-explanation of the README — it's the things you'd otherwise have to learn the hard way.

## What this repo is

A Claude Code marketplace plugin distributing free UK conveyancing AI skills. Most "code" is markdown (`SKILL.md`), JSON reference data, and small bash scripts. Edits are usually to skill prose, reference data, or install instructions — rarely to executable code. Audience for the user-facing files (README, `docs/`) is **conveyancers, not developers**.

## Why this exists

The bet behind every skill here: general-purpose models keep getting conveyancing details *confidently wrong* — stale SDLT rates, wrong lease thresholds, half-remembered lender rules — and a conveyancer can't tell a right answer from a plausible wrong one. These skills exist to close that gap and make AI **accurate and safe enough to actually rely on** in a regulated transaction. Trust, not raw capability, is the blocker we're attacking.

The proof — and the real product — is the **benchmark scorecard**: every skill is measured baseline (no skill) vs with-skill across many models. A skill earns its place by moving accuracy from unreliable into a trustable range; well-written prose that doesn't move the scorecard isn't done. **The scorecard lives in a separate Moverly repo (the demo/hosting repo), not here** — so when you add or materially change a skill, the eval that proves it works (`benchmarks/cases/<skill>.json`) lives over there. "The scorecard shows the lift" is the definition of done, not "the SKILL.md reads well".

A **second category** of skill is emerging — *guardrail* skills (data-protection, scope, verification) that constrain *how* the model behaves rather than adding topic knowledge. They follow different rules from the advisory/calculator skills below: they run on every turn and are scored on precision/recall, not a single right answer. They're not built yet — the design lives in `SKILLS_ROADMAP.md`.

## Skill anatomy

Every skill follows the same shape:

```
<skill-name>/
├── SKILL.md                    # required — the agent reads this
├── .claude-plugin/plugin.json  # optional — plugin metadata
├── scripts/                    # optional — deterministic helpers (bash)
└── references/                 # optional — lazy-loaded data (md tables, JSON)
```

`restrictive-covenant-advisor/` is `SKILL.md`-only — that's a valid shape for advisor-style skills with no calculations or large datasets.

## SKILL.md conventions used here

- **Frontmatter `description` is the trigger surface.** It's how agents decide whether to load the skill, so pack it with synonyms a user might say. See `sdlt-calculator/SKILL.md:3` ("stamp duty, SDLT, property tax on purchase, first-time buyer relief…"). When editing, preserve this density.
- **Keep SKILL.md under ~500 lines** (per `CONTRIBUTING.md`). Push detail into `references/`.
- **Open with a "Response Rules — Always Include" DO/DON'T block** for any skill where stale model knowledge would be dangerous (rates, thresholds, regulations). This is load-bearing — see `sdlt-calculator/SKILL.md:10` for the canonical pattern.
- **Imperative voice.** "Always run the script", not "you might want to". The reader is an agent.
- **Use `{{SKILL_DIR}}/...` for paths.** Resolves correctly regardless of how the skill is loaded.

## Determinism rule

Anything numeric (SDLT bands, lease calculations, rate lookups) goes in a bash script — never in the LLM's head. Models confidently produce stale rates from training data.

The pattern, established by `sdlt-calculator/scripts/sdlt-calc.sh` and `lease-impact-advisor/scripts/lease-calc.sh`:

1. Live-fetch current rates from the GitHub repo (1s timeout).
2. Fall back to a bundled JSON in the same directory.
3. Fall back to baked-in defaults.
4. Always print which source was used (`Rates from: ...`).

Replicate this for any new calculator-style skill.

## Copyright trap — handbook content

The UK Finance Lender's Handbook is licensed material. We learned this in real time: commit `8a4e4fa` added verbatim Part 2 markdown for 66 lenders → reverted in `fd492ff` → re-added as factual JSON only in `d0a17db`.

The rule:

- **Never** check in verbatim handbook prose.
- Extract **facts only** — numeric thresholds, contact details, named conditions, yes/no requirements — into structured JSON. One file per lender under `lenders-handbook-prescreen/references/lenders_json/`.
- Same logic applies to any future skill wrapping third-party regulatory text.

## `marketplace.json` lists only real skills

`.claude-plugin/marketplace.json` must list **only** plugins whose `source: ./<dir>` path resolves to a real directory containing a `SKILL.md`. Aspirational entries cause Claude's plugins marketplace to fail validation with "Marketplace sync failed".

Currently published (5): `sdlt-calculator`, `lease-impact-advisor`, `lenders-handbook-prescreen`, `restrictive-covenant-advisor`, `title-defect-advisor`. Roadmap and ideas live in `SKILLS_ROADMAP.md` — that's the right place for "we're considering X". When a planned skill becomes real, add it to `marketplace.json` and move it from Planned → Published in the roadmap.

## Releases and zip building

Tracked zips in `releases/` are what users download from GitHub for ChatGPT/Claude install. They must stay in sync with the source skill directories.

After editing any skill, rebuild:

```bash
npm run build:zips                      # rebuild all
npm run build:zips -- sdlt-calculator   # rebuild one
```

The script (`scripts/build-zips.sh`) puts `SKILL.md` at the **root** of the archive, not nested under a wrapper folder — that's what Claude/ChatGPT skill upload expects. Verify with `unzip -l releases/<skill>.zip | head`.

Root-level `*.zip` files are stale build artifacts (gitignored). Don't commit them.

## Voice for user-facing files

`README.md`, `CONTRIBUTING.md`, and `docs/*.md` are read by conveyancers. A few signals from history:

- Commit `3d25b8e` reworded install instructions to emphasize "skills only need to be installed once" — users were re-installing every chat.
- Commit `a7de61e` clarified ChatGPT skills availability by plan tier — wording matters.
- Commit `723f415` removed an inaccurate fallback suggestion for Free/Plus users.

Avoid developer jargon. Use Moverly's first-person plural voice. Be precise about what's beta vs GA and on which plan.

## Things NOT to do

- Don't expand `marketplace.json` for skills that don't exist on disk — the list is already ahead of reality.
- Don't rename existing skill directories — README install URLs point at them by name.
- Don't add **runtime** dependencies. The `package.json` exists for `npm run` ergonomics only and has no `dependencies` field — keep it that way so users can `git clone` and go.
- Don't commit root-level `*.zip` build artifacts (they're gitignored anyway).
- Don't check verbatim third-party regulatory text into `references/` — see the copyright trap above.

## For Moverly maintainers

- Issues live at `github.com/MoverlyLtd/conveyancing-toolkit/issues`.
- Contact for licence/contribution questions: `ed@moverly.com` (per `CONTRIBUTING.md`).
- The README's tone is intentionally Moverly's — first-person plural, conveyancer-friendly. Match it when editing.
