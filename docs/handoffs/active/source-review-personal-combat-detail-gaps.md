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

- Source-reviewed, paraphrased summaries for:
  - `combat.armor-barriers`
  - `combat.optional-personal`
- Updated router, page-reference index, rules map, and manifest entries where appropriate.
- Validation scenarios covering common table questions such as barriers, cover, armor degradation, stacked protection, morale, hit locations, knockdown, and optional lethality handling.

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

- Correct mode identified.
- Scoped source pages reviewed.
- Summaries are paraphrased, procedural, and page-referenced.
- Optional-rule status is explicit.
- Router, page-reference index, rules map, and manifest stay consistent.
- Validation or scenario checks are recorded.
- Raw source files remain ignored and unstaged.
- Roadmap, task state, and handoff are updated.
- Changes are committed and pushed.

## Open Questions

- Should optional personal combat rules be routed only when the user asks for them, or should the main personal-combat overview point to them as an optional escalation path?
