param(
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$Prompt,

    [int]$Top = 5,

    [ValidateSet("text", "json")]
    [string]$Format = "text",

    [string]$RepoRoot
)

$ErrorActionPreference = "Stop"

function ConvertTo-StatusLabel {
    param([string]$Status)

    switch ($Status) {
        "authoritative" { return "authoritative" }
        "provisional" { return "provisional" }
        "source_lookup_required" { return "source lookup required" }
        "external_authority_required" { return "external authority required" }
        "cannot_adjudicate" { return "cannot adjudicate" }
        "blocked_missing_route" { return "blocked / missing route" }
        default { return $Status }
    }
}

function New-Warning {
    param(
        [string]$Code,
        [string]$Severity,
        [string]$Message,
        [string]$Path = $null
    )

    [pscustomobject]@{
        code = $Code
        severity = $Severity
        message = $Message
        path = $Path
    }
}

function Test-ExternalPath {
    param([string]$Path)

    return (
        $Path -eq "gm/switch-to-classic-battletech.md" -or
        $Path -eq "gm/tactical-encounter-handoff-checklist.md" -or
        $Path -like "rules/tactical/*"
    )
}

function Test-InfrastructurePath {
    param([string]$Path)

    return (
        $Path -eq "indexes/task-router.md" -or
        $Path -eq "indexes/page-reference-index.md" -or
        $Path -eq "indexes/source-precedence.md"
    )
}

function Test-ContextPath {
    param([string]$Path)

    return (
        $Path -eq "campaign-state/active-campaign.md" -or
        $Path -like "campaigns/<campaign-id>/*"
    )
}

