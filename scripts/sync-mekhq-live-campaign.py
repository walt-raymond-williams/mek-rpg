#!/usr/bin/env python3
"""Create or refresh MEK-RPG campaign context from MekHQ live API state JSON.

This helper consumes captured GET /campaign/state JSON with bridge_metadata
included. It never opens a MekHQ save path and treats the payload as live
context, not as a durable checkpoint import.
"""

from __future__ import annotations

import argparse
import json
import re
import shutil
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


API_MODE = "local-read-only-live-context"
EVIDENCE_LIVE = "Confirmed from MekHQ live API"
EVIDENCE_UNKNOWN = "Unknown"
MAX_LIST_ITEMS = 20


def repo_root() -> Path:
    return Path(__file__).resolve().parents[1]


def validate_campaign_id(campaign_id: str) -> None:
    if campaign_id == "_template":
        raise ValueError("Campaign id '_template' is reserved.")
    if not re.match(r"^[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$", campaign_id):
        raise ValueError(
            "Campaign id must use lowercase letters, numbers, and hyphens, with no leading or trailing hyphen."
        )


def load_state(path: Path) -> dict[str, Any]:
    suffix = path.suffix.lower()
    if suffix in {".cpnx", ".gz", ".xml"}:
        raise ValueError("Live API input must be captured sanitized JSON, not a raw MekHQ save or XML file.")
    with path.open("r", encoding="utf-8-sig") as handle:
        state = json.load(handle)
    if not isinstance(state, dict):
        raise ValueError("Live API JSON must be a top-level object.")
    meta = state.get("bridge_metadata")
    if not isinstance(meta, dict):
        raise ValueError("Live API JSON is missing bridge_metadata; request it in GET /campaign/state.")
    if meta.get("api_mode") != API_MODE:
        raise ValueError(f"Live API bridge_metadata.api_mode must be {API_MODE}.")
    if meta.get("read_only") is not True:
        raise ValueError("Live API bridge_metadata.read_only must be true.")
    return state


def raw_value(raw: Any, default: Any = None) -> Any:
    if isinstance(raw, dict) and "value" in raw:
        return raw.get("value", default)
    return raw if raw is not None else default


def text(raw: Any, default: str = "Unknown") -> str:
    raw = raw_value(raw, default)
    if raw is None:
        return default
    if isinstance(raw, str):
        stripped = raw.strip()
        return stripped if stripped else default
    if isinstance(raw, bool):
        return "true" if raw else "false"
    if isinstance(raw, dict):
        label = raw.get("label") or raw.get("full_name") or raw.get("short_name") or raw.get("name")
        if label:
            return text(label, default)
        return json.dumps(raw, ensure_ascii=False, sort_keys=True)
    if isinstance(raw, list):
        if not raw:
            return default
        return ", ".join(text(item, default) for item in raw)
    return str(raw)


def display_name(item: Any, default: str = "Unknown") -> str:
    if isinstance(item, dict):
        return text(item.get("display_name") or item.get("name") or item.get("label") or item.get("value"), default)
    return text(item, default)


def summarize_value(raw: Any, keys: list[str] | None = None, default: str = "Unknown") -> str:
    value = raw_value(raw, default)
    if value is None:
        return default
    if isinstance(value, dict):
        selected_keys = keys or [
            key
            for key in value.keys()
            if key not in {"source_owner", "warnings", "evidence", "method_backed"}
        ]
        parts: list[str] = []
        for key in selected_keys:
            if key not in value:
                continue
            item = value.get(key)
            if isinstance(item, (dict, list)):
                rendered = display_name(item)
            else:
                rendered = text(item)
            if rendered != "Unknown":
                parts.append(f"{key.replace('_', ' ')}: {rendered}")
        return "; ".join(parts) if parts else default
    if isinstance(value, list):
        if not value:
            return default
        rendered_items = [display_name(item) for item in value[:5]]
        suffix = f"; +{len(value) - 5} more" if len(value) > 5 else ""
        return "; ".join(rendered_items) + suffix
    return text(value, default)


def count_items(raw: Any) -> int:
    if isinstance(raw, list):
        return len(raw)
    return 0


def label(raw: Any, default: str = "Unknown") -> str:
    if isinstance(raw, dict):
        return text(raw.get("label") or raw.get("value") or raw.get("raw_code"), default)
    return text(raw, default)


def bool_value(raw: Any, default: bool | None = None) -> bool | None:
    value = raw_value(raw, default)
    if isinstance(value, bool):
        return value
    if isinstance(value, str):
        lowered = value.strip().lower()
        if lowered in {"true", "yes", "available", "active"}:
            return True
        if lowered in {"false", "no", "unavailable", "inactive"}:
            return False
    return default


def person_is_playable(person: dict[str, Any]) -> bool:
    status = label(person.get("status")).lower()
    availability = bool_value(person.get("availability"), None)
    return status == "active" and availability is not False


