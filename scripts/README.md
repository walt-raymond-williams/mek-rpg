# Scripts

- `extract-pdf-pages.sh`: extracts one text file per PDF page into `source/atow-text/`.
- `summarize-section-prompt.md`: reusable prompt for creating paraphrased rule summaries.
- `build-rule-manifest.md`: notes for future manifest generation.
- `new-campaign-save.ps1`: creates `campaigns/<campaign-id>/` from `campaigns/_template/` without overwriting an existing save.
- `validate-campaign-state.ps1`: checks the active campaign pointer, campaign template, and selected or explicit campaign save folder for deterministic structure problems.
- `roll-dice.ps1`: rolls simple expressions such as `2d6`, `2d6+2`, and `2d6-1` for live play.
- `summarize-mekhq-save.py`: reads a MekHQ `.cpnx`, `.cpnx.gz`, or plain campaign XML save and emits a read-only MEK-RPG bridge summary.
- `bootstrap-mekhq-campaign.py`: creates a MEK-RPG campaign save folder from `summarize-mekhq-save.py` JSON output.

## Campaign Saves

```powershell
./scripts/new-campaign-save.ps1 my-campaign
./scripts/validate-campaign-state.ps1
./scripts/validate-campaign-state.ps1 -CampaignId playtest-galatea-dropship
./scripts/validate-campaign-state.ps1 -StrictActive
```

Campaign ids must use lowercase letters, numbers, and hyphens. The script refuses existing folders, rejects path traversal by construction, and does not edit `campaign-state/active-campaign.md`.

The validator reports `OK`, `WARN`, and `FAIL` lines. It checks `campaign-state/active-campaign.md`, required files in `campaigns/_template/`, and either the active campaign folder or the folder supplied with `-CampaignId`. By default, `Active campaign: None selected` is valid and does not fail; if no `-CampaignId` is supplied, the script warns that no save folder was checked. Use `-StrictActive` before play when an unselected active campaign should fail the check.

When required campaign save files or persistent campaign-state structures change, update `validate-campaign-state.ps1` or add a narrower companion validator as part of the same task. Keep this validator focused on shared save-folder structure and active-campaign safety; deeper checks for character sheets, vehicles, contracts, or other specialized records can live in separate scripts when that keeps the boundary clearer.

## Dice Rolls

```powershell
./scripts/roll-dice.ps1 2d6
./scripts/roll-dice.ps1 2d6+2 "Technician check"
```

The roller reports the expression, individual dice, modifier, and total. It does not apply A Time of War outcomes or rule logic.

## MekHQ Save Summaries

```powershell
python ./scripts/summarize-mekhq-save.py "C:\path\to\campaign.cpnx" --format json
python ./scripts/summarize-mekhq-save.py "C:\path\to\campaign.cpnx.gz" --format markdown
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign --viewpoint-person-id 12345
```

The helper detects gzip compression by magic bytes, parses the save XML with structured XML APIs, and writes JSON or Markdown to stdout. It does not write to the MekHQ save. JSON is the primary output for later bridge automation; Markdown is a quick human checkpoint. Field mappings and unsupported areas are documented in `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md`.

## MekHQ Campaign Bootstrap

```powershell
python ./scripts/summarize-mekhq-save.py "C:\path\to\campaign.cpnx" --format json > .\mekhq-summary.json
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign --viewpoint-person-id 12345
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign --embedded-pc-name "RPG Protagonist"
```

The bootstrap helper consumes only summary JSON, copies `campaigns/_template/`, refuses existing campaign folders, does not edit `campaign-state/active-campaign.md`, and writes a campaign-local `mekhq-bridge.md` with source metadata, warnings, cross-references, and pending MekHQ application notes. See `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md` for the generated file convention and ownership boundary.
