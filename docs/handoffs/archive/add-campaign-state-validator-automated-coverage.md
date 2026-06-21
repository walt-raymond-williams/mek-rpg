# Agent Handoff

## Issue

- GitHub issue: `#43` Add campaign-state validator automated coverage
- Parent epic: `#38`
- Roadmap entry: Automated regression coverage for MekHQ-linked A Time of War workflow
- Mode: Project development / testing
- Status: Completed and archived after implementation.

## Goal

Add deterministic positive and negative tests for `scripts/validate-campaign-state.ps1` so campaign save structure regressions are caught quickly.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issues `#38`, `#39`, and `#43`
- `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`
- `scripts/validate-campaign-state.ps1`
- `campaigns/_template/`

## Output

- Added `scripts/test-validate-campaign-state.ps1`.
- Added a `-RepoRoot` test hook to `scripts/validate-campaign-state.ps1`.
- Integrated the suite into `scripts/test-all.ps1`.
- Documented the command in `scripts/README.md` and `docs/current/KNOWN_COMMANDS.md`.
- Updated roadmap and task state.

## Files And Areas

Likely files to read or edit:

- `scripts/test-validate-campaign-state.ps1` or equivalent
- `scripts/validate-campaign-state.ps1` only if needed for testability
- `tests/fixtures/` if fixture folders are useful
- `scripts/test-all.ps1` if present
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
./scripts/validate-campaign-state.ps1 -CampaignId isekai-atlas-field
./scripts/test-validate-campaign-state.ps1
./scripts/test-all.ps1
git diff --check
```

## Constraints

- Do not mutate `campaign-state/active-campaign.md` unless using a disposable copy or a test-only parameter added intentionally.
- Clean up all disposable folders and files.
- Keep the shared campaign validator focused on structural safety.

## Acceptance Criteria

- Valid explicit campaign passes.
- Missing required standard file fails.
- Missing top-level heading warns without failing unless requirements say otherwise.
- `-StrictActive` failure behavior is covered.
- Legacy `campaign-state/` active pointer failure behavior is covered.
- Unsafe campaign ids are rejected.
- Verification is run or blocker recorded.
- Changes are committed and pushed.

## Close-Out Notes

- Added `-RepoRoot` so tests can use a disposable temp repository fixture without mutating the live active campaign pointer.
