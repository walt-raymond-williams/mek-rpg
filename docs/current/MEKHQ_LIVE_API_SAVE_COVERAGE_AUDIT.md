# MekHQ Live API Vs Save Parsing Coverage Audit

Date: 2026-06-22

Status: issue `#108` planning audit.

Purpose: align MEK-RPG planning around the live MekHQ API as the normal source for an active loaded campaign, and keep raw save parsing as an explicit offline, legacy, fixture, or debugging fallback.

## Decision

When MekHQ is open and the read-only local API is available, MEK-RPG should load and refresh campaign context from:

1. `GET /campaign/summary`
2. `GET /campaign/state`, either without `sections` or with `bridge_metadata` explicitly included

MEK-RPG should not parse the active `.cpnx`, `.cpnx.gz`, or XML save merely because the user supplied a save path. A save path may identify the campaign for the human, but the loaded live API payload is the source to verify active campaign identity, date, location, roster counts, ledger context, warnings, and unsupported fields.

If the live API lacks data that is available in the save file or live MekHQ memory, the project should record an API gap or producer change request instead of routing around the API by parsing the save.

## Current Role Of Save Parsing

`scripts/summarize-mekhq-save.py` remains useful for:

- offline inspection when MekHQ is not running or the live API is unavailable
- legacy/disposable campaign bootstrap experiments
- sanitized regression fixtures
- debugging differences between serialized save facts and MekHQ method-backed live values

It is not the normal workflow for a loaded MekHQ campaign.

`scripts/bootstrap-mekhq-campaign.py` remains a one-time campaign folder creator from normalized summary-like JSON. Issue `#107` should add the live API campaign-load adapter so active loaded campaigns can create or refresh MEK-RPG context directly from the API payload rather than through save-summary parser output.

## Known Coverage Comparison

| Area | Save parser or checkpoint expectation | Live API status from current docs | Planning action |
| --- | --- | --- | --- |
| Campaign identity/date | Parser can read saved id/name/date from XML. | Live API summary/state exposes id/name/date with read-only proof. | Use live API first for active loaded campaign identity and date. |
| Current system/location | Parser previously produced stale or less useful location context for the loaded test campaign. | Live API smoke test correctly reported `Galatea`; state needs stable human-readable system/location fields in all relevant payloads. | Keep current location/system as a required API field; do not fall back to parser for active context. |
| Metadata/trust envelope | Parser records helper name, input path, timestamps, warnings, and unsupported sections. | Live state supports `bridge_metadata` when requested or when all sections are returned. | All MEK-RPG live API requests for context validation must include `bridge_metadata`. |
| Dirty/unsaved state | Parser only sees saved file state. | Live API reports dirty state as `Unknown` with warnings/unsupported entries. | Request richer dirty/unsaved state if MekHQ can expose it safely; treat unknown as live-context caution. |
| Finances | Parser can infer balance from serialized transactions, but that is weaker than MekHQ business logic. | Live API should expose method-backed balance and finance warnings. | Prefer live API method-backed finance values; request missing loan/debt/recent transaction context. |
| Personnel | Parser reads roster/applicant identity and some role/status fields. | Live API includes personnel counts and should expose stable ids, display names, ranks, roles, assignments, availability, fatigue, and injury context. | Use API identity fields for context; request any missing availability, salary/pay, market/applicant, or injury details. |
| Units | Parser reads unit identity, crew links, status/site fields, and some part/report clues. | Live API includes units and should expose stable ids, crew/tech links, condition, damage, repair summary, and scenario assignment. | Request API coverage for any unit condition or repair details needed for play setup. |
| Contracts/scenarios | Parser can read saved contract/scenario basics when present. | Live API includes sections but the live test campaign had 0 contracts and 0 scenarios. | Need fixture or real campaign coverage with active contracts/scenarios before claiming this path complete. |
| Repairs/logistics | Parser has shallow pressure reporting. | Live API should expose repair queues, part pressure, shopping/acquisition pressure, cargo/transport warnings, and unsupported details. | Treat missing logistics as API gaps, not parser fallback justification. |
| Markets | Parser can see some offers, but selectors/prices are not automation-safe. | Live API should keep markets display-only unless stable ids, guard fields, prices, and command semantics are guaranteed. | Display only; request stable selectors only as future-readiness metadata, not write authorization. |
| Reports | Parser does not reliably classify daily reports. | Live API can expose sanitized categorized report buckets and compact summaries. | Prefer API reports for live GM context; request richer classification where missing. |
| Unsupported/gaps | Parser emits unsupported/warning notes. | Live API has `unsupported` and warnings. | Preserve structured unsupported entries so future agents create change requests instead of inventing facts. |

## Roadmap Implication

Recommended near-term order:

1. Issue `#108`: complete this roadmap/API-first audit.
2. Issue `#109`: keep a producer-facing change request package for any API gaps discovered here or during adapter work.
3. Issue `#107`: implement the MEK-RPG live API campaign-load adapter with gap surfacing.
4. Issue `#97`: resume the blind/live GM playtest after active campaign loading no longer depends on save parsing.

Issue `#109` can proceed in parallel as a memo/handoff package and should be updated if issue `#107` finds new API gaps.

## Producer Change Request Owner

The MegaMek/MekHQ-facing request package lives in:

- `docs/current/MEGAMEK_LIVE_API_CHANGE_REQUEST.md`
- `docs/handoffs/active/live-api-producer-change-request-109.md`

Those documents are project-local requests. They do not authorize edits, commits, issue creation, or roadmap changes in the MegaMek workspace.

## Verification Notes

This audit did not query a live MekHQ instance or parse any raw save files. It reviewed current MEK-RPG planning docs, issue state, committed live API fixture posture, and the issue `#104`/`#106` smoke-test record.
