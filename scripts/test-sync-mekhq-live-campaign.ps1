param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$campaignsRoot = Join-Path $repoRoot "campaigns"
$stateFixturePath = Join-Path $repoRoot "tests\fixtures\mekhq-live-campaign-state.fixture.json"
$warningFixturePath = Join-Path $repoRoot "tests\fixtures\mekhq-live-campaign-warning-heavy.fixture.json"
$rawFixturePath = Join-Path ([System.IO.Path]::GetTempPath()) "mek-rpg-live-sync-raw-save.cpnx"
$kiaFixturePath = Join-Path ([System.IO.Path]::GetTempPath()) "mek-rpg-live-sync-kia-viewpoint.json"
$compiledAdapterPath = Join-Path ([System.IO.Path]::GetTempPath()) "mek-rpg-sync-mekhq-live-campaign.pyc"
$activePointerPath = Join-Path $repoRoot "campaign-state\active-campaign.md"

$campaignIds = @(
    "mekhq-live-sync-test-create",
    "mekhq-live-sync-test-refresh",
    "mekhq-live-sync-test-existing",
    "mekhq-live-sync-test-kia"
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
    foreach ($path in @($compiledAdapterPath, $rawFixturePath, $kiaFixturePath)) {
        if (Test-Path -LiteralPath $path) {
            Remove-Item -LiteralPath $path -Force
        }
    }
}

function Invoke-LiveSync {
    param(
        [string]$CampaignId,
        [string]$FixturePath,
        [string[]]$ExtraArgs,
        [string]$Message
    )

    $args = @(
        "scripts/sync-mekhq-live-campaign.py",
        "--live-state",
        $FixturePath,
        "--campaign-id",
        $CampaignId
    ) + $ExtraArgs

    Invoke-Checked "python" $args $Message | Out-Null
}

