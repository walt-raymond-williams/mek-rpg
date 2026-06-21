param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$resolverPath = Join-Path $repoRoot "scripts\resolve-opposed-check.ps1"
$successFixture = Join-Path $repoRoot "tests\fixtures\opposed-check-success.fixture.json"
$sourceLookupFixture = Join-Path $repoRoot "tests\fixtures\opposed-check-source-lookup.fixture.json"
$tieFixture = Join-Path $repoRoot "tests\fixtures\opposed-check-tie.fixture.json"

function Write-Test {
    param([string]$Message)
    Write-Host "TEST: $Message"
}

function Write-Ok {
    param([string]$Message)
    Write-Host "OK: $Message"
}

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Message
    )

    if (-not $Condition) {
        throw $Message
    }

    Write-Ok $Message
}

function Invoke-Resolver {
    param([string]$InputFile)

    $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $resolverPath -InputFile $InputFile 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host $output
        throw "Opposed check resolver failed for $InputFile with exit code $LASTEXITCODE."
    }

    return (($output -join "`n") | ConvertFrom-Json)
}

Write-Test "Checking successful provisional opposed check fixture."
$success = Invoke-Resolver -InputFile $successFixture
Assert-True -Condition ($success.schema_version -eq "0.1") -Message "Output schema version is present."
Assert-True -Condition ($success.mechanic_id -eq "core.opposed_check") -Message "Output mechanic id is preserved."
Assert-True -Condition ($success.status -eq "provisional") -Message "Draft-authority result remains provisional."
Assert-True -Condition ($success.result.outcome -eq "actor_wins") -Message "Actor wins fixture contest."
Assert-True -Condition ($success.result.winner_id -eq "pc-scout") -Message "Winner id is reported."
Assert-True -Condition ($success.result.loser_id -eq "npc-sentry") -Message "Loser id is reported."
Assert-True -Condition ($success.roll_breakdown.actor.final_total -eq 9) -Message "Actor final total is reported."
Assert-True -Condition ($success.roll_breakdown.defender.final_total -eq 6) -Message "Defender final total is reported."
Assert-True -Condition ($success.roll_breakdown.actor.margin -eq 2) -Message "Actor margin is reported."
Assert-True -Condition ($success.roll_breakdown.defender.margin -eq -1) -Message "Defender margin is reported."
Assert-True -Condition ($success.roll_breakdown.margin -eq 3) -Message "Net margin is reported."
Assert-True -Condition ($success.result.degree -eq "clear") -Message "Net degree is reported."
Assert-True -Condition (($success.citations | ForEach-Object { $_.manifest_id }) -contains "core.opposed-actions") -Message "Opposed-action citation is reported."
Assert-True -Condition (($success.citations | ForEach-Object { $_.manifest_id }) -contains "core.basic-action-resolution") -Message "Basic-resolution citation is reported."
Assert-True -Condition (($success.warnings | ForEach-Object { $_.code }) -contains "draft-summary") -Message "Authority warning is preserved."
Assert-True -Condition (@($success.proposed_state_changes).Count -eq 0) -Message "Prototype emits no state changes."
Assert-True -Condition (@($success.no_hidden_mutation.files_written).Count -eq 0) -Message "Resolver writes no files."
Assert-True -Condition ($success.no_hidden_mutation.protected_source_read -eq $false) -Message "Resolver reports no protected-source read."

Write-Test "Checking tied-margin fixture."
$tie = Invoke-Resolver -InputFile $tieFixture
Assert-True -Condition ($tie.result.outcome -eq "tied_success_margins") -Message "Tied successful margins do not award a winner."
Assert-True -Condition ($null -eq $tie.result.winner_id) -Message "Tie has no winner id."
Assert-True -Condition ($tie.result.margin -eq 0) -Message "Tie reports zero net margin."
Assert-True -Condition (@($tie.unresolved_questions).Count -gt 0) -Message "Tie reports GM follow-up."

Write-Test "Checking source-lookup-required refusal fixture."
$sourceLookup = Invoke-Resolver -InputFile $sourceLookupFixture
Assert-True -Condition ($sourceLookup.status -eq "source_lookup_required") -Message "Source lookup authority is refused."
Assert-True -Condition ($null -eq $sourceLookup.result) -Message "Refusal does not produce a result."
Assert-True -Condition ($null -eq $sourceLookup.roll_breakdown) -Message "Refusal does not produce a roll breakdown."
Assert-True -Condition (($sourceLookup.warnings | ForEach-Object { $_.code }) -contains "authority-refusal") -Message "Refusal warning is reported."

Write-Test "Checking invalid input failure without mutation."
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("mek-rpg-opposed-check-" + [System.Guid]::NewGuid().ToString("N"))
try {
    New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null
    $invalidPath = Join-Path $tempRoot "invalid.json"
    @'
{
  "schema_version": "0.1",
  "request_id": "fixture-invalid",
  "mechanic_id": "core.opposed_check",
  "authority": {
    "status": "provisional",
    "warnings": []
  },
  "mechanic_inputs": {
    "actor": {
      "target_number": 7
    }
  }
}
'@ | Set-Content -LiteralPath $invalidPath -Encoding UTF8

    $invalid = Invoke-Resolver -InputFile $invalidPath
    Assert-True -Condition ($invalid.status -eq "invalid_input") -Message "Missing defender/rolls returns invalid_input."
    Assert-True -Condition (($invalid.warnings | ForEach-Object { $_.code }) -contains "missing-rolls") -Message "Missing rolls warning is reported."
    Assert-True -Condition (@($invalid.no_hidden_mutation.files_written).Count -eq 0) -Message "Invalid input writes no files."
}
finally {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
        Write-Ok "Disposable opposed-check fixture removed."
    }
}

Write-Host ""
Write-Host "Opposed check resolver tests passed."
