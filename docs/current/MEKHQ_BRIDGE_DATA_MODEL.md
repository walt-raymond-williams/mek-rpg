# MekHQ Bridge Data Model

Status: issue `#26` design note.

Purpose: define how a read-only MekHQ campaign save summary can seed or refresh MEK-RPG campaign folders without blurring ownership. This document is the field-priority and mapping input for issues `#27`, `#28`, and `#29`.

## Boundary

MekHQ is authoritative for hard logistics, force state, and tactical ledger facts once a MEK-RPG campaign is linked to a MekHQ campaign.

MEK-RPG is authoritative for RPG scenes, A Time of War character overlays, narrative memory, relationships, hooks, safety/tone, and uncertainty that has not become a hard ledger fact.

The first bridge is read-only from MekHQ:

1. User advances days, resolves purchases, accepts contracts, assigns staff, processes repairs, or resolves tactical battles in MekHQ.
2. User saves the MekHQ campaign.
3. MEK-RPG reads or summarizes the saved MekHQ state.
4. MEK-RPG updates campaign-folder summaries and RPG overlays without writing back to the MekHQ save.

Issue `#67` adds `docs/current/MEKHQ_READ_ONLY_CHECKPOINT_EXPORT_CONTRACT.md` as the MEK-RPG-side consumer contract for a future MekHQ-owned checkpoint export. Prefer that source-backed export for method-derived values when it exists; keep the current Python save-summary helper as a fallback/prototype.

## MekHQ-Owned Facts

Treat these as imported hard facts when present in the MekHQ save or summary output:

- Campaign identity: MekHQ campaign name, faction, save path, and save timestamp.
- Calendar: campaign date, day advancement, contract deadlines, travel/downtime progression, market refreshes, and repair progress.
- Location: current MekHQ campaign location, system, route, base, and travel status when exported.
- Finances: funds, income, payroll, debt, maintenance, purchases, sales, fees, salvage values, acquisition costs, and financial warnings.
- Personnel ledger: MekHQ personnel IDs, names, ranks, roles, assignments, injuries, fatigue, deployment history, salaries, and availability.
- Unit ledger: BattleMechs, vehicles, aerospace, battle armor, DropShips, JumpShips, support craft, cargo, unit condition, bay assignment, transport capacity, damage, ammunition, parts, and repair status.
- Contracts and scenarios: active contracts, available contract offers, scenario status, objectives, battlefield control, salvage terms, post-battle reports, casualties, prisoners, kill credit, and completion results.
- Repairs and logistics: parts, technicians, maintenance queues, acquisition queues, cargo pressure, transport constraints, unavailable personnel, and daily report alerts.
- Markets: unit market offers, personnel market applicants, contract market offers, prices, transit delays, market type, and generated availability.

MEK-RPG can paraphrase these for play, but should not contradict them. If a hard fact seems wrong, record a bridge discrepancy and inspect MekHQ rather than overriding the value in MEK-RPG.

## MEK-RPG-Owned Facts

Keep these in MEK-RPG campaign files even when a person, unit, or contract has a MekHQ counterpart:

- A Time of War PC sheets, attributes, traits, Edge, XP, lifepath details, personal gear notes, goals, sheet gaps, and roleplaying consequences.
- NPC motives, secrets, promises, fears, loyalties, private knowledge, attitudes toward PCs, and last-seen scene context.
- Relationships, favors, debts, grudges, leverage, family ties, command friction, and crew morale as narrative facts.
- Scene framing, current player choices, rumors, legal ambiguity, title risk, moral pressure, hidden employers, and unresolved mysteries.
- Session logs, previous-session summaries, table rulings, GM notes, playtest observations, and rules gaps.
- Safety/tone boundaries, child/co-player guidance, violence detail limits, and user preferences.
- Narrative uncertainty around a MekHQ object until the table commits it as a hard fact. Example: MekHQ may know a DropShip listing and price; MEK-RPG may still track rumors about title quality or seller honesty.

## Campaign Folder Mapping

Issue `#27` should prioritize helper output that can populate or refresh these sections. Generated text should be clearly labeled as MekHQ-derived and should preserve source save metadata.

