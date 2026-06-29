# Agent Handoff

## Issue

- GitHub issue: `#144`
- Roadmap entry: MekHQ live API query/context views
- Mode: Project development
- Priority: Depends on issue `#143`

## Goal

Wire MekHQ query views into GM startup, scene refresh, and context packet guidance.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/handoffs/active/mekhq-live-api-query-views-epic.md`
- Contract doc created by issue `#140`
- Query helper and views from issues `#141`-`#143`
- `gm/session-procedure.md`
- `docs/current/MEKHQ_OPEN_CONNECTION_STARTUP_DECISION_TREE.md`
- `docs/current/GM_CONTEXT_PACKET_DESIGN.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`

## Expected Output

- Docs route agents from fetch helper to compact query views before raw JSON inspection.
- Context packet design can include query-view output as MekHQ-owned live context.
- Missing-field warnings route to the API gap report.
- Command docs remain clear that readiness reads do not authorize hidden mutation.

## Files And Areas

Likely files to read or edit:

- `gm/session-procedure.md`
- `docs/current/MEKHQ_OPEN_CONNECTION_STARTUP_DECISION_TREE.md`
- `docs/current/GM_CONTEXT_PACKET_DESIGN.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/handoffs/active/mekhq-live-api-query-validation.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
rg -n "mekhq-live-api-capture|fetch-mekhq-live-api|query view|play-context" AGENTS.md gm docs/current scripts
./scripts/test-all.ps1 -Quick
```

## Constraints

- Do not remove the raw capture fallback for debugging.
- Preserve the API-first boundary: no active save parsing while live API is available.
- Do not update campaign state unless needed by the workflow verification and explicitly scoped.

## Required Close-Out Step

Before closing, review `docs/handoffs/active/mekhq-live-api-query-validation.md` and update it with the final workflow, changed doc paths, command sequence, expected validation report shape, and any live-validation prerequisites.

## Acceptance Criteria

- Play startup tells agents to run capture, then query compact views, then inspect raw JSON only for debugging.
- Context packet docs include compact MekHQ query outputs.
- Gap-report docs are linked from query warnings.
- Changes are verified, committed, and pushed.

## Open Questions

- Should `build-gm-context-packet.ps1` eventually call the query helper directly, or should agents paste/query the output manually for now?
