# Agent Handoff

## Issue

- GitHub issue: `#93`
- Roadmap entry: Next rules source-review expansion wave
- Mode: Source processing / project development
- Priority: Medium; follows or can run after issue `#91`

## Goal

Review whether battle armor/exoskeletons, prosthetics/implants, drugs/poisons, and personal vehicles/fuel should remain source-reviewed routing aids or gain more procedural live-play coverage.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md`
- `indexes/task-router.md`
- `indexes/page-reference-index.md`
- `indexes/manifest.yaml`
- `rules/equipment/battle-armor-and-exoskeletons.md`
- `rules/equipment/prosthetics-and-implants.md`
- `rules/equipment/drugs-and-poisons.md`
- `rules/equipment/personal-vehicles.md`

## Expected Output

- Update equipment routing aids where safe procedural coverage can be added.
- Otherwise, add a concise decision note explaining why routing-aid status remains correct.
- Update router, page-reference index, rules map, subsystem index, and manifest if status or routing changes.
- Add or update validation notes for hostile-environment gear, battle armor boundaries, lost-limb recovery, implant consequences, drug/poison treatment, and local vehicle/fuel logistics.

## Files And Areas

Likely files to read or edit:

- `rules/equipment/battle-armor-and-exoskeletons.md`
- `rules/equipment/prosthetics-and-implants.md`
- `rules/equipment/drugs-and-poisons.md`
- `rules/equipment/personal-vehicles.md`
- `indexes/task-router.md`
- `indexes/rules-map.md`
- `indexes/subsystem-index.md`
- `indexes/page-reference-index.md`
- `indexes/manifest.yaml`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
./scripts/validate-rules-indexes.ps1
./scripts/test-route-rules-prompt.ps1
./scripts/test-all.ps1
```

## Constraints

- This issue may use private ignored source text only for the scoped source-review work.
- Do not reproduce gear catalogs, prices, tables, stat blocks, or source prose.
- Keep battle armor and vehicle cases routed to Classic BattleTech, MegaMek, or MekHQ when tactical detail matters.
- Keep exact equipment stats and market values as private source lookup with page references.

## Acceptance Criteria

- Each special equipment file has either improved play-facing procedure or an explicit reason to remain a routing aid.
- Router and manifest labels match the updated authority level.
- Validation covers at least one battle armor/exoskeleton, implant/prosthetic, drug/poison, and personal vehicle/fuel prompt.
- No protected raw source is staged.

## Open Questions

- Which of these areas should become common-play summaries now, and which should remain source lookup until the table actually needs them?
