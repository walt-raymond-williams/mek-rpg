#!/usr/bin/env python3
"""Build an education/scholarship triage report from a MekHQ live API capture."""

from __future__ import annotations

import argparse
import csv
import json
import sys
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path


SCHEMA_VERSION = "mek-rpg-mekhq-education-tracker/v2"

WARRIOR_SKILL_PREFIXES = (
    "Gunnery/",
    "Piloting/",
    "Aerospace",
    "Tech/Mek",
    "Tech/Aero",
    "Tactics",
    "Strategy",
    "Leadership",
)

WARRIOR_OPTION_TERMS = (
    "Exceptional Attribute - Dexterity",
    "Exceptional Attribute - Reflexes",
    "Natural Aptitude",
    "Fast Learner",
    "Sixth Sense",
    "Pain Resistance",
    "Toughness",
    "Gunnery Specialization",
    "Hot Dog",
    "Multi-Tasker",
    "Melee Master",
    "Dodge",
    "Ambidextrous",
    "Good Vision",
)


def load_json(path: Path) -> object:
    try:
        with path.open("r", encoding="utf-8-sig") as handle:
            return json.load(handle)
    except FileNotFoundError:
        raise SystemExit(f"ERROR: file not found: {path}")
    except json.JSONDecodeError as exc:
        raise SystemExit(f"ERROR: invalid JSON in {path}: {exc}")


def get_value(obj: object, *path: str, default: object = "") -> object:
    current = obj
    for part in path:
        if not isinstance(current, dict):
            return default
        current = current.get(part, default)
    if isinstance(current, dict) and "value" in current:
        current = current["value"]
    return default if current is None else current


def text_value(obj: object, *path: str) -> str:
    value = get_value(obj, *path)
    if isinstance(value, bool):
        return "true" if value else "false"
    return str(value) if value is not None else ""


def compact_list(values: list[str], limit: int = 8) -> str:
    cleaned = [value.strip() for value in values if value and value.strip()]
    if len(cleaned) <= limit:
        return "; ".join(cleaned)
    return "; ".join(cleaned[:limit]) + f"; +{len(cleaned) - limit} more"


def education_current_record(person: dict) -> dict:
    summary = person.get("education_summary")
    if not isinstance(summary, dict):
        return {}
    record = summary.get("current_record")
    return record if isinstance(record, dict) else {}


def education_requires_assignment_review(person: dict) -> bool:
    summary = person.get("education_summary")
    record = education_current_record(person)
    return bool(
        (isinstance(summary, dict) and summary.get("requires_assignment_review"))
        or record.get("requires_assignment_review")
    )


def summarize_skills(person: dict) -> tuple[str, str]:
    skills = person.get("skill_summary")
    if not isinstance(skills, list):
        return ("", "")

    rendered: list[str] = []
    warrior: list[str] = []
    for skill in skills:
        if not isinstance(skill, dict):
            continue
        name = str(skill.get("skill_name") or skill.get("display_name") or skill.get("name") or "")
        if not name:
            continue
        level = skill.get("level", "")
        final_value = skill.get("final_value", "")
        label = name
        if level != "" or final_value != "":
            label = f"{name} L{level}/FV{final_value}"
        rendered.append(label)
        if name.startswith(WARRIOR_SKILL_PREFIXES):
            warrior.append(label)

    return (compact_list(rendered, 10), compact_list(warrior, 10))


def summarize_options(person: dict) -> tuple[str, str]:
    options = person.get("traits_or_options_summary")
    if not isinstance(options, list):
        return ("", "")

    rendered: list[str] = []
    notable: list[str] = []
    seen: set[str] = set()
    for option in options:
        if not isinstance(option, dict):
            continue
        name = str(option.get("name") or option.get("display_name") or option.get("id") or "")
        if not name or name in seen:
            continue
        seen.add(name)
        group = str(option.get("group") or "")
        if group != "edgeAdvantages":
            rendered.append(name)
        if any(term.casefold() in name.casefold() for term in WARRIOR_OPTION_TERMS):
            notable.append(name)

    return (compact_list(rendered, 8), compact_list(notable, 8))


