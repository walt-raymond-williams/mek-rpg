# Tactical Encounter Handoff Checklist

Use this checklist when a MEK-RPG scene leaves RPG-scale resolution and needs Classic BattleTech, MegaMek, or MekHQ for tactical combat.

This file prepares the handoff. It does not implement tactical rules, unit records, MekHQ save writes, damage resolution, salvage math, or repair accounting in MEK-RPG.

## Switch Trigger

- Tactical detail matters: facing, hex movement, terrain costs, heat, armor locations, weapon ranges, ammunition, initiative by unit, critical hits, or exact unit survival.
- The fight includes BattleMechs, combat vehicles, aerospace units, battle armor, DropShips, turrets, or multiple coordinated units.
- The outcome will change salvage, repairs, casualties, force readiness, contract status, cargo, prisoners, reputation, or campaign logistics.
- A player wants tactical positioning or exact unit-scale survival to matter.

Stay in RPG mode for brief chases, intimidation, sabotage, routine travel, vehicle purchase scenes, single decisive shots, or crew assignment moments where a scene consequence is enough.

## Pre-Handoff Sources

Read only what the encounter needs:

- `campaign-state/active-campaign.md`
- active `campaigns/<campaign-id>/current-state.md`
- active `campaigns/<campaign-id>/assets.md`
- active `campaigns/<campaign-id>/missions.md`
- active `campaigns/<campaign-id>/pcs.md`
- active `campaigns/<campaign-id>/npcs.md`
- active `campaigns/<campaign-id>/factions.md`
- active `campaigns/<campaign-id>/hooks.md`
- `gm/switch-to-classic-battletech.md`
- `gm/encounter-template.md`
- `rules/vehicles-and-mechs/overview.md`
- `rules/vehicles-and-mechs/converting-to-classic-battletech.md`
- `docs/current/ASSET_SHEET_SCHEMA.md`
- For MekHQ-linked campaigns: `mekhq-bridge.md`, `pending-mekhq-actions.md`, and `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`

## Handoff Packet

### 1. Encounter Identity

- Encounter name:
- Campaign id:
- Session/date context:
- Triggering scene:
- Tactical system route: Classic BattleTech | MegaMek | MekHQ
- Reason for handoff:
- What MEK-RPG must not resolve from memory:

### 2. Stakes And Objectives

- Player objective:
- Opposition objective:
- Contract or mission clause at stake:
- Civilian, cargo, facility, secrecy, extraction, or time pressure:
- Success, partial success, failure, and catastrophic failure outcomes:
- What outcome must be returned to campaign files:

### 3. Battlefield

- Map or terrain concept:
- Deployment zones:
- Starting range and line of sight:
- Weather, visibility, atmosphere, gravity, urban hazards, water, woods, cliffs, buildings, minefields, or other terrain assumptions:
- Forced movement, escape routes, reinforcements, extraction points, or off-board constraints:
- Unknowns that the tactical tool or table must decide:

### 4. Player Forces

For each player-side unit:

- Unit name/slug:
- Asset entry or MekHQ unit id:
- Unit type/model:
- Current location/deployment:
- Pilot/crew/operator:
- Relevant A Time of War skills and subskills:
- Converted tactical pilot/gunnery notes:
- Known damage, heat, ammunition, fuel, cargo, passengers, or repair state:
- Special equipment, quirks, or source/tool lookups:
- Morale, orders, withdrawal limits, or roleplaying constraint:

### 5. Opposing And Neutral Forces

For each opposing or neutral unit:

- Unit name/slug:
- Faction/controller:
- Unit type/model:
- Pilot/crew quality if known:
- Starting location/deployment:
- Objective and aggression level:
- Withdrawal or surrender threshold:
- Hidden information or GM-only motive:
- Unknown stats or tool lookups:

### 6. Deployment And Initiative Assumptions

- Who deploys first:
- Hidden or revealed units:
- Ambush, pursuit, escort, defense, extraction, or meeting engagement framing:
- Initiative method belongs to the tactical system:
- Command, Leadership, Tactics, Sensor Operations, or recon notes from RPG play:
- Any RPG scene advantage that should become setup position, hidden information, or objective pressure rather than a tactical modifier guessed from memory:

### 7. Withdrawal, Salvage, And Aftermath Stakes

- Withdrawal conditions for each side:
- Surrender, ejection, rescue, prisoner, or casualty handling:
- Salvage rights or disputes:
- Destroyed, disabled, captured, or abandoned asset consequences:
- Repair, ammo, fuel, cargo, or medical follow-up:
- Employer, faction, reputation, relationship, or hook consequences:
- MekHQ-linked hard ledger items that must wait for saved import:

## MekHQ-Linked Addendum

Use this addendum when the campaign has `mekhq-bridge.md`.

- Last imported MekHQ save metadata:
- MekHQ campaign date:
- MekHQ contract id:
- MekHQ scenario id:
- MekHQ unit ids:
- Pending action ids created before handoff:
- Hard ledger facts that MekHQ owns:
- RPG overlays that MEK-RPG owns:
- User action needed in MekHQ:
- Save/re-import checkpoint:
- Bridge discrepancies to record:

Do not edit `.cpnx`, `.cpnx.gz`, extracted XML, or raw MekHQ save payloads. If the tactical result changes funds, units, personnel, repairs, cargo, contracts, scenarios, salvage, prisoners, kills, or campaign date, apply or confirm that in MekHQ and re-import before treating it as a final hard ledger fact.

## Return-To-Campaign Checklist

After Classic BattleTech, MegaMek, or MekHQ resolves the encounter, update campaign state before continuing play.

- `session-log.md`: tactical system used, scenario summary, choices, outcome, unresolved tool/source notes, and next prompt.
- `current-state.md`: resume point, location, immediate pressure, surviving party, and whether the campaign day advanced.
- `missions.md`: objective result, contract/scenario status, employer reaction, deadlines, tactical follow-up, and unresolved clauses.
- `assets.md`: unit condition summary, salvage, cargo, prisoners, fuel/ammo/repair pressure, destroyed/captured/lost assets, and MekHQ import references.
- `pcs.md`: injuries, fatigue, XP notes, personal gear losses, pilot/gunnery consequences, and A Time of War overlays.
- `npcs.md`: casualties, prisoners, rescued characters, enemy survivors, morale changes, and last-seen status.
- `factions.md`: reputation, hostility, debt, patron reaction, legal pressure, or battlefield control.
- `relationships.md`: trust, blame, loyalty, favors, grudges, rescue debts, and command friction.
- `hooks.md`: repair scenes, salvage disputes, missing pilots, reprisal threats, bounty interest, rumors, or follow-up missions.
- `pending-mekhq-actions.md`: queued, user-applied, imported, resolved, blocked, or abandoned hard ledger actions.
- `rules-gaps.md` or `playtest-notes.md`: tactical conversion gaps, source lookups, awkward handoff steps, and workflow bugs.

## Quality Check

Before handing off:

- Every player-side tactical unit has an asset entry, MekHQ id, or explicit `Unknown`.
- Every named pilot, commander, gunner, or important crew member has a PC/NPC reference or explicit `Unknown`.
- Objectives and withdrawal conditions are clear enough to avoid a fight-to-the-last-unit default.
- Salvage and repair stakes are known or explicitly marked as MekHQ/source/table lookup.
- The tactical tool owns exact combat resolution.
- The post-encounter campaign files to update are listed.
