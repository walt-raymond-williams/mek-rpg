param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$scriptPath = Join-Path $repoRoot "scripts\query-mekhq-live-api.py"
$fixturesRoot = Join-Path $repoRoot "tests\fixtures"
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) "mek-rpg-query-mekhq-live-api-fixture"

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

function Remove-TempFixtures {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
    }
}

function Write-Utf8Json {
    param(
        [string]$Path,
        [object]$Value
    )

    $json = $Value | ConvertTo-Json -Depth 30
    [System.IO.File]::WriteAllText($Path, $json + [Environment]::NewLine, [System.Text.UTF8Encoding]::new($false))
}

function New-CaptureFixture {
    param(
        [string]$Name,
        [string]$ManifestStatus = "captured",
        [switch]$OmitManifest,
        [switch]$OmitState,
        [switch]$FailedManifest
    )

    $target = Join-Path $tempRoot $Name
    New-Item -ItemType Directory -Path $target -Force | Out-Null

    Copy-Item -LiteralPath (Join-Path $fixturesRoot "mekhq-live-campaign-summary.fixture.json") -Destination (Join-Path $target "mekhq-summary.json")
    Copy-Item -LiteralPath (Join-Path $fixturesRoot "mekhq-live-campaign-commands.fixture.json") -Destination (Join-Path $target "mekhq-commands.json")
    Copy-Item -LiteralPath (Join-Path $fixturesRoot "mekhq-live-pending-deployments.fixture.json") -Destination (Join-Path $target "mekhq-pending-deployments.json")
    if (-not $OmitState) {
        Copy-Item -LiteralPath (Join-Path $fixturesRoot "mekhq-live-campaign-state.fixture.json") -Destination (Join-Path $target "mekhq-state.json")
    }

    if (-not $OmitManifest) {
        $results = @(
            [pscustomobject]@{ name = "summary"; method = "GET"; path = "/campaign/summary"; output_file = "mekhq-summary.json"; required = $true; status = "captured"; seconds = 0.001; error = $null },
            [pscustomobject]@{ name = "state"; method = "GET"; path = "/campaign/state"; output_file = "mekhq-state.json"; required = $true; status = "captured"; seconds = 0.001; error = $null },
            [pscustomobject]@{ name = "commands"; method = "GET"; path = "/campaign/commands"; output_file = "mekhq-commands.json"; required = $true; status = "captured"; seconds = 0.001; error = $null },
            [pscustomobject]@{ name = "pending_deployments"; method = "GET"; path = "/campaign/pending-deployments"; output_file = "mekhq-pending-deployments.json"; required = $true; status = "captured"; seconds = 0.001; error = $null }
        )
        if ($FailedManifest) {
            $results[2].status = "failed"
            $results[2].output_file = "mekhq-commands.error.json"
            $results[2].error = "Synthetic command-readiness failure."
            Write-Utf8Json -Path (Join-Path $target "mekhq-commands.error.json") -Value ([pscustomobject]@{
                    name = "commands"
                    method = "GET"
                    path = "/campaign/commands"
                    required = $true
                    status = "failed"
                    error = "Synthetic command-readiness failure."
                })
        }

        Write-Utf8Json -Path (Join-Path $target "mekhq-live-api-capture-manifest.json") -Value ([pscustomobject]@{
                schema_version = "mek-rpg-mekhq-live-api-capture/v1"
                api_base_url = "http://127.0.0.1:32180"
                captured_at = "2026-06-29T00:00:00Z"
                output_directory = $target
                state_sections = @("bridge_metadata", "campaign", "unsupported")
                status = if ($FailedManifest) { "failed" } else { $ManifestStatus }
                results = $results
            })
    }

    return $target
}

