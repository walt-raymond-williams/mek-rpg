# Agent Handoff

## Issue

- GitHub issue: `#39` Define MekHQ-linked A Time of War workflow requirements and coverage matrix
- Parent epic: `#38`
- Roadmap entry: Automated regression coverage for MekHQ-linked A Time of War workflow
- Mode: Project development / requirements
- Status: Completed and archived after implementation.

## Goal

Write concrete, testable requirements for replicating the A Time of War RPG workflow while tied to MekHQ, then map each requirement to automated, manual, missing, or blocked coverage.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issues `#38` and `#39`

Task-specific context:

- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md`
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- `gm/session-procedure.md`
- `gm/scene-loop.md`
- `gm/state-save-checklist.md`
- `scripts/test-mekhq-pending-workflow.ps1`

## Output

- Added `docs/current/MEKHQ_LINKED_ATOW_WORKFLOW_REQUIREMENTS.md`.
- Added stable `REQ-MEKHQ-ATOW-*` requirements.
- Added a coverage matrix mapping requirements to automated, manual, planned, blocked, and missing coverage.
- Mapped child issues `#40`-`#45`, manual playtest issue `#37`, and tactical handoff issue `#55`.
- Updated `docs/current/ROADMAP.md` and `docs/current/TASKS.md`.

## Files And Areas

Likely files to read or edit:

- `docs/current/MEKHQ_LINKED_ATOW_WORKFLOW_REQUIREMENTS.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/current/KNOWN_COMMANDS.md` only if adding a repeatable command
- This handoff file, moved to archive on completion

## Commands

Useful commands or checks:

```powershell
git status --short --branch
rg "MekHQ|pending|context packet|A Time of War" docs/current gm scripts
./scripts/test-mekhq-pending-workflow.ps1
git diff --check
git check-ignore source/atow-pdf/example.pdf
git check-ignore source/atow-text/page-001.txt
```

## Constraints

- Do not process PDFs or source text.
- Do not use real MekHQ saves as fixtures.
- Keep requirements testable and deterministic where possible.
- Preserve the MekHQ hard-ledger authority boundary and MEK-RPG RPG-memory authority boundary.
- Do not imply direct MekHQ `.cpnx`, `.cpnx.gz`, or XML writeback is available.

## Acceptance Criteria

- Requirements cover import, bootstrap, pre-session checkpoint, in-day RPG scene flow, pending hard ledger intents, manual MekHQ application, saved re-import reconciliation, tactical handoff, and GM context packet boundaries.
- Requirements distinguish MekHQ-owned hard facts from MEK-RPG-owned RPG memory.
- Coverage matrix marks each requirement as automated, manual, planned, blocked, or missing.
- Child issues `#40`-`#45` are mapped to the relevant requirements.
- Roadmap and task state are updated.
- Verification is run or blocker recorded.
- Changes are committed and pushed.

## Close-Out Notes

- Markdown is enough for this pass. Issue `#40` can decide whether a future machine-readable manifest is useful when adding the top-level deterministic runner.
- Issue `#37` can proceed after this requirements matrix because manual validation now has explicit requirements to check.
