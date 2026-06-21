param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$helperPath = Join-Path $repoRoot "scripts\check-ruling-authority.ps1"

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

function Invoke-GateJson {
    param(
        [string]$Prompt,
        [string]$RepoRootOverride = $null
    )

    $args = @($Prompt, "-Format", "json")
    if ($RepoRootOverride) {
        $args += @("-RepoRoot", $RepoRootOverride)
    }

    $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $helperPath @args 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host $output
        throw "Authority gate failed for prompt '$Prompt' with exit code $LASTEXITCODE."
    }

    return (($output -join "`n") | ConvertFrom-Json)
}

function Write-MinimalRouterFixture {
    param([string]$FixtureRoot)

    New-Item -ItemType Directory -Force -Path (Join-Path $FixtureRoot "indexes") | Out-Null
    @"
# Task Router

| User question or task | Read first | Also read |
| --- | --- | --- |
| fixture mapped only route | ``rules/test/mapped.md`` | |
| fixture partial draft route | ``rules/test/partial.md`` | |
| fixture source lookup route | ``rules/test/source-lookup.md`` | |
| fixture needs source review route | ``rules/test/needs-review.md`` | |
| fixture source reviewed route | ``rules/test/source-reviewed.md`` | |
| fixture missing metadata route | ``rules/test/missing.md`` | |
"@ | Set-Content -LiteralPath (Join-Path $FixtureRoot "indexes\task-router.md") -Encoding UTF8

    @"
metadata:
  purpose: Minimal authority gate test fixture.
rules:
  - id: fixture.mapped
    title: Fixture Mapped
    summary: rules/test/mapped.md
    status: mapped-only
  - id: fixture.partial
    title: Fixture Partial
    summary: rules/test/partial.md
    status: partial-draft
  - id: fixture.source-lookup
    title: Fixture Source Lookup
    summary: rules/test/source-lookup.md
    status: source-lookup-only
  - id: fixture.needs-review
    title: Fixture Needs Review
    summary: rules/test/needs-review.md
    status: needs-source-review
  - id: fixture.source-reviewed
    title: Fixture Source Reviewed
    summary: rules/test/source-reviewed.md
    status: source-reviewed-routing-aid
"@ | Set-Content -LiteralPath (Join-Path $FixtureRoot "indexes\manifest.yaml") -Encoding UTF8

    @"
# Page Reference Index

| Topic | Summary file | Source pages | Status |
| --- | --- | --- | --- |
| Fixture mapped | ``rules/test/mapped.md`` | Fixture pages 1-2 | Mapped only |
| Fixture partial | ``rules/test/partial.md`` | Fixture pages 3-4 | Partially covered |
| Fixture source lookup | ``rules/test/source-lookup.md`` | Fixture pages 5-6 | Source lookup only |
| Fixture needs review | ``rules/test/needs-review.md`` | Fixture pages 7-8 | needs source review |
| Fixture source reviewed | ``rules/test/source-reviewed.md`` | Fixture pages 9-10 | Source-reviewed routing aid |
"@ | Set-Content -LiteralPath (Join-Path $FixtureRoot "indexes\page-reference-index.md") -Encoding UTF8
}

Write-Test "Checking text output for a provisional draft route."
$textOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $helperPath "Can I shoot from cover?" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host $textOutput
    throw "Text authority gate failed with exit code $LASTEXITCODE."
}
$text = $textOutput -join "`n"
Assert-True -Condition ($text -match "Ruling authority gate") -Message "Text output has authority heading."
Assert-True -Condition ($text -match "Authority: provisional") -Message "Text output reports provisional authority."
Assert-True -Condition ($text -match "protected source text and PDFs are not read") -Message "Text output preserves protected-source boundary."

