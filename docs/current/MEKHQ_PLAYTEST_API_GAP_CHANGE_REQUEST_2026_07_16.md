# MekHQ Playtest API Gap Change Request - 2026-07-16

Status: handoff-ready MEK-RPG request package derived from live play gap reports.

Audience: MegaMek / MekHQ team maintaining the local read-only and guarded-command API at `http://127.0.0.1:32180`.

Source workspace: `C:\Users\waltr\Documents\mek-rpg`

Primary source: `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`, open findings recorded through 2026-07-16.

## Summary

MEK-RPG uses the MekHQ local API as the normal source of MekHQ-owned live campaign facts during play. The current API already supports useful campaign identity, roster, unit, contract, scenario, report, pending-deployment, and command-readiness reads. The remaining live-play blockers are not broad "export everything" requests. They cluster into a few focused API needs:

1. Scenario intel, force requirements, and player/OpFor BV for pending or committed operations.
2. Salvage, finance, reputation, XP, and per-unit cost ledgers with enough history to explain recent campaign changes.
3. Inventory, spare-parts mass, cargo, and recovery transport capacity for strategic lift and salvage planning.
4. Personnel turnover history and HR/admin pressure indicators.
5. Bounded, responsive lightweight reads and partial-response behavior when collectors are slow.

The goal is to keep MEK-RPG from parsing active `.cpnx`, `.cpnx.gz`, XML, or raw save payloads during live play. When MekHQ owns a fact, the live local API should expose it directly, expose an explicit `unknown` or `withheld` marker, or return a structured unsupported entry that can become a producer ticket.

## Non-Goals

- No direct MEK-RPG edits to MekHQ saves or XML.
- No request for MEK-RPG to inspect raw active saves as a routine workaround.
- No broad arbitrary writeback or mutation endpoint.
- No requirement to reveal hidden scenario data that MekHQ intentionally withholds for fog of war; explicit hidden/unknown markers are sufficient.
- No pagination requirement for the first personnel assignment read/query design tracked separately in issue `#152`, unless producer constraints require it later.

## Priority 1: Scenario Intel And Deployment Planning

Related gap entries:

- `2026-07-16 - Pending tank-base enemy unit identities unavailable`
- `2026-07-04 - Contract force-type requirements not exposed before deployment planning`
- `2026-07-02 - Assigned player force BV unavailable in pending deployment read`
- `2026-06-29 - Committed scenario opposition force details unavailable`
- `2026-06-27 - Pending scenario OpFor BV unavailable during mission intel review`

Live play repeatedly needs to answer "what are we about to fight, what are we allowed or required to deploy, and how does the assigned force compare?" The current payloads sometimes expose bot-force aggregate BV and count, but not enough structured detail to distinguish heavy Meks, armor, hovercraft, carriers, infantry, aerospace, or mixed forces. Player-force BV is also missing even when assigned units are listed.

Suggested API shape:

```text
GET /campaign/pending-deployments
GET /campaign/scenarios/{scenarioId}/intel
GET /campaign/state?sections=scenarios,contracts,units
```

Requested fields:

- `scenario_id`, `contract_id`, `status`, `date`, `scenario_name`, `scenario_type`
- `deployment_requirements` with required/allowed unit roles, min/max unit counts, lance count, weight/BV constraints, employer support requirements, and unknown markers
- `player_force_total_bv`
- `assigned_player_units[]` with unit id, display name, chassis/model, unit type, weight class, role, battle value, crew/personnel ids, and deployment status
- `bot_forces[]` with force id/name, affiliation, template name, total BV, full entity count, visible entity count, and force role
- `bot_forces[].known_entities[]` when MekHQ allows disclosure, with unit id if available, display name, chassis/model, unit type, movement profile, weight class, battle value, and pilot if known
- `bot_forces[].estimated_summary` when exact entities are hidden, with counts by unit type, weight class, movement profile, and confidence
- `visibility_confidence`, `fog_of_war_policy`, `hidden_reason`, and `unknown_fields[]`
- terrain, weather, objectives, deployment edges/zones, and allied reinforcement summaries when already known to MekHQ

