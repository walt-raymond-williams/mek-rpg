#!/usr/bin/env python3
"""Read a MekHQ campaign save and emit a MEK-RPG bridge summary.

The helper is intentionally read-only: it opens the supplied save, parses XML,
and writes the summary to stdout.
"""

from __future__ import annotations

import argparse
import gzip
import html
import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any
from xml.etree import ElementTree as ET


HELPER_VERSION = "0.1.0"
EVIDENCE_IMPORT = "Confirmed from MekHQ import"
EVIDENCE_INFERRED = "Inferred"
EVIDENCE_UNKNOWN = "Unknown"
EVIDENCE_UNSUPPORTED = "Unsupported"
EVIDENCE_NEEDS_INSPECTION = "Needs MekHQ inspection"


def child_text(element: ET.Element | None, name: str, default: str = "Unknown") -> str:
    if element is None:
        return default
    child = element.find(name)
    if child is None or child.text is None:
        return default
    value = child.text.strip()
    return value if value else default


def clean_text(value: str | None, limit: int = 500) -> str:
    if not value:
        return "Unknown"
    value = html.unescape(value)
    value = re.sub(r"<[^>]+>", " ", value)
    value = re.sub(r"\s+", " ", value).strip()
    if not value:
        return "Unknown"
    if len(value) > limit:
        return value[: limit - 3].rstrip() + "..."
    return value


def direct_children(element: ET.Element | None, name: str) -> list[ET.Element]:
    if element is None:
        return []
    return [child for child in list(element) if child.tag == name]


def read_save(path: Path) -> tuple[bytes, bool]:
    with path.open("rb") as handle:
        header = handle.read(2)
        handle.seek(0)
        payload = handle.read()

    is_gzip = header == b"\x1f\x8b"
    if is_gzip:
        return gzip.decompress(payload), True
    return payload, False


def parse_money(value: str) -> tuple[int | None, str | None]:
    match = re.match(r"^\s*([+-]?\d+(?:\.\d+)?)\s+([A-Za-z][A-Za-z0-9_-]*)\s*$", value or "")
    if not match:
        return None, None
    amount_text, currency = match.groups()
    try:
        amount = int(float(amount_text))
    except ValueError:
        return None, None
    return amount, currency


def summarize_finances(root: ET.Element, warnings: list[str]) -> dict[str, Any]:
    finances = root.find("finances")
    transactions = direct_children(finances.find("transactions") if finances is not None else None, "transaction")
    balances: dict[str, int] = {}
    latest_transactions: list[dict[str, Any]] = []

    for transaction in transactions:
        amount_text = child_text(transaction, "amount")
        amount, currency = parse_money(amount_text)
        if amount is not None and currency is not None:
            balances[currency] = balances.get(currency, 0) + amount

        latest_transactions.append(
            {
                "type": child_text(transaction, "type"),
                "date": child_text(transaction, "date"),
                "amount": amount_text,
                "description": clean_text(child_text(transaction, "description"), 240),
                "evidence": EVIDENCE_IMPORT,
            }
        )

    if transactions:
        warnings.append(
            "Funds are calculated from serialized finance transactions; confirm in MekHQ UI if exact balance matters."
        )

    loans = direct_children(finances.find("loans") if finances is not None else None, "loan")
    assets = direct_children(finances.find("assets") if finances is not None else None, "asset")

    return {
        "funds": {
            "calculated_balance_by_currency": balances if balances else "Unknown",
            "evidence": EVIDENCE_INFERRED if balances else EVIDENCE_UNKNOWN,
        },
        "transaction_count": len(transactions),
        "latest_transactions": latest_transactions[-10:],
        "loan_count": len(loans),
        "asset_count": len(assets),
        "loan_defaults": child_text(finances, "loanDefaults"),
        "failed_collateral": child_text(finances, "failedCollateral"),
    }


