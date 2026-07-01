#!/usr/bin/env python3
"""Query compact views from captured MekHQ live API JSON files."""

from __future__ import annotations

import argparse
import json
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


SCHEMA_VERSION = "mek-rpg-mekhq-live-api-query-view/v1"
CAPTURE_SCHEMA_VERSION = "mek-rpg-mekhq-live-api-capture/v1"
API_MODE = "local-read-only-live-context"
EVIDENCE_LIVE = "confirmed_live_api"
EVIDENCE_MANIFEST = "confirmed_capture_manifest"
EVIDENCE_COMPUTED = "computed_from_live_api"
EVIDENCE_UNSUPPORTED = "unsupported_by_api"
EVIDENCE_MISSING = "missing_from_capture"
EVIDENCE_FAILED = "capture_failed"
EVIDENCE_PARTIAL = "partial_response"
EVIDENCE_UNKNOWN = "unknown"

STANDARD_FILES = {
    "manifest": "mekhq-live-api-capture-manifest.json",
    "status": "mekhq-status.json",
    "summary": "mekhq-summary.json",
    "state": "mekhq-state.json",
    "commands": "mekhq-commands.json",
    "commands_full": "mekhq-commands-full.json",
    "pending_deployments": "mekhq-pending-deployments.json",
    "pending_deployments_viewpoint": "mekhq-pending-deployments-viewpoint.json",
    "person_detail": "mekhq-personnel-detail.json",
}

REJECTED_SUFFIXES = (".cpnx", ".cpnx.gz", ".xml", ".pdf", ".epub")
PROTECTED_PARTS = (
    ("source", "atow-pdf"),
    ("source", "atow-text"),
)


class QueryError(Exception):
    """Expected validation failure for query inputs."""


def utc_now() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")


def repo_root() -> Path:
    return Path(__file__).resolve().parents[1]


def display_path(path: Path) -> str:
    try:
        return path.resolve().relative_to(repo_root()).as_posix()
    except ValueError:
        return path.name


def normalize_path(raw_path: str | None) -> Path | None:
    if not raw_path:
        return None
    path = Path(raw_path).expanduser()
    reject_path(path)
    return path


def reject_path(path: Path) -> None:
    text = str(path).replace("\\", "/").lower()
    if text.endswith(REJECTED_SUFFIXES):
        raise QueryError(f"Rejected non-capture input path: {path}")
    parts = tuple(part.lower() for part in path.parts)
    for protected in PROTECTED_PARTS:
        for index in range(0, len(parts) - len(protected) + 1):
            if parts[index : index + len(protected)] == protected:
                raise QueryError(f"Rejected protected source path: {path}")


def load_json(path: Path) -> Any:
    reject_path(path)
    if not path.is_file():
        raise FileNotFoundError(path)
    with path.open("r", encoding="utf-8-sig") as handle:
        return json.load(handle)


def as_object(value: Any, label: str) -> dict[str, Any]:
    if not isinstance(value, dict):
        raise QueryError(f"{label} must be a JSON object.")
    return value


def raw_value(value: Any, default: Any = None) -> Any:
    if isinstance(value, dict) and "value" in value:
        return value.get("value", default)
    return value if value is not None else default


def string_value(value: Any, default: str = "Unknown") -> str:
    value = raw_value(value, default)
    if value is None:
        return default
    if isinstance(value, str):
        stripped = value.strip()
        return stripped if stripped else default
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return str(value)
    if isinstance(value, dict):
        for key in ("label", "display_name", "name", "full_name", "short_name", "raw_code"):
            if key in value:
                return string_value(value.get(key), default)
    return default


def fact(value: Any, evidence: str, source_file: str, source_path: str) -> dict[str, Any]:
    return {
        "value": value,
        "evidence": evidence,
        "source_file": source_file,
        "source_path": source_path,
    }


def count_list(value: Any) -> int:
    return len(value) if isinstance(value, list) else 0


def collect_input_paths(args: argparse.Namespace) -> dict[str, Path]:
    paths: dict[str, Path] = {}
    capture_dir = normalize_path(args.capture_dir)
    if capture_dir:
        if not capture_dir.is_dir():
            raise QueryError(f"Capture directory not found: {capture_dir}")
        for key, filename in STANDARD_FILES.items():
            candidate = capture_dir / filename
            reject_path(candidate)
            if candidate.is_file():
                paths[key] = candidate
        for error_file in sorted(capture_dir.glob("*.error.json")):
            reject_path(error_file)
            paths[f"error:{error_file.name}"] = error_file

    explicit = {
        "manifest": normalize_path(args.manifest_file),
        "status": normalize_path(args.status_file),
        "summary": normalize_path(args.summary_file),
        "state": normalize_path(args.state_file),
        "commands": normalize_path(args.commands_file),
        "pending_deployments": normalize_path(args.pending_deployments_file),
        "person_detail": normalize_path(args.person_detail_file),
    }
    for key, path in explicit.items():
        if path is not None:
            paths[key] = path

    if not paths:
        raise QueryError("Pass --capture-dir or at least one explicit capture JSON file.")
    return paths


def load_inputs(paths: dict[str, Path]) -> tuple[dict[str, Any], list[dict[str, Any]], list[dict[str, Any]]]:
    loaded: dict[str, Any] = {}
    warnings: list[dict[str, Any]] = []
    gaps: list[dict[str, Any]] = []
    for key, path in paths.items():
        try:
            loaded[key] = load_json(path)
        except json.JSONDecodeError as exc:
            raise QueryError(f"Invalid JSON in {path}: {exc}") from exc
        except FileNotFoundError:
            warnings.append(
                {
                    "message": f"Capture file is missing: {display_path(path)}",
                    "evidence": EVIDENCE_MISSING,
                    "source_file": path.name,
                }
            )
            gaps.append(
                {
                    "area": "capture_file",
                    "field": path.name,
                    "reason": "Explicit capture file path was provided but the file does not exist.",
                    "evidence": EVIDENCE_MISSING,
                    "blocks_view": True,
                }
            )
    return loaded, warnings, gaps


def manifest_status(manifest: dict[str, Any] | None) -> str | None:
    if not manifest:
        return None
    return string_value(manifest.get("status"), "unknown").lower()


def endpoint_results(manifest: dict[str, Any] | None) -> list[dict[str, Any]]:
    if not manifest:
        return []
    results = manifest.get("results")
    return results if isinstance(results, list) else []


def collect_manifest_warnings(manifest: dict[str, Any] | None) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    warnings: list[dict[str, Any]] = []
    gaps: list[dict[str, Any]] = []
    if manifest is None:
        warnings.append(
            {
                "message": "Capture manifest is missing; endpoint success and capture freshness are unverified.",
                "evidence": EVIDENCE_MISSING,
                "source_file": STANDARD_FILES["manifest"],
            }
        )
        gaps.append(
            {
                "area": "capture_manifest",
                "field": STANDARD_FILES["manifest"],
                "reason": "Manifest was not available to prove endpoint capture status.",
                "evidence": EVIDENCE_MISSING,
                "blocks_view": False,
            }
        )
        return warnings, gaps

    status = manifest_status(manifest)
    if status == "partial":
        warnings.append(
            {
                "message": "Capture manifest reports partial status.",
                "evidence": EVIDENCE_PARTIAL,
                "source_file": STANDARD_FILES["manifest"],
                "source_path": "$.status",
            }
        )
    elif status == "failed":
        warnings.append(
            {
                "message": "Capture manifest reports failed status.",
                "evidence": EVIDENCE_FAILED,
                "source_file": STANDARD_FILES["manifest"],
                "source_path": "$.status",
            }
        )

    for result in endpoint_results(manifest):
        if not isinstance(result, dict):
            continue
        result_status = string_value(result.get("status"), "unknown").lower()
        if result_status == "captured":
            continue
        gaps.append(
            {
                "area": "capture_endpoint",
                "field": string_value(result.get("name"), "unknown"),
                "reason": string_value(result.get("error"), "Endpoint capture did not complete."),
                "evidence": EVIDENCE_FAILED,
                "source_file": STANDARD_FILES["manifest"],
                "source_path": "$.results[]",
                "blocks_view": bool(result.get("required")),
            }
        )
    return warnings, gaps


def collect_error_file_warnings(loaded: dict[str, Any]) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    warnings: list[dict[str, Any]] = []
    gaps: list[dict[str, Any]] = []
    for key, payload in loaded.items():
        if not key.startswith("error:"):
            continue
        error_file = key.removeprefix("error:")
        record = payload if isinstance(payload, dict) else {}
        warnings.append(
            {
                "message": f"Endpoint error capture is present: {error_file}",
                "evidence": EVIDENCE_FAILED,
                "source_file": error_file,
            }
        )
        gaps.append(
            {
                "area": "capture_endpoint",
                "field": string_value(record.get("name"), error_file),
                "reason": string_value(record.get("error"), "Endpoint error file was captured."),
                "evidence": EVIDENCE_FAILED,
                "source_file": error_file,
                "blocks_view": bool(record.get("required")),
            }
        )
    return warnings, gaps


def collect_unsupported_gaps(source_key: str, payload: dict[str, Any]) -> list[dict[str, Any]]:
    unsupported = payload.get("unsupported")
    if not isinstance(unsupported, list):
        return []
    gaps: list[dict[str, Any]] = []
    for entry in unsupported:
        if not isinstance(entry, dict):
            continue
        gaps.append(
            {
                "area": string_value(entry.get("area")),
                "field": string_value(entry.get("field")),
                "reason": string_value(entry.get("reason"), "Unsupported live API field."),
                "evidence": EVIDENCE_UNSUPPORTED,
                "source_file": STANDARD_FILES.get(source_key, source_key),
                "source_path": "$.unsupported[]",
                "recommended_owner": string_value(entry.get("recommended_owner"), "MegaMek/MekHQ live API"),
                "blocks_automation": bool(entry.get("blocks_automation", False)),
            }
        )
    return gaps


