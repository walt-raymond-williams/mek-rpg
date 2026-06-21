# Agent Handoff

## Issue

- GitHub issue: `#63` Source-review equipment and hazard gaps
- Roadmap entry: Next rules source-review expansion wave
- Mode: Source processing / project development
- Priority: Fourth child issue in the rules expansion wave

## Goal

Create source-reviewed, paraphrased summaries for the remaining equipment and hazard topics most likely to affect missions, injury aftermath, and vehicle/asset scenes.

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
- GitHub issue `#63`

Task-specific context:

- `indexes/manifest.yaml`
- `indexes/page-reference-index.md`
- `indexes/task-router.md`
- `rules/equipment/overview.md`
- `rules/equipment/armor.md`
- `rules/equipment/medical-gear.md`
- `rules/equipment/personal-gear.md`
- `rules/campaign/injuries-recovery.md`
- `rules/campaign/transport-and-large-assets.md`
- `rules/vehicles-and-mechs/overview.md`

## Expected Output

- Source-reviewed, paraphrased summaries for:
  - `special.planetary-conditions`
  - `special.creatures`
  - `special.diseases`
  - `equipment.battle-armor-exoskeletons`
  - `equipment.prosthetics-implants`
  - `equipment.drugs-poisons`
  - `equipment.personal-vehicles`
- Updated router, page-reference index, rules map, and manifest entries where appropriate.
- Validation scenarios for common mission hazards, recovery complications, special gear boundaries, and personal vehicle/fuel questions.

## Files And Areas

Likely files to read or edit:

- `rules/special/planetary-conditions.md`
- `rules/special/creatures.md`
- `rules/special/diseases.md`
- `rules/equipment/battle-armor-and-exoskeletons.md`
- `rules/equipment/prosthetics-and-implants.md`
- `rules/equipment/drugs-and-poisons.md`
- `rules/equipment/personal-vehicles.md`
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
- Do not copy equipment catalogs, creature stat blocks, disease tables, poison tables, drug tables, modifier tables, or vehicle lists.
- Preserve sensitive-topic boundaries around drugs, poisons, disease, implants, and injury aftermath: procedural game support only, not real-world medical advice.
- Route full battle armor or tactical vehicle combat to the tactical handoff where appropriate.

## Acceptance Criteria

- Correct mode identified.
- Scoped source pages reviewed.
- Summaries are paraphrased, page-referenced, and table/catalog-safe.
- Router, page-reference index, rules map, and manifest stay consistent.
- Validation or scenario checks are recorded.
- Raw source files remain ignored and unstaged.
- Roadmap, task state, and handoff are updated.
- Changes are committed and pushed.

## Open Questions

- Resolved: the issue stayed cohesive by writing concise routing aids rather than table-heavy summaries.

## Completion Notes

- Added `rules/special/planetary-conditions.md`, `rules/special/creatures.md`, and `rules/special/diseases.md`.
- Added `rules/equipment/battle-armor-and-exoskeletons.md`, `rules/equipment/prosthetics-and-implants.md`, `rules/equipment/drugs-and-poisons.md`, and `rules/equipment/personal-vehicles.md`.
- Added `docs/current/EQUIPMENT_HAZARD_SOURCE_REVIEW_VALIDATION.md`.
- Updated router, page-reference index, rules map, subsystem index, manifest metadata, related equipment/campaign/vehicle summaries, roadmap, and task state.
- Preserved table/catalog/stat-block boundaries and framed sensitive medical, disease, drug, poison, and implant topics as fictional game procedures only.