def summarize_person(person: ET.Element) -> dict[str, Any]:
    given = child_text(person, "givenName", "")
    surname = child_text(person, "surname", "")
    callsign = child_text(person, "callsign", "")
    display_name = " ".join(part for part in [given, surname] if part).strip() or "Unknown"
    if callsign:
        display_name = f'{display_name} "{callsign}"' if display_name != "Unknown" else callsign

    fatigue = child_text(person, "fatigue")
    permanent_fatigue = child_text(person, "permanentFatigue")
    days_to_heal = child_text(person, "daysToWaitForHealing")
    injury_or_fatigue_flags = []
    if days_to_heal not in ("Unknown", "0"):
        injury_or_fatigue_flags.append(f"daysToWaitForHealing={days_to_heal}")
    if fatigue not in ("Unknown", "0"):
        injury_or_fatigue_flags.append(f"fatigue={fatigue}")
    if permanent_fatigue not in ("Unknown", "0"):
        injury_or_fatigue_flags.append(f"permanentFatigue={permanent_fatigue}")

    return {
        "mekhq_person_id": person.get("id") or child_text(person, "id"),
        "display_name": display_name,
        "role": child_text(person, "primaryRole"),
        "rank": child_text(person, "rank"),
        "faction": child_text(person, "faction"),
        "assignment": {
            "unit_id": child_text(person, "unitId"),
            "evidence": EVIDENCE_IMPORT if child_text(person, "unitId") != "Unknown" else EVIDENCE_UNKNOWN,
        },
        "availability": child_text(person, "status"),
        "injury_fatigue_flags": injury_or_fatigue_flags,
        "commander": child_text(person, "commander"),
        "second_in_command": child_text(person, "secondInCommand"),
        "evidence": EVIDENCE_IMPORT,
    }


def summarize_personnel(root: ET.Element) -> list[dict[str, Any]]:
    personnel_root = root.find("./humanResources/personnel")
    return [summarize_person(person) for person in direct_children(personnel_root, "person")]


def summarize_unit(unit: ET.Element, people_by_id: dict[str, str], damaged_parts_by_unit: dict[str, list[str]]) -> dict[str, Any]:
    entity = unit.find("entity")
    chassis = entity.get("chassis") if entity is not None else None
    model = entity.get("model") if entity is not None else None
    entity_type = entity.get("type") if entity is not None else None
    unit_id = unit.get("id") or child_text(unit, "id")
    display_parts = [part for part in [chassis, model] if part]

    crew_ids = {
        "driver_id": child_text(unit, "driverId"),
        "gunner_id": child_text(unit, "gunnerId"),
        "tech_id": child_text(unit, "techId"),
    }
    crew = {
        key: {
            "id": value,
            "display_name": people_by_id.get(value, "Unknown") if value != "Unknown" else "Unknown",
        }
        for key, value in crew_ids.items()
    }

    damaged_parts = damaged_parts_by_unit.get(unit_id, [])
    return {
        "mekhq_unit_id": unit_id,
        "display_name": " ".join(display_parts) if display_parts else "Unknown",
        "chassis": chassis or "Unknown",
        "model": model or "Unknown",
        "type": entity_type or "Unknown",
        "status": {
            "site": child_text(unit, "site"),
            "formation_id": child_text(unit, "formationId"),
            "scenario_id": child_text(unit, "scenarioId"),
            "days_since_maintenance": child_text(unit, "daysSinceMaintenance"),
            "deployment": entity.get("deployment") if entity is not None and entity.get("deployment") else "Unknown",
            "evidence": EVIDENCE_IMPORT,
        },
        "location_assignment": {
            "site": child_text(unit, "site"),
            "formation_id": child_text(unit, "formationId"),
            "scenario_id": child_text(unit, "scenarioId"),
        },
        "crew": crew,
        "damage_repair_summary": {
            "linked_part_count": len(damaged_parts),
            "sample_linked_parts": damaged_parts[:8],
            "last_maintenance_report": clean_text(child_text(unit, "lastMaintenanceReport"), 300),
            "evidence": EVIDENCE_INFERRED,
        },
        "evidence": EVIDENCE_IMPORT,
    }