function Get-AuthorityDecision {
    param(
        [object]$RouteReport,
        [string]$Prompt
    )

    $allCandidates = @($RouteReport.candidates)
    if ($allCandidates.Count -eq 0) {
        return [pscustomobject]@{
            status = "blocked_missing_route"
            confidence = "none"
            external_authority = $null
            failure_mode = "blocked_missing_route"
            required_next_action = "Start manually with indexes/task-router.md or add routing metadata before making a rules answer."
            warnings = @(
                New-Warning -Code "missing-route" -Severity "blocker" -Message "No router candidates matched the prompt."
            )
        }
    }

    $primary = $allCandidates[0]
    $files = @($primary.files)
    $statuses = @($files | ForEach-Object { $_.statuses } | Where-Object { $_ } | Sort-Object -Unique)
    $paths = @($files | ForEach-Object { $_.path })
    $pageStatuses = @($files | ForEach-Object { $_.page_reference_status } | Where-Object { $_ } | Sort-Object -Unique)
    $fileWarnings = @($files | ForEach-Object { $_.warnings } | Where-Object { $_ })
    $warnings = [System.Collections.Generic.List[object]]::new()

    foreach ($file in $files) {
        foreach ($warning in @($file.warnings | Where-Object { $_ })) {
            $warnings.Add((New-Warning -Code "route-warning" -Severity "caution" -Message $warning -Path $file.path))
        }
    }

    foreach ($status in $statuses) {
        if ($status -eq "draft") {
            $warnings.Add((New-Warning -Code "draft-summary" -Severity "caution" -Message "Draft summaries can support source-aware play, but the ruling remains provisional."))
        }
        elseif ($status -eq "source-reviewed-routing-aid") {
            $warnings.Add((New-Warning -Code "routing-aid" -Severity "caution" -Message "Source-reviewed routing aids locate or frame authority; they are not complete rules procedures by themselves."))
        }
        elseif ($status -in @("mapped-only", "partial-draft", "source-lookup-only", "needs-source-review", "TBD")) {
            $warnings.Add((New-Warning -Code "insufficient-summary-status" -Severity "blocker" -Message "Manifest status '$status' requires source lookup or source review before adjudication."))
        }
    }

    $lowerPrompt = $Prompt.ToLowerInvariant()
    $lowerRouterPrompt = $primary.router_prompt.ToLowerInvariant()
    $sourceLookupCue = (
        $lowerPrompt -match 'record sheet|reference table|exact stat|weapon stat|armor value|item table|catalog table|source lookup' -or
        $lowerRouterPrompt -match 'record sheet|reference table|technical readout|sourcebook|which battletech book'
    )
    $authorityPolicyCue = (
        $lowerRouterPrompt -match 'source conflict|source precedence|which source wins|gm ruling|temporary ruling|source authority|fiction versus rules' -or
        $lowerPrompt -match 'source precedence|which source wins|authority gate|ruling authority'
    )
    $externalCue = (
        $lowerPrompt -match 'battlemech fight|hex movement|full tactical|tactical combat|mekhq ledger|hard ledger'
    )
    $sourceStatusCue = (
        ($statuses | Where-Object { $_ -in @("mapped-only", "partial-draft", "source-lookup-only", "needs-source-review", "TBD") }).Count -gt 0 -or
        ($pageStatuses | Where-Object { $_ -match 'Mapped only|Partially covered|Source lookup only|needs source review' }).Count -gt 0
    )
    $unknownNonInfrastructure = @(
        $files | Where-Object {
            @($_.manifest_ids).Count -eq 0 -and
            $_.page_reference_status -eq "Unknown" -and
            -not (Test-InfrastructurePath -Path $_.path) -and
            -not (Test-ContextPath -Path $_.path)
        }
    )

    if ($sourceLookupCue -or $sourceStatusCue) {
        $warnings.Add((New-Warning -Code "source-lookup-required" -Severity "blocker" -Message "Committed metadata points to private source lookup, table-heavy material, or incomplete source review."))
        return [pscustomobject]@{
            status = "source_lookup_required"
            confidence = "high"
            external_authority = [pscustomobject]@{
                kind = "private_source_lookup"
                owner = "User with legally owned source or source-review task"
            }
            failure_mode = "source_lookup_required"
            required_next_action = "Inspect the cited private source pages, supply the exact table/stat data, or create source-review follow-up before adjudicating."
            warnings = @($warnings)
        }
    }

    if ($authorityPolicyCue) {
        return [pscustomobject]@{
            status = "authoritative"
            confidence = "medium"
            external_authority = $null
            failure_mode = $null
            required_next_action = "Use the routed authority and adjudication procedures to decide which source owns the fact; do not answer a separate rules procedure from this gate alone."
            warnings = @($warnings)
        }
    }

    if ($externalCue) {
        $warnings.Add((New-Warning -Code "external-authority" -Severity "blocker" -Message "Exact tactical or hard-ledger resolution belongs to Classic BattleTech, MegaMek, MekHQ, or the table-selected external authority."))
        return [pscustomobject]@{
            status = "external_authority_required"
            confidence = "high"
            external_authority = [pscustomobject]@{
                kind = "tactical_or_hard_ledger"
                owner = "Classic BattleTech, MegaMek, MekHQ, or table-selected tactical/ledger authority"
            }
            failure_mode = "external_authority_required"
            required_next_action = "Prepare the appropriate tactical/MekHQ handoff instead of resolving this as a MEK-RPG rules answer."
            warnings = @($warnings)
        }
    }

    if ($unknownNonInfrastructure.Count -gt 0) {
        $warnings.Add((New-Warning -Code "missing-metadata" -Severity "blocker" -Message "At least one primary routed file has no manifest or page-reference metadata."))
        return [pscustomobject]@{
            status = "cannot_adjudicate"
            confidence = "none"
            external_authority = $null
            failure_mode = "cannot_adjudicate"
            required_next_action = "Add or repair route, manifest, and page-reference metadata before using this route for a ruling."
            warnings = @($warnings)
        }
    }

    if ($statuses -contains "draft") {
        return [pscustomobject]@{
            status = "provisional"
            confidence = "medium"
            external_authority = $null
            failure_mode = $null
            required_next_action = "Read the routed committed summaries and make a cautious GM ruling with citations and uncertainty preserved."
            warnings = @($warnings)
        }
    }

    return [pscustomobject]@{
        status = "cannot_adjudicate"
        confidence = "low"
        external_authority = $null
        failure_mode = "cannot_adjudicate"
        required_next_action = "Review routing metadata manually before making a ruling."
        warnings = @($warnings)
    }
}

