# Pending MekHQ Actions

Use this file for hard ledger intents created during MekHQ-linked RPG play. A pending item is not final until the user applies it in MekHQ, saves the MekHQ campaign, and MEK-RPG imports the saved result.

See `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md` for the full schema and lifecycle.

## Open Items

- None.

## Resolved Or Abandoned Items

### mekhq-pending-2026-06-21-001: Advance MekHQ one day for issue #37 playtest

- Status: resolved
- Type: day-advancement
- Priority: before-next-scene
- Created: 2026-06-21
- Updated: 2026-06-21
- Source scene: `session-log.md` > `Active Or Most Recent Session`
- Source files: `session-log.md`, `current-state.md`, `mekhq-bridge.md`
- MekHQ target ids: campaign `ea0d334a-1582-459a-9084-b349f0baca5a`; person `Unknown`; unit `Unknown`; contract `Unknown`; scenario `Unknown`
- Current imported baseline: MekHQ date `3025-07-24`; location `Astrokaszy`; funds `95669054 CSB`
- Proposed MekHQ action: Advance the linked MekHQ campaign by one day in the MekHQ UI, then save the campaign.
- Manual application checklist:
  - Open the linked MekHQ campaign save named in `mekhq-bridge.md`.
  - Confirm the current MekHQ date/save matches the imported baseline date `3025-07-24`.
  - Advance MekHQ by one day through the MekHQ UI.
  - Save the MekHQ campaign.
- Confirmation needed from next import: MekHQ campaign date should be `3025-07-25`; import metadata should point to the same source save path.
- Affected campaign files after import: `current-state.md`, `mekhq-bridge.md`, `session-log.md`
- Blockers or discrepancy notes: None
- Resolution notes: User advanced the MekHQ campaign by one day in the UI and overwrote the save. Read-only re-import at `2026-06-21T14:08:14.746917+00:00` confirmed the same MekHQ campaign id with date `3025-07-25`, so the item is resolved.
