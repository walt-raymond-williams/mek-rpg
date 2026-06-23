# Read-Only Dashboard Data Contract

Status: issue `#57` architecture contract.

Purpose: define the read-only data adapter shape for a future MEK-RPG dashboard before any frontend, local server, or UI framework exists.

## Decision

Use a file/CLI JSON contract first. A later local HTTP server may wrap the same contract, but the first implementation should be deterministic, testable, and able to run without opening a web server.

The adapter must read committed MEK-RPG campaign files and optional already-sanitized MekHQ summary artifacts. It must not read raw MekHQ saves, protected A Time of War source paths, purchased PDFs, extracted source text, secrets, or ignored raw payloads.

## Non-Goals

- No UI implementation.
- No local web server requirement.
- No file writes, campaign edits, git actions, issue actions, or hidden mutation.
- No campaign selection writeback.
- No MekHQ `.cpnx`, `.cpnx.gz`, XML, or raw save reads in the dashboard layer.
- No tactical resolution, live movement controls, Sunnytown-derived gameplay surface, or automation controls.
- No raw rulebook text, source tables, copied stat blocks, or protected source display.

## Adapter Invocation

Recommended first command shape:

```powershell
./scripts/export-dashboard-data.ps1 [-CampaignId <id>] [-RepoRoot <path>] [-IncludePrivate] [-IncludeExcerpts] [-MekHqSummaryJson <path>] [-MekHqLiveApiJson <path>]
```

The script name is a proposal, not an implementation in this issue.

Parameter intent:

- `CampaignId`: optional explicit campaign id. If absent, resolve `campaign-state/active-campaign.md`.
- `RepoRoot`: optional explicit repository root for tests and fixtures.
- `IncludePrivate`: allow safety/tone excerpts and GM-secret excerpts. Default should redact or link only.
- `IncludeExcerpts`: include short Markdown excerpts from campaign files. Default should emit headings, metadata, and source links only.
- `MekHqSummaryJson`: optional path to an already-sanitized output from `scripts/summarize-mekhq-save.py --format json`. The adapter may validate and summarize it, but must never open a raw MekHQ save.
- `MekHqLiveApiJson`: optional path to already-sanitized JSON captured from the MekHQ local-control live API. The adapter treats it as live context by default, separate from saved checkpoint/import facts, and preserves read-only proof, `api_mode`, `state_revision` or `snapshot_id`, dirty-state warnings, and unsupported entries.

## Input Resolution

### Required Inputs

- `campaign-state/active-campaign.md` unless `CampaignId` is passed.
- `campaigns/<campaign-id>/` selected save folder.
- `campaigns/README.md`.
- `docs/current/READ_ONLY_DASHBOARD_EVALUATION.md`.
- `docs/current/GM_CONTEXT_PACKET_DESIGN.md`.
- `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`.
- `scripts/validate-campaign-state.ps1`.

### Campaign File Inputs

The adapter should inventory these standard files:

- `overview.md`
- `current-state.md`
- `pcs.md`
- `npcs.md`
- `factions.md`
- `locations.md`
- `assets.md`
- `relationships.md`
- `missions.md`
- `hooks.md`
- `pending-mekhq-actions.md`
- `session-log.md`
- `previous-sessions.md`
- `rules-gaps.md`
- `playtest-notes.md`
- `safety-and-tone.md`

Optional campaign-local files:

- `mekhq-bridge.md`
- future generated reports or archive metadata, if documented by later issues

### Optional Tool Outputs

The adapter may include output from existing read-only validators and source-report helpers:

- `scripts/validate-campaign-state.ps1`
- `scripts/validate-mekhq-pending-actions.ps1 -ReportUnresolved`
- `scripts/build-gm-context-packet.ps1`

It should label these as tool output, not as independent authority.

### Optional MekHQ Summary Input

The adapter may accept a sanitized JSON file already produced by `scripts/summarize-mekhq-save.py --format json`.

Rules:

- Accept only explicit JSON path input.
- Treat it as optional and advisory unless it matches campaign-local bridge metadata.
- Preserve helper warnings and unsupported fields.
- Do not read the original save path from `bridge_metadata.input_path`.
- Do not open adjacent `.cpnx`, `.cpnx.gz`, XML, log, or cache files.
- Do not treat pending or proposed MEK-RPG facts as confirmed MekHQ ledger facts.

### Optional Live MekHQ API Input

The adapter may accept explicit sanitized JSON captured from the live MekHQ local-control API through `-MekHqLiveApiJson`.

Rules:

