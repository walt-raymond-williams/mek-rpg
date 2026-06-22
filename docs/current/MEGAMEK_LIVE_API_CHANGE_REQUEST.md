# MegaMek / MekHQ Live API Change Request

Date: 2026-06-22

Status: MEK-RPG request package for issue `#109`.

Audience: MegaMek / MekHQ workspace team.

Purpose: request live API coverage that lets MEK-RPG load and refresh an active MekHQ campaign from the read-only local API without parsing `.cpnx`, `.cpnx.gz`, or XML save files.

## Background

MEK-RPG previously used a read-only save parser as a bridge prototype. That parser is still useful for offline fallback, sanitized fixtures, and debugging serialized-vs-live differences. It should not be the normal source for a campaign that is already loaded in MekHQ with the local read-only API available.

During issue `#97`, MEK-RPG initially parsed a save path even though the live API was available. That was the wrong workflow. The live API correctly identified the loaded campaign system as `Galatea`, while the save-summary bootstrap carried stale or less useful location context. The fix on the MEK-RPG side is issue `#107`: add a first-class live API campaign-load adapter. This change request captures the producer-side fields that make that adapter reliable.

## Requested API Principle

If MekHQ memory or the saved campaign contains a value that MEK-RPG needs for active campaign context, expose it through the read-only live API with provenance instead of expecting MEK-RPG to parse the save.

The API should remain read-only, bound to localhost, disabled by default unless explicitly enabled, and free of write/action surfaces.

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
- Sectioned `GET /campaign/state?sections=...` requests preserve `bridge_metadata` when requested, and docs/examples tell consumers to include it for validation.
- Current location/system are human-readable and stable enough for table context.
- Method-backed values identify their source owner where practical.
- Unsupported fields are explicit, structured, and useful enough for MEK-RPG to create follow-up requests instead of inventing facts.
- Market data stays display-only unless stable selector, guard, prompt, and command semantics are intentionally designed later.

## Non-Goals

- No market purchase API.
- No personnel hiring/firing API.
- No contract accept/decline API.
- No repair execution or assignment API.
- No tactical result application API.
- No save/writeback command.
- No direct XML/save mutation.

## Suggested Producer-Side Tickets

These are suggestions for the MegaMek/MekHQ board, not MEK-RPG-owned implementation work:

- Deepen live API campaign location and travel fields.
- Expose method-backed finance balance, debt/loan status, and finance warnings.
- Deepen personnel availability, injury, fatigue, role, rank, salary/pay, and market membership fields.
- Deepen unit condition, crew/tech links, repair summary, transport/cargo, and scenario assignment fields.
- Add active-contract and scenario-rich live API fixtures.
- Deepen repair/logistics queues and warning fields.
- Improve report categorization and compact report summaries.
- Keep unsupported entries structured and automation-blocker aware.

## MEK-RPG Consumer Links

- API-first audit: `docs/current/MEKHQ_LIVE_API_SAVE_COVERAGE_AUDIT.md`
- Live API response memo: `docs/current/MEK_RPG_LIVE_MEKHQ_API_RESPONSE_MEMO.md`
- Live API adapter issue: `#107`
- Roadmap audit issue: `#108`
- Change request package issue: `#109`

## Boundary

This request document does not authorize MEK-RPG agents to edit the MegaMek workspace. It is intended to be copied, linked, or handed off to the MegaMek/MekHQ team under that repository's own workflow.
