param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$validatorPath = Join-Path $repoRoot "scripts\validate-mekhq-pending-actions.ps1"
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) "mek-rpg-pending-actions-fixtures"

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

function Invoke-Validator {
    param(
        [string[]]$Arguments,
        [string]$Message
    )

    $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $validatorPath @Arguments 2>&1
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        $output | ForEach-Object { Write-Host $_ }
        throw "$Message failed with exit code $exitCode."
    }

    Write-Host "OK: $Message"
    return ($output | Out-String)
}

function Invoke-ValidatorExpectFailure {
    param(
        [string[]]$Arguments,
        [string]$ExpectedPattern,
        [string]$Message
    )

    $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $validatorPath @Arguments 2>&1
    $exitCode = $LASTEXITCODE
    Assert-True ($exitCode -ne 0) "$Message exits non-zero"
    $text = ($output | Out-String)
    Assert-True ($text -match $ExpectedPattern) "$Message reports expected failure"
    return $text
}

function Remove-TempFixtures {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
    }
}

function New-PendingItemText {
    param(
        [string]$Id,
        [string]$Title,
        [string]$Status,
        [string]$Type,
        [string]$Priority
    )

    return @"
### ${Id}: ${Title}

- Status: $Status
- Type: $Type
- Priority: $Priority
- Created: 2026-06-21
- Updated: 2026-06-21
- Source scene: `session-log.md` fixture scene
- Source files: `session-log.md`, `assets.md`, `missions.md`
- MekHQ target ids: campaign `Unknown`; person `Unknown`; unit `Unknown`; contract `Unknown`; scenario `Unknown`
- Current imported baseline: `Unknown`
- Proposed MekHQ action: Apply fixture action manually in MekHQ UI.
- Manual application checklist:
  - Open the linked MekHQ campaign save named in `mekhq-bridge.md`.
  - Confirm the current MekHQ date/save matches the latest imported baseline.
  - Apply the action in the MekHQ UI.
  - Save the MekHQ campaign.
- Command application checklist:
  - Confirm `GET /campaign/commands` reports the requested command available.
  - Run dry-run/preflight if the command supports it.
  - Execute only after approval or documented automation policy.
  - Re-read live MekHQ state and verify expected fields.
- Confirmation needed from next import: Fixture field appears in saved import.
- Affected campaign files after import: `assets.md`, `missions.md`, `current-state.md`
- Blockers or discrepancy notes: None
- Resolution notes: TBD

"@
}

Push-Location $repoRoot
try {
    Write-Step "Creating pending action fixture files."
    Remove-TempFixtures
    New-Item -ItemType Directory -Path $tempRoot | Out-Null

    $validAllPath = Join-Path $tempRoot "pending-valid-all.md"
    $invalidValuesPath = Join-Path $tempRoot "pending-invalid-values.md"
    $missingFieldPath = Join-Path $tempRoot "pending-missing-field.md"

    $statuses = @("proposed", "queued", "user-applied-in-mekhq", "command-executed-in-mekhq", "imported", "live-verified", "resolved", "blocked", "abandoned")
    $types = @("purchase-sale", "contract", "repair-logistics", "personnel", "injury-availability", "tactical-outcome", "day-advancement", "finance", "other")
    $priorities = @("optional", "before-day-advance", "before-next-scene", "end-of-session", "deferred", "before-next-scene", "deferred", "before-day-advance", "deferred")
    $body = "# Pending MekHQ Actions`n`n## Open Items`n`n"
    for ($i = 0; $i -lt $statuses.Count; $i++) {
        $number = "{0:D3}" -f ($i + 1)
        $body += New-PendingItemText "mekhq-pending-2026-06-21-$number" "Fixture $($statuses[$i]) item" $statuses[$i] $types[$i] $priorities[$i]
    }
    $body += "## Resolved Or Abandoned Items`n`n"
    Set-Content -LiteralPath $validAllPath -Value $body -Encoding UTF8

    Set-Content -LiteralPath $invalidValuesPath -Value (New-PendingItemText "mekhq-pending-2026-06-21-999" "Invalid values" "done" "magic" "whenever") -Encoding UTF8
    $missingFieldText = (New-PendingItemText "mekhq-pending-2026-06-21-998" "Missing field" "queued" "contract" "before-day-advance") -replace '(?m)^- Proposed MekHQ action:.*\r?\n', ''
    Set-Content -LiteralPath $missingFieldPath -Value $missingFieldText -Encoding UTF8

    Write-Step "Checking default empty pending file passes."
    $defaultOutput = Invoke-Validator @("campaigns/_template/pending-mekhq-actions.md") "Default pending file validation"
    Assert-True ($defaultOutput -match "No pending item entries found") "Default pending file reports no entries."

    Write-Step "Checking valid lifecycle coverage file passes."
    $validOutput = Invoke-Validator @($validAllPath, "-ReportUnresolved") "Valid lifecycle pending file"
    Assert-True ($validOutput -like "*9 item(s), 7 unresolved pending intent(s).*") "Valid file reports expected unresolved count."
    Assert-True ($validOutput -match "These are command proposals, command results, or manual-action checklists, not confirmed hard ledger facts") "Unresolved report preserves pending-intent boundary."
    Assert-True ($validOutput -match "mekhq-pending-2026-06-21-002") "Unresolved report includes queued item."
    Assert-True ($validOutput -match "mekhq-pending-2026-06-21-004") "Unresolved report includes command-executed item."
    Assert-True ($validOutput -match "mekhq-pending-2026-06-21-006") "Unresolved report includes live-verified review item."
    Assert-True ($validOutput -match "mekhq-pending-2026-06-21-008") "Unresolved report includes blocked item."
    Assert-True (-not $validOutput.Contains("mekhq-pending-2026-06-21-007 [resolved")) "Resolved item is not reported as unresolved."
    Assert-True (-not $validOutput.Contains("mekhq-pending-2026-06-21-009 [abandoned")) "Abandoned item is not reported as unresolved."

    Write-Step "Checking invalid status/type/priority fail."
    Invoke-ValidatorExpectFailure @($invalidValuesPath) "invalid Status 'done'" "Invalid status/type/priority" | Out-Null

    Write-Step "Checking missing required field fails."
    Invoke-ValidatorExpectFailure @($missingFieldPath) "missing required field: Proposed MekHQ action" "Missing required field" | Out-Null
}
finally {
    Remove-TempFixtures
    Pop-Location
}

Assert-True (-not (Test-Path -LiteralPath $tempRoot)) "Temporary pending action fixture folder removed."

Write-Host ""
Write-Host "Pending MekHQ action validator tests passed."
