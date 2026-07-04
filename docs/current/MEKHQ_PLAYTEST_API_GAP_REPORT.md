# MekHQ Playtest API Gap Report

Status: wired for epic issue `#113` and story issue `#117`.

Purpose: capture every place where MekHQ-linked RPG play needs live MekHQ data that is missing, stale, ambiguous, or unsupported in the open MekHQ local API. During play, agents should update this file immediately instead of parsing the active `.cpnx`, `.cpnx.gz`, XML, or raw save payload as a silent workaround.

## Operating Rule

When MekHQ is open, MEK-RPG play should use `scripts/fetch-mekhq-live-api.ps1` first. The helper captures the live local API into known JSON files:

1. `GET /campaign/summary` for loaded campaign identity and compact status.
2. `GET /campaign/state` with `bridge_metadata` for live read context.
3. `GET /campaign/commands` for read-only command readiness and safe selector discovery.
4. `GET /campaign/pending-deployments` for current scenario/deployment and viewpoint-person commitment lookup.

If a needed read is not available through those API surfaces or the capture manifest records a required-read failure, record the gap here. Raw save parsing remains an explicit offline, legacy, fixture, or debugging fallback only. A user-supplied save path may identify the campaign for the human, but it should not become the normal active-play data source while the live API is available.

## Entry Schema

Use this shape for new findings:

```markdown
### YYYY-MM-DD - short gap title

- Play context:
- Needed data:
- Attempted API read:
- Missing, stale, ambiguous, or unsupported field:
- Why it mattered for play:
- Fallback used:
- Expected read shape:
- Suggested producer/API change:
- Related issue or handoff:
- Status:
```

Field guidance:

- `Play context`: campaign, scene, issue, or rehearsal where the gap appeared.
- `Needed data`: the concrete read the GM needed, such as current location label, personnel injury detail, unit repair status, market selector, contract term, scenario objective, finance warning, or report bucket.
- `Attempted API read`: endpoint and section if known.
- `Fallback used`: should normally be `None`, `asked user`, `kept as Unknown`, `used stale imported campaign-local note with warning`, or `explicit user-approved offline save inspection`.
- `Expected read shape`: describe the field, id, label, list, count, status, warning, or method-backed value that would have avoided the gap.
- `Suggested producer/API change`: phrase as a request for the MekHQ API producer, not as a MEK-RPG save-parser workaround.

## Workflow Guard

The gap-report path is intentionally part of deterministic project verification. `scripts/test-mekhq-api-gap-reporting.ps1` checks that this report keeps the repeatable entry schema and that play startup, linked-play, startup-decision-tree, and helper docs route missing live API reads here instead of treating active-save parsing as the routine workaround.

## Open Findings

### 2026-07-02 - Salvage transport capacity not exposed for recovery planning

- Play context: `Sharpe's Strikers`, 3027-08-16 Butzfleth, while Sharpe considered buying additional salvage/recovery trucks because salvage is driving company profit and current transport may be insufficient.
- Needed data: current salvage/recovery transport capacity, including each recovery vehicle or truck's cargo capacity, towing/recovery capability, salvage loading limits, and whether available flatbeds or BattleMech Recovery Vehicles can carry specific salvaged units or parts.
- Attempted API read: `GET /campaign/state` sections `units`, `transport`, `repairs_and_logistics`, and full unit records for BattleMech Recovery Vehicles, flatbeds, trucks, and support vehicles.
- Missing, stale, ambiguous, or unsupported field: unit records expose availability, crew slots, transport assignment stubs, and carried-unit counts, but not usable cargo capacity, salvage capacity, towing limits, or loading rules. Transport output is explicitly read-only context and does not expose loading, unloading, or reassignment commands.
- Why it mattered for play: the user is evaluating whether buying additional salvage trucks will increase salvage profit enough to justify cost, but the GM cannot quantify current transport bottlenecks from the live API alone.
- Fallback used: used the live roster to confirm current recovery/support vehicle count; kept exact salvage capacity as Unknown.
- Expected read shape: unit transport state should expose cargo capacity, unit transport capacity, towing/recovery capacity, current load, supported load types, and warnings when a unit cannot carry salvaged Meks/vehicles.
- Suggested producer/API change: add transport/cargo capacity fields to `/campaign/state?sections=units,transport` or a dedicated `/campaign/transport-capacity` endpoint.
- Related issue or handoff: epic issue `#113`.
- Status: open.

