param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$resolverPath = Join-Path $repoRoot "scripts\resolve-basic-check.ps1"
$successFixture = Join-Path $repoRoot "tests\fixtures\basic-check-success.fixture.json"
$sourceLookupFixture = Join-Path $repoRoot "tests\fixtures\basic-check-source-lookup.fixture.json"

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
        throw "Basic check resolver failed for $InputFile with exit code $LASTEXITCODE."
    }

    return (($output -join "`n") | ConvertFrom-Json)
}

Write-Test "Checking successful provisional basic check fixture."
$success = Invoke-Resolver -InputFile $successFixture
Assert-True -Condition ($success.schema_version -eq "0.1") -Message "Output schema version is present."
Assert-True -Condition ($success.mechanic_id -eq "core.basic_check") -Message "Output mechanic id is preserved."
Assert-True -Condition ($success.status -eq "provisional") -Message "Draft-authority result remains provisional."
Assert-True -Condition ($success.result.success -eq $true) -Message "Fixture roll succeeds."
Assert-True -Condition ($success.roll_breakdown.base_total -eq 7) -Message "Base dice total is reported."
Assert-True -Condition ($success.roll_breakdown.modifier_total -eq 1) -Message "Modifier total is reported."
Assert-True -Condition ($success.roll_breakdown.final_total -eq 8) -Message "Final total is reported."
Assert-True -Condition ($success.roll_breakdown.margin -eq 1) -Message "Margin is reported."
Assert-True -Condition ($success.result.degree -eq "standard") -Message "Degree is reported."
Assert-True -Condition (@($success.citations).Count -gt 0) -Message "Citations are reported."
Assert-True -Condition (($success.citations | ForEach-Object { $_.manifest_id }) -contains "core.skill-checks") -Message "Citation includes routed manifest id."
Assert-True -Condition (($success.warnings | ForEach-Object { $_.code }) -contains "draft-summary") -Message "Authority warning is preserved."
Assert-True -Condition (@($success.proposed_state_changes).Count -eq 0) -Message "Prototype emits no state changes."
Assert-True -Condition (@($success.no_hidden_mutation.files_written).Count -eq 0) -Message "Resolver writes no files."
Assert-True -Condition ($success.no_hidden_mutation.protected_source_read -eq $false) -Message "Resolver reports no protected-source read."

Write-Test "Checking source-lookup-required refusal fixture."
$sourceLookup = Invoke-Resolver -InputFile $sourceLookupFixture
Assert-True -Condition ($sourceLookup.status -eq "source_lookup_required") -Message "Source lookup authority is refused."
Assert-True -Condition ($null -eq $sourceLookup.result) -Message "Refusal does not produce a result."
Assert-True -Condition ($null -eq $sourceLookup.roll_breakdown) -Message "Refusal does not produce a roll breakdown."
Assert-True -Condition (($sourceLookup.warnings | ForEach-Object { $_.code }) -contains "authority-refusal") -Message "Refusal warning is reported."

Write-Test "Checking invalid input failure without mutation."
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("mek-rpg-basic-check-" + [System.Guid]::NewGuid().ToString("N"))
try {
    New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null
    $invalidPath = Join-Path $tempRoot "invalid.json"
    @'
{
  "schema_version": "0.1",
  "request_id": "fixture-invalid",
  "mechanic_id": "core.basic_check",
  "mechanic_inputs": {
    "target_number": 7
  },
  "roll": {
    "mode": "fixed",
    "expression": "2d6",
    "values": [3, 4]
  }
}
'@ | Set-Content -LiteralPath $invalidPath -Encoding UTF8

    $invalid = Invoke-Resolver -InputFile $invalidPath
    Assert-True -Condition ($invalid.status -eq "invalid_input") -Message "Missing authority returns invalid_input."
    Assert-True -Condition (($invalid.warnings | ForEach-Object { $_.code }) -contains "missing-authority") -Message "Missing authority warning is reported."
    Assert-True -Condition (@($invalid.no_hidden_mutation.files_written).Count -eq 0) -Message "Invalid input writes no files."
}
finally {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
        Write-Ok "Disposable basic-check fixture removed."
    }
}

Write-Host ""
Write-Host "Basic check resolver tests passed."