- Accept only an explicit JSON path.
- Treat `api_mode: local-read-only-live-context` as live context, not a durable import checkpoint.
- Preserve `state_revision`, `snapshot_id`, dirty-state warning/unsupported entries, method-backed trust envelopes, and read-only proof.
- For expanded state payloads, expose compact read-only summaries such as personnel/unit/contract/scenario/report counts, finance warnings, market guard fields, logistics guard fields, and report metadata so dashboards do not have to inspect raw nested payloads for common context.
- Do not promote live values into campaign files without saved/import confirmation, explicit user approval, or a future controlled promotion flow.
- Do not call the live API, require a MekHQ GUI, or follow raw save paths.
- Do not create write controls or pending MekHQ actions from market, repair, personnel, contract, or tactical fields.

## Output Envelope

The adapter should emit UTF-8 JSON with this top-level shape:

```json
{
  "schema_version": "dashboard-data/v1",
  "generated_at": "2026-06-21T00:00:00Z",
  "repo": {
    "root": "C:/Users/waltr/Documents/mek-rpg",
    "is_dirty": null
  },
  "selection": {
    "campaign_id": "isekai-atlas-field",
    "source": "active-pointer",
    "active_pointer_path": "campaign-state/active-campaign.md",
    "campaign_path": "campaigns/isekai-atlas-field"
  },
  "authority": {},
  "health": {},
  "panels": {},
  "warnings": [],
  "errors": []
}
```

`repo.is_dirty` should be `null` unless a later implementation deliberately reads git status. The dashboard must not run git actions.

## Authority Section

The `authority` object should make ownership visible:

```json
{
  "structured_campaign_files": "authoritative for MEK-RPG RPG memory",
  "mekhq_bridge": "authoritative for imported hard ledger summaries when present",
  "pending_mekhq_actions": "manual intents until saved MekHQ import confirms them",
  "rules": "route to committed summaries and indexes; no raw source display",
  "dashboard": "read-only inspection output; not a source of truth"
}
```

## Health Section

The `health` object should summarize validation state:

```json
{
  "campaign_state": {
    "status": "ok",
    "errors": [],
    "warnings": [],
    "validator": "scripts/validate-campaign-state.ps1"
  },
  "protected_sources": {
    "source_atow_pdf": "excluded",
    "source_atow_text": "excluded",
    "raw_mekhq_saves": "excluded"
  },
  "missing_files": [],
  "stale_or_conflicting_facts": []
}
```

Status values:

- `ok`: no adapter errors.
- `warn`: output is usable but warnings need attention.
- `error`: dashboard should show the problem and avoid presenting campaign state as ready.
- `unsupported`: requested feature is intentionally outside the contract.

## Panels Object

The `panels` object should contain dashboard-ready read-only summaries. Suggested panel keys:

- `active_campaign`
- `current_scene`
- `context_packet`
- `recent_session`
- `durable_memory`
- `npcs`
- `relationships`
- `hooks`
- `missions`
- `assets`
- `mekhq_bridge`
- `pending_mekhq_actions`
- `rules_routes`
- `tactical_handoff`
- `privacy_and_boundaries`

Each panel should use a common shape:

```json
{
  "title": "Current Scene",
  "status": "ok",
  "sources": [
    {"path": "campaigns/isekai-atlas-field/current-state.md", "role": "resume point"}
  ],
  "items": [],
  "warnings": []
}
```

## Source Record Shape

Use source records to make every displayed fact traceable:

```json
{
  "path": "campaigns/isekai-atlas-field/assets.md",
  "role": "asset state",
  "exists": true,
  "required": true,
  "heading": "Assets",
  "evidence": "Confirmed by campaign file",
  "privacy": "private"
}
```

Allowed `privacy` values:

- `normal`
- `private`
- `gm-secret`
- `child-safety`
- `protected-excluded`
- `raw-save-excluded`

## Item Shape

Panel items should avoid pretending parsed Markdown is more structured than it is:

```json
{
  "id": "asset-atlas-field",
  "label": "Atlas Field",
  "kind": "asset",
  "status": "unknown",
  "source_path": "campaigns/isekai-atlas-field/assets.md",
  "heading_path": ["Assets", "Asset Name"],
  "evidence": "Confirmed by campaign file",
  "summary": "Short excerpt or heading-only summary.",
  "links": [
    {"label": "Asset schema", "path": "docs/current/ASSET_SHEET_SCHEMA.md"}
  ],
  "warnings": []
}
```

Adapter v1 may emit heading-only items. If `IncludeExcerpts` is false, `summary` should be omitted or a short heading-derived phrase.

## Panel Requirements

### Active Campaign

Include:

- active pointer status
- selected campaign id
- selected campaign path
- campaign overview heading
- canon/playtest status if discoverable from headings or short excerpt
- warnings for missing, invalid, legacy, or ambiguous active pointers

### Current Scene

Include:

- `current-state.md` source link
- current session log source link
- resume heading or first meaningful heading
- warnings if `current-state.md` or `session-log.md` is missing

Do not infer a scene summary unless `IncludeExcerpts` is enabled.

### Context Packet

Include:

- source list equivalent to `scripts/build-gm-context-packet.ps1`
- authority notes
- validator warnings
- MekHQ-linked status

