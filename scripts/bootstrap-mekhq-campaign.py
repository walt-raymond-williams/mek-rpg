#!/usr/bin/env python3
"""Create a MEK-RPG campaign save folder from a MekHQ bridge summary.

The input is the JSON emitted by summarize-mekhq-save.py. This helper never
opens or writes a MekHQ save; it only copies the MEK-RPG campaign template and
fills campaign-local Markdown stubs with imported hard facts and sparse RPG
overlays.
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


EVIDENCE_IMPORT = "Confirmed from MekHQ import"
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


def load_summary(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8-sig") as handle:
        summary = json.load(handle)
    required = ["bridge_metadata", "campaign", "personnel", "units", "contracts", "scenarios"]
    missing = [key for key in required if key not in summary]
    if missing:
        raise ValueError(f"Summary JSON is missing required keys: {', '.join(missing)}")
    return summary


def value(raw: Any, default: str = "Unknown") -> str:
    if raw is None:
        return default
    if isinstance(raw, str):
        text = raw.strip()
        return text if text else default
    if isinstance(raw, dict):
        return json.dumps(raw, ensure_ascii=False, sort_keys=True)
    if isinstance(raw, list):
        if not raw:
            return default
        return ", ".join(value(item) if not isinstance(item, str) else item for item in raw)
    return str(raw)


def slugify(text: str, fallback: str) -> str:
    text = text.lower()
    text = re.sub(r"[^a-z0-9]+", "-", text)
    text = re.sub(r"-+", "-", text).strip("-")
    return text or fallback


def funds_text(summary: dict[str, Any]) -> str:
    funds = summary.get("finances", {}).get("funds", {}).get("calculated_balance_by_currency")
    if isinstance(funds, dict) and funds:
        return ", ".join(f"{amount} {currency}" for currency, amount in sorted(funds.items()))
    campaign_funds = summary.get("campaign", {}).get("funds", {}).get("calculated_balance_by_currency")
    if isinstance(campaign_funds, dict) and campaign_funds:
        return ", ".join(f"{amount} {currency}" for currency, amount in sorted(campaign_funds.items()))
    return "Unknown"


def choose_viewpoint(
    summary: dict[str, Any],
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
        }

    personnel = summary.get("personnel", [])
    if person_id:
        for person in personnel:
            if value(person.get("mekhq_person_id")) == person_id:
                return {
                    "kind": "mekhq_person",
                    "display_name": value(person.get("display_name")),
                    "mekhq_person_id": person_id,
                    "person": person,
                    "reason": "Matched requested MekHQ personnel id.",
                    "source": EVIDENCE_IMPORT,
                }
        raise ValueError(f"No MekHQ personnel found for id: {person_id}")

    if viewpoint_name:
        target = viewpoint_name.lower()
        for person in personnel:
            if value(person.get("display_name")).lower() == target:
                return {
                    "kind": "mekhq_person",
                    "display_name": value(person.get("display_name")),
                    "mekhq_person_id": value(person.get("mekhq_person_id")),
                    "person": person,
                    "reason": "Matched requested MekHQ personnel display name.",
                    "source": EVIDENCE_IMPORT,
                }
        raise ValueError(f"No MekHQ personnel found with display name: {viewpoint_name}")

    for person in personnel:
        if value(person.get("commander")).lower() == "true":
            return {
                "kind": "mekhq_person",
                "display_name": value(person.get("display_name")),
                "mekhq_person_id": value(person.get("mekhq_person_id")),
                "person": person,
                "reason": "Selected first MekHQ commander flag.",
                "source": EVIDENCE_IMPORT,
            }

    if personnel:
        person = personnel[0]
        return {
            "kind": "mekhq_person",
            "display_name": value(person.get("display_name")),
            "mekhq_person_id": value(person.get("mekhq_person_id")),
            "person": person,
            "reason": "Selected first imported MekHQ personnel record.",
            "source": EVIDENCE_IMPORT,
        }

    return {
        "kind": "embedded_pc",
        "display_name": "Embedded A Time of War PC",
        "mekhq_person_id": "None",
        "reason": "No MekHQ personnel records were available.",
        "source": EVIDENCE_UNKNOWN,
    }


def title(summary: dict[str, Any]) -> str:
    return value(summary.get("campaign", {}).get("name"), "MekHQ-Linked Campaign")


def render_overview(campaign_id: str, summary: dict[str, Any], viewpoint: dict[str, Any]) -> str:
    campaign = summary["campaign"]
    meta = summary["bridge_metadata"]
    return f"""# Campaign Overview

