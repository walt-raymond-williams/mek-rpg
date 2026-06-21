param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$fixturePath = Join-Path $repoRoot "tests\fixtures\mekhq-read-only-checkpoint.prototype-output.fixture.json"

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

Push-Location $repoRoot
try {
    Write-Step "Checking prototype-output fixture presence and JSON syntax."
    Assert-True (Test-Path -LiteralPath $fixturePath -PathType Leaf) "Prototype-output fixture is present."
    $fixtureHashBefore = (Get-FileHash -LiteralPath $fixturePath -Algorithm SHA256).Hash
    $fixtureText = Get-Content -LiteralPath $fixturePath -Raw
    $fixture = $fixtureText | ConvertFrom-Json

    Write-Step "Checking prototype metadata and experimental boundary."
    Assert-True ($fixture.bridge_metadata.schema_name -eq "mekhq-read-only-checkpoint") "Fixture declares the checkpoint schema name."
    Assert-True ($fixture.bridge_metadata.schema_version -eq "0.1") "Fixture declares the expected draft schema version."
    Assert-True ($fixture.bridge_metadata.producer -eq "workspace-jar-backed-prototype") "Fixture preserves the prototype producer."
    Assert-True ($fixture.bridge_metadata.read_only -eq $true) "Prototype fixture preserves read_only true."
    Assert-True ($fixture.bridge_metadata.input_path -like "SANITIZED:*") "Prototype fixture input path is sanitized."
    Assert-True ($fixture.bridge_metadata.warnings -contains "Prototype exporter; validate before production use.") "Prototype warning is preserved."
    Assert-True ($fixture.bridge_metadata.warnings.Count -ge 2) "Prototype classpath/initialization warning is preserved."
    Assert-True ($fixture.bridge_metadata.evidence -eq "Confirmed from MekHQ export") "Prototype fixture preserves export evidence label."
    Assert-True ($fixtureText -notmatch "C:\\\\Users\\\\") "Fixture does not include local Windows user paths."
    Assert-True ($fixtureText -notmatch "analysis\\\\tmp") "Fixture does not include scratch analysis paths."

    Write-Step "Checking observed disposable-save counts without requiring the full raw output."
    Assert-True ($fixture.bridge_metadata.prototype_observed_counts.personnel -eq 106) "Observed personnel count is preserved."
    Assert-True ($fixture.bridge_metadata.prototype_observed_counts.units -eq 27) "Observed unit count is preserved."
    Assert-True ($fixture.bridge_metadata.prototype_observed_counts.contracts -eq 1) "Observed contract count is preserved."
    Assert-True ($fixture.bridge_metadata.prototype_observed_counts.scenarios -eq 2) "Observed scenario count is preserved."
    Assert-True ($fixture.bridge_metadata.prototype_observed_counts.unit_offers -eq 48) "Observed unit-market offer count is preserved."
    Assert-True ($fixture.bridge_metadata.prototype_observed_counts.unsupported -eq 3) "Observed unsupported count is preserved."

    Write-Step "Checking campaign, finance, and location envelopes."
    Assert-ValueEnvelope $fixture.campaign.name "Campaign name"
    Assert-ValueEnvelope $fixture.campaign.date "Campaign date"
    Assert-ValueEnvelope $fixture.campaign.location.current_system_id "Campaign current system"
    Assert-ValueEnvelope $fixture.finances.balance "Finance balance"
    Assert-True ($fixture.campaign.name.value -eq "The Learning Ropes") "Prototype campaign sample value is parsed."
    Assert-True ($fixture.campaign.date.value -eq "3025-07-20") "Prototype campaign date is parsed."
    Assert-True ($fixture.finances.balance.value -eq "CSB 91255718") "Prototype method-backed balance is parsed."
    Assert-True ($fixture.finances.balance.method_backed -eq $true) "Finance balance remains method-backed."
    Assert-True ($fixture.campaign.location.current_location.warnings.Count -ge 1) "Prototype object-string location warning is preserved."

    Write-Step "Checking representative personnel and unit method-backed fields."
    Assert-True ($fixture.personnel.Count -eq 1) "Fixture keeps a compact representative personnel sample."
    $person = $fixture.personnel[0]
    Assert-True ($person.display_name -like "SANITIZED:*") "Personnel sample name is sanitized."
    Assert-ValueEnvelope $person.fatigue "Personnel fatigue"
    Assert-ValueEnvelope $person.hits "Personnel hits"
    Assert-ValueEnvelope $person.salary "Personnel salary"
    Assert-True ($person.primary_role.method_backed -eq $true) "Personnel primary role is method-backed."
    Assert-True ($person.salary.value -eq "CSB 3000.0") "Prototype personnel salary is parsed."

    Assert-True ($fixture.units.Count -eq 1) "Fixture keeps a compact representative unit sample."
    $unit = $fixture.units[0]
    Assert-True ($unit.entity.type -eq "BipedMek") "Unit entity type is parsed."
    Assert-ValueEnvelope $unit.damage_state "Unit damage state"
    Assert-True ($unit.damage_state.value -eq "Undamaged") "Unit damage state value is parsed."
    Assert-True ($unit.repair_summary.parts_needed_count -eq 0) "Unit parts-needed count is parsed."
    Assert-True ($unit.repair_summary.parts_needing_service_count -eq 1) "Unit parts-needing-service count is parsed."
    Assert-True ($unit.repair_summary.last_maintenance_report -like "SANITIZED:*") "Long maintenance report is sanitized."
    Assert-True ($unit.transport.warnings.Count -ge 1) "Unit transport warning is preserved."

    Write-Step "Checking contract, scenario, reports, and market warnings."
    Assert-True ($fixture.contracts.Count -eq 1) "Prototype fixture includes a representative contract."
    Assert-True ($fixture.contracts[0].terms.warnings.Count -ge 1) "Shallow contract-term warning is preserved."
    Assert-True ($fixture.scenarios.Count -eq 2) "Prototype fixture includes both observed scenario statuses."
    Assert-True (($fixture.scenarios.status.raw_code -contains "Pending") -and ($fixture.scenarios.status.raw_code -contains "Draw")) "Scenario statuses are parsed."
    Assert-True ($fixture.reports.current.Count -ge 1) "Current reports include a representative line."
    Assert-True ($fixture.reports.technical.Count -ge 1) "Technical reports include a representative line."
    Assert-True ($fixture.reports.technical[0].text -like "SANITIZED:*") "Technical report text is sanitized."

    Assert-True ($fixture.markets.unit_offers.Count -eq 1) "Prototype fixture includes a representative unit-market offer."
    $unitOffer = $fixture.markets.unit_offers[0]
    Assert-True ($null -eq $unitOffer.id) "Unit-market offer has no stable id."
    Assert-True ($unitOffer.stable_selector_available -eq $false) "Unit-market offer marks stable selector unavailable."
    Assert-ValueEnvelope $unitOffer.final_price "Unit offer final price"
    Assert-True ($unitOffer.final_price.method_backed -eq $true) "Unit offer final price remains method-backed."
    Assert-True ($unitOffer.warnings.Count -ge 1) "Unit offer automation-selector warning is preserved."

    Write-Step "Checking unsupported and read-only behavior."
    Assert-True ($fixture.unsupported.Count -eq 3) "Prototype fixture includes all observed unsupported categories."
    $writeUnsupported = $fixture.unsupported | Where-Object {
        $_.area -eq "write_commands" -and $_.field -eq "all"
    } | Select-Object -First 1
    Assert-True ($null -ne $writeUnsupported) "Unsupported list records the no-write-commands boundary."
    Assert-True ($writeUnsupported.blocks_automation -eq $true) "Write-command gap blocks automation."
    $stableOfferUnsupported = $fixture.unsupported | Where-Object {
        $_.area -eq "markets.unit_offers" -and $_.field -eq "stable_offer_id"
    } | Select-Object -First 1
    Assert-True ($null -ne $stableOfferUnsupported) "Unsupported list includes unit-offer stable selector gap."
    Assert-True ($stableOfferUnsupported.blocks_automation -eq $true) "Stable selector gap blocks automation."

    $fixtureHashAfter = (Get-FileHash -LiteralPath $fixturePath -Algorithm SHA256).Hash
    Assert-True ($fixtureHashBefore -eq $fixtureHashAfter) "Prototype fixture hash is unchanged after parsing."
}
finally {
    Pop-Location
}

Write-Host ""
Write-Host "MekHQ checkpoint prototype-output fixture tests passed."
