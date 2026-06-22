# MEK-RPG Live MekHQ API Response Memo

Date: 2026-06-22

Audience: MegaMek / MekHQ workspace team

Purpose: respond to `megamek-workspace/docs/current/MEK_RPG_LIVE_MEKHQ_API_FEEDBACK_MEMO.md` with MEK-RPG consumer preferences for a live localhost MekHQ campaign-state API.

## Summary

MEK-RPG supports the live localhost read-only API direction, with one important framing rule: live MekHQ API data should be treated as a freshness layer over the existing checkpoint/import model, not as automatic durable MEK-RPG campaign state.

The live API is valuable because it can reduce stale reads, expose method-backed values from the loaded MekHQ campaign, and remove the need for the user to save before MEK-RPG can refresh GM context. The existing save/checkpoint path should remain available as the offline fallback, regression fixture source, audit trail, and durable confirmation path.

## Endpoint Preference

MEK-RPG prefers both:

1. `GET /campaign/summary` as the first smallest useful endpoint.
2. `GET /campaign/state?sections=...` using the existing checkpoint top-level groups as the first full integration target.

Please preserve the current top-level checkpoint grouping:

```text
bridge_metadata, campaign, finances, personnel, units, contracts, scenarios,
repairs_and_logistics, markets, reports, unsupported
```

Sectioned reads are useful, but MEK-RPG would rather consume one familiar grouped schema than adapt to many unrelated endpoint shapes.

## First Useful Integration Fields

For `GET /campaign/summary`, the minimum useful fields are:

- campaign id
- campaign name
- campaign date
- MekHQ version
- API/schema version
- current system/location summary
- read-only/API mode proof
- dirty/unsaved indicator if available
- state revision or checkpoint id
- top-level warnings and unsupported entries

For `GET /campaign/state`, the first useful sections are:

- `campaign`: id, name, date, faction, system/location/travel state
- `finances`: method-backed current balance, debt/loan flags, recent finance warning/report summary
- `personnel`: ids, display names, ranks, roles, assignment, status, fatigue/injury/hits, availability
- `units`: ids, display names, chassis/model/type/weight, status, crew links, tech links, condition/repair summary
- `contracts`: active contract ids/names/status, employer/enemy, system, dates, terms summary
- `scenarios`: ids, linked contract/mission id, status, date, report/objective summary
- `repairs_and_logistics`: repair pressure, parts pressure, shopping/acquisition pressure, cargo/transport warnings
- `reports`: sanitized classified report buckets plus compact summaries
- `unsupported`: structured unsupported/blocker entries

## Fields To Keep Out Of V1

Please omit write/action surfaces from the read-only state API:

- market purchases
- personnel hiring
- contract accept/decline
- repair execution or assignment
- tactical result application
- save/writeback commands

Markets can appear in V1 only as display-only opportunity context. They should not imply stable selectors or automation readiness unless MegaMek can provide source-confirmed stable ids, guard fields, prompt policy, and confirmation semantics.

## Trust Envelope Preference

Keep the full trust envelope for any field that may become campaign-facing, action-adjacent, or a hard ledger fact:

```json
{
  "value": "...",
  "evidence": "Confirmed from MekHQ API",
  "method_backed": true,
  "source_owner": "Campaign#getLocalDate()",
  "warnings": []
}
```

MEK-RPG especially needs:

- `evidence`
- `source_owner`
- `method_backed`
- `warnings`
- `unsupported`

Trivial metadata can be plain values, but campaign date, finances, personnel status, unit condition, contract terms, scenarios, repairs/logistics, markets, and reports should keep provenance.

## Live Data Durability

MEK-RPG should treat live API data as live context by default.

It should become durable MEK-RPG campaign state only after one of these occurs:

- a save/import checkpoint confirms it
- the user explicitly approves recording the live value
- a future MEK-RPG adapter issue defines a controlled `record live checkpoint` flow

This keeps MekHQ as the hard ledger while preventing unsaved or dirty UI state from silently becoming permanent MEK-RPG memory.

## State Revision And Dirty State

