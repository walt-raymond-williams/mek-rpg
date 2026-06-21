param(
    [Parameter(Mandatory = $true)]
    [string]$InputFile
)

$ErrorActionPreference = "Stop"

function New-Warning {
    param(
        [string]$Code,
        [string]$Severity,
        [string]$Message
    )

    [pscustomobject]@{
        code = $Code
        severity = $Severity
        message = $Message
    }
}

function New-NoHiddenMutation {
    param([string[]]$FilesRead)

    [pscustomobject]@{
        files_read = @($FilesRead)
        files_written = @()
        mekhq_write_attempted = $false
        campaign_write_attempted = $false
        protected_source_read = $false
        notes = "Resolver reads only the supplied JSON input and writes only JSON to stdout."
    }
}

function Get-AuthorityStatus {
    param([object]$InputObject)

    if ($InputObject.PSObject.Properties.Name.Contains("authority") -and $null -ne $InputObject.authority) {
        if ($InputObject.authority.PSObject.Properties.Name.Contains("status")) {
            return [string]$InputObject.authority.status
        }
    }

    return $null
}

function Get-Citations {
    param([object]$Authority)

    if ($null -eq $Authority -or -not $Authority.PSObject.Properties.Name.Contains("routed_files")) {
        return @()
    }

    return @(
        $Authority.routed_files | ForEach-Object {
            $file = $_
            $manifestIds = @($file.manifest_ids)
            if ($manifestIds.Count -eq 0) {
                [pscustomobject]@{
                    kind = "route"
                    path = $file.path
                    manifest_id = $null
                    manifest_status = if (@($file.statuses).Count -gt 0) { @($file.statuses)[0] } else { $null }
                    source_pages = $file.source_pages
                    page_reference_status = $file.page_reference_status
                }
            }
            else {
                foreach ($id in $manifestIds) {
                    [pscustomobject]@{
                        kind = "summary"
                        path = $file.path
                        manifest_id = $id
                        manifest_status = if (@($file.statuses).Count -gt 0) { @($file.statuses)[0] } else { $null }
                        source_pages = $file.source_pages
                        page_reference_status = $file.page_reference_status
                    }
                }
            }
        }
    )
}

function Get-Degree {
    param([int]$Margin)

    if ($Margin -ge 6) {
        return "exceptional"
    }
    if ($Margin -ge 3) {
        return "strong"
    }
    if ($Margin -ge 0) {
        return "standard"
    }
    if ($Margin -ge -2) {
        return "narrow_failure"
    }

    return "failure"
}

function Get-RollValues {
    param([object]$Roll)

    if ($null -eq $Roll) {
        throw "Input roll is required."
    }

    $mode = [string]$Roll.mode
    $expression = if ($Roll.PSObject.Properties.Name.Contains("expression")) { [string]$Roll.expression } else { "2d6" }
    if ($expression -ne "2d6") {
        throw "Only 2d6 is supported by this prototype."
    }

    if ($mode -eq "fixed") {
        $values = @($Roll.values | ForEach-Object { [int]$_ })
        if ($values.Count -ne 2) {
            throw "Fixed 2d6 roll requires exactly two values."
        }

        foreach ($value in $values) {
            if ($value -lt 1 -or $value -gt 6) {
                throw "Fixed roll value out of range for d6: $value."
            }
        }

        return $values
    }

    if ($mode -eq "random") {
        return @((Get-Random -Minimum 1 -Maximum 7), (Get-Random -Minimum 1 -Maximum 7))
    }

    throw "Unsupported roll mode '$mode'."
}

function New-Output {
    param(
        [object]$InputObject,
        [string]$Status,
        [object]$Authority,
        [object]$Result,
        [object]$RollBreakdown,
        [object[]]$Citations,
        [object[]]$Warnings,
        [string[]]$UnresolvedQuestions,
        [string[]]$FilesRead
    )

    [pscustomobject]@{
        schema_version = "0.1"
        request_id = $InputObject.request_id
        mechanic_id = $InputObject.mechanic_id
        status = $Status
        authority = $Authority
        result = $Result
        roll_breakdown = $RollBreakdown
        citations = @($Citations)
        warnings = @($Warnings)
        proposed_state_changes = @()
        unresolved_questions = @($UnresolvedQuestions)
        no_hidden_mutation = (New-NoHiddenMutation -FilesRead $FilesRead)
        debug = [pscustomobject]@{
            fixture_safe = $true
            prototype = "core.basic_check"
        }
    }
}

$resolvedInputPath = (Resolve-Path $InputFile).Path
$inputObject = Get-Content -LiteralPath $resolvedInputPath -Raw | ConvertFrom-Json
$filesRead = @($resolvedInputPath)
$warnings = [System.Collections.Generic.List[object]]::new()
$unresolved = [System.Collections.Generic.List[string]]::new()

if ($inputObject.mechanic_id -ne "core.basic_check") {
    $warnings.Add((New-Warning -Code "invalid-mechanic" -Severity "blocker" -Message "This prototype only resolves mechanic_id core.basic_check."))
    New-Output -InputObject $inputObject -Status "invalid_input" -Authority $inputObject.authority -Result $null -RollBreakdown $null -Citations @() -Warnings @($warnings) -UnresolvedQuestions @("Use mechanic_id core.basic_check.") -FilesRead $filesRead |
        ConvertTo-Json -Depth 10
    exit 0
}

