param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$validatorPath = Join-Path $repoRoot "scripts\validate-profession-profiles.ps1"
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("mek-rpg-profession-validator-" + [guid]::NewGuid().ToString("N"))

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

function Invoke-Validator {
    param(
        [string]$FixtureRoot,
        [int]$ExpectedExitCode,
        [string]$Label
    )

    $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $validatorPath -RepoRoot $FixtureRoot 2>&1
    $exitCode = $LASTEXITCODE

    if ($exitCode -ne $ExpectedExitCode) {
        Write-Host $output
        throw "$Label expected exit code $ExpectedExitCode but got $exitCode."
    }

    Write-Ok "$Label exits with expected code $ExpectedExitCode."
    return ($output -join "`n")
}

function Set-FixtureFile {
    param(
        [string]$RelativePath,
        [string]$Content
    )

    $path = Join-Path $tempRoot ($RelativePath -replace '/', [System.IO.Path]::DirectorySeparatorChar)
    $parent = Split-Path -Parent $path
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
    Set-Content -LiteralPath $path -Value $Content -Encoding UTF8
}

$validProfile = @'
---
schema_version: profession-profile/v1
profession_id: test_profession
display_name: Test Profession
status: not_implemented
aliases:
  - test profession
mekhq_owned_fields:
  - current job/role
mek_rpg_overlay_fields:
  - purpose
  - allowed actions
allowed_actions: []
---

# Test Profession

## Purpose

Test profile that preserves the MekHQ-owned fact boundary.

## Typical Capabilities

- Test capability.

## Relevant MekHQ Fields

- current job/role

## Relevant RPG Skills

- Unknown.

## Allowed Actions

- None defined yet.

## Roll Rules

Not implemented.

## Data Access Limits

MekHQ-owned data may be used only through an action spec and reveal gate.

## Failure Modes

- Test failure.

## Not Yet Implemented

- Runtime lookup.

## Example Prompt/Interaction

Test example.

## Test Expectations

- Validator accepts the schema.
'@

try {
    Write-Test "Creating disposable profession profile fixture."
    New-Item -ItemType Directory -Force -Path $tempRoot | Out-Null

    Write-Test "Checking valid profile fixture."
    Set-FixtureFile -RelativePath "rules/professions/test-profession.md" -Content $validProfile
    $validOutput = Invoke-Validator -FixtureRoot $tempRoot -ExpectedExitCode 0 -Label "Valid profile"
    Assert-True -Condition ($validOutput -match "validation passed for 1 profile") -Message "Valid fixture reports one checked profile."

    Write-Test "Checking missing front matter fails."
    Set-FixtureFile -RelativePath "rules/professions/test-profession.md" -Content "# Test Profession`n"
    $missingFrontMatterOutput = Invoke-Validator -FixtureRoot $tempRoot -ExpectedExitCode 1 -Label "Missing front matter"
    Assert-True -Condition ($missingFrontMatterOutput -match "lacks YAML front matter") -Message "Missing front matter is reported."

    Write-Test "Checking missing heading fails."
    Set-FixtureFile -RelativePath "rules/professions/test-profession.md" -Content ($validProfile -replace "## Roll Rules\r?\n\r?\nNot implemented\.\r?\n\r?\n", "")
    $missingHeadingOutput = Invoke-Validator -FixtureRoot $tempRoot -ExpectedExitCode 1 -Label "Missing heading"
    Assert-True -Condition ($missingHeadingOutput -match "## Roll Rules") -Message "Missing required heading is reported."

    Write-Test "Checking empty required list fails."
    Set-FixtureFile -RelativePath "rules/professions/test-profession.md" -Content ($validProfile -replace "aliases:\r?\n  - test profession", "aliases: []")
    $emptyListOutput = Invoke-Validator -FixtureRoot $tempRoot -ExpectedExitCode 1 -Label "Empty aliases"
    Assert-True -Condition ($emptyListOutput -match "aliases") -Message "Empty required front matter list is reported."

    Write-Test "Checking duplicate profession id fails."
    Set-FixtureFile -RelativePath "rules/professions/test-profession.md" -Content $validProfile
    Set-FixtureFile -RelativePath "rules/professions/test-profession-copy.md" -Content ($validProfile -replace "# Test Profession", "# Test Profession Copy")
    $duplicateOutput = Invoke-Validator -FixtureRoot $tempRoot -ExpectedExitCode 1 -Label "Duplicate profession id"
    Assert-True -Condition ($duplicateOutput -match "duplicates profession_id") -Message "Duplicate profession id is reported."
}
finally {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
        Write-Ok "Disposable profession profile fixture removed."
    }
}

Write-Host ""
Write-Host "Profession profile validator tests passed."