def scout_priority_and_reasons(person: dict, tracking_status: str) -> tuple[str, str]:
    reasons: list[str] = []
    priority = "low"
    _, warrior_skills = summarize_skills(person)
    _, notable_options = summarize_options(person)
    record = education_current_record(person)
    program = str(record.get("program_name") or "")
    role = text_value(person, "primary_role", "label")

    if warrior_skills:
        reasons.append(f"combat/aerospace skills: {warrior_skills}")
        priority = "high"
    if notable_options:
        reasons.append(f"notable traits/options: {notable_options}")
        priority = "high"
    if any(term in program.casefold() for term in ("mekwarrior", "flight", "aerospace", "war fighting", "naval")):
        reasons.append(f"martial education program: {program}")
        priority = "high"
    if role in {"MekWarrior", "Aerospace Pilot", "Vehicle Crew/Ground", "Vehicle Crew/Naval", "Conventional Aircraft Pilot"}:
        reasons.append(f"current role: {role}")
        priority = "high"
    if education_requires_assignment_review(person):
        reasons.append("MekHQ marks education as requiring assignment review")
        priority = "high"
    if tracking_status == "dependent_on_payroll_review" and priority == "high":
        reasons.append("dependent/background scout candidate")
    if not reasons:
        reasons.append("no warrior-candidate signal in compact summaries")

    return priority, compact_list(reasons, 6)


def validate_live_state(state: dict, state_file: Path) -> None:
    metadata = state.get("bridge_metadata")
    if not isinstance(metadata, dict):
        raise SystemExit(f"ERROR: {state_file} is missing bridge_metadata.")
    if metadata.get("api_mode") != "local-read-only-live-context":
        raise SystemExit("ERROR: state file is not a live read-only context capture.")
    if metadata.get("read_only") is not True:
        raise SystemExit("ERROR: state file does not prove read_only=true.")
    if not isinstance(state.get("personnel"), list):
        raise SystemExit(f"ERROR: {state_file} does not contain a personnel list.")


def classify_person(person: dict) -> tuple[str, str, str]:
    status = text_value(person, "status", "label")
    rank = text_value(person, "rank", "label")
    role = text_value(person, "primary_role", "label")

    if status == "Student":
        return (
            "enrolled_current",
            "high",
            "MekHQ currently marks this person as Student; keep on the school roster until status changes.",
        )
    if education_requires_assignment_review(person):
        return (
            "graduation_candidate",
            "high",
            "MekHQ education summary marks this person for assignment review after training.",
        )
    if rank == "Recruit" and status in {"Active", "Background Character", "Camp Follower"}:
        return (
            "graduation_candidate",
            "high",
            "Rank remains Recruit but status is no longer Student; review as a likely missed graduate or job-assignment candidate.",
        )
    if status == "Background Character" and role != "Dependent":
        return (
            "background_role_review",
            "medium",
            "Background character has a non-dependent role; review for whether this should become an assigned job.",
        )
    if role == "Dependent" and status == "Left":
        return (
            "departed_dependent",
            "low",
            "Dependent is no longer with the command; keep historical only unless the table says they returned.",
        )
    if role == "Dependent":
        return (
            "dependent_on_payroll_review",
            "medium",
            "Dependent remains in the live personnel export; review scholarship/enrollment status manually.",
        )
    return ("not_tracked", "low", "No education-tracker trigger matched.")