def build_viewpoint(person: dict[str, Any], reason: str) -> dict[str, Any]:
    status = label(person.get("status"))
    availability = bool_value(person.get("availability"), None)
    playable = person_is_playable(person)
    return {
        "kind": "mekhq_person",
        "display_name": text(person.get("display_name")),
        "mekhq_person_id": text(person.get("id") or person.get("mekhq_person_id")),
        "person": person,
        "reason": reason,
        "source": EVIDENCE_LIVE,
        "mekhq_status": status,
        "mekhq_available": availability,
        "playable": playable,
        "play_guard": ""
        if playable
        else f"MekHQ marks this person as {status}; do not frame them as living or available except for flashback, memorial, or administrative record scenes.",
    }


def slugify(value: str, fallback: str) -> str:
    result = re.sub(r"[^a-z0-9]+", "-", value.lower()).strip("-")
    return result or fallback


def display_path(path: Path) -> str:
    try:
        return path.relative_to(repo_root()).as_posix()
    except ValueError:
        return "External captured live API JSON (not committed)"


def live_evidence(raw: Any) -> str:
    if isinstance(raw, dict):
        return text(raw.get("evidence"), EVIDENCE_LIVE)
    return EVIDENCE_LIVE


def campaign_name(state: dict[str, Any]) -> str:
    return text(state.get("campaign", {}).get("name"), "MekHQ Live Campaign")


def campaign_id_value(state: dict[str, Any]) -> str:
    return text(state.get("campaign", {}).get("id"))


def campaign_date(state: dict[str, Any]) -> str:
    return text(state.get("campaign", {}).get("date"))


def location_name(state: dict[str, Any]) -> str:
    location = state.get("campaign", {}).get("location", {})
    return text(location.get("current_system_name") or location.get("current_location_name") or location.get("current_system_id"))


def funds_text(state: dict[str, Any]) -> str:
    finances = state.get("finances", {})
    balance = finances.get("balance")
    if balance is not None:
        return text(balance)
    return "Unknown"


def choose_viewpoint(
    state: dict[str, Any],
    person_id: str | None,
    viewpoint_name: str | None,
    embedded_pc_name: str | None,
) -> dict[str, Any]:
    if embedded_pc_name:
        return {
            "kind": "embedded_pc",
            "display_name": embedded_pc_name,
            "mekhq_person_id": "None",
            "reason": "Embedded A Time of War PC requested; not linked to MekHQ personnel yet.",
            "source": EVIDENCE_UNKNOWN,
            "mekhq_status": "Unlinked",
            "mekhq_available": None,
            "playable": True,
            "play_guard": "",
        }

    personnel = state.get("personnel", [])
    if not isinstance(personnel, list):
        personnel = []

    if person_id:
        for person in personnel:
            if text(person.get("id") or person.get("mekhq_person_id")) == person_id:
                return build_viewpoint(person, "Matched requested MekHQ live API personnel id.")
        raise ValueError(f"No MekHQ live API personnel found for id: {person_id}")

    if viewpoint_name:
        target = viewpoint_name.lower()
        for person in personnel:
            if text(person.get("display_name")).lower() == target:
                return build_viewpoint(person, "Matched requested MekHQ live API personnel display name.")
        raise ValueError(f"No MekHQ live API personnel found with display name: {viewpoint_name}")

    if personnel:
        for person in personnel:
            if person_is_playable(person):
                return build_viewpoint(person, "Selected first active and available MekHQ live API personnel record.")
        return build_viewpoint(
            personnel[0],
            "No active and available MekHQ personnel were found; retained the first personnel record for audit context only.",
        )

    return {
        "kind": "embedded_pc",
        "display_name": "Embedded A Time of War PC",
        "mekhq_person_id": "None",
        "reason": "No MekHQ live API personnel records were available.",
        "source": EVIDENCE_UNKNOWN,
        "mekhq_status": "Unlinked",
        "mekhq_available": None,
        "playable": True,
        "play_guard": "",
    }


def collect_api_gaps(state: dict[str, Any]) -> list[dict[str, str]]:
    gaps: list[dict[str, str]] = []

    def require(path: str, value: Any, reason: str) -> None:
        if text(value) == "Unknown":
            gaps.append(
                {
                    "area": path.rsplit(".", 1)[0] if "." in path else path,
                    "field": path,
                    "reason": reason,
                    "recommended_owner": "MegaMek/MekHQ live API",
                    "blocks_automation": "false",
                }
            )

    campaign = state.get("campaign", {}) if isinstance(state.get("campaign"), dict) else {}
    location = campaign.get("location", {}) if isinstance(campaign.get("location"), dict) else {}
    finances = state.get("finances", {}) if isinstance(state.get("finances"), dict) else {}

    require("campaign.id", campaign.get("id"), "Live campaign id is needed for identity checks.")
    require("campaign.name", campaign.get("name"), "Live campaign name is needed for table-facing setup.")
    require("campaign.date", campaign.get("date"), "Live campaign date is needed before play.")
    require(
        "campaign.location.current_system_name",
        location.get("current_system_name") or location.get("current_location_name") or location.get("current_system_id"),
        "Human-readable current location/system is needed for scene setup.",
    )
    require("finances.balance", finances.get("balance"), "Method-backed balance is useful for campaign context.")

    for entry in state.get("unsupported", []):
        if not isinstance(entry, dict):
            continue
        gaps.append(
            {
                "area": text(entry.get("area")),
                "field": text(entry.get("field")),
                "reason": text(entry.get("reason"), "Unsupported live API field."),
                "recommended_owner": text(entry.get("recommended_owner"), "MegaMek/MekHQ live API"),
                "blocks_automation": text(entry.get("blocks_automation"), "false"),
            }
        )

    return gaps