The adapter may call the helper or reimplement its source inventory, but it must not reinterpret rules or summarize scenes.

### Recent Session And Durable Memory

Include source records and headings for:

- `session-log.md`
- `previous-sessions.md`
- `relationships.md`
- `hooks.md`
- `npcs.md`
- `factions.md`
- `playtest-notes.md`

If excerpts are enabled, keep them short and local to the requested campaign files.

### Assets, Missions, And Tactical Handoff

Include:

- `assets.md`, `missions.md`, and `hooks.md` source records
- links to `docs/current/ASSET_SHEET_SCHEMA.md`
- links to `gm/tactical-encounter-handoff-checklist.md`
- warning when tactical outcome fields look pending or unknown

Do not calculate salvage, repair costs, unit condition, fuel, cargo, or tactical results.

### MekHQ Bridge

Include only when `mekhq-bridge.md`, sanitized summary JSON, or future sanitized live API JSON is present.

Include:

- last import metadata if present
- bridge warnings
- unsupported fields
- IDs and counts from bridge notes or sanitized summary JSON
- source links to bridge docs

Never:

- open raw save paths
- inspect files adjacent to a summary JSON
- treat pending MEK-RPG actions as imported facts
- treat live API values as durable imported checkpoint facts by default

### Pending MekHQ Actions

Include:

- pending action file source record
- unresolved count from `validate-mekhq-pending-actions.ps1 -ReportUnresolved` when available
- lifecycle statuses as read-only labels
- warning that pending actions are manual intents

Never mark an action resolved or create write controls.

## Warning And Error Cases

Adapter should emit warnings for:

- no active campaign selected
- explicit campaign id overriding active pointer
- missing standard campaign file
- missing top-level heading
- `campaign-state/` legacy path selected instead of `campaigns/<campaign-id>/`
- active pointer names more than one campaign
- selected campaign folder missing
- `mekhq-bridge.md` present but `pending-mekhq-actions.md` missing
- pending MekHQ validator reports malformed entries
- sanitized MekHQ summary JSON does not match selected campaign bridge metadata
- requested excerpts include private safety/tone data without `IncludePrivate`
- source, PDF, extracted text, or raw MekHQ save paths are requested

Adapter should emit errors for:

- invalid campaign id syntax
- path traversal or selected path outside `campaigns/`
- requested raw source or raw save read
- required repository files missing
- JSON summary input is invalid or unreadable

Errors should prevent dashboard panels from presenting state as ready.

## Protected Path Rules

The adapter must treat these paths as excluded:

- `source/atow-pdf/`
- `source/atow-text/`
- raw MekHQ `.cpnx`, `.cpnx.gz`, XML saves, or extracted raw save payloads
- secrets or credentials if later config files exist

The adapter may display that these categories are excluded. It must not list individual protected source contents, read them, hash them, excerpt them, or count pages.

## Read-Only Proof Points

The implementation issue should include fixture tests that prove:

- active campaign pointer is not modified
- campaign files are not modified
- pending MekHQ action files are not modified
- no output files are written unless an explicit `-OutputPath` is later added and scoped outside campaign/source files
- protected source paths are ignored/excluded
- raw MekHQ saves are not opened by the dashboard adapter
- missing/invalid campaign ids fail safely
- summary JSON input is read without following `input_path` back to a raw save

## Fixture Strategy

Use disposable fixture repositories or temporary campaign folders, following existing test patterns.

Recommended fixtures:

- valid campaign with all standard files
- missing standard file
- invalid active pointer
- campaign with `mekhq-bridge.md` and valid pending actions
- malformed pending actions
- sanitized MekHQ summary JSON from `tests/fixtures/mekhq-summary-minimal.json`
- summary JSON with a raw save `input_path` that must not be followed
- sanitized live API summary/state/warning-heavy JSON from `tests/fixtures/mekhq-live-campaign-*.fixture.json` for live context adapter behavior
- sanitized command-readiness JSON from `tests/fixtures/mekhq-live-campaign-commands.fixture.json`; this is read-only readiness context and must not enable dashboard write controls by itself

## Implementation Follow-Up

Create implementation work only after this contract is accepted.

Recommended next issue after `#57`:

- Prototype `scripts/export-dashboard-data.ps1` as a read-only JSON adapter with tests.

Optional later issues:

- Add a local-only dashboard UI over the JSON contract.
- Add fixture-backed rendering checks for dashboard panels.
- Add session archive metadata to the adapter after issue `#58`.

## Open Decisions For Implementation

- Whether excerpts are opt-in by flag or omitted from v1 entirely.
- Whether `IncludePrivate` can show safety/tone excerpts or should only reveal file presence.
- Whether git dirty status is useful enough to include as read-only metadata.
- Whether a future local HTTP wrapper should be a separate script or a thin mode of the same adapter.
