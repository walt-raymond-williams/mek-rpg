# Agent Handoff

## Issue

- GitHub issue: `#41` Add bootstrap-mekhq-campaign unit-style fixture coverage
- Parent epic: `#38`
- Roadmap entry: Automated regression coverage for MekHQ-linked A Time of War workflow
- Mode: Project development / testing
- Priority: After issue `#39` requirements, before relying more heavily on generated MekHQ-linked campaigns.

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

## Expected Output

- New or expanded test script for bootstrap helper behavior.
- Sanitized fixture variants if needed.
- Documentation updates and test runner integration if `scripts/test-all.ps1` exists.

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

## Open Questions

- Should these checks remain PowerShell integration-style tests, or should pure Python unit tests be added for individual helper functions?