def render_overview(campaign_id: str, state: dict[str, Any], viewpoint: dict[str, Any]) -> str:
    return f"""# Campaign Overview

Campaign name: {campaign_name(state)}

Campaign id: {campaign_id}

Status: MekHQ-linked live API context

Canon status: MekHQ live context plus MEK-RPG overlays

Setting seed: `campaign-state/setting-basics.md`

## Table Frame

- Era: Needs user decision
- Starting date: {campaign_date(state)} ({EVIDENCE_LIVE}; live context only)
- Starting region: {location_name(state)} ({EVIDENCE_LIVE}; live context only)
- Player unit concept: Active loaded MekHQ campaign force; refine for table play.
- Viewpoint character: {viewpoint["display_name"]} ({viewpoint["reason"]})
- Tone: Needs user decision
- Canon strictness: Guided canon until decided
- Tactical handoff: use Classic BattleTech, MegaMek, or MekHQ when hex-scale unit combat matters.

## MekHQ Link

- Bridge file: `mekhq-bridge.md`
- API gap file: `mekhq-api-gaps.md`
- MekHQ campaign id: `{campaign_id_value(state)}`
- Live API status: read-only `{text(state.get("bridge_metadata", {}).get("read_only"))}`, mode `{text(state.get("bridge_metadata", {}).get("api_mode"))}`
- Live API snapshot: `{text(state.get("bridge_metadata", {}).get("snapshot_id") or state.get("bridge_metadata", {}).get("state_revision"))}`
- Ownership boundary: MekHQ owns hard logistics, calendar, rosters, finances, contracts, scenarios, markets, repairs, and tactical ledger state. MEK-RPG owns scenes, A Time of War overlays, relationships, promises, secrets, hooks, and session memory.

## Resume Summary

Begin play inside the active loaded MekHQ campaign day. Treat the API payload as live context until a save/import checkpoint, explicit user approval, or a future controlled promotion flow makes a value durable.

## Open Setup Questions

- Confirm the table-facing campaign premise and tone.
- Confirm whether the selected viewpoint is the initial PC, a temporary camera character, or a commander briefing role.
- Fill A Time of War sheet details, Edge, XP, traits, personality, private goals, secrets, and relationship notes as MEK-RPG-only overlays.
"""


def render_current_state(state: dict[str, Any], viewpoint: dict[str, Any]) -> str:
    if viewpoint.get("playable", True):
        current_party = (
            f"- {viewpoint['display_name']} - viewpoint character; MekHQ person id `{viewpoint['mekhq_person_id']}`; "
            f"MekHQ status `{viewpoint.get('mekhq_status', 'Unknown')}`; availability `{text(viewpoint.get('mekhq_available'))}`; RPG details sparse/TBD."
        )
    else:
        current_party = (
            "- No active live viewpoint is selected from MekHQ personnel.\n"
            f"- Unavailable reference: {viewpoint['display_name']} (`{viewpoint['mekhq_person_id']}`); "
            f"MekHQ status `{viewpoint.get('mekhq_status', 'Unknown')}`; availability `{text(viewpoint.get('mekhq_available'))}`. "
            f"{viewpoint.get('play_guard')}"
        )
    return f"""# Current State

Current date: {campaign_date(state)} ({EVIDENCE_LIVE}; MekHQ-owned; live context only)

Current location: {location_name(state)} ({EVIDENCE_LIVE}; MekHQ-owned; live context only)

Active scene: Pre-session checkpoint for MekHQ-linked RPG play

Immediate pressure: Choose the first RPG scene inside this active MekHQ day.

Next prompt: Pick a scene focus: command briefing, contract decision, personnel conversation, repair/logistics pressure, market inspection, or embedded PC introduction.

## Current Party

{current_party}

## Current Mission

See `missions.md`.

## State Since Last Session

- Campaign context refreshed from MekHQ live API at `{datetime.now(timezone.utc).isoformat()}`.
- Live API data is not a durable checkpoint by itself; do not advance the campaign date here unless MekHQ confirms it or the user explicitly approves recording it.
"""


