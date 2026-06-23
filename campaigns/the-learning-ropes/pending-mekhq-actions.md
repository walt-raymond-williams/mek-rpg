# Pending MekHQ Actions

Use this file for hard ledger intents created during MekHQ-linked RPG play. For supported MekHQ command endpoints, record the command proposal, dry-run, execution, and verification here. For unsupported or unavailable endpoints, record the manual MekHQ fallback checklist here.

A pending item is not final until MekHQ applies it through a supported command or manual UI action and MEK-RPG verifies the result by live reread or saved import.

See `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md` for the full schema and lifecycle.

## Open Items

### mekhq-pending-2026-06-23-001: Accept Free Worlds League contract offer

- Status: queued
- Type: contract
- Priority: before-day-advance
- Created: 2026-06-23
- Updated: 2026-06-23
- Source scene: `session-log.md` active session summary
- Source files: `session-log.md`, `missions.md`
- MekHQ target ids: campaign `ea0d334a-1582-459a-9084-b349f0baca5a`; contract `Unknown`
- Current imported baseline: 3025-04-08 on Galatea; market contract offers `1`; active contracts `0`
- Proposed MekHQ action: Use `GET /campaign/commands` to locate the Free Worlds League contract offer, dry-run `POST /campaign/command/contracts/accept` with copied guard fields and explicit known prompt choices, then execute after user approval if readiness and dry-run match Double-M's decision.
- Manual application checklist:
  - Use this fallback only if `contracts.accept` is unavailable, blocked, refused for unsupported prompt policy, or cannot be verified from live state.
  - Open the linked MekHQ campaign in the MekHQ UI.
  - Confirm the current MekHQ date/campaign matches the latest baseline.
  - Inspect the Free Worlds League contract offer and confirm it is the intended offer.
  - Accept the contract in the MekHQ UI and save if a durable checkpoint is needed.
- Command application checklist:
  - Query `GET /campaign/state` and `GET /campaign/commands`.
  - Confirm campaign id `ea0d334a-1582-459a-9084-b349f0baca5a`, date `3025-04-08`, state revision, and one intended Free Worlds League offer.
  - Copy the contract id, offer terms, campaign balance, market-offer count, active-mission count, and supported prompt choices from readiness/state into the request guards.
  - Run `POST /campaign/command/contracts/accept` with `dryRun=true` and `promptPolicy=explicit_known_choices`.
  - Present the dry-run target and side effects for approval.
  - Execute with `dryRun=false`, `saveAfterSuccess=false` unless the user explicitly requests save.
  - Re-read live MekHQ state and verify expected fields.
- Confirmation needed from next import: active contract count increases or live state reports the accepted contract/mission with Free Worlds League as employer; the selected offer is removed or consumed; expected payment/report effects appear where exposed.
- Affected campaign files after import: `missions.md`, `current-state.md`, `hooks.md`
- Blockers or discrepancy notes: Contract id and full guard terms are not in the current campaign-local bridge notes; next step is live command readiness, not manual UI by default.
- Resolution notes: TBD

## Resolved Or Abandoned Items

- None.