def build_rows(state: dict) -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    for person in state["personnel"]:
        if not isinstance(person, dict):
            continue
        status = text_value(person, "status", "label")
        rank = text_value(person, "rank", "label")
        role = text_value(person, "primary_role", "label")
        tracking_status, priority, note = classify_person(person)
        if tracking_status == "not_tracked":
            continue
        record = education_current_record(person)
        education_summary = person.get("education_summary") if isinstance(person.get("education_summary"), dict) else {}
        all_skills, warrior_skills = summarize_skills(person)
        non_edge_options, notable_options = summarize_options(person)
        scout_priority, scout_reasons = scout_priority_and_reasons(person, tracking_status)
        if scout_priority == "high":
            priority = "high"
        rows.append(
            {
                "tracking_status": tracking_status,
                "review_priority": priority,
                "scout_priority": scout_priority,
                "scout_reasons": scout_reasons,
                "person_id": text_value(person, "id"),
                "display_name": text_value(person, "display_name"),
                "full_title": text_value(person, "full_title"),
                "mekhq_status": status,
                "rank": rank,
                "primary_role": role,
                "secondary_role": text_value(person, "secondary_role", "label"),
                "unit_id": text_value(person, "assignments", "unit_id"),
                "unit_name": text_value(person, "assignments", "unit_name"),
                "crew_role": text_value(person, "assignments", "crew_role"),
                "formation_id": text_value(person, "assignments", "formation_id"),
                "formation_name": text_value(person, "assignments", "formation_name"),
                "employed": text_value(person, "assignments", "employed"),
                "deployed": text_value(person, "assignments", "deployed"),
                "joined_campaign": text_value(person, "assignments", "joined_campaign"),
                "recruitment_date": text_value(person, "assignments", "recruitment_date"),
                "salary": text_value(person, "salary", "value"),
                "highest_education": text_value(education_summary, "highest_education", "label"),
                "education_status": str(record.get("education_status") or ""),
                "education_stage": text_value(record, "stage", "label"),
                "school_name": str(record.get("school_name") or ""),
                "program_name": str(record.get("program_name") or ""),
                "credential_or_qualification": str(record.get("credential_or_qualification") or ""),
                "target_role": str(record.get("target_role") or ""),
                "enrolled_on": str(record.get("enrolled_on") or ""),
                "expected_graduation": str(record.get("expected_graduation_on") or ""),
                "graduated_on": str(record.get("actual_graduation_on") or ""),
                "days_remaining": str(record.get("days_remaining") if record.get("days_remaining") is not None else ""),
                "journey_time_days": str(record.get("journey_time_days") if record.get("journey_time_days") is not None else ""),
                "travel_days_elapsed": str(record.get("travel_days_elapsed") if record.get("travel_days_elapsed") is not None else ""),
                "requires_assignment_review": "true" if education_requires_assignment_review(person) else "false",
                "latest_education_event": text_value(education_summary, "latest_history_event", "text"),
                "warrior_skills": warrior_skills,
                "skill_summary": all_skills,
                "notable_traits_or_options": notable_options,
                "traits_or_options_summary": non_edge_options,
                "target_job": "",
                "assignment_action": "",
                "review_note": note,
            }
        )
    return rows


def sort_rows(rows: list[dict[str, str]]) -> list[dict[str, str]]:
    priority_order = {"high": 0, "medium": 1, "low": 2}
    status_order = {
        "enrolled_current": 0,
        "graduation_candidate": 1,
        "background_role_review": 2,
        "dependent_on_payroll_review": 3,
        "departed_dependent": 4,
    }
    return sorted(
        rows,
        key=lambda row: (
            priority_order.get(row["review_priority"], 9),
            status_order.get(row["tracking_status"], 9),
            row["joined_campaign"],
            row["display_name"].casefold(),
        ),
    )


