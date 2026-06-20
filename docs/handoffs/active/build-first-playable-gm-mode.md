# Build First Playable GM Mode

## Issue

- GitHub issue: https://github.com/walt-raymond-williams/mek-rpg/issues/11
- Roadmap entry: Build first playable GM mode
- Mode: Project development
- Priority: High
- Status: Blocked until enough play summaries and setting seed exist

## Goal

Turn the rules summaries, router, campaign-state files, and GM procedures into a first playable tabletop loop that can run a short mission scene.

This is not full automation. It is the minimum reliable GM-assistant mode: frame scenes, route rules, request rolls only when needed, track consequences, and record bugs/gaps.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/current/CORE_LOOKUP_VALIDATION.md`
- `gm/scene-loop.md`
- `gm/roll-policy.md`
- `indexes/task-router.md`
- GitHub issue `#11`

Also read outputs from:

- Issue `#7` personal combat/recovery minimum
- Issue `#8` personal combat lookup validation
- Issue `#10` campaign setting seed

## Expected Output

- Usable campaign-state structure for current mission, PCs, NPCs, factions, session log, unresolved rules gaps, and playtest bugs.
- GM session procedure that links scene loop, roll policy, task router, setting seed, and tactical handoff.
- A short test mission or scene scaffold for manual playtesting.
- Explicit bug-reporting path for issues found during play.
- Manual playtest issue confirmed or updated as the next task.

## Files And Areas

Likely files to read:

- `gm/*.md`
- `campaign-state/`
- `indexes/task-router.md`
- `rules/core/*.md`
- `rules/personal-combat/*.md`
- `docs/current/CORE_LOOKUP_VALIDATION.md`

Likely files to edit:

- `gm/session-procedure.md`
- `gm/mission-template.md`
- `campaign-state/current-mission.md`
- `campaign-state/session-log.md`
- `campaign-state/rules-gaps.md`
- `campaign-state/playtest-bugs.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

```powershell
git status --short --branch
```

## Constraints

- Keep the first playable mode small enough to test by hand.
- Do not create a landing-page style app; this is a repository-backed GM procedure and state loop unless the user asks for a UI later.
- Do not invent missing rules; route through summaries or record gaps.
- Do not store secrets, raw source text, or copyrighted prose.

## Acceptance Criteria

- Correct mode identified as Project development.
- Campaign-state structure created or refined.
- GM session/play procedure created or refined.
- First test mission or scene scaffold exists.
- Router links from play procedure to rules summaries are explicit.
- Manual playtest issue is confirmed as the next task.
- Roadmap/task state updated and handoff archived.
- Changes committed, pushed, and issue updated/closed.

## Open Questions

- Whether to use pregenerated placeholder PCs for the first test or ask the user for character concepts before the playtest.
