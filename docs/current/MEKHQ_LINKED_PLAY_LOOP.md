# MekHQ-Linked Play Loop

Status: issue `#29` design note.

Purpose: define the safe one-day RPG play loop for campaigns that use MekHQ as the hard BattleTech campaign ledger while MEK-RPG runs scenes, remembers RPG continuity, and prepares handoffs.

## Core Boundary

Once a MEK-RPG campaign is linked to a MekHQ campaign, MekHQ owns day advancement and hard ledger changes.

MekHQ is authoritative for:

- campaign date, day advancement, travel, market refreshes, contract deadlines, and repair progress
- funds, purchases, sales, salaries, debt, maintenance, salvage values, and financial warnings
- rosters, assignments, injuries, fatigue, repairs, units, cargo, transport capacity, markets, contracts, scenarios, and tactical battle outcomes

MEK-RPG is authoritative for:

- scenes inside the MekHQ day
- A Time of War overlays, PC sheets, personal goals, XP notes, Edge, traits, and sheet gaps
- conversations, promises, relationships, secrets, hidden motives, rumors, hooks, session logs, table rulings, rules gaps, and safety/tone
- narrative uncertainty around MekHQ objects until the table commits the result as a hard ledger fact

MEK-RPG may propose or queue a ledger change. MekHQ applies the committed hard outcome through the UI or a future source-backed path, then MEK-RPG imports or summarizes the saved MekHQ state. For day advancement, the current supported path is manual MekHQ UI advancement, save, and re-import; headless day advancement is not low-risk because the MekHQ new-day flow reaches GUI state and can trigger prompts or events.

## One-Day Loop

### 1. Pre-Session Import And Checkpoint

Before running a MekHQ-linked scene:

1. Load `campaign-state/active-campaign.md` and exactly one `campaigns/<campaign-id>/` folder.
2. Read `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md` and any campaign-local bridge note if one exists.
3. Confirm the last imported MekHQ save metadata: save path, import timestamp, MekHQ campaign date, location, funds, active contract or scenario, and unsupported fields.
4. Treat the MekHQ campaign date as the current campaign day. If MEK-RPG's `current-state.md` disagrees, record a bridge discrepancy instead of advancing MEK-RPG independently.
5. Check `pending-mekhq-actions.md` for unresolved manual MekHQ application items before framing new ledger-sensitive scenes.
6. Check `current-state.md`, `assets.md`, `missions.md`, `pcs.md`, `npcs.md`, `relationships.md`, `hooks.md`, `session-log.md`, `rules-gaps.md`, and `safety-and-tone.md` for the next scene.
7. Ask only for the missing input needed to start play, such as which MekHQ market offer, contract, repair delay, or character viewpoint is in focus.

The checkpoint should make the ownership visible: "MekHQ date and ledger are current through this saved import; MEK-RPG is about to run scenes inside that day."

### 2. In-Day Scene Handling

During the day, MEK-RPG can run any scene that does not require the MekHQ calendar or ledger to advance:

- conversations with crew, brokers, employers, contacts, patients, rivals, or family
- inspections, interviews, negotiations, rumors, legal checks, social pressure, and hidden-motive discovery
- A Time of War personal-scale action, medical decisions, training choices, planning, and downtime focus scenes
- preparation for a tactical handoff, including objectives, terrain assumptions, force intent, special constraints, and player-facing stakes

Use the normal GM procedure in `gm/session-procedure.md`. When rules matter, route through `indexes/task-router.md` and the relevant summaries. Use `gm/switch-to-classic-battletech.md` when hex-scale movement, armor locations, heat, ammo, salvage, repairs, or exact unit state matter.

Scene results divide into two groups:

- RPG memory updates: save directly in the campaign folder.
- Hard ledger intents: queue for MekHQ application or handoff; do not silently apply them as final ledger facts in MEK-RPG.

### 3. Post-Scene Save

After each meaningful scene, update MEK-RPG-owned memory while it is fresh:

- `session-log.md`: scene summary, choices, rolls, rulings, consequences, queued MekHQ action ids, and the next prompt.
- `npcs.md`: current whereabouts, attitude shifts, secrets revealed or preserved, promises made, favors owed, threats, and last-seen context.
- `relationships.md`: trust, leverage, loyalty, grudges, debts, command tension, crew morale, and personal stakes.
- `hooks.md`: unresolved opportunities, threats, rumors, mystery leads, repair delays, market complications, and future scenes.
- `missions.md`: player-facing objectives, open clauses, employer reactions, tactical handoff triggers, and pending MekHQ contract/scenario actions.
- `pcs.md`: A Time of War condition, personal gear notes, goals, sheet gaps, XP notes, injury overlays, and roleplaying consequences.
- `assets.md`: MekHQ-derived ledger summaries plus clearly labeled pending action ids or narrative overlays.
- `pending-mekhq-actions.md`: proposed, queued, user-applied, imported, resolved, blocked, or abandoned hard ledger intents.
- `rules-gaps.md`: missing A Time of War, conversion, tactical handoff, or MekHQ workflow questions.
- `safety-and-tone.md`: any new boundary, tone preference, or child/co-player handling note.

Do not overwrite MekHQ-owned values with guessed numbers. If a scene produces a likely purchase price, repair result, injury duration, contract payment, or personnel assignment, record it as `Pending MekHQ application` until MekHQ applies it.

### 4. End-Of-Day Save And MekHQ Update

At the end of a MekHQ-linked play day:

1. Review all unresolved items in `pending-mekhq-actions.md`, plus any linked narrative context from `session-log.md`, `assets.md`, `missions.md`, `pcs.md`, and `hooks.md`.
2. Split them into manual MekHQ UI actions, artifact handoffs, future automation candidates, and MEK-RPG-only memory.
3. Ask the user to apply current hard ledger actions in MekHQ when the campaign must advance or the ledger must change.
4. The user saves the MekHQ campaign after applying those actions or advancing the day.
5. MEK-RPG imports or summarizes the saved MekHQ state before treating the hard outcome as final.
6. Update the campaign folder with the imported hard facts, the RPG narrative consequence, unresolved discrepancies, and the next resume point.
7. Append a durable summary to `previous-sessions.md` when the session is complete.

If the user does not apply MekHQ changes yet, leave the day open in MEK-RPG and keep the hard outcomes queued. Do not advance `current-state.md` to the next campaign day unless the next MekHQ import confirms it.

## Common Outcome Handling

### Conversations, Promises, Relationships, And Hidden Motives

Save these as MEK-RPG memory immediately:

- Conversation facts and promises go in `session-log.md`, then the relevant `npcs.md`, `relationships.md`, `missions.md`, or `hooks.md` entry.
- Hidden motives and GM-only uncertainty belong in `npcs.md`, `factions.md`, or `hooks.md` with explicit evidence labels.
- Relationship changes go in `relationships.md` even when both people also exist in MekHQ.
- Session summaries go in `session-log.md` during play and `previous-sessions.md` after close-out.

MekHQ may know that a pilot exists, is injured, or is assigned to a unit. MEK-RPG knows why that pilot trusts the PC, what they promised, what they fear, and what they are hiding.

### Purchases And Sales

MEK-RPG may run the inspection, negotiation, title-risk, broker, or black-market scene. MekHQ owns the final unit or item acquisition, sale, price, transit delay, funds change, cargo change, and market removal.

Short-term workflow:

1. Record the scene result as `Pending MekHQ purchase/sale`.
2. User applies the purchase or sale in MekHQ UI when committing.
3. User saves MekHQ.
4. MEK-RPG imports the resulting funds, asset, transit, cargo, and market state.
5. MEK-RPG records any narrative overlay, such as a suspicious seller, debt pressure, or title dispute.

### Injuries, Medical Care, And Availability

