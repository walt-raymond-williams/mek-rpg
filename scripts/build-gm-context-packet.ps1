param(
    [Parameter(Position = 0)]
    [string]$CampaignId,

    [string]$RepoRoot,

    [switch]$RunValidators
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

$script:Warnings = [System.Collections.Generic.List[string]]::new()
$script:Errors = [System.Collections.Generic.List[string]]::new()

function Add-Warning {
    param([string]$Message)
    $script:Warnings.Add($Message)
}

function Add-Error {
    param([string]$Message)
    $script:Errors.Add($Message)
}

function Format-RelativePath {
    param([string]$Path)

    if (-not $Path) {
        return "None"
    }

    $resolved = $Path
    if (Test-Path -LiteralPath $Path) {
        $resolved = (Resolve-Path $Path).Path
    }

    if ($resolved.StartsWith($script:RepoRootResolved, [System.StringComparison]::OrdinalIgnoreCase)) {
        return ($resolved.Substring($script:RepoRootResolved.Length).TrimStart('\', '/') -replace '\\', '/')
    }

    return $Path
}

function Get-SourceStatus {
    param(
        [string]$RelativePath,
        [switch]$Required
    )

    $fullPath = Join-Path $script:RepoRootResolved $RelativePath
    if (Test-Path -LiteralPath $fullPath -PathType Leaf) {
        return "OK"
    }

    $message = "Missing source file: $RelativePath"
    if ($Required) {
        Add-Warning $message
    }

    return "MISSING"
}

function Write-SourceLine {
    param(
        [string]$Role,
        [string]$RelativePath,
        [switch]$Required
    )

    $status = Get-SourceStatus -RelativePath $RelativePath -Required:$Required
    Write-Output ("- {0}: ``{1}`` [{2}]" -f $Role, $RelativePath, $status)
}

function Test-CampaignId {
    param(
        [string]$Value,
        [string]$Context
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        Add-Error "$Context campaign id is empty."
        return $false
    }

    if ($Value -eq "_template") {
        Add-Error "$Context campaign id '_template' is reserved for the template folder."
        return $false
    }

    if ($Value -notmatch $safeCampaignIdPattern) {
        Add-Error "$Context campaign id '$Value' must use lowercase letters, numbers, and hyphens, with no leading or trailing hyphen."
        return $false
    }

    return $true
}

function Get-ActiveCampaignSelection {
    param([string]$ActivePointerPath)

    if (-not (Test-Path -LiteralPath $ActivePointerPath -PathType Leaf)) {
        Add-Error "Active campaign pointer missing: $(Format-RelativePath $ActivePointerPath)"
        return @{
            Status = "Missing"
            CampaignId = $null
            RawValue = $null
        }
    }

    $activeLines = @(Get-Content -LiteralPath $ActivePointerPath | Where-Object { $_ -match '^\s*Active campaign\s*:' })
    if ($activeLines.Count -eq 0) {
        Add-Error "Active campaign pointer has no 'Active campaign:' line."
        return @{
            Status = "Invalid"
            CampaignId = $null
            RawValue = $null
        }
    }

    if ($activeLines.Count -gt 1) {
        Add-Warning "Active campaign pointer has multiple 'Active campaign:' lines; using the first."
    }

    $rawValue = ($activeLines[0] -replace '^\s*Active campaign\s*:\s*', '').Trim()
    $normalized = $rawValue.Trim([char[]]@([char]0x60, [char]0x22, [char]0x27)).Trim()

    if ($normalized -match '^(?i:none selected)$') {
        return @{
            Status = "None"
            CampaignId = $null
            RawValue = $rawValue
        }
    }

    if ($normalized -match '^campaign-state(/|\\)' -or $normalized -eq "campaign-state") {
        Add-Error "Active campaign points at legacy flat campaign-state path instead of campaigns/<campaign-id>/: $normalized"
        return @{
            Status = "Invalid"
            CampaignId = $null
            RawValue = $rawValue
        }
    }

    $selectedId = $normalized
    if ($normalized -match '^campaigns(/|\\)([^/\\]+)(/|\\)?$') {
        $selectedId = $Matches[2]
    }
    elseif ($normalized -match '(/|\\)') {
        Add-Error "Active campaign value must be a campaign id or campaigns/<campaign-id>/: $normalized"
        return @{
            Status = "Invalid"
            CampaignId = $null
            RawValue = $rawValue
        }
    }

    if (Test-CampaignId -Value $selectedId -Context "Active") {
        return @{
            Status = "Selected"
            CampaignId = $selectedId
            RawValue = $rawValue
        }
    }

    return @{
        Status = "Invalid"
        CampaignId = $selectedId
        RawValue = $rawValue
    }
}

function Get-FirstHeading {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        return "Missing"
    }

    $heading = Get-Content -LiteralPath $Path |
        Where-Object { $_ -match '^\s*#+' } |
        Select-Object -First 1

    if (-not $heading) {
        return "No heading found"
    }

    return ($heading -replace '^\s*#+\s*', '').Trim()
}

function Write-SectionHeader {
    param([string]$Title)
    Write-Output ""
    Write-Output "## $Title"
}

$script:RepoRootResolved = if ($RepoRoot) {
    (Resolve-Path $RepoRoot).Path
}
else {
    (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

$campaignsRoot = Join-Path $script:RepoRootResolved "campaigns"
$activePointerPath = Join-Path $script:RepoRootResolved "campaign-state\active-campaign.md"
$activeSelection = Get-ActiveCampaignSelection -ActivePointerPath $activePointerPath
$selectedCampaignId = $null

if ($CampaignId) {
    if (Test-CampaignId -Value $CampaignId -Context "Explicit") {
        $selectedCampaignId = $CampaignId
        if ($activeSelection.CampaignId -and $activeSelection.CampaignId -ne $CampaignId) {
            Add-Warning "Explicit campaign id '$CampaignId' overrides active pointer value '$($activeSelection.CampaignId)'."
        }
    }
}
elseif ($activeSelection.CampaignId) {
    $selectedCampaignId = $activeSelection.CampaignId
}
else {
    Add-Error "No campaign selected. Set campaign-state/active-campaign.md or pass a campaign id."
}

$campaignPath = $null
$campaignRelativePath = $null
if ($selectedCampaignId) {
    $campaignPath = Join-Path $campaignsRoot $selectedCampaignId
    $campaignRelativePath = "campaigns/$selectedCampaignId"

    if (-not (Test-Path -LiteralPath $campaignPath -PathType Container)) {
        Add-Error "Campaign folder not found: $campaignRelativePath"
    }
    else {
        $resolvedCampaignPath = (Resolve-Path $campaignPath).Path
        $resolvedCampaignsRoot = (Resolve-Path $campaignsRoot).Path
        if (-not $resolvedCampaignPath.StartsWith($resolvedCampaignsRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            Add-Error "Refusing to use campaign outside campaigns/: $selectedCampaignId"
        }
    }
}

if ($campaignPath -and (Test-Path -LiteralPath $campaignPath -PathType Container)) {
    foreach ($fileName in $standardCampaignFiles) {
        $filePath = Join-Path $campaignPath $fileName
        if (-not (Test-Path -LiteralPath $filePath -PathType Leaf)) {
            Add-Warning "Campaign '$selectedCampaignId' missing standard file: $fileName"
        }
    }
}

$hasMekHqBridge = $false
if ($campaignPath) {
    $hasMekHqBridge = Test-Path -LiteralPath (Join-Path $campaignPath "mekhq-bridge.md") -PathType Leaf
}

Write-Output "# GM Context Packet"
Write-Output ""
Write-Output "This is a deterministic source report. It packages context inputs only; it does not interpret rules, invent campaign facts, summarize scenes, advance time, or apply MekHQ changes."

Write-SectionHeader "Request And Mode"
Write-SourceLine "Agent instructions" "AGENTS.md" -Required
Write-SourceLine "Project workflow" "docs/current/AI_READY_PROJECT_WORKFLOW.md" -Required
Write-SourceLine "Project profile" "docs/current/MEK_RPG_PROJECT_PROFILE.md" -Required
Write-SourceLine "Context packet design" "docs/current/GM_CONTEXT_PACKET_DESIGN.md" -Required
Write-SourceLine "Memory strategy" "docs/current/CAMPAIGN_MEMORY_STRATEGY.md" -Required
Write-SourceLine "Play procedure" "gm/session-procedure.md" -Required

Write-SectionHeader "Active Campaign"
$activePointerStatus = Get-SourceStatus -RelativePath "campaign-state/active-campaign.md" -Required
Write-Output ("- Active pointer: ``{0}`` [{1}]" -f "campaign-state/active-campaign.md", $activePointerStatus)
Write-Output "- Active pointer value: $($activeSelection.RawValue)"
Write-Output "- Active pointer status: $($activeSelection.Status)"
Write-Output "- Selected campaign id: $selectedCampaignId"
Write-Output ("- Save folder: ``{0}``" -f $campaignRelativePath)
if ($campaignPath) {
    $overviewHeading = Get-FirstHeading (Join-Path $campaignPath "overview.md")
    Write-Output "- Overview heading: $overviewHeading"
}

Write-SectionHeader "Authority Notes"
Write-Output "- Structured campaign files override stale narrative summaries."
Write-Output "- Rules answers must start at committed summaries and indexes, not model memory or raw source text."
Write-Output "- Pending MekHQ actions are command proposals, command results, or manual fallback checklists until live reread or saved import confirms them."
Write-Output "- This helper never reads source/atow-pdf/, source/atow-text/, or raw MekHQ save payloads."

Write-SectionHeader "Current Scene State"
if ($campaignRelativePath) {
    Write-SourceLine "Resume point" "$campaignRelativePath/current-state.md" -Required
    Write-SourceLine "Campaign overview" "$campaignRelativePath/overview.md" -Required
    Write-SourceLine "Player characters" "$campaignRelativePath/pcs.md" -Required
    Write-SourceLine "Important NPCs" "$campaignRelativePath/npcs.md" -Required
    Write-SourceLine "Factions" "$campaignRelativePath/factions.md" -Required
    Write-SourceLine "Locations" "$campaignRelativePath/locations.md" -Required
    Write-SourceLine "Assets" "$campaignRelativePath/assets.md" -Required
    Write-SourceLine "Missions" "$campaignRelativePath/missions.md" -Required
    Write-SourceLine "Safety and tone" "$campaignRelativePath/safety-and-tone.md" -Required
}

Write-SectionHeader "MekHQ Bridge And Pending Intents"
if ($campaignRelativePath) {
    Write-SourceLine "MekHQ bridge metadata" "$campaignRelativePath/mekhq-bridge.md"
    Write-SourceLine "Pending MekHQ intents" "$campaignRelativePath/pending-mekhq-actions.md" -Required
}
if (-not $hasMekHqBridge) {
    Write-Output "- MekHQ link status: No mekhq-bridge.md found; treat this as not MekHQ-linked unless campaign notes say otherwise."
}
else {
    Write-SourceLine "MekHQ bridge data model" "docs/current/MEKHQ_BRIDGE_DATA_MODEL.md" -Required
    Write-SourceLine "MekHQ linked play loop" "docs/current/MEKHQ_LINKED_PLAY_LOOP.md" -Required
    Write-SourceLine "Pending application workflow" "docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md" -Required
    Write-SourceLine "Checkpoint warning surfacing policy" "docs/current/MEKHQ_CHECKPOINT_WARNING_SURFACING.md" -Required
}

Write-SectionHeader "Rules Routes"
Write-SourceLine "Task router" "indexes/task-router.md" -Required
Write-SourceLine "Page reference index" "indexes/page-reference-index.md" -Required
Write-SourceLine "Tactical handoff procedure" "gm/switch-to-classic-battletech.md"
Write-SourceLine "Vehicle and tactical bridge overview" "rules/vehicles-and-mechs/overview.md"
if ($campaignRelativePath) {
    Write-SourceLine "Campaign rules gaps" "$campaignRelativePath/rules-gaps.md" -Required
}

Write-SectionHeader "Recent Events"
if ($campaignRelativePath) {
    Write-SourceLine "Active session log" "$campaignRelativePath/session-log.md" -Required
    Write-SourceLine "Current state resume pointer" "$campaignRelativePath/current-state.md" -Required
}

Write-SectionHeader "Durable Memory"
if ($campaignRelativePath) {
    Write-SourceLine "Completed session archive" "$campaignRelativePath/previous-sessions.md" -Required
    Write-SourceLine "Relationships" "$campaignRelativePath/relationships.md" -Required
    Write-SourceLine "Hooks" "$campaignRelativePath/hooks.md" -Required
    Write-SourceLine "NPC memory" "$campaignRelativePath/npcs.md" -Required
    Write-SourceLine "Faction posture" "$campaignRelativePath/factions.md" -Required
    Write-SourceLine "Playtest notes" "$campaignRelativePath/playtest-notes.md" -Required
}

if ($RunValidators) {
    Write-SectionHeader "Validator Output"
    $campaignValidatorPath = Join-Path $script:RepoRootResolved "scripts\validate-campaign-state.ps1"
    if (Test-Path -LiteralPath $campaignValidatorPath -PathType Leaf) {
        Write-Output "### Campaign State Validator"
        $validatorOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $campaignValidatorPath -RepoRoot $script:RepoRootResolved -CampaignId $selectedCampaignId 2>&1
        $validatorExitCode = $LASTEXITCODE
        $validatorOutput | ForEach-Object { Write-Output $_ }
        if ($validatorExitCode -ne 0) {
            Add-Warning "Campaign state validator exited with code $validatorExitCode."
        }
    }

    if ($campaignRelativePath) {
        $pendingValidatorPath = Join-Path $script:RepoRootResolved "scripts\validate-mekhq-pending-actions.ps1"
        $pendingPath = Join-Path $campaignPath "pending-mekhq-actions.md"
        if ((Test-Path -LiteralPath $pendingValidatorPath -PathType Leaf) -and (Test-Path -LiteralPath $pendingPath -PathType Leaf)) {
            Write-Output ""
            Write-Output "### Pending MekHQ Action Validator"
            $pendingOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $pendingValidatorPath $pendingPath -ReportUnresolved 2>&1
            $pendingExitCode = $LASTEXITCODE
            $pendingOutput | ForEach-Object { Write-Output $_ }
            if ($pendingExitCode -ne 0) {
                Add-Warning "Pending MekHQ action validator exited with code $pendingExitCode."
            }
        }
    }
}

Write-SectionHeader "Warnings"
if ($script:Warnings.Count -eq 0) {
    Write-Output "- None."
}
else {
    foreach ($warning in $script:Warnings) {
        Write-Output "- WARN: $warning"
    }
}

if ($script:Errors.Count -gt 0) {
    Write-Output ""
    Write-Output "## Errors"
    foreach ($errorMessage in $script:Errors) {
        Write-Output "- FAIL: $errorMessage"
    }
    exit 1
}

exit 0
