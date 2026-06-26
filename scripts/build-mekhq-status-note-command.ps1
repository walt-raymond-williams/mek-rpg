param(
    [string]$StatusJson,
    [string]$CommandReadinessJson,
    [string]$OutputFile,
    [string]$ExpectedCampaignId,
    [string]$ExpectedCampaignName,
    [string]$ExpectedDate,
    [string]$ExpectedStateRevision,
    [string]$NoteText = "MEK-RPG guarded command smoke dry-run.",
    [string]$IdempotencyKey,
    [string]$Actor = "mek-rpg",
    [string]$SceneId = "mek-rpg-command-smoke",
    [string]$ActionId,
    [string]$Reason = "Validate campaign.status_note guarded command envelope from MEK-RPG.",
    [string]$ClientContextJson,
    [string]$ApiBaseUrl = "http://127.0.0.1:32180",
    [switch]$InvokeDryRun
)

$ErrorActionPreference = "Stop"

function Read-JsonFile {
    param([string]$Path)

    if ([string]::IsNullOrWhiteSpace($Path)) {
        return $null
    }
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) {
        throw "JSON file not found: $Path"
    }

    return (Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json)
}

function Get-PropertyValue {
    param(
        [object]$Object,
        [string[]]$Paths
    )

    foreach ($path in $Paths) {
        $current = $Object
        $found = $true
        foreach ($part in ($path -split "\.")) {
            if ($null -eq $current -or -not ($current.PSObject.Properties.Name -contains $part)) {
                $found = $false
                break
            }
            $current = $current.$part
        }

        if ($found -and $null -ne $current) {
            if ($current.PSObject.Properties.Name -contains "value") {
                $current = $current.value
            }
            if (-not [string]::IsNullOrWhiteSpace([string]$current)) {
                return [string]$current
            }
        }
    }

    return $null
}

function Require-NonBlank {
    param(
        [string]$Value,
        [string]$Name
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        throw "Missing required value: $Name"
    }
}

function Test-ExactClientContext {
    param([object]$Context)

    if ($null -eq $Context -or $Context -is [string]) {
        throw "clientContext must be a structured JSON object, not a string."
    }

    $required = @("actor", "sceneId", "actionId", "reason")
    $names = @($Context.PSObject.Properties.Name)
    foreach ($name in $required) {
        if ($names -notcontains $name) {
            throw "clientContext missing required field: $name"
        }
        if ([string]::IsNullOrWhiteSpace([string]$Context.$name)) {
            throw "clientContext field must be non-empty: $name"
        }
    }

    $extra = @($names | Where-Object { $required -notcontains $_ })
    if ($extra.Count -gt 0) {
        throw "clientContext has unsupported field(s): $($extra -join ', ')"
    }
}

function Confirm-StatusNoteReadiness {
    param([object]$Commands)

    if ($null -eq $Commands) {
        return
    }

    if (($Commands.PSObject.Properties.Name -contains "read_only") -and $Commands.read_only -ne $true) {
        throw "Command-readiness JSON must be read_only=true."
    }

    $row = @($Commands.command_readiness | Where-Object { $_.command -eq "campaign.status_note" } | Select-Object -First 1)
    if ($row.Count -eq 0) {
        throw "Command-readiness JSON does not include campaign.status_note."
    }

    $statusNote = $row[0]
    if ($statusNote.status -ne "available") {
        throw "campaign.status_note is not available in command-readiness JSON: $($statusNote.status)"
    }
    if ($statusNote.endpoint -ne "/campaign/command/status-note") {
        throw "campaign.status_note readiness row has unexpected endpoint: $($statusNote.endpoint)"
    }
    if ($statusNote.dry_run_supported -ne $true) {
        throw "campaign.status_note readiness row does not report dry-run support."
    }
    if ($statusNote.requires_command_envelope -ne $true) {
        throw "campaign.status_note readiness row does not require the guarded command envelope."
    }
}

$status = Read-JsonFile $StatusJson
$commands = Read-JsonFile $CommandReadinessJson
Confirm-StatusNoteReadiness $commands

if ([string]::IsNullOrWhiteSpace($ExpectedCampaignId)) {
    $ExpectedCampaignId = Get-PropertyValue $status @("campaignId", "campaign.id", "campaign.id.value")
}
if ([string]::IsNullOrWhiteSpace($ExpectedCampaignName)) {
    $ExpectedCampaignName = Get-PropertyValue $status @("campaignName", "campaign.name", "campaign.name.value")
}
if ([string]::IsNullOrWhiteSpace($ExpectedDate)) {
    $ExpectedDate = Get-PropertyValue $status @("campaignDate", "campaign.date", "campaign.date.value")
}
if ([string]::IsNullOrWhiteSpace($ExpectedStateRevision)) {
    $ExpectedStateRevision = Get-PropertyValue $status @("stateRevision", "state_revision", "snapshotId", "bridge_metadata.state_revision", "bridge_metadata.snapshot_id")
}

