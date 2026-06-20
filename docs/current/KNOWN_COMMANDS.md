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
