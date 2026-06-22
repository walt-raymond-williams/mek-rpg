param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$summaryFixturePath = Join-Path $repoRoot "tests\fixtures\mekhq-live-campaign-summary.fixture.json"
$stateFixturePath = Join-Path $repoRoot "tests\fixtures\mekhq-live-campaign-state.fixture.json"
$warningFixturePath = Join-Path $repoRoot "tests\fixtures\mekhq-live-campaign-warning-heavy.fixture.json"

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

function Assert-HasProperty {
    param(
        [object]$Object,
        [string]$Name,
        [string]$Message
    )

    Assert-True ($Object.PSObject.Properties.Name -contains $Name) $Message
}

function Assert-ValueEnvelope {
    param(
        [object]$Object,
        [string]$Message
    )

    Assert-HasProperty $Object "value" "$Message includes value."
    Assert-HasProperty $Object "evidence" "$Message includes evidence."
    Assert-HasProperty $Object "method_backed" "$Message includes method_backed."
    Assert-HasProperty $Object "source_owner" "$Message includes source_owner."
}

function Assert-NoLocalPathLeak {
    param(
        [string]$Text,
        [string]$Message
    )

    Assert-True ($Text -notmatch "C:\\\\Users\\\\") "$Message has no local Windows user paths."
    Assert-True ($Text -notmatch "\.cpnx") "$Message has no raw MekHQ save path."
    Assert-True ($Text -notmatch "source/atow|source\\\\atow") "$Message has no protected A Time of War source path."
}