Push-Location $repoRoot
try {
    Remove-TempFixtures
    New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null

    Write-Step "Querying a valid capture directory."
    $validCapture = New-CaptureFixture -Name "valid-capture"
    $validJson = & python $scriptPath --capture-dir $validCapture --view summary --format json
    if ($LASTEXITCODE -ne 0) {
        $validJson | ForEach-Object { Write-Host $_ }
        throw "Valid capture query failed with exit code $LASTEXITCODE."
    }
    $valid = $validJson | ConvertFrom-Json
    Assert-True ($valid.schema_version -eq "mek-rpg-mekhq-live-api-query-view/v1") "JSON envelope schema version is stable."
    Assert-True ($valid.view -eq "summary") "Summary view is selected."
    Assert-True ($valid.status -eq "ok") "Valid capture reports ok."
    Assert-True ($valid.identity.campaign_name.value -eq "Example Live Campaign") "Campaign identity comes from live state."
    Assert-True ($valid.identity.read_only.value -eq $true) "Read-only proof is present."
    Assert-True ($valid.identity.api_mode.value -eq "local-read-only-live-context") "API mode proof is present."
    Assert-True ($valid.counts.personnel.value -eq 1) "Personnel count is computed."
    Assert-True ($valid.counts.unsupported.value -ge 1) "Unsupported count is computed."
    Assert-True (@($valid.gaps | Where-Object { $_.evidence -eq "unsupported_by_api" }).Count -ge 1) "Unsupported entries are surfaced as gaps."

    Write-Step "Querying explicit file inputs."
    $explicitJson = & python $scriptPath `
        --state-file (Join-Path $validCapture "mekhq-state.json") `
        --summary-file (Join-Path $validCapture "mekhq-summary.json") `
        --manifest-file (Join-Path $validCapture "mekhq-live-api-capture-manifest.json") `
        --view summary `
        --format json
    if ($LASTEXITCODE -ne 0) {
        $explicitJson | ForEach-Object { Write-Host $_ }
        throw "Explicit file query failed with exit code $LASTEXITCODE."
    }
    $explicit = $explicitJson | ConvertFrom-Json
    Assert-True ($explicit.status -eq "ok") "Explicit file query reports ok."
    Assert-True ($explicit.identity.campaign_id.value -eq "11111111-2222-3333-4444-555555555555") "Explicit file query preserves campaign id."

    Write-Step "Rendering text output from the same compact facts."
    $textOutput = & python $scriptPath --capture-dir $validCapture --view summary --format text
    if ($LASTEXITCODE -ne 0) {
        $textOutput | ForEach-Object { Write-Host $_ }
        throw "Text output query failed with exit code $LASTEXITCODE."
    }
    Assert-True (($textOutput -join "`n") -match "MekHQ live API query view: summary") "Text output includes summary heading."
    Assert-True (($textOutput -join "`n") -match "Example Live Campaign") "Text output includes campaign name."

    Write-Step "Checking missing manifest reports partial but remains usable."
    $missingManifestCapture = New-CaptureFixture -Name "missing-manifest" -OmitManifest
    $missingManifestJson = & python $scriptPath --capture-dir $missingManifestCapture --view summary --format json
    if ($LASTEXITCODE -ne 0) {
        $missingManifestJson | ForEach-Object { Write-Host $_ }
        throw "Missing manifest query should remain usable."
    }
    $missingManifest = $missingManifestJson | ConvertFrom-Json
    Assert-True ($missingManifest.status -eq "partial") "Missing manifest reports partial."
    Assert-True (@($missingManifest.gaps | Where-Object { $_.field -eq "mekhq-live-api-capture-manifest.json" }).Count -eq 1) "Missing manifest is recorded as a gap."

    Write-Step "Checking failed manifest and endpoint error file are surfaced."
    $failedCapture = New-CaptureFixture -Name "failed-manifest" -FailedManifest
    $failedJson = & python $scriptPath --capture-dir $failedCapture --view summary --format json
    if ($LASTEXITCODE -ne 0) {
        $failedJson | ForEach-Object { Write-Host $_ }
        throw "Failed manifest query should report partial output."
    }
    $failed = $failedJson | ConvertFrom-Json
    Assert-True ($failed.status -eq "partial") "Failed manifest reports partial."
    Assert-True (@($failed.gaps | Where-Object { $_.evidence -eq "capture_failed" }).Count -ge 1) "Capture failures are surfaced as gaps."

    Write-Step "Checking missing state blocks state-based summary view."
    $missingStateCapture = New-CaptureFixture -Name "missing-state" -OmitState
    $missingStateJson = & python $scriptPath --capture-dir $missingStateCapture --view summary --format json
    Assert-True ($LASTEXITCODE -ne 0) "Missing required state exits non-zero."
    $missingState = $missingStateJson | ConvertFrom-Json
    Assert-True ($missingState.status -eq "blocked") "Missing required state reports blocked."

    Write-Step "Checking missing read-only proof blocks state-based summary view."
    $badProofCapture = New-CaptureFixture -Name "bad-read-only"
    $badStatePath = Join-Path $badProofCapture "mekhq-state.json"
    $badState = Get-Content -LiteralPath $badStatePath -Raw | ConvertFrom-Json
    $badState.bridge_metadata.read_only = $false
    Write-Utf8Json -Path $badStatePath -Value $badState
    $badProofJson = & python $scriptPath --capture-dir $badProofCapture --view summary --format json
    Assert-True ($LASTEXITCODE -ne 0) "False read-only proof exits non-zero."
    $badProof = $badProofJson | ConvertFrom-Json
    Assert-True ($badProof.status -eq "blocked") "False read-only proof reports blocked."
    Assert-True (@($badProof.gaps | Where-Object { $_.field -eq "read_only" }).Count -eq 1) "False read-only proof is recorded as a gap."

    Write-Step "Checking wrong API mode blocks state-based summary view."
    $badModeCapture = New-CaptureFixture -Name "bad-api-mode"
    $badModeStatePath = Join-Path $badModeCapture "mekhq-state.json"
    $badModeState = Get-Content -LiteralPath $badModeStatePath -Raw | ConvertFrom-Json
    $badModeState.bridge_metadata.api_mode = "local-save-parser-context"
    Write-Utf8Json -Path $badModeStatePath -Value $badModeState
    $badModeJson = & python $scriptPath --capture-dir $badModeCapture --view summary --format json
    Assert-True ($LASTEXITCODE -ne 0) "Wrong API mode exits non-zero."
    $badMode = $badModeJson | ConvertFrom-Json
    Assert-True ($badMode.status -eq "blocked") "Wrong API mode reports blocked."
    Assert-True (@($badMode.gaps | Where-Object { $_.field -eq "api_mode" }).Count -eq 1) "Wrong API mode is recorded as a gap."

    Write-Step "Checking raw save/XML path rejection."
    $rejectedJson = & python $scriptPath --state-file (Join-Path $tempRoot "example.cpnx") --view summary --format json
    Assert-True ($LASTEXITCODE -ne 0) "Raw .cpnx path exits non-zero."
    $rejected = $rejectedJson | ConvertFrom-Json
    Assert-True ($rejected.status -eq "error") "Raw .cpnx path reports error."
    Assert-True ($rejected.gaps[0].reason -match "Rejected non-capture input path") "Raw path rejection reason is explicit."
}
finally {
    Pop-Location
    Remove-TempFixtures
}

Assert-True (-not (Test-Path -LiteralPath $tempRoot)) "Temporary query helper fixture folder removed."

Write-Host ""
Write-Host "MekHQ live API query helper tests passed."
