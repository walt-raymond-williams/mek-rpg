# GM Context Packet Design

Status: issue `#31` design note.

Purpose: define the canonical, inspectable context packet used before and during play. A later helper can assemble or report this packet, but the authority rules here apply immediately.

## Core Principle

A GM context packet is an ordered bundle of inputs, not a new source of truth. It helps the assistant decide what to read and what to foreground, while preserving the ownership boundaries already established in campaign files, rules summaries, and MekHQ bridge docs.

When packet layers disagree, prefer the highest-authority current layer and record the conflict instead of blending the facts.

## Authority Order

1. `User turn`: the user's latest explicit instruction, table decision, or correction in the current conversation.
2. `Agent instructions`: `AGENTS.md` and current project workflow docs for mode routing, copyright boundaries, and close-out expectations.
3. `Mode procedure`: the relevant play, rules lookup, project-development, or source-processing procedure.
4. `Structured campaign state`: active campaign pointer plus current campaign save files.
5. `MekHQ hard ledger import`: for MekHQ-linked campaigns, latest `mekhq-bridge.md` and imported hard facts.
6. `Pending MekHQ intents`: unresolved `pending-mekhq-actions.md` items, labeled as command proposals, command results awaiting verification, or manual fallback checklists rather than confirmed facts.
7. `Rules routes and summaries`: `indexes/task-router.md`, routed paraphrased summaries, and page-reference indexes when summaries are insufficient.
8. `Recent event record`: current `session-log.md` and immediate scene notes.
9. `Durable narrative memory`: `previous-sessions.md`, relationships, hooks, NPC motives, faction posture, and older summaries.
10. `Open gaps and warnings`: `rules-gaps.md`, `playtest-notes.md`, helper warnings, unsupported fields, and bridge discrepancies.

This order means structured campaign files override stale narrative summaries. MekHQ imported or live-verified facts override MEK-RPG guesses for hard ledger fields. Pending MekHQ actions never override confirmed hard facts until a MekHQ live reread or saved import verifies them.

## Packet Layers

### 1. Request And Mode

Inputs:

- latest user request
- `AGENTS.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`

Purpose:

- identify one primary mode
- decide whether edits are allowed
- apply copyright and protected-source boundaries
- choose the close-out path

Failure modes:

- starting source processing without an explicit source-processing request
- doing project development during play without being asked
- answering rules from memory when committed summaries exist

### 2. Active Campaign Selection

Inputs:

- `campaign-state/active-campaign.md`
- exactly one selected `campaigns/<campaign-id>/` folder
- `campaigns/README.md`

Purpose:

- identify the save folder for persistent play state
- reject legacy flat `campaign-state/` files as live campaign saves
- prevent mixing multiple campaign saves unless the user explicitly asks

Failure modes:

- loading no campaign for play
- merging playtest-only and table-canon saves
- treating `campaign-state/current-campaign.md` or other legacy flat files as the active save

### 3. Structured Campaign State

Inputs:

- `overview.md`
- `current-state.md`
- `pcs.md`
- `npcs.md`
- `factions.md`
- `locations.md`
- `assets.md`
- `relationships.md`
- `missions.md`
- `hooks.md`
- `safety-and-tone.md`

Purpose:

- establish the current scene, player characters, important NPCs, factions, locations, assets, relationships, mission state, hooks, and table boundaries
- provide the authoritative MEK-RPG state for RPG memory

Freshness expectation:

- `current-state.md` and `session-log.md` should describe the latest resume point
- stale summaries should not override these structured files

Failure modes:

- using older narrative summaries to contradict current structured state
- ignoring safety/tone or child/co-player constraints
- treating sparse generated MekHQ bootstrap stubs as full A Time of War sheets

### 4. MekHQ Bridge Layer

Inputs for MekHQ-linked campaigns:

- `mekhq-bridge.md`
- `mekhq-api-gaps.md` when present
- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`
- `docs/current/MEKHQ_CHECKPOINT_WARNING_SURFACING.md`
- captured `GET /campaign/summary`, `GET /campaign/state` with `bridge_metadata`, and `GET /campaign/commands` context when MekHQ is open
- generated output from `scripts/sync-mekhq-live-campaign.py` for active loaded MekHQ campaigns
- latest output from `scripts/summarize-mekhq-save.py` when explicitly imported

Purpose:

- identify MekHQ-owned hard facts: date, day advancement, finances, rosters, unit condition, repairs, contracts, markets, scenarios, tactical outcomes, logistics, and bridge warnings
- prefer live API snapshot context for active loaded MekHQ campaigns when available
- preserve imported IDs and unsupported-field notes
- classify checkpoint warnings and unsupported fields as blockers, manual-inspection items, caution notes, or FYI diagnostics before surfacing them to the GM

Failure modes:

- parsing an active MekHQ save as the routine live-play refresh path while the live API is available
- advancing the MEK-RPG date independently of MekHQ
- inventing exact funds, repair times, market prices, contract state, unit condition, or personnel availability
- implying direct `.cpnx`, `.cpnx.gz`, XML, or raw save writeback

### 5. Pending MekHQ Intent Layer

Inputs:

- `pending-mekhq-actions.md`
- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- optional `scripts/validate-mekhq-pending-actions.ps1 -ReportUnresolved`

Purpose:

- surface proposed, queued, user-applied, imported, or blocked hard ledger intents
- remind the GM which items need guarded command dry-run/execution, live reread verification, manual MekHQ UI application, saved re-import, or discrepancy resolution

Authority:

- unresolved items are command proposals, command results awaiting verification, manual-action checklists, or intents
- they are not confirmed funds, roster changes, repairs, contracts, scenario outcomes, salvage, unit damage, or campaign dates

Failure modes:

- treating a queued purchase, repair, contract, injury, personnel change, tactical outcome, or day advancement as final before MekHQ confirms it
- hiding blockers from the pre-session checkpoint

### 6. Rules Route Layer

Inputs:

- `indexes/task-router.md`
- routed files under `rules/`
- `indexes/page-reference-index.md` when committed summaries are insufficient
- `rules-gaps.md`

Purpose:

- identify the committed rules summaries needed for likely upcoming procedures
- keep A Time of War answers source-bound, paraphrased, and uncertainty-preserving
- record unresolved gaps instead of inventing procedures

Failure modes:

- copying rulebook text or tables
- using raw source text in a packet
- hiding a missing or placeholder rule as if verified

### 7. Recent Event Layer

Inputs:

- `session-log.md`
- current scene notes from the user turn
- recent choices, rolls, rulings, costs, rewards, and next prompt

Purpose:

- keep immediate continuity available without forcing older summaries to carry fresh details
- identify what just changed and what needs saving

Failure modes:

- letting older summaries overwrite the latest scene
- losing roll/ruling context that should be saved after play

### 8. Durable Memory Layer

Inputs:

- `previous-sessions.md`
- `relationships.md`
- `hooks.md`
- `npcs.md`
- `factions.md`
- `playtest-notes.md`

Purpose:

- preserve older continuity, promises, secrets, grudges, favors, faction posture, unresolved hooks, and workflow observations
- provide relevant memory without treating every old detail as current scene state

Failure modes:

- duplicate old summaries crowding out current state
- treating a resolved hook as active because it appears in old notes
- mixing playtest-only memory into table canon

### 9. Warnings And Open Questions

Inputs:

- `rules-gaps.md`
- `playtest-notes.md`
- `mekhq-bridge.md` warnings and unsupported fields
- `docs/current/MEKHQ_CHECKPOINT_WARNING_SURFACING.md` for MekHQ-linked warning severity
- active handoffs or issue notes when doing project development

Purpose:

- expose uncertainty before it causes a bad ruling or wrong state update
- keep helper warnings and unsupported mappings visible

Failure modes:

- smoothing over uncertainty
- using a packet as if it were complete when required files or fields are missing

## Mode Differences

### Play Mode

Use the full packet. Start with the active campaign, structured current state, safety/tone, recent log, hooks, and any likely rules routes. For MekHQ-linked campaigns, include bridge metadata and unresolved pending intents before any ledger-sensitive scene.

The packet should be just enough to run the next scene. It should not become a giant archive dump.

### Rules Lookup Mode

Use a narrow packet:

1. latest user rules question
2. `indexes/task-router.md`
3. routed committed summaries
4. page-reference index or summary source references if committed summaries are insufficient
5. relevant campaign context only when the ruling depends on current character, equipment, injury, vehicle, contract, or scene state

Do not include raw A Time of War source text.

### MekHQ-Linked Play

Use play mode plus:

- `docs/current/MEKHQ_OPEN_CONNECTION_STARTUP_DECISION_TREE.md`
- live `GET /campaign/summary`, `GET /campaign/state` with `bridge_metadata`, and `GET /campaign/commands` context when MekHQ is open
- latest `mekhq-bridge.md`
- latest `mekhq-api-gaps.md` when present
- unresolved `pending-mekhq-actions.md`
- helper warnings and unsupported fields
- date and hard-ledger discrepancy checks
- tactical handoff triggers

Every pending item must be labeled as an intent, command proposal/result, or manual checklist. MekHQ remains authoritative until a supported command plus live reread or a manual UI action plus saved import confirms the result. If the live API is unavailable, the packet must label MekHQ-owned facts as stale or explicitly offline/debug-derived.

### Project Development Mode

Use the project-development packet:

- `AGENTS.md`
- current workflow docs
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue body and comments
- active handoff
- relevant owner files
- current git status

Do not load campaign play memory unless the issue touches play workflow, campaign files, or continuity.

## Packet Skeleton

```markdown
# GM Context Packet