| MekHQ fact | Campaign file | Mapping guidance |
| --- | --- | --- |
| Campaign name, faction, linked save path, bridge status | `overview.md`; generated `mekhq-bridge.md` for MekHQ-linked bootstrap saves | Record the link, ownership boundary, and last imported save metadata. Keep the public table frame in `overview.md`; keep bridge technical details in `mekhq-bridge.md`. |
| Campaign date | `current-state.md` | Once linked, MekHQ date is authoritative for campaign date. MEK-RPG may track scene time inside the day, but day changes come from MekHQ. |
| Current location, travel state, base | `current-state.md`, `locations.md` | Put the current resume location in `current-state.md`. Put stable system/base/location details and open narrative details in `locations.md`. |
| Funds, debt, payroll, purchase/sale values, warnings | `assets.md` | Record as MekHQ-derived ledger summary. Do not manually recalculate unless MekHQ output is unavailable and the value is clearly marked provisional. |
| Personnel roster, roles, assignments, injuries, fatigue | `pcs.md`, `npcs.md`, `assets.md` | PCs with A Time of War overlays stay in `pcs.md`; important non-PC personnel with narrative memory go in `npcs.md`; large roster summaries and role counts can live in `assets.md`. Preserve MekHQ IDs for linked people and follow `docs/current/MEKHQ_PERSONNEL_SHEET_WORKFLOW.md` for expanded linked-person entries. |
| Units, DropShips, vehicles, BattleMechs, cargo, transport capacity | `assets.md` | Record owner/controller, current location, condition, crew/operators, repair state, legal status if known, and tactical handoff notes. MekHQ owns exact technical condition. |
| Active contracts | `missions.md`, `assets.md`, `factions.md` | Mission objective and play-facing stakes go in `missions.md`; payment/salvage/debt terms go in `assets.md`; employer/faction posture goes in `factions.md`. Exact contract ledger remains MekHQ-owned. |
| Available contracts | `hooks.md`, `missions.md` | Record as opportunities or future missions, not accepted facts, until committed in MekHQ. |
| Scenarios and tactical outcomes | `missions.md`, `session-log.md`, `assets.md` | Use `missions.md` for scenario status and objectives, `session-log.md` for the narrative after-action summary, and `assets.md` for damage, salvage, casualties, and repair consequences imported from MekHQ. |
| Repairs, parts, maintenance, acquisition queues | `assets.md`, `hooks.md` | Put exact queues and blockers in `assets.md`; turn shortages, delays, and favors into hooks when useful. |
| Logistics alerts | `current-state.md`, `assets.md`, `hooks.md` | Immediate pressure belongs in `current-state.md`; ledger detail belongs in `assets.md`; optional scenes belong in `hooks.md`. |
| Unit, personnel, and contract markets | `hooks.md`, `assets.md`, `missions.md`, `npcs.md` | Treat offers as MekHQ-owned availability. Use MEK-RPG overlays for brokers, interviews, inspection scenes, title uncertainty, rumors, and negotiation color. |

## Overlay Mapping

Use overlays when a MekHQ object needs RPG continuity beyond the hard ledger.

- PCs: `pcs.md` owns A Time of War sheet details, Edge, XP, traits, personal goals, scene condition, and relationship notes. Store `mekhq_person_id` and linked assignment when the PC also exists in MekHQ.
- NPC memory: `npcs.md` owns motives, secrets, promises, last-seen context, and attitude. Store `mekhq_person_id` when the NPC is a MekHQ person; use a MEK-RPG slug for purely narrative NPCs.
- Relationships: `relationships.md` owns trust, grudges, leverage, favors, command tension, and loyalty. Link to MekHQ IDs only when relationship entries reference MekHQ personnel or units.
- Hooks: `hooks.md` owns unresolved opportunities and threats generated from hard facts, such as a repair delay becoming a parts hunt or a market offer becoming an inspection scene.
- Missions: `missions.md` owns player-facing objectives, stakes, scene state, and tactical handoff triggers. Link to MekHQ contract/scenario IDs when available.
- Session logs: `session-log.md` and `previous-sessions.md` own what happened at the table and which MekHQ save was imported before or after the session.
- Rules gaps: `rules-gaps.md` owns missing A Time of War procedures, conversion uncertainty, and unresolved BattleTech handoff questions. Do not hide rules gaps inside generated MekHQ summaries.
- Safety/tone: `safety-and-tone.md` remains MEK-RPG-only and should never be generated from MekHQ data.

## ID Preservation And Slugs

Preserve MekHQ IDs exactly as read. Do not normalize, shorten, or regenerate them. If an ID is absent, record `Unknown` and rely on a stable MEK-RPG slug until issue `#27` proves whether the field exists.

Recommended cross-reference fields in generated or manually maintained bridge sections:

```yaml
mekhq_campaign_id: Unknown
mekhq_save_path: Unknown
mekhq_last_imported: Unknown
mekhq_person_id: Unknown
mekhq_unit_id: Unknown
mekhq_contract_id: Unknown
mekhq_scenario_id: Unknown
mek_rpg_slug: example-slug
display_name: Example Name
```

Slug strategy:

- Use lowercase ASCII slugs with hyphens: `mara-voss`, `atlas-as7-d-01`, `contract-sian-escort`.
- Keep slugs stable once referenced by session logs or relationships.
- Prefer human-meaningful slugs for MEK-RPG-only objects.
- For MekHQ-linked objects, include a readable name plus a short disambiguator if needed, but keep the full MekHQ ID in metadata.
- If display names change in MekHQ, keep the MEK-RPG slug stable and update `display_name`.

