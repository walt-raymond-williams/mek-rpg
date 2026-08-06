# Pending MekHQ Actions

Use this file for hard ledger intents created during MekHQ-linked RPG play. For supported MekHQ command endpoints, record the command proposal, dry-run, execution, and verification here. For unsupported or unavailable endpoints, record the manual MekHQ fallback checklist here.

A pending item is not final until MekHQ applies it through a supported command or manual UI action and MEK-RPG verifies the result by live reread or saved import.

See `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md` for the full schema and lifecycle.

## Open Items

### mekhq-pending-3037-03-20-001: Capellan repair-yard intervention for strategic transport

- Status: open
- Type: repair-logistics
- Priority: before-next-strategic-movement
- Created: 3037-03-20
- Updated: 3037-03-20
- Source scene: Planned meeting with Capellan liaison Sang-wei Qiao Ren on Raphael, asking House Liao for help with JumpShip/DropShip repairs because the Strikers' crews cannot absorb the work while maintaining garrison and subcontract tempo.
- Source files: `current-state.md`, `assets.md`, `session-log.md`
- MekHQ target ids: campaign `7fbbb5da-0bcd-46f1-8f61-846848c2f148`; units `cd5623da-4836-4157-a428-171c0167b3c7` (`Mule (2737)`), `7ea4c641-c0ab-4d00-b958-e4eadd8d9b5e` (`Merchant JumpShip (2602)` / narrative `Vermilion Gate`), `4e8c33e0-767d-4e8f-a5dd-231c688a7bdc` (`Monarch (2759) #2`).
- Current imported baseline: 3037-03-20 live API snapshot confirms `Mule (2737)` is crippled with one service item; `Merchant JumpShip (2602)` is lightly damaged, under repair, and has five service items; `Monarch (2759) #2` is crippled with two missing parts and four service items.
- Proposed MekHQ action: after the roleplay scene establishes Capellan depot or repair-yard support, use manual MekHQ action or GM mode to clear the affected strategic-transport repair burden that the table agrees is covered by House Liao intervention.
- Manual application checklist:
  - Complete or confirm the Qiao Ren repair-support scene.
  - In MekHQ, apply the repair outcome through GM mode or manual UI as the table-approved Capellan yard intervention.
  - Save or otherwise make the MekHQ state visible to the local API.
  - Rerun `./scripts/fetch-mekhq-live-api.ps1 -OutputDirectory .\mekhq-live-api-capture`.
  - Run `python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view repair-pressure --format json`.
- Command application checklist:
  - No supported repair execution, repair assignment, procurement execution, stable acquisition selector, or stable repair work id is exposed by the current live API.
  - Do not treat MEK-RPG notes as a hard repair ledger until MekHQ is manually updated and reread.
- Confirmation needed from next import: live API repair-pressure view should show the agreed JumpShip/DropShip repair items cleared or reduced, and affected units should no longer show the same damage/service pressure.
- Affected campaign files after import: `assets.md`, `current-state.md`, `session-log.md`, `pending-mekhq-actions.md`
- Blockers or discrepancy notes: Current API is read-only for repairs/procurement, so this remains a manual/GM-mode fallback by design.

## Resolved Or Abandoned Items

### mekhq-pending-3035-04-02-001: Accept Raphael Pirate Hunting retainer contract

- Status: abandoned
- Type: contract
- Priority: superseded
- Created: 3035-04-02
- Updated: 3035-11-20
- Source scene: Capella retainer hearing after Altorra completion.
- Source files: `session-log.md`, `transport-retainer-roadmap.md`
- MekHQ target ids: campaign `7fbbb5da-0bcd-46f1-8f61-846848c2f148`; contract offer `162`; contract display name `3035 - CC - Raphael Pirate Hunting`.
- Resolution notes: Superseded by user-confirmed urgent Capellan assignment to `3035 - CC - Armaxa Planetary Assault`. The 3035-11-20 live API snapshot confirms Armaxa Planetary Assault as the active accepted contract.

### mekhq-pending-3035-11-20-001: Accept Armaxa Planetary Assault retainer contract