Write-Test "Checking live repository authority statuses."
$provisional = Invoke-GateJson -Prompt "ranged attacks shooting line of sight burst fire"
Assert-True -Condition ($provisional.mode -eq "rules_lookup_authority_gate") -Message "JSON output reports authority gate mode."
Assert-True -Condition ($provisional.status -eq "provisional") -Message "Draft summary route is provisional."
Assert-True -Condition (@($provisional.routed_files).path -contains "rules/personal-combat/ranged-attacks.md") -Message "Provisional route includes ranged attack summary."
Assert-True -Condition (($provisional.warnings | ForEach-Object { $_.code }) -contains "draft-summary") -Message "Provisional route carries draft warning."

$external = Invoke-GateJson -Prompt "This BattleMech fight needs heat and hex movement"
Assert-True -Condition ($external.status -eq "external_authority_required") -Message "Tactical prompt requires external authority."
Assert-True -Condition ($null -ne $external.external_authority) -Message "External authority details are reported."
Assert-True -Condition (($external.warnings | ForEach-Object { $_.code }) -contains "external-authority") -Message "External route carries blocker warning."

$missing = Invoke-GateJson -Prompt "How do I resolve quantum hacking magic?"
Assert-True -Condition ($missing.status -eq "blocked_missing_route") -Message "Missing route is blocked."
Assert-True -Condition ($missing.failure_mode -eq "blocked_missing_route") -Message "Missing route reports failure mode."

$sourceLookup = Invoke-GateJson -Prompt "Where are record sheet reference tables?"
Assert-True -Condition ($sourceLookup.status -eq "source_lookup_required") -Message "Record-sheet/table prompt requires source lookup."
Assert-True -Condition ($sourceLookup.failure_mode -eq "source_lookup_required") -Message "Source lookup route reports failure mode."

$authority = Invoke-GateJson -Prompt "source conflict source precedence which source wins"
Assert-True -Condition ($authority.status -eq "authoritative") -Message "Source precedence route is authoritative for authority selection."
Assert-True -Condition ($authority.required_next_action -match "source owns the fact") -Message "Authoritative route explains the limited next action."

Write-Test "Checking status-specific fixture routes."
$fixtureRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("mek-rpg-authority-fixture-" + [System.Guid]::NewGuid().ToString("N"))
try {
    Write-MinimalRouterFixture -FixtureRoot $fixtureRoot

    $mapped = Invoke-GateJson -Prompt "fixture mapped only route" -RepoRootOverride $fixtureRoot
    Assert-True -Condition ($mapped.status -eq "source_lookup_required") -Message "Mapped-only status requires source lookup."

    $partial = Invoke-GateJson -Prompt "fixture partial draft route" -RepoRootOverride $fixtureRoot
    Assert-True -Condition ($partial.status -eq "source_lookup_required") -Message "Partial-draft status requires source lookup."

    $sourceOnly = Invoke-GateJson -Prompt "fixture source lookup route" -RepoRootOverride $fixtureRoot
    Assert-True -Condition ($sourceOnly.status -eq "source_lookup_required") -Message "Source-lookup-only status requires source lookup."

    $needsReview = Invoke-GateJson -Prompt "fixture needs source review route" -RepoRootOverride $fixtureRoot
    Assert-True -Condition ($needsReview.status -eq "source_lookup_required") -Message "Needs-source-review status requires source lookup."

    $routingAid = Invoke-GateJson -Prompt "fixture source reviewed route" -RepoRootOverride $fixtureRoot
    Assert-True -Condition ($routingAid.status -eq "cannot_adjudicate") -Message "Source-reviewed routing aid alone is not enough to adjudicate."

    $missingMetadata = Invoke-GateJson -Prompt "fixture missing metadata route" -RepoRootOverride $fixtureRoot
    Assert-True -Condition ($missingMetadata.status -eq "cannot_adjudicate") -Message "Missing metadata route cannot adjudicate."
}
finally {
    if (Test-Path -LiteralPath $fixtureRoot) {
        Remove-Item -LiteralPath $fixtureRoot -Recurse -Force
        Write-Ok "Disposable authority fixture removed."
    }
}

Write-Host ""
Write-Host "Ruling authority gate tests passed."
