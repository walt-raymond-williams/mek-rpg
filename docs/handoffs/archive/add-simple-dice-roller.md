# Add Simple Dice Roller

## Issue

- GitHub issue: https://github.com/walt-raymond-williams/mek-rpg/issues/16
- Roadmap entry: Add simple dice roller for live play
- Mode: Project development
- Priority: Medium
- Status: Done

## Goal

Add a small dice roller script that supports common A Time of War play rolls, starting with expressions like `2d6`, `2d6+2`, and `2d6-1`.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- `gm/roll-policy.md`
- `rules/core/basic-action-resolution.md`
- GitHub issue `#16`

## Expected Output

- A script under `scripts/` that parses and rolls simple dice expressions.
- Output showing expression, individual dice, modifier, and total.
- Optional label support if straightforward.
- Usage documentation and basic verification.

## Files And Areas

Likely files to read or edit:

- `scripts/`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `gm/roll-policy.md` only if the script needs to be referenced from play guidance
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
Get-ChildItem -Name scripts
rg "dice|roll.py|roller|2d6" scripts gm docs/current README.md
git diff --check
git diff --cached --check
git diff --cached --name-only | Select-String -Pattern '^(source/atow-pdf/|source/atow-text/)'
```

## Constraints

- Keep v1 deliberately small.
- Do not implement full A Time of War outcome logic in the roller.
- Do not replace `gm/roll-policy.md`; the script only rolls dice and reports totals.

## Acceptance Criteria

- Correct mode identified as Project development.
- Roller supports `NdM`, `NdM+K`, and `NdM-K` for positive integer values.
- Roller reports individual dice and total.
- Invalid expressions fail clearly.
- Usage documented.
- Roadmap/tasks updated and handoff archived after completion.
- Verification run or blocker recorded.
- No protected raw source committed.
- Changes committed and pushed.

## Open Questions

- Resolved: repeated rolls are deferred until actual play shows a need.

## Completion Notes

- Added `scripts/roll-dice.ps1`.
- Documented usage in `scripts/README.md` and `docs/current/KNOWN_COMMANDS.md`.
- Verified valid `2d6+2` rolls and invalid-expression failure.
