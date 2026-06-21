# MekHQ Campaign Bootstrap

Status: issue `#28` prototype.

Purpose: create a playable MEK-RPG `campaigns/<campaign-id>/` save folder from the JSON output of `scripts/summarize-mekhq-save.py`, while keeping MekHQ hard ledger facts separate from MEK-RPG narrative overlays.

## Helper

Script:

```powershell
python ./scripts/summarize-mekhq-save.py "C:\path\to\campaign.cpnx" --format json > .\mekhq-summary.json
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign --viewpoint-person-id 12345
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign --embedded-pc-name "RPG Protagonist"
```

The helper consumes only the summary JSON. It does not open, edit, or write a MekHQ `.cpnx`, `.cpnx.gz`, or XML save.

## Behavior

- Copies `campaigns/_template/` to `campaigns/<campaign-id>/`.
- Refuses existing campaign folders.
- Uses the same lowercase-hyphen campaign id rules as `new-campaign-save.ps1`.
- Does not edit `campaign-state/active-campaign.md`.
- Generates campaign stubs for overview, current state, PCs, NPCs, assets, missions, relationships, hooks, locations, factions, pending MekHQ actions, and session log.
- Adds `campaigns/<campaign-id>/mekhq-bridge.md` for bridge metadata, cross-references, warnings, unsupported fields, and bridge discrepancies.

## Viewpoint Selection

Use exactly one selector:

- `--viewpoint-person-id`: select an imported MekHQ person by preserved MekHQ id.
- `--viewpoint-name`: select an imported MekHQ person by exact display name.
- `--embedded-pc-name`: create an unlinked A Time of War PC stub as the initial viewpoint.

If no selector is supplied, the helper chooses the first imported person with `commander=true`. If none is flagged commander, it chooses the first imported personnel record. If no personnel records exist, it creates a generic embedded PC stub.

The selected viewpoint is a play camera, not a final rules sheet. A Time of War attributes, skills, traits, Edge, XP, gear, private goals, personality, secrets, and relationship state remain sparse or TBD until established in MEK-RPG.

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

## Ownership Boundary

MekHQ owns hard logistics, campaign date, day advancement, travel, finances, rosters, unit condition, repairs, contracts, markets, scenarios, tactical outcomes, and ledger state.

MEK-RPG owns RPG scenes, A Time of War overlays, conversations, relationships, promises, secrets, hooks, session logs, safety/tone, and narrative uncertainty.

Generated Markdown should not invent exact MekHQ ledger values. Missing hard facts stay `Unknown`, `Unsupported`, or `Needs MekHQ inspection`. Proposed purchases, repairs, contract choices, personnel changes, tactical outcomes, or day advancement are recorded as pending until applied in MekHQ and re-imported.

## Verification

Issue `#28` verification used disposable sister-workspace MekHQ saves and generated throwaway campaign folders that were removed before commit. No raw MekHQ save payloads, protected A Time of War source text, PDFs, or extracted source text are committed by this workflow.
