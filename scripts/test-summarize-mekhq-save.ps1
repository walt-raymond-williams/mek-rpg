param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$fixturePath = Join-Path $repoRoot "tests\fixtures\mekhq-save-sanitized.xml"
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) "mek-rpg-summarize-fixtures"
$gzipFixturePath = Join-Path $tempRoot "mekhq-save-sanitized.xml.gz"
$missingSectionsPath = Join-Path $tempRoot "mekhq-save-missing-sections.xml"
$compiledSummaryPath = Join-Path ([System.IO.Path]::GetTempPath()) "mek-rpg-summarize-mekhq-save.pyc"

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

function Invoke-Checked {
    param(
        [string]$FilePath,
        [string[]]$Arguments,
        [string]$Message
    )

    $output = & $FilePath @Arguments 2>&1
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        $output | ForEach-Object { Write-Host $_ }
        throw "$Message failed with exit code $exitCode."
    }

    Write-Host "OK: $Message"
    return ($output | Out-String)
}

function Compress-Fixture {
    param(
        [string]$InputPath,
        [string]$OutputPath
    )

    $inputStream = [System.IO.File]::OpenRead($InputPath)
    try {
        $outputStream = [System.IO.File]::Create($OutputPath)
        try {
            $gzipStream = [System.IO.Compression.GZipStream]::new($outputStream, [System.IO.Compression.CompressionMode]::Compress)
            try {
                $inputStream.CopyTo($gzipStream)
            }
            finally {
                $gzipStream.Dispose()
            }
        }
        finally {
            $outputStream.Dispose()
        }
    }
    finally {
        $inputStream.Dispose()
    }
}

function Remove-TempArtifacts {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
    }
    if (Test-Path -LiteralPath $compiledSummaryPath) {
        Remove-Item -LiteralPath $compiledSummaryPath -Force
    }
}

