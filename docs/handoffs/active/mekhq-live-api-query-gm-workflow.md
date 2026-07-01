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

Issue `#143` baseline view names:

- `summary`: capture sanity and loaded-campaign identity.
- `play-context`: scene-start campaign, finance, deployment, readiness, report, command, warning, and gap context.
- `pending-deployments`: focused pending scenario/deployment assignments plus explicit Unknown risk-intel gaps.
- `person-commitment`: focused person commitment lookup by `--person-id` or `--person-name`.
- `unit-readiness`: focused unit condition, crew, deployment, and pending-commitment scan.
- `repair-pressure`: focused repair queue, parts pressure, shopping-list pressure, and automation guard scan.
- `reports`: focused report bucket and compact current report lines.
- `command-readiness`: focused guarded-command readiness. This is read-only and does not execute commands.
- `api-gaps`: focused missing, unsupported, failed, or partial capture gap candidates for `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`.
- `person-detail`: compact selected-person context without raw log entries.

Recommended play-start order after issue `#143`:

1. Run `./scripts/fetch-mekhq-live-api.ps1 -OutputDirectory .\mekhq-live-api-capture`.
2. Run `python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view summary --format json`.
3. Run `python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view play-context --format json`.
4. Use focused views only for the active question, such as `pending-deployments`, `person-commitment --person-name <name>`, `unit-readiness`, `repair-pressure`, `reports`, `command-readiness`, or `api-gaps`.
5. Inspect raw capture JSON only for debugging or source-shape investigation, not as the normal play context.

Known warnings to preserve in workflow docs: missing OpFor BV and known enemy units are not zero; missing command selectors are not approval to mutate MekHQ; `selectorDetail=full` should be requested only when entering a specific command workflow; `api-gaps` prints candidates but does not edit the gap report automatically.

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
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view summary --format json
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view play-context --format json
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view pending-deployments --format json
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view person-commitment --person-name Moreno --format json
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view command-readiness --format json
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view api-gaps --format json
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
