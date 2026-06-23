# MegaMek / MekHQ Live API Change Request

Date: 2026-06-22

Status: handoff-ready MEK-RPG request package completed for issue `#109`; producer-side expansion reported complete locally and MEK-RPG consumer follow-up tracked in issue `#110`.

Audience: MegaMek / MekHQ workspace team.

Purpose: request live API coverage that lets MEK-RPG load and refresh an active MekHQ campaign from the read-only local API without parsing `.cpnx`, `.cpnx.gz`, or XML save files.

## Background

MEK-RPG previously used a read-only save parser as a bridge prototype. That parser is still useful for offline fallback, sanitized fixtures, and debugging serialized-vs-live differences. It should not be the normal source for a campaign that is already loaded in MekHQ with the local read-only API available.

During issue `#97`, MEK-RPG initially parsed a save path even though the live API was available. That was the wrong workflow. The live API correctly identified the loaded campaign system as `Galatea`, while the save-summary bootstrap carried stale or less useful location context. Issue `#107` added the MEK-RPG-side fix: `scripts/sync-mekhq-live-campaign.py`, a first-class live API campaign-load adapter. This change request captures the producer-side fields that make that adapter reliable.

## Current MEK-RPG Consumer Evidence

Issue `#107` implemented and tested the live adapter against sanitized `GET /campaign/state` fixtures. The adapter now:

- accepts captured live API JSON only when `bridge_metadata.api_mode` is `local-read-only-live-context` and `bridge_metadata.read_only` is `true`
- rejects `.cpnx`, `.cpnx.gz`, and XML inputs for the active live campaign-load path
- creates or refreshes MEK-RPG campaign context from live API sections
- writes `mekhq-bridge.md` with the live trust envelope and live-context-only boundary
- writes `mekhq-api-gaps.md` with missing or unsupported producer fields
- leaves `campaign-state/active-campaign.md` unchanged

The adapter did not reveal a new need for MEK-RPG to parse active saves. It did confirm these producer-side gaps should stay visible as API/schema requests:

- dirty or unsaved campaign state is still `Unknown` and not source-confirmed in V1
- sparse state payloads can lack a human-readable current system/location label
- markets remain display-only because stable offer selectors and automation guard fields are not exposed
- repair/logistics output has aggregate pressure, but not stable repair/acquisition work item ids or full queues
- richer finance, contract, scenario, personnel, unit, cargo, and report context remains useful as play expands

These gaps are inputs for MegaMek/MekHQ producer work, not permission for MEK-RPG to route around the live API by parsing active save files.

## Requested API Principle

If MekHQ memory or the saved campaign contains a value that MEK-RPG needs for active campaign context, expose it through the read-only live state API with provenance instead of expecting MEK-RPG to parse the save.

The state API should remain read-only, bound to localhost, disabled by default unless explicitly enabled, and free of write/action surfaces. Separate command-readiness or command endpoints may exist under the local control API, but they need their own guard, approval, prompt-policy, and verification contract rather than being inferred from state payloads.

## Requested Fields

MEK-RPG can avoid active-save parsing if `GET /campaign/state` provides these areas with method-backed trust envelopes where appropriate.

### `bridge_metadata`

- schema name and version
- MekHQ version/build
- API mode, with `local-read-only-live-context`
- `read_only: true`
- state revision or snapshot id
- dirty/unsaved-state indicator when safely available
- supported sections
- warning and unsupported summaries

### `campaign`

- stable campaign id, name, date, start date, faction
- current system id/name
- current location display name
- travel state
- table-safe location label
- avoid Java object `toString()` values as the only location representation

### `finances`

- method-backed current balance
- loan/debt status
- recent transaction summaries where safe
- financial warnings
- source-owner/provenance details

### `personnel`

- stable person ids
- display names/full titles
- ranks, roles, assignments
- availability/status
- fatigue, hits, injuries, recovery state where available
- salary/pay context
- commander/leadership markers
- applicant/personnel-market membership when relevant

### `units`

- stable unit ids
- display names, chassis, model, type, weight
- status, crew links, tech/engineer links
- damage state and repair summary
- transport/cargo association or warning
- scenario assignment

### `contracts`

- active contract ids, names, status
- employer/enemy
- locations
- dates/deadlines
- terms summary
- salvage/payment summary
- scenario links

### `scenarios`

- stable scenario ids
- linked contract ids
- status/date
- participating units where available
- objectives/report summary
- tactical-result pointers

### `repairs_and_logistics`

- repair queues
- parts, shopping, and acquisition pressure
- work item ids when available
- assigned techs
- time remaining where safe
- cargo/transport/logistics warnings

### `markets`

- display-only unit, personnel, and contract market entries
- stable ids/selectors when available
- prices only when method-backed
- duplicate-safe guard fields
- explicit `automation_ready: false` unless command semantics are guaranteed

### `reports`

- sanitized categorized report buckets
- compact summaries
- warning metadata

### `unsupported`

- structured entries with area, field, reason, recommended owner, and whether the gap blocks automation or is only informational

## Acceptance Criteria For Producer Work