- Status: resolved
- Type: contract
- Priority: completed
- Created: 3035-11-20
- Updated: 3035-11-20
- Source scene: Urgent message to Sang-wei Qiao Ren redirecting the Strikers from Raphael/Capricorn planning to an immediate planetary assault assignment.
- Source files: `current-state.md`, `missions.md`, `session-log.md`, `transport-retainer-roadmap.md`
- MekHQ target ids: campaign `7fbbb5da-0bcd-46f1-8f61-846848c2f148`; contract id `16`; contract display name `3035 - CC - Armaxa Planetary Assault`.
- Current imported baseline: 3035-11-20 live API snapshot confirms `3035 - CC - Armaxa Planetary Assault` is active, with active_on_campaign_date true.
- Proposed MekHQ action: Accept Armaxa Planetary Assault as the urgent Capellan assignment.
- Resolution notes: Already applied in MekHQ by user and verified by live API capture at `2026-07-28T19:20:23Z`.

### mekhq-pending-3036-08-25-001: Accept Raphael Garrison Duty

- Status: resolved
- Type: contract
- Priority: completed
- Created: 3036-08-25
- Updated: 3037-02-17
- Source scene: Raphael retainer/garrison follow-through after the Armaxa proof operation.
- Source files: `current-state.md`, `missions.md`, `session-log.md`, `transport-retainer-roadmap.md`
- MekHQ target ids: campaign `7fbbb5da-0bcd-46f1-8f61-846848c2f148`; contract id `17`; contract display name `3036 - CC - Raphael Garrison Duty`.
- Current imported baseline: 3037-02-17 live API snapshot confirms `3036 - CC - Raphael Garrison Duty` is active, with active_on_campaign_date true.
- Proposed MekHQ action: Accept Raphael Garrison Duty as the long same-planet Capellan baseline contract.
- Resolution notes: Already applied in MekHQ by user and verified by live API capture at `2026-07-30T05:22:01Z`.

### mekhq-pending-3037-02-09-001: Accept Raphael Subcontract Objective Raid

- Status: resolved
- Type: contract
- Priority: completed
- Created: 3037-02-09
- Updated: 3037-02-17
- Source scene: Same-planet Capellan subcontract layered onto the active Raphael garrison duty.
- Source files: `current-state.md`, `missions.md`, `session-log.md`, `transport-retainer-roadmap.md`
- MekHQ target ids: campaign `7fbbb5da-0bcd-46f1-8f61-846848c2f148`; contract id `18`; contract display name `3037 - Capellan Confederation - Raphael Subcontract Objective Raid`.
- Current imported baseline: 3037-02-17 live API snapshot confirms `3037 - Capellan Confederation - Raphael Subcontract Objective Raid` is active, with active_on_campaign_date true.
- Proposed MekHQ action: Accept the Raphael subcontract objective raid while preserving the long Raphael garrison obligation as a separate active contract.
- Resolution notes: Already applied in MekHQ by user and verified by live API capture at `2026-07-30T05:22:01Z`.

### mekhq-pending-3032-12-04-001: Unmothball retained ground vehicles

- Status: resolved
- Type: repair-logistics
- Priority: before-next-scene
- Created: 3032-12-04
- Updated: 3033-10-08
- Source scene: Staff meeting personnel-cut review after Jade Passage setup.
- Source files: `session-log.md`, `assets.md`
- MekHQ target ids: campaign `7fbbb5da-0bcd-46f1-8f61-846848c2f148`; person `Unknown`; unit `e0187a2c-6bfd-4f72-aa31-814232e2d81a`, `1b60147c-14ed-4a51-bb26-d89a06eeb61e`, `e979cd74-bfb9-460d-8fa5-083b24594e28`, `cbca7e39-2974-4afb-aade-2a7f91ed82e6`, `5835d1f1-6a7a-494e-9ef7-fab47aae232e`, `4da80ed1-daeb-49d5-8769-9c4231ede34e`; contract `Unknown`; scenario `Unknown`
- Current imported baseline: 3033-10-08 live API snapshot shows retained ground vehicles available, deployable, undamaged, and not mothballed.
- Proposed MekHQ action: Unmothball all retained ground vehicles so the live API can expose which vehicle crew are actually needed before Sharpe's Strikers cuts active ground vehicle personnel.
- Manual application checklist:
  - Open the linked MekHQ campaign save named in `mekhq-bridge.md`.
  - Confirm the current MekHQ date/save matches the latest imported baseline.
  - Unmothball the ground vehicles the Strikers intend to retain.
  - Save or otherwise make the MekHQ state visible to the local API.
  - Rerun `./scripts/fetch-mekhq-live-api.ps1 -OutputDirectory .\mekhq-live-api-capture`.