Campaign name: {title(summary)}

Campaign id: {campaign_id}

Status: MekHQ-linked draft

Canon status: MekHQ import plus MEK-RPG overlays

Setting seed: `campaign-state/setting-basics.md`

## Table Frame

- Era: Needs user decision
- Starting date: {value(campaign.get("date"))} ({EVIDENCE_IMPORT})
- Starting region: {value(campaign.get("location", {}).get("current_system_id"))} ({EVIDENCE_IMPORT})
- Player unit concept: Imported MekHQ campaign force; refine for table play.
- Viewpoint character: {viewpoint["display_name"]} ({viewpoint["reason"]})
- Tone: Needs user decision
- Canon strictness: Guided canon until decided
- Tactical handoff: use Classic BattleTech, MegaMek, or MekHQ when hex-scale unit combat matters.

## MekHQ Link

- Bridge file: `mekhq-bridge.md`
- MekHQ campaign id: `{value(campaign.get("mekhq_campaign_id"))}`
- Source save path: `{value(meta.get("input_path"))}`
- Last import timestamp: `{value(meta.get("import_timestamp"))}`
- Ownership boundary: MekHQ owns hard logistics, calendar, rosters, finances, contracts, scenarios, markets, repairs, and tactical ledger state. MEK-RPG owns scenes, A Time of War overlays, relationships, promises, secrets, hooks, and session memory.

## Resume Summary

Begin play inside the imported MekHQ campaign day. Confirm the viewpoint character and immediate scene focus before running RPG scenes.

## Open Setup Questions

- Confirm the table-facing campaign premise and tone.
- Confirm whether the selected viewpoint is the initial PC, a temporary camera character, or a commander briefing role.
- Fill A Time of War sheet details, Edge, XP, traits, personality, private goals, secrets, and relationship notes as MEK-RPG-only overlays.
"""


def render_current_state(summary: dict[str, Any], viewpoint: dict[str, Any]) -> str:
    campaign = summary["campaign"]
    location = campaign.get("location", {})
    contracts = summary.get("contracts", [])
    active_contract = contracts[0] if contracts else None
    pressure = "Choose the first RPG scene inside this MekHQ day."
    if active_contract:
        pressure = f"Active MekHQ contract available: {value(active_contract.get('name'))}."
    return f"""# Current State

Current date: {value(campaign.get("date"))} ({EVIDENCE_IMPORT}; MekHQ-owned)

Current location: {value(location.get("current_system_id"))} ({EVIDENCE_IMPORT}; MekHQ-owned)

Active scene: Pre-session checkpoint for MekHQ-linked RPG play

Immediate pressure: {pressure}

Next prompt: Pick a scene focus: command briefing, contract decision, personnel conversation, repair/logistics pressure, market inspection, or embedded PC introduction.

## Current Party

- {viewpoint["display_name"]} - viewpoint character; MekHQ person id `{viewpoint["mekhq_person_id"]}`; RPG details sparse/TBD.

## Current Mission

See `missions.md`.

## State Since Last Session

- Campaign folder generated from MekHQ summary import at `{value(summary["bridge_metadata"].get("import_timestamp"))}`.
- Do not advance the campaign date here unless a later MekHQ import confirms the new date.
"""


def render_pcs(summary: dict[str, Any], viewpoint: dict[str, Any]) -> str:
    person = viewpoint.get("person", {})
    role = value(person.get("role")) if person else "TBD"
    rank = value(person.get("rank")) if person else "TBD"
    assignment = person.get("assignment", {}) if isinstance(person.get("assignment"), dict) else {}
    return f"""# Player Characters

## Initial Viewpoint

### {viewpoint["display_name"]}

