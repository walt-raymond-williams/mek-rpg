# Agent Handoff

## Issue

- GitHub issue: `#20` Validate existing draft coverage and helper workflow
- Roadmap entry: Validate existing draft coverage
- Mode: Project development / review
- Priority: High

## Goal

Run scenario-based validation against existing draft rules coverage and helper scripts so future play can rely on repository files rather than model memory.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md`
- `indexes/task-router.md`
- `docs/current/CORE_LOOKUP_VALIDATION.md`
- `docs/current/PERSONAL_COMBAT_LOOKUP_VALIDATION.md`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`

## Expected Output

- Validation report, likely `docs/current/DRAFT_COVERAGE_AND_HELPER_VALIDATION.md`.
- Narrow fixes to router, docs, indexes, or scripts when validation finds clear defects.
- Follow-up issue recommendations for larger gaps.

## Files And Areas

Likely files to read or edit:

- `indexes/task-router.md`
- `indexes/page-reference-index.md`
- `indexes/manifest.yaml`
- `rules/core/`
- `rules/personal-combat/`
- `rules/equipment/`
- `gm/`
- `scripts/`
- `docs/current/`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
./scripts/validate-campaign-state.ps1
./scripts/validate-campaign-state.ps1 -CampaignId playtest-galatea-dropship
./scripts/validate-campaign-state.ps1 -StrictActive
./scripts/roll-dice.ps1 2d6
./scripts/roll-dice.ps1 2d6+2 "Validation check"
git check-ignore source/atow-pdf/example.pdf source/atow-text/page-0001.txt
```

## Constraints

- Do not perform source processing.
- Do not inspect ignored source text or PDFs.
- Validate lookup from committed summaries and indexes only.
- Do not create the first real campaign save in this issue unless the user explicitly redirects to issue `#24`.

## Acceptance Criteria

- Scenario tests start at `indexes/task-router.md` and follow committed links only.
- Core, personal combat, equipment, tactical handoff, campaign-save routing, and helper scripts are covered.
- Helper scripts are run with representative valid and invalid inputs.
- Missing or weak coverage is recorded with follow-up recommendations.
- No protected raw source is staged.
- Changes are committed and pushed.

## Open Questions

- Should broad validation fixes be made in this issue, or split into follow-up tickets when they touch source-reviewed summaries?
