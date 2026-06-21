param(
    [ValidateSet("text", "json")]
    [string]$Format = "text",

    [string]$RepoRoot
)

$ErrorActionPreference = "Stop"

$validationReports = @{
    "core-resolution" = @("docs/current/CORE_LOOKUP_VALIDATION.md", "docs/current/DRAFT_COVERAGE_AND_HELPER_VALIDATION.md")
    "personal-combat" = @("docs/current/PERSONAL_COMBAT_LOOKUP_VALIDATION.md", "docs/current/DRAFT_COVERAGE_AND_HELPER_VALIDATION.md")
    "equipment" = @("docs/current/DRAFT_COVERAGE_AND_HELPER_VALIDATION.md")
    "character-creation" = @("docs/current/CHARACTER_CREATION_LOOKUP_VALIDATION.md")
    "campaign" = @("docs/current/CAMPAIGN_CONSEQUENCE_LOOKUP_VALIDATION.md")
    "vehicles-and-mechs" = @("docs/current/VEHICLE_MECHWARRIOR_BRIDGE_VALIDATION.md")
}

function Get-ManifestEntries {
    param([string]$ManifestPath)

    $entries = [System.Collections.Generic.List[object]]::new()
    $currentSection = $null
    $currentEntry = $null
    $currentListKey = $null
    $inMetadata = $false
    $lines = Get-Content -LiteralPath $ManifestPath

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        $lineNumber = $i + 1

        if ($line -match '^([A-Za-z_][A-Za-z0-9_-]*):\s*$') {
            $currentSection = $Matches[1]
            $currentEntry = $null
            $currentListKey = $null
            $inMetadata = $currentSection -eq "metadata"
            continue
        }

        if ($inMetadata) {
            continue
        }

        if ($line -match '^\s{2}-\s+id:\s*(.+?)\s*$') {
            $currentEntry = [ordered]@{
                section = $currentSection
                id = $Matches[1].Trim()
                line = $lineNumber
                related = [System.Collections.Generic.List[string]]::new()
            }
            $entries.Add($currentEntry)
            $currentListKey = $null
            continue
        }

        if ($null -eq $currentEntry) {
            continue
        }

        if ($line -match '^\s{4}(title|subsystem|summary|candidate|file|status):\s*(.*?)\s*$') {
            $key = $Matches[1]
            $value = $Matches[2].Trim()
            $currentEntry[$key] = $value
            $currentListKey = $null
            continue
        }

        if ($line -match '^\s{4}related:\s*$') {
            $currentListKey = "related"
            continue
        }

        if ($line -match '^\s{6}-\s+(.+?)\s*$' -and $currentListKey -eq "related") {
            $currentEntry.related.Add($Matches[1].Trim())
            continue
        }
    }

    foreach ($entry in $entries) {
        [pscustomobject]$entry
    }
}

function Get-CoverageClass {
    param(
        [string]$Status,
        [bool]$HasValidation
    )

    switch ($Status) {
        "draft" {
            if ($HasValidation) {
                return "drafted/routed with validation report"
            }

            return "drafted/routed"
        }
        "source-reviewed-routing-aid" { return "source-reviewed routing aid" }
        "mapped-only" { return "mapped-only placeholder" }
        "partial-draft" { return "partial draft; needs source review for mapped target" }
        "source-lookup-only" { return "source lookup only" }
        "needs-source-review" { return "needs source review" }
        "TBD" { return "TBD" }
        default { return "Unknown" }
    }
}

