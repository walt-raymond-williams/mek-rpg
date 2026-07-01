# Agent Handoff

## Issue

- GitHub issue: `#145`
- Roadmap entry: MekHQ live API query/context views
- Mode: Project development / validation
- Priority: Final child issue under epic `#139`

## Goal

Validate the query/view workflow end to end, clean up tracking, and prepare the next related work item.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/handoffs/active/mekhq-live-api-query-views-epic.md`
- Contract doc created by issue `#140`
- Query helper and workflow docs from issues `#141`-`#144`

## Expected Output

- Validation report or concise epic handoff update proving the workflow.
- Test runner integration checked.
- Roadmap, task board, and handoffs updated.
- Follow-up GitHub issues or producer change requests only if needed.

Issue `#144` workflow baseline to validate:

1. Play startup runs `scripts/fetch-mekhq-live-api.ps1 -OutputDirectory .\mekhq-live-api-capture`.
2. Agents query compact views before raw JSON inspection:
   - `python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view summary --format json`
   - `python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view play-context --format json`
3. Focused views are used only for active questions: `pending-deployments`, `person-commitment`, `unit-readiness`, `repair-pressure`, `reports`, `command-readiness`, `api-gaps`, and `person-detail`.
4. Raw capture JSON remains a debugging/source-shape fallback, not the normal play context.
5. Query warnings, missing fields, unsupported entries, failed captures, and partial responses route to `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`; `api-gaps` prints candidates but does not edit the report automatically.
6. Command-readiness reads remain read-only and do not authorize hidden mutation.

Issue `#144` changed docs to review during validation:

- `gm/session-procedure.md`
- `docs/current/MEKHQ_OPEN_CONNECTION_STARTUP_DECISION_TREE.md`
- `docs/current/GM_CONTEXT_PACKET_DESIGN.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/handoffs/active/mekhq-live-api-query-validation.md`

## Files And Areas

Likely files to read or edit:

- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/handoffs/active/`
- `docs/handoffs/archive/`
- Query helper tests and docs
- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
git check-ignore -v mekhq-live-api-capture/mekhq-state.json
./scripts/test-query-mekhq-live-api.ps1
./scripts/test-all.ps1 -Quick
```

If live MekHQ is available, also run the documented fetch-plus-query command sequence from the workflow docs and record the loaded campaign, capture directory, query views run, and whether any warnings/gaps required `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`. If live MekHQ is unavailable, record fixture-backed validation only.

## Constraints

- Fixture-backed validation is acceptable if live MekHQ is unavailable, but record that explicitly.
- Do not commit raw captures.
- Do not close the epic if child issues remain open or the workflow docs still point agents at raw JSON as the normal path.
- Do not archive handoffs until issue `#145` verifies whether `#139` can close.

## Required Close-Out Step

Before closing, review `docs/current/TASKS.md`, `docs/current/ROADMAP.md`, and this epic handoff. Record the next recommended task after this epic, update or archive handoffs as appropriate, and comment on the next issue with any newly created docs or commands it must know about.

## Acceptance Criteria

- End-to-end fixture-backed validation passes.
- Live validation is performed or recorded as blocked/unavailable.
- Raw capture directories remain ignored and unstaged.
- Epic and child handoffs are archived or updated appropriately.
- Next work is explicitly recommended.
- Changes are verified, committed, and pushed.

## Open Questions

- Should a later issue integrate query views directly into `build-gm-context-packet.ps1`?
