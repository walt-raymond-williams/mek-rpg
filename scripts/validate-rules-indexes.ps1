param(
    [string]$RepoRoot
)

$ErrorActionPreference = "Stop"

$script:ErrorCount = 0
$script:WarningCount = 0

$allowedStatuses = @(
    "draft",
    "source-reviewed-routing-aid",
    "mapped-only",
    "partial-draft",
    "source-lookup-only",
    "needs-source-review",
    "TBD"
)

function Write-Ok {
    param([string]$Message)
    Write-Host "OK: $Message"
}

function Write-Warn {
    param([string]$Message)
    $script:WarningCount++
    Write-Host "WARN: $Message"
}

function Write-Fail {
    param([string]$Message)
    $script:ErrorCount++
    Write-Host "FAIL: $Message"
}

function Resolve-RepoPath {
    param(
        [string]$Root,
        [string]$RelativePath
    )

    return Join-Path $Root ($RelativePath -replace '/', [System.IO.Path]::DirectorySeparatorChar)
}

function Test-RepoPathExists {
    param(
        [string]$Root,
        [string]$RelativePath,
        [string]$Context,
        [switch]$WarnOnly
    )

    if ([string]::IsNullOrWhiteSpace($RelativePath)) {
        Write-Fail "$Context has an empty path."
        return
    }

    if ($RelativePath -match '<[^>]+>' -or $RelativePath -eq "Source lookup only") {
        Write-Warn "$Context uses a placeholder or source-only path: $RelativePath"
        return
    }

    $resolved = Resolve-RepoPath -Root $Root -RelativePath $RelativePath
    $exists = Test-Path -LiteralPath $resolved

    if ($exists) {
        Write-Ok "$Context path exists: $RelativePath"
        return
    }

    if ($WarnOnly) {
        Write-Warn "$Context candidate path not present yet: $RelativePath"
    }
    else {
        Write-Fail "$Context path missing: $RelativePath"
    }
}

function ConvertTo-PageNumbers {
    param([string]$Text)

    $pages = [System.Collections.Generic.List[int]]::new()
    if ([string]::IsNullOrWhiteSpace($Text)) {
        return @()
    }

    $matches = [regex]::Matches($Text, '\d+(?:\s*-\s*\d+)?')
    foreach ($match in $matches) {
        $value = $match.Value -replace '\s+', ''
        if ($value -match '^(\d+)-(\d+)$') {
            $start = [int]$Matches[1]
            $end = [int]$Matches[2]
            if ($end -lt $start) {
                continue
            }

            for ($page = $start; $page -le $end; $page++) {
                $pages.Add($page)
            }
        }
        else {
            $pages.Add([int]$value)
        }
    }

    return @($pages | Sort-Object -Unique)
}