- Command application checklist:
  - Confirm the live MekHQ API campaign id/date/state revision matches the pending baseline.
  - Run dry-run/preflight if a future unmothball command supports it.
  - Confirm target ids/selectors and guard fields.
  - Get user approval for campaign-significant changes unless an explicit automation policy exists.
  - Execute the MekHQ-owned command if supported.
  - Re-read live MekHQ state and verify expected fields.
- Confirmation needed from next import: Live API reread confirms updated vehicle availability/deployability and crew assignments or crew-slot needs.
- Affected campaign files after import: `assets.md`, `session-log.md`, `pending-mekhq-actions.md`
- Blockers or discrepancy notes: None.
- Resolution notes: Resolved by 3033-10-08 live API verification. Retained support vehicles are available, deployable, undamaged, and not mothballed. The user decided the current personnel posture is acceptable and preserves needed turnover reserve.

### mekhq-pending-3032-12-04-002: Acquire Jade Passage Small Craft

- Status: resolved
- Type: purchase-sale
- Priority: optional
- Created: 3032-12-04
- Updated: 3033-10-04
- Source scene: Jade Passage Small Craft procurement discussion.
- Source files: `session-log.md`, `assets.md`, `mekhq-bridge.md`
- MekHQ target ids: campaign `7fbbb5da-0bcd-46f1-8f61-846848c2f148`; person `Unknown`; unit `b284fa8a-4106-4790-bfe7-d6cc06cfe1dc`, `403d4123-8918-429c-a5f4-6e4818fa1e1b`, `925c5d87-47a5-4d7d-87f9-23e62378d664`; contract `Unknown`; scenario `Unknown`
- Current imported baseline: 3033-10-04 live API snapshot confirms `Ares Assault Craft Mark VII`, `Dragonstar Passenger Transport`, and `Jump Platoon (Laser)` in the roster.
- Proposed MekHQ action: Acquire one freight/landing Small Craft and one Dragonstar infantry/passenger/security Small Craft for the `Jade Passage` Small Craft bays.
- Manual application checklist:
  - Open the linked MekHQ campaign save named in `mekhq-bridge.md`.
  - Confirm the current MekHQ date/save matches the latest imported baseline.
  - Apply the purchase or special-order result in MekHQ.
  - Save the MekHQ campaign.
- Command application checklist:
  - Confirm the live MekHQ API campaign id/date/state revision matches the pending baseline.
  - Run dry-run/preflight if the command supports it.
  - Confirm target ids/selectors and guard fields.
  - Get user approval for campaign-significant changes unless an explicit automation policy exists.
  - Execute the MekHQ-owned command.
  - Re-read live MekHQ state and verify expected fields.
- Confirmation needed from next import: Live API roster includes one `Ares Assault Craft Mark VII`, one `Dragonstar Passenger Transport`, and one `Jump Platoon (Laser)`.
- Affected campaign files after import: `assets.md`, `session-log.md`, `mekhq-bridge.md`, `mekhq-api-gaps.md`
- Blockers or discrepancy notes: V1 transport fields do not expose Small Craft bay occupancy or strategic infantry transport compatibility. No current MekHQ carried-unit assignment is asserted for the jump platoon.
- Resolution notes: Resolved by live API verification on 3033-10-04. Table logistics ruling: the `Dragonstar Passenger Transport` has sufficient infantry transport capacity for the Strikers' `Jump Platoon (Laser)` during interstellar movement, avoiding the need to hire a separate troop transport vessel for that platoon.
