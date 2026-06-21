# Agent Handoff

## Issue

- GitHub issue: `#71`
- Roadmap entry: `docs/current/ROADMAP.md` > Ruling safety and deterministic mechanics maturation
- Mode: Project development
- Priority: P0

## Goal

Create the deterministic mechanics catalog that classifies RPG procedures by owner, authority posture, automation readiness, and next action.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `indexes/task-router.md`
- `indexes/rules-map.md`
- `indexes/manifest.yaml`
- `indexes/page-reference-index.md`
- `gm/rules-adjudication-posture.md`
- `gm/switch-to-classic-battletech.md`
- `docs/current/GM_CONTEXT_PACKET_DESIGN.md`
- GitHub issues `#70`-`#83`

## Expected Output

- New durable catalog, likely `docs/current/DETERMINISTIC_MECHANICS_CATALOG.md`.
- Clear classifications for agent-only, rules lookup only, authority gate, script prototype, deterministic candidate, state proposal, external authority, and blocked/source-review-gap areas.
- Roadmap and task state updated.

## Files And Areas

Likely files to read or edit:

- `docs/current/DETERMINISTIC_MECHANICS_CATALOG.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `rules/core/`
- `rules/personal-combat/`
- `rules/combat/`
- `rules/equipment/`
- `rules/campaign/`
- `rules/vehicles-and-mechs/`
- `rules/tactical/`

## Commands

Useful commands or checks:

```powershell
./scripts/report-rules-coverage.ps1
./scripts/validate-rules-indexes.ps1
./scripts/test-all.ps1
git status --short --branch
```

## Constraints

- Do not create mechanic resolver code in this issue.
- Do not turn table-heavy summaries into copied rules text.
- Exact tables, weapon stats, tactical modifiers, and unit records remain private source or external-tool lookups.

## Acceptance Criteria

- Core checks, opposed checks, Edge, initiative, personal combat, damage/wounds, healing/recovery, equipment use, campaign consequences, mission readiness, repairs, salvage, contract changes, vehicle/BattleMech handoff, and tactical combat are classified.
- Each entry states owner, status, reason, source/routing references, expected helper contract, and next action.
- Verification is run or blocker recorded.

## Open Questions

- Whether the catalog should use a Markdown table only or include JSON-like example records for later tooling.