def validate_state_proof(state: dict[str, Any]) -> tuple[list[dict[str, Any]], list[dict[str, Any]], bool]:
    warnings: list[dict[str, Any]] = []
    gaps: list[dict[str, Any]] = []
    meta = state.get("bridge_metadata")
    blocked = False
    if not isinstance(meta, dict):
        gaps.append(
            {
                "area": "bridge_metadata",
                "field": "bridge_metadata",
                "reason": "State capture is missing bridge_metadata.",
                "evidence": EVIDENCE_MISSING,
                "source_file": STANDARD_FILES["state"],
                "source_path": "$.bridge_metadata",
                "blocks_view": True,
            }
        )
        return warnings, gaps, True

    api_mode = meta.get("api_mode")
    read_only = meta.get("read_only")
    if api_mode != API_MODE:
        blocked = True
        gaps.append(
            {
                "area": "bridge_metadata",
                "field": "api_mode",
                "reason": f"Expected {API_MODE}; got {string_value(api_mode)}.",
                "evidence": EVIDENCE_MISSING,
                "source_file": STANDARD_FILES["state"],
                "source_path": "$.bridge_metadata.api_mode",
                "blocks_view": True,
            }
        )
    if read_only is not True:
        blocked = True
        gaps.append(
            {
                "area": "bridge_metadata",
                "field": "read_only",
                "reason": "State capture does not prove bridge_metadata.read_only is true.",
                "evidence": EVIDENCE_MISSING,
                "source_file": STANDARD_FILES["state"],
                "source_path": "$.bridge_metadata.read_only",
                "blocks_view": True,
            }
        )
    return warnings, gaps, blocked


def validate_person_detail_proof(detail: dict[str, Any]) -> tuple[list[dict[str, Any]], list[dict[str, Any]], bool]:
    warnings: list[dict[str, Any]] = []
    gaps: list[dict[str, Any]] = []
    blocked = False
    schema_name = detail.get("schema_name")
    api_mode = detail.get("api_mode")
    read_only = detail.get("read_only")
    if schema_name != "mekhq-live-personnel-detail":
        blocked = True
        gaps.append(
            {
                "area": "personnel_detail",
                "field": "schema_name",
                "reason": f"Expected mekhq-live-personnel-detail; got {string_value(schema_name)}.",
                "evidence": EVIDENCE_MISSING,
                "source_file": STANDARD_FILES["person_detail"],
                "source_path": "$.schema_name",
                "blocks_view": True,
            }
        )
    if api_mode != API_MODE:
        blocked = True
        gaps.append(
            {
                "area": "personnel_detail",
                "field": "api_mode",
                "reason": f"Expected {API_MODE}; got {string_value(api_mode)}.",
                "evidence": EVIDENCE_MISSING,
                "source_file": STANDARD_FILES["person_detail"],
                "source_path": "$.api_mode",
                "blocks_view": True,
            }
        )
    if read_only is not True:
        blocked = True
        gaps.append(
            {
                "area": "personnel_detail",
                "field": "read_only",
                "reason": "Personnel detail capture does not prove read_only is true.",
                "evidence": EVIDENCE_MISSING,
                "source_file": STANDARD_FILES["person_detail"],
                "source_path": "$.read_only",
                "blocks_view": True,
            }
        )
    return warnings, gaps, blocked


