# Campaign Saves

Each folder under `campaigns/` is a campaign or playtest save. Treat it like a tabletop GM binder: load one save before play, update it after meaningful state changes, and keep unrelated campaigns separate.

Use `campaigns/_template/` when creating a new campaign, or run:

```powershell
./scripts/new-campaign-save.ps1 my-campaign
```

The helper creates the folder only when it does not already exist and does not change `campaign-state/active-campaign.md`.

## Folder Rules

- One campaign or playtest per folder.
- Keep playtest-only saves clearly labeled.
- Record uncertainty with `Confirmed by user`, `Inferred`, `Unknown`, `Needs lookup`, or `Needs user confirmation`.
- Do not store raw rulebook text, purchased source material, secrets, or copied tables.
- Use Git for project versioning, not as the only campaign-memory mechanism.

## Standard Files

- `overview.md`: campaign premise, status, canon policy, and table-level assumptions.
- `current-state.md`: where play resumes, current date, active scene, and immediate next prompt.
- `pcs.md`: player characters, conditions, gear, goals, and sheet gaps.
- `npcs.md`: named NPCs, locations, affiliations, attitudes, goals, secrets, and status.
- `factions.md`: organizations, agendas, posture, assets, and important NPCs.
- `locations.md`: places introduced during play and what matters there.
- `assets.md`: money, ships, vehicles, contracts, permits, repairs, debts, and cargo.
- `relationships.md`: trust, leverage, promises, grudges, loyalty, and obligations.
- `missions.md`: active, paused, and completed missions.
- `hooks.md`: unresolved questions, threats, opportunities, and next-session prompts.
- `pending-mekhq-actions.md`: campaign-local queue for MekHQ-linked hard ledger intents that must be applied manually in MekHQ and confirmed by a later import.
- `session-log.md`: active or most recent session notes and close-out summary.
- `previous-sessions.md`: completed-session archive used to preserve durable outcomes after `session-log.md` rolls forward.
- `rules-gaps.md`: missing or uncertain rules found during this campaign.
- `playtest-notes.md`: workflow bugs, procedure gaps, and test observations.
- `safety-and-tone.md`: player preferences, child/co-player guidance, and table boundaries.

## Campaign Consequences

Use `rules/campaign/overview.md` as the rules route for persistent consequences after play. As a default ownership rule, put character-facing consequences in `pcs.md`, contract and money consequences in `assets.md` and `missions.md`, faction consequences in `factions.md`, personal favors and grudges in `relationships.md`, and future pressure in `hooks.md`.

Use `docs/current/CAMPAIGN_MEMORY_STRATEGY.md` and `gm/state-save-checklist.md` for the full memory-strata and semantic-checkpoint policy. Update campaign files when a meaningful event changes future play, not on a fixed turn count. Structured state files outrank old narrative summaries; keep old summaries only when they are clearly archived, corrected, or still useful context.

## Vehicle And Unit Assets

Vehicle, BattleMech, battle armor, aerospace, DropShip, property, cargo, contract-right, and transport assets stay in campaign-local `assets.md` until live play proves that dedicated sheets are needed. Use `docs/current/ASSET_SHEET_SCHEMA.md`, `rules/campaign/transport-and-large-assets.md`, and `rules/vehicles-and-mechs/overview.md` to decide what to record: stable slug, category, status, evidence labels, owner/controller, ownership evidence, location, condition, crew or operators, fuel or maintenance constraints, legal status, debt or liens, MekHQ references, tactical handoff notes, and open source/tool lookups.

Keep confirmed hard facts separate from RPG narrative memory. In MekHQ-linked campaigns, exact unit condition, funds, cargo, markets, repairs, rosters, contracts, and tactical outcomes remain MekHQ-owned until imported from a saved MekHQ campaign.

## MekHQ-Linked Pending Actions

For MekHQ-linked campaigns, record proposed purchases, sales, contract decisions, repairs, personnel changes, tactical outcomes, day advancement, and other hard ledger intents in `pending-mekhq-actions.md`. These items are not final facts until the user applies them in MekHQ, saves the MekHQ campaign, and MEK-RPG imports the saved result. Keep narrative causes and consequences in the normal campaign files and cross-reference the pending item id.
