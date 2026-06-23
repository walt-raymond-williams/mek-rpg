# MekHQ Command API Strategy

Date: 2026-06-22

Status: issue `#112` command-write guidance update.

Purpose: update MEK-RPG's MekHQ integration posture from permanent read-only/manual UI caution to controlled MekHQ-owned command integration.

## Current Producer Evidence

`Confirmed from local MegaMek/MekHQ workspace`: the local source branch `codex/mekhq-advance-day-control-api` now exposes command readiness and several guarded command candidates:

- `GET /campaign/commands`: read-only readiness and selector discovery endpoint.
- `POST /advance-day`: legacy guarded prototype for `advanceDayOnce`.
- `POST /campaign/command/status-note`: guarded status-note/report command with dry-run support.
- `POST /campaign/command/personnel/status`: guarded personnel status command.
- `POST /campaign/command/personnel/fatigue`: guarded personnel fatigue command.
- `POST /campaign/command/markets/unit-offers/purchase`: guarded unit-market purchase command when readiness exposes a unique live-session selector.
- `POST /campaign/command/contracts/accept`: guarded contract-market accept command when readiness exposes an acceptable contract offer.
- Source commit `e19740b110`: adds `GET /campaign/commands`.
- Source commit `4429d99ea2`: adds `POST /campaign/command/status-note`.
- Source commit `32366b64a0`: adds `POST /campaign/command/personnel/status`.
- Source commit `ef6ef99ef9`: adds `POST /campaign/command/personnel/fatigue`.
- Source commit `78890ba458`: adds `POST /campaign/command/markets/unit-offers/purchase`.
- Source commit `0451eb53d4`: adds `POST /campaign/command/contracts/accept`.
- Source commit `51dbfbe645`: adds local control API readiness and failure-isolation tests.
- Earlier source commits `9046a8075e` and `17207baa90`: added and hardened the local advance-day command prototype.

`GET /campaign/commands` reports command availability from the loaded campaign. It can report `advanceDayOnce`, `campaign.status_note`, `personnel.status`, `personnel.fatigue`, `markets.unit_offers.purchase`, and `contracts.accept` as available when their selectors and guard facts are safe for the current state. It still reports unsupported or unsafe command families such as funds adjustment, broad medical/prosthetic treatment, personnel hire/fire, repair/procurement execution, and standalone save/writeback as blocked with machine-readable reason codes.

This issue does not authorize MEK-RPG to call a real campaign command automatically. Real command execution still requires the user to run source-built MekHQ with the local control API enabled, confirm the loaded campaign baseline, and approve any campaign-significant mutation.

## Posture Update

Early MEK-RPG bridge work treated MekHQ as read-only because the project was still proving campaign context, save boundaries, fixture shape, and trust envelopes. That caution was appropriate for prototypes that parsed saves or consumed read-only exports.

The mature goal is broader:

- MEK-RPG should use live read-only API data for current context.
- MEK-RPG should be able to request explicit MekHQ-owned commands when the MegaMek/MekHQ workspace exposes safe command endpoints.
- MekHQ should remain the hard ledger for campaign date, finances, rosters, units, contracts, markets, repairs, scenarios, tactical outcomes, and saves.
- MEK-RPG should never mutate raw `.cpnx`, `.cpnx.gz`, XML, or save payloads directly.

The boundary is no longer "never mutate MekHQ." The boundary is "never perform hidden, ambiguous, or raw-file mutation." Explicit source-backed commands through MekHQ-owned code are in scope.

## Command Pattern

A safe MekHQ command workflow should follow this loop:

1. Read live state from MekHQ with `GET /campaign/state`, including `bridge_metadata`.
2. Read `GET /campaign/commands` to confirm the command is available and to discover safe selectors.
3. Select a command with stable target ids or selectors.
4. Capture baseline guards: campaign id, campaign date, state revision/snapshot id, target id, display name, relevant price/status/counts, and any prompt-sensitive fields.
5. Run dry-run or preflight if the endpoint supports it.
6. Present the proposed MekHQ mutation to the user or GM when the action is campaign-significant.
7. Execute the MekHQ-owned command only after approval or an explicit automation policy.
8. Re-read live state.
9. Verify the expected state change from MekHQ's new state, not from MEK-RPG intent text.
10. Record RPG narrative context and the confirmed hard-ledger result separately.
11. Record discrepancies as blocked reconciliation items instead of guessing.

## Command Envelope

Future command adapters should preserve this shape, even if the exact JSON varies by endpoint:

```json
{
  "command_id": "mekhq.advance_day",
  "mode": "dry_run | execute",
  "baseline": {
    "campaign_id": "example",
    "campaign_date": "3025-04-08",
    "state_revision": "live-...",
    "snapshot_id": "live-..."
  },
  "target": {
    "type": "market_offer | contract_offer | personnel | unit | repair_work | campaign",
    "id": "stable-id-or-null",
    "guard_fields": {}
  },
  "rpg_context": {
    "scene_id": "session-log heading or request id",
    "summary": "Why the RPG table is asking MekHQ to do this."
  },
  "approval": {
    "required": true,
    "approved_by": null,
    "approved_at": null
  },
  "result": {
    "status": "pending | executed | refused | blocked | verified",
    "messages": [],
    "warnings": []
  },
  "verification": {
    "reread_required": true,
    "expected_fields": [],
    "verified_from_live_state": false
  }
}
```

## First Good Command Candidates

### Advance Day

This is the selected first command candidate for MEK-RPG issue `#111`.

It is the best first command because campaign date and daily processing are central to MekHQ-linked play, and the local MegaMek/MekHQ workspace already exposes the guarded prototype command.

Current local endpoint:

```http
POST /advance-day
```

Current command name:

```text
advanceDayOnce
```

Current request guards:

- `command`: must be `advanceDayOnce`.
- `expectedDate`: required ISO MekHQ campaign date.
- `expectedCampaignId` or `expectedCampaignName`: at least one required; prefer id when the live API provides it.
- `dismissAdvanceDayNags`: optional; defaults to true in the current prototype and only suppresses the known advance-day nag sequence.
- `saveAfterSuccess`: explicit; defaults false.
- `savePath`: required only when `saveAfterSuccess` is true.

Current response statuses:

- `advanced`: `Campaign#newDay()` returned true and the loaded campaign date advanced exactly one day.
- `blocked`: the command was already running, MekHQ blocked/canceled day advancement, or the date did not advance exactly one day.
- `failed`: the command threw or failed on the Swing event dispatch thread.
- `refused`: preflight failed, such as no loaded campaign, wrong expected date, wrong campaign identity, or invalid save request.

Current limitations:

- No dry-run support.
- The legacy endpoint does not yet use the full common command envelope, command version, idempotency key, or expected state revision.
- Save-after-success is supported but should be tested only against disposable saves before real use.
- Prompt handling is limited to the known advance-day nag suppression path; arbitrary dialogs must not be auto-answered.
- `visibleDialogs` is only a final snapshot unless future producer work tracks dialogs during the command.

Useful acceptance criteria:

- `GET /campaign/commands` reports `advanceDayOnce` as available for the loaded campaign
- preflight refuses mismatched campaign id/name/date before mutation
- execute advances exactly one loaded campaign day through MekHQ-owned code
- command refuses when baseline campaign id/date does not match; future command-envelope work should add expected state revision
- command result reports before/after date, campaign id/name, whether daily nags were suppressed, final visible dialog count, and save attempt status
- post-command live state shows the new date, report changes, finances, repairs, market changes, travel, contract deadlines, and personnel/unit effects where exposed
- MEK-RPG records the RPG scene context and confirmed MekHQ result after reread

MEK-RPG-side verification contract:

1. Before command: capture `GET /campaign/state` with `bridge_metadata`, `campaign`, `finances`, `personnel`, `units`, `contracts`, `scenarios`, `repairs_and_logistics`, `markets`, `reports`, and `unsupported` when available.
2. Before command: capture `GET /campaign/commands` and confirm `advanceDayOnce` status is `available`.
3. Execute only with the exact expected campaign id/name and date from the live state/readiness responses.
4. After command: re-read `GET /campaign/state` with `bridge_metadata` and operational sections.
5. Treat the result as verified only when the reread campaign id still matches, the date is exactly one day later, and no blocker/warning indicates unresolved daily processing.
6. Update MEK-RPG campaign files only after verification, preserving MekHQ as hard ledger authority.

Issue `#110` should preserve or expose these post-command verification fields from the expanded live state shape:

- `bridge_metadata.state_revision` and `bridge_metadata.snapshot_id`
- `campaign.id`, `campaign.name`, `campaign.date`
- current system/location/travel fields
- finance balance, loan/default warnings, and recent finance report summaries
- personnel availability, assignment, fatigue, hits, injury, salary, and leadership markers
- unit availability, repair, transport, and scenario assignment summaries
- active contract dates/deadlines, payment/salvage/rental summaries, and scenario links
- scenario status/objective/tactical-result summaries
- repair/logistics pressure, shopping/acquisition rows, cargo/transport warnings
- report buckets/counts and recent report rows
- structured `unsupported` entries that block automation or verification

### Market Purchase Or Asset Acquisition

This is attractive for play because an RPG scene can negotiate or discover a unit, DropShip, cargo, or equipment purchase, then ask MekHQ to apply the final hard-ledger result.

Useful acceptance criteria:

- stable offer id or stable source-owned selector
- guard fields for campaign id, date, market type, offer id, display name, seller/source, price, and availability
- dry-run reports exact target and expected side effects
- execute purchases through MekHQ-owned logic
- post-command reread confirms funds, market removal, asset addition, cargo/transport implications, and reports

