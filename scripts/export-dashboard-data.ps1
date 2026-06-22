param(
    [string]$CampaignId,
    [string]$RepoRoot,
    [switch]$IncludePrivate,
    [switch]$IncludeExcerpts,
    [string]$MekHqSummaryJson
)

$ErrorActionPreference = "Stop"

$safeCampaignIdPattern = '^[a-z0-9][a-z0-9-]*[a-z0-9]$|^[a-z0-9]$'
$standardCampaignFiles = @(
    "overview.md",
    "current-state.md",
    "pcs.md",
    "npcs.md",
    "factions.md",
    "locations.md",
    "assets.md",
    "relationships.md",
    "missions.md",
    "hooks.md",
    "pending-mekhq-actions.md",
    "session-log.md",
    "previous-sessions.md",
    "rules-gaps.md",
    "playtest-notes.md",
    "safety-and-tone.md"
)

$script:Warnings = [System.Collections.Generic.List[object]]::new()
$script:Errors = [System.Collections.Generic.List[object]]::new()

function Add-DashboardWarning {
    param(
        [string]$Code,
        [string]$Message,
        [string]$Path = $null
    )

    $script:Warnings.Add([pscustomobject]@{
        code = $Code
        message = $Message
        path = $Path
    })
}

function Add-DashboardError {
    param(
        [string]$Code,
        [string]$Message,
        [string]$Path = $null
    )

    $script:Errors.Add([pscustomobject]@{
        code = $Code
        message = $Message
        path = $Path
    })
}

