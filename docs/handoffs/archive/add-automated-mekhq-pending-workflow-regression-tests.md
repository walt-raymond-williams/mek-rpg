# Agent Handoff

## Issue

- GitHub issue: `#36` Add automated MekHQ pending workflow regression tests
- Roadmap entry: MekHQ bridge verification / pending application regression coverage
- Mode: Project development
- Status: Completed; archive after commit and push.

## Goal

Add repeatable automated regression checks for the MekHQ pending application workflow so future changes do not silently break the `pending-mekhq-actions.md` owner file, bootstrap output, validator coverage, or no-writeback boundary.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#36`

Task-specific context:

- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md`
- `scripts/bootstrap-mekhq-campaign.py`
- `scripts/validate-campaign-state.ps1`
- `campaigns/_template/pending-mekhq-actions.md`
- `docs/current/KNOWN_COMMANDS.md`
- `scripts/README.md`

## Expected Output

- A deterministic test script, recommended path: `scripts/test-mekhq-pending-workflow.ps1`.
- A small sanitized fixture, recommended path: `tests/fixtures/mekhq-summary-minimal.json`.
- Script checks that:
  - `bootstrap-mekhq-campaign.py` can create a disposable campaign folder from the fixture.
  - generated output includes `pending-mekhq-actions.md` and `mekhq-bridge.md`.
  - `pending-mekhq-actions.md` contains the pending workflow language.
  - `mekhq-bridge.md` points pending work to `pending-mekhq-actions.md` instead of owning the queue.
  - `validate-campaign-state.ps1` passes for disposable valid output.
  - a disposable missing-`pending-mekhq-actions.md` campaign fails validation, if practical.
  - workflow docs still preserve no direct `.cpnx`, `.cpnx.gz`, or MekHQ XML writeback.
  - protected source ignore checks still pass.
- Documentation updates for the new test command.
- `TASKS.md` and `ROADMAP.md` updates on completion.

## Files And Areas

Likely files to read or edit:

- `scripts/test-mekhq-pending-workflow.ps1`
- `tests/fixtures/mekhq-summary-minimal.json`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/handoffs/active/add-automated-mekhq-pending-workflow-regression-tests.md`

Avoid using real MekHQ saves, raw MekHQ save payloads, or protected A Time of War source files as fixtures.

## Commands

Useful commands or checks:

```powershell
git status --short --branch
python -m py_compile scripts/bootstrap-mekhq-campaign.py
./scripts/test-mekhq-pending-workflow.ps1
./scripts/validate-campaign-state.ps1 -CampaignId isekai-atlas-field
git diff --check
git check-ignore source/atow-pdf/example.pdf
git check-ignore source/atow-text/page-001.txt
```

## Constraints

- Route the task into project development mode before editing.
- Do not require a real MekHQ install, real MekHQ save, purchased PDF, extracted A Time of War text, or network access.
- Keep all test output disposable and outside committed campaign folders unless intentionally using a tiny sanitized fixture.
- Do not implement direct MekHQ save/XML writeback.
- Do not commit raw MekHQ save payloads, protected A Time of War source text, purchased PDFs, extracted source text, copied tables, or secrets.
- Commit and push completed project-development changes unless explicitly told not to.

## Acceptance Criteria

- Correct mode identified.
- Adds repeatable automated regression checks for the pending MekHQ workflow.
- Uses only sanitized committed fixtures and disposable temp output.
- Verifies bootstrap output includes `pending-mekhq-actions.md`.
- Verifies validator coverage for the standard pending-actions file.
- Verifies no direct `.cpnx`, `.cpnx.gz`, or MekHQ XML writeback is implied.
- Documents the test command.
- Roadmap and task state updated.
- Verification run or blocker recorded.
- No protected raw source or raw MekHQ save payload committed.
- Changes committed and pushed.

## Open Questions

- Resolved for this issue: keep the test as standalone `scripts/test-mekhq-pending-workflow.ps1`; a broader `scripts/test-all.ps1` can be added later if multiple regression scripts accumulate.
- Resolved for this issue: the negative validator test copies the disposable generated campaign folder, removes `pending-mekhq-actions.md`, and confirms the existing validator fails.
- Deferred: issue `#33` can call this regression script before context-packet helper work if pending-action contracts change or become input to generated packets.

## Completion Notes

- Added `scripts/test-mekhq-pending-workflow.ps1`.
- Added sanitized fixture `tests/fixtures/mekhq-summary-minimal.json`.
- Documented the command in `scripts/README.md` and `docs/current/KNOWN_COMMANDS.md`.
- Updated `docs/current/TASKS.md` and `docs/current/ROADMAP.md`.
- Verification run: `./scripts/test-mekhq-pending-workflow.ps1` passed.
