# Agent Handoff

## Issue

- GitHub issue: `#22` Summarize campaign consequence systems
- Roadmap entry: Summarize campaign consequence systems
- Mode: Source processing / project development
- Priority: Medium

## Goal

Create source-reviewed, paraphrased summaries for contracts, contacts, reputation, advancement, injury consequences, downtime, and mission readiness.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/SOURCE_PROCESSING_WORKFLOW.md`
- `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md`
- `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`
- `gm/state-save-checklist.md`
- `campaigns/README.md`
- `source/atow-chapter-section-map.md`
- `indexes/task-router.md`

## Expected Output

- Campaign-system summaries under an appropriate rules path.
- Router, rules map, subsystem index, page-reference index, and manifest updates.
- GM save/update guidance for how campaign consequences affect active campaign files.
- Validator-maintenance decision for any new or changed campaign save files, asset sheets, mission records, or related persistent structures.

## Files And Areas

Likely files to read or edit:

- `rules/campaign/`
- `indexes/`
- `gm/session-procedure.md`
- `gm/state-save-checklist.md`
- `campaigns/README.md`
- `campaigns/_template/`
- `scripts/validate-campaign-state.ps1` or companion validator docs if save structure changes

## Commands

Useful commands or checks:

```powershell
git status --short --branch
git check-ignore source/atow-pdf/example.pdf source/atow-text/page-0001.txt
./scripts/validate-campaign-state.ps1 -CampaignId playtest-galatea-dropship
```

## Constraints

- Source processing must be explicit before reading ignored extracted source text.
- Do not encode table-heavy campaign rules as copied tables.
- Do not turn campaign-state guidance into invented campaign facts.
- Any save-structure change must account for validator maintenance.

## Acceptance Criteria

- Contracts, contacts, reputation, advancement, injury consequences, downtime, and mission readiness are covered or explicitly scoped as gaps.
- Summaries are paraphrased, procedural, and page-referenced.
- Indexes and manifest route to the new summaries.
- GM save/update guidance points to active campaign files.
- Scenario lookup tests cover contract aftermath, downtime recovery, reputation/contact pressure, and mission readiness.
- No protected raw source is staged.
- Changes are committed and pushed.

## Open Questions

- Should richer contracts/assets/mission records remain sections in existing files at first, or become dedicated sheets after live play proves the need?