MEK-RPG wants a `state_revision`, `checkpoint_id`, or equivalent monotonic/live snapshot identifier.

If MekHQ can expose dirty/unsaved state, please include it. MEK-RPG would display it as bridge diagnostics, roughly:

```text
MekHQ live state is newer than the last saved checkpoint. Treat as live context until saved/imported or explicitly confirmed.
```

Dirty state should not block ordinary GM context refresh, but it should block treating values as durable checkpoint facts unless the user confirms.

## Reports

MEK-RPG prefers both:

- raw sanitized report lines, grouped by bucket
- compact classified summaries where MekHQ can provide them safely

Report text should be sanitized, bucketed, and warning-bearing. Long maintenance or technical reports are useful, but the API should make it easy for adapters to show compact summaries first.

## Warning Behavior

Warnings should block automation when they affect selectors, write commands, missing hard-ledger facts, unsupported action semantics, or contradictory campaign identity/date/read-only proof.

Warnings should not block ordinary roleplay when they only affect broad context, hooks, or advisory pressure.

## Filesystem Paths

Avoid local filesystem paths by default. If needed for debugging, make them opt-in and clearly diagnostic.

MEK-RPG fixtures and committed bridge summaries should not preserve unsanitized local save paths.

## Adapter And Test Fixture Requests

Before MEK-RPG consumes the live API JSON, it would want:

- one sanitized `GET /campaign/summary` fixture
- one sanitized `GET /campaign/state?sections=...` fixture
- one dirty/unsaved-state fixture
- one warning-heavy sparse fixture
- explicit schema/version metadata
- fixture coverage for unsupported/blocking entries
- proof that the API is read-only and bound to `127.0.0.1`
- no raw save/XML paths required for normal consumption

MEK-RPG can then add an adapter layer that accepts live API JSON alongside the existing save/checkpoint JSON, normalizes both to the current bridge/context shape, and preserves the save-file path as offline fallback and regression fixture source.

## Bottom Line

MEK-RPG wants the live API, but as read-only live context first. Preserve the checkpoint grouping, preserve trust envelopes, include snapshot/dirty-state metadata, keep markets display-only, and do not promote live values into durable MEK-RPG campaign state without save/import confirmation or explicit user approval.

## Manual Smoke Test Result

Date: 2026-06-22

Issue: `#104`

Test campaign: disposable `The Learning Ropes-test.cpnx` loaded in MekHQ from the local MegaMek workspace.

Observed endpoint behavior:

- `GET /campaign/summary` returned `status: ready`, campaign `The Learning Ropes`, date `3025-04-08`, MekHQ version `0.51.01`, schema version `0.1`, `apiMode: local-read-only-live-context`, `readOnly: true`, current system `Galatea`, a live `stateRevision`/`snapshotId`, dirty state `Unknown`, one dirty-state warning, and one unsupported dirty-state entry.
- `GET /campaign/state?sections=campaign,finances,personnel,units,contracts,scenarios,repairs_and_logistics,reports,unsupported` returned live section data for campaign, finances, personnel, units, contracts, scenarios, repairs/logistics, reports, and unsupported entries. The tested campaign response included 191 personnel, 32 units, 0 contracts, 0 scenarios, 3 current report lines, 1 recent report line, and 2 unsupported entries.
- The user observed no MekHQ save prompt, dirty-state prompt, auto-save, or other visible write/save side effect after the read-only GET requests.

Consumer validation outcome:

- Existing committed live API fixture tests passed.
- The MEK-RPG dashboard adapter accepted the live summary JSON as read-only live context.
- The live full-state JSON did not include the expected top-level `bridge_metadata` object, so the dashboard adapter could not confirm `schema_name`, `schema_version`, `api_mode`, `read_only`, `state_revision`, `snapshot_id`, or dirty-state metadata from the full-state payload. The adapter correctly rejected that state payload as missing read-only proof.

Follow-up:

- Track the full-state metadata mismatch in issue `#106` before treating real full-state live API responses as validated MEK-RPG dashboard/context input.
