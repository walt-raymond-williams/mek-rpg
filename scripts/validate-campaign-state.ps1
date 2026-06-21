param(
    [Parameter(Position = 0)]
    [string]$CampaignId,

    [switch]$StrictActive,

    [string]$RepoRoot
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

$script:ErrorCount = 0
$script:WarningCount = 0

function Write-Ok {
    param([string]$Message)
    Write-Host "OK: $Message"
}

function Write-Warn {
    param([string]$Message)
    $script:WarningCount++
    Write-Host "WARN: $Message"
}

function Write-Fail {
    param([string]$Message)
    $script:ErrorCount++
    Write-Host "FAIL: $Message"
}

function Test-CampaignId {
    param(
        [string]$Value,
        [string]$Context
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        Write-Fail "$Context campaign id is empty."
        return $false
    }

    if ($Value -eq "_template") {
        Write-Fail "$Context campaign id '_template' is reserved for the template folder."
        return $false
    }

    if ($Value -notmatch $safeCampaignIdPattern) {
        Write-Fail "$Context campaign id '$Value' must use lowercase letters, numbers, and hyphens, with no leading or trailing hyphen."
        return $false
    }

    return $true
}

function Test-StandardCampaignFiles {
    param(
        [string]$FolderPath,
        [string]$DisplayName
    )

    if (-not (Test-Path -LiteralPath $FolderPath -PathType Container)) {
        Write-Fail "$DisplayName folder not found: $FolderPath"
        return
    }

    Write-Ok "$DisplayName folder exists."

    foreach ($fileName in $standardCampaignFiles) {
        $filePath = Join-Path $FolderPath $fileName

        if (-not (Test-Path -LiteralPath $filePath -PathType Leaf)) {
            Write-Fail "$DisplayName missing standard file: $fileName"
            continue
        }

        $firstLine = Get-Content -LiteralPath $filePath -TotalCount 1 -ErrorAction Stop
        if (-not $firstLine -or $firstLine -notmatch '^#\s+\S') {
            Write-Warn "$DisplayName file has no top-level Markdown heading on the first line: $fileName"
            continue
        }

        Write-Ok "$DisplayName standard file present: $fileName"
    }
}

function Get-ActiveCampaignSelection {
    param([string]$ActivePointerPath)

    if (-not (Test-Path -LiteralPath $ActivePointerPath -PathType Leaf)) {
        Write-Fail "Active campaign pointer missing: $ActivePointerPath"
        return @{
            Status = "Missing"
            CampaignId = $null
            RawValue = $null
        }
    }

    Write-Ok "Active campaign pointer exists."

    $activeLine = Get-Content -LiteralPath $ActivePointerPath |
        Where-Object { $_ -match '^\s*Active campaign\s*:' } |
        Select-Object -First 1

    if (-not $activeLine) {
        Write-Fail "Active campaign pointer has no 'Active campaign:' line."
        return @{
            Status = "Invalid"
            CampaignId = $null
            RawValue = $null
        }
    }

    $rawValue = ($activeLine -replace '^\s*Active campaign\s*:\s*', '').Trim()
    $normalized = $rawValue.Trim('`', '"', "'").Trim()

    if ($normalized -match '^(?i:none selected)$') {
        if ($StrictActive) {
            Write-Fail "No active campaign is selected, and -StrictActive was supplied."
            return @{
                Status = "Invalid"
                CampaignId = $null
                RawValue = $rawValue
            }
        }

        Write-Ok "No active campaign selected; this is valid outside strict pre-play checks."
        return @{
            Status = "None"
            CampaignId = $null
            RawValue = $rawValue
        }
    }

    if ($normalized -match '^campaign-state(/|\\)' -or $normalized -eq "campaign-state") {
        Write-Fail "Active campaign points at legacy flat campaign-state path instead of campaigns/<campaign-id>/: $normalized"
        return @{
            Status = "Invalid"
            CampaignId = $null
            RawValue = $rawValue
        }
    }

    $campaignId = $normalized
    if ($normalized -match '^campaigns(/|\\)([^/\\]+)(/|\\)?$') {
        $campaignId = $Matches[2]
    }
    elseif ($normalized -match '(/|\\)') {
        Write-Fail "Active campaign value must be a campaign id or campaigns/<campaign-id>/: $normalized"
        return @{
            Status = "Invalid"
            CampaignId = $null
            RawValue = $rawValue
        }
    }

    if (Test-CampaignId -Value $campaignId -Context "Active") {
        Write-Ok "Active campaign id is syntactically valid: $campaignId"
        return @{
            Status = "Selected"
            CampaignId = $campaignId
            RawValue = $rawValue
        }
    }

    return @{
        Status = "Invalid"
        CampaignId = $campaignId
        RawValue = $rawValue
    }
}

$repoRoot = if ($RepoRoot) {
    (Resolve-Path $RepoRoot).Path
}
else {
    (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}
$campaignsRoot = Join-Path $repoRoot "campaigns"
$templatePath = Join-Path $campaignsRoot "_template"
$activePointerPath = Join-Path $repoRoot "campaign-state\active-campaign.md"

Write-Host "Campaign state validation"
Write-Host "Repository: $repoRoot"
Write-Host ""

if (-not (Test-Path -LiteralPath $campaignsRoot -PathType Container)) {
    Write-Fail "Campaigns folder not found: $campaignsRoot"
}
else {
    Write-Ok "Campaigns folder exists."
}

Test-StandardCampaignFiles -FolderPath $templatePath -DisplayName "Template"

$activeSelection = Get-ActiveCampaignSelection -ActivePointerPath $activePointerPath
$idsToCheck = [System.Collections.Generic.List[string]]::new()

if ($CampaignId) {
    if (Test-CampaignId -Value $CampaignId -Context "Explicit") {
        $idsToCheck.Add($CampaignId)
    }
}
elseif ($activeSelection.CampaignId) {
    $idsToCheck.Add($activeSelection.CampaignId)
}

foreach ($id in $idsToCheck) {
    $campaignPath = Join-Path $campaignsRoot $id
    $resolvedParent = $null

    if (Test-Path -LiteralPath (Split-Path -Parent $campaignPath) -PathType Container) {
        $resolvedParent = (Resolve-Path (Split-Path -Parent $campaignPath)).Path
    }

    if ($resolvedParent -and $resolvedParent -ne (Resolve-Path $campaignsRoot).Path) {
        Write-Fail "Refusing to validate campaign outside campaigns/: $id"
        continue
    }

    Test-StandardCampaignFiles -FolderPath $campaignPath -DisplayName "Campaign '$id'"
}

if ($idsToCheck.Count -eq 0 -and $activeSelection.Status -eq "None" -and -not $CampaignId) {
    Write-Warn "No campaign save folder was checked because no active campaign is selected and no -CampaignId was supplied."
}

Write-Host ""
Write-Host "Summary: $script:ErrorCount error(s), $script:WarningCount warning(s)."

if ($script:ErrorCount -gt 0) {
    exit 1
}

exit 0
