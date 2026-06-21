# Agent Handoff

## Issue

- GitHub issue: `#43` Add campaign-state validator automated coverage
- Parent epic: `#38`
- Roadmap entry: Automated regression coverage for MekHQ-linked A Time of War workflow
- Mode: Project development / testing
- Priority: After issue `#39`; useful before deeper campaign validators are added.

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

## Expected Output

- Test script for campaign-state validator behavior.
- Disposable test setup that does not mutate live campaign state.
- Documentation updates and test runner integration if `scripts/test-all.ps1` exists.

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

## Open Questions

- Does the validator need an explicit `-RepoRoot` testability parameter, or can tests use disposable in-repo folders safely?
