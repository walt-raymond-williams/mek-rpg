# Run First Manual Playtest And File Follow-Up Bugs

## Issue

- GitHub issue: https://github.com/walt-raymond-williams/mek-rpg/issues/12
- Roadmap entry: Run first manual playtest and file follow-up bugs
- Mode: Play mode / project development close-out
- Priority: High
- Status: Ready after issue `#11`

## Goal

Run a short manual playtest of the first playable GM mode and turn any rough edges into concrete follow-up issues.

This is the recurring reality check: prove the assistant can run a scene, route rules, track state, and expose missing pieces while the experience is still small enough to fix.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `gm/scene-loop.md`
- `gm/roll-policy.md`
- `indexes/task-router.md`
- current campaign-state files
- GitHub issue `#12`

Also read outputs from issue `#11`:

- `gm/session-procedure.md`
- `campaign-state/current-mission.md`
- `campaign-state/session-log.md`
- `campaign-state/rules-gaps.md`
- `campaign-state/playtest-bugs.md`

## Expected Output

- A short scene is played manually using the GM procedures.
- Session/playtest log under `campaign-state/` or a dedicated playtest report under `docs/current/`.
- Updated campaign state if the test scene changes persistent facts.
- Follow-up GitHub issues for bugs, missing summaries, routing failures, awkward UX, or unclear procedures.
- Roadmap/tasks updates showing what was learned.
- This handoff archived after completion.

## Playtest Prompts

Use a small scenario that exercises:

- scene framing and player choice
- at least one core skill or attribute check
- at least one opposed or pressured roll
- personal combat if issue `#7` and issue `#8` have made it ready
- state updates after the scene
- bug/gap capture when the assistant cannot answer cleanly

## Files And Areas

Likely files to read:

- `gm/scene-loop.md`
- `gm/roll-policy.md`
- `gm/session-procedure.md`
- `campaign-state/current-mission.md`
- `campaign-state/session-log.md`
- `campaign-state/playtest-bugs.md`
- `campaign-state/rules-gaps.md`
- `indexes/task-router.md`

Likely files to edit during close-out:

- campaign-state logs
- playtest bug/gap files
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- follow-up GitHub issues

## Commands

```powershell
git status --short --branch
gh issue list --state open --limit 20
```

## Constraints

- During play, keep the scene moving.
- During rules lookup, start from `indexes/task-router.md` when summaries exist.
- If a rule gap appears, do not invent precise rules; make a provisional table ruling only when needed and record the gap.
- Do not kill a child player character without explicit adult approval.
- Switch to Classic BattleTech, MegaMek, or MekHQ when tactical combat detail matters.

## Acceptance Criteria

- Correct mode identified as Play mode during scene, then Project development for close-out.
- A short scene is played manually using the GM procedures.
- Rules lookups start from `indexes/task-router.md` when summaries exist.
- Campaign/playtest state is updated.
- Follow-up bugs or missing-rule issues are created when needed.
- Roadmap/task state updated and handoff archived.
- Changes committed, pushed, and issue updated/closed if repository files changed.

## Open Questions

- Whether to use the placeholder Scout, Tech, and Medic from `campaign-state/player-characters.md`, or ask the user for character concepts before starting.
