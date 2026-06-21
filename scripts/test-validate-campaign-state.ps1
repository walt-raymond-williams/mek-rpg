param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$templatePath = Join-Path $repoRoot "campaigns\_template"
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) "mek-rpg-validator-fixture"
$tempCampaignsRoot = Join-Path $tempRoot "campaigns"
$tempTemplatePath = Join-Path $tempCampaignsRoot "_template"
$tempCampaignStateRoot = Join-Path $tempRoot "campaign-state"
$tempActivePointerPath = Join-Path $tempCampaignStateRoot "active-campaign.md"
$validatorPath = Join-Path $repoRoot "scripts\validate-campaign-state.ps1"

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
    New-Item -ItemType Directory -Path $tempCampaignStateRoot | Out-Null
    Copy-Item -LiteralPath $templatePath -Destination $tempTemplatePath -Recurse
    Set-Content -LiteralPath $tempActivePointerPath -Value "# Active Campaign`n`nActive campaign: None selected`n" -Encoding UTF8
}

function New-CampaignCopy {
    param([string]$CampaignId)

    $target = Join-Path $tempCampaignsRoot $CampaignId
    Copy-Item -LiteralPath $tempTemplatePath -Destination $target -Recurse
    return $target
}

Push-Location $repoRoot
try {
    Write-Step "Creating disposable validator repository fixture."
    Initialize-TempRepo
    $validCampaignPath = New-CampaignCopy "validator-valid"

    Write-Step "Checking valid explicit campaign."
    $validOutput = Invoke-Validator @("-RepoRoot", $tempRoot, "-CampaignId", "validator-valid") "Valid explicit campaign"
    Assert-True ($validOutput -like "*Summary: 0 error(s), 0 warning(s).*") "Valid campaign has no errors or warnings."

    Write-Step "Checking missing required standard file failure."
    $missingFilePath = New-CampaignCopy "validator-missing-file"
    Remove-Item -LiteralPath (Join-Path $missingFilePath "pending-mekhq-actions.md") -Force
    Invoke-ValidatorExpectFailure @("-RepoRoot", $tempRoot, "-CampaignId", "validator-missing-file") "missing standard file: pending-mekhq-actions.md" "Missing required standard file" | Out-Null

    Write-Step "Checking missing top-level heading warning without failure."
    $missingHeadingPath = New-CampaignCopy "validator-missing-heading"
    Set-Content -LiteralPath (Join-Path $missingHeadingPath "overview.md") -Value "No top heading here`n" -Encoding UTF8
    $warningOutput = Invoke-Validator @("-RepoRoot", $tempRoot, "-CampaignId", "validator-missing-heading") "Missing heading warning case"
    Assert-True ($warningOutput -match "WARN: Campaign 'validator-missing-heading' file has no top-level Markdown heading") "Missing heading emits warning."
    Assert-True ($warningOutput -like "*Summary: 0 error(s), 1 warning(s).*") "Missing heading warning does not fail."

    Write-Step "Checking -StrictActive failure when no active campaign is selected."
    Invoke-ValidatorExpectFailure @("-RepoRoot", $tempRoot, "-StrictActive") "No active campaign is selected" "StrictActive with no active campaign" | Out-Null

    Write-Step "Checking legacy campaign-state active pointer failure."
    Set-Content -LiteralPath $tempActivePointerPath -Value "# Active Campaign`n`nActive campaign: campaign-state/current-mission.md`n" -Encoding UTF8
    Invoke-ValidatorExpectFailure @("-RepoRoot", $tempRoot) "legacy flat campaign-state path" "Legacy campaign-state active pointer" | Out-Null

    Write-Step "Checking unsafe campaign id rejection."
    Invoke-ValidatorExpectFailure @("-RepoRoot", $tempRoot, "-CampaignId", "..\unsafe") "must use lowercase letters" "Unsafe explicit campaign id" | Out-Null

    Write-Step "Checking live repository explicit campaign still validates."
    Invoke-Validator @("-CampaignId", "isekai-atlas-field") "Live explicit campaign validation" | Out-Null
}
finally {
    Remove-TempRepo
    Pop-Location
}

Assert-True (-not (Test-Path -LiteralPath $tempRoot)) "Disposable validator repository fixture removed."

Write-Host ""
Write-Host "Campaign-state validator tests passed."
