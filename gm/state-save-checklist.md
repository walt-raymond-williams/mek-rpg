# State Save Checklist

Use this after meaningful play in the active campaign folder from `campaign-state/active-campaign.md`.

## Required Save Steps

1. Update `current-state.md` with the exact resume point, current location, current date or in-day time, immediate pressure, current party, and next prompt.
2. Update `session-log.md` with active or most recent session notes: concise summary, important choices, rolls, rulings, consequences, rewards, costs, queued pending item ids, and next-session prompts.
3. When a session is complete, append a durable dated summary to `previous-sessions.md` before `session-log.md` is reused for the next session.
4. Update `pcs.md` for injuries, fatigue, gear, money, goals, sheet gaps, or player-specific notes.
5. Update `npcs.md` for new NPCs, current whereabouts, attitude changes, promises, secrets, and last-seen status.
6. Update `factions.md` for reputation, obligations, hostility, favors, assets, or new faction pressure.
7. Update `locations.md` for places introduced, current access, hazards, and important contents.
8. Update `assets.md` for money, vehicles, DropShips, equipment, cargo, contracts, permits, debts, liens, repairs, evidence labels, MekHQ references, and tactical handoff notes.
9. Update `relationships.md` for trust, leverage, grudges, loyalty, favors, promises, or family/crew ties.
10. Update `missions.md` and `hooks.md` for resolved objectives, active threats, opportunities, deadlines, and tactical handoff triggers.
11. For MekHQ-linked campaigns, update `pending-mekhq-actions.md` for any hard ledger intent that needs manual MekHQ application and later import confirmation.
12. Update `rules-gaps.md` or `playtest-notes.md` for missing rules, provisional rulings, awkward save steps, or workflow bugs.
13. Update `safety-and-tone.md` when a child/co-player preference, tone boundary, or agency constraint matters for future play.

## Semantic Checkpoint Triggers

Save one or more campaign files when any of these meaning changes occur:

- a scene changes location, active participants, immediate pressure, or the next prompt
- a mission is accepted, advanced, paused, failed, completed, or reframed
- a combat, risky scene, or tactical handoff returns consequences
- an NPC relationship, promise, secret, debt, favor, loyalty, or faction posture changes
- injury, recovery, inventory, money, asset, contract, repair, permit, cargo, or readiness state changes
- a rule gap, provisional ruling, workflow bug, or safety/tone boundary becomes relevant
- a MekHQ-linked campaign reaches a day boundary, unresolved pending action review, or saved import reconciliation

Use `docs/current/CAMPAIGN_MEMORY_STRATEGY.md` for the full ownership policy. Structured owner files outrank old narrative summaries when facts conflict.

## Corrections And Superseded Facts

- Put the corrected fact in the highest-authority owner file first.
- Mark old archive text as `Corrected`, `Superseded`, `Retconned`, or `Needs review` when keeping it would otherwise mislead a future GM.
- Do not treat a pending MekHQ action as a confirmed hard ledger fact until a saved MekHQ import confirms it.
- Preserve RPG-side scene memory when a later hard ledger result differs, unless the table explicitly retcons the scene.

## Consequence Routes

- XP, training, salary, bonuses, rank, and advancement: read `rules/campaign/advancement.md`; update `pcs.md`, `session-log.md`, and `assets.md` when money changes.
- Contract terms, payment, salvage expectations, breach, and employer aftermath: read `rules/campaign/contracts.md`; update `missions.md`, `assets.md`, `factions.md`, `relationships.md`, and `hooks.md`.
- Contacts, favors, patrons, and borrowed resources: read `rules/campaign/contacts.md`; update `npcs.md`, `relationships.md`, `factions.md`, and `hooks.md`.
- Reputation, public standing, faction opinion, scandals, rank/title reactions, and trust changes: read `rules/campaign/reputation.md`; update `factions.md`, `relationships.md`, `missions.md`, and `hooks.md`.
- Injury recovery, medical care, surgery, lasting wounds, and mission availability: read `rules/campaign/injuries-recovery.md`; update `pcs.md`, `assets.md`, `missions.md`, and `current-state.md`.
- Downtime, repair/acquisition prep, training time, travel, and mission readiness: read `rules/campaign/downtime-and-readiness.md`; update `current-state.md`, `pcs.md`, `assets.md`, `missions.md`, and `hooks.md`.
- Transport acquisition, DropShip/large-asset control, title questions, liens, permits, inspection defects, remote locks, fuel/readiness, and crew access: read `rules/campaign/transport-and-large-assets.md`; update `assets.md`, `missions.md`, `factions.md`, `relationships.md`, and `hooks.md`.
- Vehicles, BattleMechs, battle armor, aerospace assets, pilot/gunnery notes, crew roles, fuel, damage, and tactical handoff assumptions: read `rules/vehicles-and-mechs/overview.md`, `gm/switch-to-classic-battletech.md`, and `gm/tactical-encounter-handoff-checklist.md`; update `assets.md`, `pcs.md`, `missions.md`, and `hooks.md`.
- MekHQ-linked purchases, contracts, repairs, personnel changes, tactical outcomes, funds, and day advancement: update `pending-mekhq-actions.md` first; update hard ledger summaries only after a saved MekHQ import confirms them.

## Close-Out Questions

Ask only what is needed to save cleanly:

- Did any fact become table canon, or is this playtest-only?
- Where should play resume next time?
- Which NPCs, assets, or hooks changed?
- Did any rule or workflow gap slow play down?

## Git Note

For normal play mode, the save is complete once the active campaign files are updated. Git commits are a project-development close-out step, not the only way campaign memory persists.