### 2026-07-01 - DropShip Raid chassis and coordinate-sale transaction not exposed

- Play context: `Sharpe's Strikers`, 3027-03-23 Altorra, after completing MekHQ scenario id `21`, `DropShip Raid`.
- Needed data: exact enemy DropShip chassis/model and a finance transaction confirming the user-reported 5,000,000 C-bill sale of damaged DropShip coordinates.
- Attempted API read: `GET /campaign/state` sections `scenarios`, `finances`, `reports`, `units`, and `unsupported`; `GET /campaign/summary`; local search of the capture files for `Condor`, `coordinates`, `5000000`, `5,000,000`, `DropShip`, and related terms.
- Missing, stale, ambiguous, or unsupported field: the scenario confirms an enemy `Dionysus's Starfire Vikings DropShip` force, 1 unit, 1,978 BV, but does not expose the exact chassis/model in the captured scenario object. The finance endpoint confirms current balance and transaction count but only exposes the last five transactions, none of which show the coordinate sale.
- Why it mattered for play: the user specifically wanted concrete MekHQ facts after a mission where the table understood the target as an enemy Condor DropShip and the coordinates were sold for 5,000,000 C-bills.
- Fallback used: recorded current funds and scenario victory as MekHQ-confirmed; recorded `Condor` chassis and coordinate sale as user/table-reported unless later confirmed by a broader MekHQ finance or scenario export. Did not parse the active save.
- Expected read shape: scenario state should expose resolved bot-force unit summaries with chassis/model/type/BV, and finance state should expose a full or queryable transaction list with date, type, amount, description, and optional linked scenario id.
- Suggested producer/API change: add resolved scenario force-unit details to `/campaign/state?sections=scenarios` or `/campaign/scenarios/{id}/forces`; add paginated or filterable finance transaction export to `/campaign/finances/transactions`.
- Related issue or handoff: epic issue `#113`.
- Status: open.

### 2026-07-01 - Per-unit DropShip maintenance cost history unavailable

- Play context: `Sharpe's Strikers`, 3027-03-13 Altorra, after the user reported that the Mule's maintenance bills were high enough to threaten bankruptcy and that the ship had to be mothballed.
- Needed data: per-unit maintenance cost history for `Mule (2737)`, including maintenance charges over time, monthly cost attribution, whether mothballing stopped or reduced those charges, and any outstanding DropShip-specific upkeep liability.
- Attempted API read: `GET /campaign/state` sections `finances`, `units`, `repairs_and_logistics`, and `reports`; `GET /campaign/summary`; local search of the captured live state for the Mule unit and recent maintenance transactions.
- Missing, stale, ambiguous, or unsupported field: the API exposes current funds, recent transactions, the Mule's current Mothballed status, and a long last-maintenance report, but not a structured per-unit cost ledger or cost attribution history for the Mule.
- Why it mattered for play: Sharpe needs to decide whether to keep the mothballed Mule, ask the Capellans for support, or return the vessel before it bankrupts the company. The GM can see the current cash crisis but not quantify how much of the cash drain came from the Mule through API data alone.
- Fallback used: recorded the bankruptcy pressure and mothballing as user-confirmed table memory; used the live API only for current funds and current Mule status. Did not parse the active save.
- Expected read shape: finance state should expose a unit-linked transaction list or aggregate such as `unit_costs[{unit_id, display_name, period_start, period_end, maintenance_total, repair_total, payroll_total, mothballing_costs, current_month_projection}]`.
- Suggested producer/API change: add unit-linked cost attribution to `/campaign/state?sections=finances,units` or a dedicated `/campaign/finances/unit-costs` endpoint, with clear handling for mothballed and activating units.
- Related issue or handoff: epic issue `#113`.
- Status: open.

