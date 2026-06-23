param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$campaignsRoot = Join-Path $repoRoot "campaigns"
$fixturePath = Join-Path $repoRoot "tests\fixtures\mekhq-summary-minimal.json"
$compiledBootstrapPath = Join-Path ([System.IO.Path]::GetTempPath()) "mek-rpg-bootstrap-mekhq-campaign-unit.pyc"
$activePointerPath = Join-Path $repoRoot "campaign-state\active-campaign.md"

$campaignIds = @(
    "mekhq-bootstrap-test-id",
    "mekhq-bootstrap-test-name",
    "mekhq-bootstrap-test-commander",
    "mekhq-bootstrap-test-embedded",
    "mekhq-bootstrap-test-existing"
)

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

function Assert-FileContains {
    param(
        [string]$Path,
        [string]$Pattern,
        [string]$Message
    )

    Assert-True (Test-Path -LiteralPath $Path -PathType Leaf) "File exists: $Path"
    $content = Get-Content -LiteralPath $Path -Raw
    Assert-True ($content -match $Pattern) $Message
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
    return $output
}

function Invoke-ExpectFailure {
    param(
        [string]$FilePath,
        [string[]]$Arguments,
        [string]$ExpectedPattern,
        [string]$Message
    )

    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $output = & $FilePath @Arguments 2>&1
        $exitCode = $LASTEXITCODE
    }
    finally {
        $ErrorActionPreference = $oldErrorActionPreference
    }

    Assert-True ($exitCode -ne 0) "$Message exits non-zero"
    $text = ($output | Out-String)
    Assert-True ($text -match $ExpectedPattern) "$Message reports expected failure"
    return $output
}

function Remove-TestCampaigns {
    $campaignsRootResolved = (Resolve-Path $campaignsRoot).Path
    foreach ($campaignId in $campaignIds) {
        $path = Join-Path $campaignsRootResolved $campaignId
        if (Test-Path -LiteralPath $path) {
            Assert-True ((Split-Path -Parent $path) -eq $campaignsRootResolved) "Disposable campaign path stays inside campaigns/: $campaignId"
            Remove-Item -LiteralPath $path -Recurse -Force
        }
    }
}

function Remove-TempFiles {
    if (Test-Path -LiteralPath $compiledBootstrapPath) {
        Remove-Item -LiteralPath $compiledBootstrapPath -Force
    }
}

function Invoke-Bootstrap {
    param(
        [string]$CampaignId,
        [string[]]$SelectorArgs,
        [string]$Message
    )

    $args = @(
        "scripts/bootstrap-mekhq-campaign.py",
        "--summary",
        $fixturePath,
        "--campaign-id",
        $CampaignId
    ) + $SelectorArgs

    Invoke-Checked "python" $args $Message | Out-Null
}

