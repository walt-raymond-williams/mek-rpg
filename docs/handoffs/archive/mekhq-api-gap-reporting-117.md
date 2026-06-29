# Agent Handoff

## Issue

- GitHub issue: `#117`
- Roadmap entry: MekHQ API-first playtest hardening
- Mode: Project development
- Priority: High

## Goal

Finish wiring the MekHQ playtest API gap reporting workflow so missing reads discovered during play are captured immediately and consistently.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`
- `gm/session-procedure.md`

## Expected Output

- Report schema refined if needed.
- Play-mode docs and helper docs point to the report.
- Tests or grep-style verification protect the report reference where practical.

## Completion Notes

- Added `scripts/test-mekhq-api-gap-reporting.ps1` to verify the report schema and the play/helper documentation references.
- Wired the check into `scripts/test-all.ps1 -Quick`.
- Updated command documentation in `scripts/README.md` and `docs/current/KNOWN_COMMANDS.md`.
- Marked `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md` as wired for story issue `#117`.
- Existing report entries remain open producer/API gaps for later follow-up.

## Files And Areas

Likely files to read or edit:

- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`
- `AGENTS.md`
- `gm/session-procedure.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`

## Commands

```powershell
rg -n "MEKHQ_PLAYTEST_API_GAP_REPORT|API gap|save parsing|active save" AGENTS.md gm docs/current scripts
./scripts/test-all.ps1 -Quick
```

## Constraints

- Read gaps are the focus. Write/command notes can be tracked only as secondary future context.
- Missing API data should not authorize silent raw save parsing.

## Acceptance Criteria

- Report path is visible from play startup docs.
- Entry schema covers needed data, attempted read, missing field, fallback, and suggested API change.
- Verification or blocker is recorded.

## Open Questions

- None yet.
