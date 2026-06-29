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


def build_identity(loaded: dict[str, Any]) -> dict[str, Any]:
    identity: dict[str, Any] = {}
    state = loaded.get("state") if isinstance(loaded.get("state"), dict) else None
    summary = loaded.get("summary") if isinstance(loaded.get("summary"), dict) else None
    manifest = loaded.get("manifest") if isinstance(loaded.get("manifest"), dict) else None

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


def build_view(args: argparse.Namespace) -> dict[str, Any]:
    paths = collect_input_paths(args)
    loaded, load_warnings, load_gaps = load_inputs(paths)
    if args.view != "summary":
        raise QueryError(f"Unsupported view for issue #141 helper core: {args.view}")
    output = summary_view(paths, loaded)
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
    parser.add_argument("--view", default="summary", choices=["summary"], help="Compact view to emit.")
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
