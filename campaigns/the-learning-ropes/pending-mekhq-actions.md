# Pending MekHQ Actions

Use this file for hard ledger intents created during MekHQ-linked RPG play. For supported MekHQ command endpoints, record the command proposal, dry-run, execution, and verification here. For unsupported or unavailable endpoints, record the manual MekHQ fallback checklist here.

A pending item is not final until MekHQ applies it through a supported command or manual UI action and MEK-RPG verifies the result by live reread or saved import.

See `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md` for the full schema and lifecycle.

## Open Items

### mekhq-pending-2026-06-23-001: Accept Free Worlds League contract offer

- Status: resolved
- Type: contract
- Priority: before-day-advance
- Created: 2026-06-23
- Updated: 2026-06-23
- Source scene: `session-log.md` active session summary
- Source files: `session-log.md`, `missions.md`
- MekHQ target ids: campaign `ea0d334a-1582-459a-9084-b349f0baca5a`; market offer `82`; active contract `1`; scenario `1`
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
- Confirmation needed from next import: Complete by live reread at `2026-06-23T16:35:50.765201Z`: active contract count increased to `1`, Free Worlds League objective raid appeared as active contract, contract market offer count dropped to `0`, campaign balance changed to `101,274,018 C-Bill`, and current reports named Astrokaszy with 142 travel days.
- Affected campaign files after import: `missions.md`, `current-state.md`, `hooks.md`
- Blockers or discrepancy notes: `GET /campaign/commands` timed out during play, so the user applied the acceptance manually in MekHQ; live reread verified the result. This live API verification is not a saved-clean proof because dirty state remains unsupported by the V1 endpoint.
- Resolution notes: Resolved during play on 2026-06-23 after manual MekHQ acceptance and live API verification.

## Resolved Or Abandoned Items

- `mekhq-pending-2026-06-23-001` resolved in place above to preserve the command/manual checklist audit trail.
