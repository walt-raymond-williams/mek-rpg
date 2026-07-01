param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$templatePath = Join-Path $repoRoot "campaigns\_template"
$validatorPath = Join-Path $repoRoot "scripts\validate-rich-character-records.ps1"
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) "mek-rpg-rich-character-validator-fixture"
$tempCampaignsRoot = Join-Path $tempRoot "campaigns"
$tempTemplatePath = Join-Path $tempCampaignsRoot "_template"

function Write-Step {
    param([string]$Message)
    Write-Host "TEST: $Message"
}

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Message
    )

    if (-not $Condition) {
        throw $Message
    }

    Write-Host "OK: $Message"
}

function Invoke-Validator {
    param(
        [string[]]$Arguments,
        [string]$Message
    )

    $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $validatorPath @Arguments 2>&1
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        $output | ForEach-Object { Write-Host $_ }
        throw "$Message failed with exit code $exitCode."
    }

    Write-Host "OK: $Message"
    return ($output | Out-String)
}

function Invoke-ValidatorExpectFailure {
    param(
        [string[]]$Arguments,
        [string]$ExpectedPattern,
        [string]$Message
    )

    $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $validatorPath @Arguments 2>&1
    $exitCode = $LASTEXITCODE
    Assert-True ($exitCode -ne 0) "$Message exits non-zero"
    $text = ($output | Out-String)
    Assert-True ($text -match $ExpectedPattern) "$Message reports expected failure"
    return $text
}

function Remove-TempRepo {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
    }
}

function Initialize-TempRepo {
    Remove-TempRepo
    New-Item -ItemType Directory -Path $tempCampaignsRoot | Out-Null
    Copy-Item -LiteralPath $templatePath -Destination $tempTemplatePath -Recurse
}

Push-Location $repoRoot
try {
    Write-Step "Creating disposable rich character validator fixture."
    Initialize-TempRepo

    Write-Step "Checking live template passes."
    $liveOutput = Invoke-Validator @("-Template") "Live template validation"
    Assert-True ($liveOutput -like "*Summary: 0 error(s), 0 warning(s).*") "Live template has no rich-record validator errors or warnings."

    Write-Step "Checking copied template passes through -RepoRoot."
    $fixtureOutput = Invoke-Validator @("-RepoRoot", $tempRoot, "-Template") "Fixture template validation"
    Assert-True ($fixtureOutput -like "*Summary: 0 error(s), 0 warning(s).*") "Fixture template has no rich-record validator errors or warnings."

    Write-Step "Checking missing rich PC section fails."
    $pcsPath = Join-Path $tempTemplatePath "pcs.md"
    $pcsText = Get-Content -Raw -LiteralPath $pcsPath
    $pcsText = $pcsText -replace '#### Speech, Behavior, And Portrayal\s*\r?\n', ''
    Set-Content -LiteralPath $pcsPath -Value $pcsText -Encoding UTF8
    Invoke-ValidatorExpectFailure @("-RepoRoot", $tempRoot, "-Template") "missing required rich character section.*Speech, Behavior, And Portrayal" "Missing rich PC section" | Out-Null

    Write-Step "Checking unsupported evidence label fails."
    Initialize-TempRepo
    $npcsPath = Join-Path $tempTemplatePath "npcs.md"
    Add-Content -LiteralPath $npcsPath -Value "`n- Evidence label: Vibes only`n" -Encoding UTF8
    Invoke-ValidatorExpectFailure @("-RepoRoot", $tempRoot, "-Template") "unsupported evidence label 'Vibes only'" "Unsupported evidence label" | Out-Null

    Write-Step "Checking protected source marker fails."
    Initialize-TempRepo
    Add-Content -LiteralPath (Join-Path $tempTemplatePath "pcs.md") -Value "`n- Source note: source/atow-text/page-0001.txt`n" -Encoding UTF8
    Invoke-ValidatorExpectFailure @("-RepoRoot", $tempRoot, "-Template") "protected-source or raw-save marker" "Protected source marker" | Out-Null

    Write-Step "Checking legacy unresolved marker warns without failure."
    Initialize-TempRepo
    Add-Content -LiteralPath (Join-Path $tempTemplatePath "pcs.md") -Value "`n- Open note: Needs lookup`n" -Encoding UTF8
    $warningOutput = Invoke-Validator @("-RepoRoot", $tempRoot, "-Template") "Legacy unresolved marker warning"
    Assert-True ($warningOutput -match "WARN: .*Needs lookup") "Legacy unresolved marker is reported as a warning."
    Assert-True ($warningOutput -like "*Summary: 0 error(s), 1 warning(s).*") "Legacy unresolved marker warning does not fail validation."
}
finally {
    Remove-TempRepo
    Pop-Location
}

Assert-True (-not (Test-Path -LiteralPath $tempRoot)) "Disposable rich character validator fixture removed."

Write-Host ""
Write-Host "Rich character record validator tests passed."