- `GET /campaign/summary` and `GET /campaign/state` expose enough identity, date, location, roster, unit, contract/scenario, logistics, report, warning, and unsupported data for MEK-RPG to create or refresh a campaign context without opening a raw save file.
- `GET /campaign/commands` or an equivalent readiness endpoint can expose command availability and safe selectors without mutating the loaded campaign.
- Sectioned `GET /campaign/state?sections=...` requests preserve `bridge_metadata` when requested, and docs/examples tell consumers to include it for validation.
- Current location/system are human-readable and stable enough for table context.
- Method-backed values identify their source owner where practical.
- Unsupported fields are explicit, structured, and useful enough for MEK-RPG to create follow-up requests instead of inventing facts.
- Market data stays display-only unless stable selector, guard, prompt, and command semantics are intentionally designed later.

## Non-Goals

For the read-only state API, this request still excludes mutation surfaces:

- No market purchase API.
- No personnel hiring/firing API.
- No contract accept/decline API.
- No repair execution or assignment API.
- No tactical result application API.
- No save/writeback command in the state API.
- No direct XML/save mutation.

Issue `#111` separately defines MEK-RPG's controlled command posture for explicit MekHQ-owned command endpoints. The first command candidate is day advancement through the local `POST /advance-day` prototype plus post-command live reread verification.

## Suggested Producer-Side Tickets

These are suggestions for the MegaMek/MekHQ board, not MEK-RPG-owned implementation work:

### Immediate Adapter-Proven Requests

- Expose source-confirmed dirty/unsaved campaign state, or keep the current `Unknown` value with a structured unsupported entry that clearly identifies the missing MekHQ source owner.
- Ensure every full or sparse campaign state response can include stable, human-readable current system and location labels when campaign data exists.
- Preserve `bridge_metadata` in documentation/examples for every consumer validation request; selected-section examples should include `bridge_metadata` explicitly.
- Keep unsupported entries structured with `area`, `field`, `reason`, `evidence`, `recommended_owner`, and `blocks_automation`.

### Near-Term Playtest Requests

- Expose method-backed finance balance, debt/loan status, recent transaction summaries, and finance warnings.
- Deepen personnel availability, injury, fatigue, role, rank, salary/pay, commander marker, and market/applicant membership fields.
- Deepen unit condition, crew/tech links, repair summary, transport/cargo, and scenario assignment fields.
- Add active-contract and scenario-rich live API fixtures so MEK-RPG can validate non-empty operational campaign context.
- Deepen repair/logistics queues, stable work item ids, assigned techs, time remaining, parts pressure, acquisition pressure, and warning fields.
- Improve report categorization and compact report summaries.

### Future-Readiness Only

- Investigate stable market offer selectors and duplicate-safe guard fields, but keep `automation_ready: false` unless command semantics, prompts, and saved/import confirmation are intentionally designed later.

## MEK-RPG Consumer Links

- API-first audit: `docs/current/MEKHQ_LIVE_API_SAVE_COVERAGE_AUDIT.md`
- Live API response memo: `docs/current/MEK_RPG_LIVE_MEKHQ_API_RESPONSE_MEMO.md`
- Live API adapter issue: `#107`
- Roadmap audit issue: `#108`
- Change request package issue: `#109`
- Adapter implementation: `scripts/sync-mekhq-live-campaign.py`
- Adapter coverage: `scripts/test-sync-mekhq-live-campaign.ps1`

## Handoff Status

This MEK-RPG package is ready to copy, link, or summarize into the MegaMek/MekHQ workflow. The recommended first producer-side action is to create or update one MegaMek/MekHQ issue for the immediate adapter-proven requests, then split deeper personnel/unit/contract/logistics/report work into separate producer tickets if the team wants narrower implementation units.

## Producer Completion Update

Date: 2026-06-22

The MegaMek/MekHQ workspace reports that the requested local live API expansion is complete on branch `codex/mekhq-advance-day-control-api` in commits `dc214d946d`, `d38a500960`, `495b58faef`, and `911a338788`. The completed read-only state work covers hardened metadata/location behavior, deeper finance/personnel/unit/contract/scenario/logistics/report/market state, and explicit automation guards.

The same local source branch later added `GET /campaign/commands` in commit `e19740b110`. That endpoint is read-only command readiness and selector discovery. It reports `advanceDayOnce` as available through the legacy `POST /advance-day` command prototype. Commit `4429d99ea2` also adds guarded `campaign.status_note` support through `POST /campaign/command/status-note`. Other command classes remain blocked unless the readiness endpoint reports them available. MEK-RPG issue `#111` owns the consumer-side command strategy and verification plan.

Source publication to upstream `MegaMek/mekhq` remains blocked by repository permissions, but MEK-RPG can use the local source-built MekHQ and the producer fixtures for consumer validation. MEK-RPG follow-up issue `#110` tracks fixture refresh, adapter/dashboard/context consumption, and tests for the expanded shape. See `docs/current/MEKHQ_LIVE_API_EXPANSION_TRACKING.md`.

## Boundary

This request document does not authorize MEK-RPG agents to edit the MegaMek workspace. It is intended to be copied, linked, or handed off to the MegaMek/MekHQ team under that repository's own workflow.