### 2026-07-01 - Live local API unavailable during API-first validation

- Play context: issue `#114` API-first MekHQ playtest workflow validation.
- Needed data: live MekHQ campaign availability and current MekHQ-owned context through the local control API before play startup.
- Attempted API read: `GET /status`, `GET /campaign/summary`, `GET /campaign/state?sections=bridge_metadata,campaign,finances,personnel,units,contracts,scenarios,repairs_and_logistics,markets,reports,unsupported`, and `GET /campaign/commands` at `http://127.0.0.1:32180`.
- Missing, stale, ambiguous, or unsupported field: all attempted live reads failed with `Unable to connect to the remote server`; no local MekHQ control server was reachable.
- Why it mattered for play: true live validation cannot prove current MekHQ-owned campaign context without the running local API.
- Fallback used: fixture-backed rehearsal only; no active save, XML, or raw MekHQ payload was parsed.
- Expected read shape: reachable local control API responses for `/status`, `/campaign/summary`, sectioned `/campaign/state` with `bridge_metadata`, and `/campaign/commands`.
- Suggested producer/API change: none from this pass; rerun live validation when MekHQ is open with the local control API enabled.
- Related issue or handoff: issue `#114`, epic issue `#113`.
- Status: blocked on user-present live MekHQ session.

### 2026-06-30 - Salvaged unit inventory not exposed after battle

- Play context: `Sharpe's Strikers`, 3026-06-21 Altorra, after the user reported finishing a battle and salvaging a Warhammer.
- Needed data: confirmation that a Warhammer/WHM was salvaged, including whether it is now a unit, pending salvage item, cargo item, acquisition/recovery work item, or employer-held salvage claim.
- Attempted API read: `GET /campaign/state` sections `units`, `scenarios`, `repairs_and_logistics`, `markets`, `reports`, and `unsupported`; `GET /campaign/summary`; `GET /campaign/pending-deployments`; full-text search of the captured live state for `Warhammer` and `WHM`.
- Missing, stale, ambiguous, or unsupported field: no Warhammer/WHM appears in the live unit list or captured state JSON. Recent completed scenarios expose `salvage_assignments`, but not actual salvage result inventory, salvaged unit identities, disputed salvage claims, or pending recovery items.
- Why it mattered for play: the user believed a Warhammer had been salvaged but could not see it in MekHQ, and the GM needed to know whether to record it as hard ledger state, pending/manual state, or an API gap.
- Fallback used: kept Warhammer salvage as user-reported/table-facing but not MekHQ-confirmed; did not parse the active save.
- Expected read shape: completed scenarios or logistics state should expose a `salvage_results` or `pending_salvage` list with unit id if created, chassis/model, status, owner/claim holder, recovery state, repair state, location, and whether it is visible in the campaign unit roster.
- Suggested producer/API change: add actual salvage inventory/results to `/campaign/state?sections=scenarios,repairs_and_logistics` or a dedicated `/campaign/salvage` endpoint, distinct from salvage assignment teams.
- Related issue or handoff: epic issue `#113`.
- Status: open.

### 2026-06-29 - Active contract reputation impact unavailable

