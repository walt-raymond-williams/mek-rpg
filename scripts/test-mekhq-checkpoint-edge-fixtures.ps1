param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$fixturePath = Join-Path $repoRoot "tests\fixtures\mekhq-read-only-checkpoint.edge-cases.fixture.json"

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
    Write-Step "Checking edge-case fixture presence, JSON syntax, and sanitation."
    Assert-True (Test-Path -LiteralPath $fixturePath -PathType Leaf) "Edge-case fixture is present."
    $fixtureHashBefore = (Get-FileHash -LiteralPath $fixturePath -Algorithm SHA256).Hash
    $fixtureText = Get-Content -LiteralPath $fixturePath -Raw
    $fixture = $fixtureText | ConvertFrom-Json
    Assert-True ($fixtureText -notmatch "C:\\\\Users\\\\") "Edge fixture has no local Windows user paths."
    Assert-True ($fixtureText -notmatch "analysis\\\\tmp") "Edge fixture has no scratch analysis paths."

    Write-Step "Checking top-level checkpoint shape stays stable despite sparse content."
    foreach ($key in @(
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
    )) {
        Assert-HasProperty $fixture $key "Edge fixture includes top-level key: $key"
    }
    Assert-True ($fixture.bridge_metadata.producer -eq "sanitized-edge-fixture") "Edge fixture declares sanitized-edge-fixture producer."
    Assert-True ($fixture.bridge_metadata.read_only -eq $true) "Edge fixture remains read-only."
    Assert-True ($fixture.bridge_metadata.input_path -like "SANITIZED:*") "Edge fixture input path is sanitized."
    Assert-True ($fixture.bridge_metadata.warnings.Count -ge 2) "Edge fixture records sanitation and edge-case warnings."

    Write-Step "Checking unknown and missing-but-wrapped hard ledger values."
    Assert-ValueEnvelope $fixture.campaign.name "Campaign name"
    Assert-ValueEnvelope $fixture.campaign.date "Campaign date"
    Assert-ValueEnvelope $fixture.campaign.location.current_system_id "Current system id"
    Assert-ValueEnvelope $fixture.finances.balance "Finance balance"
    Assert-True ($fixture.campaign.location.current_system_id.value -eq "Unknown") "Missing current system is explicit Unknown."
    Assert-True ($fixture.campaign.location.current_system_id.evidence -eq "Needs MekHQ inspection") "Missing current system requires inspection."
    Assert-True ($fixture.finances.balance.value -eq "Unknown") "Missing balance is explicit Unknown."
    Assert-True ($fixture.finances.balance.warnings.Count -ge 1) "Missing balance carries warning."

    Write-Step "Checking empty roster, unit, and scenario arrays are accepted."
    Assert-True ($fixture.personnel.Count -eq 0) "Edge fixture allows empty personnel array."
    Assert-True ($fixture.units.Count -eq 0) "Edge fixture allows empty units array."
    Assert-True ($fixture.scenarios.Count -eq 0) "Edge fixture allows empty scenarios array."

    Write-Step "Checking shallow contract terms are preserved as warnings, not invented details."
    Assert-True ($fixture.contracts.Count -eq 1) "Edge fixture includes one shallow contract."
    $contract = $fixture.contracts[0]
    Assert-True ($contract.display_name -eq "Sparse Contract Terms") "Shallow contract display name is parsed."
    Assert-True ($contract.terms.PSObject.Properties.Name -notcontains "salvage_pct") "Shallow contract does not invent salvage terms."
    Assert-True ($contract.terms.warnings.Count -ge 1) "Shallow contract terms carry warning."
    Assert-True ($contract.scenario_ids.Count -eq 0) "Shallow contract tolerates no linked scenarios."

    Write-Step "Checking warning-heavy logistics and empty reports."
    Assert-ValueEnvelope $fixture.repairs_and_logistics.cargo "Cargo pressure"
    Assert-ValueEnvelope $fixture.repairs_and_logistics.transport_bays "Transport bay pressure"
    Assert-True ($fixture.repairs_and_logistics.cargo.evidence -eq "Needs MekHQ inspection") "Cargo pressure requires inspection."
    Assert-True ($fixture.repairs_and_logistics.transport_bays.warnings.Count -ge 1) "Transport bays carry warning."
    Assert-True ($fixture.reports.current.Count -eq 0) "Current report bucket may be empty."
    Assert-True ($fixture.reports.technical.Count -eq 0) "Technical report bucket may be empty."
    Assert-True ($fixture.reports.warnings.Count -ge 1) "Report classification gap is preserved."

    Write-Step "Checking market offer without final_price is display-only and non-automation-safe."
    Assert-True ($fixture.markets.unit_offers.Count -eq 1) "Edge fixture includes one unit offer."
    $offer = $fixture.markets.unit_offers[0]
    Assert-True ($null -eq $offer.id) "Edge unit offer has no stable id."
    Assert-True ($offer.stable_selector_available -eq $false) "Edge unit offer marks stable selector unavailable."
    Assert-True ($offer.PSObject.Properties.Name -notcontains "final_price") "Edge unit offer may omit final_price."
    Assert-True ($offer.warnings.Count -ge 2) "Edge unit offer carries missing price and selector warnings."

    Write-Step "Checking unsupported entries distinguish blockers from FYI gaps."
    Assert-True ($fixture.unsupported.Count -ge 4) "Edge fixture includes multiple unsupported entries."
    $stableOfferUnsupported = $fixture.unsupported | Where-Object {
        $_.area -eq "markets.unit_offers" -and $_.field -eq "stable_offer_id"
    } | Select-Object -First 1
    Assert-True ($null -ne $stableOfferUnsupported) "Stable selector unsupported entry is present."
    Assert-True ($stableOfferUnsupported.blocks_automation -eq $true) "Stable selector unsupported entry blocks automation."
    $missingPriceUnsupported = $fixture.unsupported | Where-Object {
        $_.area -eq "markets.unit_offers" -and $_.field -eq "final_price"
    } | Select-Object -First 1
    Assert-True ($null -ne $missingPriceUnsupported) "Missing final price unsupported entry is present."
    Assert-True ($missingPriceUnsupported.blocks_automation -eq $false) "Missing final price is not itself an automation blocker."
    $writeUnsupported = $fixture.unsupported | Where-Object {
        $_.area -eq "write_commands" -and $_.field -eq "all"
    } | Select-Object -First 1
    Assert-True ($null -ne $writeUnsupported) "Write-command unsupported entry is present."
    Assert-True ($writeUnsupported.blocks_automation -eq $true) "Write-command unsupported entry blocks automation."

    Write-Step "Checking read-only fixture behavior."
    $fixtureHashAfter = (Get-FileHash -LiteralPath $fixturePath -Algorithm SHA256).Hash
    Assert-True ($fixtureHashBefore -eq $fixtureHashAfter) "Edge fixture hash is unchanged after parsing."
}
finally {
    Pop-Location
}

Write-Host ""
Write-Host "MekHQ checkpoint edge-case fixture tests passed."
