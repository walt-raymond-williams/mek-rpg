# Agent Handoff

## Issue

- GitHub issue: `#40` Add top-level deterministic test runner
- Parent epic: `#38`
- Roadmap entry: Automated regression coverage for MekHQ-linked A Time of War workflow
- Mode: Project development / testing
- Status: Completed and archived after implementation.

## Goal

Add a single local command that runs all deterministic MEK-RPG regression and unit-style checks and exits nonzero on failure.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issues `#38` and `#40`
- `scripts/test-mekhq-pending-workflow.ps1`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`

## Output

- Added `scripts/test-all.ps1`.
- Documented the command in `scripts/README.md` and `docs/current/KNOWN_COMMANDS.md`.
- Updated roadmap and task state.

## Files And Areas

Likely files to read or edit:

- `scripts/test-all.ps1`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
./scripts/test-mekhq-pending-workflow.ps1
./scripts/test-all.ps1
git diff --check
git status --short --branch
```

## Constraints

- The runner must not require real MekHQ saves, protected source files, network access, or user interaction.
- Preserve child command output enough to diagnose failures.
- Keep the runner easy to extend as issues `#41`-`#45` add tests.

## Acceptance Criteria

- `scripts/test-all.ps1` runs current deterministic tests from repo root.
- The script exits nonzero when a child test fails.
- The command is documented in `scripts/README.md` and `docs/current/KNOWN_COMMANDS.md`.
- Verification is run or blocker recorded.
- Changes are committed and pushed.

## Close-Out Notes

- The runner continues through configured suites and summarizes failures at the end. With one current suite this behaves like a direct wrapper, and it will be useful as issues `#41` through `#45` add more suites.