Push-Location $repoRoot
try {
    Write-Step "Cleaning temporary fixture artifacts."
    Remove-TempArtifacts
    New-Item -ItemType Directory -Path $tempRoot | Out-Null

    Write-Step "Checking sanitized XML fixture and compiling helper."
    Assert-True (Test-Path -LiteralPath $fixturePath -PathType Leaf) "Sanitized XML fixture is present."
    $fixtureHashBefore = (Get-FileHash -LiteralPath $fixturePath -Algorithm SHA256).Hash
    Invoke-Checked "python" @(
        "-c",
        "import py_compile, sys; py_compile.compile(sys.argv[1], cfile=sys.argv[2], doraise=True)",
        "scripts/summarize-mekhq-save.py",
        $compiledSummaryPath
    ) "summarize-mekhq-save.py compiles" | Out-Null

    Write-Step "Parsing plain XML fixture as JSON."
    $jsonText = Invoke-Checked "python" @(
        "scripts/summarize-mekhq-save.py",
        $fixturePath,
        "--format",
        "json"
    ) "Plain XML JSON summary"
    $summary = $jsonText | ConvertFrom-Json

    $expectedKeys = @(
        "bridge_metadata",
        "campaign",
        "finances",
        "personnel",
        "units",
        "contracts",
        "scenarios",
        "repairs_and_logistics",
        "markets",
        "unsupported"
    )
    foreach ($key in $expectedKeys) {
        Assert-True ($summary.PSObject.Properties.Name -contains $key) "JSON output includes top-level key: $key"
    }
    Assert-True ($summary.bridge_metadata.gzip_compressed -eq $false) "Plain XML reports gzip_compressed false."
    Assert-True ($summary.bridge_metadata.mekhq_save_version -eq "sanitized-xml-fixture") "Save version is read from sanitized fixture."
    Assert-True ($summary.campaign.name -eq "Fixture Test Lances") "Campaign name is parsed."
    Assert-True ($summary.campaign.date -eq "3025-07-22") "Campaign date is parsed."
    Assert-True ($summary.finances.funds.calculated_balance_by_currency.'C-Bills' -eq 750000) "Funds are calculated from fixture transactions."
    Assert-True ($summary.personnel.Count -eq 2) "Personnel roster count is parsed."
    Assert-True ($summary.personnel[0].display_name -eq 'Avery Holt "Anchor"') "Personnel display name and callsign are parsed."
    Assert-True ($summary.units[0].display_name -eq "CN9-A Centurion Fixture") "Unit display name is parsed."
    Assert-True ($summary.contracts[0].name -eq "Fixture Convoy Guard") "Contract name is parsed."
    Assert-True ($summary.scenarios[0].name -eq "Fixture Roadblock") "Scenario name is parsed."
    Assert-True ($summary.markets.unit_market_offers[0].unit_name -eq "Fixture Jenner") "Unit market offer is parsed."
    Assert-True ($summary.markets.personnel_market_applicants[0].display_name -eq "Rin Calder") "Personnel market applicant is parsed."
    Assert-True ($summary.markets.contract_market_offers[0].name -eq "Fixture Offer") "Contract market offer is parsed."
    Assert-True ($summary.unsupported.Count -ge 1) "Unsupported fields are reported."
    Assert-True ($summary.bridge_metadata.warnings.Count -ge 1) "Warnings are reported for inferred funds."

    Write-Step "Parsing generated gzip fixture as JSON."
    Compress-Fixture $fixturePath $gzipFixturePath
    $gzipJsonText = Invoke-Checked "python" @(
        "scripts/summarize-mekhq-save.py",
        $gzipFixturePath,
        "--format",
        "json"
    ) "Gzip XML JSON summary"
    $gzipSummary = $gzipJsonText | ConvertFrom-Json
    Assert-True ($gzipSummary.bridge_metadata.gzip_compressed -eq $true) "Gzip XML reports gzip_compressed true."
    Assert-True ($gzipSummary.campaign.name -eq "Fixture Test Lances") "Gzip fixture parses same campaign name."
    Assert-True ($gzipSummary.finances.funds.calculated_balance_by_currency.'C-Bills' -eq 750000) "Gzip fixture parses same funds."

    Write-Step "Running Markdown output smoke test."
    $markdown = Invoke-Checked "python" @(
        "scripts/summarize-mekhq-save.py",
        $fixturePath,
        "--format",
        "markdown"
    ) "Plain XML Markdown summary"
    Assert-True ($markdown -match "# MekHQ Save Summary") "Markdown includes summary heading."
    Assert-True ($markdown -match "Fixture Test Lances") "Markdown includes campaign name."
    Assert-True ($markdown -match "Unsupported Or Needs Inspection") "Markdown includes unsupported section."

    Write-Step "Checking missing sections do not crash."
    @"
<?xml version="1.0" encoding="UTF-8"?>
<campaign version="missing-sections-fixture">
  <info>
    <id>missing-001</id>
    <name>Missing Sections Fixture</name>
    <calendar>3025-07-24</calendar>
  </info>
</campaign>
"@ | Set-Content -LiteralPath $missingSectionsPath -Encoding UTF8
    $missingJsonText = Invoke-Checked "python" @(
        "scripts/summarize-mekhq-save.py",
        $missingSectionsPath,
        "--format",
        "json"
    ) "Missing sections JSON summary"
    $missingSummary = $missingJsonText | ConvertFrom-Json
    Assert-True ($missingSummary.campaign.name -eq "Missing Sections Fixture") "Missing-sections fixture still parses campaign name."
    Assert-True ($missingSummary.personnel.Count -eq 0) "Missing personnel section returns empty roster."
    Assert-True ($missingSummary.units.Count -eq 0) "Missing units section returns empty units."
    Assert-True ($missingSummary.unsupported.Count -ge 1) "Missing-sections fixture still reports unsupported fields."
    Assert-True ($missingSummary.repairs_and_logistics.transport_cargo_pressure.status -eq "Needs MekHQ inspection") "Missing transport semantics are explicitly marked needs-inspection."

    Write-Step "Checking read-only fixture behavior."
    $fixtureHashAfter = (Get-FileHash -LiteralPath $fixturePath -Algorithm SHA256).Hash
    Assert-True ($fixtureHashBefore -eq $fixtureHashAfter) "Plain XML fixture hash is unchanged after summaries."
    Assert-True (-not (Test-Path -LiteralPath (Join-Path (Split-Path -Parent $fixturePath) "mekhq-save-sanitized.json"))) "Helper did not create an adjacent JSON output file."
}
finally {
    Remove-TempArtifacts
    Pop-Location
}

Assert-True (-not (Test-Path -LiteralPath $tempRoot)) "Temporary summarize fixture folder removed."

Write-Host ""
Write-Host "MekHQ save summary fixture tests passed."
