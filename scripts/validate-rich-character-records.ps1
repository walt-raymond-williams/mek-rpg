param(
    [Parameter(Position = 0)]
    [string]$CampaignId,

    [switch]$Template,

    [string]$RepoRoot
)

$ErrorActionPreference = "Stop"

$script:ErrorCount = 0
$script:WarningCount = 0

$safeCampaignIdPattern = '^[a-z0-9][a-z0-9-]*[a-z0-9]$|^[a-z0-9]$'
$allowedEvidenceLabels = @(
    "Confirmed by user",
    "Confirmed from summary",
    "Confirmed from source reference",
    "Confirmed from MekHQ import",
    "Confirmed in play",
    "Inferred",
    "Unknown",
    "Needs source lookup",
    "Needs user decision",
    "Needs GM ruling"
)
$allowedVisibilityLabels = @("player-known", "GM-only", "mixed")
$legacyUnresolvedMarkers = @("Needs lookup", "Needs user confirmation")
$protectedPatterns = @(
    "source/atow-pdf",
    "source\atow-pdf",
    "source/atow-text",
    "source\atow-text",
    ".cpnx",
    ".cpnx.gz",
    "raw extracted source text",
    "raw MekHQ save"
)

$requiredPcTokens = @(
    "## Character Template",
    "#### Header And Evidence",
    "#### Identity And Concept",
    "#### Sheet Status",
    "#### Attributes",
    "#### Traits",
    "#### Skills",
    "#### Combat And Readiness",
    "#### Inventory And Assets",
    "#### Biography And Memory",
    "#### Relationships And Obligations",
    "#### Secrets, Uncertainty, And Visibility",
    "#### Speech, Behavior, And Portrayal",
    "#### Update History",
    "## MekHQ-Linked PC Template",
    "#### Link And Evidence",
    "#### MekHQ-Owned Roster Facts",
    "#### MEK-RPG A Time Of War Overlay",
    "#### RPG Memory",
    "#### Visibility And Uncertainty",
    "#### Import Refresh Notes"
)

$requiredNpcTokens = @(
    "## NPC Template",
    "#### Header And Evidence",
    "#### Identity And Role",
    "#### Motives And Memory",
    "#### Relationships And Obligations",
    "#### Secrets, Uncertainty, And Visibility",
    "#### Sheet And Rules Gaps",
    "#### Speech, Behavior, And Portrayal",
    "#### Update History",
    "## MekHQ-Linked NPC Template",
    "#### Link And Evidence",
    "#### MekHQ-Owned Roster Facts",
    "#### MEK-RPG NPC Overlay",
    "#### Import Refresh Notes"
)

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
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        Write-Fail "Campaign id is empty."
        return $false
    }

    if ($Value -eq "_template") {
        Write-Fail "Use -Template instead of campaign id '_template'."
        return $false
    }

    if ($Value -notmatch $safeCampaignIdPattern) {
        Write-Fail "Campaign id '$Value' must use lowercase letters, numbers, and hyphens, with no leading or trailing hyphen."
        return $false
    }

    return $true
}

function Test-RequiredTokens {
    param(
        [string]$Content,
        [string[]]$Tokens,
        [string]$DisplayName
    )

    foreach ($token in $Tokens) {
        if (-not $Content.Contains($token)) {
            Write-Fail "$DisplayName missing required rich character section or marker: $token"
        }
    }
}

function Test-ProtectedPatterns {
    param(
        [string]$Content,
        [string]$DisplayName
    )

    foreach ($pattern in $protectedPatterns) {
        if ($Content.IndexOf($pattern, [System.StringComparison]::OrdinalIgnoreCase) -ge 0) {
            Write-Fail "$DisplayName contains protected-source or raw-save marker: $pattern"
        }
    }
}

function Test-UnresolvedMarkers {
    param(
        [string]$Content,
        [string]$DisplayName
    )

    foreach ($marker in $legacyUnresolvedMarkers) {
        if ($Content.IndexOf($marker, [System.StringComparison]::OrdinalIgnoreCase) -ge 0) {
            Write-Warn "$DisplayName uses legacy unresolved marker '$marker'. Prefer schema labels such as 'Needs source lookup' or 'Needs user decision'."
        }
    }
}

function Test-LabelLines {
    param(
        [string[]]$Lines,
        [string]$DisplayName
    )

    foreach ($line in $Lines) {
        if ($line -match '^\s*-\s*(Import evidence|Evidence label):\s*(.+?)\s*$') {
            $value = $Matches[2].Trim()
            if ($value -and ($allowedEvidenceLabels -notcontains $value)) {
                Write-Fail "$DisplayName has unsupported evidence label '$value'."
            }
        }

        if ($line -match '^\s*-\s*Player-facing visibility:\s*(.+?)\s*$') {
            $value = $Matches[1].Trim()
            if ($value -and ($allowedVisibilityLabels -notcontains $value)) {
                Write-Fail "$DisplayName has unsupported visibility label '$value'."
            }
        }
    }
}

function Test-CharacterFile {
    param(
        [string]$FilePath,
        [string[]]$RequiredTokens,
        [string]$DisplayName
    )

    if (-not (Test-Path -LiteralPath $FilePath -PathType Leaf)) {
        Write-Fail "$DisplayName file not found: $FilePath"
        return
    }

    $lines = Get-Content -LiteralPath $FilePath
    $content = $lines -join "`n"

    Write-Ok "$DisplayName file exists."
    Test-RequiredTokens -Content $content -Tokens $RequiredTokens -DisplayName $DisplayName
    Test-ProtectedPatterns -Content $content -DisplayName $DisplayName
    Test-UnresolvedMarkers -Content $content -DisplayName $DisplayName
    Test-LabelLines -Lines $lines -DisplayName $DisplayName
}

$repoRoot = if ($RepoRoot) {
    (Resolve-Path $RepoRoot).Path
}
else {
    (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

if ($Template -and $CampaignId) {
    Write-Fail "Use either -Template or a campaign id, not both."
}

$campaignsRoot = Join-Path $repoRoot "campaigns"
$targetId = $null
$targetPath = $null

if ($CampaignId) {
    if (Test-CampaignId -Value $CampaignId) {
        $targetId = $CampaignId
        $targetPath = Join-Path $campaignsRoot $CampaignId
    }
}
else {
    $targetId = "_template"
    $targetPath = Join-Path $campaignsRoot "_template"
}

Write-Host "Rich character record validation"
Write-Host "Repository: $repoRoot"
Write-Host "Target: $targetId"
Write-Host ""

if ($targetPath) {
    if (-not (Test-Path -LiteralPath $targetPath -PathType Container)) {
        Write-Fail "Target campaign/template folder not found: $targetPath"
    }
    else {
        Write-Ok "Target folder exists."
        Test-CharacterFile -FilePath (Join-Path $targetPath "pcs.md") -RequiredTokens $requiredPcTokens -DisplayName "$targetId pcs.md"
        Test-CharacterFile -FilePath (Join-Path $targetPath "npcs.md") -RequiredTokens $requiredNpcTokens -DisplayName "$targetId npcs.md"
    }
}

Write-Host ""
Write-Host "Summary: $script:ErrorCount error(s), $script:WarningCount warning(s)."

if ($script:ErrorCount -gt 0) {
    exit 1
}

exit 0
