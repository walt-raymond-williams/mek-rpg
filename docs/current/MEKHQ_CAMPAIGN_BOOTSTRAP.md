# MekHQ Campaign Bootstrap

Status: issue `#28` prototype; legacy/offline fallback for live MekHQ campaign loading.

Purpose: create a playable MEK-RPG `campaigns/<campaign-id>/` save folder from read-only MekHQ bridge JSON, while keeping MekHQ hard ledger facts separate from MEK-RPG narrative overlays.

If the user has MekHQ open and the local live API is available, run `scripts/fetch-mekhq-live-api.ps1` first, then use `scripts/sync-mekhq-live-campaign.py` on the captured `mekhq-state.json` when campaign-local generated context needs to be created or refreshed. Do not parse the loaded campaign's `.cpnx`, `.cpnx.gz`, or XML save as the normal campaign-load path. Missing live API fields should become API gap notes or change requests.

Live API and future checkpoint exports should follow the consumer contract in `docs/current/MEKHQ_READ_ONLY_CHECKPOINT_EXPORT_CONTRACT.md`.

## Live API Campaign Load

Script:

```powershell
./scripts/fetch-mekhq-live-api.ps1 -OutputDirectory .\mekhq-live-api-capture
python ./scripts/sync-mekhq-live-campaign.py --live-state .\mekhq-live-api-capture\mekhq-state.json --campaign-id my-linked-campaign
python ./scripts/sync-mekhq-live-campaign.py --live-state .\mekhq-live-api-capture\mekhq-state.json --campaign-id my-linked-campaign --refresh-existing
python ./scripts/sync-mekhq-live-campaign.py --live-state .\mekhq-live-api-capture\mekhq-state.json --campaign-id my-linked-campaign --viewpoint-person-id 12345
python ./scripts/sync-mekhq-live-campaign.py --live-state .\mekhq-live-api-capture\mekhq-state.json --campaign-id my-linked-campaign --embedded-pc-name "RPG Protagonist"
```

The fetch helper writes the live API capture files. The live adapter consumes captured sanitized `GET /campaign/state` JSON with `bridge_metadata`, normally `.\mekhq-live-api-capture\mekhq-state.json`. It verifies `bridge_metadata.api_mode: local-read-only-live-context` and `bridge_metadata.read_only: true` before using the payload. It rejects `.cpnx`, `.cpnx.gz`, and XML paths, copies `campaigns/_template/` for new campaign folders, refreshes generated context files only when `--refresh-existing` is supplied, and leaves `campaign-state/active-campaign.md` unchanged.

The generated `mekhq-bridge.md` records the live API trust envelope, snapshot/revision data, counts, cross-references, ownership boundary, and live-context-only status. The generated `mekhq-api-gaps.md` records missing or unsupported fields as producer-side change request inputs rather than parser fallback reasons.

Live API data is not a durable MEK-RPG checkpoint by itself. Promote live values to durable memory only through a save/import checkpoint, explicit user approval, or a future controlled promotion flow.

## Offline Summary Helper

Script:

```powershell
python ./scripts/summarize-mekhq-save.py "C:\path\to\campaign.cpnx" --format json > .\mekhq-summary.json
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign --viewpoint-person-id 12345
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign --embedded-pc-name "RPG Protagonist"
```

The helper consumes only the summary JSON. It does not open, edit, or write a MekHQ `.cpnx`, `.cpnx.gz`, or XML save. The summary may come from the current MEK-RPG fallback parser for offline/disposable use or from a MekHQ-owned read-only checkpoint export normalized to the same top-level sections.

For active loaded MekHQ campaigns, prefer `fetch-mekhq-live-api.ps1` plus `sync-mekhq-live-campaign.py` over `summarize-mekhq-save.py`. Use `summarize-mekhq-save.py` only when the live API is unavailable or the user explicitly chooses offline save inspection.

## Behavior

