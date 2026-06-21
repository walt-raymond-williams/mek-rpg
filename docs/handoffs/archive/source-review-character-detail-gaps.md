# Agent Handoff

## Issue

- GitHub issue: `#60` Source-review character detail gaps
- Roadmap entry: Next rules source-review expansion wave
- Mode: Source processing / project development
- Priority: First child issue in the rules expansion wave

## Goal

Create source-reviewed, paraphrased support for the character-detail gaps most likely to matter when building or reviewing PCs and important NPCs: character record basics, skill fields, purchasing character elements, trait catalog routing, and skill catalog routing.

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
- GitHub issue `#60`

Task-specific context:

- `indexes/manifest.yaml`
- `indexes/page-reference-index.md`
- `indexes/task-router.md`
- `indexes/rules-map.md`
- `rules/character-creation/overview.md`
- `rules/character-creation/lifepaths.md`
- `rules/character-creation/attributes.md`
- `rules/character-creation/traits.md`
- `rules/character-creation/skills.md`
- `rules/character-creation/xp-advancement.md`

## Expected Output

- Completed source-reviewed, paraphrased summaries or routing maps for:
  - `core.character-record-basics`
  - `character.skill-fields`
  - `character.purchasing-elements`
  - `traits.catalog-map`
  - `skills.catalog-map`
- Updated router, page-reference index, rules map, subsystem index, and manifest entries.
- Focused validation note: `docs/current/CHARACTER_DETAIL_GAPS_SOURCE_REVIEW_VALIDATION.md`.

## Files And Areas

Likely files to read or edit:

- `rules/core/character-record-basics.md`
- `rules/character-creation/skill-fields.md`
- `rules/character-creation/purchasing-character-elements.md`
- `rules/traits/trait-catalog-map.md`
- `rules/skills/skill-catalog-map.md`
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
- Do not copy trait catalogs, skill catalogs, tables, sample sheets, or stat blocks.
- Use concise paraphrase, page references, route guidance, and uncertainty labels.
- Catalog work should help agents find the right source pages or committed summaries; it should not recreate protected lists wholesale.
- Do not broaden into full character generator automation unless a new issue is created.

## Acceptance Criteria

- Correct mode identified: source processing / project development.
- Scoped source pages reviewed.
- New summaries/maps are paraphrased and page-referenced.
- Router, page-reference index, rules map, subsystem index, and manifest updated.
- Validation/scenario checks recorded in `docs/current/CHARACTER_DETAIL_GAPS_SOURCE_REVIEW_VALIDATION.md`.
- Raw source files remain ignored and unstaged.
- Roadmap, task state, and handoff updated.
- Changes committed and pushed in the issue close-out.

## Open Questions

- Resolved for issue `#60`: trait and skill catalog maps live as standalone source-reviewed routing aids, and adjacent character summaries/indexes link to them for page routing rather than full catalog authority.
- Does character-record basics need a future sheet validator issue after real PC sheets stabilize?

## Completion Notes

- Added `rules/core/character-record-basics.md`.
- Added `rules/character-creation/skill-fields.md`.
- Added `rules/character-creation/purchasing-character-elements.md`.
- Added `rules/traits/trait-catalog-map.md`.
- Added `rules/skills/skill-catalog-map.md`.
- Added `docs/current/CHARACTER_DETAIL_GAPS_SOURCE_REVIEW_VALIDATION.md`.
- Updated routing/index metadata to promote the issue `#60` mapped targets to committed draft or source-reviewed routing-aid entries.
