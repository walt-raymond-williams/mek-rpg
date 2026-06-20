# Design Durable Campaign Memory Tracking

## Issue

- GitHub issue: https://github.com/walt-raymond-williams/mek-rpg/issues/13
- Roadmap entry: Design durable campaign memory tracking
- Mode: Project development
- Priority: High
- Status: Ready after issue `#12` playtest observation

## Goal

Investigate and design a durable campaign-memory strategy so MEK RPG can reliably resume play without depending on chat context alone.

The memory system should answer practical GM questions:

- Who are the PCs, and what is their current condition, gear, role, and unresolved sheet state?
- Who are the NPCs, where are they, who do they work for, what do they want, and what do they know?
- Which factions, locations, assets, vehicles, DropShips, contracts, debts, and hooks are active?
- What happened last session, what changed, and what must be remembered before the next scene?

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `gm/session-procedure.md`
- `gm/scene-loop.md`
- `campaign-state/README.md`
- all current `campaign-state/*.md` files
- GitHub issue `#13`

Also consider issue `#12` observation:

- The manual playtest used a Glacier DropShip-purchase scene with the user's son instead of the original `Checkpoint Ghosts` scaffold.
- The playtest went well, but exposed the need for a reliable campaign memory/save strategy.

## Expected Output

- Audit current `campaign-state/` files and GM procedures for memory coverage.
- Define what must be tracked for PCs, NPCs, factions, locations, assets/vehicles/DropShips, missions, unresolved hooks, relationships, conditions, inventory, and session outcomes.
- Propose or implement a small durable campaign-memory structure that supports quick resume.
- Add an end-of-session/state-save checklist to the GM procedure if missing.
- Include guidance for child/co-player sessions where tone, agency, and safety constraints should be remembered.
- Identify follow-up issues needed for automation, templates, or richer campaign state.

## Files And Areas

Likely files to read or edit:

- `campaign-state/README.md`
- `campaign-state/current-campaign.md`
- `campaign-state/current-mission.md`
- `campaign-state/player-characters.md`
- `campaign-state/npc-roster.md`
- `campaign-state/faction-roster.md`
- `campaign-state/unresolved-hooks.md`
- `campaign-state/session-log.md`
- `campaign-state/playtest-bugs.md`
- `campaign-state/rules-gaps.md`
- `gm/session-procedure.md`
- `gm/session-log-template.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

Possible new files:

- `campaign-state/location-roster.md`
- `campaign-state/assets-roster.md`
- `campaign-state/relationship-map.md`
- `gm/state-save-checklist.md`

## Commands

```powershell
git status --short --branch
gh issue view 13 --json number,title,state,body,url
```

## Constraints

- Keep the system lightweight and repo-native unless a stronger need appears.
- Do not rely on chat context as durable memory.
- Do not process raw source PDFs or extracted rule text.
- Do not over-specify canon facts that the user has not confirmed.
- Preserve uncertainty with labels like `Confirmed by user`, `Inferred`, `Unknown`, or `Needs lookup`.

## Acceptance Criteria

- Correct mode identified as Project development.
- Current campaign-state coverage is audited.
- Durable memory requirements are documented.
- Recommended file structure or template updates are implemented or clearly specified.
- GM close-out procedure includes a clear state-save checklist.
- Glacier DropShip playtest implications are considered as an example continuity case.
- Roadmap/tasks updated and handoff archived after completion.
- Changes committed, pushed, and issue updated/closed.

## Open Questions

- Should the Glacier DropShip scene become committed table canon now, or should issue `#13` first define the memory schema and then record it?
- Should campaign memory stay as Markdown only, or should some rosters use structured YAML front matter later?
