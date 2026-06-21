param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$validatorPath = Join-Path $repoRoot "scripts\validate-rules-indexes.ps1"
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("mek-rpg-rules-index-validator-" + [guid]::NewGuid().ToString("N"))

function Write-Test {
    param([string]$Message)
    Write-Host "TEST: $Message"
}

function Write-Ok {
    param([string]$Message)
    Write-Host "OK: $Message"
}

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Message
    )

    if (-not $Condition) {
        throw $Message
    }

    Write-Ok $Message
}

function Invoke-Validator {
    param(
        [string]$FixtureRoot,
        [int]$ExpectedExitCode,
        [string]$Label
    )

    $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $validatorPath -RepoRoot $FixtureRoot 2>&1
    $exitCode = $LASTEXITCODE

    if ($exitCode -ne $ExpectedExitCode) {
        Write-Host $output
        throw "$Label expected exit code $ExpectedExitCode but got $exitCode."
    }

    Write-Ok "$Label exits with expected code $ExpectedExitCode."
    return ($output -join "`n")
}

function Set-FixtureFile {
    param(
        [string]$RelativePath,
        [string]$Content
    )

    $path = Join-Path $tempRoot ($RelativePath -replace '/', [System.IO.Path]::DirectorySeparatorChar)
    $parent = Split-Path -Parent $path
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
    Set-Content -LiteralPath $path -Value $Content -Encoding UTF8
}