def render_pcs(viewpoint: dict[str, Any]) -> str:
    person = viewpoint.get("person", {}) if isinstance(viewpoint.get("person"), dict) else {}
    playability = "available for live viewpoint scenes" if viewpoint.get("playable", True) else "unavailable for live viewpoint scenes"
    guard = viewpoint.get("play_guard") or "None."
    return f"""# Player Characters

## Initial Viewpoint

### {viewpoint["display_name"]}

- Player: TBD
- Concept: Initial MekHQ-linked viewpoint; refine as commander, pilot, tech chief, negotiator, or embedded A Time of War PC.
- MekHQ person id: `{viewpoint["mekhq_person_id"]}`
- MekHQ role/rank: {label(person.get("primary_role") or person.get("role"))} / {label(person.get("rank"))} ({viewpoint["source"]})
- MekHQ status: {label(person.get("status"))}
- MekHQ playability: {playability}
- Play guard: {guard}
- Linked unit id: `{text(person.get("unit_id"))}`
- Current condition: fatigue `{text(person.get("fatigue"))}`, hits `{text(person.get("hits"))}`; A Time of War condition TBD.
- Key skills or approaches: TBD
- Edge or limited resources: TBD
- Armor and important gear: TBD
- Assets controlled: TBD; do not infer MekHQ command authority beyond live API role/rank.
- Goals: TBD
- Relationships: Sparse/TBD. Record future scene memory in `relationships.md`.
- Personality, secrets, and private motives: Sparse/TBD; MEK-RPG overlay only.
- Open sheet questions: Fill A Time of War attributes, traits, skills, XP, Edge, gear, and personal goals before rules-heavy PC play.

## Other Player Characters

- Add embedded A Time of War PCs here when selected by the user. Use `mekhq_person_id: None` until linked to a MekHQ person.
"""


def render_npcs(state: dict[str, Any], viewpoint: dict[str, Any]) -> str:
    lines = [
        "# NPCs",
        "",
        "Imported MekHQ personnel are live roster context only. Personality, secrets, motives, and relationship memory are sparse/TBD until established in MEK-RPG scenes.",
        "",
        "## Live API Personnel",
        "",
    ]
    personnel = state.get("personnel", []) if isinstance(state.get("personnel"), list) else []
    others = [person for person in personnel if text(person.get("id") or person.get("mekhq_person_id")) != viewpoint["mekhq_person_id"]]
    if not others:
        lines.append("- None imported beyond the viewpoint character.")
    for person in others[:MAX_LIST_ITEMS]:
        lines.extend(
            [
                f"### {text(person.get('display_name'))}",
                "",
                f"- MekHQ person id: `{text(person.get('id') or person.get('mekhq_person_id'))}`",
                f"- Role/rank/status: {label(person.get('primary_role') or person.get('role'))} / {label(person.get('rank'))} / {label(person.get('status'))} ({EVIDENCE_LIVE})",
                f"- Linked unit id: `{text(person.get('unit_id'))}`",
                f"- Fatigue/hits: {text(person.get('fatigue'))} / {text(person.get('hits'))}",
                "- Current attitude toward PCs: Sparse/TBD",
                "- Wants: Sparse/TBD",
                "- Knows: Sparse/TBD",
                "- Secrets or uncertainty: Sparse/TBD; MEK-RPG overlay only",
                "- Current status: Live MekHQ roster context",
                "",
            ]
        )
    if len(others) > MAX_LIST_ITEMS:
        lines.append(f"- Additional live API personnel not expanded here: {len(others) - MAX_LIST_ITEMS}. See `mekhq-bridge.md`.")
    return "\n".join(lines).rstrip() + "\n"


def render_assets(state: dict[str, Any]) -> str:
    finances = state.get("finances", {}) if isinstance(state.get("finances"), dict) else {}
    logistics = state.get("repairs_and_logistics", {}) if isinstance(state.get("repairs_and_logistics"), dict) else {}
    lines = [
        "# Assets",
        "",
        "MekHQ owns exact ledger values, unit condition, repairs, cargo, and market state. MEK-RPG may add narrative overlays, pending actions, and tactical handoff notes without changing the hard ledger.",
        "",
        "## Finances",
        "",
        f"- Funds: {funds_text(state)} ({EVIDENCE_LIVE}; live context only)",
        f"- Active loans: {text(finances.get('has_active_loans'))}",
        f"- Loan balance: {text(finances.get('loan_balance'))}",
        f"- Loan defaults: {summarize_value(finances.get('loan_defaults'), ['defaulted_loan_count', 'overdue_loan_count'])}",
        f"- Finance warnings: {summarize_value(finances.get('financial_warnings'))}",
        "",
        "## Live API Units",
        "",
    ]
    units = state.get("units", []) if isinstance(state.get("units"), list) else []
    if not units:
        lines.append("- None reported by the live API.")
    for unit in units[:MAX_LIST_ITEMS]:
        entity = unit.get("entity", {}) if isinstance(unit.get("entity"), dict) else {}
        availability = unit.get("availability", {}) if isinstance(unit.get("availability"), dict) else {}
        transport = unit.get("transport", {}) if isinstance(unit.get("transport"), dict) else {}
        lines.extend(
            [
                f"### {display_name(unit)}",
                "",
                f"- MekHQ unit id: `{text(unit.get('id') or unit.get('mekhq_unit_id'))}`",
                f"- Type: {text(entity.get('type'))}",
                f"- Chassis/model/weight: {text(entity.get('chassis'))} / {text(entity.get('model'))} / {text(entity.get('weight_tons'))}",
                f"- Status: {label(unit.get('status'))} ({EVIDENCE_LIVE})",
                f"- Availability/deployability: available `{text(availability.get('available'))}`, deployable `{text(availability.get('deployable'))}`, deployed `{text(availability.get('deployed'))}`",
                f"- Crew links: {text(unit.get('crew'))}",
                f"- Commander/maintenance: commander `{text(unit.get('commander_id'))}`, maintenance site `{text(unit.get('maintenance_site'))}`",
                f"- Damage state: {text(unit.get('damage_state'))}",
                f"- Transport: assigned `{text(transport.get('transport_id'))}`, carried units `{summarize_value(transport.get('carried_unit_ids'))}`",
                "- Legal status: Unknown unless established by MekHQ or play.",
                "- Narrative overlay: Sparse/TBD",
                "- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.",
                "",
            ]
        )
    if len(units) > MAX_LIST_ITEMS:
        lines.append(f"- Additional live API units not expanded here: {len(units) - MAX_LIST_ITEMS}. See `mekhq-bridge.md`.")
    parts_pressure = logistics.get("parts_pressure", {}) if isinstance(logistics.get("parts_pressure"), dict) else {}
    shopping_list = logistics.get("shopping_list", []) if isinstance(logistics.get("shopping_list"), list) else []
    cargo = logistics.get("cargo", {}) if isinstance(logistics.get("cargo"), dict) else {}
    automation_guard = logistics.get("automation_guard", {}) if isinstance(logistics.get("automation_guard"), dict) else {}
    lines.extend(
        [
            "",
            "## Repairs And Logistics",
            "",
            f"- Repair pressure: {summarize_value(logistics.get('repair_pressure'), ['parts_needed_count', 'parts_needing_service_count', 'units_needing_parts_count', 'units_needing_service_count', 'units_under_repair_count'])}",
            f"- Parts/shopping pressure: {summarize_value(parts_pressure, ['shopping_list_item_count', 'shopping_list_part_item_count', 'total_buy_cost'])}",
            f"- Shopping list sample: {summarize_value(shopping_list)}",
            f"- Cargo/transport warnings: {summarize_value(cargo.get('warnings'))}",
            f"- Automation guard: repair execution `{text(automation_guard.get('repair_execution_supported'))}`, procurement execution `{text(automation_guard.get('procurement_execution_supported'))}`, stable work ids `{text(automation_guard.get('stable_repair_work_ids_available'))}`",
            f"- Warnings: {summarize_value(logistics.get('warnings'))}",
            "- Pending MekHQ application: None yet; create item ids in `pending-mekhq-actions.md`.",
        ]
    )
    return "\n".join(lines).rstrip() + "\n"


