param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$helperPath = Join-Path $repoRoot "scripts\build-gm-context-packet.ps1"
$templatePath = Join-Path $repoRoot "campaigns\_template"
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) "mek-rpg-context-regressions"
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

function Copy-RequiredFile {
    param([string]$RelativePath)

    $source = Join-Path $repoRoot $RelativePath
    $target = Join-Path $tempRoot $RelativePath
    New-Item -ItemType Directory -Path (Split-Path -Parent $target) -Force | Out-Null
    Copy-Item -LiteralPath $source -Destination $target
}

function Initialize-TempRepo {
    Remove-TempRepo
    New-Item -ItemType Directory -Path $tempCampaignsRoot | Out-Null
    New-Item -ItemType Directory -Path $tempCampaignStateRoot | Out-Null
    Copy-Item -LiteralPath $templatePath -Destination (Join-Path $tempCampaignsRoot "_template") -Recurse

    foreach ($file in @(
        "AGENTS.md",
        "docs/current/AI_READY_PROJECT_WORKFLOW.md",
        "docs/current/MEK_RPG_PROJECT_PROFILE.md",
        "docs/current/GM_CONTEXT_PACKET_DESIGN.md",
        "docs/current/CAMPAIGN_MEMORY_STRATEGY.md",
        "gm/session-procedure.md",
        "indexes/task-router.md",
        "indexes/page-reference-index.md",
        "scripts/build-gm-context-packet.ps1"
    )) {
        Copy-RequiredFile $file
    }

    Set-Content -LiteralPath $tempActivePointerPath -Value "# Active Campaign`n`nActive campaign: campaigns/regression-alpha/`n" -Encoding UTF8
}

function New-CampaignCopy {
    param([string]$CampaignId)

    $target = Join-Path $tempCampaignsRoot $CampaignId
    Copy-Item -LiteralPath (Join-Path $tempCampaignsRoot "_template") -Destination $target -Recurse
    return $target
}

function Invoke-Packet {
    param(
        [string[]]$Arguments,
        [string]$Message
    )

    $fixtureHelperPath = Join-Path $tempRoot "scripts\build-gm-context-packet.ps1"
    $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $fixtureHelperPath @Arguments 2>&1
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        $output | ForEach-Object { Write-Host $_ }
        throw "$Message failed with exit code $exitCode."
    }

    Write-Host "OK: $Message"
    return ($output | Out-String)
}

Push-Location $repoRoot
try {
    Write-Step "Creating disposable GM context regression fixture."
    Initialize-TempRepo
    $alphaPath = New-CampaignCopy "regression-alpha"
    New-CampaignCopy "regression-beta" | Out-Null

    Set-Content -LiteralPath (Join-Path $alphaPath "current-state.md") -Value "# Current State`n`nActive scene: Fresh scene detail.`n" -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $alphaPath "session-log.md") -Value "# Session Log`n`n## Active Or Most Recent Session`n`nFresh scene detail remains here.`n" -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $alphaPath "previous-sessions.md") -Value "# Previous Sessions`n`n## Session Entries`n`nOlder archived summary.`n" -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $alphaPath "relationships.md") -Value "# Relationships`n`nStructured correction owner.`n" -Encoding UTF8

    Write-Step "CTX-001 active campaign source selection."
    $packet = Invoke-Packet @("-RepoRoot", $tempRoot) "Context regression packet"
    Assert-True ($packet -match "Selected campaign id: regression-alpha") "Packet selects the active campaign id."
    Assert-True ($packet -like "*Save folder: *campaigns/regression-alpha*") "Packet reports the selected save folder."
    Assert-True (-not ($packet -match "Selected campaign id: regression-beta")) "Packet does not merge another campaign id."

    Write-Step "CTX-002 recent and durable memory inputs stay separate."
    Assert-True ($packet -match "Active session log: ``campaigns/regression-alpha/session-log.md``") "Packet lists active session log."
    Assert-True ($packet -match "Completed session archive: ``campaigns/regression-alpha/previous-sessions.md``") "Packet lists completed-session archive separately."
    Assert-True ($packet -match "Current state resume pointer: ``campaigns/regression-alpha/current-state.md``") "Packet lists current state resume pointer."

    Write-Step "CTX-003 structured state precedence."
    Assert-True ($packet -match "Structured campaign files override stale narrative summaries") "Packet states structured state precedence."

    Write-Step "CTX-004 rules routing boundary."
    Assert-True ($packet.Contains('Task router: `indexes/task-router.md` [OK]')) "Packet includes task router."
    Assert-True ($packet.Contains('Page reference index: `indexes/page-reference-index.md` [OK]')) "Packet includes page reference index."
    Assert-True ($packet -match "not model memory or raw source text") "Packet preserves rules source boundary."

    Write-Step "CTX-005 missing source warning."
    Remove-Item -LiteralPath (Join-Path $alphaPath "hooks.md") -Force
    $warningPacket = Invoke-Packet @("-RepoRoot", $tempRoot) "Context regression warning packet"
    Assert-True ($warningPacket -match "WARN: Campaign 'regression-alpha' missing standard file: hooks.md") "Packet reports missing standard file warning."

    Write-Step "CTX-006 protected source boundary."
    Assert-True ($packet -match "source/atow-pdf") "Packet includes protected PDF boundary."
    Assert-True ($packet -match "source/atow-text") "Packet includes protected extracted-text boundary."
    Assert-True (-not ($packet -match "source/atow-pdf/.+\\[OK\\]")) "Packet does not treat protected PDF source as an input file."

    Write-Step "CTX-007 read-only packet assembly."
    $pendingPath = Join-Path $alphaPath "pending-mekhq-actions.md"
    $beforeHash = (Get-FileHash -LiteralPath $pendingPath -Algorithm SHA256).Hash
    Invoke-Packet @("-RepoRoot", $tempRoot) "Context regression read-only packet" | Out-Null
    $afterHash = (Get-FileHash -LiteralPath $pendingPath -Algorithm SHA256).Hash
    Assert-True ($beforeHash -eq $afterHash) "Packet helper does not mutate campaign files."
}
finally {
    Remove-TempRepo
    Pop-Location
}

Assert-True (-not (Test-Path -LiteralPath $tempRoot)) "Disposable GM context regression fixture removed."

Write-Host ""
Write-Host "GM context regression scenarios passed."
