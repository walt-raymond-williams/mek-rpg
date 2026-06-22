# MekHQ Read-Only Checkpoint Export Contract

Status: issue `#67` consumer contract and gap comparison.

Purpose: define how MEK-RPG should consume a future MekHQ-owned read-only checkpoint export while preserving the current Python save-summary helper as a read-only prototype and fallback.

## Decision

MEK-RPG should define its desired consumer contract now, but MekHQ should own any future source-backed exporter that loads campaign state through MekHQ code and emits derived values through MekHQ methods.

Live MekHQ local-control API JSON is a related but distinct input class. It should use the same top-level grouping and trust envelopes where practical, but it is a live context refresh, not a durable checkpoint/import record by default. A live payload becomes durable MEK-RPG campaign state only after a saved checkpoint/import confirms it, the user explicitly approves recording it, or a future controlled adapter flow defines that promotion.

The current `scripts/summarize-mekhq-save.py` output remains useful for:

- bootstrapping disposable or personal MEK-RPG campaign folders from explicit saved MekHQ files
- regression fixtures that prove MEK-RPG can consume a read-only summary
- fallback inspection when no MekHQ-owned exporter exists

It should not become the long-term authority for values that MekHQ derives through campaign methods, UI business logic, or option-dependent services.

## Consumer Requirements

MEK-RPG can consume either the current helper JSON or a future MekHQ-owned checkpoint export if the payload:

- is read-only and never applies a MekHQ ledger change
- identifies the source save or campaign checkpoint, export tool, export version, export timestamp, and MekHQ version when available
- preserves full MekHQ IDs for campaigns, people, units, contracts, scenarios, market offers, and work items when available
- separates confirmed serialized facts from method-backed derived values, inferred values, unsupported fields, and warnings
- includes enough guard fields for later reconciliation: campaign id, save path or checkpoint id, campaign date, object ids, display names, status, and relevant dates
- avoids raw MekHQ XML, raw save payloads, protected A Time of War source text, copied tables, secrets, or large opaque blobs

Recommended evidence labels:

- `Confirmed from MekHQ export`: value came from a MekHQ-owned exporter using MekHQ code.
- `Confirmed from MekHQ import`: value came from the current MEK-RPG read-only XML summary helper.
- `Method-backed`: value was produced by a MekHQ method rather than raw XML field inspection.
- `Serialized fact`: value is stored directly in a saved campaign.
- `Inferred`: value was calculated or interpreted outside MekHQ business logic and needs caution.
- `Unknown`: expected field is absent or not exposed.
- `Unsupported`: field is outside the current exporter/helper.
- `Needs MekHQ inspection`: field requires MekHQ source or sample-save review before trust.

## Preferred Export Shape

The top-level shape should stay close to the current helper so existing bootstrap and context tooling can adapt gradually. The live local-control API state endpoint also uses this grouping so adapters can share validation and warning behavior while keeping durability separate:

```json
{
  "bridge_metadata": {},
  "campaign": {},
  "finances": {},
  "personnel": [],
  "units": [],
  "contracts": [],
  "scenarios": [],
  "repairs_and_logistics": {},
  "markets": {},
  "reports": {},
  "unsupported": []
}
```

`reports` is the main new top-level area recommended for a MekHQ-owned export. The current helper has warnings and unsupported fields but does not classify daily report alerts as a reliable separate feed.

For live API payloads, `bridge_metadata.api_mode` should identify `local-read-only-live-context`, `read_only` must remain true, and `state_revision` or `snapshot_id` should be preserved as live freshness metadata. `checkpoint_id` may be `Unknown`; consumers must not treat that as a saved import checkpoint.

Each complex object should include:

- stable MekHQ id when available
- display name or short label
- status or lifecycle value
- source/evidence label
- `source_owner` when useful, such as `MekHQ method`, `Serialized save field`, or `MEK-RPG fallback parser`
- `method_backed: true | false | "Unknown"` for values that may be derived
- unsupported or warning notes scoped to that object

## Gap Comparison