- Copies `campaigns/_template/` to `campaigns/<campaign-id>/`.
- Refuses existing campaign folders.
- Uses the same lowercase-hyphen campaign id rules as `new-campaign-save.ps1`.
- Does not edit `campaign-state/active-campaign.md`.
- Generates campaign stubs for overview, current state, PCs, NPCs, assets, missions, relationships, hooks, locations, factions, pending MekHQ actions, and session log.
- Adds `campaigns/<campaign-id>/mekhq-bridge.md` for bridge metadata, cross-references, warnings, unsupported fields, and bridge discrepancies.
- Preserves warning, unsupported, inferred, and method-backed provenance from the summary when available.

## Viewpoint Selection

Use exactly one selector:

- `--viewpoint-person-id`: select an imported MekHQ person by preserved MekHQ id.
- `--viewpoint-name`: select an imported MekHQ person by exact display name.
- `--embedded-pc-name`: create an unlinked A Time of War PC stub as the initial viewpoint.

If no selector is supplied, the helper chooses the first imported person with `commander=true`. If none is flagged commander, it chooses the first imported personnel record. If no personnel records exist, it creates a generic embedded PC stub.

The selected viewpoint is a play camera, not a final rules sheet. A Time of War attributes, skills, traits, Edge, XP, gear, private goals, personality, secrets, and relationship state remain sparse or TBD until established in MEK-RPG.

For richer linked `pcs.md` and `npcs.md` entries, use `docs/current/MEKHQ_PERSONNEL_SHEET_WORKFLOW.md`. Bootstrap output is intentionally sparse and should not be treated as a refresh/merge tool for existing RPG memory.

## Bridge File Convention

`mekhq-bridge.md` is the campaign-local technical bridge note. It should contain:

- source save path, save timestamp, import timestamp, helper version, and MekHQ save version
- a short ownership boundary reminder
- campaign snapshot fields from the last import
- counts and cross-reference rows for MekHQ personnel, units, and contracts
- helper warnings and unsupported or needs-inspection fields
- a pointer to `pending-mekhq-actions.md` for hard ledger changes proposed during RPG play

Keep table-facing campaign premise and scene state in the normal campaign files. Keep technical import metadata, unsupported fields, and ID cross-references in `mekhq-bridge.md`.

`pending-mekhq-actions.md` is the campaign-local manual application queue. Use it for proposed or committed hard ledger changes that must be applied in MekHQ and confirmed by a later import before becoming final facts.

`pcs.md` and `npcs.md` may contain expanded MekHQ-linked person entries. Keep MekHQ-owned roster fields in a clearly labeled block, keep A Time of War overlays and RPG memory in separate blocks, and preserve MekHQ person ids exactly. Do not infer full RPG stats from imported role/rank fields.

## Ownership Boundary

MekHQ owns hard logistics, campaign date, day advancement, travel, finances, rosters, unit condition, repairs, contracts, markets, scenarios, tactical outcomes, and ledger state.

MEK-RPG owns RPG scenes, A Time of War overlays, conversations, relationships, promises, secrets, hooks, session logs, safety/tone, and narrative uncertainty.

Generated Markdown should not invent exact MekHQ ledger values. Missing hard facts stay `Unknown`, `Unsupported`, or `Needs MekHQ inspection`. Proposed purchases, repairs, contract choices, personnel changes, tactical outcomes, or day advancement are recorded as pending until applied in MekHQ and re-imported.

## Verification

Issue `#28` verification used disposable sister-workspace MekHQ saves and generated throwaway campaign folders that were removed before commit. No raw MekHQ save payloads, protected A Time of War source text, PDFs, or extracted source text are committed by this workflow.

Issue `#97` exposed the need to demote this parser-first workflow for live play setup: the loaded campaign was available through the live API, and the API reported a more accurate current system than the file-summary bootstrap. Future live campaign-load work should use the API payload and record missing API fields instead of parsing the save.
