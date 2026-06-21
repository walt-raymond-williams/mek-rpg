param(
    [Parameter(Position = 0, Mandatory = $true)]
    [string]$Prompt,

    [int]$Top = 5,

    [ValidateSet("text", "json")]
    [string]$Format = "text",

    [string]$RepoRoot
)

$ErrorActionPreference = "Stop"

function Get-TextTokens {
    param([string]$Text)

    $stopWords = @(
        "a", "an", "and", "are", "can", "do", "does", "for", "from", "how", "i", "in", "is", "it", "of", "on", "or", "the", "to", "what", "when", "with"
    )

    $tokens = [regex]::Matches($Text.ToLowerInvariant(), '[a-z0-9][a-z0-9-]*') |
        ForEach-Object { $_.Value } |
        Where-Object { $_.Length -gt 1 -and $stopWords -notcontains $_ } |
        Sort-Object -Unique

    return @($tokens)
}

function Get-BacktickPathsFromText {
    param([string]$Text)

    [regex]::Matches($Text, '`([^`]+)`') |
        ForEach-Object { $_.Groups[1].Value.Trim() } |
        Where-Object {
            $_ -match '^(rules|gm|indexes|docs|scripts|campaign-state|campaigns)/' -or
            $_ -match '^(rules|gm|indexes|docs|scripts|campaign-state|campaigns)\\'
        }
}

function Get-RouterRows {
    param([string]$RouterPath)

    $rows = [System.Collections.Generic.List[object]]::new()
    $lines = Get-Content -LiteralPath $RouterPath

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($line -notmatch '^\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|\s*([^|]*?)\s*\|$') {
            continue
        }

        $question = $Matches[1].Trim()
        if ($question -eq "---" -or $question -eq "User question or task") {
            continue
        }

        $readFirst = $Matches[2].Trim()
        $alsoRead = $Matches[3].Trim()
        $files = @(
            (Get-BacktickPathsFromText -Text "$readFirst $alsoRead") |
                Where-Object { $_ -notmatch '<[^>]+>' } |
                Sort-Object -Unique
        )

        $rows.Add([pscustomobject]@{
            line = $i + 1
            question = $question
            read_first = $readFirst
            also_read = $alsoRead
            files = $files
            tokens = @(Get-TextTokens -Text $question)
        })
    }

    return $rows
}

function Get-ManifestEntries {
    param([string]$ManifestPath)

    $entries = [System.Collections.Generic.List[object]]::new()
    $currentSection = $null
    $currentEntry = $null
    $inMetadata = $false
    $lines = Get-Content -LiteralPath $ManifestPath

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]

        if ($line -match '^([A-Za-z_][A-Za-z0-9_-]*):\s*$') {
            $currentSection = $Matches[1]
            $currentEntry = $null
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
            }
            $entries.Add($currentEntry)
            continue
        }

        if ($null -eq $currentEntry) {
            continue
        }

        if ($line -match '^\s{4}(title|subsystem|summary|candidate|file|status):\s*(.*?)\s*$') {
            $currentEntry[$Matches[1]] = $Matches[2].Trim()
        }
    }

    foreach ($entry in $entries) {
        [pscustomobject]$entry
    }
}

function Get-PageReferenceRows {
    param([string]$PageReferencePath)

    $rows = @{}
    $lines = Get-Content -LiteralPath $PageReferencePath
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($line -notmatch '^\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|$') {
            continue
        }

        $paths = @(Get-BacktickPathsFromText -Text $Matches[2])
        foreach ($path in $paths) {
            if (-not $rows.ContainsKey($path)) {
                $rows[$path] = [pscustomobject]@{
                    line = $i + 1
                    topic = $Matches[1].Trim()
                    source_pages = $Matches[3].Trim()
                    status = $Matches[4].Trim()
                }
            }
        }
    }

    return $rows
}

function Get-ManifestForPath {
    param(
        [object[]]$ManifestEntries,
        [string]$Path
    )

    return @(
        $ManifestEntries | Where-Object {
            ($_.PSObject.Properties.Name.Contains("summary") -and $_.summary -eq $Path) -or
            ($_.PSObject.Properties.Name.Contains("file") -and $_.file -eq $Path) -or
            ($_.PSObject.Properties.Name.Contains("candidate") -and $_.candidate -eq $Path)
        }
    )
}