def summarize_units(root: ET.Element, personnel: list[dict[str, Any]]) -> list[dict[str, Any]]:
    people_by_id = {p["mekhq_person_id"]: p["display_name"] for p in personnel}
    damaged_parts_by_unit: dict[str, list[str]] = {}

    for part in direct_children(root.find("parts"), "part"):
        unit_id = child_text(part, "unitId", "")
        if not unit_id:
            continue
        damaged_parts_by_unit.setdefault(unit_id, []).append(child_text(part, "name"))

    return [
        summarize_unit(unit, people_by_id, damaged_parts_by_unit)
        for unit in direct_children(root.find("units"), "unit")
    ]


def summarize_scenario(scenario: ET.Element, contract_id: str) -> dict[str, Any]:
    return {
        "mekhq_scenario_id": scenario.get("id") or child_text(scenario, "id"),
        "contract_id": contract_id,
        "name": child_text(scenario, "name"),
        "status": child_text(scenario, "status"),
        "date": child_text(scenario, "date"),
        "objective_status_summary": clean_text(child_text(scenario, "desc"), 300),
        "evidence": EVIDENCE_IMPORT,
    }


def summarize_missions(root: ET.Element) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    contracts = []
    scenarios = []
    for mission in direct_children(root.find("missions"), "mission"):
        mission_id = mission.get("id") or child_text(mission, "id")
        contract = {
            "mekhq_contract_id": mission_id,
            "name": child_text(mission, "name"),
            "type": child_text(mission, "type"),
            "employer": child_text(mission, "employer"),
            "status": child_text(mission, "status"),
            "deadline": child_text(mission, "endDate"),
            "system_id": child_text(mission, "systemId"),
            "objective_summary": clean_text(child_text(mission, "desc"), 300),
            "terms_summary": {
                "payment_multiplier": child_text(mission, "paymentMultiplier"),
                "salvage_pct": child_text(mission, "salvagePct"),
                "command_rights": child_text(mission, "commandRights"),
                "transport_comp": child_text(mission, "transportComp"),
                "support_amount": child_text(mission, "supportAmount"),
                "advance_amount": child_text(mission, "advanceAmount"),
                "base_amount": child_text(mission, "baseAmount"),
                "fee_amount": child_text(mission, "feeAmount"),
            },
            "evidence": EVIDENCE_IMPORT,
        }
        contracts.append(contract)

        scenarios_root = mission.find("scenarios")
        for scenario in direct_children(scenarios_root, "scenario"):
            scenarios.append(summarize_scenario(scenario, mission_id))

    return contracts, scenarios


def summarize_repairs_and_logistics(root: ET.Element) -> dict[str, Any]:
    shopping_items = []
    for item in direct_children(root.find("shoppingList"), "part"):
        shopping_items.append(
            {
                "id": item.get("id") or child_text(item, "id"),
                "type": item.get("type") or "Unknown",
                "name": child_text(item, "name"),
                "quantity": child_text(item, "quantity"),
                "quality": child_text(item, "quality"),
                "unit_id": child_text(item, "unitId"),
                "evidence": EVIDENCE_IMPORT,
            }
        )

    parts = direct_children(root.find("parts"), "part")
    unit_linked_parts = [part for part in parts if child_text(part, "unitId", "") != ""]

    return {
        "alerts": [
            {
                "message": "Detailed daily-report alerts are not mapped by this prototype.",
                "evidence": EVIDENCE_UNSUPPORTED,
            }
        ],
        "shopping_list": shopping_items,
        "shopping_list_count": len(shopping_items),
        "parts_count": len(parts),
        "unit_linked_parts_count": len(unit_linked_parts),
        "as_tech_pool": child_text(root.find("humanResources"), "asTechPool"),
        "as_tech_pool_minutes": child_text(root.find("humanResources"), "asTechPoolMinutes"),
        "medic_pool": child_text(root.find("humanResources"), "medicPool"),
        "transport_cargo_pressure": {
            "status": "Needs MekHQ inspection",
            "evidence": EVIDENCE_NEEDS_INSPECTION,
        },
    }


