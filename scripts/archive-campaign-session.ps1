param(
    [Parameter(Position = 0)]
    [string]$CampaignId,

    [string]$RepoRoot,

    [switch]$UseActive,

    [switch]$ConfirmArchive,

    [switch]$ResetSessionLog,

    [string]$ArchiveTitle,

    [string]$BackupRoot,

    [switch]$WhatIf
)

$ErrorActionPreference = "Stop"

$safeCampaignIdPattern = '^[a-z0-9][a-z0-9-]*[a-z0-9]$|^[a-z0-9]$'

function Fail {
    param([string]$Message)
    Write-Error $Message
    exit 1
}

function Test-CampaignId {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $false
    }

    if ($Value -eq "_template") {
        return $false
    }

    return ($Value -match $safeCampaignIdPattern)
}

function Get-ActiveCampaignId {
    param([string]$ActivePointerPath)

    if (-not (Test-Path -LiteralPath $ActivePointerPath -PathType Leaf)) {
        Fail "Active campaign pointer missing: $ActivePointerPath"
    }

    $activeLines = @(Get-Content -LiteralPath $ActivePointerPath | Where-Object { $_ -match '^\s*Active campaign\s*:' })
    if ($activeLines.Count -eq 0) {
        Fail "Active campaign pointer has no 'Active campaign:' line."
    }

    $rawValue = ($activeLines[0] -replace '^\s*Active campaign\s*:\s*', '').Trim()
    $normalized = $rawValue.Trim([char[]]@([char]0x60, [char]0x22, [char]0x27)).Trim()

    if ($normalized -match '^(?i:none selected)$') {
        Fail "No active campaign is selected."
    }

    if ($normalized -match '^campaign-state(/|\\)' -or $normalized -eq "campaign-state") {
        Fail "Active campaign points at legacy flat campaign-state path instead of campaigns/<campaign-id>/: $normalized"
    }

    if ($normalized -match '^campaigns(/|\\)([^/\\]+)(/|\\)?$') {
        return $Matches[2]
    }

    if ($normalized -match '(/|\\)') {
        Fail "Active campaign value must be a campaign id or campaigns/<campaign-id>/: $normalized"
    }

    return $normalized
}

function New-SessionLogTemplate {
    param(
        [string]$Title,
        [string]$ArchivedAt
    )

    return @"
# Session Log

## Active Or Most Recent Session

Date: TBD

Mode: TBD

Player characters:

- TBD

## Summary

TBD

## Important Rolls

- TBD

## State Changes

- TBD

## Rewards And Costs

- TBD

## Rules Gaps

- TBD

## Next Session

- TBD

## Archive Note

Previous session-log contents were archived to `previous-sessions.md` under "$Title" at $ArchivedAt.
"@
}

$repoRootResolved = if ($RepoRoot) {
    (Resolve-Path $RepoRoot).Path
}
else {
    (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

if ($CampaignId -and $UseActive) {
    Fail "Pass either an explicit campaign id or -UseActive, not both."
}

if (-not $CampaignId -and -not $UseActive) {
    Fail "Refusing to archive without explicit intent. Pass a campaign id or -UseActive, plus -ConfirmArchive."
}

if (-not $ConfirmArchive -and -not $WhatIf) {
    Fail "Refusing to change files without -ConfirmArchive. Use -WhatIf to preview."
}

if ($UseActive) {
    $CampaignId = Get-ActiveCampaignId -ActivePointerPath (Join-Path $repoRootResolved "campaign-state\active-campaign.md")
}

if (-not (Test-CampaignId -Value $CampaignId)) {
    Fail "Invalid campaign id '$CampaignId'. Use lowercase letters, numbers, and hyphens."
}

$campaignsRoot = Join-Path $repoRootResolved "campaigns"
$campaignPath = Join-Path $campaignsRoot $CampaignId
if (-not (Test-Path -LiteralPath $campaignPath -PathType Container)) {
    Fail "Campaign folder not found: campaigns/$CampaignId"
}

$resolvedCampaignPath = (Resolve-Path $campaignPath).Path
$resolvedCampaignsRoot = (Resolve-Path $campaignsRoot).Path
if (-not $resolvedCampaignPath.StartsWith($resolvedCampaignsRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    Fail "Refusing to use campaign outside campaigns/: $CampaignId"
}

$sessionLogPath = Join-Path $campaignPath "session-log.md"
$previousSessionsPath = Join-Path $campaignPath "previous-sessions.md"

if (-not (Test-Path -LiteralPath $sessionLogPath -PathType Leaf)) {
    Fail "Missing session log: campaigns/$CampaignId/session-log.md"
}

if (-not (Test-Path -LiteralPath $previousSessionsPath -PathType Leaf)) {
    Fail "Missing previous sessions archive: campaigns/$CampaignId/previous-sessions.md"
}

$sessionText = Get-Content -LiteralPath $sessionLogPath -Raw
if ([string]::IsNullOrWhiteSpace($sessionText)) {
    Fail "Refusing to archive an empty session-log.md."
}

$archivedAt = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss zzz")
$safeTimestamp = (Get-Date).ToString("yyyyMMdd-HHmmss")
$title = if ([string]::IsNullOrWhiteSpace($ArchiveTitle)) {
    "Archived Session $safeTimestamp"
}
else {
    $ArchiveTitle.Trim()
}

$backupBase = if ($BackupRoot) {
    $BackupRoot
}
else {
    Join-Path ([System.IO.Path]::GetTempPath()) "mek-rpg-session-archive-backups"
}

$backupDir = Join-Path (Join-Path $backupBase $CampaignId) $safeTimestamp
$archiveEntry = @"

### $title

- Archived at: $archivedAt
- Source: `session-log.md`
- Mode: exact copy; no summary was generated
- Session log reset after archive: $($ResetSessionLog.IsPresent)
- Backup directory: `$backupDir`

<!-- archive-campaign-session:start $safeTimestamp -->
$sessionText
<!-- archive-campaign-session:end $safeTimestamp -->

"@

Write-Output "Campaign: $CampaignId"
Write-Output "Session log: campaigns/$CampaignId/session-log.md"
Write-Output "Archive: campaigns/$CampaignId/previous-sessions.md"
Write-Output "Archive title: $title"
Write-Output "Reset session log: $($ResetSessionLog.IsPresent)"
Write-Output "Backup directory: $backupDir"

if ($WhatIf) {
    Write-Output "WhatIf: no files changed."
    exit 0
}

New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
Copy-Item -LiteralPath $sessionLogPath -Destination (Join-Path $backupDir "session-log.md.bak") -Force
Copy-Item -LiteralPath $previousSessionsPath -Destination (Join-Path $backupDir "previous-sessions.md.bak") -Force

Add-Content -LiteralPath $previousSessionsPath -Value $archiveEntry

if ($ResetSessionLog) {
    $newSessionLog = New-SessionLogTemplate -Title $title -ArchivedAt $archivedAt
    Set-Content -LiteralPath $sessionLogPath -Value $newSessionLog -Encoding UTF8
}

Write-Output "Archived exact session-log.md contents into previous-sessions.md."
Write-Output "No summary was generated."
