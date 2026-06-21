param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$checkpointPath = Join-Path $repoRoot "scripts\checkpoint-personal-combat.ps1"
$successFixture = Join-Path $repoRoot "tests\fixtures\personal-combat-checkpoint-success.fixture.json"
$handoffFixture = Join-Path $repoRoot "tests\fixtures\personal-combat-checkpoint-tactical-handoff.fixture.json"

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

function Invoke-Checkpoint {
    param([string]$InputFile)

    $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $checkpointPath -InputFile $InputFile 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host $output
        throw "Personal combat checkpoint failed for $InputFile with exit code $LASTEXITCODE."
    }

    return (($output -join "`n") | ConvertFrom-Json)
}

Write-Test "Checking personal-scale checkpoint fixture."
$success = Invoke-Checkpoint -InputFile $successFixture
Assert-True -Condition ($success.schema_version -eq "0.1") -Message "Output schema version is present."
Assert-True -Condition ($success.mechanic_id -eq "combat.personal_checkpoint") -Message "Output mechanic id is preserved."
Assert-True -Condition ($success.status -eq "provisional") -Message "Draft-authority checkpoint remains provisional."
Assert-True -Condition ($success.result.personal_checkpoint_allowed -eq $true) -Message "Personal checkpoint is allowed."
Assert-True -Condition ($success.result.handoff_required -eq $false) -Message "No tactical handoff is required."
Assert-True -Condition ($success.result.phase -eq "end") -Message "Phase is reported."
Assert-True -Condition ($success.result.turn -eq 2) -Message "Turn is reported."
Assert-True -Condition (@($success.result.active_effects).Count -eq 1) -Message "Active effects are reported."
Assert-True -Condition (($success.citations | ForEach-Object { $_.manifest_id }) -contains "personal-combat.overview") -Message "Overview citation is reported."
Assert-True -Condition (($success.warnings | ForEach-Object { $_.code }) -contains "draft-summary") -Message "Authority warning is preserved."
Assert-True -Condition (@($success.proposed_state_changes).Count -eq 1) -Message "One state proposal is emitted."
$proposal = @($success.proposed_state_changes)[0]
Assert-True -Condition ($proposal.schema_version -eq "0.1") -Message "Proposal schema version is reported."
Assert-True -Condition ($proposal.change_class -eq "rpg_memory") -Message "Proposal class is RPG memory."
Assert-True -Condition ($proposal.change_type -eq "session_log") -Message "Proposal type targets session log."
Assert-True -Condition ($proposal.approval.requires_approval -eq $true) -Message "Proposal requires approval."
Assert-True -Condition ($proposal.mekhq_boundary.affects_mekhq_hard_ledger -eq $false) -Message "Proposal does not claim MekHQ ledger effect."
Assert-True -Condition (@($success.no_hidden_mutation.files_written).Count -eq 0) -Message "Checkpoint writes no files."
Assert-True -Condition ($success.no_hidden_mutation.protected_source_read -eq $false) -Message "Checkpoint reports no protected-source read."

Write-Test "Checking tactical handoff refusal fixture."
$handoff = Invoke-Checkpoint -InputFile $handoffFixture
Assert-True -Condition ($handoff.status -eq "external_authority_required") -Message "Tactical fixture requires external authority."
Assert-True -Condition ($handoff.result.handoff_required -eq $true) -Message "Handoff result reports required handoff."
Assert-True -Condition ($handoff.result.personal_checkpoint_allowed -eq $false) -Message "Personal checkpoint is not allowed."
Assert-True -Condition (($handoff.warnings | ForEach-Object { $_.code }) -contains "tactical-handoff-required") -Message "Tactical handoff warning is reported."
Assert-True -Condition (@($handoff.proposed_state_changes).Count -eq 0) -Message "Handoff refusal emits no state proposals."

Write-Test "Checking invalid input failure without mutation."
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("mek-rpg-personal-checkpoint-" + [System.Guid]::NewGuid().ToString("N"))
try {
    New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null
    $invalidPath = Join-Path $tempRoot "invalid.json"
    @'
{
  "schema_version": "0.1",
  "request_id": "fixture-invalid",
  "mechanic_id": "combat.personal_checkpoint",
  "authority": {
    "status": "provisional",
    "warnings": []
  }
}
'@ | Set-Content -LiteralPath $invalidPath -Encoding UTF8

    $invalid = Invoke-Checkpoint -InputFile $invalidPath
    Assert-True -Condition ($invalid.status -eq "invalid_input") -Message "Missing checkpoint returns invalid_input."
    Assert-True -Condition (($invalid.warnings | ForEach-Object { $_.code }) -contains "missing-checkpoint") -Message "Missing checkpoint warning is reported."
    Assert-True -Condition (@($invalid.no_hidden_mutation.files_written).Count -eq 0) -Message "Invalid input writes no files."
}
finally {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
        Write-Ok "Disposable personal-checkpoint fixture removed."
    }
}

Write-Host ""
Write-Host "Personal combat checkpoint tests passed."