- Play context: `Sharpe's Strikers`, 3025-05-15 Talitha, after `Deep Raid Defense` refused, `Official Challenge` defeated, `Facility Assault` defeated/withdrawn, and during `Recon Evasion`.
- Needed data: current or projected reputation impact, faction-standing delta, employer satisfaction, contract score, or final contract resolution risk from repeated failed/refused scenarios.
- Attempted API read: `GET /campaign/state` sections `contracts`, `scenarios`, and `unsupported`; `GET /campaign/commands`; local search of `mekhq-live-api-capture/*.json` for reputation/standing/satisfaction fields.
- Missing, stale, ambiguous, or unsupported field: active contract exposes status, payment, salvage, and scenario ledger, but no structured current reputation, employer satisfaction, faction-standing delta, or pending reputation impact. Command readiness mentions faction-standing prompts for contract acceptance, but not active contract performance.
- Why it mattered for play: Sharpe specifically wondered what reputation hit the unit might take because the enemy appears to be outperforming the Strikers while the company survives and keeps billing.
- Fallback used: kept reputation hit Unknown; framed it as an in-world command concern rather than a quantified MekHQ ledger value.
- Expected read shape: active contract should expose `employer_satisfaction`, `contract_success_score`, `projected_reputation_delta`, `projected_faction_standing_delta`, `scenario_result_summary`, and warnings when reputation effects are only calculated at contract close.
- Suggested producer/API change: add contract performance/reputation projection fields to `/campaign/state?sections=contracts,scenarios` or a dedicated `/campaign/contracts/{id}/performance` endpoint.
- Related issue or handoff: epic issue `#113`.
- Status: open.

### 2026-07-02 - Reputation and XP change history unavailable

- Play context: `Sharpe's Strikers`, 3027-08-20 Butzfleth, after Sharpe noticed improved reputation and experience on the campaign board and tried to trace what caused the rise.
- Needed data: current campaign/unit reputation value, faction standing, employer standing, Sharpe's XP change history, XP award sources, award dates, and a ledger tying reputation or XP increases to scenarios, contracts, education, command events, or manual GM adjustments.
- Attempted API read: `GET /campaign/state` sections `bridge_metadata`, `campaign`, `contracts`, `scenarios`, `personnel`, and `unsupported`; `GET /campaign/summary`; `GET /campaign/commands`; `GET /personnel/{id}` detail through `scripts/fetch-mekhq-live-api.ps1`; local search of captured JSON for reputation, standing, experience, and XP terms.
- Missing, stale, ambiguous, or unsupported field: the API exposes current personnel XP, skills, awards count, contract status, scenario results, salvage totals, and campaign balance, but no numeric reputation/standing field and no structured XP or reputation delta history.
- Why it mattered for play: Sharpe could see that the unit and commander had improved, but the GM needed to identify whether the rise came from command school, battle results, contract success, salvage, awards, or another MekHQ-owned event.
- Fallback used: traced the rise circumstantially from visible MekHQ facts: command school completion on 3027-05-22, skill gains, current XP 50/50, eight awards, active Butzfleth victories, prior successful contracts, and strong salvage/profit results. Kept exact reputation value and exact XP source ledger Unknown.
- Expected read shape: expose `campaign_reputation`, `faction_standings[]`, `employer_standing`, `reputation_history[]`, and personnel `xp_history[]` entries with date, amount, source type, source id/name, manual flag, and notes.
- Suggested producer/API change: add reputation/standing fields to `/campaign/state?sections=campaign,contracts` and add XP/reputation audit histories to personnel detail or dedicated `/campaign/reputation/history` and `/personnel/{id}/xp-history` endpoints.
- Related issue or handoff: epic issue `#113`.
- Status: open.

### 2026-07-02 - Assigned player force BV unavailable in pending deployment read

- Play context: `Sharpe's Strikers`, 3027-09-01 Butzfleth, reviewing pending scenario `29`, `MekBase - Allied - Defend`, before continuing RPG play.
- Needed data: total BV for the assigned Strikers player force, plus per-assigned-unit BV for Catapult CPLT-C1, Griffin GRF-1N, Wolverine WVR-6R, Jenner JR7-D, Stinger STG-3R, Wasp WSP-1A #2, Locust LCT-1V, Shadow Hawk SHD-2H, Grasshopper GHR-5H, two Warhammer WHM-6R entries, and Manticore Heavy Tank.
- Attempted API read: `GET /campaign/pending-deployments`, `GET /campaign/state` sections `scenarios` and `units`, and local inspection of assigned unit objects in `mekhq-state.json`.
- Missing, stale, ambiguous, or unsupported field: bot force BV is exposed for allied and enemy forces, but the assigned player units in pending deployments and unit list do not expose per-unit BV or a summed player-force BV.
- Why it mattered for play: the user asked how the current operation's BV looks before deciding how to frame the engagement and RPG consequences.
- Fallback used: reported exact exposed bot-force BV and marked Strikers assigned-force BV as not exposed by the current API, while listing the assigned units and their qualitative weight.
- Expected read shape: pending scenario should expose `player_force_total_bv` and assigned-unit `battle_value` fields alongside `bot_forces[].total_bv`.
- Suggested producer/API change: add per-unit and aggregate BV to `/campaign/pending-deployments` and `/campaign/state?sections=scenarios,units` for assigned player forces.
- Related issue or handoff: epic issue `#113`.
- Status: open.