function Get-SourcePagesFromText {
    param(
        [string]$Text,
        [ValidateSet("pdf", "printed")]
        [string]$Kind
    )

    if ([string]::IsNullOrWhiteSpace($Text)) {
        return @()
    }

    $pattern = if ($Kind -eq "pdf") {
        'PDF page(?:s)?\s+(.+?)(?:\s*/\s*printed|\s*$)'
    }
    else {
        'printed page(?:s)?\s+(.+?)(?:\.|\s*$)'
    }

    $matches = [regex]::Matches($Text, $pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $pages = [System.Collections.Generic.List[int]]::new()
    foreach ($match in $matches) {
        foreach ($page in (ConvertTo-PageNumbers -Text $match.Groups[1].Value)) {
            $pages.Add($page)
        }
    }

    return @($pages | Sort-Object -Unique)
}

function Test-Subset {
    param(
        [int[]]$ExpectedSubset,
        [int[]]$ActualSuperset
    )

    foreach ($page in @($ExpectedSubset)) {
        if (@($ActualSuperset) -notcontains $page) {
            return $false
        }
    }

    return $true
}

function Format-PageList {
    param([int[]]$Pages)

    if (@($Pages).Count -eq 0) {
        return "none"
    }

    return (@($Pages) | Sort-Object -Unique) -join ", "
}

function Get-BacktickPaths {
    param([string]$Text)

    $matches = [regex]::Matches($Text, '`([^`]+)`')
    foreach ($match in $matches) {
        $value = $match.Groups[1].Value.Trim()
        if ($value -match '^(rules|gm|indexes|docs|scripts|campaign-state|campaigns)/' -or
            $value -match '^(rules|gm|indexes|docs|scripts|campaign-state|campaigns)\\') {
            [pscustomobject]@{
                Path = $value
                Line = $null
            }
        }
    }
}

function Get-IndexedBacktickPaths {
    param([string]$Path)

    $lines = Get-Content -LiteralPath $Path
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        $matches = [regex]::Matches($line, '`([^`]+)`')
        foreach ($match in $matches) {
            $value = $match.Groups[1].Value.Trim()
            if ($value -match '^(rules|gm|indexes|docs|scripts|campaign-state|campaigns)/' -or
                $value -match '^(rules|gm|indexes|docs|scripts|campaign-state|campaigns)\\') {
                [pscustomobject]@{
                    Path = $value
                    Line = $i + 1
                    Text = $line
                }
            }
        }
    }
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
                Section = $currentSection
                Id = $Matches[1].Trim()
                Line = $lineNumber
                Related = [System.Collections.Generic.List[string]]::new()
                HasPdfPages = $false
                HasPrintedPages = $false
                PdfPages = @()
                PrintedPages = @()
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
            $currentEntry.Related.Add($Matches[1].Trim())
            continue
        }

        if ($line -match '^\s{6}pdf:\s*\[(.*?)\]\s*$') {
            $currentEntry.HasPdfPages = -not [string]::IsNullOrWhiteSpace($Matches[1])
            $currentEntry.PdfPages = @(ConvertTo-PageNumbers -Text $Matches[1])
            continue
        }

        if ($line -match '^\s{6}printed:\s*\[(.*?)\]\s*$') {
            $currentEntry.HasPrintedPages = -not [string]::IsNullOrWhiteSpace($Matches[1])
            $currentEntry.PrintedPages = @(ConvertTo-PageNumbers -Text $Matches[1])
            continue
        }
    }

    foreach ($entry in $entries) {
        [pscustomobject]$entry
    }
}

function Get-PageReferenceRows {
    param([string]$PageReferencePath)

    $rows = [System.Collections.Generic.List[object]]::new()
    $lines = Get-Content -LiteralPath $PageReferencePath
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        if ($line -notmatch '^\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|\s*([^|]+?)\s*\|$') {
            continue
        }

        $topic = $Matches[1].Trim()
        if ($topic -eq "---" -or $topic -eq "Topic") {
            continue
        }

        $sourcePages = $Matches[3].Trim()
        foreach ($pathInfo in (Get-BacktickPaths -Text $Matches[2])) {
            $rows.Add([pscustomobject]@{
                Line = $i + 1
                Topic = $topic
                Path = $pathInfo.Path
                SourcePages = $sourcePages
                Status = $Matches[4].Trim()
                PdfPages = @(Get-SourcePagesFromText -Text $sourcePages -Kind pdf)
                PrintedPages = @(Get-SourcePagesFromText -Text $sourcePages -Kind printed)
            })
        }
    }

    return $rows
}

