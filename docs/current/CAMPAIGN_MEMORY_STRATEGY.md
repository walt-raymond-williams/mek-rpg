# Campaign Memory Strategy

Status: implemented as the issue `#13` baseline.

Purpose: make campaign continuity durable enough that play can resume from repository files without relying on chat context, agent memory, or Git history as the play-state mechanism.

## Audit

The issue `#11` and `#12` files under `campaign-state/` proved the basic GM loop works, but the flat structure has limits:

- It mixes global setting assumptions, active mission state, playtest-only notes, and future table canon.
- It lacks dedicated owners for locations, assets, relationships, and child/co-player tone notes.
- It can record NPCs and factions, but current whereabouts, obligations, secrets, and relationship changes are scattered.
- It does not isolate different campaigns or playtests, so an improvised session can drift away from the current mission scaffold.
- It does not provide an explicit load/save step for play mode.

## Design

Use repository-native campaign save folders:

```text
campaigns/
  _template/
  <campaign-id>/
    overview.md
    current-state.md
    pcs.md
    npcs.md
    factions.md
    locations.md
    assets.md
    relationships.md
    missions.md
    hooks.md
    session-log.md
    previous-sessions.md
    rules-gaps.md
    playtest-notes.md
    safety-and-tone.md
```

Keep shared rules, indexes, GM procedures, and broad setting seeds outside campaign folders. Use `campaign-state/active-campaign.md` as the active save pointer before play.

## Required Coverage

- PCs: player, concept, current condition, resources, gear, sheet gaps, personal goals, and limited resources.
- NPCs: role, location, affiliation, attitude, goals, secrets, promises, current status, and last-seen scene.
- Factions: agenda, posture toward PCs, important NPCs, local assets, obligations, and open canon questions.
- Locations: current scene location, important places, access rules, hazards, contacts, and unresolved details.
- Assets: money, vehicles, DropShips, contracts, permits, debts, liens, repairs, cargo, rewards, and losses.
- Relationships: trust, leverage, debts, rivalries, fear, family ties, command relationships, and crew loyalties.
- Missions and hooks: active objective, next scene prompt, threats, deadlines, choices, unresolved hooks, and tactical handoff triggers.
- Session outcomes: current-session notes in `session-log.md`; completed-session summaries, rolls, rulings, state changes, rewards, costs, and next-session prompts in `previous-sessions.md`.
- Safety and tone: child/co-player participation, tone boundaries, agency preferences, and harm/violence constraints.

## Load And Save Rule

Before play, the assistant should load only one active campaign save folder unless the user explicitly asks to compare or migrate campaigns. If no active campaign is selected, ask which campaign to load or whether to start from `campaigns/_template/`.

After meaningful play, the assistant should update the active save folder directly. Git commits are optional for play mode; the durable play state is the files themselves. Development-mode close-out still commits and pushes repository changes.

## Galatea Playtest Implication

Issue `#12` showed why this matters. The Galatea DropShip purchase scene introduced Walter, Sharpe, multiple named NPCs, two DropShips, a large money pool, legal/technical ownership risks, and a pending one-hour inspection. Those objects are useful continuity data, but the user confirmed they are playtest-only and not table canon. The correct storage model is therefore a separate playtest save folder, not accidental merger into the future main campaign.

## Follow-Up Candidates

- Add scripts to create a new campaign folder from `campaigns/_template/`.
- Add a short command or checklist to archive a completed session into campaign-local history.
- Add structured front matter later only if Markdown scanning becomes too slow or ambiguous.
- Add richer DropShip and unit sheets after transport ownership rules are summarized.