### 2026-07-04 - Current salvage sale itemization unavailable

- Play context: `Sharpe's Strikers`, 3027-11-22 Wallacia, after the user reported completing a battle, receiving salvage, and selling it.
- Needed data: exact salvaged items/units from the latest battle, which salvage was retained versus sold, sale transaction lines, buyer/employer allocation, and sale value by item.
- Attempted API read: `GET /campaign/state` sections `contracts`, `scenarios`, `finances`, `units`, `repairs_and_logistics`, and `reports`; `GET /campaign/pending-deployments`; local search of the captured live API JSON for salvage and sale terms.
- Missing, stale, ambiguous, or unsupported field: the active contract exposes aggregate salvage value by unit/employer, and finances expose current balance plus the five most recent transactions, but the exact salvage sale line and itemized sold salvage are not exposed in the current capture.
- Why it mattered for play: the user wanted to verify that recent salvage/sales are making the Wallacia contract highly profitable and understand what changed after the battle.
- Fallback used: reported confirmed aggregate ledger facts only: Wallacia contract salvage by unit is 2,757,103 C-bills, salvage by employer is 1,732,502 C-bills, current salvage percent is 62, current funds are 44,806,926 C-bills, and recent visible transactions do not include the sale itemization.
- Expected read shape: expose a salvage ledger with scenario id, item/unit id, chassis/item name, disposition retained/sold/employer, sale value, transaction id/date, and whether the proceeds are included in contract `salvaged_by_unit`.
- Suggested producer/API change: add `/campaign/salvage` or extend scenario/finance exports with itemized salvage-result and sale records, not just aggregate contract salvage values.
- Related issue or handoff: epic issue `#113`.
- Status: open.

### 2026-06-29 - Committed scenario opposition force details unavailable

- Play context: `Sharpe's Strikers`, 3025-05-13 Talitha, with Alpha Lance committed to `Facility Assault` and Bravo Lance committed to `Recon Evasion`.
- Needed data: exact known opposition force composition for committed pending scenarios, including enemy unit list, total BV, bot force labels, pilots if known, deployment zones, allied reinforcement details, and fog-of-war confidence.
- Attempted API read: `GET /campaign/state` section `scenarios`; `GET /campaign/pending-deployments`; `GET /campaign/summary`; local capture files under `mekhq-live-api-capture/`.
- Missing, stale, ambiguous, or unsupported field: scenario descriptions expose narrative opposition hints, but no structured `opfor_units`, `bot_forces`, `opfor_total_bv`, `known_enemy_units`, `allied_reinforcements`, or deployment/visibility fields for scenario ids `1` and `7`.
- Why it mattered for play: the user specifically asked what is known about opposition forces for the two committed scenarios before resolving or framing the fights.
- Fallback used: kept exact OpFor as Unknown; used scenario description hints only.
- Expected read shape: each committed/pending scenario should expose a bounded `scenario_intel` object with `known_enemy_units`, `estimated_enemy_units`, `opfor_total_bv`, `bot_force_summaries`, `known_allied_units`, `deployment_zones`, `visibility_confidence`, and warnings when double blind or fog-of-war intentionally withholds detail.
- Suggested producer/API change: add scenario intel fields to `/campaign/pending-deployments` or a dedicated `/campaign/scenarios/{id}/intel` endpoint, with explicit hidden/unknown markers rather than absent fields.
- Related issue or handoff: epic issue `#113`.
- Status: open.