$repoRoot = if ($RepoRoot) {
    (Resolve-Path $RepoRoot).Path
}
else {
    (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

$taskRouterPath = Join-Path $repoRoot "indexes\task-router.md"
$rulesMapPath = Join-Path $repoRoot "indexes\rules-map.md"
$pageReferencePath = Join-Path $repoRoot "indexes\page-reference-index.md"
$manifestPath = Join-Path $repoRoot "indexes\manifest.yaml"
$extractionNotesPath = Join-Path $repoRoot "source\extraction-notes.md"
$chapterSectionMapPath = Join-Path $repoRoot "source\atow-chapter-section-map.md"

Write-Host "Rules index validation"
Write-Host "Repository: $repoRoot"
Write-Host ""

foreach ($requiredPath in @($taskRouterPath, $rulesMapPath, $pageReferencePath, $manifestPath)) {
    if (Test-Path -LiteralPath $requiredPath -PathType Leaf) {
        Write-Ok "Required index exists: $([System.IO.Path]::GetFileName($requiredPath))"
    }
    else {
        Write-Fail "Required index missing: $requiredPath"
    }
}

if ($script:ErrorCount -eq 0) {
    Write-Host ""
    Write-Host "Checking source offset metadata"

    if (Test-Path -LiteralPath $extractionNotesPath -PathType Leaf) {
        $extractionNotesText = Get-Content -LiteralPath $extractionNotesPath -Raw
        if ($extractionNotesText -match 'PDF page = printed page \+ 2') {
            Write-Ok "Extraction notes record PDF-to-printed page offset."
        }
        else {
            Write-Fail "Extraction notes do not record expected PDF-to-printed page offset."
        }
    }
    else {
        Write-Fail "Extraction notes missing: source/extraction-notes.md"
    }

    if (Test-Path -LiteralPath $chapterSectionMapPath -PathType Leaf) {
        $chapterMapText = Get-Content -LiteralPath $chapterSectionMapPath -Raw
        if ($chapterMapText -match 'PDF page = printed page \+ 2') {
            Write-Ok "Chapter/section map records PDF-to-printed page offset."
        }
        else {
            Write-Fail "Chapter/section map does not record expected PDF-to-printed page offset."
        }
    }
    else {
        Write-Fail "Chapter/section map missing: source/atow-chapter-section-map.md"
    }

    Write-Host ""
    Write-Host "Checking router and rules-map links"

    foreach ($pathInfo in (Get-IndexedBacktickPaths -Path $taskRouterPath)) {
        Test-RepoPathExists -Root $repoRoot -RelativePath $pathInfo.Path -Context "Task router line $($pathInfo.Line)"
    }

    foreach ($pathInfo in (Get-IndexedBacktickPaths -Path $rulesMapPath)) {
        Test-RepoPathExists -Root $repoRoot -RelativePath $pathInfo.Path -Context "Rules map line $($pathInfo.Line)"
    }

    Write-Host ""
    Write-Host "Checking page-reference linked files"

    $pageReferenceText = Get-Content -LiteralPath $pageReferencePath -Raw
    $pageReferenceRows = @(Get-PageReferenceRows -PageReferencePath $pageReferencePath)
    $pageReferenceRowsByPath = @{}
    $pageReferencePaths = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($pathInfo in (Get-IndexedBacktickPaths -Path $pageReferencePath)) {
        [void]$pageReferencePaths.Add($pathInfo.Path)
        $warnOnly = $pathInfo.Text -match 'Mapped only|Partially covered|Source lookup only|candidate'
        Test-RepoPathExists -Root $repoRoot -RelativePath $pathInfo.Path -Context "Page reference line $($pathInfo.Line)" -WarnOnly:$warnOnly
    }

    foreach ($row in $pageReferenceRows) {
        if (-not $pageReferenceRowsByPath.ContainsKey($row.Path)) {
            $pageReferenceRowsByPath[$row.Path] = [System.Collections.Generic.List[object]]::new()
        }

        $pageReferenceRowsByPath[$row.Path].Add($row)

        if (@($row.PdfPages).Count -gt 0 -and @($row.PrintedPages).Count -gt 0 -and @($row.PdfPages).Count -eq @($row.PrintedPages).Count) {
            for ($pageIndex = 0; $pageIndex -lt @($row.PdfPages).Count; $pageIndex++) {
                if ($row.PdfPages[$pageIndex] -ne ($row.PrintedPages[$pageIndex] + 2)) {
                    Write-Fail "Page-reference line $($row.Line) violates PDF=printed+2 offset for $($row.Path): PDF $($row.PdfPages[$pageIndex]) / printed $($row.PrintedPages[$pageIndex])."
                }
            }
        }
        elseif (@($row.PdfPages).Count -gt 0 -or @($row.PrintedPages).Count -gt 0) {
            Write-Warn "Page-reference line $($row.Line) has non-comparable PDF/printed page ranges for $($row.Path)."
        }
    }

    Write-Host ""
    Write-Host "Checking manifest metadata"

    $manifestEntries = @(Get-ManifestEntries -ManifestPath $manifestPath)
    if ($manifestEntries.Count -eq 0) {
        Write-Fail "Manifest has no parsed entries."
    }
    else {
        Write-Ok "Manifest entries parsed: $($manifestEntries.Count)"
    }

    $ids = @{}
    foreach ($entry in $manifestEntries) {
        if ($ids.ContainsKey($entry.Id)) {
            Write-Fail "Duplicate manifest id '$($entry.Id)' at line $($entry.Line); first seen at line $($ids[$entry.Id])."
        }
        else {
            $ids[$entry.Id] = $entry.Line
        }

        if (-not $entry.PSObject.Properties.Name.Contains("status")) {
            Write-Fail "Manifest entry '$($entry.Id)' has no status."
        }
        elseif ($allowedStatuses -notcontains $entry.status) {
            Write-Fail "Manifest entry '$($entry.Id)' has unsupported status '$($entry.status)'."
        }

        if ($entry.Section -in @("rules", "indexes", "mapped_rules")) {
            if (-not $entry.HasPdfPages) {
                Write-Fail "Manifest entry '$($entry.Id)' has no PDF source_pages array."
            }

            if (-not $entry.HasPrintedPages) {
                Write-Fail "Manifest entry '$($entry.Id)' has no printed source_pages array."
            }

            if (@($entry.PdfPages).Count -gt 0 -and @($entry.PrintedPages).Count -gt 0) {
                if (@($entry.PdfPages).Count -ne @($entry.PrintedPages).Count) {
                    Write-Fail "Manifest entry '$($entry.Id)' has unmatched PDF and printed source page counts."
                }
                else {
                    for ($pageIndex = 0; $pageIndex -lt @($entry.PdfPages).Count; $pageIndex++) {
                        if ($entry.PdfPages[$pageIndex] -ne ($entry.PrintedPages[$pageIndex] + 2)) {
                            Write-Fail "Manifest entry '$($entry.Id)' violates PDF=printed+2 offset: PDF $($entry.PdfPages[$pageIndex]) / printed $($entry.PrintedPages[$pageIndex])."
                        }
                    }
                }
            }
        }
    }

    foreach ($entry in $manifestEntries) {
        foreach ($relatedId in $entry.Related) {
            if (-not $ids.ContainsKey($relatedId)) {
                Write-Fail "Manifest entry '$($entry.Id)' references unknown related id '$relatedId'."
            }
        }

        if ($entry.Section -eq "rules") {
            if (-not $entry.PSObject.Properties.Name.Contains("summary")) {
                Write-Fail "Rule manifest entry '$($entry.Id)' has no summary path."
                continue
            }

            Test-RepoPathExists -Root $repoRoot -RelativePath $entry.summary -Context "Manifest rule '$($entry.Id)'"
            if (-not $pageReferencePaths.Contains($entry.summary)) {
                Write-Fail "Rule manifest entry '$($entry.Id)' summary is missing from page-reference index: $($entry.summary)"
            }
            elseif ($pageReferenceRowsByPath.ContainsKey($entry.summary)) {
                $matchingRows = @($pageReferenceRowsByPath[$entry.summary])
                $pageRefPdfPages = @($matchingRows | ForEach-Object { $_.PdfPages } | Sort-Object -Unique)
                $pageRefPrintedPages = @($matchingRows | ForEach-Object { $_.PrintedPages } | Sort-Object -Unique)
                if (-not (Test-Subset -ExpectedSubset $entry.PdfPages -ActualSuperset $pageRefPdfPages)) {
                    Write-Fail "Rule manifest entry '$($entry.Id)' PDF pages are not covered by page-reference index for $($entry.summary). Manifest: $(Format-PageList -Pages $entry.PdfPages); page-reference: $(Format-PageList -Pages $pageRefPdfPages)."
                }
                if (-not (Test-Subset -ExpectedSubset $entry.PrintedPages -ActualSuperset $pageRefPrintedPages)) {
                    Write-Fail "Rule manifest entry '$($entry.Id)' printed pages are not covered by page-reference index for $($entry.summary). Manifest: $(Format-PageList -Pages $entry.PrintedPages); page-reference: $(Format-PageList -Pages $pageRefPrintedPages)."
                }
            }

            $summaryPath = Resolve-RepoPath -Root $repoRoot -RelativePath $entry.summary
            if (Test-Path -LiteralPath $summaryPath -PathType Leaf) {
                $summaryText = Get-Content -LiteralPath $summaryPath -Raw
                if ($summaryText -notmatch '## Source References') {
                    Write-Fail "Rule manifest entry '$($entry.Id)' summary lacks a Source References section: $($entry.summary)"
                }
                else {
                    $summaryPdfPages = @(Get-SourcePagesFromText -Text $summaryText -Kind pdf)
                    $summaryPrintedPages = @(Get-SourcePagesFromText -Text $summaryText -Kind printed)
                    if (-not (Test-Subset -ExpectedSubset $entry.PdfPages -ActualSuperset $summaryPdfPages)) {
                        Write-Fail "Rule manifest entry '$($entry.Id)' PDF pages are not covered by summary Source References for $($entry.summary). Manifest: $(Format-PageList -Pages $entry.PdfPages); summary: $(Format-PageList -Pages $summaryPdfPages)."
                    }
                    if (-not (Test-Subset -ExpectedSubset $entry.PrintedPages -ActualSuperset $summaryPrintedPages)) {
                        Write-Fail "Rule manifest entry '$($entry.Id)' printed pages are not covered by summary Source References for $($entry.summary). Manifest: $(Format-PageList -Pages $entry.PrintedPages); summary: $(Format-PageList -Pages $summaryPrintedPages)."
                    }
                }
            }
        }
        elseif ($entry.Section -eq "indexes") {
            if (-not $entry.PSObject.Properties.Name.Contains("file")) {
                Write-Fail "Index manifest entry '$($entry.Id)' has no file path."
                continue
            }

            Test-RepoPathExists -Root $repoRoot -RelativePath $entry.file -Context "Manifest index '$($entry.Id)'"
            if (-not $pageReferencePaths.Contains($entry.file)) {
                Write-Fail "Index manifest entry '$($entry.Id)' file is missing from page-reference index: $($entry.file)"
            }
            elseif ($pageReferenceRowsByPath.ContainsKey($entry.file)) {
                $matchingRows = @($pageReferenceRowsByPath[$entry.file])
                $pageRefPdfPages = @($matchingRows | ForEach-Object { $_.PdfPages } | Sort-Object -Unique)
                $pageRefPrintedPages = @($matchingRows | ForEach-Object { $_.PrintedPages } | Sort-Object -Unique)
                if (-not (Test-Subset -ExpectedSubset $entry.PdfPages -ActualSuperset $pageRefPdfPages)) {
                    Write-Fail "Index manifest entry '$($entry.Id)' PDF pages are not covered by page-reference index for $($entry.file)."
                }
                if (-not (Test-Subset -ExpectedSubset $entry.PrintedPages -ActualSuperset $pageRefPrintedPages)) {
                    Write-Fail "Index manifest entry '$($entry.Id)' printed pages are not covered by page-reference index for $($entry.file)."
                }
            }
        }
        elseif ($entry.Section -eq "gm") {
            if (-not $entry.PSObject.Properties.Name.Contains("file")) {
                Write-Fail "GM manifest entry '$($entry.Id)' has no file path."
                continue
            }

            Test-RepoPathExists -Root $repoRoot -RelativePath $entry.file -Context "Manifest GM '$($entry.Id)'"
        }
        elseif ($entry.Section -eq "mapped_rules") {
            if (-not $entry.PSObject.Properties.Name.Contains("candidate")) {
                Write-Fail "Mapped manifest entry '$($entry.Id)' has no candidate path."
                continue
            }

            if ($entry.status -eq "source-lookup-only") {
                Write-Warn "Mapped manifest entry '$($entry.Id)' is source lookup only."
            }
            else {
                Test-RepoPathExists -Root $repoRoot -RelativePath $entry.candidate -Context "Mapped manifest '$($entry.Id)'" -WarnOnly
                if (-not $pageReferencePaths.Contains($entry.candidate)) {
                    Write-Fail "Mapped manifest entry '$($entry.Id)' candidate is missing from page-reference index: $($entry.candidate)"
                }
            }
        }
    }
}

Write-Host ""
Write-Host "Summary: $script:ErrorCount error(s), $script:WarningCount warning(s)."

if ($script:ErrorCount -gt 0) {
    exit 1
}

exit 0