## Unknown And Unsupported Fields

Use explicit evidence labels and avoid silent inference:

- `Confirmed from MekHQ import`: value came from the last read-only MekHQ summary.
- `Confirmed by user`: value was supplied by the user or decided at the table.
- `Inferred`: reasonable bridge interpretation that needs later confirmation.
- `Unknown`: field is expected but not present, not inspected, or not yet supported.
- `Unsupported`: field is known to be outside the current helper or mapping.
- `Needs MekHQ inspection`: issue `#27` or later must inspect save/XML/source behavior before the mapping is trusted.

Handling rules:

- Missing hard ledger fields do not become MEK-RPG facts. Mark them `Unknown` or `Unsupported`.
- Do not invent exact prices, repair durations, market availability, contract terms, payroll, or unit condition when MekHQ is linked.
- If MEK-RPG adds narrative uncertainty to a hard object, label it as narrative overlay rather than ledger truth.
- If a later MekHQ import contradicts a MEK-RPG summary, MekHQ wins for hard logistics and tactical state; MEK-RPG retains narrative memories unless the table retcons them.

## Read-Only Import Shape

The first helper may emit JSON, Markdown, or both. The data model should be source-neutral:

- `bridge_metadata`: save path, save timestamp, import timestamp, helper version, warnings.
- `campaign`: name, date, faction, current location, funds, high-level status.
- `personnel`: MekHQ ID, display name, role, rank, assignment, availability, injury/fatigue flags, linked MEK-RPG slug if known.
- `units`: MekHQ ID, display name, type, status, location, assignment, crew, damage/repair summary, transport/cargo notes.
- `contracts`: MekHQ ID, name, employer, status, deadline, terms summary, linked mission slug if known.
- `scenarios`: MekHQ ID, contract ID if available, name, status, date, objective/status summary.
- `repairs_and_logistics`: alerts, queues, shortages, unavailable staff, transport constraints, daily-report highlights.
- `markets`: unit offers, personnel offers, contract offers, prices or terms when exported, transit delays, expiration or refresh uncertainty.
- `unsupported`: fields the helper could not map cleanly.

Markdown generated into campaign files should quote no raw MekHQ XML and should not include large copied source text. Use summaries and IDs.

For future checkpoint exporter work, preserve this broad shape but add producer/schema metadata, method-backed provenance, object-scoped warnings, and classified reports as described in `docs/current/MEKHQ_READ_ONLY_CHECKPOINT_EXPORT_CONTRACT.md`.

## Non-Goals

These are explicitly out of scope for issue `#26` and the first read-only bridge:

- Writing to `.cpnx`, `.cpnx.gz`, or MekHQ XML saves.
- Direct XML edits for purchases, hiring, contracts, repairs, day advancement, personnel assignment, or scenario resolution.
- Headless MekHQ day advancement.
- Automatic MekHQ purchases, contract acceptance, repair changes, market refreshes, or personnel changes.
- Replacing MekHQ's force, finance, repair, salvage, scenario, or market logic with MEK-RPG Markdown.
- Replacing MEK-RPG's A Time of War character sheets, scene memory, hooks, relationships, session logs, or safety/tone notes with MekHQ fields.
- Parsing real MekHQ saves as part of this design note beyond tiny examples required by issue `#27`.
- Committing protected PDFs, extracted A Time of War source text, copied rulebook passages, secrets, or raw copyrighted source material.

## Follow-On Decisions

Issue `#27` should inspect representative disposable saves and confirm exact available fields for the initial read-only helper. The first field priority is:

1. Bridge metadata, campaign date/location, and funds.
2. Personnel and unit IDs with display names and statuses.
3. Active contracts, scenarios, repairs, logistics alerts, and markets.
4. Unsupported field reporting.

Issue `#28` chose a dedicated generated `campaigns/<campaign-id>/mekhq-bridge.md` file. Use it for save paths, import timestamps, helper warnings, cross-reference tables, unsupported-field reports, and bridge discrepancies. Issue `#35` adds `campaigns/<campaign-id>/pending-mekhq-actions.md` as the owner for manual MekHQ application items. Keep table-facing campaign premise, scene state, and RPG memory in the normal campaign files.

Issue `#29` should define the play loop around the read-only boundary: MEK-RPG can run scenes inside a MekHQ day, but hard ledger changes are applied in MekHQ first and imported afterward.

Issue `#65` adds `docs/current/MEKHQ_PERSONNEL_SHEET_WORKFLOW.md` for expanded MekHQ-linked PC/NPC entries, import refresh behavior, and discrepancy handling. Use that workflow before attempting a personnel refresh or merge helper.