Push-Location $repoRoot
try {
    Write-Step "Checking live API fixture presence, JSON syntax, and sanitation."
    foreach ($path in @($summaryFixturePath, $stateFixturePath, $warningFixturePath)) {
        Assert-True (Test-Path -LiteralPath $path -PathType Leaf) "Fixture exists: $([System.IO.Path]::GetFileName($path))"
    }

    $summaryHashBefore = (Get-FileHash -LiteralPath $summaryFixturePath -Algorithm SHA256).Hash
    $stateHashBefore = (Get-FileHash -LiteralPath $stateFixturePath -Algorithm SHA256).Hash
    $warningHashBefore = (Get-FileHash -LiteralPath $warningFixturePath -Algorithm SHA256).Hash

    $summaryText = Get-Content -LiteralPath $summaryFixturePath -Raw
    $stateText = Get-Content -LiteralPath $stateFixturePath -Raw
    $warningText = Get-Content -LiteralPath $warningFixturePath -Raw
    $summary = $summaryText | ConvertFrom-Json
    $state = $stateText | ConvertFrom-Json
    $warning = $warningText | ConvertFrom-Json

    Assert-NoLocalPathLeak $summaryText "Summary fixture"
    Assert-NoLocalPathLeak $stateText "State fixture"
    Assert-NoLocalPathLeak $warningText "Warning-heavy fixture"

    Write-Step "Checking summary endpoint shape and live-context metadata."
    foreach ($key in @(
        "status",
        "campaignId",
        "campaignName",
        "campaignDate",
        "mekhqVersion",
        "apiSchemaVersion",
        "apiMode",
        "readOnly",
        "currentSystem",
        "currentLocation",
        "dirtyState",
        "stateRevision",
        "snapshotId",
        "warnings",
        "unsupported"
    )) {
        Assert-HasProperty $summary $key "Summary fixture includes top-level key: $key"
    }
    Assert-True ($summary.status -eq "ready") "Summary endpoint status is ready."
    Assert-True ($summary.apiMode -eq "local-read-only-live-context") "Summary declares live read-only API mode."
    Assert-True ($summary.readOnly -eq $true) "Summary preserves readOnly true."
    Assert-ValueEnvelope $summary.dirtyState "Summary dirty state"
    Assert-True ($summary.dirtyState.value -eq "Unknown") "Summary marks dirty state as Unknown in V1."
    Assert-True ($summary.warnings.Count -ge 1) "Summary preserves dirty-state warning."
    Assert-True ($summary.unsupported.Count -ge 1) "Summary preserves unsupported entries."
    Assert-True ($summary.stateRevision -like "live-*") "Summary has a live state revision."
    Assert-True ($summary.snapshotId -eq $summary.stateRevision) "Summary snapshot id matches the state revision fixture value."

    Write-Step "Checking full state endpoint checkpoint-group shape."
    foreach ($key in @(
        "bridge_metadata",
        "campaign",
        "finances",
        "personnel",
        "units",
        "contracts",
        "scenarios",
        "repairs_and_logistics",
        "reports",
        "unsupported"
    )) {
        Assert-HasProperty $state $key "State fixture includes top-level key: $key"
    }
    Assert-True ($state.bridge_metadata.schema_name -eq "mekhq-live-campaign-state") "State fixture declares the live campaign-state schema."
    Assert-True ($state.bridge_metadata.schema_version -eq "0.1") "State fixture declares schema version 0.1."
    Assert-True ($state.bridge_metadata.producer -eq "mekhq-local-control-api") "State fixture declares the local control API producer."
    Assert-True ($state.bridge_metadata.api_mode -eq "local-read-only-live-context") "State fixture declares live-context API mode."
    Assert-True ($state.bridge_metadata.read_only -eq $true) "State fixture preserves read_only true."
    Assert-True ($state.bridge_metadata.checkpoint_id -eq "Unknown") "State fixture does not pretend to be a durable checkpoint."
    Assert-True ($state.bridge_metadata.state_revision -like "live-*") "State fixture has a live state revision."
    Assert-True ($state.bridge_metadata.snapshot_id -eq $state.bridge_metadata.state_revision) "State snapshot id matches state revision."
    Assert-ValueEnvelope $state.bridge_metadata.dirty_state "State dirty state"
    Assert-True ($state.bridge_metadata.dirty_state.value -eq "Unknown") "State fixture keeps dirty state Unknown."
    Assert-True ($state.bridge_metadata.supported_sections -contains "campaign") "State fixture lists supported campaign section."
    Assert-True ($state.bridge_metadata.supported_sections -contains "unsupported") "State fixture lists supported unsupported section."

    Write-Step "Checking representative method-backed live state values."
    Assert-ValueEnvelope $state.campaign.id "Campaign id"
    Assert-ValueEnvelope $state.campaign.name "Campaign name"
    Assert-ValueEnvelope $state.campaign.date "Campaign date"
    Assert-ValueEnvelope $state.campaign.location.current_system_id "Campaign current system id"
    Assert-ValueEnvelope $state.finances.balance "Finance balance"
    Assert-True ($state.campaign.name.value -eq "Example Live Campaign") "Campaign name sample is parsed."
    Assert-True ($state.campaign.date.method_backed -eq $true) "Campaign date is method-backed."
    Assert-True ($state.finances.balance.method_backed -eq $true) "Finance balance is method-backed."
    Assert-True ($state.finances.balance.currency -eq "C-bills") "Finance balance carries currency metadata."

    Assert-True ($state.personnel.Count -ge 1) "State fixture includes representative personnel."
    $person = $state.personnel[0]
    Assert-True ($person.display_name -eq "Example Pilot") "Personnel display name sample is parsed."
    Assert-True ($person.primary_role.method_backed -eq $true) "Personnel primary role is method-backed."
    Assert-ValueEnvelope $person.fatigue "Personnel fatigue"
    Assert-ValueEnvelope $person.hits "Personnel hits"

    Assert-True ($state.units.Count -ge 1) "State fixture includes representative units."
    $unit = $state.units[0]
    Assert-True ($unit.entity.type -eq "Mek") "Unit entity type sample is parsed."
    Assert-True ($unit.crew -contains $person.id) "Unit crew links to the representative personnel id."
    Assert-ValueEnvelope $unit.damage_state "Unit damage state"

    Assert-True ($state.reports.current.Count -ge 1) "State fixture includes sanitized current report lines."
    Assert-True ($state.reports.current[0].contains_html -eq $false) "Report line declares no HTML."
    Assert-True ($state.repairs_and_logistics.warnings.Count -ge 1) "Repair/logistics aggregate warning is preserved."

    Write-Step "Checking unsupported entries and warning-heavy blocker behavior."
    $dirtyUnsupported = $state.unsupported | Where-Object {
        $_.area -eq "bridge_metadata.dirty_state" -and $_.field -eq "unsaved_changes"
    } | Select-Object -First 1
    Assert-True ($null -ne $dirtyUnsupported) "State fixture records dirty-state unsupported entry."
    Assert-True ($dirtyUnsupported.blocks_automation -eq $false) "Dirty-state unsupported entry does not block ordinary context refresh."

    Assert-True ($warning.status -eq "ready") "Warning-heavy fixture status is ready."
    Assert-True ($warning.bridge_metadata.api_mode -eq "local-read-only-live-context") "Warning-heavy fixture declares live-context API mode."
    Assert-True ($warning.bridge_metadata.read_only -eq $true) "Warning-heavy fixture is read-only."
    Assert-ValueEnvelope $warning.bridge_metadata.dirty_state "Warning-heavy dirty state"
    Assert-True ($warning.markets.unit_offers.Count -eq 0) "Warning-heavy fixture has no unit market offers."
    Assert-True ($warning.markets.personnel_applicants.Count -eq 0) "Warning-heavy fixture has no personnel applicants."
    Assert-True ($warning.markets.contract_offers.Count -eq 0) "Warning-heavy fixture has no contract offers."
    Assert-True ($warning.markets.warnings.Count -ge 1) "Warning-heavy fixture preserves market omission warning."
    Assert-ValueEnvelope $warning.repairs_and_logistics.repair_pressure "Warning-heavy repair pressure"
    Assert-True ($warning.repairs_and_logistics.cargo.warnings.Count -ge 1) "Warning-heavy fixture preserves cargo inspection warning."
    Assert-True ($warning.unsupported.Count -ge 3) "Warning-heavy fixture preserves multiple unsupported entries."

    $marketUnsupported = $warning.unsupported | Where-Object {
        $_.area -eq "markets" -and $_.field -eq "stable_offer_selectors"
    } | Select-Object -First 1
    Assert-True ($null -ne $marketUnsupported) "Warning-heavy fixture records market selector unsupported entry."
    Assert-True ($marketUnsupported.blocks_automation -eq $true) "Market selector gap blocks automation."
    $repairUnsupported = $warning.unsupported | Where-Object {
        $_.area -eq "repairs_and_logistics" -and $_.field -eq "stable_repair_work_ids"
    } | Select-Object -First 1
    Assert-True ($null -ne $repairUnsupported) "Warning-heavy fixture records stable repair-work id unsupported entry."
    Assert-True ($repairUnsupported.blocks_automation -eq $true) "Stable repair-work id gap blocks automation."

    Write-Step "Checking read-only fixture behavior."
    $summaryHashAfter = (Get-FileHash -LiteralPath $summaryFixturePath -Algorithm SHA256).Hash
    $stateHashAfter = (Get-FileHash -LiteralPath $stateFixturePath -Algorithm SHA256).Hash
    $warningHashAfter = (Get-FileHash -LiteralPath $warningFixturePath -Algorithm SHA256).Hash
    Assert-True ($summaryHashBefore -eq $summaryHashAfter) "Summary fixture hash is unchanged after parsing."
    Assert-True ($stateHashBefore -eq $stateHashAfter) "State fixture hash is unchanged after parsing."
    Assert-True ($warningHashBefore -eq $warningHashAfter) "Warning-heavy fixture hash is unchanged after parsing."
}
finally {
    Pop-Location
}

Write-Host ""
Write-Host "MekHQ live API fixture tests passed."
