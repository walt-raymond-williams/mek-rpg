# Pending MekHQ Actions

Use this file for hard ledger intents created during MekHQ-linked RPG play. For supported MekHQ command endpoints, record the command proposal, dry-run, execution, and verification here. For unsupported or unavailable endpoints, record the manual MekHQ fallback checklist here.

A pending item is not final until MekHQ applies it through a supported command or manual UI action and MEK-RPG verifies the result by live reread or saved import.

See `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md` for the full schema and lifecycle.

## Open Items

- None.

## Resolved Or Abandoned Items

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
