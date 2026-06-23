# MekHQ Live API Gaps

This file records missing, unsupported, or automation-blocking live API fields found during the latest campaign context refresh. These are producer-side change request inputs, not permission to parse the active save as a workaround.

Last checked: 2026-06-23T15:17:19.944925+00:00

## Gaps

- `unsaved_changes`
  - Area: bridge_metadata.dirty_state
  - Reason: Source search found editor-local unsaved state, but no campaign-wide dirty/unsaved flag exposed for the loaded MekHQ campaign.
  - Recommended owner: MekHQ GUI save-state tracking
  - Blocks automation: false
- `stable_repair_work_ids`
  - Area: repairs_and_logistics
  - Reason: Stable IPartWork/IAcquisitionWork selectors are not exposed by this V1 read-only endpoint.
  - Recommended owner: Future MekHQ exporter work
  - Blocks automation: true
- `repair_or_procurement_commands`
  - Area: repairs_and_logistics
  - Reason: This V1 endpoint does not expose repair execution, repair assignment, shopping-list purchase, or shopping-list priority mutation commands.
  - Recommended owner: Future MekHQ command API design
  - Blocks automation: true
- `stable_unit_market_offer_selectors`
  - Area: markets
  - Reason: The campaign-local bridge note was generated before the latest command-readiness updates; use `GET /campaign/commands` for current command selectors instead of this stale bridge gap list. Unit-market selector availability depends on the current readiness row.
  - Recommended owner: MekHQ command readiness reread
  - Blocks automation: true
- `market_mutation_commands`
  - Area: markets
  - Reason: This generated bridge note predates local guarded commands such as `contracts.accept` and `markets.unit_offers.purchase`. Reread `GET /campaign/commands`; only unavailable, blocked, or refused market actions should remain producer gaps.
  - Recommended owner: MekHQ command readiness reread
  - Blocks automation: true