- Player: TBD
- Concept: Initial MekHQ-linked viewpoint; refine as commander, pilot, tech chief, negotiator, or embedded A Time of War PC.
- MekHQ person id: `{viewpoint["mekhq_person_id"]}`
- MekHQ role/rank: {role} / {rank} ({viewpoint["source"]})
- MekHQ assignment: unit id `{value(assignment.get("unit_id"))}`
- Current location: See `current-state.md`
- Current condition: MekHQ availability `{value(person.get("availability")) if person else "TBD"}`; A Time of War condition TBD.
- Key skills or approaches: TBD
- Edge or limited resources: TBD
- Armor and important gear: TBD
- Assets controlled: TBD; do not infer MekHQ command authority beyond imported role/rank.
- Goals: TBD
- Relationships: Sparse/TBD. Record future scene memory in `relationships.md`.
- Personality, secrets, and private motives: Sparse/TBD; MEK-RPG overlay only.
- Open sheet questions: Fill A Time of War attributes, traits, skills, XP, Edge, gear, and personal goals before rules-heavy PC play.

## Other Player Characters

- Add embedded A Time of War PCs here when selected by the user. Use `mekhq_person_id: None` until linked to a MekHQ person.
"""


def render_npcs(summary: dict[str, Any], viewpoint: dict[str, Any]) -> str:
    lines = ["# NPCs", "", "Imported MekHQ personnel are hard roster facts only. Personality, secrets, motives, and relationship memory are sparse/TBD until established in MEK-RPG scenes.", ""]
    personnel = [
        person
        for person in summary.get("personnel", [])
        if value(person.get("mekhq_person_id")) != viewpoint["mekhq_person_id"]
    ]
    if not personnel:
        lines.extend(["## Imported Personnel", "", "- None imported beyond the viewpoint character."])
    else:
        lines.extend(["## Imported Personnel", ""])
        for person in personnel[:MAX_LIST_ITEMS]:
            lines.extend(
                [
                    f"### {value(person.get('display_name'))}",
                    "",
                    f"- MekHQ person id: `{value(person.get('mekhq_person_id'))}`",
                    f"- Role/rank: {value(person.get('role'))} / {value(person.get('rank'))} ({EVIDENCE_IMPORT})",
                    f"- Assignment: unit id `{value(person.get('assignment', {}).get('unit_id') if isinstance(person.get('assignment'), dict) else None)}`",
                    f"- Availability: {value(person.get('availability'))}",
                    f"- Injury/fatigue flags: {value(person.get('injury_fatigue_flags'))}",
                    "- Current attitude toward PCs: Sparse/TBD",
                    "- Wants: Sparse/TBD",
                    "- Knows: Sparse/TBD",
                    "- Secrets or uncertainty: Sparse/TBD; MEK-RPG overlay only",
                    "- Promises, debts, or threats: Sparse/TBD",
                    "- Current status: Imported MekHQ roster fact",
                    "- Last seen: Not yet established in MEK-RPG play",
                    "",
                ]
            )
        if len(personnel) > MAX_LIST_ITEMS:
            lines.append(f"- Additional imported personnel not expanded here: {len(personnel) - MAX_LIST_ITEMS}. See `mekhq-bridge.md`.")
    return "\n".join(lines).rstrip() + "\n"


def render_assets(summary: dict[str, Any]) -> str:
    lines = [
        "# Assets",
        "",
        "MekHQ owns exact ledger values, unit condition, repairs, cargo, and market state. MEK-RPG may add narrative overlays, pending actions, and tactical handoff notes without changing the hard ledger.",
        "",
        "## Finances",
        "",
        f"- Funds: {funds_text(summary)} (derived from imported summary; confirm in MekHQ UI when exact balance matters)",
        f"- Transaction count: {value(summary.get('finances', {}).get('transaction_count'))}",
        f"- Loan count: {value(summary.get('finances', {}).get('loan_count'))}",
        f"- Asset count: {value(summary.get('finances', {}).get('asset_count'))}",
        "",
        "## Imported Units",
        "",
    ]
    units = summary.get("units", [])
    if not units:
        lines.append("- None imported.")
    for unit in units[:MAX_LIST_ITEMS]:
        damage = unit.get("damage_repair_summary", {}) if isinstance(unit.get("damage_repair_summary"), dict) else {}
        crew = unit.get("crew", {}) if isinstance(unit.get("crew"), dict) else {}
        crew_bits = []
        for label, entry in crew.items():
            if isinstance(entry, dict):
                crew_bits.append(f"{label} `{value(entry.get('id'))}` {value(entry.get('display_name'))}")
        lines.extend(
            [
                f"### {value(unit.get('display_name'))}",
                "",
                f"- MekHQ unit id: `{value(unit.get('mekhq_unit_id'))}`",
                f"- Type: {value(unit.get('type'))}",
                f"- Status/site: {value(unit.get('status', {}).get('site') if isinstance(unit.get('status'), dict) else None)} ({EVIDENCE_IMPORT})",
                f"- Crew links: {value(crew_bits)}",
                f"- Damage/repair summary: linked part count {value(damage.get('linked_part_count'))}; exact condition remains MekHQ-owned.",
                f"- Last maintenance note: {value(damage.get('last_maintenance_report'))}",
                "- Legal status: Unknown unless established by MekHQ or play.",
                "- Narrative overlay: Sparse/TBD",
                "- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.",
                "",
            ]
        )
    if len(units) > MAX_LIST_ITEMS:
        lines.append(f"- Additional imported units not expanded here: {len(units) - MAX_LIST_ITEMS}. See `mekhq-bridge.md`.")

    logistics = summary.get("repairs_and_logistics", {})
    lines.extend(
        [
            "",
            "## Repairs And Logistics",
            "",
            f"- Shopping list count: {value(logistics.get('shopping_list_count'))}",
            f"- Parts count: {value(logistics.get('parts_count'))}",
            f"- Unit-linked parts count: {value(logistics.get('unit_linked_parts_count'))}",
            f"- Transport/cargo pressure: {value(logistics.get('transport_cargo_pressure'))}",
            "- Pending MekHQ application: None yet; create item ids in `pending-mekhq-actions.md`.",
        ]
    )
    return "\n".join(lines).rstrip() + "\n"


def render_missions(summary: dict[str, Any]) -> str:
    contracts = summary.get("contracts", [])
    scenarios = summary.get("scenarios", [])
    lines = [
        "# Missions",
        "",
        "MekHQ owns accepted contract ledger status, deadlines, scenario generation, payment, salvage, and tactical outcomes. MEK-RPG owns player-facing stakes, briefings, relationships, promises, and pending choices.",
        "",
    ]
    if contracts:
        first = contracts[0]
        lines.extend(
            [
                "## Active Mission",
                "",
                f"Mission name: {value(first.get('name'))}",
                "",
                f"Status: {value(first.get('status'))} ({EVIDENCE_IMPORT}; MekHQ-owned)",
                "",
                f"Objective: {value(first.get('objective_summary'))}",
                "",
                "Current scene: Choose an RPG briefing, negotiation, planning, or tactical handoff prep scene.",
                "",
                f"Stakes: Employer `{value(first.get('employer'))}`, deadline `{value(first.get('deadline'))}`, system `{value(first.get('system_id'))}`.",
                "",
                "Tactical handoff trigger: Switch to MekHQ/MegaMek/Classic BattleTech when exact unit combat, scenario outcome, damage, salvage, or casualty state matters.",
                "",
                "## Imported Contracts",
                "",
            ]
        )
        for contract in contracts[:MAX_LIST_ITEMS]:
            terms = contract.get("terms_summary", {}) if isinstance(contract.get("terms_summary"), dict) else {}
            lines.extend(
                [
                    f"### {value(contract.get('name'))}",
                    "",
                    f"- MekHQ contract id: `{value(contract.get('mekhq_contract_id'))}`",
                    f"- Type/status: {value(contract.get('type'))} / {value(contract.get('status'))}",
                    f"- Employer: {value(contract.get('employer'))}",
                    f"- Deadline/system: {value(contract.get('deadline'))} / {value(contract.get('system_id'))}",
                    f"- Terms summary: payment multiplier `{value(terms.get('payment_multiplier'))}`, salvage `{value(terms.get('salvage_pct'))}`, command rights `{value(terms.get('command_rights'))}`",
                    "- MEK-RPG scene notes: Sparse/TBD",
                    "- Pending MekHQ application: None yet; create item ids in `pending-mekhq-actions.md`.",
                    "",
                ]
            )
    else:
        lines.extend(
            [
                "## Active Mission",
                "",
                "Mission name: TBD",
                "",
                "Status: No active MekHQ contract imported.",
                "",
                "Objective: Choose a scene from hooks, markets, repairs, personnel, or an embedded PC introduction.",
                "",
                "Current scene: TBD",
                "",
                "Stakes: TBD",
                "",
                "Tactical handoff trigger: Switch to MekHQ/MegaMek/Classic BattleTech when exact unit combat or ledger consequences matter.",
            ]
        )
    lines.extend(["", "## Imported Scenarios", ""])
    if not scenarios:
        lines.append("- None imported.")
    for scenario in scenarios[:MAX_LIST_ITEMS]:
        lines.append(
            f"- `{value(scenario.get('mekhq_scenario_id'))}` {value(scenario.get('name'))}: status {value(scenario.get('status'))}, date {value(scenario.get('date'))}, contract `{value(scenario.get('contract_id'))}`."
        )
    lines.extend(["", "## Paused Or Future Missions", "", "- See `hooks.md` for market offers and RPG scene prompts.", "", "## Completed Missions", "", "- None recorded in MEK-RPG yet."])
    return "\n".join(lines).rstrip() + "\n"


def render_hooks(summary: dict[str, Any]) -> str:
    markets = summary.get("markets", {})
    unit_offers = markets.get("unit_market_offers", [])
    personnel_offers = markets.get("personnel_market_applicants", [])
    contract_offers = markets.get("contract_market_offers", [])
    lines = ["# Hooks", "", "## Active Hooks", ""]
    if unit_offers:
        for offer in unit_offers[:10]:
            lines.append(
                f"- Market inspection: {value(offer.get('unit_name'))} ({value(offer.get('unit_type'))}) at `{value(offer.get('price_percent'))}` percent offer; final price unsupported until checked in MekHQ."
            )
    if personnel_offers:
        for person in personnel_offers[:10]:
            lines.append(
                f"- Hiring interview: {value(person.get('display_name'))}, role `{value(person.get('role'))}`, MekHQ applicant id `{value(person.get('mekhq_person_id'))}`."
            )
    if contract_offers:
        for offer in contract_offers[:10]:
            lines.append(
                f"- Contract review: {value(offer.get('name'))}, employer `{value(offer.get('employer'))}`, deadline `{value(offer.get('deadline'))}`."
            )
    if len(lines) == 4:
        lines.append("- Choose a personnel, contract, logistics, repair, or embedded PC scene from the imported campaign state.")
    lines.extend(
        [
            "",
            "## Threats",
            "",
            "- Unsupported or unmapped MekHQ fields may hide logistics pressure; inspect MekHQ before making exact ledger claims.",
            "",
            "## Opportunities",
            "",
            "- Turn MekHQ repair delays, personnel applicants, market offers, or employer meetings into RPG scenes without finalizing ledger changes outside MekHQ.",
            "",
            "## Next-Session Prompts",
            "",
            "- Who is the viewpoint character for the first scene?",
            "- Which MekHQ hard fact is under narrative pressure right now: contract, unit, repair, market, personnel, or command decision?",
            "- What player choice can be resolved inside the current MekHQ day without advancing the ledger?",
        ]
    )
    return "\n".join(lines).rstrip() + "\n"


def render_relationships(summary: dict[str, Any], viewpoint: dict[str, Any]) -> str:
    personnel = summary.get("personnel", [])
    lines = [
        "# Relationships",
        "",
        "Track relationship state that matters for future scenes. Imported MekHQ rosters do not define trust, loyalty, secrets, favors, or grudges by themselves.",
        "",
        "## Initial Relationship Stubs",
        "",
    ]
    others = [person for person in personnel if value(person.get("mekhq_person_id")) != viewpoint["mekhq_person_id"]]
    if not others:
        lines.append("- None yet.")
    for person in others[:10]:
        lines.extend(
            [
                f"### {viewpoint['display_name']} -> {value(person.get('display_name'))}",
                "",
                "- Current status: Sparse/TBD",
                "- Trust or hostility: Sparse/TBD",
                "- Leverage: Sparse/TBD",
                "- Promises: Sparse/TBD",
                "- Debts or favors: Sparse/TBD",
                "- Secrets: Sparse/TBD",
                "- Last changed: Not yet established in MEK-RPG play",
                "",
            ]
        )
    return "\n".join(lines).rstrip() + "\n"


def render_locations(summary: dict[str, Any]) -> str:
    location = summary["campaign"].get("location", {})
    system_id = value(location.get("current_system_id"))
    return f"""# Locations