if ($commands) {
    if ([string]::IsNullOrWhiteSpace($ExpectedCampaignId)) {
        $ExpectedCampaignId = Get-PropertyValue $commands @("campaign.id", "selectors.campaign.id")
    }
    if ([string]::IsNullOrWhiteSpace($ExpectedCampaignName)) {
        $ExpectedCampaignName = Get-PropertyValue $commands @("campaign.name", "selectors.campaign.name")
    }
    if ([string]::IsNullOrWhiteSpace($ExpectedDate)) {
        $ExpectedDate = Get-PropertyValue $commands @("campaign.date", "selectors.campaign.date")
    }
    if ([string]::IsNullOrWhiteSpace($ExpectedStateRevision)) {
        $ExpectedStateRevision = Get-PropertyValue $commands @("state_revision", "stateRevision")
    }
}

if ([string]::IsNullOrWhiteSpace($ActionId)) {
    $ActionId = "status-note-smoke-$([Guid]::NewGuid().ToString('N'))"
}
if ([string]::IsNullOrWhiteSpace($IdempotencyKey)) {
    $IdempotencyKey = "mek-rpg-status-note-dry-run-$([Guid]::NewGuid().ToString('N'))"
}

if (-not [string]::IsNullOrWhiteSpace($ClientContextJson)) {
    $clientContextJsonText = $ClientContextJson
    if (Test-Path -LiteralPath $ClientContextJson -PathType Leaf) {
        $clientContextJsonText = Get-Content -LiteralPath $ClientContextJson -Raw
    }
    try {
        $clientContext = $clientContextJsonText | ConvertFrom-Json
    }
    catch {
        throw "clientContext must be valid JSON: $($_.Exception.Message)"
    }
}
else {
    $clientContext = [pscustomobject][ordered]@{
        actor = $Actor
        sceneId = $SceneId
        actionId = $ActionId
        reason = $Reason
    }
}

Require-NonBlank $NoteText "NoteText"
Require-NonBlank $IdempotencyKey "IdempotencyKey"
Require-NonBlank $ExpectedDate "ExpectedDate"
if ([string]::IsNullOrWhiteSpace($ExpectedCampaignId) -and [string]::IsNullOrWhiteSpace($ExpectedCampaignName)) {
    throw "At least one campaign identity guard is required: ExpectedCampaignId or ExpectedCampaignName."
}
if ($ExpectedDate -notmatch "^\d{4}-\d{2}-\d{2}$") {
    throw "ExpectedDate must use yyyy-MM-dd format."
}
if ($IdempotencyKey -match "\s") {
    throw "IdempotencyKey must not contain whitespace."
}
Test-ExactClientContext $clientContext

$request = [ordered]@{
    command = "campaign.status_note"
    commandVersion = 1
    idempotencyKey = $IdempotencyKey
    expectedCampaignId = if ([string]::IsNullOrWhiteSpace($ExpectedCampaignId)) { $null } else { $ExpectedCampaignId }
    expectedCampaignName = if ([string]::IsNullOrWhiteSpace($ExpectedCampaignName)) { $null } else { $ExpectedCampaignName }
    expectedDate = $ExpectedDate
    expectedStateRevision = if ([string]::IsNullOrWhiteSpace($ExpectedStateRevision)) { $null } else { $ExpectedStateRevision }
    noteText = $NoteText
    dryRun = $true
    promptPolicy = "refuse_if_prompt"
    saveAfterSuccess = $false
    savePath = $null
    clientContext = $clientContext
}

$json = $request | ConvertTo-Json -Depth 12

if (-not [string]::IsNullOrWhiteSpace($OutputFile)) {
    $fullOutputPath = [System.IO.Path]::GetFullPath($OutputFile)
    $outputDirectory = [System.IO.Path]::GetDirectoryName($fullOutputPath)
    if (-not [string]::IsNullOrWhiteSpace($outputDirectory) -and -not (Test-Path -LiteralPath $outputDirectory)) {
        New-Item -ItemType Directory -Path $outputDirectory | Out-Null
    }
    [System.IO.File]::WriteAllText($fullOutputPath, $json + [Environment]::NewLine, [System.Text.UTF8Encoding]::new($false))
}

if ($InvokeDryRun) {
    if ([string]::IsNullOrWhiteSpace($OutputFile)) {
        throw "InvokeDryRun requires OutputFile so the exact UTF-8 request body is auditable."
    }

    $uri = ($ApiBaseUrl.TrimEnd("/") + "/campaign/command/status-note")
    Invoke-RestMethod -Method Post -Uri $uri -InFile $fullOutputPath -ContentType "application/json; charset=utf-8" -TimeoutSec 30
}
else {
    $json
}