$repoRoot = if ($RepoRoot) {
    (Resolve-Path $RepoRoot).Path
}
else {
    (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

$routeHelper = Join-Path $PSScriptRoot "route-rules-prompt.ps1"
$routeJson = & powershell -NoProfile -ExecutionPolicy Bypass -File $routeHelper $Prompt -Top $Top -Format json -RepoRoot $repoRoot 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host $routeJson
    throw "Route helper failed with exit code $LASTEXITCODE."
}

$routeReport = ($routeJson -join "`n") | ConvertFrom-Json
$decision = Get-AuthorityDecision -RouteReport $routeReport -Prompt $Prompt
$primaryCandidate = if (@($routeReport.candidates).Count -gt 0) { @($routeReport.candidates)[0] } else { $null }
$primaryFiles = if ($null -ne $primaryCandidate) { @($primaryCandidate.files) } else { @() }

$routedFiles = @(
    $primaryFiles | ForEach-Object {
        [pscustomobject]@{
            path = $_.path
            manifest_ids = @($_.manifest_ids)
            statuses = @($_.statuses)
            source_pages = $_.source_pages
            page_reference_status = $_.page_reference_status
            warnings = @($_.warnings)
        }
    }
)

$manifestEntries = @(
    $primaryFiles | ForEach-Object {
        $file = $_
        foreach ($id in @($file.manifest_ids)) {
            [pscustomobject]@{
                id = $id
                path = $file.path
                statuses = @($file.statuses)
            }
        }
    }
)

$sourcePages = @(
    $primaryFiles |
        Where-Object { $_.source_pages -and $_.source_pages -ne "Unknown" } |
        ForEach-Object {
            [pscustomobject]@{
                path = $_.path
                source_pages = $_.source_pages
                page_reference_status = $_.page_reference_status
            }
        }
)

$report = [pscustomobject]@{
    schema_version = "0.1"
    prompt = $Prompt
    mode = "rules_lookup_authority_gate"
    status = $decision.status
    status_label = ConvertTo-StatusLabel -Status $decision.status
    confidence = $decision.confidence
    primary_candidate = $primaryCandidate
    routed_files = $routedFiles
    manifest_entries = $manifestEntries
    source_pages = $sourcePages
    source_boundary = [pscustomobject]@{
        protected_source_read = $false
        copied_table_or_stat_block = $false
        notes = "Uses committed route helper output, manifest metadata, and page-reference metadata only."
    }
    external_authority = $decision.external_authority
    warnings = @($decision.warnings)
    failure_mode = $decision.failure_mode
    required_next_action = $decision.required_next_action
    route_note = $routeReport.note
}

if ($Format -eq "json") {
    $report | ConvertTo-Json -Depth 10
    exit 0
}

Write-Host "Ruling authority gate"
Write-Host "Prompt: $Prompt"
Write-Host "Mode: rules_lookup_authority_gate"
Write-Host "Authority: $($report.status_label)"
Write-Host "Confidence: $($report.confidence)"
Write-Host "Required next action: $($report.required_next_action)"
Write-Host "Source boundary: committed metadata only; protected source text and PDFs are not read."

if ($null -eq $primaryCandidate) {
    Write-Host ""
    Write-Host "No route candidate matched."
    exit 0
}

Write-Host ""
Write-Host "Primary route line $($primaryCandidate.router_line): $($primaryCandidate.router_prompt)"
Write-Host "Routed files:"
foreach ($file in $routedFiles) {
    $statusText = if (@($file.statuses).Count -gt 0) { @($file.statuses) -join ", " } else { "Unknown" }
    Write-Host "- $($file.path) [$statusText] $($file.source_pages)"
}

if (@($report.warnings).Count -gt 0) {
    Write-Host ""
    Write-Host "Warnings:"
    foreach ($warning in @($report.warnings)) {
        $pathText = if ($warning.path) { " ($($warning.path))" } else { "" }
        Write-Host "- $($warning.severity): $($warning.code)$pathText - $($warning.message)"
    }
}

exit 0