### 2026-06-27 - Pending scenario OpFor BV unavailable during mission intel review

- Play context: `Sharpe's Strikers`, 3025-02-14 Alioth nadir jump point, Sharpe reviewing upcoming Talitha pending scenarios before arrival.
- Needed data: OpFor battle value, enemy force composition, and bot force summaries for pending scenarios `Facility Assault` and `VIP Ambush`.
- Attempted API read: `GET /campaign/state` section `scenarios`; `GET /campaign/pending-deployments`; local capture file `mekhq-live-api-capture-sharpes-strikers/mekhq-state.json`.
- Missing, stale, ambiguous, or unsupported field: `bot_forces`, `bot_force_stubs`, and `objectives` are empty; no OpFor BV, enemy unit list, total BV, or estimated force-balance field is exposed for either pending scenario.
- Why it mattered for play: the commander explicitly tried to compare mission risk by OpFor BV before deciding which pending alert deserved planning priority.
- Fallback used: kept OpFor BV as Unknown; used scenario type, map, environmental conditions, and assignment status only.
- Expected read shape: each pending scenario should expose method-backed OpFor summary fields such as `opfor_total_bv`, `opfor_unit_count`, `opfor_force_stubs`, `known_enemy_units`, `enemy_weight_classes`, `confidence`, and warnings when cloaking/fog-of-war intentionally hides details.
- Suggested producer/API change: add bounded scenario force-intel/BV fields to `/campaign/state?sections=scenarios` or a dedicated `/campaign/scenarios/{id}/intel` endpoint, including clear fog-of-war or hidden-force warnings.
- Related issue or handoff: epic issue `#113`.
- Status: open.

### 2026-06-26 - Summary endpoint timed out while checking Double-M deployment commitment

- Play context: `The Learning Ropes`, Ildlandet briefing for current back-to-back tank-base defense and insurgency operations.
- Needed data: summary-level indication of which pending operation Michelle "Double-M" Moreno is already committed to, plus scenario/unit/personnel assignment details if summary was insufficient.
- Attempted API read: `GET /campaign/summary` with 15-second and 60-second timeouts; `GET /campaign/state?sections=bridge_metadata,campaign,scenarios,units,personnel,reports`; and `GET /campaign/commands`.
- Missing, stale, ambiguous, or unsupported field: all attempted reads timed out during this pass, including the usually lightweight summary endpoint.
- Why it mattered for play: the GM needed current MekHQ-owned deployment commitment before framing Double-M's briefing and command role.
- Fallback used: none; did not infer the commitment from stale campaign notes.
- Expected read shape: a fast summary or deployment endpoint exposing current pending scenarios and personnel/unit commitments, including the viewpoint character's assigned operation.
- Suggested producer/API change: keep `/campaign/summary` bounded and responsive under loaded campaign state, or add a dedicated lightweight deployment/commitment summary endpoint.
- Related issue or handoff: epic issue `#113`.
- Status: open.

### 2026-06-26 - Play-mode startup can still invite save-first behavior

- Play context: user-reported Mech RPG play sessions before epic issue `#113`.
- Needed data: all MekHQ-owned live campaign context for an open MekHQ session.
- Attempted API read: expected `GET /campaign/summary`, `GET /campaign/state` with `bridge_metadata`, and `GET /campaign/commands`.
- Missing, stale, ambiguous, or unsupported field: not a single field; the startup SOP was not strong enough in top-level play instructions.
- Why it mattered for play: agents could reach for save-derived context even though the intended loaded-campaign source is the open MekHQ API connection.
- Fallback used: planning correction; no raw save inspection was performed for this report entry.
- Expected read shape: a required play startup checklist that reaches the live API first and treats missing reads as API gaps.
- Suggested producer/API change: none yet; this is a MEK-RPG workflow hardening gap.
- Related issue or handoff: epic issue `#113`, story issues `#114`, `#115`, `#116`, and `#117`.
- Status: open until the child issues audit and validate the fixed workflow.

## Closed Findings

No closed findings yet.
