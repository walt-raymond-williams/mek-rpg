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
        [switch]$IncludePersonDetail,
        [switch]$FailedManifest
    )

    $target = Join-Path $tempRoot $Name
    New-Item -ItemType Directory -Path $target -Force | Out-Null

    Copy-Item -LiteralPath (Join-Path $fixturesRoot "mekhq-live-campaign-summary.fixture.json") -Destination (Join-Path $target "mekhq-summary.json")
    Copy-Item -LiteralPath (Join-Path $fixturesRoot "mekhq-live-campaign-commands.fixture.json") -Destination (Join-Path $target "mekhq-commands.json")
    Copy-Item -LiteralPath (Join-Path $fixturesRoot "mekhq-live-pending-deployments.fixture.json") -Destination (Join-Path $target "mekhq-pending-deployments.json")
    if ($IncludePersonDetail) {
        Copy-Item -LiteralPath (Join-Path $fixturesRoot "mekhq-live-personnel-detail.fixture.json") -Destination (Join-Path $target "mekhq-personnel-detail.json")
    }
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
        if ($IncludePersonDetail) {
            $results += [pscustomobject]@{ name = "personnel_detail"; method = "GET"; path = "/campaign/personnel/detail?personId=00000000-0000-0000-0000-000000000468"; output_file = "mekhq-personnel-detail.json"; required = $true; status = "captured"; seconds = 0.001; error = $null }
        }
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

    Write-Step "Querying compact play-context facts."
    $playJson = & python $scriptPath --capture-dir $validCapture --view play-context --format json
    if ($LASTEXITCODE -ne 0) {
        $playJson | ForEach-Object { Write-Host $_ }
        throw "Play-context query failed with exit code $LASTEXITCODE."
    }
    $play = $playJson | ConvertFrom-Json
    Assert-True ($play.view -eq "play-context") "Play-context view is selected."
    Assert-True ($play.status -eq "ok") "Valid play-context capture reports ok."
    Assert-True ($play.identity.campaign_name.value -eq "Example Live Campaign") "Play-context includes campaign identity."
    Assert-True ($play.facts.finance_headline.balance.value -eq "2,500,000 C-bills") "Play-context includes finance headline."
    Assert-True ($play.facts.deployment_headline.pending_scenario_count.value -eq 2) "Play-context includes pending scenario count."
    Assert-True (@($play.facts.deployment_headline.scenarios).Count -ge 1) "Play-context includes scenario headline rows."
    Assert-True ($play.facts.unit_readiness_headline.deployable_count.value -eq 1) "Play-context includes unit readiness headline."
    Assert-True ($play.facts.personnel_headline.personnel_count.value -eq 1) "Play-context includes personnel headline."
    Assert-True (@($play.facts.reports_headline.current_reports).Count -eq 1) "Play-context includes visible current reports."
    Assert-True ($play.facts.command_headline.available_count.value -ge 1) "Play-context includes command readiness headline."
    Assert-True (($play.source.files | ForEach-Object { $_.file }) -contains "mekhq-state.json") "Play-context source files include state capture."

    Write-Step "Rendering play-context text output."
    $playText = & python $scriptPath --capture-dir $validCapture --view play-context --format text
    if ($LASTEXITCODE -ne 0) {
        $playText | ForEach-Object { Write-Host $_ }
        throw "Play-context text output query failed with exit code $LASTEXITCODE."
    }
    Assert-True (($playText -join "`n") -match "MekHQ live API query view: play-context") "Play-context text output includes heading."
    Assert-True (($playText -join "`n") -match "Pending scenarios: 2") "Play-context text output includes pending scenario headline."

    Write-Step "Checking play-context remains partial without optional pending deployments and commands."
    $partialPlayCapture = New-CaptureFixture -Name "play-context-partial"
    Remove-Item -LiteralPath (Join-Path $partialPlayCapture "mekhq-pending-deployments.json") -Force
    Remove-Item -LiteralPath (Join-Path $partialPlayCapture "mekhq-commands.json") -Force
    $partialPlayJson = & python $scriptPath --capture-dir $partialPlayCapture --view play-context --format json
    if ($LASTEXITCODE -ne 0) {
        $partialPlayJson | ForEach-Object { Write-Host $_ }
        throw "Partial play-context query should remain usable."
    }
    $partialPlay = $partialPlayJson | ConvertFrom-Json
    Assert-True ($partialPlay.status -eq "partial") "Missing optional play-context captures report partial."
    Assert-True ($partialPlay.facts.deployment_headline.pending_scenario_count.value -eq "Unknown") "Missing pending deployments preserves Unknown."
    Assert-True ($partialPlay.facts.command_headline.available_count.value -eq "Unknown") "Missing command readiness preserves Unknown."
    Assert-True (@($partialPlay.gaps | Where-Object { $_.field -eq "mekhq-pending-deployments.json" }).Count -eq 1) "Missing pending deployments is recorded as a gap."
    Assert-True (@($partialPlay.gaps | Where-Object { $_.field -eq "mekhq-commands.json" }).Count -eq 1) "Missing commands is recorded as a gap."

    Write-Step "Querying focused pending deployment facts."
    $deployJson = & python $scriptPath --capture-dir $validCapture --view pending-deployments --format json
    if ($LASTEXITCODE -ne 0) {
        $deployJson | ForEach-Object { Write-Host $_ }
        throw "Pending-deployments query failed with exit code $LASTEXITCODE."
    }
    $deployments = $deployJson | ConvertFrom-Json
    Assert-True ($deployments.view -eq "pending-deployments") "Pending-deployments view is selected."
    Assert-True ($deployments.status -eq "partial") "Pending-deployments view marks missing risk intel as partial."
    Assert-True ($deployments.counts.pending_scenarios.value -eq 2) "Pending-deployments counts pending scenarios."
    Assert-True ($deployments.facts.pending_scenarios[0].id.value -eq 66) "Pending-deployments reports scenario ids."
    Assert-True ($deployments.facts.pending_scenarios[0].assigned_unit_count.value -eq 1) "Pending-deployments reports assignment counts."
    Assert-True ($deployments.facts.pending_scenarios[0].risk_intel.opfor_total_bv.value -eq "Unknown") "Pending-deployments preserves missing OpFor BV as Unknown."
    Assert-True (@($deployments.gaps | Where-Object { $_.field -eq "opfor_total_bv" }).Count -ge 1) "Pending-deployments records missing OpFor BV as a gap."

    Write-Step "Querying focused person commitment facts by name."
    $commitJson = & python $scriptPath --capture-dir $validCapture --view person-commitment --person-name Moreno --format json
    if ($LASTEXITCODE -ne 0) {
        $commitJson | ForEach-Object { Write-Host $_ }
        throw "Person-commitment query failed with exit code $LASTEXITCODE."
    }
    $commitment = $commitJson | ConvertFrom-Json
    Assert-True ($commitment.view -eq "person-commitment") "Person-commitment view is selected."
    Assert-True ($commitment.status -eq "ok") "Person-commitment view reports ok for a match."
    Assert-True ($commitment.counts.matches.value -eq 1) "Person-commitment matches one crew member."
    Assert-True ($commitment.facts.commitments[0].scenario_name.value -eq "Tank-base defense") "Person-commitment reports scenario commitment."

    Write-Step "Querying focused unit readiness facts."
    $unitJson = & python $scriptPath --capture-dir $validCapture --view unit-readiness --format json
    if ($LASTEXITCODE -ne 0) {
        $unitJson | ForEach-Object { Write-Host $_ }
        throw "Unit-readiness query failed with exit code $LASTEXITCODE."
    }
    $unitReadiness = $unitJson | ConvertFrom-Json
    Assert-True ($unitReadiness.view -eq "unit-readiness") "Unit-readiness view is selected."
    Assert-True ($unitReadiness.counts.units.value -eq 1) "Unit-readiness counts units."
    Assert-True ($unitReadiness.counts.deployable.value -eq 1) "Unit-readiness counts deployable units."
    Assert-True ($unitReadiness.facts.units[0].damage_state.value -eq "Undamaged") "Unit-readiness reports damage state."

    Write-Step "Querying focused repair pressure facts."
    $repairJson = & python $scriptPath --capture-dir $validCapture --view repair-pressure --format json
    if ($LASTEXITCODE -ne 0) {
        $repairJson | ForEach-Object { Write-Host $_ }
        throw "Repair-pressure query failed with exit code $LASTEXITCODE."
    }
    $repair = $repairJson | ConvertFrom-Json
    Assert-True ($repair.view -eq "repair-pressure") "Repair-pressure view is selected."
    Assert-True ($repair.facts.repair_pressure.value.parts_needed_count -eq 0) "Repair-pressure reports parts-needed pressure."
    Assert-True ($repair.counts.shopping_list.value -eq 1) "Repair-pressure reports shopping-list pressure."

    Write-Step "Querying focused reports facts."
    $reportsJson = & python $scriptPath --capture-dir $validCapture --view reports --format json
    if ($LASTEXITCODE -ne 0) {
        $reportsJson | ForEach-Object { Write-Host $_ }
        throw "Reports query failed with exit code $LASTEXITCODE."
    }
    $reports = $reportsJson | ConvertFrom-Json
    Assert-True ($reports.view -eq "reports") "Reports view is selected."
    Assert-True ($reports.counts.current.value -eq 1) "Reports view counts current reports."
    Assert-True ($reports.facts.report_buckets.current[0].text.value -match "sanitized report line") "Reports view includes current report text."

    Write-Step "Querying focused command readiness facts."
    $commandJson = & python $scriptPath --capture-dir $validCapture --view command-readiness --format json
    if ($LASTEXITCODE -ne 0) {
        $commandJson | ForEach-Object { Write-Host $_ }
        throw "Command-readiness query failed with exit code $LASTEXITCODE."
    }
    $commandReadiness = $commandJson | ConvertFrom-Json
    Assert-True ($commandReadiness.view -eq "command-readiness") "Command-readiness view is selected."
    Assert-True ($commandReadiness.facts.selector_detail.value -eq "default-cheap-readiness") "Command-readiness identifies cheap default selector mode."
    Assert-True ($commandReadiness.counts.available.value -ge 1) "Command-readiness counts available commands."
    Assert-True (@($commandReadiness.facts.commands | Where-Object { $_.command.value -eq "campaign.status_note" -and $_.requires_command_envelope.value -eq $true }).Count -eq 1) "Command-readiness reports envelope-backed command workflow."

    Write-Step "Querying focused API gap facts."
    $gapJson = & python $scriptPath --capture-dir $validCapture --view api-gaps --format json
    if ($LASTEXITCODE -ne 0) {
        $gapJson | ForEach-Object { Write-Host $_ }
        throw "API-gaps query failed with exit code $LASTEXITCODE."
    }
    $apiGaps = $gapJson | ConvertFrom-Json
    Assert-True ($apiGaps.view -eq "api-gaps") "API-gaps view is selected."
    Assert-True ($apiGaps.counts.unsupported.value -ge 1) "API-gaps counts unsupported fields."
    Assert-True ($apiGaps.facts.gap_report_skeleton.value -match "MEKHQ_PLAYTEST_API_GAP_REPORT") "API-gaps points to gap-report schema."

    Write-Step "Querying compact personnel detail facts."
    $personCapture = New-CaptureFixture -Name "person-detail" -IncludePersonDetail
    $personJson = & python $scriptPath `
        --person-detail-file (Join-Path $personCapture "mekhq-personnel-detail.json") `
        --manifest-file (Join-Path $personCapture "mekhq-live-api-capture-manifest.json") `
        --view person-detail `
        --format json
    if ($LASTEXITCODE -ne 0) {
        $personJson | ForEach-Object { Write-Host $_ }
        throw "Person-detail query failed with exit code $LASTEXITCODE."
    }
    $person = $personJson | ConvertFrom-Json
    Assert-True ($person.view -eq "person-detail") "Person-detail view is selected."
    Assert-True ($person.status -eq "ok") "Default person-detail capture reports ok."
    Assert-True ($person.identity.campaign_name.value -eq "The Learning Ropes") "Person-detail identity can stand alone."
    Assert-True ($person.facts.person.display_name.value -eq "Michelle Moreno") "Person detail includes compact display name."
    Assert-True ($person.facts.status.primary_role.value -eq "MekWarrior") "Person detail includes compact role label."
    Assert-True ($person.counts.skills.value -eq 1) "Person detail counts skills."
    Assert-True ($person.facts.log_families.medical.status.value -eq "excluded") "Medical logs remain excluded by default."
    Assert-True ($person.facts.log_families.medical.required_query_flag.value -eq "includeMedical=true") "Medical log opt-in flag is surfaced."
    Assert-True ($person.facts.privacy.medical_included.value -eq $false) "Privacy facts prove medical logs were not included."
    Assert-True (-not (($personJson -join "`n") -match "Joined The Learning Ropes")) "Compact person-detail output does not dump raw log entries."

    Write-Step "Checking explicit sensitive log opt-in remains bounded and compact."
    $optInCapture = New-CaptureFixture -Name "person-detail-opt-in" -IncludePersonDetail
    $optInPath = Join-Path $optInCapture "mekhq-personnel-detail.json"
    $optInDetail = Get-Content -LiteralPath $optInPath -Raw | ConvertFrom-Json
    $optInDetail.person.privacy.medical_included = $true
    $optInDetail.person.logs.medical.status = "included"
    $optInDetail.person.logs.medical | Add-Member -MemberType NoteProperty -Name returned_count -Value 1
    $optInDetail.person.logs.medical | Add-Member -MemberType NoteProperty -Name entries -Value @([pscustomobject]@{ text = "Sensitive fixture medical text should not appear in compact output." })
    $optInDetail.person.logs.metadata.limit_per_family = 7
    Write-Utf8Json -Path $optInPath -Value $optInDetail
    $optInJson = & python $scriptPath --capture-dir $optInCapture --view person-detail --format json
    if ($LASTEXITCODE -ne 0) {
        $optInJson | ForEach-Object { Write-Host $_ }
        throw "Bounded sensitive opt-in query should remain usable."
    }
    $optIn = $optInJson | ConvertFrom-Json
    Assert-True ($optIn.status -eq "partial") "Sensitive opt-in is marked partial with a privacy warning."
    Assert-True ($optIn.facts.privacy.medical_included.value -eq $true) "Sensitive opt-in fact is explicit."
    Assert-True ($optIn.facts.privacy.limit_per_family.value -eq 7) "Sensitive opt-in keeps bounded log limit."
    Assert-True (-not (($optInJson -join "`n") -match "Sensitive fixture medical text")) "Compact output suppresses sensitive raw log text."

    Write-Step "Checking sensitive opt-in without a bounded log limit blocks output."
    $badOptInCapture = New-CaptureFixture -Name "person-detail-bad-opt-in" -IncludePersonDetail
    $badOptInPath = Join-Path $badOptInCapture "mekhq-personnel-detail.json"
    $badOptInDetail = Get-Content -LiteralPath $badOptInPath -Raw | ConvertFrom-Json
    $badOptInDetail.person.privacy.medical_included = $true
    $badOptInDetail.person.logs.medical.status = "included"
    $badOptInDetail.person.logs.metadata.limit_per_family = 0
    Write-Utf8Json -Path $badOptInPath -Value $badOptInDetail
    $badOptInJson = & python $scriptPath --capture-dir $badOptInCapture --view person-detail --format json
    Assert-True ($LASTEXITCODE -ne 0) "Unbounded sensitive opt-in exits non-zero."
    $badOptIn = $badOptInJson | ConvertFrom-Json
    Assert-True ($badOptIn.status -eq "blocked") "Unbounded sensitive opt-in reports blocked."
    Assert-True (@($badOptIn.gaps | Where-Object { $_.field -eq "logLimit" }).Count -eq 1) "Unbounded sensitive opt-in records logLimit gap."

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

    Write-Step "Checking missing state blocks play-context view."
    $missingPlayStateJson = & python $scriptPath --capture-dir $missingStateCapture --view play-context --format json
    Assert-True ($LASTEXITCODE -ne 0) "Missing required state exits non-zero for play-context."
    $missingPlayState = $missingPlayStateJson | ConvertFrom-Json
    Assert-True ($missingPlayState.status -eq "blocked") "Missing required state reports blocked for play-context."

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
