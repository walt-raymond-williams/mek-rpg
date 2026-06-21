# Campaign Memory Strategy

Status: implemented as the issue `#13` baseline; expanded by issue `#32`.

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

## Memory Strata

Use campaign files as separate memory layers. Do not let a narrative summary silently replace structured state, and do not use old summaries to contradict the current save files.

### Current Resume State

Owner: `current-state.md`.

Use for the exact point where play should resume: current date or in-day time, current location, active scene, active party, immediate pressure, next prompt, and any urgent blocker.

Update after any scene that changes where play resumes, who is present, what is immediately at stake, or what the next player-facing decision is.

### Active Session Record

Owner: `session-log.md`.

Use for fresh continuity: what happened this session, important choices, rolls, rulings, costs, rewards, queued pending action ids, and the next prompt.

Update during or immediately after meaningful scenes. Keep it concise enough to read before the next scene.

### Completed Session Archive

Owner: `previous-sessions.md`.

Use for durable compressed continuity after a session closes. Each entry should preserve the date or session label, mission context, major outcomes, important NPC or faction shifts, rewards and costs, rulings that may recur, and the next-session hook.

Append here before `session-log.md` is cleared or rolled forward. Do not rewrite old entries except to mark a correction, contradiction, or retcon.

### Structured State Sheets

Owners: `pcs.md`, `npcs.md`, `factions.md`, `locations.md`, `assets.md`, `relationships.md`, `missions.md`, and `hooks.md`.

Use for authoritative campaign facts that future play should rely on without rereading every log entry. These files outrank summaries when facts conflict.

Update when a fact becomes stable enough to affect future scenes: character condition, inventory, money, obligation, NPC status, faction posture, location access, mission status, unresolved hook, relationship leverage, promise, secret, debt, or asset condition.

### Rules And Workflow Memory

Owners: `rules-gaps.md` and `playtest-notes.md`.

Use `rules-gaps.md` for missing, uncertain, provisional, or source-review-needed rules found during this campaign. Use `playtest-notes.md` for save friction, helper gaps, confusing procedures, or campaign-local usability observations.

Do not bury rules uncertainty inside narrative summaries alone.

### Safety And Table Tone

Owner: `safety-and-tone.md`.

Use for player preferences, child/co-player guidance, tone boundaries, agency constraints, and harm-detail limits. This file should be checked before framing scenes that could touch sensitive material.

Update when the user sets, changes, or clarifies a boundary or participation preference.

### MekHQ Bridge And Pending Intents

Owners: `mekhq-bridge.md` and `pending-mekhq-actions.md` for MekHQ-linked campaigns.

Use `mekhq-bridge.md` for imported hard ledger facts, bridge metadata, unsupported fields, and discrepancies. Use `pending-mekhq-actions.md` for proposed or queued hard ledger changes that require manual MekHQ application and later saved import confirmation.

Pending actions are intents, not confirmed facts. Keep narrative causes and RPG consequences in normal campaign files, and cross-reference pending item ids when a hard ledger change may follow.

## Semantic Checkpoints

Save when meaning changes, not after a fixed number of turns. A checkpoint can update one file or many files depending on the consequence.

### Scene Checkpoints

Update `current-state.md` and `session-log.md` when:

- the active location, participants, pressure, or next prompt changes
- a conversation creates a promise, secret, threat, favor, or clue
- a risky roll, ruling, cost, reward, injury, or setback matters later
- the player chooses a plan that future scenes should honor

Route stable effects to structured sheets immediately when the fact will matter outside the current scene.

### Mission Checkpoints

Update `missions.md`, `hooks.md`, `session-log.md`, and usually `current-state.md` when a mission is accepted, advanced, paused, failed, completed, or reframed.

Also update `factions.md`, `relationships.md`, `assets.md`, or `npcs.md` when the mission changes obligations, pay, enemies, patrons, deadlines, or access.

### Relationship And Secret Checkpoints

