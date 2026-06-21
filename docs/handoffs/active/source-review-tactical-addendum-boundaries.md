# Agent Handoff

## Issue

- GitHub issue: `#62` Source-review tactical addendum boundaries
- Roadmap entry: Next rules source-review expansion wave
- Mode: Source processing / project development
- Priority: Third child issue in the rules expansion wave

## Goal

Create a source-reviewed tactical addendum layer that improves RPG-to-tactical handoff without replacing Classic BattleTech, MegaMek, or MekHQ as the authority for full tactical combat.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/SOURCE_PROCESSING_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#62`

Task-specific context:

- `indexes/manifest.yaml`
- `indexes/page-reference-index.md`
- `indexes/task-router.md`
- `rules/vehicles-and-mechs/overview.md`
- `rules/vehicles-and-mechs/piloting.md`
- `rules/vehicles-and-mechs/gunnery.md`
- `rules/vehicles-and-mechs/mechwarrior-skills.md`
- `rules/vehicles-and-mechs/converting-to-classic-battletech.md`
- `gm/switch-to-classic-battletech.md`
- `gm/encounter-template.md`
- `gm/tactical-encounter-handoff-checklist.md`

## Expected Output

- Source-reviewed, paraphrased routing/handoff support for:
  - `tactical.overview`
  - `tactical.turn-initiative`
  - `tactical.vehicle-actions`
  - `tactical.damage-traits`
  - `tactical.heat-pilot-abilities`
- Router/index updates that point tactical-detail questions to the right summary or tactical handoff.
- Scenario validation that proves the new material clarifies handoff decisions without pretending to run full BattleTech combat.

## Files And Areas

Likely files to read or edit:

- `rules/tactical/tactical-combat-overview.md`
- `rules/tactical/tactical-turn-and-initiative.md`
- `rules/tactical/vehicle-actions.md`
- `rules/tactical/tactical-damage-and-traits.md`
- `rules/tactical/heat-and-pilot-abilities.md`
- `rules/vehicles-and-mechs/*.md`
- `gm/switch-to-classic-battletech.md`
- `gm/tactical-encounter-handoff-checklist.md`
- `indexes/task-router.md`
- `indexes/page-reference-index.md`
- `indexes/rules-map.md`
- `indexes/manifest.yaml`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- this handoff

## Commands

Useful commands or checks:

```powershell
git status --short --branch
./scripts/validate-rules-indexes.ps1
./scripts/report-rules-coverage.ps1
./scripts/test-all.ps1
git check-ignore source/atow-pdf/example.pdf
git check-ignore source/atow-text/page-001.txt
```

## Constraints

- This issue explicitly permits source-processing work for the scoped source ranges only.
- Do not implement a tactical rules engine.
- Do not copy tactical tables, weapon traits, modifier lists, or special-pilot-ability text wholesale.
- Keep Classic BattleTech, MegaMek, or MekHQ as the route for hex movement, armor locations, heat, weapon ranges, initiative, and detailed unit state.

## Acceptance Criteria

- Correct mode identified.
- Scoped source pages reviewed.
- Addendum files are paraphrased, page-referenced, and clear about tactical handoff limits.
- Router, page-reference index, rules map, and manifest stay consistent.
- Validation scenarios distinguish RPG support from full tactical handling.
- Raw source files remain ignored and unstaged.
- Roadmap, task state, and handoff are updated.
- Changes are committed and pushed.

## Open Questions

- Should these outputs live under `rules/tactical/`, or should some tactical-boundary material remain in `gm/` as pure handoff procedure?
