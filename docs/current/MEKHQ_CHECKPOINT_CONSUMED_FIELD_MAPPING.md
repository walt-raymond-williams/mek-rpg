# MekHQ Checkpoint Consumed Field Mapping

Status: issue `#87` consumer decision for MEK-RPG checkpoint adapter experiments.

Purpose: define which MekHQ read-only checkpoint export fields MEK-RPG should consume directly, preserve as evidence, surface to the GM, ignore for now, or treat as blocked/unsafe before MegaMek hardens exporter output.

## Decision

MEK-RPG should keep the current top-level checkpoint shape:

```text
bridge_metadata, campaign, finances, personnel, units, contracts, scenarios,
repairs_and_logistics, markets, reports, unsupported
```

No top-level rename or removal is requested from the current draft schema. MEK-RPG does request that the exporter preserve these trust-boundary fields wherever a value may become campaign-facing or action-adjacent:

- `evidence`
- `source_owner`
- `method_backed`
- `warnings`
- `unsupported`

These fields are not decorative. MEK-RPG uses them to decide whether a value can enter campaign state, should appear only as GM context, needs manual confirmation, or must block automation.

## Consumption Categories

Use these categories when writing adapters, tests, or feedback to the MegaMek workspace:

| Category | Meaning | MEK-RPG handling |
| --- | --- | --- |
| `Consumed hard checkpoint` | Read-only MekHQ fact safe to carry into MEK-RPG bridge/context files after import. | Preserve exact value, source/evidence metadata, and MekHQ ids. |
| `Consumed with caution` | Useful context, but exact semantics may depend on MekHQ methods, UI state, or later validation. | Display or record with warnings; do not use for automation or final adjudication. |
| `GM-facing context` | Useful for scene framing, handoff prompts, or operator review. | Surface to the GM; avoid treating as final ledger authority. |
| `Evidence/diagnostic only` | Helps debug adapter trust or exporter gaps. | Preserve in bridge metadata, warnings, or diagnostics; do not expose as player-facing facts by default. |
| `Blocked/unsafe` | Missing stable selector, write-side action, or ambiguous method semantics. | Block automation and require manual MekHQ/UI confirmation or future source-backed issue. |
| `Ignored for now` | Not currently used by MEK-RPG but harmless to preserve. | Keep if producer owns it; adapter may pass through or omit from campaign-facing output. |

## Field Map

