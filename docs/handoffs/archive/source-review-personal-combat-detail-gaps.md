# Agent Handoff

## Issue

- GitHub issue: `#61` Source-review personal combat detail gaps
- Roadmap entry: Next rules source-review expansion wave
- Mode: Source processing / project development
- Priority: Second child issue in the rules expansion wave

## Goal

Create source-reviewed, paraphrased support for mapped personal-combat details that were intentionally left outside the first playable combat minimum: armor/barriers and optional personal combat procedures.

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
- GitHub issue `#61`

Task-specific context:

- `indexes/manifest.yaml`
- `indexes/page-reference-index.md`
- `indexes/task-router.md`
- `rules/personal-combat/overview.md`
- `rules/personal-combat/action-and-movement.md`
- `rules/personal-combat/ranged-attacks.md`
- `rules/personal-combat/melee-attacks.md`
- `rules/personal-combat/damage.md`
- `rules/personal-combat/wounds.md`
- `rules/personal-combat/end-phase.md`
- `rules/equipment/armor.md`

## Expected Output

- Completed source-reviewed, paraphrased summaries for:
  - `combat.armor-barriers`
  - `combat.optional-personal`
- Updated router, page-reference index, rules map, subsystem index, and manifest entries.
- Validation scenarios recorded in `docs/current/PERSONAL_COMBAT_DETAIL_GAPS_SOURCE_REVIEW_VALIDATION.md`.

## Files And Areas

Likely files to read or edit:

- `rules/combat/armor-and-barriers.md`
- `rules/combat/optional-personal-combat.md`
- `rules/personal-combat/*.md` where cross-links are needed
- `rules/equipment/armor.md`
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
- Do not copy tables, modifier lists, hit-location tables, or optional-rule text wholesale.
- Preserve the tactical BattleTech handoff boundary where personal combat stops being the right scale.
- Mark optional rules clearly so future play does not silently turn them on.

## Acceptance Criteria

- Correct mode identified: source processing / project development.
- Scoped source pages reviewed.
- Summaries are paraphrased, procedural, and page-referenced.
- Optional-rule status is explicit.
- Router, page-reference index, rules map, subsystem index, and manifest updated.
- Validation/scenario checks recorded in `docs/current/PERSONAL_COMBAT_DETAIL_GAPS_SOURCE_REVIEW_VALIDATION.md`.
- Raw source files remain ignored and unstaged.
- Roadmap, task state, and handoff updated.
- Changes committed and pushed in the issue close-out.

## Open Questions

- Resolved for issue `#61`: optional personal combat rules are routed when the user/GM asks for optional detail or a relevant table question arises; the main overview links to them as an opt-in escalation path, not default procedure.

## Completion Notes

- Added `rules/combat/armor-and-barriers.md`.
- Added `rules/combat/optional-personal-combat.md`.
- Added `docs/current/PERSONAL_COMBAT_DETAIL_GAPS_SOURCE_REVIEW_VALIDATION.md`.
- Cross-linked the new files from existing personal-combat and armor summaries.
- Promoted `combat.armor-barriers` and `combat.optional-personal` from mapped-only targets to committed draft manifest entries.