def summarize_markets(root: ET.Element) -> dict[str, Any]:
    unit_offers = []
    for offer in direct_children(root.find("unitMarket"), "offer"):
        unit_offers.append(
            {
                "market": child_text(offer, "market"),
                "unit_type": child_text(offer, "unitType"),
                "unit_name": child_text(offer, "unit"),
                "price_percent": child_text(offer, "percent"),
                "transit_duration": child_text(offer, "transitDuration"),
                "price": {
                    "value": "Unsupported",
                    "reason": "MekHQ derives final unit-market price from unit cost, offer percent, and campaign price multipliers.",
                    "evidence": EVIDENCE_UNSUPPORTED,
                },
                "evidence": EVIDENCE_IMPORT,
            }
        )

    personnel_market_root = root.find("personnelMarket")
    if personnel_market_root is None:
        personnel_market_root = root.find("./humanResources/personnelMarket")
    personnel_offers = [summarize_person(person) for person in direct_children(personnel_market_root, "person")]

    contract_market = root.find("contractMarket")
    contract_offer_elements = direct_children(contract_market, "contract") + direct_children(contract_market, "mission")
    contract_offers = []
    for offer in contract_offer_elements:
        contract_offers.append(
            {
                "mekhq_contract_id": offer.get("id") or child_text(offer, "id"),
                "name": child_text(offer, "name"),
                "employer": child_text(offer, "employer"),
                "status": child_text(offer, "status"),
                "deadline": child_text(offer, "endDate"),
                "evidence": EVIDENCE_IMPORT,
            }
        )

    return {
        "unit_market_offers": unit_offers,
        "personnel_market_applicants": personnel_offers,
        "contract_market_offers": contract_offers,
        "contract_market_metadata": {
            "method": child_text(contract_market, "method"),
            "last_id": child_text(contract_market, "lastId"),
            "offer_count_note": (
                "No direct contract or mission offer elements found."
                if not contract_offers
                else "Direct offer elements found."
            ),
            "evidence": EVIDENCE_IMPORT if contract_market is not None else EVIDENCE_UNKNOWN,
        },
    }


def summarize_campaign(root: ET.Element) -> dict[str, Any]:
    info = root.find("info")
    location = root.find("./locations/location")
    return {
        "mekhq_campaign_id": child_text(info, "id"),
        "name": child_text(info, "name"),
        "date": child_text(info, "calendar"),
        "campaign_start_date": child_text(info, "campaignStartDate"),
        "faction": child_text(info, "faction"),
        "location": {
            "current_system_id": child_text(location, "currentSystemId"),
            "transit_time": child_text(location, "transitTime"),
            "recharge_time": child_text(location, "rechargeTime"),
            "jump_zenith": child_text(location, "jumpZenith"),
            "evidence": EVIDENCE_IMPORT if location is not None else EVIDENCE_UNKNOWN,
        },
        "reputation": child_text(info, "reputation"),
        "gm_mode": child_text(info, "gmMode"),
        "evidence": EVIDENCE_IMPORT,
    }


def build_summary(path: Path) -> dict[str, Any]:
    resolved = path.expanduser().resolve()
    stat = resolved.stat()
    payload, is_gzip = read_save(resolved)
    root = ET.fromstring(payload)
    warnings: list[str] = []

    if root.tag != "campaign":
        warnings.append(f"Expected root element 'campaign' but found '{root.tag}'.")

    finances = summarize_finances(root, warnings)
    campaign = summarize_campaign(root)
    campaign["funds"] = finances["funds"]
    personnel = summarize_personnel(root)
    units = summarize_units(root, personnel)
    contracts, scenarios = summarize_missions(root)
    markets = summarize_markets(root)

    unsupported = [
        {
            "field": "unit_market_final_prices",
            "reason": "Serialized offers include percent and unit name; final price requires MekHQ unit cost lookup and campaign multipliers.",
            "evidence": EVIDENCE_UNSUPPORTED,
        },
        {
            "field": "exact_unit_damage_state",
            "reason": "Prototype reports linked parts and maintenance text but does not translate MekHQ entity locations, armor, internals, or critical slots.",
            "evidence": EVIDENCE_UNSUPPORTED,
        },
        {
            "field": "transport_capacity_and_cargo_pressure",
            "reason": "Top-level location and unit sections are read, but transport-capacity semantics are not mapped yet.",
            "evidence": EVIDENCE_NEEDS_INSPECTION,
        },
        {
            "field": "daily_report_alerts",
            "reason": "Report fields can contain presentation HTML; prototype does not classify them into finance, medical, repair, or logistics alerts.",
            "evidence": EVIDENCE_UNSUPPORTED,
        },
    ]

    return {
        "bridge_metadata": {
            "helper": "summarize-mekhq-save.py",
            "helper_version": HELPER_VERSION,
            "input_path": str(resolved),
            "save_timestamp": datetime.fromtimestamp(stat.st_mtime, timezone.utc).isoformat(),
            "import_timestamp": datetime.now(timezone.utc).isoformat(),
            "input_size_bytes": stat.st_size,
            "gzip_compressed": is_gzip,
            "mekhq_save_version": root.get("version", "Unknown"),
            "warnings": warnings,
            "unsupported_sections": [item["field"] for item in unsupported],
        },
        "campaign": campaign,
        "finances": finances,
        "personnel": personnel,
        "units": units,
        "contracts": contracts,
        "scenarios": scenarios,
        "repairs_and_logistics": summarize_repairs_and_logistics(root),
        "markets": markets,
        "unsupported": unsupported,
    }


