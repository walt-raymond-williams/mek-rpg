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

## Fields To Keep Out Of V1 State Payloads

Please omit write/action surfaces from the read-only state API payloads:

- market purchases
- personnel hiring
- contract accept/decline
- repair execution or assignment
- tactical result application
- save/writeback commands

Markets can appear in V1 only as display-only opportunity context. They should not imply stable selectors or automation readiness unless MegaMek can provide source-confirmed stable ids, guard fields, prompt policy, and confirmation semantics.

Separate local control command endpoints are acceptable when they are explicitly command-shaped, disabled by default, loopback-only, MekHQ-owned, guarded, approval-aware, and verified by live reread. They should not be hidden inside `GET /campaign/state` output.

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

## Campaign Load Workflow Correction

Date: 2026-06-22

Issue: `#97`

When a user has MekHQ open and provides the active loaded campaign context, MEK-RPG should treat the live API as the primary source for campaign loading and refresh. It should not parse the `.cpnx`, `.cpnx.gz`, or XML save as the normal path.

Correct workflow:

1. Query `GET /campaign/summary` to confirm MekHQ is ready, read-only, and serving the expected loaded campaign.
2. Query `GET /campaign/state` without `sections`, or include `bridge_metadata` explicitly when selecting sections.
3. Build or refresh MEK-RPG campaign context from the live API payload.
4. If the live API lacks fields needed for safe campaign context, record those as API gaps or producer change requests.
5. Use raw save parsing only as an explicit offline/legacy fallback, fixture-generation aid, or debugging path when the user knowingly requests that path.

This correction exists because the issue `#97` setup initially used `scripts/summarize-mekhq-save.py` despite the live API being available. That created an avoidable stale-field risk: the file-summary bootstrap recorded `Canopus IV`, while the live API correctly reported `Galatea` for the loaded campaign. Live API data should win for active loaded-campaign context.

## API Additions That Would Remove Save Parsing From Campaign Load

MEK-RPG can avoid direct save parsing for active campaign loading if the live API response provides these fields with method-backed trust envelopes where appropriate:

- `bridge_metadata`: schema name/version, MekHQ version, API mode, read-only proof, snapshot/state revision, dirty-state/unsaved-state indicator, supported sections, warnings, unsupported entries.
- `campaign`: id, name, date, start date, faction, current system id/name, current location display name, travel state, and a table-safe location label. Avoid Java object `toString()` values such as `mekhq.campaign.CurrentLocation@...` as the only location representation.
- `finances`: method-backed balance, loan/debt status, recent transaction summaries, financial warnings, and source-owner details.
- `personnel`: stable person ids, display names/full titles, ranks, roles, assignments, availability/status, fatigue, hits/injuries where available, salary/pay context, commander/leadership markers, and market/applicant membership when relevant.
- `units`: stable unit ids, display names, chassis/model/type/weight, status, crew links, tech/engineer links, damage state, repair summary, transport/cargo association or warning, and scenario assignment.
- `contracts`: active contract ids, names, status, employer/enemy, locations, dates/deadlines, terms summary, salvage/payment summary, and scenario links.
- `scenarios`: stable scenario ids, linked contract ids, status, date, participating units when available, objectives/report summary, and tactical-result pointers.
- `repairs_and_logistics`: repair queues, parts/shopping/acquisition pressure, work item ids when available, assigned techs, minutes/time remaining where safe, and warnings for unsupported logistics areas.
- `markets`: display-only unit, personnel, and contract market entries with stable ids/selectors when available, prices only when method-backed, duplicate-safe guard fields, and explicit `automation_ready: false` unless the producer can guarantee command semantics.
- `reports`: sanitized, categorized report buckets plus compact summaries and warning metadata.
- `unsupported`: structured area/field/reason/recommended-owner entries so MEK-RPG records gaps instead of falling back to save parsing or inventing facts.

Two response details are especially important for replacing save parsing:

- Include a stable, human-readable current location/system summary in the live state response.
- Include enough roster/unit/market/contract identity and count information that `bootstrap-mekhq-campaign.py` or its successor can create a campaign folder directly from the API JSON without first normalizing through `summarize-mekhq-save.py`.

## MEK-RPG Consumer Follow-Up

MEK-RPG added a first-class live API campaign-load adapter in issue `#107` rather than routing live play setup through the old save-summary parser.

That adapter:

- accept captured live API JSON from `GET /campaign/state`
- verify `bridge_metadata.read_only` and `api_mode`
- create or refresh campaign-local bridge/context files from API sections
- preserve live-context versus durable-checkpoint status
- never require or follow a raw MekHQ save path when the live API is available
- surface missing fields as API gaps/change requests

Issue `#109` refreshed the producer-facing change request package from that adapter work. The confirmed request set is in `docs/current/MEGAMEK_LIVE_API_CHANGE_REQUEST.md`; the short version is source-confirmed dirty/unsaved state, stable human-readable location labels, structured unsupported entries, stable repair/acquisition work ids, display-only market selectors only when safe, and richer operational fields for finance, personnel, units, contracts, scenarios, logistics, and reports.

Related planning and producer-request documents:

- API-first coverage audit: `docs/current/MEKHQ_LIVE_API_SAVE_COVERAGE_AUDIT.md`
- MegaMek/MekHQ-facing change request: `docs/current/MEGAMEK_LIVE_API_CHANGE_REQUEST.md`
- Expanded local API tracking: `docs/current/MEKHQ_LIVE_API_EXPANSION_TRACKING.md`
- MEK-RPG adapter issue: `#107`
- Producer package issue: `#109`
- Expanded consumer follow-up issue: `#110`

## Producer Expansion Completion

Date: 2026-06-22

Follow-up issue: `#110`

The MegaMek/MekHQ workspace reported that the requested live API expansion is complete locally on branch `codex/mekhq-advance-day-control-api`.

Completed local source commits:

- `dc214d946d` (`Harden live campaign state metadata`)
- `d38a500960` (`Deepen live campaign personnel unit finance state`)
- `495b58faef` (`Deepen live campaign contract scenario state`)
- `911a338788` (`Deepen live campaign logistics market reports`)
- `e19740b110` (`Expose command readiness endpoint`)

Workspace docs and fixtures are pushed in MegaMek workspace commit `41aef57`, and the durable producer note is `../megamek-workspace/docs/current/MEK_RPG_LIVE_MEKHQ_API_PROTOTYPE.md`.

The added command-readiness endpoint is:

```http
GET /campaign/commands
```

It is read-only and reports command availability plus selector policy. It currently reports `advanceDayOnce` as available through the legacy `POST /advance-day` prototype and reports other command families as blocked. MEK-RPG issue `#111` treats day advancement as the first controlled command candidate, with live state reread required before updating durable MEK-RPG campaign files.

MEK-RPG can use the local source-built MekHQ for validation even though pushing the source branch to upstream `MegaMek/mekhq` is blocked by repository permissions. The next MEK-RPG-side work is issue `#110`: refresh fixtures, adapter mappings, dashboard/context summaries, and focused tests against the expanded read-only shape while preserving live-context-not-durable and no-writeback boundaries.

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

## Full-State Metadata Follow-Up

Date: 2026-06-22

Issue: `#106`

Resolution: no producer code change was needed. `Confirmed from source`: `LocalCampaignStateExporter` supports `bridge_metadata` and includes it by default when state sections are omitted. The issue `#104` smoke-test command explicitly requested selected sections but omitted `bridge_metadata`, so the response was section data without the metadata envelope.

Corrected smoke-test command:

```powershell
Invoke-RestMethod -Method Get `
  -Uri 'http://127.0.0.1:32180/campaign/state?sections=bridge_metadata,campaign,finances,personnel,units,contracts,scenarios,repairs_and_logistics,reports,unsupported' `
  -TimeoutSec 30 |
  ConvertTo-Json -Depth 12
```

Validation result:

- The live full-state payload with `bridge_metadata` included `schema_name: mekhq-live-campaign-state`, schema version `0.1`, API mode `local-read-only-live-context`, `read_only: true`, live `state_revision`/`snapshot_id`, dirty-state `Unknown`, warning metadata, supported sections, and the requested campaign sections.
- `scripts/export-dashboard-data.ps1 -MekHqLiveApiJson <real-state-json>` accepted the corrected real full-state payload as `live-context` with no `live-api-not-read-only` error.
- Existing committed fixture tests still cover the expected state shape with `bridge_metadata`.

Future state-section smoke tests should either omit `sections` entirely to request all supported sections or explicitly include `bridge_metadata` whenever the payload is meant for MEK-RPG dashboard/context validation.