### Contract Accept

This is now implemented locally for accepting one current contract-market offer when readiness reports `contracts.accept` as available.

Current local endpoint:

```http
POST /campaign/command/contracts/accept
```

Current command name:

```text
contracts.accept
```

Current request expectations:

- `GET /campaign/commands` must expose `contracts.accept` as available and include the selected `selectors.contract_market_offers[]` entry.
- Use the offer's source contract id, the readiness `state_revision`, current campaign id/name/date, and guard facts copied from MekHQ readiness/state output.
- Run the endpoint first with `dryRun=true`.
- Use `promptPolicy=explicit_known_choices` and explicit acceptance options for known prompt branches.
- Use a fresh idempotency key for the final apply request.
- Keep `saveAfterSuccess=false` unless the user explicitly requests a MekHQ save.

Current response behavior:

- Dry-run reports the selected offer and intended side effects without mutation.
- Apply mode credits advance and transport payments through MekHQ's finance path, inserts the mission, calls MekHQ contract acceptance logic, removes the offer from the market, can append a `GENERAL` MEK-RPG audit report, and returns the new mission id.
- The command refuses stale campaign/date/state guards, mismatched offer guard facts, unsupported or unknown prompt choices, visible dialogs at start, invalid JSON/envelope fields, or ambiguous target state.

MEK-RPG-side contract-selection flow:

1. Read `GET /campaign/state` for current live context and verification fields.
2. Read `GET /campaign/commands` and confirm `contracts.accept` is available.
3. Select the intended offer by `contract_id` from readiness selectors, not by display name alone.
4. Build the guarded request from readiness/state facts and run `dryRun=true`.
5. Present the dry-run target and side effects when the action is campaign-significant.
6. Execute with the same guard facts after user approval or documented automation policy.
7. Re-read live state and verify the offer is gone or consumed, the active mission/contract exists, expected finance/report effects appear where exposed, and campaign identity still matches.
8. Update `pending-mekhq-actions.md`, `missions.md`, `assets.md`, `hooks.md`, and `session-log.md` from the verified MekHQ result.

Manual MekHQ UI acceptance remains the fallback only when `contracts.accept` is unavailable, blocked, refused for unsupported prompt policy, or cannot be verified from live state/saved import.

Declining a contract remains a separate future command need; do not simulate a decline by editing MEK-RPG Markdown or raw MekHQ saves.

### Repair Assignment Or Execution

This should wait until stable repair work ids and prompt policy exist. The expanded live API still reports stable repair work ids as unsupported, so repair commands remain a later candidate.

## Relationship To Existing Pending Actions

`pending-mekhq-actions.md` remains useful, but its role changes:

- Before command endpoints exist, pending items are manual UI checklists.
- Once a command endpoint exists, pending items can become command proposals with target ids, guard fields, dry-run output, approval status, command result, and reread verification.
- After live reread verifies the command, the pending item can resolve without requiring a separate raw save parse.

Saved import can still be useful as a durable checkpoint, audit artifact, or offline fallback. It is not the only possible confirmation path once a live command plus live reread can prove the result.

## Producer Requests

When MEK-RPG needs a new mutation capability, create a producer request that asks for:

- one narrow command, not broad arbitrary writeback
- stable source-owned selectors
- guard fields and baseline state revision checks
- dry-run/preflight mode when side effects are nontrivial
- explicit prompt policy
- refusal behavior for unsafe or ambiguous cases
- post-command result metadata
- live state fields sufficient to verify success after reread
- disposable validation fixtures or smoke commands

No new producer request is needed for `advanceDayOnce`, `campaign.status_note`, `personnel.status`, `personnel.fatigue`, `markets.unit_offers.purchase`, or `contracts.accept` because local producer work already exposes those command rows/endpoints when their current selectors are safe. MEK-RPG should instead track consumer-side readiness, fixture capture, live disposable-campaign smoke validation, and play guidance for supported commands. Create producer requests only for still-missing command families or for refusal reasons encountered during real play.

## Non-Goals

- No direct `.cpnx`, `.cpnx.gz`, XML, or raw save mutation by MEK-RPG.
- No broad "apply any pending action" command.
- No command execution from stale baseline state.
- No hidden mutation during rules lookup, dashboard rendering, or context packet assembly.
- No treating MEK-RPG narrative intent as proof that MekHQ changed.

## Planning Impact

Issue `#111` owns the first planning pass for this strategy. Issue `#112` updates older docs that describe manual UI or read-only-only behavior as the permanent workflow now that `contracts.accept` is implemented locally.

Issue `#110` remains the expanded read-only state consumption pass. It should preserve the live state surface that command adapters will use for preflight and post-command verification.