$authorityStatus = Get-AuthorityStatus -InputObject $inputObject
if ([string]::IsNullOrWhiteSpace($authorityStatus)) {
    $warnings.Add((New-Warning -Code "missing-authority" -Severity "blocker" -Message "Input must include an authority envelope from the ruling authority gate."))
    New-Output -InputObject $inputObject -Status "invalid_input" -Authority $inputObject.authority -Result $null -RollBreakdown $null -Citations @() -Warnings @($warnings) -UnresolvedQuestions @("Run scripts/check-ruling-authority.ps1 and provide its authority output.") -FilesRead $filesRead |
        ConvertTo-Json -Depth 10
    exit 0
}

$citations = @(Get-Citations -Authority $inputObject.authority)
if ($inputObject.authority.PSObject.Properties.Name.Contains("warnings")) {
    foreach ($warning in @($inputObject.authority.warnings)) {
        $warnings.Add($warning)
    }
}

if ($authorityStatus -notin @("authoritative", "provisional")) {
    $warnings.Add((New-Warning -Code "authority-refusal" -Severity "blocker" -Message "Authority status '$authorityStatus' cannot be resolved by the basic check prototype."))
    $status = switch ($authorityStatus) {
        "source_lookup_required" { "source_lookup_required" }
        "external_authority_required" { "external_authority_required" }
        "cannot_adjudicate" { "cannot_adjudicate" }
        "blocked_missing_route" { "invalid_input" }
        default { "cannot_adjudicate" }
    }

    New-Output -InputObject $inputObject -Status $status -Authority $inputObject.authority -Result $null -RollBreakdown $null -Citations $citations -Warnings @($warnings) -UnresolvedQuestions @("Resolve authority status '$authorityStatus' before attempting a basic check.") -FilesRead $filesRead |
        ConvertTo-Json -Depth 10
    exit 0
}

if (-not $inputObject.PSObject.Properties.Name.Contains("mechanic_inputs") -or $null -eq $inputObject.mechanic_inputs) {
    $warnings.Add((New-Warning -Code "missing-inputs" -Severity "blocker" -Message "mechanic_inputs is required."))
    New-Output -InputObject $inputObject -Status "invalid_input" -Authority $inputObject.authority -Result $null -RollBreakdown $null -Citations $citations -Warnings @($warnings) -UnresolvedQuestions @("Provide mechanic_inputs.target_number and explicit modifiers.") -FilesRead $filesRead |
        ConvertTo-Json -Depth 10
    exit 0
}

if (-not $inputObject.mechanic_inputs.PSObject.Properties.Name.Contains("target_number")) {
    $warnings.Add((New-Warning -Code "missing-target-number" -Severity "blocker" -Message "mechanic_inputs.target_number is required."))
    New-Output -InputObject $inputObject -Status "invalid_input" -Authority $inputObject.authority -Result $null -RollBreakdown $null -Citations $citations -Warnings @($warnings) -UnresolvedQuestions @("Provide an explicit target number.") -FilesRead $filesRead |
        ConvertTo-Json -Depth 10
    exit 0
}

try {
    $dice = @(Get-RollValues -Roll $inputObject.roll)
}
catch {
    $warnings.Add((New-Warning -Code "invalid-roll" -Severity "blocker" -Message $_.Exception.Message))
    New-Output -InputObject $inputObject -Status "invalid_input" -Authority $inputObject.authority -Result $null -RollBreakdown $null -Citations $citations -Warnings @($warnings) -UnresolvedQuestions @("Provide a fixed or random 2d6 roll.") -FilesRead $filesRead |
        ConvertTo-Json -Depth 10
    exit 0
}

$targetNumber = [int]$inputObject.mechanic_inputs.target_number
$modifiers = @()
if ($inputObject.mechanic_inputs.PSObject.Properties.Name.Contains("modifiers")) {
    $modifiers = @(
        $inputObject.mechanic_inputs.modifiers | ForEach-Object {
            [pscustomobject]@{
                label = $_.label
                value = [int]$_.value
                source = if ($_.PSObject.Properties.Name.Contains("source")) { $_.source } else { $null }
            }
        }
    )
}

$baseTotal = ($dice | Measure-Object -Sum).Sum
$modifierTotal = (@($modifiers) | ForEach-Object { $_.value } | Measure-Object -Sum).Sum
if ($null -eq $modifierTotal) {
    $modifierTotal = 0
}
$finalTotal = [int]$baseTotal + [int]$modifierTotal
$margin = $finalTotal - $targetNumber
$success = $margin -ge 0
$degree = Get-Degree -Margin $margin
$outputStatus = if ($authorityStatus -eq "authoritative") { "resolved" } else { "provisional" }

$result = [pscustomobject]@{
    summary = if ($success) { "Success" } else { "Failure" }
    success = $success
    margin = $margin
    degree = $degree
    narrative_permission = if ($success) { "GM may narrate the declared action succeeding within stated stakes." } else { "GM may narrate failure, cost, delay, or complication within stated stakes." }
    limits = @("No campaign file was edited.", "No exact table, equipment stat, or tactical result was invented.")
}

$rollBreakdown = [pscustomobject]@{
    expression = "2d6"
    dice = $dice
    base_total = [int]$baseTotal
    modifiers = @($modifiers)
    modifier_total = [int]$modifierTotal
    final_total = $finalTotal
    target_number = $targetNumber
    margin = $margin
}

New-Output -InputObject $inputObject -Status $outputStatus -Authority $inputObject.authority -Result $result -RollBreakdown $rollBreakdown -Citations $citations -Warnings @($warnings) -UnresolvedQuestions @($unresolved) -FilesRead $filesRead |
    ConvertTo-Json -Depth 10
