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
