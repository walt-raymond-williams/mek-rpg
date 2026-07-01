# Agent Handoff

## Issue

- GitHub issue: `#143`
- Roadmap entry: MekHQ live API query/context views
- Mode: Project development
- Priority: Depends on issue `#142`

## Goal

Add focused operational query views for common live-play questions.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/handoffs/active/mekhq-live-api-query-views-epic.md`
- Contract doc created by issue `#140`
- Query helper and play-context view from issues `#141` and `#142`
- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`
- `docs/current/MEKHQ_COMMAND_API_STRATEGY.md`

Issue `#142` baseline: `scripts/query-mekhq-live-api.py` supports `--view play-context` with JSON/text output. The view requires `mekhq-state.json` and live read-only/API-mode proof, accepts optional `mekhq-pending-deployments.json` and `mekhq-commands.json`, and reports partial output with explicit gaps when those optional captures are absent.

## Expected Output

- Focused views for pending scenarios/deployments, person commitment, unit readiness, repair/service pressure, visible reports, command readiness, and API gaps/unsupported entries.
- Tests for each view using sanitized fixtures.
- Clear gap-report guidance for missing play-critical fields.

Build these focused views from the `play-context` fact families where possible:

- `finance_headline`
- `contract_headline`
- `deployment_headline`
- `unit_readiness_headline`
- `personnel_headline`
- `reports_headline`
- `command_headline`

The `play-context` view also emits `counts`, `source.files`, `warnings`, `gaps`, and `next_actions`. Preserve the same `Unknown` and partial-output behavior when focused views cannot see an optional capture or API field.

## Files And Areas

Likely files to read or edit:

- Query helper script and tests
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`
- `docs/handoffs/active/mekhq-live-api-query-gm-workflow.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
./scripts/fetch-mekhq-live-api.ps1 -OutputDirectory .\mekhq-live-api-capture
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view play-context --format json
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view play-context --format text
./scripts/test-query-mekhq-live-api.ps1
./scripts/test-all.ps1 -Quick
```

## Constraints

- Do not treat missing OpFor BV, objectives, or hidden scenario data as zero or safe.
- Do not expose hidden data beyond what the API provides and what the view contract allows.
- Command readiness remains read-only unless a separate guarded command workflow is explicitly invoked.
- Use source labels and capture paths from the query envelope; do not imply facts came from MekHQ if they were derived by the MEK-RPG helper.

## Required Close-Out Step

Before closing, review `docs/handoffs/active/mekhq-live-api-query-gm-workflow.md` and update it with final view names, command examples, known warnings, and the correct recommended order for play startup.

## Acceptance Criteria

- Pending scenario/deployment view reports ids, names, dates, assignments, and missing risk-intel fields.
- Person commitment view supports id or name when data exists.
- Unit readiness and repair views report counts and named pressure points without tactical overreach.
- Command readiness view distinguishes cheap default readiness from full-selector workflows.
- Changes are verified, committed, and pushed.

## Open Questions

- Should API gap output write directly to a draft entry template, or only print enough facts for manual gap-report editing?
