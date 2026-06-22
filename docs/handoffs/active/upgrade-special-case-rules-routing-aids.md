# Agent Handoff

## Issue

- GitHub issue: `#92`
- Roadmap entry: Next rules source-review expansion wave
- Mode: Source processing / project development
- Priority: Medium; follows or can run after issue `#91`

## Goal

Review whether `rules/special/planetary-conditions.md`, `rules/special/creatures.md`, and `rules/special/diseases.md` should remain source-reviewed routing aids or become more complete play-facing summaries for live GM use.

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
- `rules/special/planetary-conditions.md`
- `rules/special/creatures.md`
- `rules/special/diseases.md`

## Expected Output

- Update the special-case summaries where safe procedural coverage can be added.
- Otherwise, add a concise decision note explaining why routing-aid status remains correct.
- Update router, page-reference index, rules map, subsystem index, and manifest if status or routing changes.
- Add or update validation notes for environmental hazards, creature encounters, disease clocks, exposure, venom, and quarantine consequences.

## Files And Areas

Likely files to read or edit:

- `rules/special/planetary-conditions.md`
- `rules/special/creatures.md`
- `rules/special/diseases.md`
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
- Do not reproduce creature catalogs, disease tables, environmental modifier tables, stat blocks, or source prose.
- Keep exact table lookups as private source lookup with page references.
- Preserve tactical BattleTech/MegaMek/MekHQ handoff boundaries where environmental or creature cases become tactical-scale.

## Acceptance Criteria

- Each special-case file has either improved play-facing procedure or an explicit reason to remain a routing aid.
- Router and manifest labels match the updated authority level.
- Validation covers at least one environmental, creature, and disease prompt.
- No protected raw source is staged.

## Open Questions

- Are these summaries intended to become authoritative enough for common play, or should they stay as routing aids until a campaign actually stresses them?
