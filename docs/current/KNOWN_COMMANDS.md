# Known Commands

Run commands from the repository root unless noted otherwise.

## Git And GitHub

```powershell
git status --short --branch
git remote -v
gh auth status
gh issue view 1
git add <paths>
git commit -m "Harden AI workflow for MEK RPG"
git push
```

## Inspect Project Files

```powershell
Get-ChildItem -Recurse -File docs,indexes,issues,gm,source,scripts | ForEach-Object { $_.FullName.Substring((Get-Location).Path.Length + 1) }
Get-ChildItem -Recurse -File docs/current,docs/templates,.github/ISSUE_TEMPLATE
```

## Campaign And Play Helpers

```powershell
./scripts/new-campaign-save.ps1 my-campaign
./scripts/validate-campaign-state.ps1
./scripts/validate-campaign-state.ps1 -CampaignId playtest-galatea-dropship
./scripts/validate-campaign-state.ps1 -StrictActive
./scripts/roll-dice.ps1 2d6
./scripts/roll-dice.ps1 2d6+2 "Technician check"
```

`new-campaign-save.ps1` copies `campaigns/_template/` to a new campaign folder and leaves `campaign-state/active-campaign.md` unchanged. `validate-campaign-state.ps1` checks the active campaign pointer, template files, and the active or explicitly supplied save folder; `-StrictActive` fails when no active campaign is selected. `roll-dice.ps1` reports dice, modifier, and total only; use the rules summaries to interpret outcomes.

## Verify Protected Source Is Not Staged

```powershell
git status --short
git check-ignore source/atow-pdf/example.pdf
git check-ignore source/atow-text/page-001.txt
```

Expected ignored paths include `source/atow-pdf/*`, `source/atow-text/*`, `*.pdf`, and `*.epub`.

## Source Extraction

Only run after an explicit source-processing request:

```powershell
bash ./scripts/extract-pdf-pages.sh "source/atow-pdf/A Time of War.pdf"
```

This command requires `pdftotext` and writes ignored page text into `source/atow-text/`.

## Useful Search

```powershell
rg "Needs source review|TBD|Unknown" docs indexes rules gm
rg "source/atow" .
```