def render_markdown(summary: dict[str, Any]) -> str:
    meta = summary["bridge_metadata"]
    campaign = summary["campaign"]
    finances = summary["finances"]
    lines = [
        "# MekHQ Save Summary",
        "",
        "## Bridge Metadata",
        "",
        f"- Helper: `{meta['helper']}` version `{meta['helper_version']}`",
        f"- Input path: `{meta['input_path']}`",
        f"- Save timestamp: `{meta['save_timestamp']}`",
        f"- Import timestamp: `{meta['import_timestamp']}`",
        f"- Gzip compressed: `{meta['gzip_compressed']}`",
        f"- MekHQ save version: `{meta['mekhq_save_version']}`",
        "",
        "## Campaign",
        "",
        f"- Name: {campaign['name']}",
        f"- Date: {campaign['date']}",
        f"- Faction: {campaign['faction']}",
        f"- Location: {campaign['location']['current_system_id']}",
        f"- Funds: {finances['funds']['calculated_balance_by_currency']}",
        "",
        "## Counts",
        "",
        f"- Personnel: {len(summary['personnel'])}",
        f"- Units: {len(summary['units'])}",
        f"- Contracts: {len(summary['contracts'])}",
        f"- Scenarios: {len(summary['scenarios'])}",
        f"- Unit market offers: {len(summary['markets']['unit_market_offers'])}",
        f"- Personnel market applicants: {len(summary['markets']['personnel_market_applicants'])}",
        f"- Shopping list items: {summary['repairs_and_logistics']['shopping_list_count']}",
        "",
        "## Active Contracts",
        "",
    ]

    if summary["contracts"]:
        for contract in summary["contracts"]:
            lines.append(
                f"- `{contract['mekhq_contract_id']}` {contract['name']} ({contract['status']}), employer {contract['employer']}, deadline {contract['deadline']}"
            )
    else:
        lines.append("- None found.")

    lines.extend(["", "## Unsupported Or Needs Inspection", ""])
    for item in summary["unsupported"]:
        lines.append(f"- {item['field']}: {item['reason']} ({item['evidence']})")

    if meta["warnings"]:
        lines.extend(["", "## Warnings", ""])
        for warning in meta["warnings"]:
            lines.append(f"- {warning}")

    return "\n".join(lines) + "\n"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Read a MekHQ .cpnx, .cpnx.gz, or campaign XML save and emit a read-only MEK-RPG summary."
    )
    parser.add_argument("path", help="Explicit path to a MekHQ save or plain campaign XML file.")
    parser.add_argument(
        "--format",
        choices=("json", "markdown"),
        default="json",
        help="Output format. Default: json.",
    )
    args = parser.parse_args(argv)

    path = Path(args.path)
    if not path.exists() or not path.is_file():
        parser.error(f"Save path not found or not a file: {path}")

    summary = build_summary(path)
    if args.format == "json":
        json.dump(summary, sys.stdout, indent=2, ensure_ascii=False)
        sys.stdout.write("\n")
    else:
        sys.stdout.write(render_markdown(summary))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
