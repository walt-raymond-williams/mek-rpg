# Agent Handoff

## Issue

- GitHub issue: `#44` Add pending MekHQ actions validator
- Parent epic: `#38`
- Roadmap entry: Automated regression coverage for MekHQ-linked A Time of War workflow
- Mode: Project development / validation
- Status: Completed and archived after implementation.

## Goal

Create deterministic validation for `pending-mekhq-actions.md` item structure after the requirements matrix defines the stable schema enough to automate.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issues `#38`, `#39`, and `#44`
- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- `campaigns/_template/pending-mekhq-actions.md`
- `scripts/test-mekhq-pending-workflow.ps1`

## Output

- Added `scripts/validate-mekhq-pending-actions.ps1`.
- Added `scripts/test-validate-mekhq-pending-actions.ps1`.
- Integrated the suite into `scripts/test-all.ps1`.
- Documented the validator and test command in `scripts/README.md` and `docs/current/KNOWN_COMMANDS.md`.
- Updated roadmap and task state.

## Files And Areas

Likely files to read or edit:

- `scripts/validate-mekhq-pending-actions.ps1`
- `scripts/test-validate-mekhq-pending-actions.ps1`
- `tests/fixtures/`
- `scripts/test-all.ps1` if present
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
./scripts/test-mekhq-pending-workflow.ps1
./scripts/validate-mekhq-pending-actions.ps1 campaigns/_template/pending-mekhq-actions.md
./scripts/test-validate-mekhq-pending-actions.ps1
git diff --check
```

## Constraints

- Pending items are intents or checklists, not confirmed hard ledger facts.
- Do not require real MekHQ saves.
- Keep parser rules conservative and document any schema looseness.

## Acceptance Criteria

- Valid empty/default pending file passes.
- Valid file with proposed, queued, user-applied, imported, resolved, blocked, and abandoned items passes.
- Invalid status/type/priority fails.
- Missing required fields fail for item entries.
- Unresolved items can be reported for day-advance review.
- Verification is run or blocker recorded.
- Changes are committed and pushed.

## Close-Out Notes

- The first pass uses conservative line-oriented Markdown checks for item headings and checklist fields. That is enough for the current schema and avoids pretending pending items are structured ledger facts.
