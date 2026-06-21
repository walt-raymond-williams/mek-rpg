param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$fixturePath = Join-Path $repoRoot "tests\fixtures\mekhq-read-only-checkpoint.fixture.json"

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
    Write-Step "Checking sanitized checkpoint fixture presence and JSON syntax."
    Assert-True (Test-Path -LiteralPath $fixturePath -PathType Leaf) "Sanitized checkpoint fixture is present."
    $fixtureHashBefore = (Get-FileHash -LiteralPath $fixturePath -Algorithm SHA256).Hash
    $fixture = Get-Content -LiteralPath $fixturePath -Raw | ConvertFrom-Json

    Write-Step "Checking top-level checkpoint shape."
    $expectedTopLevelKeys = @(
        "bridge_metadata",
        "campaign",
        "finances",
        "personnel",
        "units",
        "contracts",
        "scenarios",
        "repairs_and_logistics",
        "markets",
        "reports",
        "unsupported"
    )
    foreach ($key in $expectedTopLevelKeys) {
        Assert-HasProperty $fixture $key "Fixture includes top-level key: $key"
    }

    Write-Step "Checking bridge metadata and sanitation boundary."
    Assert-True ($fixture.bridge_metadata.schema_name -eq "mekhq-read-only-checkpoint") "Fixture declares the checkpoint schema name."
    Assert-True ($fixture.bridge_metadata.schema_version -eq "0.1") "Fixture declares the expected draft schema version."
    Assert-True ($fixture.bridge_metadata.producer -eq "sanitized-fixture") "Fixture producer is sanitized-fixture."
    Assert-True ($fixture.bridge_metadata.read_only -eq $true) "Fixture metadata preserves read_only true."
    Assert-True ($fixture.bridge_metadata.input_path -like "SANITIZED:*") "Fixture input path is sanitized."
    Assert-True ($fixture.bridge_metadata.warnings.Count -ge 1) "Fixture metadata includes sanitation warnings."
    Assert-True ($fixture.bridge_metadata.evidence -eq "Confirmed from MekHQ export") "Fixture metadata preserves evidence label."

    Write-Step "Checking campaign and finance value envelopes."
    Assert-ValueEnvelope $fixture.campaign.name "Campaign name"
    Assert-ValueEnvelope $fixture.campaign.date "Campaign date"
    Assert-ValueEnvelope $fixture.finances.balance "Finance balance"
    Assert-True ($fixture.campaign.name.value -eq "Fictional Lancers") "Campaign name value is parsed."
    Assert-True ($fixture.campaign.date.value -eq "3025-07-21") "Campaign date value is parsed."
    Assert-True ($fixture.finances.balance.value -eq 12485000) "Finance balance value is parsed."
    Assert-True ($fixture.finances.balance.method_backed -eq $true) "Finance balance is method-backed in the fixture."

    Write-Step "Checking personnel shape and method-backed fields."
    Assert-True ($fixture.personnel.Count -ge 1) "Fixture includes personnel entries."
    $person = $fixture.personnel[0]
    Assert-True ($person.id -eq "aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeee0001") "Personnel id is parsed."
    Assert-True ($person.display_name -eq "Captain Mara Voss") "Personnel display name is parsed."
    Assert-ValueEnvelope $person.fatigue "Personnel fatigue"
    Assert-ValueEnvelope $person.hits "Personnel hits"
    Assert-ValueEnvelope $person.salary "Personnel salary"
    Assert-True ($person.primary_role.method_backed -eq $true) "Personnel primary role is method-backed."
    Assert-True ($person.warnings.Count -eq 0) "Personnel entry can carry scoped warnings."

    Write-Step "Checking unit condition and repair summary shape."
    Assert-True ($fixture.units.Count -ge 1) "Fixture includes unit entries."
    $unit = $fixture.units[0]
    Assert-True ($unit.display_name -eq "Shadow Hawk SHD-2H Sentinel One") "Unit display name is parsed."
    Assert-ValueEnvelope $unit.damage_state "Unit damage state"
    Assert-True ($unit.damage_state.warnings.Count -ge 1) "Unit damage state carries scoped warnings."
    Assert-True ($unit.repair_summary.parts_needed_count -eq 1) "Unit repair parts-needed count is parsed."
    Assert-True ($unit.transport.warnings.Count -ge 1) "Unit transport carries needs-inspection warning."

    Write-Step "Checking contract, scenario, and report sections."
    Assert-True ($fixture.contracts.Count -ge 1) "Fixture includes contract entries."
    Assert-True ($fixture.contracts[0].display_name -eq "Training Cadre Rotation") "Contract display name is parsed."
    Assert-True ($fixture.contracts[0].terms.salvage_pct -eq "40%") "Contract terms summary is parsed."
    Assert-True ($fixture.scenarios.Count -ge 1) "Fixture includes scenario entries."
    Assert-True ($fixture.scenarios[0].display_name -eq "Checkpoint Sweep") "Scenario display name is parsed."
    Assert-HasProperty $fixture.reports "current" "Reports include current report bucket."
    Assert-HasProperty $fixture.reports "technical" "Reports include technical report bucket."
    Assert-True ($fixture.reports.current.Count -ge 1) "Current reports include representative lines."
    Assert-True ($fixture.reports.technical.Count -ge 1) "Technical reports include representative lines."

    Write-Step "Checking market and unsupported automation boundaries."
    Assert-HasProperty $fixture.markets "unit_offers" "Markets include unit offers."
    Assert-HasProperty $fixture.markets "personnel_applicants" "Markets include personnel applicants."
    Assert-HasProperty $fixture.markets "contract_offers" "Markets include contract offers."
    Assert-True ($fixture.markets.unit_offers.Count -ge 1) "Fixture includes a unit market offer."
    $unitOffer = $fixture.markets.unit_offers[0]
    Assert-True ($null -eq $unitOffer.id) "Unit offer has no stable id."
    Assert-True ($unitOffer.stable_selector_available -eq $false) "Unit offer explicitly marks stable selector unavailable."
    Assert-ValueEnvelope $unitOffer.final_price "Unit offer final price"
    Assert-True ($unitOffer.warnings.Count -ge 1) "Unit offer carries automation-selector warning."
    Assert-True ($fixture.unsupported.Count -ge 1) "Fixture includes unsupported fields."
    $stableOfferUnsupported = $fixture.unsupported | Where-Object {
        $_.area -eq "markets.unit_offers" -and $_.field -eq "stable_offer_id"
    } | Select-Object -First 1
    Assert-True ($null -ne $stableOfferUnsupported) "Unsupported list includes unit-offer stable selector gap."
    Assert-True ($stableOfferUnsupported.blocks_automation -eq $true) "Stable selector gap blocks automation."

    Write-Step "Checking read-only fixture behavior."
    $fixtureHashAfter = (Get-FileHash -LiteralPath $fixturePath -Algorithm SHA256).Hash
    Assert-True ($fixtureHashBefore -eq $fixtureHashAfter) "Checkpoint fixture hash is unchanged after parsing."
}
finally {
    Pop-Location
}

Write-Host ""
Write-Host "MekHQ checkpoint fixture tests passed."