def build_identity(loaded: dict[str, Any]) -> dict[str, Any]:
    identity: dict[str, Any] = {}
    state = loaded.get("state") if isinstance(loaded.get("state"), dict) else None
    summary = loaded.get("summary") if isinstance(loaded.get("summary"), dict) else None
    manifest = loaded.get("manifest") if isinstance(loaded.get("manifest"), dict) else None
    person_detail = loaded.get("person_detail") if isinstance(loaded.get("person_detail"), dict) else None

    if state:
        meta = state.get("bridge_metadata", {}) if isinstance(state.get("bridge_metadata"), dict) else {}
        campaign = state.get("campaign", {}) if isinstance(state.get("campaign"), dict) else {}
        location = campaign.get("location", {}) if isinstance(campaign.get("location"), dict) else {}
        identity.update(
            {
                "campaign_id": fact(string_value(campaign.get("id")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.campaign.id"),
                "campaign_name": fact(string_value(campaign.get("name")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.campaign.name"),
                "campaign_date": fact(string_value(campaign.get("date")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.campaign.date"),
                "location": fact(
                    string_value(
                        location.get("table_safe_location_label")
                        or location.get("current_system_name")
                        or location.get("current_location_display_name")
                    ),
                    EVIDENCE_LIVE,
                    STANDARD_FILES["state"],
                    "$.campaign.location",
                ),
                "api_mode": fact(string_value(meta.get("api_mode")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.bridge_metadata.api_mode"),
                "read_only": fact(meta.get("read_only") is True, EVIDENCE_LIVE, STANDARD_FILES["state"], "$.bridge_metadata.read_only"),
                "mekhq_version": fact(
                    string_value(meta.get("mekhq_version") or meta.get("producer_version")),
                    EVIDENCE_LIVE,
                    STANDARD_FILES["state"],
                    "$.bridge_metadata",
                ),
                "state_revision": fact(
                    string_value(meta.get("state_revision")),
                    EVIDENCE_LIVE,
                    STANDARD_FILES["state"],
                    "$.bridge_metadata.state_revision",
                ),
                "snapshot_id": fact(
                    string_value(meta.get("snapshot_id")),
                    EVIDENCE_LIVE,
                    STANDARD_FILES["state"],
                    "$.bridge_metadata.snapshot_id",
                ),
                "dirty_state": fact(
                    raw_value(meta.get("dirty_state"), "Unknown"),
                    EVIDENCE_LIVE,
                    STANDARD_FILES["state"],
                    "$.bridge_metadata.dirty_state",
                ),
            }
        )
    elif summary:
        identity.update(
            {
                "campaign_id": fact(string_value(summary.get("campaignId")), EVIDENCE_LIVE, STANDARD_FILES["summary"], "$.campaignId"),
                "campaign_name": fact(string_value(summary.get("campaignName")), EVIDENCE_LIVE, STANDARD_FILES["summary"], "$.campaignName"),
                "campaign_date": fact(string_value(summary.get("campaignDate")), EVIDENCE_LIVE, STANDARD_FILES["summary"], "$.campaignDate"),
                "location": fact(
                    string_value(summary.get("currentLocation") or summary.get("currentSystem")),
                    EVIDENCE_LIVE,
                    STANDARD_FILES["summary"],
                    "$.currentLocation",
                ),
                "api_mode": fact(string_value(summary.get("apiMode")), EVIDENCE_LIVE, STANDARD_FILES["summary"], "$.apiMode"),
                "read_only": fact(summary.get("readOnly") is True, EVIDENCE_LIVE, STANDARD_FILES["summary"], "$.readOnly"),
                "mekhq_version": fact(string_value(summary.get("mekhqVersion")), EVIDENCE_LIVE, STANDARD_FILES["summary"], "$.mekhqVersion"),
                "state_revision": fact(string_value(summary.get("stateRevision")), EVIDENCE_LIVE, STANDARD_FILES["summary"], "$.stateRevision"),
                "snapshot_id": fact(string_value(summary.get("snapshotId")), EVIDENCE_LIVE, STANDARD_FILES["summary"], "$.snapshotId"),
            }
        )
    elif person_detail:
        identity.update(
            {
                "campaign_id": fact(string_value(person_detail.get("campaign_id")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.campaign_id"),
                "campaign_name": fact(string_value(person_detail.get("campaign_name")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.campaign_name"),
                "campaign_date": fact(string_value(person_detail.get("campaign_date")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.campaign_date"),
                "api_mode": fact(string_value(person_detail.get("api_mode")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.api_mode"),
                "read_only": fact(person_detail.get("read_only") is True, EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.read_only"),
                "mekhq_version": fact(
                    string_value(person_detail.get("mekhq_version") or person_detail.get("producer_version")),
                    EVIDENCE_LIVE,
                    STANDARD_FILES["person_detail"],
                    "$.mekhq_version",
                ),
                "state_revision": fact(string_value(person_detail.get("state_revision")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.state_revision"),
                "snapshot_id": fact(string_value(person_detail.get("snapshot_id")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.snapshot_id"),
            }
        )

    if manifest:
        identity["capture_status"] = fact(
            string_value(manifest.get("status")),
            EVIDENCE_MANIFEST,
            STANDARD_FILES["manifest"],
            "$.status",
        )
        identity["captured_at"] = fact(
            string_value(manifest.get("captured_at")),
            EVIDENCE_MANIFEST,
            STANDARD_FILES["manifest"],
            "$.captured_at",
        )
    return identity


def source_info(paths: dict[str, Path]) -> dict[str, Any]:
    ordinary = {key: path for key, path in paths.items() if not key.startswith("error:")}
    capture_dirs = {path.parent.resolve() for path in ordinary.values()}
    capture_directory = None
    if len(capture_dirs) == 1:
        capture_directory = display_path(next(iter(capture_dirs)))
    files = []
    for key, path in sorted(paths.items(), key=lambda item: item[0]):
        files.append({"role": key, "path": display_path(path), "file": path.name})
    return {
        "capture_directory": capture_directory,
        "manifest_file": paths.get("manifest").name if paths.get("manifest") else None,
        "files": files,
    }


def summary_view(paths: dict[str, Path], loaded: dict[str, Any]) -> dict[str, Any]:
    warnings: list[dict[str, Any]] = []
    gaps: list[dict[str, Any]] = []
    blocked = False

    state = loaded.get("state")
    if not isinstance(state, dict):
        blocked = True
        gaps.append(
            {
                "area": "capture_file",
                "field": STANDARD_FILES["state"],
                "reason": "Summary view requires captured GET /campaign/state JSON.",
                "evidence": EVIDENCE_MISSING,
                "source_file": STANDARD_FILES["state"],
                "blocks_view": True,
            }
        )
        state = None
    else:
        state = as_object(state, STANDARD_FILES["state"])
        state_warnings, state_gaps, state_blocked = validate_state_proof(state)
        warnings.extend(state_warnings)
        gaps.extend(state_gaps)
        blocked = blocked or state_blocked
        gaps.extend(collect_unsupported_gaps("state", state))

    manifest = loaded.get("manifest") if isinstance(loaded.get("manifest"), dict) else None
    manifest_warnings, manifest_gaps = collect_manifest_warnings(manifest)
    warnings.extend(manifest_warnings)
    gaps.extend(manifest_gaps)
    error_warnings, error_gaps = collect_error_file_warnings(loaded)
    warnings.extend(error_warnings)
    gaps.extend(error_gaps)

    summary = loaded.get("summary") if isinstance(loaded.get("summary"), dict) else None
    if summary:
        gaps.extend(collect_unsupported_gaps("summary", summary))

    facts: dict[str, Any] = {}
    counts: dict[str, Any] = {}
    if state:
        campaign = state.get("campaign", {}) if isinstance(state.get("campaign"), dict) else {}
        meta = state.get("bridge_metadata", {}) if isinstance(state.get("bridge_metadata"), dict) else {}
        facts = {
            "campaign": {
                "id": fact(string_value(campaign.get("id")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.campaign.id"),
                "name": fact(string_value(campaign.get("name")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.campaign.name"),
                "date": fact(string_value(campaign.get("date")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.campaign.date"),
            },
            "read_only_proof": {
                "api_mode": fact(string_value(meta.get("api_mode")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.bridge_metadata.api_mode"),
                "read_only": fact(meta.get("read_only") is True, EVIDENCE_LIVE, STANDARD_FILES["state"], "$.bridge_metadata.read_only"),
            },
            "capture_manifest": {
                "status": fact(manifest_status(manifest) or "missing", EVIDENCE_MANIFEST if manifest else EVIDENCE_MISSING, STANDARD_FILES["manifest"], "$.status")
            },
        }
        counts = {
            "personnel": fact(count_list(state.get("personnel")), EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.personnel"),
            "units": fact(count_list(state.get("units")), EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.units"),
            "contracts": fact(count_list(state.get("contracts")), EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.contracts"),
            "scenarios": fact(count_list(state.get("scenarios")), EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.scenarios"),
            "unsupported": fact(count_list(state.get("unsupported")), EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.unsupported"),
            "endpoint_failures": fact(
                len([gap for gap in gaps if gap.get("evidence") == EVIDENCE_FAILED]),
                EVIDENCE_COMPUTED,
                STANDARD_FILES["manifest"],
                "$.results",
            ),
        }

    status = "ok"
    if blocked:
        status = "blocked"
    elif manifest_status(manifest) in {"partial", "failed"} or warnings:
        status = "partial"

    next_actions: list[str] = []
    if any(gap.get("evidence") in {EVIDENCE_MISSING, EVIDENCE_FAILED, EVIDENCE_UNSUPPORTED} for gap in gaps):
        next_actions.append("Review gaps before play; record producer/API gaps when the missing data blocks live context.")
    if manifest is None:
        next_actions.append("Rerun scripts/fetch-mekhq-live-api.ps1 or pass --manifest-file to verify endpoint capture status.")

    return {
        "schema_version": SCHEMA_VERSION,
        "view": "summary",
        "generated_at": utc_now(),
        "status": status,
        "source": source_info(paths),
        "identity": build_identity(loaded),
        "facts": facts,
        "counts": counts,
        "warnings": warnings,
        "gaps": gaps,
        "next_actions": next_actions,
    }


def first_items(value: Any, limit: int = 3) -> list[Any]:
    return value[:limit] if isinstance(value, list) else []


def current_scenarios_from_state(state: dict[str, Any]) -> list[dict[str, Any]]:
    scenarios = state.get("scenarios")
    if not isinstance(scenarios, list):
        return []
    current: list[dict[str, Any]] = []
    for scenario in scenarios:
        if not isinstance(scenario, dict):
            continue
        status = scenario.get("status", {}) if isinstance(scenario.get("status"), dict) else {}
        label = string_value(status.get("label") or status.get("raw_code"), "Unknown").lower()
        if label in {"current", "active", "pending"}:
            current.append(scenario)
    return current or [scenario for scenario in scenarios if isinstance(scenario, dict)][:3]


def common_capture_findings(loaded: dict[str, Any]) -> tuple[dict[str, Any] | None, list[dict[str, Any]], list[dict[str, Any]]]:
    manifest = loaded.get("manifest") if isinstance(loaded.get("manifest"), dict) else None
    warnings, gaps = collect_manifest_warnings(manifest)
    error_warnings, error_gaps = collect_error_file_warnings(loaded)
    warnings.extend(error_warnings)
    gaps.extend(error_gaps)
    return manifest, warnings, gaps


def state_context(loaded: dict[str, Any], view_name: str) -> tuple[dict[str, Any] | None, list[dict[str, Any]], list[dict[str, Any]], bool]:
    warnings: list[dict[str, Any]] = []
    gaps: list[dict[str, Any]] = []
    blocked = False
    state = loaded.get("state")
    if not isinstance(state, dict):
        blocked = True
        gaps.append(
            {
                "area": "capture_file",
                "field": STANDARD_FILES["state"],
                "reason": f"{view_name} view requires captured GET /campaign/state JSON.",
                "evidence": EVIDENCE_MISSING,
                "source_file": STANDARD_FILES["state"],
                "blocks_view": True,
            }
        )
        return None, warnings, gaps, blocked

    state = as_object(state, STANDARD_FILES["state"])
    state_warnings, state_gaps, state_blocked = validate_state_proof(state)
    warnings.extend(state_warnings)
    gaps.extend(state_gaps)
    gaps.extend(collect_unsupported_gaps("state", state))
    return state, warnings, gaps, state_blocked


def standard_output(
    view_name: str,
    paths: dict[str, Path],
    loaded: dict[str, Any],
    manifest: dict[str, Any] | None,
    facts: dict[str, Any],
    counts: dict[str, Any],
    warnings: list[dict[str, Any]],
    gaps: list[dict[str, Any]],
    blocked: bool = False,
    next_actions: list[str] | None = None,
) -> dict[str, Any]:
    status = "ok"
    if blocked:
        status = "blocked"
    elif manifest_status(manifest) in {"partial", "failed"} or warnings:
        status = "partial"

    return {
        "schema_version": SCHEMA_VERSION,
        "view": view_name,
        "generated_at": utc_now(),
        "status": status,
        "source": source_info(paths),
        "identity": build_identity(loaded),
        "facts": facts,
        "counts": counts,
        "warnings": warnings,
        "gaps": gaps,
        "next_actions": next_actions or [],
    }


def missing_risk_intel_gaps(scenario_id: Any, source_file: str, source_path: str) -> list[dict[str, Any]]:
    return [
        {
            "area": "scenario_intel",
            "field": "opfor_total_bv",
            "reason": f"Scenario {scenario_id} does not expose source-confirmed OpFor BV in this capture.",
            "evidence": EVIDENCE_MISSING,
            "source_file": source_file,
            "source_path": source_path,
            "blocks_view": False,
        },
        {
            "area": "scenario_intel",
            "field": "known_enemy_units",
            "reason": f"Scenario {scenario_id} does not expose source-confirmed enemy unit identities in this capture.",
            "evidence": EVIDENCE_MISSING,
            "source_file": source_file,
            "source_path": source_path,
            "blocks_view": False,
        },
    ]


def scenario_focus_row(scenario: dict[str, Any], source_file: str, source_path: str) -> dict[str, Any]:
    assigned_units = scenario.get("assigned_units") if isinstance(scenario.get("assigned_units"), list) else []
    player_force = scenario.get("player_force") if isinstance(scenario.get("player_force"), dict) else {}
    bot_forces = scenario.get("bot_forces") if isinstance(scenario.get("bot_forces"), list) else []
    known_enemy_units = [string_value(force.get("name")) for force in bot_forces if isinstance(force, dict)]
    opfor_total_bv: int | str = sum(
        raw_value(force.get("total_bv"), 0) for force in bot_forces if isinstance(force, dict) and isinstance(raw_value(force.get("total_bv"), 0), int)
    )
    if not bot_forces:
        opfor_total_bv = "Unknown"
        known_enemy_units = ["Unknown"]

    return {
        "id": fact(scenario.get("id", "Unknown"), EVIDENCE_LIVE, source_file, source_path),
        "display_name": fact(string_value(scenario.get("display_name")), EVIDENCE_LIVE, source_file, source_path),
        "date": fact(string_value(scenario.get("date")), EVIDENCE_LIVE, source_file, source_path),
        "status": fact(string_value(scenario.get("status")), EVIDENCE_LIVE, source_file, source_path),
        "scenario_type": fact(string_value(scenario.get("stratcon_scenario_type")), EVIDENCE_LIVE, source_file, source_path),
        "assigned_unit_count": fact(raw_value(scenario.get("assigned_unit_count"), count_list(scenario.get("all_unit_ids") or player_force.get("all_unit_ids"))), EVIDENCE_LIVE, source_file, source_path),
        "assigned_units": [
            {
                "unit_id": fact(string_value(unit.get("unit_id")), EVIDENCE_LIVE, source_file, source_path),
                "display_name": fact(string_value(unit.get("display_name")), EVIDENCE_LIVE, source_file, source_path),
                "formation_name": fact(string_value(unit.get("formation_name")), EVIDENCE_LIVE, source_file, source_path),
            }
            for unit in first_items(assigned_units)
            if isinstance(unit, dict)
        ],
        "risk_intel": {
            "opfor_total_bv": fact(opfor_total_bv, EVIDENCE_LIVE if bot_forces else EVIDENCE_MISSING, source_file, source_path),
            "known_enemy_units": fact(known_enemy_units, EVIDENCE_LIVE if bot_forces else EVIDENCE_MISSING, source_file, source_path),
        },
    }


def pending_deployments_view(paths: dict[str, Path], loaded: dict[str, Any]) -> dict[str, Any]:
    manifest, warnings, gaps = common_capture_findings(loaded)
    state, state_warnings, state_gaps, state_blocked = state_context(loaded, "pending-deployments")
    warnings.extend(state_warnings)
    gaps.extend(state_gaps)
    blocked = state_blocked and not isinstance(loaded.get("pending_deployments"), dict)

    pending = loaded.get("pending_deployments") if isinstance(loaded.get("pending_deployments"), dict) else None
    if pending is None:
        warnings.append(
            {
                "message": "Pending deployments capture is missing; falling back to current scenarios from state when available.",
                "evidence": EVIDENCE_MISSING,
                "source_file": STANDARD_FILES["pending_deployments"],
            }
        )
        gaps.append(
            {
                "area": "pending_deployments",
                "field": STANDARD_FILES["pending_deployments"],
                "reason": "Focused pending-deployments view prefers GET /campaign/pending-deployments.",
                "evidence": EVIDENCE_MISSING,
                "source_file": STANDARD_FILES["pending_deployments"],
                "blocks_view": state is None,
            }
        )
        pending_scenarios = current_scenarios_from_state(state) if state else []
        source_file = STANDARD_FILES["state"]
        source_path = "$.scenarios[]"
    else:
        gaps.extend(collect_unsupported_gaps("pending_deployments", pending))
        pending_scenarios = pending.get("pending_scenarios") if isinstance(pending.get("pending_scenarios"), list) else []
        source_file = STANDARD_FILES["pending_deployments"]
        source_path = "$.pending_scenarios[]"

    for scenario in pending_scenarios:
        if isinstance(scenario, dict) and not isinstance(scenario.get("bot_forces"), list):
            gaps.extend(missing_risk_intel_gaps(scenario.get("id", "Unknown"), source_file, source_path))
    risk_intel_gap_count = len([gap for gap in gaps if gap.get("area") == "scenario_intel"])
    if risk_intel_gap_count:
        warnings.append(
            {
                "message": "One or more pending scenarios lack source-confirmed risk-intel fields such as OpFor BV or known enemy units.",
                "evidence": EVIDENCE_MISSING,
                "source_file": source_file,
            }
        )

    facts = {
        "pending_scenarios": [
            scenario_focus_row(scenario, source_file, source_path)
            for scenario in first_items(pending_scenarios, 10)
            if isinstance(scenario, dict)
        ],
        "viewpoint_person": fact(pending.get("viewpoint_person", "Unknown") if pending else "Unknown", EVIDENCE_LIVE if pending else EVIDENCE_MISSING, STANDARD_FILES["pending_deployments"], "$.viewpoint_person"),
    }
    counts = {
        "pending_scenarios": fact(len(pending_scenarios), EVIDENCE_COMPUTED if pending_scenarios else EVIDENCE_MISSING if pending is None else EVIDENCE_COMPUTED, source_file, source_path),
        "risk_intel_gaps": fact(risk_intel_gap_count, EVIDENCE_COMPUTED, source_file, source_path),
    }
    return standard_output(
        "pending-deployments",
        paths,
        loaded,
        manifest,
        facts,
        counts,
        warnings,
        gaps,
        blocked,
        ["Record an API gap when missing scenario intel blocks pre-mission planning."] if counts["risk_intel_gaps"]["value"] else [],
    )


def commitment_rows_from_pending(pending: dict[str, Any], person_id: str, person_name: str) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    matches: list[dict[str, Any]] = []
    commitments: list[dict[str, Any]] = []
    scenarios = pending.get("pending_scenarios") if isinstance(pending.get("pending_scenarios"), list) else []
    wanted_id = person_id.lower()
    wanted_name = person_name.lower()
    for scenario in scenarios:
        if not isinstance(scenario, dict):
            continue
        units = scenario.get("assigned_units") if isinstance(scenario.get("assigned_units"), list) else []
        for unit in units:
            if not isinstance(unit, dict):
                continue
            crew = unit.get("crew") if isinstance(unit.get("crew"), list) else []
            for crew_member in crew:
                if not isinstance(crew_member, dict):
                    continue
                current_id = string_value(crew_member.get("person_id"))
                current_name = string_value(crew_member.get("display_name"))
                id_matches = bool(wanted_id and current_id.lower() == wanted_id)
                name_matches = bool(wanted_name and wanted_name in current_name.lower())
                if not (id_matches or name_matches):
                    continue
                matches.append(
                    {
                        "person_id": fact(current_id, EVIDENCE_LIVE, STANDARD_FILES["pending_deployments"], "$.pending_scenarios[].assigned_units[].crew[]"),
                        "display_name": fact(current_name, EVIDENCE_LIVE, STANDARD_FILES["pending_deployments"], "$.pending_scenarios[].assigned_units[].crew[]"),
                        "primary_role": fact(string_value(crew_member.get("primary_role")), EVIDENCE_LIVE, STANDARD_FILES["pending_deployments"], "$.pending_scenarios[].assigned_units[].crew[]"),
                        "status": fact(string_value(crew_member.get("status")), EVIDENCE_LIVE, STANDARD_FILES["pending_deployments"], "$.pending_scenarios[].assigned_units[].crew[]"),
                    }
                )
                commitments.append(
                    {
                        "scenario_id": fact(scenario.get("id", "Unknown"), EVIDENCE_LIVE, STANDARD_FILES["pending_deployments"], "$.pending_scenarios[]"),
                        "scenario_name": fact(string_value(scenario.get("display_name")), EVIDENCE_LIVE, STANDARD_FILES["pending_deployments"], "$.pending_scenarios[]"),
                        "scenario_date": fact(string_value(scenario.get("date")), EVIDENCE_LIVE, STANDARD_FILES["pending_deployments"], "$.pending_scenarios[]"),
                        "unit_id": fact(string_value(unit.get("unit_id")), EVIDENCE_LIVE, STANDARD_FILES["pending_deployments"], "$.pending_scenarios[].assigned_units[]"),
                        "unit_name": fact(string_value(unit.get("display_name")), EVIDENCE_LIVE, STANDARD_FILES["pending_deployments"], "$.pending_scenarios[].assigned_units[]"),
                    }
                )
    return matches, commitments


def person_commitment_view(paths: dict[str, Path], loaded: dict[str, Any], person_id: str, person_name: str) -> dict[str, Any]:
    manifest, warnings, gaps = common_capture_findings(loaded)
    pending = loaded.get("pending_deployments") if isinstance(loaded.get("pending_deployments"), dict) else None
    blocked = False
    if pending is None:
        blocked = True
        gaps.append(
            {
                "area": "pending_deployments",
                "field": STANDARD_FILES["pending_deployments"],
                "reason": "Person commitment view requires pending deployment capture.",
                "evidence": EVIDENCE_MISSING,
                "source_file": STANDARD_FILES["pending_deployments"],
                "blocks_view": True,
            }
        )
    if not person_id and not person_name and pending:
        viewpoint = pending.get("viewpoint_person") if isinstance(pending.get("viewpoint_person"), dict) else {}
        query = viewpoint.get("query") if isinstance(viewpoint.get("query"), dict) else {}
        person_id = "" if string_value(query.get("person_id")) == "Unknown" else string_value(query.get("person_id"))
        person_name = "" if string_value(query.get("person_name")) == "Unknown" else string_value(query.get("person_name"))
    if not person_id and not person_name:
        blocked = True
        gaps.append(
            {
                "area": "query",
                "field": "person_id_or_name",
                "reason": "Pass --person-id or --person-name, or capture a viewpoint-person pending deployment query.",
                "evidence": EVIDENCE_MISSING,
                "blocks_view": True,
            }
        )

    matches, commitments = commitment_rows_from_pending(pending, person_id, person_name) if pending else ([], [])
    if pending and not matches:
        warnings.append(
            {
                "message": "No matching person commitment found in pending deployments.",
                "evidence": EVIDENCE_MISSING,
                "source_file": STANDARD_FILES["pending_deployments"],
            }
        )
    facts = {
        "query": {
            "person_id": fact(person_id or "Unknown", EVIDENCE_COMPUTED, "arguments", "--person-id"),
            "person_name": fact(person_name or "Unknown", EVIDENCE_COMPUTED, "arguments", "--person-name"),
        },
        "matches": matches,
        "commitments": commitments,
    }
    counts = {
        "matches": fact(len(matches), EVIDENCE_COMPUTED, STANDARD_FILES["pending_deployments"], "$.pending_scenarios[].assigned_units[].crew[]"),
        "commitments": fact(len(commitments), EVIDENCE_COMPUTED, STANDARD_FILES["pending_deployments"], "$.pending_scenarios[]"),
    }
    return standard_output("person-commitment", paths, loaded, manifest, facts, counts, warnings, gaps, blocked)


def unit_commitment_map(pending: dict[str, Any] | None) -> dict[str, list[dict[str, Any]]]:
    mapping: dict[str, list[dict[str, Any]]] = {}
    if not pending:
        return mapping
    scenarios = pending.get("pending_scenarios") if isinstance(pending.get("pending_scenarios"), list) else []
    for scenario in scenarios:
        if not isinstance(scenario, dict):
            continue
        units = scenario.get("assigned_units") if isinstance(scenario.get("assigned_units"), list) else []
        for unit in units:
            if not isinstance(unit, dict):
                continue
            unit_id = string_value(unit.get("unit_id"))
            mapping.setdefault(unit_id, []).append(
                {
                    "scenario_id": fact(scenario.get("id", "Unknown"), EVIDENCE_LIVE, STANDARD_FILES["pending_deployments"], "$.pending_scenarios[]"),
                    "scenario_name": fact(string_value(scenario.get("display_name")), EVIDENCE_LIVE, STANDARD_FILES["pending_deployments"], "$.pending_scenarios[]"),
                    "scenario_date": fact(string_value(scenario.get("date")), EVIDENCE_LIVE, STANDARD_FILES["pending_deployments"], "$.pending_scenarios[]"),
                }
            )
    return mapping


def unit_readiness_view(paths: dict[str, Path], loaded: dict[str, Any]) -> dict[str, Any]:
    manifest, warnings, gaps = common_capture_findings(loaded)
    state, state_warnings, state_gaps, blocked = state_context(loaded, "unit-readiness")
    warnings.extend(state_warnings)
    gaps.extend(state_gaps)
    pending = loaded.get("pending_deployments") if isinstance(loaded.get("pending_deployments"), dict) else None
    commitments = unit_commitment_map(pending)
    units = state.get("units") if state and isinstance(state.get("units"), list) else []
    rows = []
    damaged = 0
    deployable = 0
    for unit in units:
        if not isinstance(unit, dict):
            continue
        availability = unit.get("availability") if isinstance(unit.get("availability"), dict) else {}
        damage = string_value(unit.get("damage_state"))
        if damage.lower() not in {"undamaged", "unknown", "none"}:
            damaged += 1
        if availability.get("deployable") is True:
            deployable += 1
        unit_id = string_value(unit.get("id"))
        entity = unit.get("entity") if isinstance(unit.get("entity"), dict) else {}
        rows.append(
            {
                "id": fact(unit_id, EVIDENCE_LIVE, STANDARD_FILES["state"], "$.units[]"),
                "display_name": fact(string_value(unit.get("display_name")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.units[]"),
                "unit_type": fact(string_value(entity.get("type")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.units[].entity.type"),
                "status": fact(string_value(unit.get("status")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.units[].status"),
                "damage_state": fact(damage, EVIDENCE_LIVE, STANDARD_FILES["state"], "$.units[].damage_state"),
                "deployable": fact(availability.get("deployable", "Unknown"), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.units[].availability.deployable"),
                "deployment_blocker": fact(string_value(availability.get("deployment_blocker")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.units[].availability.deployment_blocker"),
                "crew_count": fact(count_list(unit.get("crew")), EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.units[].crew"),
                "pending_commitments": commitments.get(unit_id, []),
            }
        )
    facts = {"units": rows}
    counts = {
        "units": fact(len(rows), EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.units"),
        "deployable": fact(deployable, EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.units[].availability.deployable"),
        "damaged": fact(damaged, EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.units[].damage_state"),
        "pending_commitments": fact(sum(len(value) for value in commitments.values()), EVIDENCE_COMPUTED, STANDARD_FILES["pending_deployments"], "$.pending_scenarios[]"),
    }
    return standard_output("unit-readiness", paths, loaded, manifest, facts, counts, warnings, gaps, blocked)


def repair_pressure_view(paths: dict[str, Path], loaded: dict[str, Any]) -> dict[str, Any]:
    manifest, warnings, gaps = common_capture_findings(loaded)
    state, state_warnings, state_gaps, blocked = state_context(loaded, "repair-pressure")
    warnings.extend(state_warnings)
    gaps.extend(state_gaps)
    repair = state.get("repairs_and_logistics") if state and isinstance(state.get("repairs_and_logistics"), dict) else {}
    queue = repair.get("repair_queue") if isinstance(repair.get("repair_queue"), list) else []
    shopping = repair.get("shopping_list") if isinstance(repair.get("shopping_list"), list) else []
    facts = {
        "repair_pressure": fact(raw_value(repair.get("repair_pressure"), "Unknown"), EVIDENCE_LIVE if repair else EVIDENCE_MISSING, STANDARD_FILES["state"], "$.repairs_and_logistics.repair_pressure"),
        "parts_pressure": fact(repair.get("parts_pressure", "Unknown"), EVIDENCE_LIVE if repair else EVIDENCE_MISSING, STANDARD_FILES["state"], "$.repairs_and_logistics.parts_pressure"),
        "automation_guard": fact(repair.get("automation_guard", "Unknown"), EVIDENCE_LIVE if repair else EVIDENCE_MISSING, STANDARD_FILES["state"], "$.repairs_and_logistics.automation_guard"),
        "repair_queue": [
            {
                "unit_id": fact(string_value(row.get("unit_id")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.repairs_and_logistics.repair_queue[]"),
                "display_name": fact(string_value(row.get("display_name")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.repairs_and_logistics.repair_queue[]"),
                "under_repair": fact(row.get("under_repair", "Unknown"), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.repairs_and_logistics.repair_queue[]"),
                "parts_needed_count": fact(raw_value(row.get("parts_needed_count"), "Unknown"), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.repairs_and_logistics.repair_queue[]"),
                "parts_needing_service_count": fact(raw_value(row.get("parts_needing_service_count"), "Unknown"), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.repairs_and_logistics.repair_queue[]"),
            }
            for row in first_items(queue, 10)
            if isinstance(row, dict)
        ],
    }
    counts = {
        "repair_queue": fact(len(queue), EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.repairs_and_logistics.repair_queue"),
        "shopping_list": fact(len(shopping), EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.repairs_and_logistics.shopping_list"),
    }
    return standard_output("repair-pressure", paths, loaded, manifest, facts, counts, warnings, gaps, blocked)


def reports_view(paths: dict[str, Path], loaded: dict[str, Any]) -> dict[str, Any]:
    manifest, warnings, gaps = common_capture_findings(loaded)
    state, state_warnings, state_gaps, blocked = state_context(loaded, "reports")
    warnings.extend(state_warnings)
    gaps.extend(state_gaps)
    reports = state.get("reports") if state and isinstance(state.get("reports"), dict) else {}
    buckets: dict[str, Any] = {}
    counts: dict[str, Any] = {}
    for name, value in reports.items():
        if not isinstance(value, list):
            continue
        buckets[name] = [
            {
                "date": fact(string_value(row.get("date")), EVIDENCE_LIVE, STANDARD_FILES["state"], f"$.reports.{name}[]"),
                "text": fact(string_value(row.get("text")), EVIDENCE_LIVE, STANDARD_FILES["state"], f"$.reports.{name}[]"),
            }
            for row in first_items(value, 10)
            if isinstance(row, dict)
        ]
        counts[name] = fact(len(value), EVIDENCE_COMPUTED, STANDARD_FILES["state"], f"$.reports.{name}")
    facts = {"report_buckets": buckets}
    counts["buckets"] = fact(len(buckets), EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.reports")
    return standard_output("reports", paths, loaded, manifest, facts, counts, warnings, gaps, blocked)


def command_readiness_view(paths: dict[str, Path], loaded: dict[str, Any]) -> dict[str, Any]:
    manifest, warnings, gaps = common_capture_findings(loaded)
    commands = loaded.get("commands") if isinstance(loaded.get("commands"), dict) else None
    blocked = False
    if commands is None:
        blocked = True
        gaps.append(
            {
                "area": "command_readiness",
                "field": STANDARD_FILES["commands"],
                "reason": "Command-readiness view requires captured GET /campaign/commands JSON.",
                "evidence": EVIDENCE_MISSING,
                "source_file": STANDARD_FILES["commands"],
                "blocks_view": True,
            }
        )
        rows = []
    else:
        gaps.extend(collect_unsupported_gaps("commands", commands))
        rows = commands.get("command_readiness") if isinstance(commands.get("command_readiness"), list) else []
    facts = {
        "selector_detail": fact("default-cheap-readiness", EVIDENCE_COMPUTED, STANDARD_FILES["commands"], "$.command_readiness"),
        "commands": [
            {
                "command": fact(string_value(row.get("command")), EVIDENCE_LIVE, STANDARD_FILES["commands"], "$.command_readiness[]"),
                "endpoint": fact(string_value(row.get("endpoint")), EVIDENCE_LIVE, STANDARD_FILES["commands"], "$.command_readiness[]"),
                "status": fact(string_value(row.get("status")), EVIDENCE_LIVE, STANDARD_FILES["commands"], "$.command_readiness[]"),
                "safe_selectors_available": fact(row.get("safe_selectors_available", "Unknown"), EVIDENCE_LIVE, STANDARD_FILES["commands"], "$.command_readiness[]"),
                "dry_run_supported": fact(row.get("dry_run_supported", "Unknown"), EVIDENCE_LIVE, STANDARD_FILES["commands"], "$.command_readiness[]"),
                "requires_command_envelope": fact(row.get("requires_command_envelope", "Unknown"), EVIDENCE_LIVE, STANDARD_FILES["commands"], "$.command_readiness[]"),
                "prompt_policy": fact(string_value(row.get("prompt_policy")), EVIDENCE_LIVE, STANDARD_FILES["commands"], "$.command_readiness[]"),
                "reason_code": fact(string_value(row.get("reason_code")), EVIDENCE_LIVE, STANDARD_FILES["commands"], "$.command_readiness[]"),
            }
            for row in rows
            if isinstance(row, dict)
        ],
    }
    counts = {
        "commands": fact(len(rows), EVIDENCE_COMPUTED, STANDARD_FILES["commands"], "$.command_readiness"),
        "available": fact(len([row for row in rows if isinstance(row, dict) and string_value(row.get("status")).lower() == "available"]), EVIDENCE_COMPUTED, STANDARD_FILES["commands"], "$.command_readiness[]"),
        "blocked": fact(len([row for row in rows if isinstance(row, dict) and string_value(row.get("status")).lower() == "blocked"]), EVIDENCE_COMPUTED, STANDARD_FILES["commands"], "$.command_readiness[]"),
        "full_selector_workflows": fact(len([row for row in rows if isinstance(row, dict) and string_value(row.get("reason_code")).lower() == "selector_generation_deferred"]), EVIDENCE_COMPUTED, STANDARD_FILES["commands"], "$.command_readiness[]"),
    }
    return standard_output(
        "command-readiness",
        paths,
        loaded,
        manifest,
        facts,
        counts,
        warnings,
        gaps,
        blocked,
        ["Use selectorDetail=full only when entering a specific command workflow; this view does not execute commands."],
    )


def api_gaps_view(paths: dict[str, Path], loaded: dict[str, Any]) -> dict[str, Any]:
    manifest, warnings, gaps = common_capture_findings(loaded)
    for key, value in loaded.items():
        if isinstance(value, dict) and not key.startswith("error:"):
            gaps.extend(collect_unsupported_gaps(key, value))
    facts = {
        "gap_candidates": [
            {
                "area": fact(string_value(gap.get("area")), gap.get("evidence", EVIDENCE_UNKNOWN), string_value(gap.get("source_file")), string_value(gap.get("source_path"))),
                "field": fact(string_value(gap.get("field")), gap.get("evidence", EVIDENCE_UNKNOWN), string_value(gap.get("source_file")), string_value(gap.get("source_path"))),
                "reason": fact(string_value(gap.get("reason")), gap.get("evidence", EVIDENCE_UNKNOWN), string_value(gap.get("source_file")), string_value(gap.get("source_path"))),
                "blocks_view": fact(gap.get("blocks_view", gap.get("blocks_automation", "Unknown")), gap.get("evidence", EVIDENCE_UNKNOWN), string_value(gap.get("source_file")), string_value(gap.get("source_path"))),
            }
            for gap in gaps
        ],
        "gap_report_skeleton": fact(
            "Use docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md entry schema; do not edit the report automatically from this view.",
            EVIDENCE_COMPUTED,
            "docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md",
            "Entry Schema",
        ),
    }
    counts = {
        "gap_candidates": fact(len(gaps), EVIDENCE_COMPUTED, "query-helper", "gaps"),
        "unsupported": fact(len([gap for gap in gaps if gap.get("evidence") == EVIDENCE_UNSUPPORTED]), EVIDENCE_COMPUTED, "query-helper", "gaps"),
        "missing": fact(len([gap for gap in gaps if gap.get("evidence") == EVIDENCE_MISSING]), EVIDENCE_COMPUTED, "query-helper", "gaps"),
        "failed": fact(len([gap for gap in gaps if gap.get("evidence") == EVIDENCE_FAILED]), EVIDENCE_COMPUTED, "query-helper", "gaps"),
    }
    status_blocked = any(gap.get("blocks_view") is True for gap in gaps)
    return standard_output("api-gaps", paths, loaded, manifest, facts, counts, warnings, gaps, status_blocked)


def play_context_view(paths: dict[str, Path], loaded: dict[str, Any]) -> dict[str, Any]:
    warnings: list[dict[str, Any]] = []
    gaps: list[dict[str, Any]] = []
    blocked = False

    state = loaded.get("state")
    if not isinstance(state, dict):
        blocked = True
        gaps.append(
            {
                "area": "capture_file",
                "field": STANDARD_FILES["state"],
                "reason": "Play-context view requires captured GET /campaign/state JSON.",
                "evidence": EVIDENCE_MISSING,
                "source_file": STANDARD_FILES["state"],
                "blocks_view": True,
            }
        )
        state = None
    else:
        state = as_object(state, STANDARD_FILES["state"])
        state_warnings, state_gaps, state_blocked = validate_state_proof(state)
        warnings.extend(state_warnings)
        gaps.extend(state_gaps)
        blocked = blocked or state_blocked
        gaps.extend(collect_unsupported_gaps("state", state))

    manifest = loaded.get("manifest") if isinstance(loaded.get("manifest"), dict) else None
    manifest_warnings, manifest_gaps = collect_manifest_warnings(manifest)
    warnings.extend(manifest_warnings)
    gaps.extend(manifest_gaps)
    error_warnings, error_gaps = collect_error_file_warnings(loaded)
    warnings.extend(error_warnings)
    gaps.extend(error_gaps)

    pending = loaded.get("pending_deployments") if isinstance(loaded.get("pending_deployments"), dict) else None
    if pending is None:
        warnings.append(
            {
                "message": "Pending deployments capture is missing; scenario commitment context may be incomplete.",
                "evidence": EVIDENCE_MISSING,
                "source_file": STANDARD_FILES["pending_deployments"],
            }
        )
        gaps.append(
            {
                "area": "pending_deployments",
                "field": STANDARD_FILES["pending_deployments"],
                "reason": "Play-context view can run without pending deployments, but current scenario/personnel commitment may be incomplete.",
                "evidence": EVIDENCE_MISSING,
                "source_file": STANDARD_FILES["pending_deployments"],
                "blocks_view": False,
            }
        )
    else:
        gaps.extend(collect_unsupported_gaps("pending_deployments", pending))

    commands = loaded.get("commands") if isinstance(loaded.get("commands"), dict) else None
    if commands is None:
        warnings.append(
            {
                "message": "Command readiness capture is missing; guarded command availability is unknown.",
                "evidence": EVIDENCE_MISSING,
                "source_file": STANDARD_FILES["commands"],
            }
        )
        gaps.append(
            {
                "area": "command_readiness",
                "field": STANDARD_FILES["commands"],
                "reason": "Command readiness was not captured.",
                "evidence": EVIDENCE_MISSING,
                "source_file": STANDARD_FILES["commands"],
                "blocks_view": False,
            }
        )

    facts: dict[str, Any] = {}
    counts: dict[str, Any] = {}
    if state:
        finances = state.get("finances", {}) if isinstance(state.get("finances"), dict) else {}
        personnel = state.get("personnel") if isinstance(state.get("personnel"), list) else []
        units = state.get("units") if isinstance(state.get("units"), list) else []
        contracts = state.get("contracts") if isinstance(state.get("contracts"), list) else []
        reports = state.get("reports", {}) if isinstance(state.get("reports"), dict) else {}
        repair = state.get("repairs_and_logistics", {}) if isinstance(state.get("repairs_and_logistics"), dict) else {}
        current_reports = reports.get("current") if isinstance(reports.get("current"), list) else []
        pending_scenarios = pending.get("pending_scenarios") if isinstance(pending, dict) and isinstance(pending.get("pending_scenarios"), list) else []
        scenarios_for_headline = pending_scenarios or current_scenarios_from_state(state)
        command_rows = commands.get("command_readiness") if isinstance(commands, dict) and isinstance(commands.get("command_readiness"), list) else []

        active_contracts = [
            contract
            for contract in contracts
            if isinstance(contract, dict)
            and string_value((contract.get("status") or {}).get("label") if isinstance(contract.get("status"), dict) else contract.get("status"), "").lower()
            in {"active", "current"}
        ]
        deployable_units = [
            unit
            for unit in units
            if isinstance(unit, dict)
            and isinstance(unit.get("availability"), dict)
            and unit["availability"].get("deployable") is True
        ]
        damaged_units = [
            unit
            for unit in units
            if isinstance(unit, dict)
            and string_value(unit.get("damage_state"), "Unknown").lower() not in {"undamaged", "unknown", "none"}
        ]
        fatigued_people = [
            person
            for person in personnel
            if isinstance(person, dict)
            and isinstance(person.get("fatigue"), dict)
            and raw_value(person["fatigue"].get("value"), 0) not in {0, "0", "Unknown", None}
        ]
        injured_people = [
            person
            for person in personnel
            if isinstance(person, dict)
            and isinstance(person.get("hits"), dict)
            and raw_value(person["hits"].get("value"), 0) not in {0, "0", "Unknown", None}
        ]
        available_commands = [row for row in command_rows if isinstance(row, dict) and string_value(row.get("status")).lower() == "available"]
        blocked_commands = [row for row in command_rows if isinstance(row, dict) and string_value(row.get("status")).lower() == "blocked"]
        command_count_evidence = EVIDENCE_COMPUTED if commands else EVIDENCE_MISSING
        available_command_count: int | str = len(available_commands) if commands else "Unknown"
        blocked_command_count: int | str = len(blocked_commands) if commands else "Unknown"

        facts = {
            "finance_headline": {
                "balance": fact(string_value(finances.get("balance")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.finances.balance"),
                "loan_balance": fact(string_value(finances.get("loan_balance")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.finances.loan_balance"),
                "has_active_loans": fact(raw_value(finances.get("has_active_loans"), "Unknown"), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.finances.has_active_loans"),
            },
            "contract_headline": {
                "active_count": fact(len(active_contracts), EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.contracts"),
                "active_contracts": [
                    {
                        "id": fact(contract.get("id", "Unknown"), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.contracts[]"),
                        "display_name": fact(string_value(contract.get("display_name")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.contracts[]"),
                        "employer": fact(string_value(contract.get("employer")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.contracts[]"),
                        "end_date": fact(string_value(contract.get("end_date")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.contracts[]"),
                    }
                    for contract in first_items(active_contracts)
                    if isinstance(contract, dict)
                ],
            },
            "deployment_headline": {
                "pending_scenario_count": fact(
                    raw_value(pending.get("pending_scenario_count"), len(pending_scenarios)) if isinstance(pending, dict) else "Unknown",
                    EVIDENCE_LIVE if pending else EVIDENCE_MISSING,
                    STANDARD_FILES["pending_deployments"],
                    "$.pending_scenario_count",
                ),
                "scenarios": [
                    {
                        "id": fact(scenario.get("id", "Unknown"), EVIDENCE_LIVE, STANDARD_FILES["pending_deployments"] if pending_scenarios else STANDARD_FILES["state"], "$.pending_scenarios[]" if pending_scenarios else "$.scenarios[]"),
                        "display_name": fact(string_value(scenario.get("display_name")), EVIDENCE_LIVE, STANDARD_FILES["pending_deployments"] if pending_scenarios else STANDARD_FILES["state"], "$.pending_scenarios[]" if pending_scenarios else "$.scenarios[]"),
                        "date": fact(string_value(scenario.get("date")), EVIDENCE_LIVE, STANDARD_FILES["pending_deployments"] if pending_scenarios else STANDARD_FILES["state"], "$.pending_scenarios[]" if pending_scenarios else "$.scenarios[]"),
                        "assigned_unit_count": fact(raw_value(scenario.get("assigned_unit_count"), count_list(scenario.get("all_unit_ids"))), EVIDENCE_LIVE, STANDARD_FILES["pending_deployments"] if pending_scenarios else STANDARD_FILES["state"], "$.pending_scenarios[]" if pending_scenarios else "$.scenarios[]"),
                    }
                    for scenario in first_items(scenarios_for_headline)
                    if isinstance(scenario, dict)
                ],
            },
            "unit_readiness_headline": {
                "unit_count": fact(len(units), EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.units"),
                "deployable_count": fact(len(deployable_units), EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.units[].availability.deployable"),
                "damaged_count": fact(len(damaged_units), EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.units[].damage_state"),
                "repair_pressure": fact(repair.get("repair_pressure", {}).get("value", "Unknown") if isinstance(repair.get("repair_pressure"), dict) else "Unknown", EVIDENCE_LIVE, STANDARD_FILES["state"], "$.repairs_and_logistics.repair_pressure"),
            },
            "personnel_headline": {
                "personnel_count": fact(len(personnel), EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.personnel"),
                "fatigued_count": fact(len(fatigued_people), EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.personnel[].fatigue"),
                "injured_count": fact(len(injured_people), EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.personnel[].hits"),
            },
            "reports_headline": {
                "current_reports": [
                    {
                        "date": fact(string_value(report.get("date")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.reports.current[]"),
                        "text": fact(string_value(report.get("text")), EVIDENCE_LIVE, STANDARD_FILES["state"], "$.reports.current[]"),
                    }
                    for report in first_items(current_reports)
                    if isinstance(report, dict)
                ],
                "report_count": fact(count_list(current_reports), EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.reports.current"),
            },
            "command_headline": {
                "available_count": fact(available_command_count, command_count_evidence, STANDARD_FILES["commands"], "$.command_readiness[]"),
                "blocked_count": fact(blocked_command_count, command_count_evidence, STANDARD_FILES["commands"], "$.command_readiness[]"),
                "available_commands": [
                    fact(string_value(row.get("command")), EVIDENCE_LIVE, STANDARD_FILES["commands"], "$.command_readiness[]")
                    for row in first_items(available_commands)
                    if isinstance(row, dict)
                ],
            },
        }
        counts = {
            "personnel": facts["personnel_headline"]["personnel_count"],
            "units": facts["unit_readiness_headline"]["unit_count"],
            "active_contracts": facts["contract_headline"]["active_count"],
            "pending_scenarios": facts["deployment_headline"]["pending_scenario_count"],
            "current_reports": facts["reports_headline"]["report_count"],
            "available_commands": facts["command_headline"]["available_count"],
            "unsupported": fact(count_list(state.get("unsupported")), EVIDENCE_COMPUTED, STANDARD_FILES["state"], "$.unsupported"),
        }

    status = "ok"
    if blocked:
        status = "blocked"
    elif manifest_status(manifest) in {"partial", "failed"} or warnings:
        status = "partial"

    next_actions: list[str] = []
    if any(gap.get("evidence") in {EVIDENCE_MISSING, EVIDENCE_FAILED, EVIDENCE_UNSUPPORTED} for gap in gaps):
        next_actions.append("Review gaps before play; record producer/API gaps when missing data blocks live scene startup.")
    if pending is None:
        next_actions.append("Rerun scripts/fetch-mekhq-live-api.ps1 with pending deployments enabled when scenario/personnel commitment matters.")
    if commands is None:
        next_actions.append("Rerun scripts/fetch-mekhq-live-api.ps1 with command readiness capture when guarded MekHQ actions matter.")

    return {
        "schema_version": SCHEMA_VERSION,
        "view": "play-context",
        "generated_at": utc_now(),
        "status": status,
        "source": source_info(paths),
        "identity": build_identity(loaded),
        "facts": facts,
        "counts": counts,
        "warnings": warnings,
        "gaps": gaps,
        "next_actions": next_actions,
    }


def compact_log_families(logs: dict[str, Any]) -> dict[str, Any]:
    families: dict[str, Any] = {}
    for family_name, family in logs.items():
        if family_name == "metadata" or not isinstance(family, dict):
            continue
        families[family_name] = {
            "status": fact(string_value(family.get("status")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], f"$.person.logs.{family_name}.status"),
            "entry_count": fact(raw_value(family.get("entry_count"), family.get("available_count", 0)), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], f"$.person.logs.{family_name}"),
            "returned_count": fact(raw_value(family.get("returned_count"), 0), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], f"$.person.logs.{family_name}.returned_count"),
        }
        if family.get("status") == "excluded":
            families[family_name]["required_query_flag"] = fact(
                string_value(family.get("required_query_flag")),
                EVIDENCE_LIVE,
                STANDARD_FILES["person_detail"],
                f"$.person.logs.{family_name}.required_query_flag",
            )
    return families


def person_detail_view(paths: dict[str, Path], loaded: dict[str, Any]) -> dict[str, Any]:
    warnings: list[dict[str, Any]] = []
    gaps: list[dict[str, Any]] = []
    blocked = False

    detail = loaded.get("person_detail")
    if not isinstance(detail, dict):
        blocked = True
        gaps.append(
            {
                "area": "capture_file",
                "field": STANDARD_FILES["person_detail"],
                "reason": "Person-detail view requires captured GET /campaign/personnel/detail JSON.",
                "evidence": EVIDENCE_MISSING,
                "source_file": STANDARD_FILES["person_detail"],
                "blocks_view": True,
            }
        )
        detail = None
    else:
        detail = as_object(detail, STANDARD_FILES["person_detail"])
        detail_warnings, detail_gaps, detail_blocked = validate_person_detail_proof(detail)
        warnings.extend(detail_warnings)
        gaps.extend(detail_gaps)
        blocked = blocked or detail_blocked
        gaps.extend(collect_unsupported_gaps("person_detail", detail))

    manifest = loaded.get("manifest") if isinstance(loaded.get("manifest"), dict) else None
    manifest_warnings, manifest_gaps = collect_manifest_warnings(manifest)
    warnings.extend(manifest_warnings)
    gaps.extend(manifest_gaps)
    error_warnings, error_gaps = collect_error_file_warnings(loaded)
    warnings.extend(error_warnings)
    gaps.extend(error_gaps)

    facts: dict[str, Any] = {}
    counts: dict[str, Any] = {}
    if detail:
        person = detail.get("person", {}) if isinstance(detail.get("person"), dict) else {}
        identity = person.get("identity", {}) if isinstance(person.get("identity"), dict) else {}
        status = person.get("status", {}) if isinstance(person.get("status"), dict) else {}
        assignment = person.get("assignment_context", {}) if isinstance(person.get("assignment_context"), dict) else {}
        logs = person.get("logs", {}) if isinstance(person.get("logs"), dict) else {}
        log_metadata = logs.get("metadata", {}) if isinstance(logs.get("metadata"), dict) else {}
        privacy = person.get("privacy", {}) if isinstance(person.get("privacy"), dict) else {}
        skills = person.get("skills") if isinstance(person.get("skills"), list) else []
        options = person.get("options_and_abilities", {}) if isinstance(person.get("options_and_abilities"), dict) else {}
        active_options = options.get("active_options") if isinstance(options.get("active_options"), list) else []
        awards = person.get("awards", {}) if isinstance(person.get("awards"), dict) else {}

        log_limit = raw_value(log_metadata.get("limit_per_family"))
        medical_included = raw_value(privacy.get("medical_included"), False) is True
        patient_included = raw_value(privacy.get("patient_included"), False) is True
        if (medical_included or patient_included) and (not isinstance(log_limit, int) or log_limit < 1 or log_limit > 50):
            blocked = True
            gaps.append(
                {
                    "area": "personnel_detail_privacy",
                    "field": "logLimit",
                    "reason": "Sensitive medical/patient log inclusion requires an explicit bounded logLimit from 1 to 50.",
                    "evidence": EVIDENCE_MISSING,
                    "source_file": STANDARD_FILES["person_detail"],
                    "source_path": "$.person.logs.metadata.limit_per_family",
                    "blocks_view": True,
                }
            )
        if medical_included or patient_included:
            warnings.append(
                {
                    "message": "Personnel detail capture includes sensitive medical or patient logs by explicit opt-in; compact output suppresses raw log entries.",
                    "evidence": EVIDENCE_LIVE,
                    "source_file": STANDARD_FILES["person_detail"],
                    "source_path": "$.person.privacy",
                }
            )

        facts = {
            "person": {
                "id": fact(string_value(person.get("id")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.id"),
                "display_name": fact(string_value(person.get("display_name")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.display_name"),
                "full_title": fact(string_value(person.get("full_title")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.full_title"),
                "callsign": fact(string_value(identity.get("callsign")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.identity.callsign"),
                "rank": fact(string_value(identity.get("rank")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.identity.rank"),
                "age": fact(raw_value(identity.get("age"), "Unknown"), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.identity.age"),
            },
            "status": {
                "primary_role": fact(string_value(status.get("primary_role")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.status.primary_role"),
                "secondary_role": fact(string_value(status.get("secondary_role")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.status.secondary_role"),
                "personnel_status": fact(string_value(status.get("personnel_status")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.status.personnel_status"),
                "prisoner_status": fact(string_value(status.get("prisoner_status")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.status.prisoner_status"),
                "fatigue": fact(status.get("fatigue", {}), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.status.fatigue"),
                "xp": fact(status.get("xp", {}), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.status.xp"),
            },
            "assignment": {
                "unit_id": fact(string_value(assignment.get("unit_id")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.assignment_context.unit_id"),
                "unit_name": fact(string_value(assignment.get("unit_name")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.assignment_context.unit_name"),
                "formation_name": fact(string_value(assignment.get("formation_name")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.assignment_context.formation_name"),
            },
            "skills": [
                {
                    "name": fact(string_value(skill.get("name")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.skills[]"),
                    "display_name": fact(string_value(skill.get("display_name")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.skills[]"),
                    "subtype": fact(string_value(skill.get("subtype")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.skills[]"),
                    "level": fact(raw_value(skill.get("level"), "Unknown"), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.skills[]"),
                    "final_value": fact(raw_value(skill.get("final_value"), "Unknown"), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.skills[]"),
                    "roleplay_only": fact(raw_value(skill.get("roleplay_only"), False) is True, EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.skills[]"),
                }
                for skill in skills
                if isinstance(skill, dict)
            ],
            "options": [
                {
                    "id": fact(string_value(option.get("id")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.options_and_abilities.active_options[]"),
                    "group": fact(string_value(option.get("group")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.options_and_abilities.active_options[]"),
                    "display_name": fact(string_value(option.get("display_name")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.options_and_abilities.active_options[]"),
                    "value": fact(string_value(option.get("value")), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.options_and_abilities.active_options[]"),
                }
                for option in active_options
                if isinstance(option, dict)
            ],
            "awards": {
                "award_count": fact(raw_value(awards.get("award_count"), 0), EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.awards.award_count"),
                "has_awards": fact(raw_value(awards.get("has_awards"), False) is True, EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.awards.has_awards"),
            },
            "log_families": compact_log_families(logs),
            "privacy": {
                "medical_included": fact(medical_included, EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.privacy.medical_included"),
                "patient_included": fact(patient_included, EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.privacy.patient_included"),
                "default_sensitive_log_families_excluded": fact(
                    privacy.get("default_sensitive_log_families_excluded", []),
                    EVIDENCE_LIVE,
                    STANDARD_FILES["person_detail"],
                    "$.person.privacy.default_sensitive_log_families_excluded",
                ),
                "limit_per_family": fact(log_limit if log_limit is not None else "Unknown", EVIDENCE_LIVE, STANDARD_FILES["person_detail"], "$.person.logs.metadata.limit_per_family"),
            },
        }
        counts = {
            "skills": fact(len(skills), EVIDENCE_COMPUTED, STANDARD_FILES["person_detail"], "$.person.skills"),
            "active_options": fact(len(active_options), EVIDENCE_COMPUTED, STANDARD_FILES["person_detail"], "$.person.options_and_abilities.active_options"),
            "unsupported": fact(count_list(detail.get("unsupported")), EVIDENCE_COMPUTED, STANDARD_FILES["person_detail"], "$.unsupported"),
            "log_families": fact(len(facts["log_families"]), EVIDENCE_COMPUTED, STANDARD_FILES["person_detail"], "$.person.logs"),
        }

    output_status = "ok"
    if blocked:
        output_status = "blocked"
    elif manifest_status(manifest) in {"partial", "failed"} or warnings:
        output_status = "partial"

    next_actions: list[str] = []
    if detail is None:
        next_actions.append("Rerun scripts/fetch-mekhq-live-api.ps1 with -PersonnelDetailPersonId <uuid>.")
    elif facts:
        privacy_facts = facts.get("privacy", {})
        if isinstance(privacy_facts, dict):
            if privacy_facts.get("medical_included", {}).get("value") is False and privacy_facts.get("patient_included", {}).get("value") is False:
                next_actions.append("Use medical/patient log opt-in only when the scene explicitly needs those sensitive families.")
    if any(gap.get("evidence") in {EVIDENCE_MISSING, EVIDENCE_FAILED, EVIDENCE_UNSUPPORTED} for gap in gaps):
        next_actions.append("Review gaps before play; record producer/API gaps when the missing data blocks live character context.")

    return {
        "schema_version": SCHEMA_VERSION,
        "view": "person-detail",
        "generated_at": utc_now(),
        "status": output_status,
        "source": source_info(paths),
        "identity": build_identity(loaded),
        "facts": facts,
        "counts": counts,
        "warnings": warnings,
        "gaps": gaps,
        "next_actions": next_actions,
    }


def build_view(args: argparse.Namespace) -> dict[str, Any]:
    paths = collect_input_paths(args)
    loaded, load_warnings, load_gaps = load_inputs(paths)
    if args.view == "summary":
        output = summary_view(paths, loaded)
    elif args.view == "pending-deployments":
        output = pending_deployments_view(paths, loaded)
    elif args.view == "person-commitment":
        output = person_commitment_view(paths, loaded, args.person_id or "", args.person_name or "")
    elif args.view == "unit-readiness":
        output = unit_readiness_view(paths, loaded)
    elif args.view == "repair-pressure":
        output = repair_pressure_view(paths, loaded)
    elif args.view == "reports":
        output = reports_view(paths, loaded)
    elif args.view == "command-readiness":
        output = command_readiness_view(paths, loaded)
    elif args.view == "api-gaps":
        output = api_gaps_view(paths, loaded)
    elif args.view == "play-context":
        output = play_context_view(paths, loaded)
    elif args.view == "person-detail":
        output = person_detail_view(paths, loaded)
    else:
        raise QueryError(f"Unsupported view: {args.view}")
    output["warnings"].extend(load_warnings)
    output["gaps"].extend(load_gaps)
    if any(gap.get("blocks_view") for gap in load_gaps):
        output["status"] = "blocked"
    return output


def render_text(output: dict[str, Any]) -> str:
    identity = output.get("identity", {})

    def identity_value(key: str) -> str:
        item = identity.get(key)
        if isinstance(item, dict):
            return string_value(item.get("value"))
        return "Unknown"

    lines = [
        f"MekHQ live API query view: {output.get('view')}",
        f"Status: {output.get('status')}",
        f"Campaign: {identity_value('campaign_name')} ({identity_value('campaign_id')})",
        f"Date: {identity_value('campaign_date')}",
        f"Location: {identity_value('location')}",
        f"Read-only: {identity_value('read_only')} / API mode: {identity_value('api_mode')}",
        f"State revision: {identity_value('state_revision')}",
        "",
        "Counts:",
    ]
    if output.get("view") == "person-detail":
        facts = output.get("facts", {})
        person = facts.get("person", {}) if isinstance(facts, dict) else {}
        status = facts.get("status", {}) if isinstance(facts, dict) else {}
        assignment = facts.get("assignment", {}) if isinstance(facts, dict) else {}
        privacy = facts.get("privacy", {}) if isinstance(facts, dict) else {}

        def fact_value(group: dict[str, Any], key: str) -> str:
            item = group.get(key) if isinstance(group, dict) else None
            if isinstance(item, dict):
                return string_value(item.get("value"))
            return "Unknown"

        lines.extend(
            [
                f"Person: {fact_value(person, 'display_name')} ({fact_value(person, 'id')})",
                f"Role/status: {fact_value(status, 'primary_role')} / {fact_value(status, 'personnel_status')}",
                f"Assignment: {fact_value(assignment, 'unit_name')} / {fact_value(assignment, 'formation_name')}",
                f"Sensitive logs included: medical={fact_value(privacy, 'medical_included')} patient={fact_value(privacy, 'patient_included')} limit={fact_value(privacy, 'limit_per_family')}",
                "",
            ]
        )
    elif output.get("view") == "play-context":
        facts = output.get("facts", {})
        finance = facts.get("finance_headline", {}) if isinstance(facts, dict) else {}
        deployment = facts.get("deployment_headline", {}) if isinstance(facts, dict) else {}
        readiness = facts.get("unit_readiness_headline", {}) if isinstance(facts, dict) else {}
        personnel = facts.get("personnel_headline", {}) if isinstance(facts, dict) else {}

        def fact_value(group: dict[str, Any], key: str) -> str:
            item = group.get(key) if isinstance(group, dict) else None
            if isinstance(item, dict):
                return string_value(item.get("value"))
            return "Unknown"

        lines.extend(
            [
                f"Funds: {fact_value(finance, 'balance')} / loans: {fact_value(finance, 'loan_balance')}",
                f"Pending scenarios: {fact_value(deployment, 'pending_scenario_count')}",
                f"Units: {fact_value(readiness, 'unit_count')} total, {fact_value(readiness, 'deployable_count')} deployable, {fact_value(readiness, 'damaged_count')} damaged",
                f"Personnel: {fact_value(personnel, 'personnel_count')} total, {fact_value(personnel, 'fatigued_count')} fatigued, {fact_value(personnel, 'injured_count')} injured",
                "",
            ]
        )
    counts = output.get("counts", {})
    if isinstance(counts, dict) and counts:
        for key, item in counts.items():
            value = item.get("value") if isinstance(item, dict) else item
            lines.append(f"- {key}: {value}")
    else:
        lines.append("- None available.")

    warnings = output.get("warnings", [])
    lines.extend(["", "Warnings:"])
    if warnings:
        for warning in warnings:
            lines.append(f"- {string_value(warning.get('message') if isinstance(warning, dict) else warning)}")
    else:
        lines.append("- None.")

    gaps = output.get("gaps", [])
    lines.extend(["", "Gaps:"])
    if gaps:
        for gap in gaps:
            if isinstance(gap, dict):
                lines.append(f"- {string_value(gap.get('field'))}: {string_value(gap.get('reason'))}")
    else:
        lines.append("- None.")
    return "\n".join(lines) + "\n"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Emit compact query views from captured MekHQ live API JSON.")
    parser.add_argument("--capture-dir", help="Directory created by scripts/fetch-mekhq-live-api.ps1.")
    parser.add_argument("--manifest-file", help="Explicit mekhq-live-api-capture-manifest.json path.")
    parser.add_argument("--status-file", help="Explicit mekhq-status.json path.")
    parser.add_argument("--summary-file", help="Explicit mekhq-summary.json path.")
    parser.add_argument("--state-file", help="Explicit mekhq-state.json path.")
    parser.add_argument("--commands-file", help="Explicit mekhq-commands.json path.")
    parser.add_argument("--pending-deployments-file", help="Explicit mekhq-pending-deployments.json path.")
    parser.add_argument("--person-detail-file", help="Explicit mekhq-personnel-detail.json path.")
    parser.add_argument("--person-id", help="MekHQ person id for person-commitment matching.")
    parser.add_argument("--person-name", help="MekHQ person display-name fragment for person-commitment matching.")
    parser.add_argument(
        "--view",
        default="summary",
        choices=[
            "summary",
            "play-context",
            "pending-deployments",
            "person-commitment",
            "unit-readiness",
            "repair-pressure",
            "reports",
            "command-readiness",
            "api-gaps",
            "person-detail",
        ],
        help="Compact view to emit.",
    )
    parser.add_argument("--format", default="json", choices=["json", "text"], help="Output format.")
    args = parser.parse_args(argv)

    try:
        output = build_view(args)
    except (OSError, QueryError) as exc:
        output = {
            "schema_version": SCHEMA_VERSION,
            "view": args.view,
            "generated_at": utc_now(),
            "status": "error",
            "source": {"capture_directory": None, "manifest_file": None, "files": []},
            "identity": {},
            "facts": {},
            "counts": {},
            "warnings": [],
            "gaps": [
                {
                    "area": "query_helper",
                    "field": "input",
                    "reason": str(exc),
                    "evidence": EVIDENCE_UNKNOWN,
                    "blocks_view": True,
                }
            ],
            "next_actions": ["Fix the input path or capture JSON and rerun the query helper."],
        }

    if args.format == "json":
        print(json.dumps(output, indent=2, sort_keys=True))
    else:
        print(render_text(output), end="")
    return 0 if output.get("status") in {"ok", "partial"} else 2


if __name__ == "__main__":
    raise SystemExit(main())
