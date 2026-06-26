# Agent Handoff

## Issue

- GitHub issue: `#116`
- Roadmap entry: MekHQ API-first playtest hardening
- Mode: Project development
- Priority: High

## Goal

Harden open-connection-first startup for MekHQ-linked play.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `gm/session-procedure.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEKHQ_LIVE_API_SAVE_COVERAGE_AUDIT.md`

## Expected Output

- Clear fallback decision tree for API available, API unavailable, and explicit offline save inspection.
- Any helper/checklist improvements needed to make API-first startup hard to miss.
- Verification that docs no longer imply save-first live play.

## Files And Areas

Likely files to read or edit:

- `AGENTS.md`
- `gm/session-procedure.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/GM_CONTEXT_PACKET_DESIGN.md`
- `scripts/README.md`
- `scripts/sync-mekhq-live-campaign.py`

## Commands

```powershell
rg -n "GET /campaign/summary|GET /campaign/state|GET /campaign/commands|summarize-mekhq-save|active .*save" AGENTS.md gm docs/current scripts
./scripts/test-all.ps1 -Quick
```

## Constraints

- Do not run live command endpoints unless the issue scope and user approval allow it.
- Do not use active raw save parsing as the default fallback.

## Acceptance Criteria

- Startup docs require live API reads when MekHQ is open.
- API-unavailable behavior is explicit.
- Missing-read behavior points to `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`.

## Open Questions

- Should there be a small helper script that probes the API and emits a startup checklist, or are docs enough for this pass?