## Imported Current Location

### {system_id}

- Type: MekHQ current system/location id
- Parent region: Unknown
- Current relevance: Current campaign location for the imported MekHQ day
- Access or security: Sparse/TBD
- Important NPCs: See imported personnel in `npcs.md`
- Important assets: See imported units in `assets.md`
- Hazards or pressures: Sparse/TBD
- Travel fields: transit time `{value(location.get("transit_time"))}`, recharge time `{value(location.get("recharge_time"))}`, jump zenith `{value(location.get("jump_zenith"))}` ({EVIDENCE_IMPORT})
- Open questions: Convert system id to table-facing location details only after user confirmation or source lookup.
"""


def render_factions(summary: dict[str, Any]) -> str:
    faction = value(summary["campaign"].get("faction"))
    employers = sorted({value(contract.get("employer")) for contract in summary.get("contracts", []) if value(contract.get("employer")) != "Unknown"})
    lines = [
        "# Factions",
        "",
        "## Imported Campaign Faction",
        "",
        f"### {faction}",
        "",
        "- Table role: Campaign faction from MekHQ import",
        "- Current attitude toward PCs: Sparse/TBD",
        "- Agenda: Sparse/TBD",
        "- Known assets: See `assets.md`",
        "- Important NPCs: See `npcs.md`",
        "- Obligations, debts, or leverage: Sparse/TBD",
        "- Open canon questions: Confirm table-facing faction interpretation.",
        "",
        "## Imported Employers",
        "",
    ]
    if not employers:
        lines.append("- None imported.")
    else:
        for employer in employers:
            lines.append(f"- {employer}: contract employer from MekHQ import; relationship and motive sparse/TBD.")
    return "\n".join(lines).rstrip() + "\n"


def render_session_log(summary: dict[str, Any], viewpoint: dict[str, Any]) -> str:
    return f"""# Session Log

