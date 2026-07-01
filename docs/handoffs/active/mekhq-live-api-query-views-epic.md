# Agent Handoff

## Issue

- GitHub issue: `#139`
- Roadmap entry: MekHQ live API query/context views
- Mode: Project development
- Priority: Next major MekHQ tooling track after the current API-first hardening work, unless the user reprioritizes it sooner.

## Goal

Coordinate the epic that turns ignored MekHQ live API capture JSON into compact deterministic query views for agents. Raw captures remain local evidence; agents should normally read small query outputs and use judgment for play interpretation.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/current/MEKHQ_OPEN_CONNECTION_STARTUP_DECISION_TREE.md`
- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`
- `scripts/fetch-mekhq-live-api.ps1`
- `scripts/sync-mekhq-live-campaign.py`

## Expected Output

- Keep child issues ordered and scoped.
- Ensure raw `mekhq-live-api-capture*/` files stay ignored and unstaged.
- Build from contract to helper core to play-context view to focused views to GM workflow integration to validation.
- Create producer/API gap notes only when missing data or expensive reads are proven by captures or fixtures.

## Files And Areas

Likely files to read or edit:

- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/handoffs/active/mekhq-live-api-query-*.md`
- `scripts/`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `gm/session-procedure.md`
- `docs/current/GM_CONTEXT_PACKET_DESIGN.md`
- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
git check-ignore -v mekhq-live-api-capture/mekhq-state.json
./scripts/test-fetch-mekhq-live-api.ps1
./scripts/test-all.ps1 -Quick
```

## Constraints

- Do not commit raw live capture JSON.
- Do not parse active MekHQ saves as the routine live-play path.
- Do not edit the MegaMek workspace from this repository.
- Query helpers extract, count, filter, and preserve uncertainty; they do not choose tactics, scenes, or story outcomes.

## Child Issues

1. `#140`: define the MekHQ live API query view contract. Complete.
2. `#141`: implement the helper core. Complete; `scripts/query-mekhq-live-api.py` now supports `--view summary` with JSON/text output and fixture coverage.
3. `#142`: add compact play-context view. Complete; `scripts/query-mekhq-live-api.py` now supports `--view play-context` with compact scene-start JSON/text facts, optional pending-deployment and command capture gaps, and normal/partial/missing-state fixture coverage.
4. `#143`: add focused operational views. Complete; `scripts/query-mekhq-live-api.py` now supports `pending-deployments`, `person-commitment`, `unit-readiness`, `repair-pressure`, `reports`, `command-readiness`, and `api-gaps` focused views with fixture coverage.
5. `#144`: wire query views into GM workflow. Next unblocked child issue.
6. `#145`: validate query views and finalize tracking.
7. `#146`: consume personnel detail endpoint. Complete; `scripts/fetch-mekhq-live-api.ps1` supports `-PersonnelDetailPersonId`, optional bounded medical/patient log flags, and writes `mekhq-personnel-detail.json`; `scripts/query-mekhq-live-api.py` supports `--view person-detail` with compact person/status/assignment/skill/option/award/log-family/privacy facts and no raw log entry output.

## Required Close-Out Step

At the end of each child issue, review the next child handoff and update it with any new documents, script names, output fields, fixture paths, commands, or cautions created by the completed issue. If the next issue is no longer the right next step, update `docs/current/TASKS.md`, this epic handoff, and the GitHub issue comments before closing.

## Acceptance Criteria

- Child issues remain linked and ordered.
- Compact deterministic views become the normal agent input for MekHQ live context.
- Raw capture inspection remains a debugging fallback.
- Missing fields route to `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`.
- Verification or blockers are recorded.

## Open Questions

- How much of the existing `sync-mekhq-live-campaign.py` extraction logic should be reused versus kept separate?
- Should the compact output format be JSON-first with optional text, text-first with optional JSON, or both from the start?