Acceptance target:

MEK-RPG can produce a mission-intel brief from API data alone, while preserving fog-of-war limits as explicit `hidden`, `estimated`, or `unknown` states instead of absent fields.

## Priority 2: Salvage, Finance, Reputation, XP, And Cost Ledgers

Related gap entries:

- `2026-07-04 - Current salvage sale itemization unavailable`
- `2026-07-02 - Reputation and XP change history unavailable`
- `2026-07-01 - DropShip Raid chassis and coordinate-sale transaction not exposed`
- `2026-07-01 - Per-unit DropShip maintenance cost history unavailable`
- `2026-06-30 - Salvaged unit inventory not exposed after battle`
- `2026-06-29 - Active contract reputation impact unavailable`

Play often needs to explain why the command's finances, salvage position, reputation, or commander XP changed. Current state reads can expose current balance, aggregate salvage values, scenario results, and current personnel XP, but not itemized salvage results, sale transactions, full finance history, per-unit cost attribution, or XP/reputation deltas.

Suggested API shapes:

```text
GET /campaign/finances/transactions
GET /campaign/finances/unit-costs
GET /campaign/salvage
GET /campaign/contracts/{contractId}/performance
GET /campaign/reputation/history
GET /campaign/personnel/{personId}/xp-history
GET /campaign/scenarios/{scenarioId}/forces
```

Requested fields:

- Finance transactions: transaction id, date, type, amount, description, linked unit id, linked contract id, linked scenario id, linked salvage item id, and source event/report id
- Unit costs: unit id, display name, period, maintenance total, repair total, payroll total, mothballing or activation cost, current-month projection, and relevant report ids
- Salvage ledger: scenario id, item/unit id, chassis or item name, condition, owner/claim holder, disposition retained/sold/employer, sale value, transaction id/date, and whether proceeds are included in contract aggregates
- Scenario force resolution: exact enemy or allied entity details after battle when no longer hidden, including chassis/model/type/BV
- Contract performance: employer satisfaction, contract success score, scenario result summary, projected or final reputation delta, and projected or final faction-standing delta
- Reputation/XP history: current reputation/standing values plus dated delta entries with amount, source type, source id/name, manual flag, and notes

Acceptance target:

MEK-RPG can answer "what changed and why?" for finance, salvage, reputation, and XP without treating user memory or stale imported notes as MekHQ-confirmed ledger facts.

## Priority 3: Inventory, Cargo, And Transport Capacity

Related gap entries:

- `2026-07-12 - Spare-parts inventory mass unavailable for strategic lift planning`
- `2026-07-02 - Salvage transport capacity not exposed for recovery planning`

Strategic planning needs total spare-parts, ammunition, armor, equipment, and cargo mass, plus usable transport and recovery capacity. Current transport output warns that capacity math is not exposed, and the state read does not expose actual warehouse inventory or total cargo mass/value.

Suggested API shapes:

```text
GET /campaign/inventory
GET /campaign/transport-capacity
GET /campaign/state?sections=inventory,transport,repairs_and_logistics,units
```

Requested fields:

- Inventory rows: item id, name, category, count, mass per item, total mass, value, quality, tech rating, location/storage owner, assigned unit if any, and stranded/loaded/warehouse status
- Inventory aggregates: total inventory tons, total inventory value, ammo tons, armor tons, parts tons, equipment tons, cargo tons, and cargo-space usage if MekHQ tracks volume separately
- Transport capacity rows: unit id, display name, transport type, cargo capacity, unit transport capacity, towing or recovery capacity, supported load types, current load, remaining capacity, and cannot-carry warnings
- Recovery-specific fields for flatbeds, recovery vehicles, trucks, and support units when salvage loading differs from ordinary cargo

Acceptance target:

MEK-RPG can support DropShip/logistics planning and salvage-recovery purchasing decisions from live MekHQ facts, with exact capacity marked `unknown` only when MekHQ itself does not track it.

## Priority 4: Personnel Turnover And HR/Admin Pressure

Related gap entry:

