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

- The manual playtest used a Galatea DropShip-purchase scene with the user's son instead of the original `Checkpoint Ghosts` scaffold.
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
- Galatea DropShip playtest implications are considered as an example continuity case.
- Roadmap/tasks updated and handoff archived after completion.
- Changes committed, pushed, and issue updated/closed.

## Open Questions

- Should the Galatea DropShip playtest remain only in issue `#12` records, or should a later campaign intentionally promote any of its elements to table canon?
- Should campaign memory stay as Markdown only, or should some rosters use structured YAML front matter later?

## Issue #13 Memory-Design Input From Issue #12

Confirmed by user after the playtest:

- The actual issue `#12` playtest was the Galatea DropShip purchase scene with Walter and Sharpe, not `Checkpoint Ghosts`.
- The Galatea DropShip scene is playtest only, not table canon.
- The playtest stopped when Captain Selene Arano offered a one-hour inspection of the Union-class DropShip `The Second Dawn`.
- The location is Galatea, the Mercenary's Star.
- Sharpe is the son's placeholder Tech PC for the playtest.

Durable campaign-memory requirement:

- Play mode should not rely on Git history as the play-state mechanism.
- Campaign state should behave like a save game folder: one campaign has its own PCs, NPCs, session logs, locations, assets, relationships, missions, hooks, and current-state files.
- Separate campaigns need separate folders or equivalent state roots so facts do not bleed between campaigns.
- Play mode should be able to lock onto one active campaign state tree and read/write only that campaign during play.
- Future linking between campaigns can be supported later, but the default should isolate campaigns.

Coverage gaps exposed by the playtest:

- The current flat `campaign-state/` structure can store notes, but it cannot cleanly isolate multiple campaigns or playtests.
- There is no dedicated owner for locations such as Galatea docks, broker kiosks, Dock C-19, hangars, or ship interiors.
- There is no dedicated owner for assets such as DropShips, C-bill funds, cooperative stakes, liens, permits, debts, repairs, or pending offers.
- NPC whereabouts, crew affiliation, and relationship state are scattered across rosters, hooks, and session logs.
- `current-mission.md` can drift from the actual playtest scene when the user improvises a different scenario.

Recommended design direction:

- Add a lightweight campaign-root structure, for example `campaigns/<campaign-id>/`, with per-campaign files for overview/current state, PCs, NPCs, factions, locations, assets, relationships, missions, hooks, session logs, rules gaps, and playtest/workflow notes.
- Keep shared GM procedures, rule summaries, and indexes outside campaign roots.
- Add an active-campaign pointer or clear selection step so Play mode knows which campaign save folder to load before scene play.
- Add an end-of-session save checklist that updates the active campaign's files before the assistant closes a play session.
