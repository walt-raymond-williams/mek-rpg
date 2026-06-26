# Agent Handoff

## Issue

- GitHub issue: `#113`
- Roadmap entry: MekHQ API-first playtest hardening
- Mode: Project development / playtest workflow hardening
- Priority: High

## Goal

Coordinate the epic that makes MekHQ-linked play use the open MekHQ local API connection as the normal source of live campaign context and records read gaps immediately instead of silently parsing active saves.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`
- `docs/current/MEKHQ_LIVE_API_SAVE_COVERAGE_AUDIT.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEKHQ_LIVE_API_EXPANSION_TRACKING.md`

## Expected Output

- Keep child issues linked and ordered.
- Ensure API-first play startup is durable in instructions, GM docs, and tests.
- Ensure every missing MekHQ read discovered during play lands in the API gap report.
- Create project-local producer change requests when MEK-RPG needs MegaMek/MekHQ API changes.

## Files And Areas

Likely files to read or edit:

- `AGENTS.md`
- `gm/session-procedure.md`
- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `scripts/sync-mekhq-live-campaign.py`
- `scripts/export-dashboard-data.ps1`
- `scripts/README.md`
- `tests/fixtures/mekhq-live-*.json`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
rg -n "summarize-mekhq-save|cpnx|campaign/state|campaign/summary|GET /campaign/commands|MEKHQ_PLAYTEST_API_GAP_REPORT" AGENTS.md gm docs/current scripts tests
./scripts/test-all.ps1 -Quick
```

## Constraints

- Route the task into project development mode before editing.
- Do not include unrelated user changes under `campaigns/the-learning-ropes/`.
- Do not commit purchased PDFs, raw extracted text, raw MekHQ saves, or copied rulebook passages.
- Do not edit the MegaMek workspace from this repository.
- Preserve save parsing only as explicit offline, legacy, fixture, or debugging fallback.
- Commit and push completed project-development changes unless explicitly told not to.

## Acceptance Criteria

- Child issues `#116`, `#115`, `#117`, and `#114` remain linked from the epic.
- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md` is the required read-gap sink for MekHQ-linked play.
- Play-mode startup uses live API first when MekHQ is open.
- Missing live API reads become report entries or producer change requests, not silent active-save parsing.
- Verification or blockers are recorded.

## Open Questions

- Static audit is GitHub issue `#116`; startup SOP hardening is GitHub issue `#115`.