| Area | Current MEK-RPG helper output | Future MekHQ-owned export expectation | Consumer guidance |
| --- | --- | --- | --- |
| Metadata | `bridge_metadata` includes helper name/version, input path, save timestamp, import timestamp, save size, gzip flag, save version, warnings, and unsupported section names. | Preserve metadata and add MekHQ exporter name/version, MekHQ build/version, checkpoint id if available, and whether values are source-backed through MekHQ code. | Current shape is close enough. Adapter should normalize names without dropping source-path and timestamp fields. |
| Campaign identity/date | `campaign` includes id, name, date, start date, faction, GM mode, reputation, location, and calculated funds copy. | Use MekHQ campaign getters for id/name/date/faction and include serialized-vs-method provenance. | Treat current id/date/name as usable checkpoint facts; prefer MekHQ export for exact current location and option-sensitive status. |
| Location/travel | Current helper exposes current system id and a few transit fields when present. | Export current location/system/base/travel state through MekHQ location APIs and include route/base semantics where available. | Current location is partial. Mark route, transit, base, cargo pressure, and travel readiness as `Needs MekHQ inspection` unless the exporter provides method-backed values. |
| Finances | Current helper infers balance by summing serialized transactions and reports counts/lists. | Export `Finances#getBalance()` or equivalent method-backed balances, financial warnings, loans/assets/debt status, and recent transactions. | Funds from the Python helper remain `Inferred`; exact funds should prefer the MekHQ export or UI confirmation. |
| Personnel | Current helper parses roster/applicant ids, display names, role/rank/status fields, unit assignment, commander flag, and basic fatigue/healing flags. | Export personnel through MekHQ/HumanResources APIs with method-backed availability, salary/pay meaning, injury objects, fatigue, role/rank display, assignment, and market membership. | Current roster identity is useful; exact availability, injury, pay, and role semantics should be method-backed before treated as precise ledger facts. |
| Units | Current helper parses unit ids, chassis/model/type, status/site fields, crew links, linked part counts, and maintenance-report excerpts. | Export unit status, crew, transport/cargo associations, damage state, repair needs, ammo/heat where useful, and assignment through `Unit` and entity methods. | Current unit identity and crew links are useful; exact condition, transport, cargo, and repair readiness need MekHQ method-backed export. |
| Contracts | Current helper reads saved active mission/contract facts and some direct contract-market offer elements when present. | Export active contracts and market offers with stable ids, employer/enemy, deadlines, terms summary, status, StratCon/AtB state, prompt requirements, and confirmation fields. | Active saved contracts can be displayed cautiously. Contract-market decision planning requires stable offer ids and prompt policy from MekHQ. |
| Scenarios | Current helper parses scenario id, parent contract id, name, status, date, and objective/status summaries. | Export scenario status, linked contract, participating units when available, resolve state, tactical result pointers, and confirmation fields after resolution. | Current scenario summaries are enough for hooks and handoff prompts, not final tactical outcome details. |
| Repairs and logistics | Current helper reports shopping-list counts, part counts, unit-linked part counts, tech/medic pools where present, and `transport_cargo_pressure` as unknown/needs-inspection. | Export repair queues, part/work ids, assigned techs, minutes left, part needs, acquisition queue state, shopping results, cargo/transport pressure, and method-backed logistics warnings. | Current output is shallow pressure reporting. Do not use it to automate repairs or exact readiness. |
| Unit market | Current helper reads offer market, unit type/name, offer percent, and transit duration. | Export stable offer selector/id if available, unit details, method-backed final price via `UnitMarketOffer#getPrice()`, transit, market type, and duplicate-safe guard fields. | Current offers are opportunities only. Price and selection are unsafe for automation without MekHQ exporter support. |
| Personnel market | Current helper parses applicant `Person` entries. | Export applicant ids, availability, hiring cost, attached entity references, market status, and hire preconditions. | Current applicant identity is useful; hiring decisions still require UI/manual or future source-backed command. |
| Contract market | Current helper has partial support; sample coverage is limited. | Export contract offer ids, terms, employers, deadlines, StratCon/AtB prompt flags, and accept/decline confirmation fields. | This is a critical gap for issue `#69`; no write-side plan should rely on raw table row or display name alone. |
| Daily reports/alerts | Current helper does not provide a reliable classified report feed. | Export sanitized and categorized alerts from current, skill, technical, finance, acquisition, medical, personnel, battle, politics, and aggregate report sections. | Treat report text from raw XML as presentation data until a MekHQ exporter classifies it. |
| Unsupported/warnings | Current helper emits `unsupported` plus metadata warnings. | Preserve unsupported/warning entries with area, field, reason, evidence, and recommended owner. | Keep this area mandatory so consumers can surface gaps instead of inventing values. |

## Adapter Plan

When a MekHQ-owned checkpoint export or live API payload becomes available, MEK-RPG should add a small adapter layer before changing bootstrap or play workflows:

1. Accept an explicit JSON file path produced by either the current Python helper or the MekHQ-owned exporter.
2. Detect producer and schema version from `bridge_metadata`.
3. Normalize to the existing MEK-RPG summary shape used by `scripts/bootstrap-mekhq-campaign.py`.
4. Preserve method-backed provenance and warnings in `mekhq-bridge.md`.
5. Prefer MekHQ-exported method-backed values over Python-helper inferred values when both are present.
6. Refuse to silently coerce missing stable ids for contract-market offers, unit-market offers, repair work items, or personnel applicants into automation-ready selectors.
7. Keep current helper fixtures as fallback coverage and add separate fixture coverage for the MekHQ export shape once a sample exists.
8. Treat live API payloads as live context unless a saved/imported checkpoint or explicit user approval promotes selected values into durable MEK-RPG memory.

No adapter should write to `.cpnx`, `.cpnx.gz`, MekHQ XML, or raw MekHQ save payloads.

Live API adapters also must not call write/action endpoints, create pending MekHQ actions from market or repair data, or infer that unsaved GUI state is durable campaign truth.

## Bootstrap Expectations

`scripts/bootstrap-mekhq-campaign.py` should remain conservative:

- It may consume normalized checkpoint JSON with the current top-level sections.
- It should continue to create `mekhq-bridge.md` as the technical owner of import metadata, warnings, unsupported fields, and cross-references.
- It should surface method-backed versus inferred values where the normalized input provides that distinction.
- It should continue to use `Unknown`, `Unsupported`, or `Needs MekHQ inspection` instead of inventing hard ledger values.
- It should not promote market offers, repair work, contract decisions, personnel hires, or day advancement into final facts without a saved MekHQ import confirming the outcome.

## Follow-Up

Issue `#87` adds `docs/current/MEKHQ_CHECKPOINT_CONSUMED_FIELD_MAPPING.md` as the MEK-RPG consumed-field map for future adapter and exporter-hardening decisions.

Issue `#105` added sanitized live API fixtures under `tests/fixtures/` and `scripts/test-mekhq-live-api-fixtures.ps1` so summary, full state, warning-heavy, trust-envelope, read-only, unsupported, and sanitation behavior can be validated without a running MekHQ GUI.

Create a focused adapter implementation issue after the MegaMek workspace provides either:

- a draft MekHQ-owned checkpoint export JSON shape, or
- a representative sanitized export fixture with method-backed fields.

Until then, issue `#67` closes as a consumer contract and gap map. The current Python helper remains the read-only prototype/fallback.
