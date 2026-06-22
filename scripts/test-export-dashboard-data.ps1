$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$scriptPath = Join-Path $repoRoot "scripts\export-dashboard-data.ps1"
$activePointerPath = Join-Path $repoRoot "campaign-state\active-campaign.md"
$campaignId = "dashboard-adapter-fixture"
$campaignPath = Join-Path $repoRoot "campaigns\$campaignId"
$summaryPath = Join-Path $repoRoot "tests\fixtures\mekhq-summary-minimal.json"
$originalActivePointerContent = if (Test-Path -LiteralPath $activePointerPath -PathType Leaf) {
    Get-Content -LiteralPath $activePointerPath -Raw
}
else {
    $null
}

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Message
    )

    if (-not $Condition) {
        throw "ASSERTION FAILED: $Message"
    }

    Write-Host "OK: $Message"
}

function Get-FileHashMap {
    param([string[]]$Paths)

    $map = @{}
    foreach ($path in $Paths) {
        if (Test-Path -LiteralPath $path -PathType Leaf) {
            $map[$path] = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash
        }
    }
    return $map
}

function Assert-HashMapUnchanged {
    param([hashtable]$Before)

    foreach ($path in $Before.Keys) {
        $after = (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash
        Assert-True ($after -eq $Before[$path]) "File was not modified: $path"
    }
}

Write-Host "TEST: Preparing disposable dashboard adapter campaign."
if (Test-Path -LiteralPath $campaignPath) {
    Remove-Item -LiteralPath $campaignPath -Recurse -Force
}
Copy-Item -LiteralPath (Join-Path $repoRoot "campaigns\_template") -Destination $campaignPath -Recurse

try {
    Add-Content -LiteralPath (Join-Path $campaignPath "current-state.md") -Value "`n## Resume Point`n- Test scene remains read-only."
    Add-Content -LiteralPath (Join-Path $campaignPath "mekhq-bridge.md") -Value "# MekHQ Bridge`n`n## Import Metadata`n`n- Test bridge only."
    $pathsToProtect = @(
        $activePointerPath,
        (Join-Path $campaignPath "current-state.md"),
        (Join-Path $campaignPath "pending-mekhq-actions.md"),
        (Join-Path $campaignPath "mekhq-bridge.md")
    )
    $beforeHashes = Get-FileHashMap -Paths $pathsToProtect

    Write-Host "TEST: Exporting explicit campaign dashboard JSON."
    $json = & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath -RepoRoot $repoRoot -CampaignId $campaignId -MekHqSummaryJson $summaryPath 2>&1
    Assert-True ($LASTEXITCODE -eq 0) "Explicit campaign export exits successfully"
    $data = ($json -join "`n") | ConvertFrom-Json

    Assert-True ($data.schema_version -eq "dashboard-data/v1") "Schema version is dashboard-data/v1"
    Assert-True ($data.selection.campaign_id -eq $campaignId) "Explicit campaign id is selected"
    Assert-True ($data.selection.source -eq "explicit") "Selection source records explicit mode"
    Assert-True ($data.repo.is_dirty -eq $null) "Git dirty status remains null in v1"
    Assert-True ($data.health.protected_sources.source_atow_pdf -eq "excluded") "Protected PDF source is excluded"
    Assert-True ($data.health.protected_sources.source_atow_text -eq "excluded") "Protected extracted text source is excluded"
    Assert-True ($data.health.protected_sources.raw_mekhq_saves -eq "excluded") "Raw MekHQ saves are excluded"
    Assert-True ($null -ne $data.panels.active_campaign) "Active campaign panel exists"
    Assert-True ($null -ne $data.panels.context_packet) "Context packet panel exists"
    Assert-True ($null -ne $data.panels.pending_mekhq_actions) "Pending MekHQ actions panel exists"
    Assert-True ($null -ne $data.panels.privacy_and_boundaries) "Privacy panel exists"
    Assert-True (@($data.panels.mekhq_bridge.items).Count -gt 0) "Sanitized MekHQ summary item is included"
    Assert-True ($data.panels.mekhq_bridge.items[0].raw_input_path_followed -eq $false) "MekHQ summary raw input path is not followed"
    Assert-HashMapUnchanged -Before $beforeHashes

    Write-Host "TEST: Exporting explicit campaign despite invalid active pointer."
    Set-Content -LiteralPath $activePointerPath -Value "Active campaign: ..\bad"
    $invalidActivePointerHashes = Get-FileHashMap -Paths $pathsToProtect
    $explicitWithBadActiveJson = & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath -RepoRoot $repoRoot -CampaignId $campaignId 2>&1
    Assert-True ($LASTEXITCODE -eq 0) "Explicit campaign export ignores invalid active pointer"
    $explicitWithBadActiveData = ($explicitWithBadActiveJson -join "`n") | ConvertFrom-Json
    Assert-True ($explicitWithBadActiveData.selection.campaign_id -eq $campaignId) "Explicit selection is preserved with invalid active pointer"
    Assert-True ($explicitWithBadActiveData.selection.source -eq "explicit") "Explicit selection source is preserved with invalid active pointer"
    Assert-HashMapUnchanged -Before $invalidActivePointerHashes
    if ($null -ne $originalActivePointerContent) {
        Set-Content -LiteralPath $activePointerPath -Value $originalActivePointerContent -NoNewline
    }

    Write-Host "TEST: Exporting active-pointer dashboard JSON from controlled fixture pointer."
    Set-Content -LiteralPath $activePointerPath -Value "Active campaign: $campaignId"
    $activePointerHashes = Get-FileHashMap -Paths $pathsToProtect
    $activeJson = & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath -RepoRoot $repoRoot 2>&1
    Assert-True ($LASTEXITCODE -eq 0) "Active campaign export exits successfully"
    $activeData = ($activeJson -join "`n") | ConvertFrom-Json
    Assert-True ($activeData.selection.source -eq "active-pointer") "Active-pointer selection is recorded"
    Assert-True ($activeData.selection.campaign_id -eq $campaignId) "Active campaign id is selected from controlled pointer"
    Assert-HashMapUnchanged -Before $activePointerHashes
    if ($null -ne $originalActivePointerContent) {
        Set-Content -LiteralPath $activePointerPath -Value $originalActivePointerContent -NoNewline
    }

    Write-Host "TEST: Checking missing and invalid campaign failures."
    $invalidOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath -RepoRoot $repoRoot -CampaignId "..\bad" 2>&1
    Assert-True ($LASTEXITCODE -ne 0) "Invalid campaign id exits non-zero"
    $invalidData = ($invalidOutput -join "`n") | ConvertFrom-Json
    Assert-True (@($invalidData.errors).Count -gt 0) "Invalid campaign id reports JSON errors"

    $missingOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath -RepoRoot $repoRoot -CampaignId "missing-dashboard-campaign" 2>&1
    Assert-True ($LASTEXITCODE -ne 0) "Missing campaign exits non-zero"
    $missingData = ($missingOutput -join "`n") | ConvertFrom-Json
    Assert-True (@($missingData.errors | Where-Object { $_.code -eq "missing-campaign-folder" }).Count -gt 0) "Missing campaign reports missing folder"

    Write-Host "TEST: Checking raw MekHQ save input rejection."
    $rawSavePath = Join-Path $env:TEMP "dashboard-adapter-raw-save.cpnx"
    Set-Content -LiteralPath $rawSavePath -Value "raw save placeholder"
    try {
        $rawOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath -RepoRoot $repoRoot -CampaignId $campaignId -MekHqSummaryJson $rawSavePath 2>&1
        Assert-True ($LASTEXITCODE -ne 0) "Raw MekHQ save input exits non-zero"
        $rawData = ($rawOutput -join "`n") | ConvertFrom-Json
        Assert-True (@($rawData.errors | Where-Object { $_.code -eq "raw-save-rejected" }).Count -gt 0) "Raw MekHQ save input is rejected"
    }
    finally {
        if (Test-Path -LiteralPath $rawSavePath) {
            Remove-Item -LiteralPath $rawSavePath -Force
        }
    }

    Assert-HashMapUnchanged -Before $beforeHashes
}
finally {
    if ($null -ne $originalActivePointerContent) {
        Set-Content -LiteralPath $activePointerPath -Value $originalActivePointerContent -NoNewline
    }
    if (Test-Path -LiteralPath $campaignPath) {
        Remove-Item -LiteralPath $campaignPath -Recurse -Force
        Write-Host "OK: Disposable dashboard adapter campaign removed."
    }
}

Write-Host ""
Write-Host "Dashboard data adapter tests passed."