$repoRoot = if ($RepoRoot) {
    (Resolve-Path $RepoRoot).Path
}
else {
    (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

$routerPath = Join-Path $repoRoot "indexes\task-router.md"
$manifestPath = Join-Path $repoRoot "indexes\manifest.yaml"
$pageReferencePath = Join-Path $repoRoot "indexes\page-reference-index.md"

$promptTokens = @(Get-TextTokens -Text $Prompt)
$routerRows = @(Get-RouterRows -RouterPath $routerPath)
$manifestEntries = @(Get-ManifestEntries -ManifestPath $manifestPath)
$pageReferences = Get-PageReferenceRows -PageReferencePath $pageReferencePath

$matches = foreach ($row in $routerRows) {
    $tokenHits = @($row.tokens | Where-Object { $promptTokens -contains $_ })
    $phraseScore = 0
    $lowerPrompt = $Prompt.ToLowerInvariant()

    foreach ($token in $row.tokens) {
        if ($lowerPrompt.Contains($token)) {
            $phraseScore++
        }
    }

    $score = ($tokenHits.Count * 2) + $phraseScore
    if ($score -le 0) {
        continue
    }

    $fileReports = foreach ($file in $row.files) {
        $manifestMatches = @(Get-ManifestForPath -ManifestEntries $manifestEntries -Path $file)
        $pageRef = if ($pageReferences.ContainsKey($file)) { $pageReferences[$file] } else { $null }
        $statuses = @($manifestMatches | ForEach-Object { $_.status } | Sort-Object -Unique)
        $warnings = [System.Collections.Generic.List[string]]::new()

        if ($manifestMatches.Count -eq 0) {
            $warnings.Add("No manifest entry found for routed file.")
        }

        foreach ($status in $statuses) {
            if ($status -in @("mapped-only", "partial-draft", "source-lookup-only", "needs-source-review", "TBD")) {
                $warnings.Add("Manifest status '$status' is not full rules authority.")
            }
        }

        if ($null -eq $pageRef) {
            $warnings.Add("No page-reference entry found.")
        }
        elseif ($pageRef.status -match 'Mapped only|Partially covered|Source lookup only|needs source review') {
            $warnings.Add("Page reference status: $($pageRef.status)")
        }

        [pscustomobject]@{
            path = $file
            manifest_ids = @($manifestMatches | ForEach-Object { $_.id })
            statuses = $statuses
            source_pages = if ($null -ne $pageRef) { $pageRef.source_pages } else { "Unknown" }
            page_reference_status = if ($null -ne $pageRef) { $pageRef.status } else { "Unknown" }
            warnings = @($warnings)
        }
    }

    [pscustomobject]@{
        score = $score
        router_line = $row.line
        router_prompt = $row.question
        token_hits = $tokenHits
        files = @($fileReports)
    }
}

$ranked = @($matches | Sort-Object @{ Expression = "score"; Descending = $true }, @{ Expression = "router_line"; Descending = $false } | Select-Object -First $Top)
$report = [pscustomobject]@{
    prompt = $Prompt
    note = "Route helper only. Read the routed summaries and GM procedures before making a ruling; do not answer from this helper alone."
    source_boundary = "Uses committed indexes and manifest metadata only; protected source text and PDFs are not read."
    candidates = $ranked
}

if ($Format -eq "json") {
    $report | ConvertTo-Json -Depth 8
    exit 0
}

Write-Host "Rules route helper"
Write-Host "Prompt: $Prompt"
Write-Host "Note: Route helper only. Read the routed summaries and GM procedures before making a ruling."
Write-Host "Source boundary: committed indexes and manifest metadata only; protected source text and PDFs are not read."

if ($ranked.Count -eq 0) {
    Write-Host ""
    Write-Host "No router candidates matched. Start manually with indexes/task-router.md."
    exit 0
}

foreach ($candidate in $ranked) {
    Write-Host ""
    Write-Host "Score $($candidate.score), router line $($candidate.router_line): $($candidate.router_prompt)"
    Write-Host "Token hits: $(if ($candidate.token_hits.Count -gt 0) { $candidate.token_hits -join ', ' } else { 'None' })"
    Write-Host "Files to read:"
    foreach ($file in $candidate.files) {
        $statusText = if ($file.statuses.Count -gt 0) { $file.statuses -join ', ' } else { "Unknown" }
        Write-Host "- $($file.path) [$statusText] $($file.source_pages)"
        foreach ($warning in $file.warnings) {
            Write-Host "  WARN: $warning"
        }
    }
}

exit 0