Push-Location $repoRoot
try {
    Write-Step "Cleaning disposable campaign folders."
    Remove-TestCampaigns
    Remove-TempFiles

    Write-Step "Checking fixtures and active campaign pointer baseline."
    Assert-True (Test-Path -LiteralPath $stateFixturePath -PathType Leaf) "Sanitized live state fixture is present."
    Assert-True (Test-Path -LiteralPath $warningFixturePath -PathType Leaf) "Sanitized warning-heavy live state fixture is present."
    $activeBefore = if (Test-Path -LiteralPath $activePointerPath -PathType Leaf) {
        Get-Content -LiteralPath $activePointerPath -Raw
    }
    else {
        ""
    }

    Write-Step "Compiling live campaign sync helper."
    Invoke-Checked "python" @(
        "-c",
        "import py_compile, sys; py_compile.compile(sys.argv[1], cfile=sys.argv[2], doraise=True)",
        "scripts/sync-mekhq-live-campaign.py",
        $compiledAdapterPath
    ) "sync-mekhq-live-campaign.py compiles" | Out-Null

    Write-Step "Checking invalid campaign id rejection."
    Invoke-ExpectFailure "python" @(
        "scripts/sync-mekhq-live-campaign.py",
        "--live-state",
        $stateFixturePath,
        "--campaign-id",
        "Bad_ID"
    ) "Campaign id must use lowercase letters" "Invalid campaign id" | Out-Null

    Write-Step "Checking raw save path rejection."
    Set-Content -LiteralPath $rawFixturePath -Value "<campaign />" -Encoding UTF8
    Invoke-ExpectFailure "python" @(
        "scripts/sync-mekhq-live-campaign.py",
        "--live-state",
        $rawFixturePath,
        "--campaign-id",
        "mekhq-live-sync-test-create"
    ) "not a raw MekHQ save or XML file" "Raw save input rejection" | Out-Null

    Write-Step "Checking live API campaign creation from state fixture."
    Invoke-LiveSync "mekhq-live-sync-test-create" $stateFixturePath @("--viewpoint-person-id", "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee") "Live API campaign create"
    $createPath = Join-Path $campaignsRoot "mekhq-live-sync-test-create"
    Assert-FileContains (Join-Path $createPath "overview.md") "MekHQ-linked live API context" "Overview records live API status."
    Assert-FileContains (Join-Path $createPath "current-state.md") "Live API data is not a durable checkpoint" "Current state preserves live-context boundary."
    Assert-FileContains (Join-Path $createPath "pcs.md") "Example Pilot" "Selected live API viewpoint is written."
    Assert-FileContains (Join-Path $createPath "pcs.md") "MekHQ playability: available for live viewpoint scenes" "Playable viewpoint is marked available."
    Assert-FileContains (Join-Path $createPath "assets.md") "Example PXH-1 Phoenix Hawk" "Live API unit is written."
    Assert-FileContains (Join-Path $createPath "assets.md") "Availability/deployability" "Live API unit availability is surfaced."
    Assert-FileContains (Join-Path $createPath "assets.md") "Parts/shopping pressure" "Expanded logistics pressure is surfaced."
    Assert-FileContains (Join-Path $createPath "assets.md") "Automation guard" "Repair/procurement automation guard is surfaced."
    Assert-FileContains (Join-Path $createPath "missions.md") "Example Security Contract" "Expanded contract display name is surfaced."
    Assert-FileContains (Join-Path $createPath "missions.md") "Payment summary" "Expanded contract payment summary is surfaced."
    Assert-FileContains (Join-Path $createPath "missions.md") "Example Convoy Intercept" "Expanded scenario display name is surfaced."
    Assert-FileContains (Join-Path $createPath "hooks.md") "Market posture" "Expanded market read-only posture is surfaced."
    Assert-FileContains (Join-Path $createPath "hooks.md") "Report pressure" "Expanded report metadata is surfaced."
    Assert-FileContains (Join-Path $createPath "locations.md") "Galatea" "Live API location is written."
    Assert-FileContains (Join-Path $createPath "mekhq-bridge.md") "API mode: ``local-read-only-live-context``" "Bridge records expected API mode."
    Assert-FileContains (Join-Path $createPath "mekhq-bridge.md") "Market unit/personnel/contract offers" "Bridge records market counts."
    Assert-FileContains (Join-Path $createPath "mekhq-bridge.md") "Current report lines" "Bridge records report counts."
    Assert-FileContains (Join-Path $createPath "mekhq-bridge.md") "Live API state JSON: ``tests/fixtures/mekhq-live-campaign-state.fixture.json``" "Bridge uses repo-relative fixture path."
    Assert-FileContains (Join-Path $createPath "mekhq-api-gaps.md") "unsaved_changes" "Unsupported live API dirty-state gap is surfaced."
    Assert-FileContains (Join-Path $createPath "mekhq-api-gaps.md") "not permission to parse the active save" "Gap file rejects parser fallback workaround."

    Write-Step "Checking existing target requires explicit refresh."
    Invoke-LiveSync "mekhq-live-sync-test-existing" $stateFixturePath @() "Live API existing-target setup"
    Invoke-ExpectFailure "python" @(
        "scripts/sync-mekhq-live-campaign.py",
        "--live-state",
        $stateFixturePath,
        "--campaign-id",
        "mekhq-live-sync-test-existing"
    ) "Pass --refresh-existing" "Existing target without refresh" | Out-Null

    Write-Step "Checking explicit refresh and API gap reporting from sparse warning-heavy fixture."
    Invoke-LiveSync "mekhq-live-sync-test-refresh" $stateFixturePath @() "Live API refresh setup"
    Invoke-LiveSync "mekhq-live-sync-test-refresh" $warningFixturePath @("--refresh-existing", "--embedded-pc-name", "Live API Camera") "Live API explicit refresh"
    $refreshPath = Join-Path $campaignsRoot "mekhq-live-sync-test-refresh"
    Assert-FileContains (Join-Path $refreshPath "pcs.md") "Live API Camera" "Refresh can select embedded viewpoint."
    Assert-FileContains (Join-Path $refreshPath "mekhq-api-gaps.md") "campaign.location.current_system_name" "Missing location is surfaced as an API gap."
    Assert-FileContains (Join-Path $refreshPath "mekhq-api-gaps.md") "stable_offer_selectors" "Automation-blocking unsupported market selector gap is surfaced."
    Assert-FileContains (Join-Path $refreshPath "mekhq-api-gaps.md") "Blocks automation: true" "Automation-blocking gaps keep severity."

    Write-Step "Checking unavailable MekHQ viewpoint guardrails."
    $kiaState = Get-Content -LiteralPath $stateFixturePath -Raw | ConvertFrom-Json
    $kiaState.personnel[0].status.raw_code = "KIA"
    $kiaState.personnel[0].status.label = "Killed in Action"
    $kiaState.personnel[0] | Add-Member -NotePropertyName "availability" -NotePropertyValue ([pscustomobject]@{
        value = $false
        evidence = "Confirmed from MekHQ export"
        method_backed = $true
        source_owner = "Person#getStatus().isActive()"
        warnings = @()
    }) -Force
    $kiaState | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $kiaFixturePath -Encoding UTF8
    Invoke-LiveSync "mekhq-live-sync-test-kia" $kiaFixturePath @() "Live API campaign create with unavailable viewpoint"
    $kiaPath = Join-Path $campaignsRoot "mekhq-live-sync-test-kia"
    Assert-FileContains (Join-Path $kiaPath "current-state.md") "No active live viewpoint is selected" "Current state refuses to present KIA personnel as active viewpoint."
    Assert-FileContains (Join-Path $kiaPath "current-state.md") "do not frame them as living or available" "Current state includes explicit KIA narration guard."
    Assert-FileContains (Join-Path $kiaPath "pcs.md") "MekHQ playability: unavailable for live viewpoint scenes" "PC sheet marks unavailable viewpoint."

    Write-Step "Checking active campaign pointer was not edited."
    $activeAfter = if (Test-Path -LiteralPath $activePointerPath -PathType Leaf) {
        Get-Content -LiteralPath $activePointerPath -Raw
    }
    else {
        ""
    }
    Assert-True ($activeBefore -eq $activeAfter) "Live sync tests leave active-campaign pointer unchanged."

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
Write-Host "MekHQ live API campaign sync tests passed."
