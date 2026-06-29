param(
    [switch]$Quick,
    [switch]$ListSuites
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

$suites = @(
    @{
        Name = "MekHQ pending workflow regression"
        Path = Join-Path $repoRoot "scripts\test-mekhq-pending-workflow.ps1"
        Quick = $true
    },
    @{
        Name = "MekHQ bootstrap fixture coverage"
        Path = Join-Path $repoRoot "scripts\test-bootstrap-mekhq-campaign.ps1"
        Quick = $true
    },
    @{
        Name = "MekHQ save summary fixture coverage"
        Path = Join-Path $repoRoot "scripts\test-summarize-mekhq-save.ps1"
        Quick = $true
    },
    @{
        Name = "MekHQ checkpoint export fixture coverage"
        Path = Join-Path $repoRoot "scripts\test-mekhq-checkpoint-fixture.ps1"
        Quick = $true
    },
    @{
        Name = "MekHQ checkpoint prototype-output fixture coverage"
        Path = Join-Path $repoRoot "scripts\test-mekhq-checkpoint-prototype-fixture.ps1"
        Quick = $true
    },
    @{
        Name = "MekHQ checkpoint edge-case fixture coverage"
        Path = Join-Path $repoRoot "scripts\test-mekhq-checkpoint-edge-fixtures.ps1"
        Quick = $true
    },
    @{
        Name = "MekHQ live API fixture coverage"
        Path = Join-Path $repoRoot "scripts\test-mekhq-live-api-fixtures.ps1"
        Quick = $true
    },
    @{
        Name = "MekHQ live API fetch helper coverage"
        Path = Join-Path $repoRoot "scripts\test-fetch-mekhq-live-api.ps1"
        Quick = $true
    },
    @{
        Name = "MekHQ live API query helper coverage"
        Path = Join-Path $repoRoot "scripts\test-query-mekhq-live-api.ps1"
        Quick = $true
    },
    @{
        Name = "MekHQ status-note command helper coverage"
        Path = Join-Path $repoRoot "scripts\test-build-mekhq-status-note-command.ps1"
        Quick = $true
    },
    @{
        Name = "MekHQ live API campaign sync coverage"
        Path = Join-Path $repoRoot "scripts\test-sync-mekhq-live-campaign.ps1"
        Quick = $true
    },
    @{
        Name = "MekHQ API gap reporting workflow coverage"
        Path = Join-Path $repoRoot "scripts\test-mekhq-api-gap-reporting.ps1"
        Quick = $true
    },
    @{
        Name = "Campaign-state validator coverage"
        Path = Join-Path $repoRoot "scripts\test-validate-campaign-state.ps1"
        Quick = $true
    },
    @{
        Name = "Pending MekHQ action validator coverage"
        Path = Join-Path $repoRoot "scripts\test-validate-mekhq-pending-actions.ps1"
        Quick = $true
    },
    @{
        Name = "Rules index validator coverage"
        Path = Join-Path $repoRoot "scripts\test-validate-rules-indexes.ps1"
        Quick = $true
    },
    @{
        Name = "Rules coverage reporter smoke tests"
        Path = Join-Path $repoRoot "scripts\test-report-rules-coverage.ps1"
        Quick = $true
    },
    @{
        Name = "Profession profile schema validator coverage"
        Path = Join-Path $repoRoot "scripts\test-validate-profession-profiles.ps1"
        Quick = $true
    },
    @{
        Name = "Rules route helper golden fixture tests"
        Path = Join-Path $repoRoot "scripts\test-route-rules-prompt.ps1"
        Quick = $false
    },
    @{
        Name = "Ruling authority gate fixture tests"
        Path = Join-Path $repoRoot "scripts\test-check-ruling-authority.ps1"
        Quick = $false
    },
    @{
        Name = "Basic check resolver fixture tests"
        Path = Join-Path $repoRoot "scripts\test-resolve-basic-check.ps1"
        Quick = $true
    },
    @{
        Name = "Opposed check resolver fixture tests"
        Path = Join-Path $repoRoot "scripts\test-resolve-opposed-check.ps1"
        Quick = $true
    },
    @{
        Name = "Personal combat checkpoint fixture tests"
        Path = Join-Path $repoRoot "scripts\test-checkpoint-personal-combat.ps1"
        Quick = $true
    },
    @{
        Name = "GM context packet helper coverage"
        Path = Join-Path $repoRoot "scripts\test-build-gm-context-packet.ps1"
        Quick = $true
    },
    @{
        Name = "Read-only dashboard data adapter coverage"
        Path = Join-Path $repoRoot "scripts\test-export-dashboard-data.ps1"
        Quick = $false
    },
    @{
        Name = "Campaign session archive helper coverage"
        Path = Join-Path $repoRoot "scripts\test-archive-campaign-session.ps1"
        Quick = $true
    },
    @{
        Name = "GM context regression scenarios"
        Path = Join-Path $repoRoot "scripts\test-gm-context-regressions.ps1"
        Quick = $true
    },
    @{
        Name = "MekHQ-linked context packet scenarios"
        Path = Join-Path $repoRoot "scripts\test-mekhq-context-packet.ps1"
        Quick = $true
    }
)

$selectedSuites = if ($Quick) {
    @($suites | Where-Object { $_.Quick })
}
else {
    @($suites)
}

if ($ListSuites) {
    Write-Host "Deterministic MEK-RPG test suites"
    foreach ($suite in $suites) {
        $mode = if ($suite.Quick) { "quick, full" } else { "full" }
        Write-Host "- $($suite.Name) [$mode] $($suite.Path)"
    }
    exit 0
}

$failures = @()
$results = [System.Collections.Generic.List[object]]::new()
$runTimer = [System.Diagnostics.Stopwatch]::StartNew()

Push-Location $repoRoot
try {
    $modeLabel = if ($Quick) { "quick" } else { "full" }
    Write-Host "Running deterministic MEK-RPG $modeLabel test suites from $repoRoot"

    foreach ($suite in $selectedSuites) {
        Write-Host ""
        Write-Host "SUITE: $($suite.Name)"

        $suiteTimer = [System.Diagnostics.Stopwatch]::StartNew()
        try {
            & powershell -NoProfile -ExecutionPolicy Bypass -File $suite.Path
            if ($LASTEXITCODE -ne 0) {
                throw "Suite exited with code $LASTEXITCODE."
            }

            $suiteTimer.Stop()
            $results.Add([pscustomobject]@{
                Name = $suite.Name
                Status = "PASS"
                Seconds = $suiteTimer.Elapsed.TotalSeconds
            })
            Write-Host ("PASS: {0} ({1:N2}s)" -f $suite.Name, $suiteTimer.Elapsed.TotalSeconds)
        }
        catch {
            $suiteTimer.Stop()
            $failures += "$($suite.Name): $($_.Exception.Message)"
            $results.Add([pscustomobject]@{
                Name = $suite.Name
                Status = "FAIL"
                Seconds = $suiteTimer.Elapsed.TotalSeconds
            })
            Write-Host "FAIL: $($suite.Name)"
            Write-Host $_.Exception.Message
        }
    }
}
finally {
    Pop-Location
}

Write-Host ""
$runTimer.Stop()
Write-Host ("Test suite timing summary ({0} mode, {1:N2}s total):" -f $(if ($Quick) { "quick" } else { "full" }), $runTimer.Elapsed.TotalSeconds)
foreach ($result in @($results | Sort-Object -Property Seconds -Descending)) {
    Write-Host ("- {0}: {1} ({2:N2}s)" -f $result.Name, $result.Status, $result.Seconds)
}

Write-Host ""
if ($failures.Count -gt 0) {
    Write-Host "Deterministic test run failed."
    foreach ($failure in $failures) {
        Write-Host "- $failure"
    }
    exit 1
}

if ($Quick) {
    Write-Host "Quick deterministic MEK-RPG test suites passed. Run ./scripts/test-all.ps1 for full rules-route, authority-gate, and dashboard adapter coverage."
}
else {
    Write-Host "All deterministic MEK-RPG test suites passed."
}