| Export area | Fields | Category | Consumer use | Schema feedback |
| --- | --- | --- | --- | --- |
| `bridge_metadata` | `schema_name`, `schema_version`, `producer`, `producer_version`, `mekhq_version`, `exported_at`, `save_timestamp`, `save_size_bytes`, `gzip`, `read_only`, `checkpoint_id`, `warnings` | Consumed hard checkpoint for metadata; evidence/diagnostic for producer details | Store in `mekhq-bridge.md` or adapter diagnostics so future imports can be reconciled to a specific checkpoint. | Keep all fields. Add stable `checkpoint_id` whenever possible. Sanitize or allow adapter sanitization of local `input_path` before commit. |
| `bridge_metadata.input_path` | Local save path | Evidence/diagnostic only | Useful during local debugging but should not be committed unsanitized in fixtures or campaign-facing summaries. | Keep optional; producer may emit it, but fixtures/docs should sanitize it. |
| `campaign.id` | Campaign id when available | Consumed hard checkpoint | Preserve as MekHQ campaign cross-reference if non-`Unknown`. | Keep envelope and warning when absent. |
| `campaign.name`, `campaign.date`, `campaign.faction` | Campaign identity and linked date | Consumed hard checkpoint | Use for pre-session checkpoint context and MekHQ-linked campaign date. | Keep method-backed envelopes. Date/name/faction are high-priority adapter fields. |
| `campaign.start_date`, `campaign.gm_mode` | Setup/options hints | Consumed with caution | Preserve for context if present; avoid over-interpreting option state. | Keep as serialized or method-backed with evidence. |
| `campaign.location.current_system_id`, `current_system_name` | Current system | Consumed hard checkpoint when method-backed | Use for mission/travel context and tactical handoff setup. | Keep. Prefer stable system id plus display name. |
| `campaign.location.current_location`, `travel_state` | Location node, route/base/transit hints | Consumed with caution | Useful GM context; not a travel automation trigger. | Producer should serialize stable display/id fields, not object `toString()` values. Keep warnings for route/base semantics until validated. |
| `finances.balance`, `loan_balance`, `has_active_loans` | Method-backed financial state | Consumed hard checkpoint when method-backed | Surface as ledger context and financial pressure. | Keep method-backed values. Prefer numeric amount plus display string/currency when practical. |
| `finances.recent_transactions` | Recent finance rows | GM-facing context | Useful for audit/recent changes; not enough for broad accounting automation. | Keep optional; include ids/dates/categories when available. |
| `personnel[].id`, `display_name`, `full_title` | Personnel identity | Consumed hard checkpoint | Preserve full MekHQ ids and display titles for PC/NPC linking. | Keep exact IDs and method-backed display fields. |
| `personnel[].rank`, `primary_role`, `secondary_role`, `status`, `unit_id` | Roster role/assignment | Consumed hard checkpoint when method-backed or serialized with evidence | Drive linked PC/NPC sheet refresh, scene availability, and unit crew context. | Keep raw code and label where possible. |
| `personnel[].fatigue`, `hits`, `salary`, `injuries`, `skills` | Personnel condition/pay/capability | Consumed with caution | Good for GM context and discrepancy checks; A Time of War overlays still belong to MEK-RPG. | Keep method-backed fields. Salary/skills/injuries should not be inferred from raw XML when methods exist. |
| `units[].id`, `display_name`, `entity` | Unit identity | Consumed hard checkpoint | Preserve unit cross-references and vehicle/asset context. | Keep entity chassis/model/type/weight and source owner. |
| `units[].status`, `scenario_id`, `crew`, `tech_id`, `engineer_id` | Unit assignment and staffing | Consumed hard checkpoint when method-backed or serialized with evidence | Use for tactical handoff, asset sheets, and mission context. | Keep IDs stable and do not replace with MEK-RPG slugs. |
| `units[].damage_state`, `repair_summary` | Unit condition/readiness summary | Consumed with caution; high-priority GM context | Surface condition and readiness, but do not infer exact armor/internal/crit state. | Keep method-backed summary. If long maintenance reports are emitted, exporter should support compact/sanitized report lines or adapter should truncate for GM display. |
| `units[].transport` | Transport assignments | Consumed with caution | Useful for DropShip/force movement context; not exact cargo/bay authority yet. | Keep warnings until disposable-save/UI validation confirms semantics. |
| `contracts[].id`, `display_name`, `type`, `status`, `system_id`, `system_name`, `employer`, `enemy`, `start_date`, `end_date` | Active contract identity and lifecycle | Consumed hard checkpoint for active saved contracts | Use for campaign objective context and tactical handoff. | Keep integer contract ids and status labels. Deepen employer/enemy/date extraction where prototype currently says `Unknown`. |
| `contracts[].terms`, `scenario_ids` | Contract terms and scenario links | Consumed with caution | Surface payment/salvage/support/transport terms for GM review; do not use to accept/alter contracts. | Deepen method-backed `Contract` getter extraction before schema hardening. |
| `scenarios[].id`, `mission_id`, `display_name`, `status`, `date` | Scenario identity/lifecycle | Consumed hard checkpoint | Use for tactical handoff, pending scenario prompts, and post-battle reconciliation. | Keep status raw code and label. |
| `scenarios[].report`, `player_force`, `bot_forces` | Scenario report/objective/force hints | GM-facing context | Useful for scene setup and handoff, but not a full tactical result import. | Keep sanitized report text and force summaries. Preserve warnings when details are incomplete. |
| `repairs_and_logistics.shopping_list`, `repair_work`, `parts_pressure` | Repair/procurement pressure | GM-facing context | Surface repair and acquisition pressure; do not execute repair or procurement actions. | Keep item/work ids when available. Prefer compact method-backed summaries over verbose raw report text. |
| `repairs_and_logistics.cargo`, `transport_bays` | Cargo/bay pressure | Consumed with caution | Display as advisory logistics pressure only. | Keep `Needs MekHQ inspection` warnings until source/UI validation resolves DropShip assignment edge cases. |
| `markets.unit_offers` | Unit market opportunities | GM-facing context, blocked/unsafe for automation | Display as opportunity context only; no purchase selector. | Keep `id: null`, `stable_selector_available: false`, guard fields, final price provenance, and selector warnings until stable source-confirmed offer IDs exist. |
| `markets.personnel_applicants` | Applicant identities | GM-facing context, blocked/unsafe for automation | Display as hiring opportunities only; no hire command. | Keep applicant ids and role/status fields; keep hire preconditions unsupported until a separate write-side issue exists. |
| `markets.contract_offers` | Contract opportunities | GM-facing context, blocked/unsafe for automation | Display as possible hooks/offers only; no accept/decline command. | Keep offer id/guard fields if present, but accept/decline remains blocked on stable ids, prompt policy, and saved re-import confirmation. |
| `markets.warnings` | Market-wide warnings | Evidence/diagnostic and GM-facing context | Surface when market entries are shown. | Keep warnings mandatory for selector safety. |
| `reports.current`, `technical`, `skill`, `finances`, `acquisitions`, `medical`, `personnel`, `battle`, `politics`, `aggregate` | Sanitized report buckets | GM-facing context | Surface as recent MekHQ alerts after sanitization and prioritization. | Keep bucket names. Producer should sanitize HTML/control content and include `contains_html` or equivalent. Issue `#88` owns display behavior. |
| `reports.warnings` | Report caveats | Evidence/diagnostic and GM-facing context | Surface when reports are shown or omitted. | Keep warnings mandatory. |
| `unsupported[]` | Unsupported fields and blockers | Consumed hard checkpoint as diagnostics | Store and surface so MEK-RPG does not invent missing values. | Keep mandatory. Entries should include `area`, `field`, `reason`, `evidence`, `recommended_owner`, and `blocks_automation`. |