def render_missions(state: dict[str, Any]) -> str:
    contracts = state.get("contracts", []) if isinstance(state.get("contracts"), list) else []
    scenarios = state.get("scenarios", []) if isinstance(state.get("scenarios"), list) else []
    lines = [
        "# Missions",
        "",
        "MekHQ owns accepted contract ledger status, deadlines, scenario generation, payment, salvage, and tactical outcomes. MEK-RPG owns player-facing stakes, briefings, relationships, promises, and pending choices.",
        "",
        "## Active Mission",
        "",
    ]
    if contracts:
        first = contracts[0]
        terms = first.get("terms", {}) if isinstance(first.get("terms"), dict) else {}
        payment = first.get("payment_summary", {}) if isinstance(first.get("payment_summary"), dict) else {}
        salvage = first.get("salvage_summary", {}) if isinstance(first.get("salvage_summary"), dict) else {}
        rental = first.get("rental_summary", {}) if isinstance(first.get("rental_summary"), dict) else {}
        lines.extend(
            [
                f"Mission name: {display_name(first)}",
                "",
                f"Status: {label(first.get('status'))} ({EVIDENCE_LIVE}; live context only)",
                "",
                f"Description: {text(first.get('description'))}",
                "",
                f"Dates: start `{text(first.get('start_date'))}`, end `{text(first.get('end_date'))}`, months left `{text(first.get('months_left'))}`, travel days `{text(first.get('travel_days'))}`.",
                "",
                f"Stakes: employer `{text(first.get('employer'))}`, enemy `{text(first.get('enemy'))}`, system `{text(first.get('system_name') or first.get('system_id'))}`.",
                "",
                f"Terms: {summarize_value(terms, ['advance_pct', 'advance_amount', 'monthly_payout', 'transport_comp', 'command_rights', 'salvage_pct', 'straight_support'])}.",
                "",
                f"Payment summary: {summarize_value(payment, ['total_amount', 'monthly_payout', 'advance_amount', 'estimated_total_profit'])}.",
                "",
                f"Salvage/rental summary: {summarize_value(salvage, ['salvage_pct_label', 'battle_loss_comp'])}; rentals {summarize_value(rental, ['hospital_beds', 'kitchens', 'holding_cells'])}.",
            ]
        )
    else:
        lines.extend(
            [
                "Mission name: TBD",
                "",
                "Status: No active MekHQ contract reported by the live API.",
                "",
                "Objective: Choose a scene from hooks, markets, repairs, personnel, or an embedded PC introduction.",
            ]
        )
    lines.extend(["", "## Imported Scenarios", ""])
    if not scenarios:
        lines.append("- None reported by the live API.")
    for scenario in scenarios[:MAX_LIST_ITEMS]:
        objective_summary = ""
        objectives = scenario.get("objectives") if isinstance(scenario.get("objectives"), list) else []
        if objectives:
            objective_summary = f"; first objective {text(objectives[0].get('short_label') or objectives[0].get('description'))}"
        lines.append(
            f"- `{text(scenario.get('id') or scenario.get('mekhq_scenario_id'))}` {display_name(scenario)}: "
            f"status {label(scenario.get('status'))}, date {text(scenario.get('date'))}, "
            f"type {text(scenario.get('stratcon_scenario_type'))}, map {summarize_value(scenario.get('map'), ['board_type', 'map', 'map_size_x', 'map_size_y'])}"
            f"{objective_summary}."
        )
    lines.extend(["", "## Completed Missions", "", "- None recorded in MEK-RPG yet."])
    return "\n".join(lines).rstrip() + "\n"


