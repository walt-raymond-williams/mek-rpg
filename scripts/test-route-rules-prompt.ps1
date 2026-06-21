param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$helperPath = Join-Path $repoRoot "scripts\route-rules-prompt.ps1"

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

Write-Test "Checking text route output for a ranged-cover prompt."
$textOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $helperPath "Can I shoot from cover?" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host $textOutput
    throw "Text route helper failed with exit code $LASTEXITCODE."
}

$text = $textOutput -join "`n"
Assert-True -Condition ($text -match "Rules route helper") -Message "Text output has helper heading."
Assert-True -Condition ($text -match "Read the routed summaries") -Message "Text output includes non-authority warning."
Assert-True -Condition ($text -match "rules/personal-combat/ranged-attacks.md") -Message "Text output routes shooting prompt to ranged attacks."

Write-Test "Checking JSON route output for a tactical prompt."
$jsonOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $helperPath "BattleMech heat and tactical movement" -Format json 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host $jsonOutput
    throw "JSON route helper failed with exit code $LASTEXITCODE."
}

$report = ($jsonOutput -join "`n") | ConvertFrom-Json
Assert-True -Condition ($report.candidates.Count -gt 0) -Message "JSON output has route candidates."
$allPaths = @($report.candidates | ForEach-Object { $_.files } | ForEach-Object { $_.path })
Assert-True -Condition ($allPaths -contains "gm/switch-to-classic-battletech.md") -Message "JSON tactical prompt routes to tactical handoff."

Write-Host ""
Write-Host "Rules route helper tests passed."
