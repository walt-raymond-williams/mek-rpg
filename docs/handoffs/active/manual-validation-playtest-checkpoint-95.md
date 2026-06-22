# Agent Handoff

## Issue

- GitHub issue: `#95` Epic: manual validation and playtest checkpoint after rules expansion
- Roadmap entry: Manual validation and playtest checkpoint after rules expansion
- Mode: Project development / manual validation coordination
- Priority: Blocked coordination epic

## Goal

Coordinate completion of the validation wave after issues `#90`-`#94`, then close the epic only after child issues are complete or explicitly blocked with clear follow-up state.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`

Task-specific context:

- GitHub issues `#96`-`#100`
- `docs/current/LATEST_RULES_LOOKUP_RUNTHROUGH_VALIDATION.md` if present
- `docs/current/CHARACTER_CREATION_PC_SHEET_RUNTHROUGH.md` if present

## Expected Output

- Confirm child issue completion or blockers.
- Convert discovered bugs and gaps into follow-up GitHub issues.
- Update roadmap and task state.
- Close `#95` only when no child work remains actionable for the current wave.

## Files And Areas

Likely files to read or edit:

- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/handoffs/active/`
- `docs/handoffs/archive/`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
gh issue list --state open --limit 100
gh issue view 95 --comments
```

## Constraints

- `#95` is labeled `blocked` because it depends on child issue state.
- Autonomous agents should skip `#95` until child issues are complete or explicitly blocked.
- Do not perform source processing as part of this coordination epic.
- Do not close `#95` while `#97`, `#99`, or `#100` remain open without a documented decision.

## Acceptance Criteria

- Child issue state is reconciled against GitHub.
- Manual/user-gated child issues are clearly labeled.
- Roadmap and task state match GitHub.
- Completed handoffs are archived.
- Changes are committed and pushed.

## Open Questions

- Whether user-gated issues `#97` and `#99` should remain open as blocked tickets or be closed and re-opened only when the user is available.