## Blocked Or Unsafe Fields

The following remain blocked even if they appear in checkpoint JSON:

- Market purchase, sale, hire, contract accept/decline, repair assignment, day advancement, tactical-result application, and save/XML mutation commands.
- Unit-market automation selectors while `stable_selector_available` is false or offer `id` is null.
- Contract-market accept/decline until stable offer ids, prompt policy, guard fields, disposable validation, and saved re-import confirmation exist.
- Exact cargo pressure and bay occupancy until source/UI validation resolves transport and DropShip assignment semantics.
- Exact BattleTech tactical state beyond summary condition/readiness. Full tactical handling still belongs to Classic BattleTech, MegaMek, or MekHQ.
- RPG-only overlays: A Time of War stats, secrets, relationships, promises, hooks, title risks, rumors, and scene memory remain MEK-RPG-owned.

## Ignored For Now

No field in the current draft top-level schema should be removed or renamed solely for MEK-RPG. Fields that MEK-RPG does not immediately display, such as optional producer metadata, empty report buckets, recent transaction details, applicant precondition placeholders, and future method-specific diagnostics, may be ignored by campaign-facing adapters while still being preserved in raw adapter diagnostics.

Future producer-specific extension fields should be treated as `Ignored for now` unless they affect one of these trust boundaries:

- source/evidence authority
- stable object identity
- warnings or unsupported fields
- automation blockers
- read-only proof
- user-facing GM context

## Feedback For MegaMek Exporter Hardening

Send these points back before producer-side schema hardening:

1. Keep the current top-level grouping. No rename or removal is requested yet.
2. Preserve `evidence`, `source_owner`, `method_backed`, `warnings`, and `unsupported` throughout the payload.
3. Prioritize method-backed campaign/date/location, finance balance, personnel role/status/condition, unit status/condition/repair summary, active contract terms, scenario status, and sanitized reports.
4. Replace object-string values such as prototype `current_location` output with stable display/id fields.
5. Deepen active contract-term extraction through `Contract` getters before treating contract fields as schema-stable.
6. Keep market offers read-only and display-only. Do not imply purchase/hire/accept selectors until stable source-confirmed IDs and prompt policy exist.
7. Keep unsupported entries mandatory and automation-blocking where appropriate.
8. Prefer compact report and maintenance summaries that are already sanitized for downstream display.

## Adapter Implications

Near-term MEK-RPG adapters should:

- accept explicit JSON paths only
- detect producer/schema version from `bridge_metadata`
- preserve full MekHQ ids rather than generating MEK-RPG ids from them
- carry trust metadata into bridge/context diagnostics
- fail closed or warn when blocked/unsafe fields are missing or ambiguous
- treat market/report/logistics details as GM context unless this map says they are hard checkpoint facts
- avoid writing campaign files automatically from market offers, repair work, or pending action-like data without a separate issue and saved re-import confirmation

This map does not authorize production exporter assumptions. It is consumer-side feedback for issues `#84` through `#89` and should be revisited after MegaMek hardens exporter output.
