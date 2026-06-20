param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$CampaignId
)

$ErrorActionPreference = "Stop"

if ($CampaignId -notmatch '^[a-z0-9][a-z0-9-]*[a-z0-9]$|^[a-z0-9]$') {
    Write-Error "Campaign id must use lowercase letters, numbers, and hyphens, with no leading or trailing hyphen."
}

if ($CampaignId -eq "_template") {
    Write-Error "Campaign id '_template' is reserved."
}

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$campaignsRoot = (Resolve-Path (Join-Path $repoRoot "campaigns")).Path
$templatePath = Join-Path $campaignsRoot "_template"

if (-not (Test-Path -LiteralPath $templatePath -PathType Container)) {
    Write-Error "Template folder not found: $templatePath"
}

$targetPath = Join-Path $campaignsRoot $CampaignId
$resolvedParent = (Resolve-Path (Split-Path -Parent $targetPath)).Path

if ($resolvedParent -ne $campaignsRoot) {
    Write-Error "Refusing to create a campaign outside $campaignsRoot"
}

if (Test-Path -LiteralPath $targetPath) {
    Write-Error "Campaign already exists: $targetPath"
}

Copy-Item -LiteralPath $templatePath -Destination $targetPath -Recurse

Write-Output "Created campaign save: campaigns/$CampaignId/"
Write-Output "Review campaign-state/active-campaign.md before play; this script does not change the active campaign pointer."