function Format-RelativePath {
    param([string]$Path)

    if (-not $Path) {
        return $null
    }

    $resolved = $Path
    if (Test-Path -LiteralPath $Path) {
        $resolved = (Resolve-Path -LiteralPath $Path).Path
    }

    if ($resolved.StartsWith($script:RepoRootResolved, [System.StringComparison]::OrdinalIgnoreCase)) {
        return ($resolved.Substring($script:RepoRootResolved.Length).TrimStart('\', '/') -replace '\\', '/')
    }

    return ($Path -replace '\\', '/')
}

function Test-CampaignId {
    param(
        [string]$Value,
        [string]$Context
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        Add-DashboardError -Code "invalid-campaign-id" -Message "$Context campaign id is empty."
        return $false
    }

    if ($Value -eq "_template") {
        Add-DashboardError -Code "reserved-campaign-id" -Message "$Context campaign id '_template' is reserved."
        return $false
    }

    if ($Value -notmatch $safeCampaignIdPattern) {
        Add-DashboardError -Code "invalid-campaign-id" -Message "$Context campaign id '$Value' must use lowercase letters, numbers, and hyphens, with no leading or trailing hyphen."
        return $false
    }

    return $true
}

function Get-ActiveCampaignSelection {
    param([string]$ActivePointerPath)

    if (-not (Test-Path -LiteralPath $ActivePointerPath -PathType Leaf)) {
        Add-DashboardError -Code "missing-active-pointer" -Message "Active campaign pointer missing." -Path "campaign-state/active-campaign.md"
        return [pscustomobject]@{
            status = "missing"
            campaign_id = $null
            raw_value = $null
        }
    }

    $activeLines = @(Get-Content -LiteralPath $ActivePointerPath | Where-Object { $_ -match '^\s*Active campaign\s*:' })
    if ($activeLines.Count -eq 0) {
        Add-DashboardError -Code "invalid-active-pointer" -Message "Active campaign pointer has no 'Active campaign:' line." -Path "campaign-state/active-campaign.md"
        return [pscustomobject]@{
            status = "invalid"
            campaign_id = $null
            raw_value = $null
        }
    }

    if ($activeLines.Count -gt 1) {
        Add-DashboardWarning -Code "multiple-active-lines" -Message "Active campaign pointer has multiple 'Active campaign:' lines; using the first." -Path "campaign-state/active-campaign.md"
    }

    $rawValue = ($activeLines[0] -replace '^\s*Active campaign\s*:\s*', '').Trim()
    $normalized = $rawValue.Trim([char[]]@([char]0x60, [char]0x22, [char]0x27)).Trim()

    if ($normalized -match '^(?i:none selected)$') {
        return [pscustomobject]@{
            status = "none"
            campaign_id = $null
            raw_value = $rawValue
        }
    }

    if ($normalized -match '^campaign-state(/|\\)' -or $normalized -eq "campaign-state") {
        Add-DashboardError -Code "legacy-active-pointer" -Message "Active campaign points at legacy campaign-state path instead of campaigns/<campaign-id>/." -Path "campaign-state/active-campaign.md"
        return [pscustomobject]@{
            status = "invalid"
            campaign_id = $null
            raw_value = $rawValue
        }
    }

    $campaignId = $normalized
    if ($normalized -match '^campaigns(/|\\)([^/\\]+)(/|\\)?$') {
        $campaignId = $Matches[2]
    }
    elseif ($normalized -match '(/|\\)') {
        Add-DashboardError -Code "invalid-active-pointer" -Message "Active campaign value must be a campaign id or campaigns/<campaign-id>/." -Path "campaign-state/active-campaign.md"
        return [pscustomobject]@{
            status = "invalid"
            campaign_id = $null
            raw_value = $rawValue
        }
    }

    if (-not (Test-CampaignId -Value $campaignId -Context "Active")) {
        return [pscustomobject]@{
            status = "invalid"
            campaign_id = $campaignId
            raw_value = $rawValue
        }
    }

    return [pscustomobject]@{
        status = "selected"
        campaign_id = $campaignId
        raw_value = $rawValue
    }
}

function Get-Headings {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return @()
    }

    return @(
        Get-Content -LiteralPath $Path |
            Where-Object { $_ -match '^\s*#+\s+\S' } |
            ForEach-Object {
                $level = ([regex]::Match($_, '^\s*(#+)')).Groups[1].Value.Length
                [pscustomobject]@{
                    level = $level
                    text = ($_ -replace '^\s*#+\s*', '').Trim()
                }
            }
    )
}

function Get-Excerpt {
    param(
        [string]$Path,
        [string]$Privacy
    )

    if (-not $IncludeExcerpts -or -not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return $null
    }

    if (($Privacy -in @("gm-secret", "child-safety")) -and -not $IncludePrivate) {
        Add-DashboardWarning -Code "private-excerpt-redacted" -Message "Private excerpt redacted; pass -IncludePrivate to include it." -Path (Format-RelativePath $Path)
        return $null
    }

    $lines = @(
        Get-Content -LiteralPath $Path |
            Where-Object {
                $trimmed = $_.Trim()
                $trimmed -and $trimmed -notmatch '^\s*#'
            } |
            Select-Object -First 6
    )

    if ($lines.Count -eq 0) {
        return $null
    }

    return (($lines -join " ") -replace '\s+', ' ').Trim()
}

function Get-PrivacyForPath {
    param([string]$RelativePath)

    if ($RelativePath -match '^source/atow-pdf/' -or $RelativePath -match '^source/atow-text/') {
        return "protected-excluded"
    }

    if ($RelativePath -match '\.(cpnx|gz|xml)$') {
        return "raw-save-excluded"
    }

    if ($RelativePath -like "*/safety-and-tone.md") {
        return "child-safety"
    }

    if ($RelativePath -like "*/npcs.md" -or $RelativePath -like "*/hooks.md" -or $RelativePath -like "*/relationships.md") {
        return "gm-secret"
    }

    if ($RelativePath -like "campaigns/*") {
        return "private"
    }

    return "normal"
}

function New-SourceRecord {
    param(
        [string]$RelativePath,
        [string]$Role,
        [bool]$Required = $false
    )

    $fullPath = Join-Path $script:RepoRootResolved ($RelativePath -replace '/', '\')
    $exists = Test-Path -LiteralPath $fullPath -PathType Leaf
    $privacy = Get-PrivacyForPath -RelativePath $RelativePath
    $headings = @(Get-Headings -Path $fullPath)

    if ($Required -and -not $exists) {
        Add-DashboardWarning -Code "missing-required-file" -Message "Required dashboard source is missing." -Path $RelativePath
    }

    [pscustomobject]@{
        path = $RelativePath
        role = $Role
        exists = $exists
        required = $Required
        heading = if ($headings.Count -gt 0) { $headings[0].text } else { $null }
        headings = $headings
        evidence = if ($exists) { "Confirmed by campaign file" } else { "Missing" }
        privacy = $privacy
        excerpt = Get-Excerpt -Path $fullPath -Privacy $privacy
    }
}

function New-Panel {
    param(
        [string]$Title,
        [object[]]$Sources = @(),
        [object[]]$Items = @(),
        [object[]]$Warnings = @(),
        [string]$Status = "ok"
    )

    [pscustomobject]@{
        title = $Title
        status = $Status
        sources = @($Sources)
        items = @($Items)
        warnings = @($Warnings)
    }
}

function Invoke-ToolOutput {
    param(
        [string]$ScriptRelativePath,
        [string[]]$Arguments = @()
    )

    $scriptPath = Join-Path $script:RepoRootResolved ($ScriptRelativePath -replace '/', '\')
    if (-not (Test-Path -LiteralPath $scriptPath -PathType Leaf)) {
        return [pscustomobject]@{
            script = $ScriptRelativePath
            exit_code = $null
            output = @()
            status = "missing"
        }
    }

    $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath @Arguments 2>&1
    $exitCode = $LASTEXITCODE
    [pscustomobject]@{
        script = $ScriptRelativePath
        exit_code = $exitCode
        output = @($output | ForEach-Object { "$_" })
        status = if ($exitCode -eq 0) { "ok" } else { "error" }
    }
}

function Get-MekHqSummaryPanelItem {
    param([string]$SummaryPath)

    if (-not $SummaryPath) {
        return $null
    }

    $resolvedSummaryPath = $null
    try {
        $resolvedSummaryPath = (Resolve-Path -LiteralPath $SummaryPath).Path
    }
    catch {
        Add-DashboardError -Code "missing-summary-json" -Message "MekHQ summary JSON not found." -Path $SummaryPath
        return $null
    }

    if ($resolvedSummaryPath -match '\.(cpnx|gz|xml)$') {
        Add-DashboardError -Code "raw-save-rejected" -Message "MekHQ dashboard input must be sanitized JSON, not a raw save or XML file." -Path $SummaryPath
        return $null
    }

    try {
        $summary = (Get-Content -LiteralPath $resolvedSummaryPath -Raw) | ConvertFrom-Json
    }
    catch {
        Add-DashboardError -Code "invalid-summary-json" -Message "MekHQ summary JSON could not be parsed." -Path $SummaryPath
        return $null
    }

    $metadata = $summary.bridge_metadata
    [pscustomobject]@{
        id = "mekhq-summary-json"
        label = "Sanitized MekHQ summary JSON"
        kind = "mekhq-summary"
        status = "advisory"
        source_path = Format-RelativePath $resolvedSummaryPath
        evidence = "Confirmed from explicit sanitized JSON input"
        campaign_name = $summary.campaign.name
        campaign_date = $summary.campaign.date
        warnings = @($metadata.warnings)
        unsupported = @($summary.unsupported)
        raw_input_path_followed = $false
        raw_input_path_policy = "bridge_metadata input paths are displayed only as metadata and are never opened by this adapter"
    }
}

$script:RepoRootResolved = if ($RepoRoot) {
    (Resolve-Path -LiteralPath $RepoRoot).Path
}
else {
    (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
}

$campaignsRoot = Join-Path $script:RepoRootResolved "campaigns"
$activePointerPath = Join-Path $script:RepoRootResolved "campaign-state\active-campaign.md"
$activeSelection = [pscustomobject]@{
    status = "not-read"
    campaign_id = $null
    raw_value = $null
}
$selectionSource = "active-pointer"
$selectedCampaignId = $null

if ($CampaignId) {
    if (Test-CampaignId -Value $CampaignId -Context "Explicit") {
        $selectionSource = "explicit"
        $selectedCampaignId = $CampaignId
    }
}
else {
    $activeSelection = Get-ActiveCampaignSelection -ActivePointerPath $activePointerPath
    $selectedCampaignId = $activeSelection.campaign_id
    if (-not $selectedCampaignId) {
        Add-DashboardError -Code "no-campaign-selected" -Message "No campaign selected. Pass -CampaignId or select one in campaign-state/active-campaign.md."
    }
}

$campaignRelativePath = if ($selectedCampaignId) { "campaigns/$selectedCampaignId" } else { $null }
$campaignPath = if ($selectedCampaignId) { Join-Path $campaignsRoot $selectedCampaignId } else { $null }

if ($campaignPath) {
    if (-not (Test-Path -LiteralPath $campaignPath -PathType Container)) {
        Add-DashboardError -Code "missing-campaign-folder" -Message "Selected campaign folder not found." -Path $campaignRelativePath
    }
    else {
        $resolvedCampaignPath = (Resolve-Path -LiteralPath $campaignPath).Path
        $resolvedCampaignsRoot = (Resolve-Path -LiteralPath $campaignsRoot).Path
        if (-not $resolvedCampaignPath.StartsWith($resolvedCampaignsRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            Add-DashboardError -Code "campaign-outside-root" -Message "Refusing to read campaign outside campaigns/." -Path $campaignRelativePath
        }
    }
}

$campaignSources = @()
if ($campaignRelativePath) {
    foreach ($fileName in $standardCampaignFiles) {
        $campaignSources += New-SourceRecord -RelativePath "$campaignRelativePath/$fileName" -Role ($fileName -replace '\.md$', '') -Required $true
    }
}

$toolOutputs = @()
if ($selectedCampaignId) {
    $toolOutputs += Invoke-ToolOutput -ScriptRelativePath "scripts/validate-campaign-state.ps1" -Arguments @("-RepoRoot", $script:RepoRootResolved, "-CampaignId", $selectedCampaignId)
    $pendingPath = if ($campaignPath) { Join-Path $campaignPath "pending-mekhq-actions.md" } else { $null }
    if ($pendingPath -and (Test-Path -LiteralPath $pendingPath -PathType Leaf)) {
        $toolOutputs += Invoke-ToolOutput -ScriptRelativePath "scripts/validate-mekhq-pending-actions.ps1" -Arguments @($pendingPath, "-ReportUnresolved")
    }
    $toolOutputs += Invoke-ToolOutput -ScriptRelativePath "scripts/build-gm-context-packet.ps1" -Arguments @($selectedCampaignId, "-RepoRoot", $script:RepoRootResolved, "-RunValidators")
}

foreach ($tool in $toolOutputs) {
    if ($tool.exit_code -ne 0 -and $null -ne $tool.exit_code) {
        Add-DashboardWarning -Code "tool-output-warning" -Message "$($tool.script) exited with code $($tool.exit_code)." -Path $tool.script
    }
}

$missingFiles = @($campaignSources | Where-Object { -not $_.exists } | ForEach-Object { $_.path })
$healthStatus = if ($script:Errors.Count -gt 0) { "error" } elseif ($script:Warnings.Count -gt 0 -or $missingFiles.Count -gt 0) { "warn" } else { "ok" }
$mekHqBridgeSource = if ($campaignRelativePath) { New-SourceRecord -RelativePath "$campaignRelativePath/mekhq-bridge.md" -Role "mekhq bridge" -Required $false } else { $null }
$mekHqSummaryItem = Get-MekHqSummaryPanelItem -SummaryPath $MekHqSummaryJson

$panels = [ordered]@{
    active_campaign = New-Panel -Title "Active Campaign" -Sources @(
        New-SourceRecord -RelativePath "campaign-state/active-campaign.md" -Role "active pointer" -Required $true
        if ($campaignSources.Count -gt 0) { $campaignSources | Where-Object { $_.path -like "*/overview.md" } }
    ) -Items @(
        [pscustomobject]@{
            id = "campaign-selection"
            label = $selectedCampaignId
            kind = "selection"
            status = $activeSelection.status
            source = $selectionSource
            active_pointer_value = $activeSelection.raw_value
        }
    ) -Warnings @($script:Warnings | Where-Object { $_.code -match 'active|campaign|explicit' })
    current_scene = New-Panel -Title "Current Scene" -Sources @($campaignSources | Where-Object { $_.path -match '/(current-state|session-log)\.md$' })
    context_packet = New-Panel -Title "Context Packet" -Sources @(
        New-SourceRecord -RelativePath "docs/current/GM_CONTEXT_PACKET_DESIGN.md" -Role "context design" -Required $true
        New-SourceRecord -RelativePath "scripts/build-gm-context-packet.ps1" -Role "context helper" -Required $true
    ) -Items @($toolOutputs | Where-Object { $_.script -eq "scripts/build-gm-context-packet.ps1" })
    recent_session = New-Panel -Title "Recent Session" -Sources @($campaignSources | Where-Object { $_.path -match '/session-log\.md$' })
    durable_memory = New-Panel -Title "Durable Memory" -Sources @($campaignSources | Where-Object { $_.path -match '/(previous-sessions|relationships|hooks|npcs|factions|playtest-notes)\.md$' })
    npcs = New-Panel -Title "NPCs" -Sources @($campaignSources | Where-Object { $_.path -match '/npcs\.md$' })
    relationships = New-Panel -Title "Relationships" -Sources @($campaignSources | Where-Object { $_.path -match '/relationships\.md$' })
    hooks = New-Panel -Title "Hooks" -Sources @($campaignSources | Where-Object { $_.path -match '/hooks\.md$' })
    missions = New-Panel -Title "Missions" -Sources @($campaignSources | Where-Object { $_.path -match '/missions\.md$' })
    assets = New-Panel -Title "Assets" -Sources @(
        $campaignSources | Where-Object { $_.path -match '/assets\.md$' }
        New-SourceRecord -RelativePath "docs/current/ASSET_SHEET_SCHEMA.md" -Role "asset schema" -Required $false
    )
    mekhq_bridge = New-Panel -Title "MekHQ Bridge" -Sources @(
        if ($mekHqBridgeSource) { $mekHqBridgeSource }
        New-SourceRecord -RelativePath "docs/current/MEKHQ_BRIDGE_DATA_MODEL.md" -Role "bridge data model" -Required $false
        New-SourceRecord -RelativePath "docs/current/MEKHQ_CHECKPOINT_WARNING_SURFACING.md" -Role "warning policy" -Required $false
    ) -Items @($mekHqSummaryItem | Where-Object { $_ })
    pending_mekhq_actions = New-Panel -Title "Pending MekHQ Actions" -Sources @(
        $campaignSources | Where-Object { $_.path -match '/pending-mekhq-actions\.md$' }
        New-SourceRecord -RelativePath "docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md" -Role "pending workflow" -Required $false
        New-SourceRecord -RelativePath "scripts/validate-mekhq-pending-actions.ps1" -Role "pending validator" -Required $false
    ) -Items @($toolOutputs | Where-Object { $_.script -eq "scripts/validate-mekhq-pending-actions.ps1" }) -Warnings @(
        [pscustomobject]@{
            code = "pending-intents-not-facts"
            message = "Pending MekHQ actions are manual intents until saved MekHQ import confirms them."
        }
    )
    rules_routes = New-Panel -Title "Rules Routes" -Sources @(
        New-SourceRecord -RelativePath "indexes/task-router.md" -Role "rules router" -Required $true
        New-SourceRecord -RelativePath "indexes/page-reference-index.md" -Role "page references" -Required $true
        if ($campaignSources.Count -gt 0) { $campaignSources | Where-Object { $_.path -match '/rules-gaps\.md$' } }
    )
    tactical_handoff = New-Panel -Title "Tactical Handoff" -Sources @(
        New-SourceRecord -RelativePath "gm/tactical-encounter-handoff-checklist.md" -Role "tactical handoff checklist" -Required $false
        New-SourceRecord -RelativePath "gm/switch-to-classic-battletech.md" -Role "switch procedure" -Required $false
        New-SourceRecord -RelativePath "rules/vehicles-and-mechs/overview.md" -Role "vehicle bridge" -Required $false
    ) -Warnings @(
        [pscustomobject]@{
            code = "external-tactical-authority"
            message = "Dashboard does not resolve tactical combat; use Classic BattleTech, MegaMek, MekHQ, or table-selected tactical authority."
        }
    )
    privacy_and_boundaries = New-Panel -Title "Privacy And Boundaries" -Sources @(
        New-SourceRecord -RelativePath "docs/current/READ_ONLY_DASHBOARD_DATA_CONTRACT.md" -Role "dashboard contract" -Required $true
        New-SourceRecord -RelativePath "docs/current/MEK_RPG_PROJECT_PROFILE.md" -Role "project profile" -Required $true
    ) -Items @(
        [pscustomobject]@{
            id = "protected-source-policy"
            label = "Protected sources excluded"
            kind = "boundary"
            status = "enforced"
            excluded_paths = @("source/atow-pdf/", "source/atow-text/", "*.pdf", "*.epub", "*.cpnx", "*.cpnx.gz", "*.xml raw saves")
        }
    )
}

$report = [pscustomobject]@{
    schema_version = "dashboard-data/v1"
    generated_at = (Get-Date).ToUniversalTime().ToString("o")
    repo = [pscustomobject]@{
        root = ($script:RepoRootResolved -replace '\\', '/')
        is_dirty = $null
    }
    selection = [pscustomobject]@{
        campaign_id = $selectedCampaignId
        source = $selectionSource
        active_pointer_path = "campaign-state/active-campaign.md"
        campaign_path = $campaignRelativePath
    }
    authority = [pscustomobject]@{
        structured_campaign_files = "authoritative for MEK-RPG RPG memory"
        mekhq_bridge = "authoritative for imported hard ledger summaries when present"
        pending_mekhq_actions = "manual intents until saved MekHQ import confirms them"
        rules = "route to committed summaries and indexes; no raw source display"
        dashboard = "read-only inspection output; not a source of truth"
    }
    health = [pscustomobject]@{
        status = $healthStatus
        campaign_state = [pscustomobject]@{
            status = if (($toolOutputs | Where-Object { $_.script -eq "scripts/validate-campaign-state.ps1" }).status -contains "error") { "error" } else { "ok" }
            errors = @()
            warnings = @($script:Warnings)
            validator = "scripts/validate-campaign-state.ps1"
        }
        protected_sources = [pscustomobject]@{
            source_atow_pdf = "excluded"
            source_atow_text = "excluded"
            raw_mekhq_saves = "excluded"
        }
        missing_files = @($missingFiles)
        stale_or_conflicting_facts = @()
    }
    panels = $panels
    warnings = @($script:Warnings)
    errors = @($script:Errors)
}

$json = $report | ConvertTo-Json -Depth 20
Write-Output $json

if ($script:Errors.Count -gt 0) {
    exit 1
}

exit 0
