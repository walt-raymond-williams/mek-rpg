# Agent Handoff

## Issue

- GitHub issue: `#114`
- Roadmap entry: MekHQ API-first playtest hardening
- Mode: Project development / playtest validation
- Priority: High, user-gated for live MekHQ validation

Archive note: issue `#114` is complete. Live API validation was blocked because the local control server was unavailable; fixture-backed rehearsal and the blocker are recorded in `docs/current/MEKHQ_API_FIRST_PLAYTEST_VALIDATION_2026_07_01.md`. Issue `#97` remains open for the user-present live GM play checkpoint.

## Goal

Validate the API-first MekHQ playtest workflow using a live MekHQ local API when available, or explicitly record the blocker and rehearse with fixtures only if live validation is unavailable.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/handoffs/active/live-gm-playtest-checkpoint-97.md`
- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`
- `docs/current/MEKHQ_LIVE_API_EXPANSION_TRACKING.md`

## Expected Output

- Playtest or rehearsal report under `docs/current/`.
- Gap report entries for every missing read.
- Updated roadmap/tasks and any follow-up producer change request.

## Files And Areas

Likely files to read or edit:

- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`
- `docs/handoffs/active/live-gm-playtest-checkpoint-97.md`
- `campaigns/the-learning-ropes/` only when deliberately updating playtest campaign state
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

```powershell
git status --short --branch
Invoke-RestMethod -Method Get -Uri 'http://127.0.0.1:32180/campaign/summary' -TimeoutSec 30
Invoke-RestMethod -Method Get -Uri 'http://127.0.0.1:32180/campaign/state?sections=bridge_metadata,campaign,finances,personnel,units,contracts,scenarios,repairs_and_logistics,markets,reports,unsupported' -TimeoutSec 30
Invoke-RestMethod -Method Get -Uri 'http://127.0.0.1:32180/campaign/commands' -TimeoutSec 30
```

## Constraints

- True live validation requires user-assisted running MekHQ.
- Do not parse a real active save as the normal source.
- Do not stage unrelated existing playtest campaign edits unless this story deliberately updates them.

## Acceptance Criteria

- Live API was used, or live API unavailability is recorded as a blocker.
- Missing reads are captured in the API gap report.
- Issue `#97` relationship is clarified before closing this story.

## Open Questions

- Should this story close issue `#97` as part of the same playtest pass, or only prepare it?

Answer: issue `#97` stays open. This issue only rehearsed the workflow and recorded live API unavailability; it did not run a user-present play checkpoint.
