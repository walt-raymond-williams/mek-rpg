param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

$suites = @(
    @{
        Name = "MekHQ pending workflow regression"
        Path = Join-Path $repoRoot "scripts\test-mekhq-pending-workflow.ps1"
    },
    @{
        Name = "MekHQ bootstrap fixture coverage"
        Path = Join-Path $repoRoot "scripts\test-bootstrap-mekhq-campaign.ps1"
    },
    @{
        Name = "MekHQ save summary fixture coverage"
        Path = Join-Path $repoRoot "scripts\test-summarize-mekhq-save.ps1"
    }
)

$failures = @()

Push-Location $repoRoot
try {
    Write-Host "Running deterministic MEK-RPG test suites from $repoRoot"

    foreach ($suite in $suites) {
        Write-Host ""
        Write-Host "SUITE: $($suite.Name)"

        try {
            & powershell -NoProfile -ExecutionPolicy Bypass -File $suite.Path
            if ($LASTEXITCODE -ne 0) {
                throw "Suite exited with code $LASTEXITCODE."
            }

            Write-Host "PASS: $($suite.Name)"
        }
        catch {
            $failures += "$($suite.Name): $($_.Exception.Message)"
            Write-Host "FAIL: $($suite.Name)"
            Write-Host $_.Exception.Message
        }
    }
}
finally {
    Pop-Location
}

Write-Host ""
if ($failures.Count -gt 0) {
    Write-Host "Deterministic test run failed."
    foreach ($failure in $failures) {
        Write-Host "- $failure"
    }
    exit 1
}

Write-Host "All deterministic MEK-RPG test suites passed."
