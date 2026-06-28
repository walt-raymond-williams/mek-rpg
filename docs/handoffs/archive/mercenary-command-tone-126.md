# Agent Handoff

## Issue

- GitHub issue: `#126`
- Roadmap entry: Improve RPG game-mode prose quality / tone control for live play
- Mode: Project development
- Priority: Completed user-requested interrupt

## Goal

Make live RPG narration and command dialogue less corporate by adding durable tone controls for rough mercenary military voice, with Sharpe's Strikers as the first campaign using the profile.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `gm/narrative-tone-profiles.md`
- `campaigns/sharpes-strikers/safety-and-tone.md`

## Expected Output

- Reusable GM tone profile guidance.
- Active campaign tone settings for Sharpe's Strikers.
- Workflow tracking in roadmap/tasks and this handoff.
- Commit and push referencing issue `#126`.

## Files And Areas

Likely files to read or edit:

- `gm/narrative-tone-profiles.md`
- `gm/gm-style.md`
- `gm/session-procedure.md`
- `campaigns/_template/safety-and-tone.md`
- `campaigns/sharpes-strikers/safety-and-tone.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
git diff --check
git status --short --branch
git ls-files source/atow-pdf source/atow-text
```

## Constraints

- Route the task into project development mode.
- Do not include unrelated user changes from the existing dirty worktree.
- Do not copy song lyrics, BattleTech novel text, rulebook text, or raw source material.
- Tone guidance can cite broad influence categories and user-confirmed preferences, but should remain original procedural guidance.
- Commit and push completed project-development changes unless explicitly told not to.

## Acceptance Criteria

- `gm/narrative-tone-profiles.md` exists and gives concrete anti-corporate rewrite rules.
- Live play startup explicitly applies campaign tone profiles.
- Sharpe's Strikers records the confirmed rough mercenary military tone.
- `docs/current/TASKS.md` and `docs/current/ROADMAP.md` record issue `#126`.
- Verification is run or blocker recorded.
- No protected raw source files are staged.

## Completion Notes

- Implemented in issue `#126`.
- Handoff archived after the GM tone profile, active campaign tone settings, roadmap, and task board were updated.

## Open Questions

- Kid-friendly mode for Sharpe's Strikers remains `Needs user decision`.
- Future work may add validation or context-packet display for active tone settings if play shows the guidance is skipped.