def write_csv(rows: list[dict[str, str]], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.DictWriter(handle, fieldnames=list(rows[0].keys()) if rows else [])
        if rows:
            writer.writeheader()
            writer.writerows(rows)


def markdown_table(rows: list[dict[str, str]], limit: int) -> list[str]:
    lines = [
        "| Priority | Scout | Tracker status | Name | Role | School/program | ETA | Candidate signals | Review note |",
        "| --- | --- | --- | --- | --- | --- | --- | --- | --- |",
    ]
    for row in rows[:limit]:
        lines.append(
            "| {review_priority} | {scout_priority} | {tracking_status} | {display_name} | {primary_role} | {school_name} / {program_name} | {days_remaining} days | {scout_reasons} | {review_note} |".format(
                **{key: escape_md(value) for key, value in row.items()}
            )
        )
    return lines


def escape_md(value: str) -> str:
    return value.replace("|", "\\|").replace("\n", " ").strip()


def render_markdown(state: dict, rows: list[dict[str, str]], limit: int, csv_path: Path | None) -> str:
    campaign = state["campaign"]
    metadata = state["bridge_metadata"]
    counter = Counter(row["tracking_status"] for row in rows)
    priority_counter = Counter(row["review_priority"] for row in rows)
    scout_counter = Counter(row["scout_priority"] for row in rows)
    school_counter = Counter(row["school_name"] or "Unknown" for row in rows)
    program_counter = Counter(row["program_name"] or "Unknown" for row in rows)
    generated_at = datetime.now(timezone.utc).replace(microsecond=0).isoformat()

    lines = [
        "# Education Tracker Snapshot",
        "",
        f"Schema: `{SCHEMA_VERSION}`",
        f"Generated: {generated_at}",
        "",
        "## Source",
        "",
        f"- Campaign: {text_value(campaign, 'name') or 'Unknown'}",
        f"- Campaign date: {text_value(campaign, 'date') or 'Unknown'}",
        f"- Location: {text_value(campaign, 'location', 'table_safe_location_label') or text_value(campaign, 'location', 'current_location_display_name') or 'Unknown'}",
        f"- Snapshot id: `{metadata.get('snapshot_id', 'Unknown')}`",
        f"- State revision: `{metadata.get('state_revision', 'Unknown')}`",
        "- Evidence: Confirmed from MekHQ live API for roster, compact education, compact skills, and compact traits/options.",
    ]
    if csv_path:
        lines.append(f"- Full candidate CSV: `{csv_path.as_posix()}`")
    lines.extend(
        [
            "",
            "## Current Counts",
            "",
            f"- Total MekHQ personnel records: {len(state['personnel'])}",
            f"- Tracked education/scholarship candidates: {len(rows)}",
            f"- Current MekHQ students: {counter['enrolled_current']}",
            f"- Likely missed-graduation/job candidates: {counter['graduation_candidate']}",
            f"- Background role review candidates: {counter['background_role_review']}",
            f"- Dependent payroll/scholarship review candidates: {counter['dependent_on_payroll_review']}",
            f"- Departed dependents kept for history: {counter['departed_dependent']}",
            f"- High priority rows: {priority_counter['high']}",
            f"- Medium priority rows: {priority_counter['medium']}",
            f"- Low priority rows: {priority_counter['low']}",
            f"- High-priority warrior scout rows: {scout_counter['high']}",
            f"- Rows requiring MekHQ assignment review: {sum(1 for row in rows if row['requires_assignment_review'] == 'true')}",
            "",
            "## Current Schools",
            "",
            *[f"- {school}: {count}" for school, count in school_counter.most_common(12) if school != "Unknown"],
            "",
            "## Current Programs",
            "",
            *[f"- {program}: {count}" for program, count in program_counter.most_common(12) if program != "Unknown"],
            "",
            "## Review Rules",
            "",
            "- MekHQ-owned fields: name, id, status, rank, role, salary, assignment, education status, school, program, expected graduation, days remaining, compact skills, and compact traits/options.",
            "- MEK-RPG-owned overlay fields: target job and assignment action.",
            "- Treat `Student` as currently enrolled.",
            "- Treat `requires_assignment_review=true` as a high-priority job-assignment review.",
            "- Treat `Recruit` rank without `Student` status as a high-priority missed-graduation/job-assignment review.",
            "- Treat non-dependent `Background Character` records as possible civilians or specialists who need a deliberate job decision.",
            "- Do not apply final job, payroll, rank, or assignment changes in MEK-RPG; queue them for MekHQ UI or guarded command support.",
            "",
            "## High Priority Snapshot",
            "",
        ]
    )
    high_rows = [row for row in rows if row["review_priority"] == "high"]
    lines.extend(markdown_table(high_rows, limit))
    if len(high_rows) > limit:
        lines.append(f"\nShowing {limit} of {len(high_rows)} high-priority rows. Use the CSV for the full list.")
    lines.extend(
        [
            "",
            "## Next Review Pass",
            "",
            "1. Filter the CSV to `tracking_status=enrolled_current`; review school, program, expected graduation, and days remaining.",
            "2. Filter to `tracking_status=graduation_candidate`; assign each person a target job or mark them as intentionally unassigned.",
            "3. Filter to `scout_priority=high`; review warrior skills, notable traits/options, and martial education programs.",
            "4. Filter to `tracking_status=background_role_review` or `dependent_on_payroll_review`; decide whether each person should stay background, become active staff, or leave payroll.",
            "5. Record confirmed MekHQ ledger changes in `pending-mekhq-actions.md` before applying them in MekHQ.",
        ]
    )
    return "\n".join(lines) + "\n"


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--state-file", required=True, type=Path, help="Captured mekhq-state.json file.")
    parser.add_argument("--csv-out", type=Path, help="Optional CSV output path for all tracked candidates.")
    parser.add_argument("--markdown-out", type=Path, help="Optional Markdown output path for the tracker snapshot.")
    parser.add_argument("--limit", type=int, default=80, help="Maximum high-priority rows shown in Markdown.")
    args = parser.parse_args(argv)

    state = load_json(args.state_file)
    if not isinstance(state, dict):
        raise SystemExit("ERROR: state file must contain a JSON object.")
    validate_live_state(state, args.state_file)

    rows = sort_rows(build_rows(state))
    if args.csv_out:
        write_csv(rows, args.csv_out)

    markdown = render_markdown(state, rows, args.limit, args.csv_out)
    if args.markdown_out:
        args.markdown_out.parent.mkdir(parents=True, exist_ok=True)
        args.markdown_out.write_text(markdown, encoding="utf-8")
    else:
        sys.stdout.write(markdown)

    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
