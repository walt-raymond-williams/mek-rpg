param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$helperPath = Join-Path $repoRoot "scripts\build-gm-context-packet.ps1"
$templatePath = Join-Path $repoRoot "campaigns\_template"
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) "mek-rpg-context-packet-fixture"
$tempCampaignsRoot = Join-Path $tempRoot "campaigns"
$tempCampaignStateRoot = Join-Path $tempRoot "campaign-state"
$tempActivePointerPath = Join-Path $tempCampaignStateRoot "active-campaign.md"

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

function Remove-TempRepo {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
    }
}

function Initialize-TempRepo {
    Remove-TempRepo
    New-Item -ItemType Directory -Path $tempCampaignsRoot | Out-Null
    New-Item -ItemType Directory -Path $tempCampaignStateRoot | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $tempRoot "docs\current") -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $tempRoot "indexes") -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $tempRoot "gm") -Force | Out-Null
    New-Item -ItemType Directory -Path (Join-Path $tempRoot "scripts") -Force | Out-Null

    Copy-Item -LiteralPath $templatePath -Destination (Join-Path $tempCampaignsRoot "_template") -Recurse
    Copy-Item -LiteralPath $helperPath -Destination (Join-Path $tempRoot "scripts\build-gm-context-packet.ps1")
    Copy-Item -LiteralPath (Join-Path $repoRoot "scripts\validate-campaign-state.ps1") -Destination (Join-Path $tempRoot "scripts\validate-campaign-state.ps1")
    Copy-Item -LiteralPath (Join-Path $repoRoot "scripts\validate-mekhq-pending-actions.ps1") -Destination (Join-Path $tempRoot "scripts\validate-mekhq-pending-actions.ps1")

    foreach ($file in @(
        "AGENTS.md",
        "docs/current/AI_READY_PROJECT_WORKFLOW.md",
        "docs/current/MEK_RPG_PROJECT_PROFILE.md",
        "docs/current/GM_CONTEXT_PACKET_DESIGN.md",
        "docs/current/CAMPAIGN_MEMORY_STRATEGY.md",
        "docs/current/MEKHQ_BRIDGE_DATA_MODEL.md",
        "docs/current/MEKHQ_LINKED_PLAY_LOOP.md",
        "docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md",
        "gm/session-procedure.md",
        "indexes/task-router.md",
        "indexes/page-reference-index.md"
    )) {
        $source = Join-Path $repoRoot $file
        $target = Join-Path $tempRoot $file
        Copy-Item -LiteralPath $source -Destination $target
    }

    Set-Content -LiteralPath $tempActivePointerPath -Value "# Active Campaign`n`nActive campaign: campaigns/packet-valid/`n" -Encoding UTF8
}

function New-CampaignCopy {
    param([string]$CampaignId)

    $target = Join-Path $tempCampaignsRoot $CampaignId
    Copy-Item -LiteralPath (Join-Path $tempCampaignsRoot "_template") -Destination $target -Recurse
    return $target
}

function Invoke-Helper {
    param(
        [string[]]$Arguments,
        [string]$Message
    )

    $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $helperPath @Arguments 2>&1
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        $output | ForEach-Object { Write-Host $_ }
        throw "$Message failed with exit code $exitCode."
    }

    Write-Host "OK: $Message"
    return ($output | Out-String)
}

function Invoke-HelperExpectFailure {
    param(
        [string[]]$Arguments,
        [string]$ExpectedPattern,
        [string]$Message
    )

    $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $helperPath @Arguments 2>&1
    $exitCode = $LASTEXITCODE
    Assert-True ($exitCode -ne 0) "$Message exits non-zero"
    $text = ($output | Out-String)
    Assert-True ($text -match $ExpectedPattern) "$Message reports expected failure"
    return $text
}

Push-Location $repoRoot
try {
    Write-Step "Creating disposable context packet fixture repository."
    Initialize-TempRepo
    $campaignPath = New-CampaignCopy "packet-valid"

    Write-Step "Checking active campaign packet source report."
    $activeOutput = Invoke-Helper @("-RepoRoot", $tempRoot) "Active campaign packet report"
    Assert-True ($activeOutput -match "# GM Context Packet") "Packet report has expected title."
    Assert-True ($activeOutput -match "Selected campaign id: packet-valid") "Packet report resolves active campaign id."
    Assert-True ($activeOutput -match "## Request And Mode") "Packet report includes request and mode section."
    Assert-True ($activeOutput -match "## Active Campaign") "Packet report includes active campaign section."
    Assert-True ($activeOutput -match "## Current Scene State") "Packet report includes current scene section."
    Assert-True ($activeOutput -match "## MekHQ Bridge And Pending Intents") "Packet report includes MekHQ pending section."
    Assert-True ($activeOutput -match "## Rules Routes") "Packet report includes rules route section."
    Assert-True ($activeOutput -match "## Recent Events") "Packet report includes recent events section."
    Assert-True ($activeOutput -match "## Durable Memory") "Packet report includes durable memory section."
    Assert-True ($activeOutput -match "## Warnings") "Packet report includes warnings section."
    Assert-True ($activeOutput -match "does not interpret rules") "Packet report preserves no-interpretation boundary."
    Assert-True ($activeOutput -match "source/atow-pdf") "Packet report names protected source boundary."

    Write-Step "Checking missing campaign file is flagged without rewriting files."
    $pendingPath = Join-Path $campaignPath "pending-mekhq-actions.md"
    $beforeHash = (Get-FileHash -LiteralPath $pendingPath -Algorithm SHA256).Hash
    Remove-Item -LiteralPath (Join-Path $campaignPath "hooks.md") -Force
    $missingOutput = Invoke-Helper @("-RepoRoot", $tempRoot) "Missing file warning packet report"
    Assert-True ($missingOutput -match "WARN: Campaign 'packet-valid' missing standard file: hooks.md") "Missing standard file warning is reported."
    $afterHash = (Get-FileHash -LiteralPath $pendingPath -Algorithm SHA256).Hash
    Assert-True ($beforeHash -eq $afterHash) "Helper does not mutate pending actions file."

    Write-Step "Checking explicit campaign id works when no active campaign is selected."
    New-CampaignCopy "packet-explicit" | Out-Null
    Set-Content -LiteralPath $tempActivePointerPath -Value "# Active Campaign`n`nActive campaign: None selected`n" -Encoding UTF8
    $explicitOutput = Invoke-Helper @("-RepoRoot", $tempRoot, "packet-explicit") "Explicit campaign packet report"
    Assert-True ($explicitOutput -match "Selected campaign id: packet-explicit") "Explicit campaign id is used."

    Write-Step "Checking legacy active pointer failure."
    Set-Content -LiteralPath $tempActivePointerPath -Value "# Active Campaign`n`nActive campaign: campaign-state/current-mission.md`n" -Encoding UTF8
    Invoke-HelperExpectFailure @("-RepoRoot", $tempRoot) "legacy flat campaign-state path" "Legacy active pointer" | Out-Null
}
finally {
    Remove-TempRepo
    Pop-Location
}

Assert-True (-not (Test-Path -LiteralPath $tempRoot)) "Disposable context packet fixture removed."

Write-Host ""
Write-Host "GM context packet helper tests passed."
