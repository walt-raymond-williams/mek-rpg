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
            continue
        }

        if ($line -match '^\s{6}printed:\s*\[(.*?)\]\s*$') {
            $currentEntry.HasPrintedPages = -not [string]::IsNullOrWhiteSpace($Matches[1])
            continue
        }
    }

    foreach ($entry in $entries) {
        [pscustomobject]$entry
    }
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
    $pageReferencePaths = [System.Collections.Generic.HashSet[string]]::new()
    foreach ($pathInfo in (Get-IndexedBacktickPaths -Path $pageReferencePath)) {
        [void]$pageReferencePaths.Add($pathInfo.Path)
        $warnOnly = $pathInfo.Text -match 'Mapped only|Partially covered|Source lookup only|candidate'
        Test-RepoPathExists -Root $repoRoot -RelativePath $pathInfo.Path -Context "Page reference line $($pathInfo.Line)" -WarnOnly:$warnOnly
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