Update `relationships.md`, `npcs.md`, `factions.md`, and `hooks.md` when trust, leverage, loyalty, fear, family ties, command relationships, secrets, promises, grudges, debts, or favors change.

Put the scene detail in `session-log.md`; put the durable future-facing state in the structured owner file.

### Character And Asset Checkpoints

Update `pcs.md`, `assets.md`, `missions.md`, and `current-state.md` when injuries, fatigue, recovery clocks, equipment, money, cargo, vehicles, contracts, repairs, permits, debts, liens, or large assets change.

For MekHQ-linked campaigns, put hard ledger changes in `pending-mekhq-actions.md` first unless a saved MekHQ import already confirms them.

### Combat And Tactical Handoff Checkpoints

Update `session-log.md`, `current-state.md`, `missions.md`, `assets.md`, `pcs.md`, `npcs.md`, and `hooks.md` after personal combat, risky scenes, or a tactical handoff return when casualties, damage, salvage, prisoners, readiness, objectives, or future pressure change.

When full tactical BattleMech combat matters, switch to Classic BattleTech, MegaMek, or MekHQ and record the returned outcome rather than inventing tactical ledger results.

### Day Boundary And Downtime Checkpoints

Update `current-state.md`, `session-log.md`, `missions.md`, `assets.md`, `pcs.md`, and `hooks.md` when travel, downtime, training, repair, acquisition prep, recovery, or readiness changes the campaign clock.

For MekHQ-linked campaigns, campaign day advancement comes from MekHQ. If MEK-RPG scene time and MekHQ day disagree, record a bridge discrepancy instead of silently advancing the hard campaign date.

### Session Close Checkpoints

When a session is complete:

1. Ensure `current-state.md` has the next resume point.
2. Ensure `session-log.md` names the major choices, rolls, rulings, costs, rewards, state changes, and pending MekHQ item ids.
3. Append a durable summary to `previous-sessions.md`.
4. Move durable facts from the log into the structured owner files.
5. Record rules gaps, workflow friction, or safety/tone updates while they are fresh.

## Corrections And Superseded Facts

When the user corrects a fact, a later import contradicts a narrative assumption, or an old summary is superseded:

- update the highest-authority owner file first
- mark the old statement as `Corrected`, `Superseded`, `Retconned`, or `Needs review` when leaving it in an archive
- do not delete useful old context unless it is misleading, sensitive, or explicitly removed by the user
- record why the fact changed when the correction may matter later
- for MekHQ-linked campaigns, preserve RPG-side scene memory unless the table explicitly retcons the scene

If a summary and a structured sheet conflict, trust the structured sheet and add a short correction note to the stale summary or `playtest-notes.md`.

## Load And Save Rule

Before play, the assistant should load only one active campaign save folder unless the user explicitly asks to compare or migrate campaigns. If no active campaign is selected, ask which campaign to load or whether to start from `campaigns/_template/`.

After meaningful play, the assistant should update the active save folder directly using the semantic checkpoint rules above and `gm/state-save-checklist.md`. Git commits are optional for play mode; the durable play state is the files themselves. Development-mode close-out still commits and pushes repository changes.

## Galatea Playtest Implication

Issue `#12` showed why this matters. The Galatea DropShip purchase scene introduced Walter, Sharpe, multiple named NPCs, two DropShips, a large money pool, legal/technical ownership risks, and a pending one-hour inspection. Those objects are useful continuity data, but the user confirmed they are playtest-only and not table canon. The correct storage model is therefore a separate playtest save folder, not accidental merger into the future main campaign.

## Follow-Up Candidates

- Done in issue `#15`: `scripts/new-campaign-save.ps1` creates a new campaign folder from `campaigns/_template/`.
- Add a short command or checklist to archive a completed session into campaign-local history.
- Add structured front matter later only if Markdown scanning becomes too slow or ambiguous.
- Add richer DropShip and unit sheets after transport ownership rules are summarized.