- `2026-07-04 - Personnel turnover history and departure reasons unavailable`

Current personnel records show current roster facts, but play sometimes needs the history behind roster changes: who left, when, why, and whether there is an HR/admin capacity pressure behind turnover.

Suggested API shapes:

```text
GET /campaign/personnel/history
GET /campaign/state?sections=personnel,reports
```

Requested fields:

- `personnel_turnover[]` with date, person id, name, role, old status, new status, departure reason, source event/report id, and whether the person was fired, resigned, retired, died, became a background character, or was cleaned up
- `admin_hr_pressure` with required HR/admin capacity, assigned capacity, unmet demand, recent turnover count, morale/retention warnings if MekHQ tracks them, and unknown markers where it does not

Acceptance target:

MEK-RPG can distinguish "MekHQ confirms this person departed for this reason" from "current roster no longer shows them and the cause is unknown."

## Priority 5: Reliability, Lightweight Reads, And Partial Responses

Related gap entry:

- `2026-06-26 - Summary endpoint timed out while checking Double-M deployment commitment`

The existing reliability handoff `docs/current/MEGAMEK_API_RELIABILITY_HANDOFF_2026-06-26.md` remains valid. The most important play-facing requirement is that lightweight reads stay bounded enough to use during a live scene.

Requested behavior:

- Keep `GET /campaign/summary` bounded and consistently responsive.
- Keep `GET /campaign/commands` bounded and safe for readiness checks.
- Make `sections=` filtering lazy or bounded so a narrow state request does not traverse unrelated expensive collectors.
- Return partial data with structured warnings when optional collectors fail or time out.
- Include collector timing or failure metadata so consumers can distinguish "data unavailable" from "collector slow" from "feature unsupported."
- Provide purpose-built lightweight endpoints for deployment commitment, scenario intel, personnel/unit assignment summary, current reports, repair pressure, and command readiness where full state is too heavy.

Acceptance target:

The GM can obtain campaign identity, date, pending operations, selected-person or viewpoint commitment, unit/repair pressure, and command readiness quickly enough to avoid stale-note fallbacks during live play.

## MEK-RPG Internal Gap

The `2026-06-26 - Play-mode startup can still invite save-first behavior` entry is an internal MEK-RPG workflow hardening item, not a producer API request. MEK-RPG docs now route live play through:

```powershell
./scripts/fetch-mekhq-live-api.ps1 -OutputDirectory .\mekhq-live-api-capture
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view play-context --format text
```

Missing reads should continue to be recorded in `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md` instead of triggering routine active-save parsing.

## Suggested Producer-Side Ticket Split

1. Scenario intel and force BV export for pending/current scenarios.
2. Contract and scenario deployment requirement export.
3. Salvage ledger and itemized salvage sale export.
4. Finance transaction history and per-unit cost attribution.
5. Reputation, faction-standing, and personnel XP history export.
6. Inventory, cargo mass, and transport/recovery capacity export.
7. Personnel turnover/history and HR/admin pressure export.
8. Lightweight endpoint reliability and partial-response behavior.

These can be implemented independently. Scenario intel and force BV appear to have the highest immediate play impact because they affect every mission-planning scene.

## Related Local Tracking

- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`
- `docs/current/MEGAMEK_API_RELIABILITY_HANDOFF_2026-06-26.md`
- `docs/current/MEGAMEK_LIVE_API_CHANGE_REQUEST.md`
- `docs/current/RICH_CHARACTER_MEKHQ_API_NEEDS.md`
- `docs/current/MEKHQ_COMMAND_API_STRATEGY.md`
- `docs/current/MEKHQ_LIVE_API_QUERY_VIEW_CONTRACT.md`
- Issue `#113`: MekHQ API-first playtest hardening epic
- Issue `#152`: personnel assignment read/query and guarded reassignment workflow

## Boundary

This document is a MEK-RPG-side change request package. It is intended to be copied, linked, or summarized into the MegaMek/MekHQ workflow. It does not authorize MEK-RPG agents to edit the MegaMek workspace or to replace live API reads with routine active-save parsing.
