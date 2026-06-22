param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$reporterPath = Join-Path $repoRoot "scripts\report-rules-coverage.ps1"

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

Write-Test "Checking text coverage report."
$textOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $reporterPath 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host $textOutput
    throw "Text coverage report failed with exit code $LASTEXITCODE."
}

$text = $textOutput -join "`n"
Assert-True -Condition ($text -match "Rules coverage report") -Message "Text report has expected heading."
Assert-True -Condition ($text -match "\[core-resolution\]") -Message "Text report includes core-resolution subsystem."
Assert-True -Condition ($text -match "ADVANCEMENT_REWARDS_SOURCE_REVIEW_VALIDATION.md") -Message "Text report includes advancement rewards validation coverage."
Assert-True -Condition ($text -match "SPECIAL_CASE_RULES_SOURCE_REVIEW_VALIDATION.md") -Message "Text report includes special-case validation coverage."
Assert-True -Condition ($text -match "source lookup only") -Message "Text report distinguishes source-lookup-only coverage."
Assert-True -Condition ($text -match "drafted/routed") -Message "Text report distinguishes drafted/routed coverage."

Write-Test "Checking JSON coverage report."
$jsonOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $reporterPath -Format json 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host $jsonOutput
    throw "JSON coverage report failed with exit code $LASTEXITCODE."
}

$report = ($jsonOutput -join "`n") | ConvertFrom-Json
Assert-True -Condition ($report.totals.covered_entries -gt 0) -Message "JSON report has coverage entries."
Assert-True -Condition (@($report.subsystems | Where-Object { $_.subsystem -eq "core-resolution" }).Count -eq 1) -Message "JSON report includes core-resolution subsystem."
Assert-True -Condition (@($report.subsystems | Where-Object { $_.subsystem -eq "gamemastering" }).Count -eq 1) -Message "JSON report includes gamemastering subsystem."
$campaignSubsystem = @($report.subsystems | Where-Object { $_.subsystem -eq "campaign" })[0]
Assert-True -Condition (@($campaignSubsystem.validation_reports) -contains "docs/current/ADVANCEMENT_REWARDS_SOURCE_REVIEW_VALIDATION.md") -Message "JSON report includes advancement rewards validation report."
$specialSubsystem = @($report.subsystems | Where-Object { $_.subsystem -eq "special-case-rules" })[0]
Assert-True -Condition (@($specialSubsystem.validation_reports) -contains "docs/current/SPECIAL_CASE_RULES_SOURCE_REVIEW_VALIDATION.md") -Message "JSON report includes special-case validation report."

Write-Host ""
Write-Host "Rules coverage reporter tests passed."
