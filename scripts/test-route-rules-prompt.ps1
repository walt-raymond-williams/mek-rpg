param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$helperPath = Join-Path $repoRoot "scripts\route-rules-prompt.ps1"
$fixturePath = Join-Path $repoRoot "tests\fixtures\rules-route-golden-prompts.fixture.json"

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

function Get-RouteFiles {
    param([object]$Report)

    return @($Report.candidates | ForEach-Object { $_.files })
}

Write-Test "Checking text route output for a ranged-cover prompt."
$textOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $helperPath "Can I shoot from cover?" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host $textOutput
    throw "Text route helper failed with exit code $LASTEXITCODE."
}

$text = $textOutput -join "`n"
Assert-True -Condition ($text -match "Rules route helper") -Message "Text output has helper heading."
Assert-True -Condition ($text -match "Read the routed summaries") -Message "Text output includes non-authority warning."
Assert-True -Condition ($text -match "rules/personal-combat/ranged-attacks.md") -Message "Text output routes shooting prompt to ranged attacks."

Write-Test "Checking JSON route output for a tactical prompt."
$jsonOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $helperPath "BattleMech heat and tactical movement" -Format json 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host $jsonOutput
    throw "JSON route helper failed with exit code $LASTEXITCODE."
}

$report = ($jsonOutput -join "`n") | ConvertFrom-Json
Assert-True -Condition ($report.mode -eq "rules_lookup") -Message "JSON output identifies rules lookup mode."
Assert-True -Condition ($report.candidates.Count -gt 0) -Message "JSON output has route candidates."
$allPaths = @($report.candidates | ForEach-Object { $_.files } | ForEach-Object { $_.path })
Assert-True -Condition ($allPaths -contains "gm/switch-to-classic-battletech.md") -Message "JSON tactical prompt routes to tactical handoff."

Write-Test "Checking fixture-driven golden route prompts."
$fixture = Get-Content -LiteralPath $fixturePath -Raw | ConvertFrom-Json
Assert-True -Condition ($fixture.schema -eq "mek-rpg.rules-route-golden-prompts.v1") -Message "Golden route fixture schema is recognized."

foreach ($case in @($fixture.cases)) {
    $caseOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $helperPath $case.prompt -Top $case.top -Format json 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host $caseOutput
        throw "Golden route case '$($case.id)' failed with exit code $LASTEXITCODE."
    }

    $caseReport = ($caseOutput -join "`n") | ConvertFrom-Json
    Assert-True -Condition ($caseReport.mode -eq "rules_lookup") -Message "Case '$($case.id)' reports rules lookup mode."
    Assert-True -Condition ($caseReport.source_boundary -match "protected source text and PDFs are not read") -Message "Case '$($case.id)' preserves protected-source boundary."

    if ($case.PSObject.Properties.Name.Contains("expect_no_candidates") -and $case.expect_no_candidates) {
        Assert-True -Condition (@($caseReport.candidates).Count -eq 0) -Message "Case '$($case.id)' returns no candidates for missing route."
        continue
    }

    Assert-True -Condition (@($caseReport.candidates).Count -gt 0) -Message "Case '$($case.id)' returns route candidates."
    $routeFiles = @(Get-RouteFiles -Report $caseReport)
    $matchedFiles = @($routeFiles | Where-Object { $_.path -eq $case.expected_path })
    Assert-True -Condition ($matchedFiles.Count -gt 0) -Message "Case '$($case.id)' includes expected route file $($case.expected_path)."

    $matchedFile = $matchedFiles[0]
    $statuses = @($matchedFile.statuses | Where-Object { $_ })
    if ($case.expected_status -eq "Unknown") {
        Assert-True -Condition ($statuses.Count -eq 0) -Message "Case '$($case.id)' reports expected manifest status Unknown."
    }
    else {
        Assert-True -Condition ($statuses -contains $case.expected_status) -Message "Case '$($case.id)' reports expected manifest status $($case.expected_status)."
    }
    Assert-True -Condition ($matchedFile.page_reference_status -eq $case.expected_page_reference_status) -Message "Case '$($case.id)' reports expected page-reference status."
    Assert-True -Condition ($matchedFile.source_pages -like "*$($case.expected_source_pages_contains)*") -Message "Case '$($case.id)' reports expected source-page text."

    $warnings = @($matchedFile.warnings | Where-Object { $_ })
    if ($case.expect_warnings) {
        Assert-True -Condition ($warnings.Count -gt 0) -Message "Case '$($case.id)' surfaces route warnings."
        if ($case.PSObject.Properties.Name.Contains("expected_warning_contains")) {
            Assert-True -Condition (($warnings -join "`n") -like "*$($case.expected_warning_contains)*") -Message "Case '$($case.id)' includes expected warning text."
        }
    }
    else {
        Assert-True -Condition ($warnings.Count -eq 0) -Message "Case '$($case.id)' has no warnings for expected draft route."
    }
}

Write-Host ""
Write-Host "Rules route helper tests passed."
