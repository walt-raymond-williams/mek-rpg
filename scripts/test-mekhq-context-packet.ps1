param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$templatePath = Join-Path $repoRoot "campaigns\_template"
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) "mek-rpg-mekhq-context-packet"
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
        "docs/current/MEKHQ_BRIDGE_DATA_MODEL.md",
        "docs/current/MEKHQ_LINKED_PLAY_LOOP.md",
        "docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md",
        "docs/current/MEKHQ_CHECKPOINT_WARNING_SURFACING.md",
        "gm/session-procedure.md",
        "gm/switch-to-classic-battletech.md",
        "indexes/task-router.md",
        "indexes/page-reference-index.md",
        "rules/vehicles-and-mechs/overview.md",
        "scripts/build-gm-context-packet.ps1",
        "scripts/validate-campaign-state.ps1",
        "scripts/validate-mekhq-pending-actions.ps1"
    )) {
        Copy-RequiredFile $file
    }

    Set-Content -LiteralPath $tempActivePointerPath -Value "# Active Campaign`n`nActive campaign: campaigns/mekhq-context-alpha/`n" -Encoding UTF8
}

function New-CampaignCopy {
    param([string]$CampaignId)

    $target = Join-Path $tempCampaignsRoot $CampaignId
    Copy-Item -LiteralPath (Join-Path $tempCampaignsRoot "_template") -Destination $target -Recurse
    return $target
}

function New-PendingItemText {
    return @"
# Pending MekHQ Actions

Use this file for MekHQ-linked campaigns when RPG play creates a possible hard ledger change. Supported commands become command proposals/results; unsupported commands use manual fallback checklists until verified.

## Open Items

### mekhq-pending-2026-06-21-045: Apply contract salvage outcome

- Status: queued
- Type: tactical-outcome
- Priority: before-day-advance
- Created: 2026-06-21
- Updated: 2026-06-21
- Source scene: `session-log.md` tactical aftermath
- Source files: `session-log.md`, `assets.md`, `missions.md`
- MekHQ target ids: campaign `mekhq-test-campaign`; person `Unknown`; unit `unit-17`; contract `contract-9`; scenario `scenario-3`
- Current imported baseline: MekHQ date `3050-01-04`; scenario `scenario-3` unresolved
- Proposed MekHQ action: Apply the tactical outcome manually in MekHQ UI after the external tactical result is available.
- Manual application checklist:
  - Open the linked MekHQ campaign save named in `mekhq-bridge.md`.
  - Confirm the current MekHQ date/save matches the latest imported baseline.
  - Apply the tactical outcome in the MekHQ UI.
  - Save the MekHQ campaign.
- Command application checklist:
  - Confirm `GET /campaign/commands` reports the requested command available.
  - Run dry-run/preflight if the command supports it.
  - Execute only after approval or documented automation policy.
  - Re-read live MekHQ state and verify expected fields.
- Confirmation needed from next import: scenario `scenario-3` resolved and unit damage/salvage reflected in summary.
- Affected campaign files after import: `assets.md`, `missions.md`, `current-state.md`
- Blockers or discrepancy notes: Needs saved MekHQ import before this becomes a final ledger fact.
- Resolution notes: TBD

"@
}

