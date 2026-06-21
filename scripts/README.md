# Scripts

- `extract-pdf-pages.sh`: extracts one text file per PDF page into `source/atow-text/`.
- `summarize-section-prompt.md`: reusable prompt for creating paraphrased rule summaries.
- `build-rule-manifest.md`: notes for future manifest generation.
- `new-campaign-save.ps1`: creates `campaigns/<campaign-id>/` from `campaigns/_template/` without overwriting an existing save.
- `validate-campaign-state.ps1`: checks the active campaign pointer, campaign template, and selected or explicit campaign save folder for deterministic structure problems.
- `roll-dice.ps1`: rolls simple expressions such as `2d6`, `2d6+2`, and `2d6-1` for live play.
- `summarize-mekhq-save.py`: reads a MekHQ `.cpnx`, `.cpnx.gz`, or plain campaign XML save and emits a read-only MEK-RPG bridge summary.
- `bootstrap-mekhq-campaign.py`: creates a MEK-RPG campaign save folder from `summarize-mekhq-save.py` JSON output.
- `test-mekhq-pending-workflow.ps1`: runs disposable regression checks for MekHQ pending-action bootstrap, validation, no-writeback boundaries, and protected-source guards.
- `test-bootstrap-mekhq-campaign.ps1`: runs fixture coverage for bootstrap campaign id validation, overwrite refusal, viewpoint selection, generated headings, ownership language, and cleanup.
- `test-all.ps1`: runs all deterministic local regression and unit-style checks that are safe for normal repository verification.

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
./scripts/test-bootstrap-mekhq-campaign.ps1
```

The bootstrap helper consumes only summary JSON, copies `campaigns/_template/`, refuses existing campaign folders, does not edit `campaign-state/active-campaign.md`, and writes a campaign-local `mekhq-bridge.md` with source metadata, warnings, cross-references, and pending MekHQ application notes. See `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md` for the generated file convention and ownership boundary.

The bootstrap fixture test uses `tests/fixtures/mekhq-summary-minimal.json` and disposable `campaigns/mekhq-bootstrap-test-*` folders. It checks valid bootstrap output, invalid campaign id rejection, existing-folder refusal, viewpoint selection by id and exact name, commander fallback, embedded PC generation, required headings, ownership/no-writeback language, active pointer preservation, and cleanup.

## MekHQ Pending Workflow Regression

```powershell
./scripts/test-mekhq-pending-workflow.ps1
./scripts/test-all.ps1
```

The regression script uses `tests/fixtures/mekhq-summary-minimal.json` to bootstrap disposable `campaigns/mekhq-pending-regression-*` folders, checks that `pending-mekhq-actions.md` remains the pending queue owner, verifies `mekhq-bridge.md` points pending work to that file, confirms the campaign validator catches a missing pending-actions file, checks no direct MekHQ save/XML writeback is implied by the workflow docs, verifies protected source ignore rules, and removes disposable output before exit.

`test-all.ps1` is the top-level deterministic runner. It currently wraps the MekHQ pending workflow regression and bootstrap fixture coverage, and is the extension point for future fixture and validator suites from issues `#42` through `#45`. It does not require real MekHQ saves, protected source files, network access, or user interaction.