def render_locations(state: dict[str, Any]) -> str:
    location = state.get("campaign", {}).get("location", {}) if isinstance(state.get("campaign"), dict) else {}
    return f"""# Locations

## Live API Current Location

### {location_name(state)}

- Type: MekHQ current system/location
- System id: `{text(location.get("current_system_id"))}`
- Current relevance: Current campaign location for the active loaded MekHQ day
- Access or security: Sparse/TBD
- Important NPCs: See imported personnel in `npcs.md`
- Important assets: See imported units in `assets.md`
- Hazards or pressures: Sparse/TBD
- Travel fields: on planet `{text(location.get("on_planet"))}`, in transit `{text(location.get("in_transit"))}`, at jump point `{text(location.get("at_jump_point"))}`, transit percentage `{text(location.get("transit_percentage"))}` ({EVIDENCE_LIVE})
- Open questions: Convert system id to table-facing location details only after user confirmation or source lookup.
"""


def render_hooks(state: dict[str, Any]) -> str:
    lines = ["# Hooks", "", "## Active Hooks", ""]
    markets = state.get("markets", {}) if isinstance(state.get("markets"), dict) else {}
    logistics = state.get("repairs_and_logistics", {}) if isinstance(state.get("repairs_and_logistics"), dict) else {}
    reports = state.get("reports", {}) if isinstance(state.get("reports"), dict) else {}
    unit_offers = markets.get("unit_offers") or markets.get("unit_market_offers") or []
    personnel = markets.get("personnel_applicants") or markets.get("personnel_market_applicants") or []
    contracts = markets.get("contract_offers") or markets.get("contract_market_offers") or []
    for offer in unit_offers[:10] if isinstance(unit_offers, list) else []:
        lines.append(f"- Market inspection: {text(offer.get('unit_name') or offer.get('display_name'))}; final price and selectors are unsupported until checked in MekHQ.")
    for person in personnel[:10] if isinstance(personnel, list) else []:
        lines.append(f"- Hiring interview: {text(person.get('display_name'))}, role `{label(person.get('primary_role') or person.get('role'))}`.")
    for offer in contracts[:10] if isinstance(contracts, list) else []:
        lines.append(f"- Contract review: {text(offer.get('name'))}, employer `{text(offer.get('employer'))}`.")
    if len(lines) == 4:
        lines.append("- Choose a personnel, contract, logistics, repair, or embedded PC scene from the live campaign state.")
    market_summary = markets.get("summary", {}) if isinstance(markets.get("summary"), dict) else {}
    lines.extend(
        [
            f"- Market posture: display-only `{text(markets.get('display_only'))}`, automation-ready `{text(markets.get('automation_ready'))}`, unit offers `{text(market_summary.get('unit_offer_count'))}`, personnel applicants `{text(market_summary.get('personnel_applicant_count'))}`, contract offers `{text(market_summary.get('contract_offer_count'))}`.",
            f"- Shopping pressure: {summarize_value(logistics.get('parts_pressure'), ['shopping_list_item_count', 'total_buy_cost'])}.",
            f"- Report pressure: {summarize_value(reports.get('metadata', {}).get('categories') if isinstance(reports.get('metadata'), dict) else None)}.",
        ]
    )
    lines.extend(
        [
            "",
            "## Threats",
            "",
            "- Unsupported or unmapped MekHQ live API fields may hide logistics pressure; inspect MekHQ before making exact ledger claims.",
            "",
            "## Opportunities",
            "",
            "- Turn MekHQ repair delays, personnel applicants, market offers, or employer meetings into RPG scenes without finalizing ledger changes outside MekHQ.",
        ]
    )
    return "\n".join(lines).rstrip() + "\n"