function Invoke-Packet {
    param([string]$Message)

    $fixtureHelperPath = Join-Path $tempRoot "scripts\build-gm-context-packet.ps1"
    $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $fixtureHelperPath -RepoRoot $tempRoot -RunValidators 2>&1
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
    Write-Step "Creating disposable MekHQ-linked context packet fixture."
    Initialize-TempRepo
    $campaignPath = New-CampaignCopy "mekhq-context-alpha"

    Set-Content -LiteralPath (Join-Path $campaignPath "mekhq-bridge.md") -Value @"
# MekHQ Bridge

Linked MekHQ campaign: MekHQ Test Campaign
Last import: 2026-06-21T04:00:00Z
MekHQ campaign date: 3050-01-04
Source save: Not committed; fixture metadata only.
Unsupported fields: contract salvage details need MekHQ inspection.
Bridge discrepancy: MEK-RPG scene time is inside the imported day.
No direct MekHQ save or XML writeback is authorized.
"@ -Encoding UTF8

    Set-Content -LiteralPath (Join-Path $campaignPath "pending-mekhq-actions.md") -Value (New-PendingItemText) -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $campaignPath "current-state.md") -Value "# Current State`n`nCurrent date: 3050-01-04 from MekHQ import.`nActive scene: Tactical aftermath inside the MekHQ day.`n" -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $campaignPath "session-log.md") -Value "# Session Log`n`n## Active Or Most Recent Session`n`nThe table returned from tactical resolution and queued mekhq-pending-2026-06-21-045.`n" -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $campaignPath "previous-sessions.md") -Value "# Previous Sessions`n`n## Session Entries`n`nStale note: the scenario was once assumed resolved, but current structured state and pending actions supersede this.`n" -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $campaignPath "missions.md") -Value "# Missions`n`n## Active Mission`n`nScenario scenario-3 remains pending MekHQ confirmation through mekhq-pending-2026-06-21-045.`n" -Encoding UTF8

    Write-Step "MEKHQ-CTX-001 packet includes bridge metadata and unresolved pending actions."
    $packet = Invoke-Packet "MekHQ-linked context packet"
    Assert-True ($packet.Contains('MekHQ bridge metadata: `campaigns/mekhq-context-alpha/mekhq-bridge.md` [OK]')) "Packet includes bridge metadata file."
    Assert-True ($packet.Contains('Pending MekHQ intents: `campaigns/mekhq-context-alpha/pending-mekhq-actions.md` [OK]')) "Packet includes pending actions file."
    Assert-True ($packet.Contains('Checkpoint warning surfacing policy: `docs/current/MEKHQ_CHECKPOINT_WARNING_SURFACING.md` [OK]')) "Packet includes checkpoint warning surfacing policy."
    Assert-True ($packet -match "mekhq-pending-2026-06-21-045") "Packet validator output reports unresolved pending item id."

    Write-Step "MEKHQ-CTX-002 pending actions stay labeled as intents, command records, or manual fallbacks."
    Assert-True ($packet -match "These are command proposals, command results, or manual-action checklists, not confirmed hard ledger facts") "Pending validator preserves pending-intent label."
    Assert-True ($packet -match "Pending MekHQ actions are command proposals, command results, or manual fallback checklists") "Packet authority notes preserve pending-intent boundary."

    Write-Step "MEKHQ-CTX-003 structured campaign state outranks stale summaries."
    Assert-True ($packet -match "Structured campaign files override stale narrative summaries") "Packet preserves structured-state precedence."
    Assert-True ($packet.Contains('Current state resume pointer: `campaigns/mekhq-context-alpha/current-state.md` [OK]')) "Packet includes current state."
    Assert-True ($packet.Contains('Completed session archive: `campaigns/mekhq-context-alpha/previous-sessions.md` [OK]')) "Packet includes older archive separately."

    Write-Step "MEKHQ-CTX-004 rules routes and tactical handoff sources are referenced."
    Assert-True ($packet.Contains('Task router: `indexes/task-router.md` [OK]')) "Packet includes task router."
    Assert-True ($packet.Contains('Tactical handoff procedure: `gm/switch-to-classic-battletech.md` [OK]')) "Packet includes tactical handoff procedure."
    Assert-True ($packet.Contains('Vehicle and tactical bridge overview: `rules/vehicles-and-mechs/overview.md` [OK]')) "Packet includes vehicle/tactical bridge overview."
    Assert-True ($packet -match "does not interpret rules") "Packet does not claim rules authority."

    Write-Step "MEKHQ-CTX-005 protected source and no-writeback boundaries are preserved."
    Assert-True ($packet -match "source/atow-pdf") "Packet names protected PDF boundary."
    Assert-True ($packet -match "raw MekHQ save payloads") "Packet names raw MekHQ save boundary."
    Assert-True ($packet -match "does not .*apply MekHQ changes") "Packet does not apply MekHQ changes."

    Write-Step "MEKHQ-CTX-006 read-only behavior for campaign files."
    $pendingPath = Join-Path $campaignPath "pending-mekhq-actions.md"
    $beforeHash = (Get-FileHash -LiteralPath $pendingPath -Algorithm SHA256).Hash
    Invoke-Packet "MekHQ-linked context packet read-only check" | Out-Null
    $afterHash = (Get-FileHash -LiteralPath $pendingPath -Algorithm SHA256).Hash
    Assert-True ($beforeHash -eq $afterHash) "Packet helper does not mutate pending actions."
}
finally {
    Remove-TempRepo
    Pop-Location
}

Assert-True (-not (Test-Path -LiteralPath $tempRoot)) "Disposable MekHQ-linked context packet fixture removed."

Write-Host ""
Write-Host "MekHQ-linked context packet regression scenarios passed."
