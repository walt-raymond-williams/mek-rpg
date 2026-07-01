# Agent Handoff

## Issue

- GitHub issue: `#142`
- Roadmap entry: MekHQ live API query/context views
- Mode: Project development
- Priority: Depends on issue `#141`

## Goal

Add a compact play-context view that summarizes the current MekHQ-owned state needed at scene startup.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/handoffs/active/mekhq-live-api-query-views-epic.md`
- Contract doc created by issue `#140`
- Query helper created by issue `#141`: `scripts/query-mekhq-live-api.py`
- Query helper test suite: `scripts/test-query-mekhq-live-api.ps1`
- `gm/session-procedure.md`
- `docs/current/GM_CONTEXT_PACKET_DESIGN.md`

## Expected Output

- Play-context view from the query helper.
- Compact text and/or JSON suitable for an agent to read directly.
- Tests for normal, partial, and missing-field captures.
- Documentation examples.

## Files And Areas

Likely files to read or edit:

- Query helper script from issue `#141`
- Query helper tests and fixtures
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/handoffs/active/mekhq-live-api-focused-views.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view summary --format json
python ./scripts/query-mekhq-live-api.py --state-file .\mekhq-live-api-capture\mekhq-state.json --manifest-file .\mekhq-live-api-capture\mekhq-live-api-capture-manifest.json --view summary --format text
./scripts/test-query-mekhq-live-api.ps1
./scripts/test-all.ps1 -Quick
```

## Issue `#141` Helper Baseline

- Script: `scripts/query-mekhq-live-api.py`.
- Implemented view: `--view summary`.
- Formats: `--format json` and `--format text`; JSON is the primary schema-bearing output.
- Inputs: `--capture-dir` or explicit files with `--state-file`, `--summary-file`, `--manifest-file`, `--status-file`, `--commands-file`, and `--pending-deployments-file`.
- Output schema: `schema_version: mek-rpg-mekhq-live-api-query-view/v1` with `view`, `generated_at`, `status`, `source`, `identity`, `facts`, `counts`, `warnings`, `gaps`, and `next_actions`.
- Summary validation: requires captured `mekhq-state.json`, validates `bridge_metadata.api_mode: local-read-only-live-context` and `bridge_metadata.read_only: true`, reports missing manifest as `partial`, reports failed manifest/error files as gaps, rejects raw `.cpnx`, `.cpnx.gz`, XML, PDF, EPUB, and protected source paths.
- Exit behavior: `ok` and `partial` return zero; `blocked` and `error` return nonzero.
- Fixture coverage: `scripts/test-query-mekhq-live-api.ps1` builds disposable capture directories from sanitized fixtures under `tests/fixtures/` and covers valid capture, explicit file inputs, JSON/text output, missing manifest, failed manifest, missing required state, missing read-only proof, wrong API mode, raw-save rejection, and unsupported gap surfacing.
- Limitations: `play-context` and focused operational views are not implemented yet; issue `#142` should add a new view to the same helper rather than creating a separate command.

## Constraints

- Preserve `Unknown`, `not exposed`, `unsupported`, and `partial` rather than inventing facts.
- Do not hard-code Sharpe's Strikers or The Learning Ropes.
- Keep tactical BattleTech/MekHQ combat details outside MEK-RPG interpretation.

## Required Close-Out Step

Before closing, review `docs/handoffs/active/mekhq-live-api-focused-views.md` and update it with the play-context fields, fixture assumptions, missing-field behavior, and any view names or command examples that focused views should reuse.

## Acceptance Criteria

- Play-context view includes campaign identity/date/location, finance headline, scenario/deployment headline, unit readiness headline, personnel/fatigue headline when available, visible reports, and warnings.
- Output is small enough for routine agent consumption.
- Source capture filenames or manifest metadata are represented in the output.
- Changes are verified, committed, and pushed.

## Open Questions

- Should the view include only current alerts or also recent reports from the latest day advancement?
