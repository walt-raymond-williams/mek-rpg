# MekHQ Live API Query View Contract

Status: issue `#140` contract for epic issue `#139`.

Purpose: define compact deterministic query views over MekHQ live API capture JSON so agents can use current MekHQ-owned facts during play without reading full raw captures.

## Boundary

Raw MekHQ live API captures are local evidence, not durable campaign memory. The standard raw capture directory pattern is `mekhq-live-api-capture*/`, and those directories must remain ignored and unstaged.

The query helper consumes captured JSON from `scripts/fetch-mekhq-live-api.ps1` and emits compact outputs for agents and downstream scripts. It may extract, count, filter, validate, label uncertainty, and point to source files. It must not choose tactics, decide scenes, infer hidden MekHQ state, apply MekHQ commands, edit campaign saves, parse active `.cpnx`/`.cpnx.gz`/XML files, or promote live context into durable MEK-RPG memory.

MekHQ remains authoritative for campaign date, day advancement, finances, rosters, unit condition, repairs, contracts, markets, scenarios, reports, command readiness, tactical outcomes, and other hard ledger state. MEK-RPG remains authoritative for scenes, A Time of War overlays, relationships, secrets, hooks, tone, session memory, and explicit pending intents.

## Implementation Decision

Use Python for the query helper core. The live API state payload is nested and already has Python traversal/extraction precedent in `scripts/sync-mekhq-live-campaign.py`. PowerShell remains the capture boundary through `scripts/fetch-mekhq-live-api.ps1`; Python should handle compact view assembly, JSON validation, and fixture-friendly tests.

The planned helper name for issue `#141` is `scripts/query-mekhq-live-api.py`.

Use one command with a `--view` argument rather than separate subcommands. Planned common arguments:

```powershell
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view summary --format json
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view play-context --format text
```

JSON is the primary output format. Text output is optional and should be a readable rendering of the same compact facts, not a separate authority model. JSON output should include source references and metadata. Text output may cite source filenames inline for traceability.

## Input Files

The helper should accept either an explicit capture directory or explicit file paths. Directory mode should discover these standard files:

- `mekhq-live-api-capture-manifest.json`
- `mekhq-status.json`
- `mekhq-summary.json`
- `mekhq-state.json`
- `mekhq-commands.json`
- `mekhq-commands-full.json`, optional
- `mekhq-pending-deployments.json`, unless deliberately skipped
- `mekhq-pending-deployments-viewpoint.json`, optional
- `*.error.json` files produced by failed captures

State-based views must require `mekhq-state.json` with `bridge_metadata.api_mode: local-read-only-live-context` and `bridge_metadata.read_only: true`. Command views must require `mekhq-commands.json`. Pending deployment views should use `mekhq-pending-deployments.json` first and the viewpoint file when present.

Reject input paths ending in `.cpnx`, `.cpnx.gz`, `.xml`, `.pdf`, `.epub`, or protected source paths. Do not follow embedded local save paths or source paths inside JSON payloads.

## Output Envelope

Every JSON output should use this top-level shape:

```json
{
  "schema_version": "mek-rpg-mekhq-live-api-query-view/v1",
  "view": "summary",
  "generated_at": "2026-06-29T00:00:00Z",
  "status": "ok",
  "source": {
    "capture_directory": "mekhq-live-api-capture",
    "manifest_file": "mekhq-live-api-capture-manifest.json",
    "files": []
  },
  "identity": {},
  "facts": {},
  "counts": {},
  "warnings": [],
  "gaps": [],
  "next_actions": []
}
```

Required fields:

- `schema_version`: exactly `mek-rpg-mekhq-live-api-query-view/v1` until a breaking change is made.
- `view`: selected view name.
- `generated_at`: helper runtime timestamp in UTC.
- `status`: one of `ok`, `partial`, `blocked`, or `error`.
- `source`: capture directory, manifest file when available, and the raw capture files used by the view.
- `identity`: campaign identity, date, state revision, snapshot id, MekHQ version, API mode, and read-only proof when available.
- `facts`: compact view-specific records.
- `counts`: view-specific counts that let agents scan before opening details.
- `warnings`: stale, partial, failed, unsupported, dirty-state, timeout, or validation warnings.
- `gaps`: missing or unsupported read records that may need `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`.
- `next_actions`: non-mutating suggestions such as "rerun fetch with -PendingDeploymentsPersonName" or "record API gap"; never scene or tactical decisions.

## Source References

Each fact group should include enough source metadata to audit where it came from without copying the raw payload:

```json
{
  "value": "3025-05-15",
  "evidence": "confirmed_live_api",
  "source_file": "mekhq-state.json",
  "source_path": "$.campaign.date"
}
```

Use file names and JSON paths where practical. Do not include long raw JSON excerpts in compact output.

## Evidence And Uncertainty

Use these normalized evidence labels:

- `confirmed_live_api`: value came directly from captured MekHQ live API JSON.
- `confirmed_capture_manifest`: value came from the capture manifest.
- `computed_from_live_api`: value is a deterministic count, filter, or classification from captured live API JSON.
- `unsupported_by_api`: captured JSON explicitly reports an unsupported field or automation blocker.
- `missing_from_capture`: required or expected field/file is absent from the capture.
- `capture_failed`: the manifest or `*.error.json` records a failed read.
- `partial_response`: a requested endpoint or section returned incomplete data.
- `stale_or_unverified`: value came from older campaign-local context or cannot be proven current by the capture.
- `unknown`: the helper cannot safely determine the value.