Push-Location $repoRoot
try {
    Write-Step "Cleaning disposable campaign folders."
    Remove-TestCampaigns
    Remove-TempFiles

    Write-Step "Checking fixture and active campaign pointer baseline."
    Assert-True (Test-Path -LiteralPath $fixturePath -PathType Leaf) "Sanitized summary fixture is present."
    $activeBefore = if (Test-Path -LiteralPath $activePointerPath -PathType Leaf) {
        Get-Content -LiteralPath $activePointerPath -Raw
    }
    else {
        ""
    }

    Write-Step "Compiling bootstrap helper."
    Invoke-Checked "python" @(
        "-c",
        "import py_compile, sys; py_compile.compile(sys.argv[1], cfile=sys.argv[2], doraise=True)",
        "scripts/bootstrap-mekhq-campaign.py",
        $compiledBootstrapPath
    ) "bootstrap-mekhq-campaign.py compiles" | Out-Null

    Write-Step "Checking invalid campaign id rejection."
    Invoke-ExpectFailure "python" @(
        "scripts/bootstrap-mekhq-campaign.py",
        "--summary",
        $fixturePath,
        "--campaign-id",
        "Bad_ID",
        "--viewpoint-person-id",
        "p-001"
    ) "Campaign id must use lowercase letters" "Invalid campaign id" | Out-Null

    Write-Step "Checking viewpoint selection by MekHQ personnel id."
    Invoke-Bootstrap "mekhq-bootstrap-test-id" @("--viewpoint-person-id", "p-002") "Bootstrap by viewpoint id"
    $idPath = Join-Path $campaignsRoot "mekhq-bootstrap-test-id"
    Assert-FileContains (Join-Path $idPath "pcs.md") "Mira Voss" "Viewpoint by id writes selected character."
    Assert-FileContains (Join-Path $idPath "overview.md") "Matched requested MekHQ personnel id" "Overview records id-selection reason."
    Assert-FileContains (Join-Path $idPath "mekhq-bridge.md") "Do not write to .*\.cpnx.*\.cpnx\.gz.*MekHQ XML.*raw MekHQ save payloads" "Bridge preserves no-writeback language."
    Assert-FileContains (Join-Path $idPath "pending-mekhq-actions.md") "supported MekHQ command endpoints" "Pending file preserves command proposal guidance."
    Assert-FileContains (Join-Path $idPath "pending-mekhq-actions.md") "manual MekHQ fallback checklist" "Pending file preserves manual fallback guidance."

    Write-Step "Checking viewpoint selection by exact display name."
    Invoke-Bootstrap "mekhq-bootstrap-test-name" @("--viewpoint-name", "Avery Holt") "Bootstrap by exact viewpoint name"
    $namePath = Join-Path $campaignsRoot "mekhq-bootstrap-test-name"
    Assert-FileContains (Join-Path $namePath "pcs.md") "Avery Holt" "Viewpoint by exact name writes selected character."
    Assert-FileContains (Join-Path $namePath "overview.md") "Matched requested MekHQ personnel display name" "Overview records name-selection reason."

    Write-Step "Checking commander fallback viewpoint selection."
    Invoke-Bootstrap "mekhq-bootstrap-test-commander" @() "Bootstrap with commander fallback"
    $commanderPath = Join-Path $campaignsRoot "mekhq-bootstrap-test-commander"
    Assert-FileContains (Join-Path $commanderPath "pcs.md") "Avery Holt" "Commander fallback selects fixture commander."
    Assert-FileContains (Join-Path $commanderPath "overview.md") "Selected first MekHQ commander flag" "Overview records commander fallback reason."

    Write-Step "Checking embedded PC viewpoint selection."
    Invoke-Bootstrap "mekhq-bootstrap-test-embedded" @("--embedded-pc-name", "Rin Calder") "Bootstrap with embedded PC"
    $embeddedPath = Join-Path $campaignsRoot "mekhq-bootstrap-test-embedded"
    Assert-FileContains (Join-Path $embeddedPath "pcs.md") "Rin Calder" "Embedded PC name is written."
    Assert-FileContains (Join-Path $embeddedPath "pcs.md") "MekHQ person id: ``None``" "Embedded PC remains unlinked to MekHQ person id."
    Assert-FileContains (Join-Path $embeddedPath "overview.md") "Embedded A Time of War PC requested" "Overview records embedded PC reason."

    Write-Step "Checking existing target folder refusal."
    Invoke-Bootstrap "mekhq-bootstrap-test-existing" @("--viewpoint-person-id", "p-001") "Bootstrap existing-target setup"
    Invoke-ExpectFailure "python" @(
        "scripts/bootstrap-mekhq-campaign.py",
        "--summary",
        $fixturePath,
        "--campaign-id",
        "mekhq-bootstrap-test-existing",
        "--viewpoint-person-id",
        "p-001"
    ) "Campaign already exists" "Existing target folder refusal" | Out-Null

    Write-Step "Checking generated standard headings."
    foreach ($campaignId in @("mekhq-bootstrap-test-id", "mekhq-bootstrap-test-name", "mekhq-bootstrap-test-commander", "mekhq-bootstrap-test-embedded")) {
        $path = Join-Path $campaignsRoot $campaignId
        Assert-FileContains (Join-Path $path "overview.md") "^# Campaign Overview" "$campaignId overview heading present."
        Assert-FileContains (Join-Path $path "current-state.md") "^# Current State" "$campaignId current state heading present."
        Assert-FileContains (Join-Path $path "mekhq-bridge.md") "^# MekHQ Bridge" "$campaignId bridge heading present."
        Assert-FileContains (Join-Path $path "session-log.md") "^# Session Log" "$campaignId session log heading present."
    }

    Write-Step "Checking active campaign pointer was not edited."
    $activeAfter = if (Test-Path -LiteralPath $activePointerPath -PathType Leaf) {
        Get-Content -LiteralPath $activePointerPath -Raw
    }
    else {
        ""
    }
    Assert-True ($activeBefore -eq $activeAfter) "Bootstrap tests leave active-campaign pointer unchanged."

    Write-Step "Cleaning disposable campaign folders."
}
finally {
    Remove-TestCampaigns
    Remove-TempFiles
    Pop-Location
}

foreach ($campaignId in $campaignIds) {
    Assert-True (-not (Test-Path -LiteralPath (Join-Path $campaignsRoot $campaignId))) "Disposable campaign folder removed: $campaignId"
}

Write-Host ""
Write-Host "MekHQ bootstrap fixture tests passed."