def render_mekhq_bridge(campaign_id: str, state: dict[str, Any], viewpoint: dict[str, Any], state_path: Path) -> str:
    meta = state["bridge_metadata"]
    personnel = state.get("personnel", []) if isinstance(state.get("personnel"), list) else []
    units = state.get("units", []) if isinstance(state.get("units"), list) else []
    contracts = state.get("contracts", []) if isinstance(state.get("contracts"), list) else []
    lines = [
        "# MekHQ Bridge",
        "",
        "This file records campaign-local bridge metadata for a read-only MekHQ live API context refresh. It is not a MekHQ save, not a durable checkpoint, and not authority to write to MekHQ.",
        "",
        "## Live API Metadata",
        "",
        f"- MEK-RPG campaign id: `{campaign_id}`",
        f"- Live API state JSON: `{display_path(state_path)}`",
        f"- Adapter timestamp: `{datetime.now(timezone.utc).isoformat()}`",
        f"- Schema: `{text(meta.get('schema_name'))}` version `{text(meta.get('schema_version'))}`",
        f"- API mode: `{text(meta.get('api_mode'))}`",
        f"- Read-only proof: `{text(meta.get('read_only'))}`",
        f"- MekHQ version: `{text(meta.get('mekhq_version') or meta.get('producer_version'))}`",
        f"- State revision: `{text(meta.get('state_revision'))}`",
        f"- Snapshot id: `{text(meta.get('snapshot_id'))}`",
        f"- Dirty state: {text(meta.get('dirty_state'))}",
        "",
        "## Ownership Boundary",
        "",
        "- MekHQ owns campaign date, day advancement, travel, finances, rosters, unit condition, repairs, contracts, markets, scenarios, tactical outcomes, and hard logistics.",
        "- MEK-RPG owns RPG scenes, A Time of War overlays, conversations, relationships, promises, secrets, hooks, session logs, safety/tone, and narrative uncertainty.",
        "- Live API values are live context by default. Promote them to durable MEK-RPG memory only through a save/import checkpoint, explicit user approval, or a future controlled promotion flow.",
        "- Do not write to `.cpnx`, `.cpnx.gz`, MekHQ XML, raw MekHQ save payloads, or MekHQ API write surfaces from this workspace.",
        "",
        "## Campaign Snapshot",
        "",
        f"- MekHQ campaign id: `{campaign_id_value(state)}`",
        f"- Name: {campaign_name(state)}",
        f"- Date: {campaign_date(state)}",
        f"- Location: {location_name(state)}",
        f"- Funds: {funds_text(state)}",
        f"- Viewpoint: {viewpoint['display_name']} (`{viewpoint['mekhq_person_id']}`), {viewpoint['reason']}",
        "",
        "## Counts",
        "",
        f"- Personnel: {len(personnel)}",
        f"- Units: {len(units)}",
        f"- Contracts: {len(contracts)}",
        f"- Scenarios: {len(state.get('scenarios', [])) if isinstance(state.get('scenarios'), list) else 0}",
        f"- Market unit/personnel/contract offers: {count_items(state.get('markets', {}).get('unit_offers') if isinstance(state.get('markets'), dict) else None)} / {count_items(state.get('markets', {}).get('personnel_applicants') if isinstance(state.get('markets'), dict) else None)} / {count_items(state.get('markets', {}).get('contract_offers') if isinstance(state.get('markets'), dict) else None)}",
        f"- Current report lines: {count_items(state.get('reports', {}).get('current') if isinstance(state.get('reports'), dict) else None)}",
        "",
        "## Cross-References",
        "",
        "### Personnel",
        "",
    ]
    for person in personnel[:MAX_LIST_ITEMS]:
        slug = slugify(text(person.get("display_name")), "person")
        lines.append(f"- `{text(person.get('id') or person.get('mekhq_person_id'))}` -> `{slug}`: {text(person.get('display_name'))}")
    if not personnel:
        lines.append("- None reported by the live API.")
    lines.extend(["", "### Units", ""])
    for unit in units[:MAX_LIST_ITEMS]:
        slug = slugify(text(unit.get("display_name")), "unit")
        lines.append(f"- `{text(unit.get('id') or unit.get('mekhq_unit_id'))}` -> `{slug}`: {text(unit.get('display_name'))}")
    if not units:
        lines.append("- None reported by the live API.")
    lines.extend(["", "### Contracts", ""])
    for contract in contracts[:MAX_LIST_ITEMS]:
        slug = slugify(display_name(contract), "contract")
        lines.append(f"- `{text(contract.get('id') or contract.get('mekhq_contract_id'))}` -> `{slug}`: {display_name(contract)}")
    if not contracts:
        lines.append("- None reported by the live API.")
    lines.extend(["", "## Warnings", ""])
    warnings = meta.get("warnings", [])
    if warnings:
        for warning in warnings:
            lines.append(f"- {text(warning)}")
    else:
        lines.append("- None reported by bridge_metadata.")
    lines.extend(["", "## API Gaps", "", "- See `mekhq-api-gaps.md`."])
    return "\n".join(lines).rstrip() + "\n"


def render_api_gaps(state: dict[str, Any]) -> str:
    gaps = collect_api_gaps(state)
    lines = [
        "# MekHQ Live API Gaps",
        "",
        "This file records missing, unsupported, or automation-blocking live API fields found during the latest campaign context refresh. These are producer-side change request inputs, not permission to parse the active save as a workaround.",
        "",
        f"Last checked: {datetime.now(timezone.utc).isoformat()}",
        "",
        "## Gaps",
        "",
    ]
    if not gaps:
        lines.append("- None detected by the adapter.")
    for gap in gaps:
        lines.extend(
            [
                f"- `{gap['field']}`",
                f"  - Area: {gap['area']}",
                f"  - Reason: {gap['reason']}",
                f"  - Recommended owner: {gap['recommended_owner']}",
                f"  - Blocks automation: {gap['blocks_automation']}",
            ]
        )
    return "\n".join(lines).rstrip() + "\n"