## Request And Mode
- User request:
- Primary mode:
- Close-out expectation:

## Active Campaign
- Active campaign:
- Save folder:
- Canon/playtest status:

## Authority Notes
- Structured campaign files override:
- MekHQ owns:
- Pending MekHQ items are:
- Rules source boundary:

## Current Scene State
- Resume point:
- Current location/date:
- Active PCs/NPCs:
- Immediate pressure:
- Next prompt:

## MekHQ Bridge And Pending Intents
- Last import:
- Unsupported fields:
- Unresolved pending item ids:
- Day-advance blockers:

## Rules Routes
- Likely procedures:
- Files to read:
- Known rules gaps:

## Recent Events
- Current session summary:
- Important rolls/rulings:
- Unsaved consequences:

## Durable Memory
- Relevant relationships:
- Relevant hooks:
- Faction/NPC context:
- Older summaries used:

## Warnings
- Stale or conflicting facts:
- Missing files:
- Protected-source/no-writeback reminders:
```

The helper in issue `#33` may emit this shape or a machine-readable equivalent, but it must keep the sections inspectable.

## Helper Requirements For Issue `#33`

The first deterministic helper should:

- resolve `campaign-state/active-campaign.md`
- list the selected campaign folder and standard files
- report missing files and stale active-pointer problems
- include or list current-state, session-log, pending MekHQ actions, bridge metadata, rules gaps, and safety/tone inputs
- optionally run `scripts/validate-campaign-state.ps1`
- optionally run `scripts/validate-mekhq-pending-actions.ps1 -ReportUnresolved` for MekHQ-linked saves
- print file paths and warnings rather than inventing facts
- avoid raw A Time of War source text, raw MekHQ save payloads, and direct MekHQ writeback

The helper should not generate narrative summaries, choose rules rulings, advance time, apply pending actions, or rewrite campaign files.

## Follow-Up Boundaries

- Issue `#32` should define memory strata and semantic checkpoint triggers in more detail.
- Issue `#33` should prototype the deterministic packet helper.
- Issue `#34` should add regression scenarios for general context behavior after the design is usable.
- Issue `#45` should add MekHQ-linked context packet scenarios after the helper or equivalent testable assembly exists.
