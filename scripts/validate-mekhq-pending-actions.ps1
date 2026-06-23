param(
    [Parameter(Position = 0)]
    [string]$Path = "campaigns/_template/pending-mekhq-actions.md",

    [switch]$ReportUnresolved
)

$ErrorActionPreference = "Stop"

$allowedStatuses = @("proposed", "queued", "user-applied-in-mekhq", "command-executed-in-mekhq", "imported", "live-verified", "resolved", "blocked", "abandoned")
$allowedTypes = @("purchase-sale", "contract", "repair-logistics", "personnel", "injury-availability", "tactical-outcome", "day-advancement", "finance", "other")
$allowedPriorities = @("before-day-advance", "before-next-scene", "end-of-session", "optional", "deferred")
$requiredFields = @(
    "Status",
    "Type",
    "Priority",
    "Created",
    "Updated",
    "Source scene",
    "Source files",
    "MekHQ target ids",
    "Current imported baseline",
    "Proposed MekHQ action",
    "Manual application checklist",
    "Command application checklist",
    "Confirmation needed from next import",
    "Affected campaign files after import",
    "Blockers or discrepancy notes",
    "Resolution notes"
)

$script:ErrorCount = 0
$script:WarningCount = 0
$unresolvedStatuses = @("proposed", "queued", "user-applied-in-mekhq", "command-executed-in-mekhq", "imported", "live-verified", "blocked")

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

function New-PendingItem {
    param(
        [string]$Id,
        [string]$Title,
        [int]$LineNumber
    )

    return [pscustomobject]@{
        Id = $Id
        Title = $Title
        LineNumber = $LineNumber
        Fields = @{}
    }
}

$resolvedPath = (Resolve-Path $Path).Path
$lines = Get-Content -LiteralPath $resolvedPath
$items = [System.Collections.Generic.List[object]]::new()
$currentItem = $null

for ($index = 0; $index -lt $lines.Count; $index++) {
    $line = $lines[$index]
    $lineNumber = $index + 1

    if ($line -match '^###\s+(mekhq-pending-\d{4}-\d{2}-\d{2}-\d{3})\s*:\s*(.+?)\s*$') {
        $currentItem = New-PendingItem -Id $Matches[1] -Title $Matches[2] -LineNumber $lineNumber
        $items.Add($currentItem)
        continue
    }

    if ($line -match '^###\s+') {
        Write-Fail "Line $lineNumber has invalid pending item heading. Expected '### mekhq-pending-YYYY-MM-DD-NNN: Short title'."
        $currentItem = $null
        continue
    }

    if ($null -ne $currentItem -and $line -match '^-\s+([^:]+):\s*(.*)$') {
        $fieldName = $Matches[1].Trim()
        $fieldValue = $Matches[2].Trim()
        $currentItem.Fields[$fieldName] = $fieldValue
    }
}

Write-Host "Pending MekHQ action validation"
Write-Host "File: $resolvedPath"
Write-Host ""

if ($items.Count -eq 0) {
    Write-Ok "No pending item entries found."
}

$ids = @{}
foreach ($item in $items) {
    if ($ids.ContainsKey($item.Id)) {
        Write-Fail "Duplicate pending item id '$($item.Id)' at line $($item.LineNumber)."
    }
    else {
        $ids[$item.Id] = $true
    }

    foreach ($field in $requiredFields) {
        if (-not $item.Fields.ContainsKey($field)) {
            Write-Fail "$($item.Id) missing required field: $field"
            continue
        }

        $listContainerFields = @("Manual application checklist", "Command application checklist")
        if ($listContainerFields -notcontains $field -and [string]::IsNullOrWhiteSpace([string]$item.Fields[$field])) {
            Write-Fail "$($item.Id) required field is empty: $field"
        }
    }

    if ($item.Fields.ContainsKey("Status") -and $allowedStatuses -notcontains $item.Fields["Status"]) {
        Write-Fail "$($item.Id) has invalid Status '$($item.Fields["Status"])'."
    }

    if ($item.Fields.ContainsKey("Type") -and $allowedTypes -notcontains $item.Fields["Type"]) {
        Write-Fail "$($item.Id) has invalid Type '$($item.Fields["Type"])'."
    }

    if ($item.Fields.ContainsKey("Priority") -and $allowedPriorities -notcontains $item.Fields["Priority"]) {
        Write-Fail "$($item.Id) has invalid Priority '$($item.Fields["Priority"])'."
    }

    if ($item.Fields.ContainsKey("Created") -and $item.Fields["Created"] -notmatch '^\d{4}-\d{2}-\d{2}$') {
        Write-Fail "$($item.Id) Created must use YYYY-MM-DD."
    }

    if ($item.Fields.ContainsKey("Updated") -and $item.Fields["Updated"] -notmatch '^\d{4}-\d{2}-\d{2}$') {
        Write-Fail "$($item.Id) Updated must use YYYY-MM-DD."
    }
}

$unresolvedItems = @(
    $items | Where-Object {
        $_.Fields.ContainsKey("Status") -and $unresolvedStatuses -contains $_.Fields["Status"]
    }
)

Write-Host ""
Write-Host "Summary: $script:ErrorCount error(s), $script:WarningCount warning(s), $($items.Count) item(s), $($unresolvedItems.Count) unresolved pending intent(s)."

if ($ReportUnresolved) {
    Write-Host ""
    Write-Host "Unresolved pending intents for day-advance review"
    Write-Host "These are command proposals, command results, or manual-action checklists, not confirmed hard ledger facts."

    if ($unresolvedItems.Count -eq 0) {
        Write-Host "- None."
    }
    else {
        foreach ($item in $unresolvedItems) {
            $status = $item.Fields["Status"]
            $priority = if ($item.Fields.ContainsKey("Priority")) { $item.Fields["Priority"] } else { "Unknown" }
            $type = if ($item.Fields.ContainsKey("Type")) { $item.Fields["Type"] } else { "Unknown" }
            Write-Host "- $($item.Id) [$status/$priority/$type]: $($item.Title)"
        }
    }
}

if ($script:ErrorCount -gt 0) {
    exit 1
}

exit 0