def render_session_log(state: dict[str, Any], viewpoint: dict[str, Any]) -> str:
    return f"""# Session Log

## Active Or Most Recent Session

Date: {datetime.now(timezone.utc).date().isoformat()}

Mode: MekHQ-linked live API context load

Player characters:

- {viewpoint["display_name"]} (initial viewpoint; confirm before play)

## Summary

Generated or refreshed this campaign save from a read-only MekHQ live API state payload. No RPG scene has been played yet.

## Important Rolls

- None.

## State Changes

- Created or refreshed campaign-local MekHQ live API bridge/context notes.

## Rewards And Costs

- None.

## Rules Gaps

- A Time of War sheet details for the selected viewpoint remain TBD.
- MekHQ-owned ledger changes must be applied in MekHQ and confirmed before becoming hard facts.

## Next Session

- Confirm the viewpoint and choose the first scene inside the active MekHQ day.
"""


def render_pending_mekhq_actions() -> str:
    return """# Pending MekHQ Actions

Use this file for hard ledger intents created during MekHQ-linked RPG play. For supported MekHQ command endpoints, record the command proposal, dry-run, execution, and verification here. For unsupported or unavailable endpoints, record the manual MekHQ fallback checklist here.

A pending item is not final until MekHQ applies it through a supported command or manual UI action and MEK-RPG verifies the result by live reread or saved import.

See `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md` for the full schema and lifecycle.

## Open Items

- None.

## Resolved Or Abandoned Items

- None.
"""


def write_text(path: Path, content: str) -> None:
    path.write_text(content, encoding="utf-8", newline="\n")


def sync_campaign(state_path: Path, campaign_id: str, viewpoint: dict[str, Any], state: dict[str, Any], refresh_existing: bool) -> Path:
    root = repo_root()
    campaigns_root = root / "campaigns"
    template = campaigns_root / "_template"
    target = campaigns_root / campaign_id
    if not template.is_dir():
        raise FileNotFoundError(f"Template folder not found: {template}")
    if target.exists() and not refresh_existing:
        raise FileExistsError(f"Campaign already exists: {target}. Pass --refresh-existing to update generated live API context files.")
    if not target.exists():
        resolved_parent = target.parent.resolve()
        if resolved_parent != campaigns_root.resolve():
            raise ValueError(f"Refusing to create a campaign outside {campaigns_root}")
        shutil.copytree(template, target)

    renderers = {
        "overview.md": render_overview(campaign_id, state, viewpoint),
        "current-state.md": render_current_state(state, viewpoint),
        "pcs.md": render_pcs(viewpoint),
        "npcs.md": render_npcs(state, viewpoint),
        "assets.md": render_assets(state),
        "missions.md": render_missions(state),
        "hooks.md": render_hooks(state),
        "locations.md": render_locations(state),
        "session-log.md": render_session_log(state, viewpoint),
        "pending-mekhq-actions.md": render_pending_mekhq_actions(),
        "mekhq-bridge.md": render_mekhq_bridge(campaign_id, state, viewpoint, state_path),
        "mekhq-api-gaps.md": render_api_gaps(state),
    }
    for filename, content in renderers.items():
        write_text(target / filename, content)
    return target


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Create or refresh a MEK-RPG campaign folder from captured MekHQ GET /campaign/state JSON."
    )
    parser.add_argument("--live-state", required=True, help="Path to captured GET /campaign/state JSON with bridge_metadata.")
    parser.add_argument("--campaign-id", required=True, help="campaigns/<campaign-id>/ folder to create or refresh.")
    parser.add_argument("--refresh-existing", action="store_true", help="Refresh generated live API context files when the campaign folder already exists.")
    parser.add_argument("--viewpoint-person-id", help="MekHQ personnel id to use as the initial viewpoint.")
    parser.add_argument("--viewpoint-name", help="Exact MekHQ display name to use as the initial viewpoint.")
    parser.add_argument("--embedded-pc-name", help="Create an unlinked embedded A Time of War PC as the initial viewpoint.")
    args = parser.parse_args(argv)

    selectors = [args.viewpoint_person_id, args.viewpoint_name, args.embedded_pc_name]
    if sum(1 for item in selectors if item) > 1:
        parser.error("Choose only one viewpoint selector.")

    try:
        validate_campaign_id(args.campaign_id)
        state_path = Path(args.live_state).expanduser().resolve()
        state = load_state(state_path)
        viewpoint = choose_viewpoint(state, args.viewpoint_person_id, args.viewpoint_name, args.embedded_pc_name)
        target = sync_campaign(state_path, args.campaign_id, viewpoint, state, args.refresh_existing)
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1

    action = "Refreshed" if args.refresh_existing else "Created"
    print(f"{action} campaign live API context: campaigns/{args.campaign_id}/")
    print(f"Viewpoint: {viewpoint['display_name']} ({viewpoint['reason']})")
    print("Live API data is live context only; this script does not edit campaign-state/active-campaign.md.")
    print(f"Bridge note: {target.relative_to(repo_root()) / 'mekhq-bridge.md'}")
    print(f"API gaps: {target.relative_to(repo_root()) / 'mekhq-api-gaps.md'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