MEK-RPG owns A Time of War personal injury overlays, medical scenes, fears, favors, and recovery choices. MekHQ owns MekHQ personnel injury/fatigue/availability fields once the character or NPC is represented in MekHQ.

If the injury is personal-scale only, save it in `pcs.md` or `npcs.md`. If it affects a MekHQ pilot, doctor, tech, administrator, or crew member ledger status, queue a MekHQ update or wait for MekHQ's tactical/scenario resolution to apply it.

### Contract Decisions

MEK-RPG may run employer meetings, negotiations, clause interpretation, hidden-principal reveals, moral pressure, and reputation scenes. MekHQ owns accepted contracts, contract terms as ledger objects, scenario generation, deadlines, payments, salvage rights, and completion status when a MekHQ contract is used.

Record uncommitted choices as `Pending MekHQ contract decision` entries in `pending-mekhq-actions.md`. Once the user accepts, declines, updates, or resolves the contract in MekHQ, import the result and update `missions.md`, `assets.md`, `factions.md`, `relationships.md`, and `hooks.md`.

### Repairs, Parts, And Personnel Changes

MEK-RPG may frame repair delays as scenes: a parts hunt, favor request, technician dispute, sabotage suspicion, or readiness tradeoff. MekHQ owns repair queues, part consumption, repair completion, technician assignments, salary, hiring, firing, ranks, and availability.

Use MEK-RPG to record why the change matters. Use MekHQ to apply the ledger change.

### Battle Outcomes

When tactical detail matters, switch to Classic BattleTech, MegaMek, or MekHQ. MEK-RPG prepares the narrative and scenario handoff. MekHQ or the tactical tool applies damage, casualties, salvage, prisoners, kill credit, scenario status, repairs, and force history.

After the battle, import or summarize the MekHQ result and then save the RPG consequence: grief, blame, loyalty changes, employer reaction, rumors, hooks, and next scene.

## Writeback Boundary Matrix

