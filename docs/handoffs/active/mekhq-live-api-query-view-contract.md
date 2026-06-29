# Agent Handoff

## Issue

- GitHub issue: `#140`
- Roadmap entry: MekHQ live API query/context views
- Mode: Project development
- Priority: First child issue under epic `#139`

## Goal

Define the contract for compact deterministic views produced from ignored MekHQ live API capture JSON.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/handoffs/active/mekhq-live-api-query-views-epic.md`
- `docs/current/MEKHQ_OPEN_CONNECTION_STARTUP_DECISION_TREE.md`
- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`
- `scripts/fetch-mekhq-live-api.ps1`
- `scripts/sync-mekhq-live-campaign.py`

## Expected Output

- New contract doc under `docs/current/`.
- Initial view list and output principles.
- Decision on Python versus PowerShell for nested JSON querying.
- Fixture and privacy strategy that avoids committing raw live campaign captures.

## Files And Areas

Likely files to read or edit:

- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/current/MEKHQ_*`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/handoffs/active/mekhq-live-api-query-helper-core.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
rg -n "fetch-mekhq-live-api|mekhq-live-api-capture|sync-mekhq-live-campaign" docs/current scripts gm AGENTS.md
git check-ignore -v mekhq-live-api-capture/mekhq-state.json
```

## Constraints

- Do not commit raw capture JSON.
- Do not implement the helper in this issue unless the scope remains trivially small and the issue is updated.
- Preserve the split: scripts determine facts and uncertainty; the LLM interprets play meaning.

## Required Close-Out Step

Before closing, review `docs/handoffs/active/mekhq-live-api-query-helper-core.md` and update it with the final contract doc path, chosen language, output mode decisions, fixture requirements, and any schema names or view names introduced here.

## Acceptance Criteria

- Contract doc exists under `docs/current/`.
- Contract separates raw capture evidence from compact query outputs.
- Unknown, missing, unsupported, stale, and partial-response behavior are defined.
- Initial views include play context, pending scenarios/deployments, person commitment, unit readiness, repair pressure, command readiness, reports, and API gaps.
- Changes are verified, committed, and pushed.

## Open Questions

- Should outputs use one command with `--view` or subcommands?
- Should text output cite source filenames directly, or should citations live only in JSON metadata?