try {
    Write-Test "Creating disposable rules index fixture."
    New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null

    Set-FixtureFile -RelativePath "indexes/task-router.md" -Content @'
# Task Router

| User question or task | Read first | Also read |
| --- | --- | --- |
| resolving an uncertain action | `rules/core/action-checks.md` | `gm/scene-loop.md` |
'@

    Set-FixtureFile -RelativePath "indexes/rules-map.md" -Content @'
# Rules Map

Core rules live in `rules/core/`.
'@

    Set-FixtureFile -RelativePath "indexes/page-reference-index.md" -Content @'
# Page Reference Index

| Topic | Summary file | Source pages | Status |
| --- | --- | --- | --- |
| Action checks | `rules/core/action-checks.md` | A Time of War PDF page 40 / printed page 38 | Draft |
| Glossary | `indexes/term-glossary.md` | A Time of War PDF pages 30-32 / printed pages 28-30 | Source-reviewed glossary routing aid |
| Future skill catalog | `rules/skills/skill-catalog-map.md` | A Time of War PDF pages 143-161 / printed pages 141-159 | Partially covered; catalog/map only |
'@

    Set-FixtureFile -RelativePath "source/extraction-notes.md" -Content @'
# Extraction Notes

- Page-number offset notes:
  - Numbered interior pages use a consistent offset: `PDF page = printed page + 2`.
'@

    Set-FixtureFile -RelativePath "source/atow-chapter-section-map.md" -Content @'
# A Time Of War Chapter And Section Map

## Page Offset

- Numbered interior pages use a consistent offset: `PDF page = printed page + 2`.
'@

    Set-FixtureFile -RelativePath "indexes/manifest.yaml" -Content @'
metadata:
  status_legend:
    draft: Draft summary exists.
indexes:
  - id: universe.glossary-source-map
    title: Term Glossary
    file: indexes/term-glossary.md
    source_pages:
      pdf: [30, 31, 32]
      printed: [28, 29, 30]
    status: source-reviewed-routing-aid
rules:
  - id: core.action-checks
    title: Action Checks
    subsystem: core-resolution
    summary: rules/core/action-checks.md
    source_pages:
      pdf: [40]
      printed: [38]
    related:
      - gm.scene-loop
    status: draft
mapped_rules:
  - id: skills.catalog-map
    title: Skill Catalog Map
    subsystem: skills
    candidate: rules/skills/skill-catalog-map.md
    source_pages:
      pdf: [143, 144]
      printed: [141, 142]
    status: partial-draft
gm:
  - id: gm.scene-loop
    title: Scene Loop
    file: gm/scene-loop.md
    status: draft
'@

    Set-FixtureFile -RelativePath "rules/core/action-checks.md" -Content @'
# Action Checks

## Source References

- A Time of War, PDF page 40 / printed page 38.
'@
    Set-FixtureFile -RelativePath "gm/scene-loop.md" -Content "# Scene Loop"
    Set-FixtureFile -RelativePath "indexes/term-glossary.md" -Content @'
# Term Glossary

## Source References

- A Time of War, PDF pages 30-32 / printed pages 28-30.
'@

    Write-Test "Checking valid fixture passes with mapped-only candidate warnings."
    $validOutput = Invoke-Validator -FixtureRoot $tempRoot -ExpectedExitCode 0 -Label "Valid fixture"
    Assert-True -Condition ($validOutput -match "Mapped manifest 'skills.catalog-map' candidate path not present yet") -Message "Valid fixture warns for missing mapped-only candidate without failing."
    Assert-True -Condition ($validOutput -match "Extraction notes record PDF-to-printed page offset") -Message "Valid fixture checks extraction offset metadata."
    Assert-True -Condition ($validOutput -match "Chapter/section map records PDF-to-printed page offset") -Message "Valid fixture checks chapter-map offset metadata."

    Write-Test "Checking router missing file fails."
    Add-Content -LiteralPath (Join-Path $tempRoot "indexes\task-router.md") -Value '| broken | `rules/core/missing.md` |  |'
    $routerOutput = Invoke-Validator -FixtureRoot $tempRoot -ExpectedExitCode 1 -Label "Missing router link"
    Assert-True -Condition ($routerOutput -match "rules/core/missing.md") -Message "Missing router link is reported."

    Write-Test "Checking manifest missing summary fails."
    $taskRouterPath = Join-Path $tempRoot "indexes\task-router.md"
    (Get-Content -LiteralPath $taskRouterPath) | Where-Object { $_ -notmatch 'missing.md' } | Set-Content -LiteralPath $taskRouterPath -Encoding UTF8
    (Get-Content -LiteralPath (Join-Path $tempRoot "indexes\manifest.yaml")) -replace 'summary: rules/core/action-checks.md', 'summary: rules/core/missing-summary.md' |
        Set-Content -LiteralPath (Join-Path $tempRoot "indexes\manifest.yaml") -Encoding UTF8
    $manifestOutput = Invoke-Validator -FixtureRoot $tempRoot -ExpectedExitCode 1 -Label "Missing manifest summary"
    Assert-True -Condition ($manifestOutput -match "rules/core/missing-summary.md") -Message "Missing manifest summary is reported."

    Write-Test "Checking source offset metadata failure."
    (Get-Content -LiteralPath (Join-Path $tempRoot "indexes\manifest.yaml")) -replace 'summary: rules/core/missing-summary.md', 'summary: rules/core/action-checks.md' |
        Set-Content -LiteralPath (Join-Path $tempRoot "indexes\manifest.yaml") -Encoding UTF8
    Set-FixtureFile -RelativePath "source/extraction-notes.md" -Content "# Extraction Notes`n`nNo offset here."
    $offsetOutput = Invoke-Validator -FixtureRoot $tempRoot -ExpectedExitCode 1 -Label "Missing offset metadata"
    Assert-True -Condition ($offsetOutput -match "Extraction notes do not record expected PDF-to-printed page offset") -Message "Missing extraction offset is reported."

    Write-Test "Checking manifest/page-reference mismatch fails."
    Set-FixtureFile -RelativePath "source/extraction-notes.md" -Content @'
# Extraction Notes

- `PDF page = printed page + 2`
'@
    (Get-Content -LiteralPath (Join-Path $tempRoot "indexes\page-reference-index.md")) -replace 'A Time of War PDF page 40 / printed page 38', 'A Time of War PDF page 41 / printed page 39' |
        Set-Content -LiteralPath (Join-Path $tempRoot "indexes\page-reference-index.md") -Encoding UTF8
    $pageMismatchOutput = Invoke-Validator -FixtureRoot $tempRoot -ExpectedExitCode 1 -Label "Manifest/page-reference mismatch"
    Assert-True -Condition ($pageMismatchOutput -match "PDF pages are not covered by page-reference index") -Message "Manifest/page-reference PDF mismatch is reported."

    Write-Test "Checking missing summary Source References fails."
    (Get-Content -LiteralPath (Join-Path $tempRoot "indexes\page-reference-index.md")) -replace 'A Time of War PDF page 41 / printed page 39', 'A Time of War PDF page 40 / printed page 38' |
        Set-Content -LiteralPath (Join-Path $tempRoot "indexes\page-reference-index.md") -Encoding UTF8
    Set-FixtureFile -RelativePath "rules/core/action-checks.md" -Content "# Action Checks`n`nNo source references section."
    $summarySourceOutput = Invoke-Validator -FixtureRoot $tempRoot -ExpectedExitCode 1 -Label "Missing summary source references"
    Assert-True -Condition ($summarySourceOutput -match "summary lacks a Source References section") -Message "Missing summary Source References section is reported."
}
finally {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
        Write-Ok "Disposable rules index fixture removed."
    }
}

Write-Host ""
Write-Host "Rules index validator tests passed."
