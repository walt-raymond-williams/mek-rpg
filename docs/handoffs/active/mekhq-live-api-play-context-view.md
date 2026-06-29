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
- Query helper created by issue `#141`
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
./scripts/test-all.ps1 -Quick
```

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
