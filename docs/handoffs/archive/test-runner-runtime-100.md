# Agent Handoff

## Issue

- GitHub issue: `#100` Diagnose and improve full test runner runtime
- Roadmap entry: Keep deterministic verification usable as regression coverage expands
- Mode: Project development
- Priority: Agent-ready

## Goal

Diagnose why `./scripts/test-all.ps1` can exceed a normal agent verification timeout and make the runner easier to use for routine close-out.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`

Task-specific context:

- `scripts/test-all.ps1`
- Individual scripts called by `scripts/test-all.ps1`

## Expected Output

- Measured per-suite runtime or enough diagnostics to identify slow tests.
- Runner improvements, documented expected runtime, or split quick/full verification commands if appropriate.
- Updated command docs if command behavior changes.

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
git status --short --branch
Measure-Command { ./scripts/test-all.ps1 }
./scripts/test-all.ps1
```

## Constraints

- This issue is agent-ready and should not require user presence.
- Do not remove meaningful coverage just to make the suite faster.
- Keep tests safe for local verification: no protected source files, no real MekHQ saves, no network requirement, and no user interaction.
- Be careful around existing uncommitted changes from other issue work.

## Acceptance Criteria

- Slow suite or timeout cause is identified.
- Runner behavior is improved or documented.
- Quick verification path is considered if full verification is expected to stay long.
- Roadmap and task state are updated.
- Verification result or blocker is recorded.
- Changes are committed and pushed.

## Open Questions

- Whether the desired default close-out command should be a quick suite, full suite, or documented choice by task scope.
