# Agent Handoff

## Issue

- GitHub issue: `#116`
- Roadmap entry: MekHQ API-first playtest hardening
- Mode: Project development
- Priority: High
- Status: Completed 2026-06-26

## Goal

Audit live-play MekHQ access paths and fix stale guidance that encourages routine active-save parsing when the live API should be used.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`
- `docs/current/MEKHQ_LIVE_API_SAVE_COVERAGE_AUDIT.md`

## Expected Output

- Static audit report under `docs/current/`.
- Targeted doc/script/test fixes for stale live-play references.
- Any new API gaps recorded in `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`.

## Completion Notes

- Added `docs/current/MEKHQ_API_FIRST_ACCESS_AUDIT.md`.
- Confirmed current play startup guidance is API-first and raw active-save parsing is not the normal live-play path.
- Preserved save parsing for explicit offline, legacy, fixture, or debugging fallback.
- Corrected child issue number mappings in roadmap, task board, and handoffs.
- Tightened `docs/current/GM_CONTEXT_PACKET_DESIGN.md` so live API snapshot/gap context is a first-class MekHQ bridge input.
- Verification: static audit search, `git diff --check`, protected-source ignore checks, and `./scripts/test-all.ps1 -Quick` passed.

## Files And Areas

Likely files to read or edit:

- `AGENTS.md`
- `gm/`
- `docs/current/`
- `scripts/README.md`
- `scripts/summarize-mekhq-save.py`
- `scripts/bootstrap-mekhq-campaign.py`
- `scripts/sync-mekhq-live-campaign.py`
- `scripts/export-dashboard-data.ps1`
- `scripts/test-*.ps1`

## Commands

```powershell
rg -n "summarize-mekhq-save|cpnx|cpnx.gz|XML|save parsing|campaign/state|campaign/summary|MekHqLiveApiJson" AGENTS.md gm docs/current scripts tests
./scripts/test-all.ps1 -Quick
```

## Constraints

- Valid fixture, legacy, offline, and debugging uses of save parsing should remain allowed.
- Do not parse or commit real MekHQ saves.
- Do not stage unrelated campaign playtest edits.

## Acceptance Criteria

- Audit explicitly separates correct fallback uses from incorrect live-play paths.
- Raw active-save parsing is not described as the normal MekHQ-linked play startup path.
- Verification or blocker is recorded.

## Open Questions

- None yet.