$repoRoot = if ($RepoRoot) {
    (Resolve-Path $RepoRoot).Path
}
else {
    (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

$manifestPath = Join-Path $repoRoot "indexes\manifest.yaml"
if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
    throw "Manifest not found: $manifestPath"
}

$entries = @(Get-ManifestEntries -ManifestPath $manifestPath)
$rulesEntries = @($entries | Where-Object { $_.section -in @("rules", "indexes", "mapped_rules") })
$gmEntries = @($entries | Where-Object { $_.section -eq "gm" })

$subsystems = @(
    $rulesEntries |
        ForEach-Object {
            if ($_.PSObject.Properties.Name.Contains("subsystem")) {
                $_.subsystem
            }
            elseif ($_.section -eq "indexes") {
                "indexes"
            }
            else {
                "Unknown"
            }
        } |
        Sort-Object -Unique
)

$subsystemReports = foreach ($subsystem in $subsystems) {
    $items = @(
        $rulesEntries | Where-Object {
            $entrySubsystem = if ($_.PSObject.Properties.Name.Contains("subsystem")) { $_.subsystem } elseif ($_.section -eq "indexes") { "indexes" } else { "Unknown" }
            $entrySubsystem -eq $subsystem
        }
    )

    $reports = @()
    if ($validationReports.ContainsKey($subsystem)) {
        $reports = @(
            $validationReports[$subsystem] | Where-Object {
                Test-Path -LiteralPath (Join-Path $repoRoot ($_ -replace '/', [System.IO.Path]::DirectorySeparatorChar)) -PathType Leaf
            }
        )
    }

    $statusCounts = @{}
    foreach ($item in $items) {
        $status = if ($item.PSObject.Properties.Name.Contains("status")) { $item.status } else { "Unknown" }
        if (-not $statusCounts.ContainsKey($status)) {
            $statusCounts[$status] = 0
        }
        $statusCounts[$status]++
    }

    $classes = @{}
    foreach ($item in $items) {
        $status = if ($item.PSObject.Properties.Name.Contains("status")) { $item.status } else { "Unknown" }
        $class = Get-CoverageClass -Status $status -HasValidation:($reports.Count -gt 0)
        if (-not $classes.ContainsKey($class)) {
            $classes[$class] = 0
        }
        $classes[$class]++
    }

    [pscustomobject]@{
        subsystem = $subsystem
        total = $items.Count
        statuses = [pscustomobject]$statusCounts
        coverage_classes = [pscustomobject]$classes
        validation_reports = $reports
        entries = @(
            $items | Sort-Object id | ForEach-Object {
                $status = if ($_.PSObject.Properties.Name.Contains("status")) { $_.status } else { "Unknown" }
                [pscustomobject]@{
                    id = $_.id
                    title = $_.title
                    status = $status
                    coverage_class = Get-CoverageClass -Status $status -HasValidation:($reports.Count -gt 0)
                    path = if ($_.PSObject.Properties.Name.Contains("summary")) { $_.summary } elseif ($_.PSObject.Properties.Name.Contains("file")) { $_.file } elseif ($_.PSObject.Properties.Name.Contains("candidate")) { $_.candidate } else { "Unknown" }
                }
            }
        )
    }
}

$statusTotals = @{}
foreach ($entry in $rulesEntries) {
    $status = if ($entry.PSObject.Properties.Name.Contains("status")) { $entry.status } else { "Unknown" }
    if (-not $statusTotals.ContainsKey($status)) {
        $statusTotals[$status] = 0
    }
    $statusTotals[$status]++
}

$report = [pscustomobject]@{
    repository = $repoRoot
    manifest = "indexes/manifest.yaml"
    scope = "Committed manifest/index metadata only; protected source files are not read."
    totals = [pscustomobject]@{
        covered_entries = $rulesEntries.Count
        gm_entries = $gmEntries.Count
        by_status = [pscustomobject]$statusTotals
    }
    subsystems = @($subsystemReports | Sort-Object subsystem)
}

if ($Format -eq "json") {
    $report | ConvertTo-Json -Depth 8
    exit 0
}

Write-Host "Rules coverage report"
Write-Host "Repository: $repoRoot"
Write-Host "Source: indexes/manifest.yaml"
Write-Host "Scope: committed manifest/index metadata only; protected source files are not read."
Write-Host ""
Write-Host "Totals"
Write-Host "- Coverage entries: $($report.totals.covered_entries)"
Write-Host "- GM entries: $($report.totals.gm_entries)"
foreach ($status in (($statusTotals.Keys) | Sort-Object)) {
    Write-Host "- ${status}: $($statusTotals[$status])"
}

Write-Host ""
Write-Host "Subsystems"
foreach ($subsystem in ($report.subsystems | Sort-Object subsystem)) {
    Write-Host ""
    Write-Host "[$($subsystem.subsystem)] $($subsystem.total) entr$(if ($subsystem.total -eq 1) { 'y' } else { 'ies' })"
    $classProperties = $subsystem.coverage_classes.PSObject.Properties | Sort-Object Name
    foreach ($property in $classProperties) {
        Write-Host "- $($property.Name): $($property.Value)"
    }

    if ($subsystem.validation_reports.Count -gt 0) {
        Write-Host "- validation reports: $($subsystem.validation_reports -join ', ')"
    }
    else {
        Write-Host "- validation reports: None recorded"
    }
}

exit 0
