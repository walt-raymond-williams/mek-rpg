# Pending MekHQ Actions

Use this file for MekHQ-linked campaigns when RPG play creates a possible hard ledger change. For supported MekHQ command endpoints, record the command proposal, dry-run, execution, and verification here. For unsupported or unavailable endpoints, record the manual MekHQ fallback checklist here.

For non-MekHQ-linked campaigns, leave this file empty except for notes that the campaign is not linked.

## Workflow

- MekHQ owns campaign date, day advancement, funds, rosters, unit condition, repairs, contracts, markets, scenarios, tactical outcomes, and hard logistics.
- MEK-RPG owns scenes, conversations, relationships, promises, secrets, hooks, A Time of War overlays, session logs, and safety/tone.
- A pending item is not a hard ledger fact until MekHQ applies it through a supported command or manual UI action and MEK-RPG verifies the result by live reread or saved import.
- See `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`.

## Open Items

### mekhq-pending-2026-07-02-001: Complete BattleMech Recovery Vehicle expansion

- Status: queued
- Type: purchase-sale
- Priority: deferred
- Created: 2026-07-02
- Updated: 2026-07-04
- Source scene: Sharpe reviewed salvage logistics after Butzfleth salvage profits
- Source files: `session-log.md`, `assets.md`, `current-state.md`, `pending-mekhq-actions.md`
- MekHQ target ids: campaign `7fbbb5da-0bcd-46f1-8f61-846848c2f148`; person `Unknown`; unit `BattleMech Recovery Vehicle #5`; contract `3`; scenario `Unknown`
- Current imported baseline: MekHQ date `3027-11-22`; roster has 7 BattleMech Recovery Vehicles and 4 Flatbed Trucks. `BattleMech Recovery Vehicle #5` is in transit for 9 days; `BattleMech Recovery Vehicle #6` and `BattleMech Recovery Vehicle #7` are in transit for 40 days.
- Proposed MekHQ action: Acquire 1 more BattleMech Recovery Vehicle when MekHQ markets/procurement allow, targeting 8 recovery vehicles total. Per user direction, do not pursue additional Flatbed Trucks.
- Manual application checklist:
  - Open the linked MekHQ campaign save named in `mekhq-bridge.md`.
  - Confirm the current MekHQ date/save matches the latest imported baseline.
  - Buy or otherwise acquire 1 more BattleMech Recovery Vehicle through MekHQ markets/procurement.
  - Confirm enough vehicle crew staffing before relying on the expanded fleet.
  - Save the MekHQ campaign.
- Command application checklist:
  - Confirm the live MekHQ API campaign id/date/state revision matches the pending baseline.
  - Run dry-run/preflight if a future purchase command supports it.
  - Confirm target ids/selectors and guard fields.
  - Get user approval for campaign-significant purchases unless an explicit automation policy exists.
  - Execute the MekHQ-owned command.
  - Re-read live MekHQ state and verify expected fields.
- Confirmation needed from next import: live roster should contain 8 BattleMech Recovery Vehicles, with the new vehicle present or clearly in transit, and finance transactions should reflect any purchase. No additional Flatbed Trucks are expected.
- Affected campaign files after import: `assets.md`, `current-state.md`, `session-log.md`, `pending-mekhq-actions.md`
- Blockers or discrepancy notes: Market availability, crew staffing, and upkeep impact remain unknown until MekHQ procurement is applied and reread. Earlier flatbed expansion target was canceled by user direction on 2026-07-03.
- Resolution notes: TBD

## Resolved Or Abandoned Items

### mekhq-pending-2026-07-01-001: Return or abandon `Mule (2737)`

- Status: resolved
- Type: purchase-sale
- Priority: before-next-scene
- Created: 2026-07-01
- Updated: 2026-07-01
- Source scene: Sharpe decided the Mule maintenance costs were too high and the company would give the ship back or leave it mothballed.
- Source files: `session-log.md`, `assets.md`, `current-state.md`, `pending-mekhq-actions.md`
- MekHQ target ids: campaign `7fbbb5da-0bcd-46f1-8f61-846848c2f148`; person `Unknown`; unit `Mule (2737)`; contract `2`; scenario `Unknown`
- Current imported baseline: live API on 3027-03-13 showed `Mule (2737)`, Dropship, 11,200 tons, present, Mothballed, unavailable, unserviceable, not deployable, no pilot or gunner assigned.
- Proposed MekHQ action: Remove, transfer, sell, surrender, or otherwise resolve `Mule (2737)` in MekHQ so it is no longer a Sharpe's Strikers upkeep liability.
- Manual application checklist:
  - Open the linked MekHQ campaign save named in `mekhq-bridge.md`.
  - Confirm the current MekHQ date/save matches the latest imported baseline.
  - Remove, transfer, sell, surrender, or otherwise resolve `Mule (2737)` through MekHQ.
  - Remove the associated Mule-only crew if they are no longer retained by the unit.
  - Save the MekHQ campaign.
- Command application checklist:
  - Historical item resolved by user/manual MekHQ action; no command was executed.
  - Future vessel disposal should check `GET /campaign/commands`, guard the campaign/date/unit, get approval, execute through MekHQ-owned code if supported, and verify by live reread.
- Confirmation needed from next import: `Mule (2737)` should not appear in the unit roster, no Mule should appear as mothballed, and the Mule-only crew should no longer appear in personnel if they were released.
- Affected campaign files after import: `assets.md`, `current-state.md`, `session-log.md`, `pending-mekhq-actions.md`
- Blockers or discrepancy notes: None.
- Resolution notes: MekHQ acquisition report confirmed `Mule (2737) has been removed from the unit roster.` No Mule appears in the current unit list, and no mothballed units are exposed. Personnel reports confirmed Daniel Mcclung, Alois Manzei, Aiko Higashi, Gerardo Hernandez, Alyson Abley Storer, Allan Minhas, Mende Munoz, Captain Mi-Kum Pak, Linda Cantrell, and Farzana Khawaja were removed from the personnel roster.
