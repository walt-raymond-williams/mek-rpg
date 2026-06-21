# Agent Handoff

## Issue

- GitHub issue: `#41` Add bootstrap-mekhq-campaign unit-style fixture coverage
- Parent epic: `#38`
- Roadmap entry: Automated regression coverage for MekHQ-linked A Time of War workflow
- Mode: Project development / testing
- Status: Completed and archived after implementation.

## Goal

Expand automated coverage for `scripts/bootstrap-mekhq-campaign.py` using sanitized summary fixtures and disposable campaign output.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issues `#38`, `#39`, and `#41`
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`
- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `scripts/bootstrap-mekhq-campaign.py`
- `scripts/test-mekhq-pending-workflow.ps1`
- `tests/fixtures/mekhq-summary-minimal.json`

## Output

- Added `scripts/test-bootstrap-mekhq-campaign.ps1`.
- Reused `tests/fixtures/mekhq-summary-minimal.json`; no new fixture variants were needed.
- Integrated the suite into `scripts/test-all.ps1`.
- Documented the command in `scripts/README.md` and `docs/current/KNOWN_COMMANDS.md`.
- Updated roadmap and task state.

## Files And Areas

Likely files to read or edit:

- `scripts/test-bootstrap-mekhq-campaign.ps1` or equivalent
- `tests/fixtures/`
- `scripts/test-all.ps1` if present
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
python -m py_compile scripts/bootstrap-mekhq-campaign.py
./scripts/test-mekhq-pending-workflow.ps1
./scripts/test-all.ps1
git diff --check
```

## Constraints

- Use only sanitized summary fixtures.
- Keep all generated campaign folders disposable and cleaned up.
- Do not edit the active campaign pointer.
- Do not imply MekHQ save writeback.

## Acceptance Criteria

- Valid campaign bootstrap passes.
- Invalid campaign ids fail.
- Existing target folder is refused.
- Viewpoint selection by id, exact name, commander fallback, and embedded PC are covered.
- Generated campaign files include required headings and ownership/no-writeback language.
- Disposable output is removed before exit.
- Verification is run or blocker recorded.
- Changes are committed and pushed.

## Close-Out Notes

- These checks remain PowerShell integration-style tests for now because the acceptance criteria focus on generated campaign output and filesystem cleanup. Later Python unit tests can still be useful if helper internals become complex.
