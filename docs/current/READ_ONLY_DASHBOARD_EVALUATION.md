# Read-Only Dashboard Evaluation

Status: issue `#56` design evaluation.

Purpose: decide whether a read-only MEK-RPG dashboard is worth pursuing, what it should show first, and which boundaries must hold before any UI or adapter work begins.

## Recommendation

Proceed to issue `#57` for a read-only data adapter contract.

The first dashboard value should be campaign state audit and GM context inspection, not a game surface. A useful dashboard should answer: "What campaign state would the assistant load, what warnings exist, what changed recently, and what must not be treated as confirmed?"

Do not build write controls, live movement controls, Sunnytown-derived gameplay surfaces, tactical combat controls, source text viewers, or MekHQ save editors.

## Target Users

- Solo GM/player using MEK-RPG to resume a campaign after time away.
- Agent or future assistant preparing a play scene and needing to inspect the same context packet a human can inspect.
- Project maintainer debugging campaign save structure, stale memory, pending MekHQ items, missing files, and protected-source boundaries.
- MekHQ-linked campaign operator who needs a read-only view of imported ledger summaries, pending manual actions, and bridge discrepancies.

Non-targets:

- Players using a live tactical map.
- A replacement for MekHQ, MegaMek, Classic BattleTech, or A Time of War source books.
- A campaign editor, automation control panel, or GM secret writer.
- A public sharing site for private campaign notes or copyrighted source-derived material.

## Core Read-Only Workflows

### 1. Pre-Session State Audit

Show the active campaign, selected save folder, required files, current-state heading, latest session-log freshness, unresolved hooks, safety/tone presence, and validator warnings.

Useful questions:

- Which campaign is active?
- Is the selected save folder structurally complete?
- Where does play resume?
- Are there missing files, stale pointers, or warnings before the scene starts?

Primary inputs:

- `campaign-state/active-campaign.md`
- `campaigns/<campaign-id>/`
- `scripts/validate-campaign-state.ps1`
- `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`

### 2. GM Context Packet Inspection

Render the deterministic source report from `scripts/build-gm-context-packet.ps1` as an inspectable dashboard view.

Useful questions:

- What sources would the assistant load?
- Which authority notes apply?
- Are pending MekHQ actions clearly labeled as intents?
- Which rules routes and tactical handoff docs are available?
- What warnings must be handled before play?

Primary inputs:

- `docs/current/GM_CONTEXT_PACKET_DESIGN.md`
- `scripts/build-gm-context-packet.ps1`
- `scripts/validate-mekhq-pending-actions.ps1`
- active campaign files

### 3. Session And NPC Review

Provide read-only browsing for recent scene memory and durable continuity.

Useful questions:

- What happened last session?
- Which NPCs have current motives, secrets, promises, or last-seen status?
- Which relationships, grudges, favors, and hooks matter now?
- Which old summaries are durable context versus stale history?

Primary inputs:

- `session-log.md`
- `previous-sessions.md`
- `npcs.md`
- `relationships.md`
- `factions.md`
- `hooks.md`
- `playtest-notes.md`

### 4. Asset, Mission, And Tactical Handoff Review

Show assets, missions, tactical handoff triggers, large-asset schema fields, and unresolved source/tool lookups without resolving tactical combat.

Useful questions:

- Which ships, vehicles, units, cargo, debts, permits, or repairs matter?
- Which missions are active, paused, or waiting on tactical resolution?
- Which assets have unknown condition, legal status, crew, or MekHQ references?
- Is a Classic BattleTech, MegaMek, or MekHQ handoff needed?

Primary inputs:

- `assets.md`
- `missions.md`
- `docs/current/ASSET_SHEET_SCHEMA.md`
- `gm/tactical-encounter-handoff-checklist.md`
- `gm/switch-to-classic-battletech.md`
- `rules/vehicles-and-mechs/overview.md`

### 5. MekHQ Bridge Visibility

For MekHQ-linked campaigns, show bridge metadata, imported hard facts, unsupported fields, unresolved pending actions, and save/re-import boundaries.

Useful questions:

- What was the last imported MekHQ save?
- Which MekHQ-owned facts are visible?
- Which pending items still need manual application, saved re-import, or discrepancy handling?
- Which hard ledger fields are unsupported or unknown?

Primary inputs:

- `mekhq-bridge.md`
- `pending-mekhq-actions.md`
- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- sanitized helper output only; never raw MekHQ saves

## Data Sources And Ownership

| Data source | Dashboard may show | Dashboard must not do |
| --- | --- | --- |
| Campaign pointer and campaign files | File presence, headings, selected campaign id, read-only Markdown excerpts, structured source links | Select a new campaign, rewrite files, merge campaigns, or infer missing facts silently |
| GM context packet helper | Source report, warnings, authority notes, validator output | Interpret rules, summarize scenes, advance time, or apply pending actions |
| Rules indexes and summaries | Routed file names, committed summary paths, page-reference pointers, source-boundary warnings | Display raw protected source, answer rules from mapped-only entries, or copy source tables |
| MekHQ bridge files | Imported summaries, IDs, warnings, unsupported fields, last import metadata | Read raw `.cpnx`, `.cpnx.gz`, XML payloads, write MekHQ saves, or treat pending items as confirmed |
| Pending action validator | Unresolved pending item ids and lifecycle status | Mark items resolved, apply actions, or create UI controls that imply writeback |
| Git/project docs | Current workflow docs and issue-linked design status | Hide dirty status, stage files, commit, push, or close issues from the dashboard |

## Hard Boundaries

- Read-only means no file writes, no git actions, no issue actions, no MekHQ writeback, no generated campaign edits, and no hidden state mutation.
- Do not expose or read `source/atow-pdf/`, `source/atow-text/`, raw purchased source material, copied tables, secrets, or raw MekHQ save payloads.
- Do not embed a tactical rules engine. Tactical resolution remains Classic BattleTech, MegaMek, or MekHQ.
- Do not present pending MekHQ actions as final facts.
- Do not show child/co-player safety/tone notes outside a private local dashboard context.
- Do not create a public web server by default. If a later prototype runs locally, it should bind to localhost and require explicit user action to expose it.
- Do not reuse Sunnytown game movement, live controls, or write surfaces. This is an inspection/debugging layer only.

## Privacy And Locality

The dashboard should assume all campaign files are private. It may contain:

- GM secrets
- child/co-player preferences
- private campaign continuity
- purchased-source page references
- MekHQ save paths
- NPC motives and hidden factions

Recommended posture:

- Local-only by default.
- No telemetry.
- No remote asset fetching required.
- No raw source rendering.
- Clear labels for private, GM-only, unsupported, and pending data.

## Minimum Useful Dashboard

A first dashboard is worthwhile if it can show these panels from read-only adapter output:

1. Active campaign and standard file health.
2. Current scene resume card.
3. Context packet source report and warnings.
4. Recent session and previous-session links.
5. NPC, relationship, hook, mission, and asset summaries by heading.
6. Pending MekHQ action status and bridge metadata when present.
7. Rules/tactical route pointers for the current scene.

The dashboard is not worth building yet if it requires a write API, a database, a tactical map, direct MekHQ integration, or a UI framework decision before the data contract is clear.

## Data Adapter Direction For Issue `#57`

Issue `#57` should design a read-only adapter contract before UI work. It should specify:

- input root and campaign id selection
- JSON shape for campaign file inventory, headings, excerpts, warnings, and source links
- authority labels and evidence labels
- MekHQ bridge and pending-action sections
- protected-source and raw-save exclusion checks
- no-write proof points and test fixtures
- deterministic behavior suitable for regression tests
- explicit non-goals for mutation, control, tactical resolution, and public sharing

## Open Questions For Later

- Should the adapter provide Markdown excerpts or only headings and source links for the first version?
- Should safety/tone be hidden behind an explicit `include_private` flag even on localhost?
- Should the dashboard show git dirty status, or keep git entirely outside the product surface?
- Should issue `#58`'s session archive helper produce metadata the dashboard can consume?

## Decision

Proceed to #57. Build the data adapter contract first. Defer all UI implementation until the adapter can prove read-only behavior, protected-source exclusion, campaign-source clarity, and useful warning output against fixtures.