Unknown and missing behavior:

- `unknown`: use when the API may have validly withheld the value, the value is blank, or the helper cannot classify it.
- `missing`: use when the contract expected a field or file but it was absent.
- `unsupported`: use when the API explicitly reports a gap, unsupported area, or automation blocker.
- `stale`: use when the only available value is older campaign-local context or an old manifest.
- `partial`: use when a response or manifest indicates partial capture success.

The helper should keep these states distinct. It should not turn missing or unsupported data into `Unknown` without also preserving the reason in `warnings` or `gaps`.

## Status Rules

Return `ok` when the selected view has all required files and no required validation failure.

Return `partial` when the capture manifest status is `partial`, optional files are missing, non-blocking sections failed, or some facts are unavailable but the view can still report useful bounded context.

Return `blocked` when a required file, read-only proof, campaign identity, or selected view dependency is missing.

Return `error` for invalid JSON, rejected path types, malformed top-level payloads, or internal helper failures.

## Initial Views

### `summary`

Purpose: fast sanity check of capture freshness and loaded campaign identity.

Facts: campaign id/name/date, location label if available, dirty-state marker, MekHQ version, state revision, snapshot id, manifest status, captured endpoint statuses, high-level counts.

### `play-context`

Purpose: scene-start context for MekHQ-linked play.

Facts: campaign identity/date/location/funds, active contracts, pending scenarios/deployments, viewpoint commitment when available, urgent reports, command-readiness summary, open API gaps, and warnings. This view should be compact enough to read before play and should not rewrite campaign-local files.

### `pending-deployments`

Purpose: focused current scenario/deployment read.

Facts: pending scenarios, assigned units, committed personnel, viewpoint-person match, scenario dates/types/statuses, missing OpFor/intel fields, and fallback prompts.

### `person-commitment`

Purpose: answer "what is this person doing or committed to right now?"

Facts: matched MekHQ person id/name, status/availability, assigned unit, linked pending scenario/deployment, fatigue/hits where available, and unknown/multiple-match warnings.

### `unit-readiness`

Purpose: compact force readiness scan.

Facts: unit ids/names/types, condition/readiness labels, linked pilots/personnel, repair/damage flags, deployment commitments, and counts by readiness bucket.

### `repair-pressure`

Purpose: scan repair/logistics pressure without opening the full state payload.

Facts: repair queue counts, parts pressure, maintenance/cargo warnings, procurement/repair automation guard fields, and unsupported stable-work-id gaps.

### `command-readiness`

Purpose: show supported guarded MekHQ command options without executing them.

Facts: available/unavailable command ids, required guards, selector availability, deferred selector notes, prompt/save constraints, and blocking reasons.

### `reports`

Purpose: compact current report pressure.

Facts: report categories, current report lines, severity or date when present, generated daily/monthly warnings, and month-boundary prompt signals when exposed.

### `api-gaps`

Purpose: extract candidate producer/API gaps from missing, unsupported, partial, and failed capture data.

Facts: gap area/field/reason, attempted source file or endpoint, whether it blocks automation or play setup, and a suggested entry skeleton for `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`. The helper may suggest a gap entry but should not edit the gap report automatically in issue `#141`.

## Fixture And Privacy Strategy

Tests should use committed sanitized fixtures under `tests/fixtures/`, not personal live campaign captures. Reuse the existing sanitized live API fixture family when possible:

- `tests/fixtures/mekhq-live-campaign-summary.fixture.json`
- `tests/fixtures/mekhq-live-campaign-state.fixture.json`
- `tests/fixtures/mekhq-live-campaign-warning-heavy.fixture.json`
- `tests/fixtures/mekhq-live-campaign-commands.fixture.json`
- `tests/fixtures/mekhq-live-pending-deployments.fixture.json`

Issue `#141` may add a small fake capture-directory fixture if needed for manifest and multi-file tests. That fixture should contain minimal synthetic JSON, no real player/personnel names unless already sanitized, no local user paths, no save paths except explicit fake rejected-path cases, and no raw MekHQ save/XML payload.

Do not commit `mekhq-live-api-capture*/`, personal campaign captures, raw MekHQ saves, extracted XML, protected A Time of War source text, purchased PDFs, EPUBs, secrets, or long raw payload excerpts.

## Validation Expectations

Issue `#141` should add focused tests for:

- valid capture directory output
- explicit file input where useful
- missing manifest
- failed or partial manifest
- missing required file for a selected view
- missing or false `bridge_metadata.read_only`
- wrong `bridge_metadata.api_mode`
- raw save/XML path rejection
- unsupported entries surfaced as gaps
- deterministic JSON output fields

Routine close-out for the contract and helper work should include:

```powershell
git diff --check
git check-ignore -v mekhq-live-api-capture/mekhq-state.json
git check-ignore -v source/atow-pdf/example.pdf
git check-ignore -v source/atow-text/page-001.txt
```

Run focused helper tests after issue `#141` implements them. Full `./scripts/test-all.ps1 -Quick` is useful when script behavior changes beyond the narrow helper.

## Downstream Workflow

Issue `#141` should implement the helper core and the `summary` or equivalent basic metadata view first. Issues `#142` and `#143` should add the play and focused operational views. Issue `#144` should update GM workflow docs so agents normally read compact query output rather than full raw capture JSON during play. Issue `#145` should validate the workflow and clean up tracking.