## Active Or Most Recent Session

Date: {datetime.now(timezone.utc).date().isoformat()}

Mode: MekHQ-linked pre-session bootstrap

Player characters:

- {viewpoint["display_name"]} (initial viewpoint; confirm before play)

## Summary

Generated this campaign save from a read-only MekHQ summary import. No RPG scene has been played yet.

## Important Rolls

- None.

## State Changes

- Created campaign-local MekHQ bridge note and generated stubs for current state, viewpoint PC, NPCs, assets, missions, relationships, hooks, locations, and factions.

## Rewards And Costs

- None.

## Rules Gaps

- A Time of War sheet details for the selected viewpoint remain TBD.
- MekHQ-owned ledger changes must be applied in MekHQ and re-imported before becoming hard facts.

## Next Session

- Confirm the viewpoint and choose the first scene inside the imported MekHQ day.
"""


def render_pending_mekhq_actions() -> str:
    return """# Pending MekHQ Actions

Use this file for hard ledger intents created during MekHQ-linked RPG play. A pending item is not final until the user applies it in MekHQ, saves the MekHQ campaign, and MEK-RPG imports the saved result.

See `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md` for the full schema and lifecycle.

## Open Items

- None.

## Resolved Or Abandoned Items

- None.
"""


def render_mekhq_bridge(campaign_id: str, summary: dict[str, Any], viewpoint: dict[str, Any], summary_path: Path) -> str:
    meta = summary["bridge_metadata"]
    campaign = summary["campaign"]
    lines = [
        "# MekHQ Bridge",
        "",
        "This file records the campaign-local bridge metadata for a read-only MekHQ import. It is not a MekHQ save and must not be treated as authoritative for fields that MekHQ owns after the import changes.",
        "",
        "## Import Metadata",
        "",
        f"- MEK-RPG campaign id: `{campaign_id}`",
        f"- Bootstrap source summary: `{summary_path}`",
        f"- Bootstrap timestamp: `{datetime.now(timezone.utc).isoformat()}`",
        f"- Summary helper: `{value(meta.get('helper'))}` version `{value(meta.get('helper_version'))}`",
        f"- Source save path: `{value(meta.get('input_path'))}`",
        f"- Source save timestamp: `{value(meta.get('save_timestamp'))}`",
        f"- Summary import timestamp: `{value(meta.get('import_timestamp'))}`",
        f"- MekHQ save version: `{value(meta.get('mekhq_save_version'))}`",
        f"- Gzip compressed source: `{value(meta.get('gzip_compressed'))}`",
        "",
        "## Ownership Boundary",
        "",
        "- MekHQ owns campaign date, day advancement, travel, finances, rosters, unit condition, repairs, contracts, markets, scenarios, tactical outcomes, and hard logistics.",
        "- MEK-RPG owns RPG scenes, A Time of War overlays, conversations, relationships, promises, secrets, hooks, session logs, safety/tone, and narrative uncertainty.",
        "- Generated RPG-only personality, secrets, motives, and relationships are sparse/TBD until established during play.",
        "- Do not write to `.cpnx`, `.cpnx.gz`, MekHQ XML, or raw MekHQ save payloads from this workspace.",
        "",
        "## Campaign Snapshot",
        "",
        f"- MekHQ campaign id: `{value(campaign.get('mekhq_campaign_id'))}`",
        f"- Name: {value(campaign.get('name'))}",
        f"- Date: {value(campaign.get('date'))}",
        f"- Faction: {value(campaign.get('faction'))}",
        f"- Location: {value(campaign.get('location', {}).get('current_system_id') if isinstance(campaign.get('location'), dict) else None)}",
        f"- Funds: {funds_text(summary)}",
        f"- Viewpoint: {viewpoint['display_name']} (`{viewpoint['mekhq_person_id']}`), {viewpoint['reason']}",
        "",
        "## Counts",
        "",
        f"- Personnel: {len(summary.get('personnel', []))}",
        f"- Units: {len(summary.get('units', []))}",
        f"- Contracts: {len(summary.get('contracts', []))}",
        f"- Scenarios: {len(summary.get('scenarios', []))}",
        f"- Unit market offers: {len(summary.get('markets', {}).get('unit_market_offers', []))}",
        f"- Personnel market applicants: {len(summary.get('markets', {}).get('personnel_market_applicants', []))}",
        f"- Contract market offers: {len(summary.get('markets', {}).get('contract_market_offers', []))}",
        "",
        "## Cross-References",
        "",
        "### Personnel",
        "",
    ]
    for person in summary.get("personnel", [])[:MAX_LIST_ITEMS]:
        slug = slugify(value(person.get("display_name")), "person")
        lines.append(f"- `{value(person.get('mekhq_person_id'))}` -> `{slug}`: {value(person.get('display_name'))}")
    if not summary.get("personnel"):
        lines.append("- None imported.")
    lines.extend(["", "### Units", ""])
    for unit in summary.get("units", [])[:MAX_LIST_ITEMS]:
        slug = slugify(value(unit.get("display_name")), "unit")
        lines.append(f"- `{value(unit.get('mekhq_unit_id'))}` -> `{slug}`: {value(unit.get('display_name'))}")
    if not summary.get("units"):
        lines.append("- None imported.")
    lines.extend(["", "### Contracts", ""])
    for contract in summary.get("contracts", [])[:MAX_LIST_ITEMS]:
        slug = slugify(value(contract.get("name")), "contract")
        lines.append(f"- `{value(contract.get('mekhq_contract_id'))}` -> `{slug}`: {value(contract.get('name'))}")
    if not summary.get("contracts"):
        lines.append("- None imported.")
    lines.extend(["", "## Warnings", ""])
    warnings = list(meta.get("warnings", []))
    for unsupported in summary.get("unsupported", []):
        warnings.append(f"{value(unsupported.get('field'))}: {value(unsupported.get('reason'))} ({value(unsupported.get('evidence'))})")
    if warnings:
        for warning in warnings:
            lines.append(f"- {warning}")
    else:
        lines.append("- None reported by the summary helper.")
    lines.extend(
        [
            "",
            "## Pending MekHQ Application",
            "",
            "- Queue manual application items in `pending-mekhq-actions.md`.",
            "- Use this bridge file for import metadata, cross-references, warnings, unsupported fields, and discrepancies.",
        ]
    )
    return "\n".join(lines).rstrip() + "\n"


def write_text(path: Path, content: str) -> None:
    path.write_text(content, encoding="utf-8", newline="\n")


def create_campaign(summary_path: Path, campaign_id: str, viewpoint: dict[str, Any], summary: dict[str, Any]) -> Path:
    root = repo_root()
    campaigns_root = root / "campaigns"
    template = campaigns_root / "_template"
    target = campaigns_root / campaign_id

    if not template.is_dir():
        raise FileNotFoundError(f"Template folder not found: {template}")
    if target.exists():
        raise FileExistsError(f"Campaign already exists: {target}")

    resolved_parent = target.parent.resolve()
    if resolved_parent != campaigns_root.resolve():
        raise ValueError(f"Refusing to create a campaign outside {campaigns_root}")

    shutil.copytree(template, target)

    renderers = {
        "overview.md": render_overview(campaign_id, summary, viewpoint),
        "current-state.md": render_current_state(summary, viewpoint),
        "pcs.md": render_pcs(summary, viewpoint),
        "npcs.md": render_npcs(summary, viewpoint),
        "assets.md": render_assets(summary),
        "missions.md": render_missions(summary),
        "relationships.md": render_relationships(summary, viewpoint),
        "hooks.md": render_hooks(summary),
        "locations.md": render_locations(summary),
        "factions.md": render_factions(summary),
        "session-log.md": render_session_log(summary, viewpoint),
        "pending-mekhq-actions.md": render_pending_mekhq_actions(),
        "mekhq-bridge.md": render_mekhq_bridge(campaign_id, summary, viewpoint, summary_path),
    }
    for filename, content in renderers.items():
        write_text(target / filename, content)

    return target


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Create a MEK-RPG campaign save folder from summarize-mekhq-save.py JSON output."
    )
    parser.add_argument("--summary", required=True, help="Path to MekHQ bridge summary JSON.")
    parser.add_argument("--campaign-id", required=True, help="New campaigns/<campaign-id>/ folder to create.")
    parser.add_argument("--viewpoint-person-id", help="MekHQ personnel id to use as the initial viewpoint.")
    parser.add_argument("--viewpoint-name", help="Exact MekHQ display name to use as the initial viewpoint.")
    parser.add_argument("--embedded-pc-name", help="Create an unlinked embedded A Time of War PC as the initial viewpoint.")
    args = parser.parse_args(argv)

    selectors = [args.viewpoint_person_id, args.viewpoint_name, args.embedded_pc_name]
    if sum(1 for item in selectors if item) > 1:
        parser.error("Choose only one viewpoint selector.")

    try:
        validate_campaign_id(args.campaign_id)
        summary_path = Path(args.summary).expanduser().resolve()
        summary = load_summary(summary_path)
        viewpoint = choose_viewpoint(summary, args.viewpoint_person_id, args.viewpoint_name, args.embedded_pc_name)
        target = create_campaign(summary_path, args.campaign_id, viewpoint, summary)
    except (OSError, ValueError, json.JSONDecodeError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1

    print(f"Created campaign save: campaigns/{args.campaign_id}/")
    print(f"Viewpoint: {viewpoint['display_name']} ({viewpoint['reason']})")
    print("Review campaign-state/active-campaign.md before play; this script does not change the active campaign pointer.")
    print(f"Bridge note: {target.relative_to(repo_root()) / 'mekhq-bridge.md'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
