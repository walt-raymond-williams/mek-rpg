# Agent Handoff

## Issue

- GitHub issue: `#110`
- Roadmap entry: Live MekHQ campaign-state API consumer follow-up
- Mode: Project development
- Priority: Next/backlog; useful before deeper issue `#97` live playtest pressure on logistics, scenarios, or markets

## Goal

Update MEK-RPG's live MekHQ API fixtures, adapter mappings, dashboard/context behavior, and docs to consume the expanded read-only MekHQ live campaign-state API shape now available from the local MegaMek/MekHQ source checkout.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/current/MEKHQ_LIVE_API_EXPANSION_TRACKING.md`
- `docs/current/MEK_RPG_LIVE_MEKHQ_API_RESPONSE_MEMO.md`
- `docs/current/MEGAMEK_LIVE_API_CHANGE_REQUEST.md`
- `docs/current/MEKHQ_LIVE_API_SAVE_COVERAGE_AUDIT.md`
- `scripts/README.md`
- `../megamek-workspace/docs/current/MEK_RPG_LIVE_MEKHQ_API_PROTOTYPE.md`

## Expected Output

- Refresh or add sanitized live API fixtures under `tests/fixtures/` from the expanded producer fixtures or a disposable live MekHQ capture.
- Update `scripts/test-mekhq-live-api-fixtures.ps1` for expanded metadata, personnel, unit, finance, contract, scenario, logistics, market, report, and unsupported fields.
- Update `scripts/sync-mekhq-live-campaign.py` only for fields MEK-RPG should surface in campaign-local context now.
- Update dashboard/context docs or tests if the read-only dashboard should summarize new expanded fields.
- Preserve the live-context-not-durable boundary and all unsupported write-command guards.

## Files And Areas

Likely files to read or edit:

- `tests/fixtures/mekhq-live-campaign-summary.fixture.json`
- `tests/fixtures/mekhq-live-campaign-state.fixture.json`
- `tests/fixtures/mekhq-live-campaign-warning-heavy.fixture.json`
- `scripts/test-mekhq-live-api-fixtures.ps1`
- `scripts/test-sync-mekhq-live-campaign.ps1`
- `scripts/sync-mekhq-live-campaign.py`
- `scripts/export-dashboard-data.ps1`
- `scripts/test-export-dashboard-data.ps1`
- `docs/current/READ_ONLY_DASHBOARD_DATA_CONTRACT.md`
- `docs/current/MEKHQ_LIVE_API_EXPANSION_TRACKING.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`

Producer-side source and fixture references, read-only unless the user explicitly asks to modify that repository:

- `../megamek-workspace/docs/current/MEK_RPG_LIVE_MEKHQ_API_PROTOTYPE.md`
- `../megamek-workspace/docs/templates/mekhq-live-campaign-summary.fixture.json`
- `../megamek-workspace/docs/templates/mekhq-live-campaign-state.fixture.json`
- `../megamek-workspace/docs/templates/mekhq-live-campaign-warning-heavy.fixture.json`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
Get-Content -Raw ..\megamek-workspace\docs\current\MEK_RPG_LIVE_MEKHQ_API_PROTOTYPE.md
Get-Content -Raw ..\megamek-workspace\docs\templates\mekhq-live-campaign-state.fixture.json | ConvertFrom-Json | Out-Null
./scripts/test-mekhq-live-api-fixtures.ps1
./scripts/test-sync-mekhq-live-campaign.ps1
./scripts/test-export-dashboard-data.ps1
./scripts/test-all.ps1 -Quick
```

## Constraints

- Route the task into project development mode before editing.
- Do not edit the MegaMek workspace from this repository unless the user explicitly asks for cross-repository changes.
- Do not treat live API values as durable MEK-RPG campaign state by default.
- Do not add write/control behavior for market purchase, personnel hire/fire, contract accept/decline, market refresh or negotiation, repair execution, repair assignment, shopping-list purchase or priority mutation, save/writeback, stable market offer selectors, or stable repair work ids.
- Do not parse active MekHQ save files to fill ordinary live API gaps.
- Do not commit purchased PDFs, raw extracted text, copied rulebook text, raw saves, or secrets.

## Acceptance Criteria

- Expanded producer fixtures or disposable captures parse with `ConvertFrom-Json`.
- MEK-RPG fixtures reflect the expanded local API shape without real campaign secrets or local save paths.
- Focused live API fixture tests pass.
- Live campaign sync tests pass, or blockers are recorded with exact missing fields.
- Dashboard/context tests are updated if their behavior changes.
- Remaining producer gaps are recorded as gaps, not filled by active-save parsing.
- `git status --short --branch` is clean after commit and push, except for explicitly reported unrelated files.

## Open Questions

- Should issue `#110` be completed before resuming issue `#97`, or can it run after a first playtest pass using the current adapter shape?
- Should MEK-RPG add a manual smoke capture command for the expanded API, or continue relying on the producer fixtures until the next source-built MekHQ run?