| Outcome type | Safe as MEK-RPG-only memory | User applies manually in MekHQ UI | Artifact-based handoff | Future source-backed automation | Out of scope / unsafe direct XML edits |
| --- | --- | --- | --- | --- | --- |
| Conversations, promises, secrets, hidden motives | Yes. Save in `session-log.md`, `npcs.md`, `relationships.md`, `hooks.md`, and `factions.md`. | No MekHQ action unless it becomes hiring, firing, assignment, injury, contract, or finance state. | Optional briefing or GM note only. | Possible future export to a read-only GM packet, not MekHQ ledger. | Directly embedding RPG secrets in MekHQ XML. |
| Relationships, favors, debts, morale, command tension | Yes. `relationships.md` is authoritative for narrative meaning. | Only if it changes MekHQ rank, role, assignment, salary, availability, or employment. | Optional personnel note or after-action report. | Possible source-backed personnel annotation only after MekHQ support is understood. | Editing personnel XML to simulate social state. |
| Session logs and previous-session summaries | Yes. `session-log.md` and `previous-sessions.md` own table history. | No. | Optional end-of-day report for user reference. | Possible generated context packet. | Storing full MEK-RPG session logs in MekHQ saves. |
| A Time of War PC overlays, XP, Edge, traits, personal goals | Yes. `pcs.md` owns RPG sheets and overlays. | Only when the PC is also a MekHQ person and a ledger field changes. | Optional tactical pilot note for MegaMek/MekHQ setup. | Possible conversion helper after source-backed mapping. | Direct XML edits that force MekHQ to carry A Time of War sheet state. |
| Narrative uncertainty around market offers, title, rumors, seller honesty | Yes until committed. Save in `hooks.md`, `assets.md`, and `npcs.md`. | Apply final purchase/sale only after the table commits. | Optional inspection report or purchase checklist. | Possible source-backed market summary reader or UI-assisted checklist. | Editing market XML to fake negotiated outcomes. |
| Purchases, sales, funds, cargo, transit, market removal | Record intent only as `Pending MekHQ purchase/sale`. | Yes. MekHQ UI is the current safe write path. | Possible purchase checklist or MUL-style asset setup where MekHQ supports it. | Later MekHQ command/helper that calls campaign methods and saves through MekHQ. | Direct `.cpnx`, `.cpnx.gz`, or XML edits to funds, markets, cargo, or units. |
| Injuries, fatigue, medical availability | Personal-scale RPG overlays can live in `pcs.md`/`npcs.md`. | Yes for MekHQ personnel injury, fatigue, availability, and medical ledger changes. | Tactical battle result import or after-action report. | Later source-backed scenario or personnel update command. | Direct XML edits to personnel health/availability fields. |
| Contract negotiation, acceptance, failure, payment, salvage rights | Scene facts and promises in `missions.md`, `relationships.md`, `factions.md`, and `hooks.md`; ledger status pending. | Yes for accepting, declining, resolving, or paying MekHQ contracts. | Contract brief, clause checklist, or battle/scenario report. | Later source-backed contract command after MekHQ internals are inspected. | Direct XML edits to contracts, payments, salvage, or scenario status. |
| Repairs, parts, maintenance, technician work, acquisition queues | Narrative pressure and hooks are safe in MEK-RPG. | Yes for repair queues, part use, assignments, and completion. | Repair checklist or logistics report. | Later source-backed repair/logistics helper. | Direct XML edits to parts, units, repair tasks, or queues. |
| Personnel hiring, firing, ranks, assignments, salaries | Interviews, motives, loyalty, and promises are MEK-RPG memory. | Yes for hiring, firing, role, salary, assignment, rank, and availability. | Hiring packet or candidate notes. | Later source-backed personnel command if proven useful. | Direct XML edits to rosters, assignments, or payroll. |
| Tactical battles, damage, salvage, casualties, prisoners, kill credit | Narrative stakes and aftermath memory are safe in MEK-RPG. | Use MekHQ/MegaMek/tabletop workflows for tactical outcomes. | Battle-record MUL or other MekHQ-supported result artifact where available. | Later source-backed battle-result import/export tooling. | Direct XML edits to unit damage, salvage, kills, prisoners, or scenario result. |
| Day advancement, travel, market refreshes, deadlines, daily reports | MEK-RPG may track scene time inside the day only. | Yes. User advances the day in MekHQ UI and saves; issue `#37` validated this manual path only. | End-of-day checklist for actions to perform before advancing. | Not a near-term target. `CampaignNewDayManager#newDay()` reaches GUI state and daily processing can trigger prompts/events, so any future command needs MekHQ source work plus explicit prompt policy before MEK-RPG treats it as safe. | Direct XML edits to campaign date, travel, deadlines, or daily report state. |

## Unsafe Current Behaviors

Do not do these in current MEK-RPG workflows:

- write to MekHQ saves
- edit `.cpnx`, `.cpnx.gz`, or extracted MekHQ XML as a way to apply purchases, contracts, repairs, personnel changes, battles, or day advancement
- run or plan headless MekHQ day advancement as a normal bridge primitive before MekHQ source work separates GUI/prompt dependencies and defines a noninteractive policy
- advance the MEK-RPG campaign date independently after a campaign is linked
- invent exact MekHQ ledger values when the import is missing or unsupported
- commit raw MekHQ save payloads, protected A Time of War source text, purchased PDFs, secrets, or copied rulebook passages

## Follow-On Notes

Issue `#27` should make the read-only MekHQ summary helper useful for this loop by emitting pre-session checkpoint facts and unsupported-field warnings.

Issue `#28` adds a dedicated `mekhq-bridge.md` file for save path, import metadata, ownership reminder, cross-reference tables, unsupported fields, and discrepancy notes.

Issue `#35` adds `pending-mekhq-actions.md` as the campaign-local checklist for proposed, queued, user-applied, imported, resolved, blocked, and abandoned MekHQ application items.
