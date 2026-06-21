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
    param([Nullable[int]]$Margin)

    if ($null -eq $Margin) {
        return "none"
    }
    if ($Margin -ge 6) {
        return "decisive"
    }
    if ($Margin -ge 3) {
        return "clear"
    }
    if ($Margin -gt 0) {
        return "narrow"
    }

    return "tie"
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

function Get-Modifiers {
    param([object]$SideInput)

    if ($null -eq $SideInput -or -not $SideInput.PSObject.Properties.Name.Contains("modifiers")) {
        return @()
    }

    return @(
        $SideInput.modifiers | ForEach-Object {
            [pscustomobject]@{
                label = $_.label
                value = [int]$_.value
                source = if ($_.PSObject.Properties.Name.Contains("source")) { $_.source } else { $null }
            }
        }
    )
}

function Resolve-Side {
    param(
        [string]$Name,
        [object]$SideInput,
        [object]$Roll
    )

    if ($null -eq $SideInput) {
        throw "$Name mechanic input is required."
    }
    if (-not $SideInput.PSObject.Properties.Name.Contains("target_number")) {
        throw "$Name target_number is required."
    }

    $dice = @(Get-RollValues -Roll $Roll)
    $modifiers = @(Get-Modifiers -SideInput $SideInput)
    $baseTotal = ($dice | Measure-Object -Sum).Sum
    $modifierTotal = (@($modifiers) | ForEach-Object { $_.value } | Measure-Object -Sum).Sum
    if ($null -eq $modifierTotal) {
        $modifierTotal = 0
    }

    $targetNumber = [int]$SideInput.target_number
    $finalTotal = [int]$baseTotal + [int]$modifierTotal
    $margin = $finalTotal - $targetNumber

    [pscustomobject]@{
        expression = "2d6"
        dice = $dice
        base_total = [int]$baseTotal
        modifiers = @($modifiers)
        modifier_total = [int]$modifierTotal
        final_total = $finalTotal
        target_number = $targetNumber
        margin = $margin
        success = ($margin -ge 0)
    }
}

function Get-ParticipantId {
    param(
        [object]$Participants,
        [string]$SideName,
        [string]$Fallback
    )

    if ($null -eq $Participants -or -not $Participants.PSObject.Properties.Name.Contains($SideName)) {
        return $Fallback
    }

    $side = $Participants.$SideName
    if ($null -eq $side -or -not $side.PSObject.Properties.Name.Contains("id") -or [string]::IsNullOrWhiteSpace([string]$side.id)) {
        return $Fallback
    }

    return [string]$side.id
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
            prototype = "core.opposed_check"
        }
    }
}

$resolvedInputPath = (Resolve-Path $InputFile).Path
$inputObject = Get-Content -LiteralPath $resolvedInputPath -Raw | ConvertFrom-Json
$filesRead = @($resolvedInputPath)
$warnings = [System.Collections.Generic.List[object]]::new()
$unresolved = [System.Collections.Generic.List[string]]::new()

if ($inputObject.mechanic_id -ne "core.opposed_check") {
    $warnings.Add((New-Warning -Code "invalid-mechanic" -Severity "blocker" -Message "This prototype only resolves mechanic_id core.opposed_check."))
    New-Output -InputObject $inputObject -Status "invalid_input" -Authority $inputObject.authority -Result $null -RollBreakdown $null -Citations @() -Warnings @($warnings) -UnresolvedQuestions @("Use mechanic_id core.opposed_check.") -FilesRead $filesRead |
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
    $warnings.Add((New-Warning -Code "authority-refusal" -Severity "blocker" -Message "Authority status '$authorityStatus' cannot be resolved by the opposed check prototype."))
    $status = switch ($authorityStatus) {
        "source_lookup_required" { "source_lookup_required" }
        "external_authority_required" { "external_authority_required" }
        "cannot_adjudicate" { "cannot_adjudicate" }
        "blocked_missing_route" { "invalid_input" }
        default { "cannot_adjudicate" }
    }

    New-Output -InputObject $inputObject -Status $status -Authority $inputObject.authority -Result $null -RollBreakdown $null -Citations $citations -Warnings @($warnings) -UnresolvedQuestions @("Resolve authority status '$authorityStatus' before attempting an opposed check.") -FilesRead $filesRead |
        ConvertTo-Json -Depth 10
    exit 0
}

if (-not $inputObject.PSObject.Properties.Name.Contains("mechanic_inputs") -or $null -eq $inputObject.mechanic_inputs) {
    $warnings.Add((New-Warning -Code "missing-inputs" -Severity "blocker" -Message "mechanic_inputs with actor and defender entries is required."))
    New-Output -InputObject $inputObject -Status "invalid_input" -Authority $inputObject.authority -Result $null -RollBreakdown $null -Citations $citations -Warnings @($warnings) -UnresolvedQuestions @("Provide mechanic_inputs.actor and mechanic_inputs.defender.") -FilesRead $filesRead |
        ConvertTo-Json -Depth 10
    exit 0
}

if (-not $inputObject.PSObject.Properties.Name.Contains("rolls") -or $null -eq $inputObject.rolls) {
    $warnings.Add((New-Warning -Code "missing-rolls" -Severity "blocker" -Message "rolls.actor and rolls.defender are required."))
    New-Output -InputObject $inputObject -Status "invalid_input" -Authority $inputObject.authority -Result $null -RollBreakdown $null -Citations $citations -Warnings @($warnings) -UnresolvedQuestions @("Provide fixed or random 2d6 rolls for both sides.") -FilesRead $filesRead |
        ConvertTo-Json -Depth 10
    exit 0
}

try {
    $actorBreakdown = Resolve-Side -Name "actor" -SideInput $inputObject.mechanic_inputs.actor -Roll $inputObject.rolls.actor
    $defenderBreakdown = Resolve-Side -Name "defender" -SideInput $inputObject.mechanic_inputs.defender -Roll $inputObject.rolls.defender
}
catch {
    $warnings.Add((New-Warning -Code "invalid-opposed-input" -Severity "blocker" -Message $_.Exception.Message))
    New-Output -InputObject $inputObject -Status "invalid_input" -Authority $inputObject.authority -Result $null -RollBreakdown $null -Citations $citations -Warnings @($warnings) -UnresolvedQuestions @("Provide actor and defender target numbers, modifiers, and fixed or random 2d6 rolls.") -FilesRead $filesRead |
        ConvertTo-Json -Depth 10
    exit 0
}

$actorId = Get-ParticipantId -Participants $inputObject.participants -SideName "actor" -Fallback "actor"
$defenderId = Get-ParticipantId -Participants $inputObject.participants -SideName "defender" -Fallback "defender"

$winnerId = $null
$loserId = $null
$outcome = "no_clear_winner"
$netMargin = $null

if ($actorBreakdown.success -and -not $defenderBreakdown.success) {
    $winnerId = $actorId
    $loserId = $defenderId
    $outcome = "actor_wins"
    $netMargin = $actorBreakdown.margin - $defenderBreakdown.margin
}
elseif ($defenderBreakdown.success -and -not $actorBreakdown.success) {
    $winnerId = $defenderId
    $loserId = $actorId
    $outcome = "defender_wins"
    $netMargin = $defenderBreakdown.margin - $actorBreakdown.margin
}
elseif ($actorBreakdown.success -and $defenderBreakdown.success) {
    if ($actorBreakdown.margin -gt $defenderBreakdown.margin) {
        $winnerId = $actorId
        $loserId = $defenderId
        $outcome = "actor_wins"
        $netMargin = $actorBreakdown.margin - $defenderBreakdown.margin
    }
    elseif ($defenderBreakdown.margin -gt $actorBreakdown.margin) {
        $winnerId = $defenderId
        $loserId = $actorId
        $outcome = "defender_wins"
        $netMargin = $defenderBreakdown.margin - $actorBreakdown.margin
    }
    else {
        $outcome = "tied_success_margins"
        $netMargin = 0
        $unresolved.Add("Tied successful margins do not grant either side a clean win; GM resolves time, cost, or renewed stakes.")
    }
}
else {
    $outcome = "mutual_failure"
    $unresolved.Add("Both sides failed; GM resolves hesitation, delay, noise, or another non-clean-win consequence from the declared stakes.")
}

$result = [pscustomobject]@{
    summary = switch ($outcome) {
        "actor_wins" { "Actor wins the opposed check" }
        "defender_wins" { "Defender wins the opposed check" }
        "tied_success_margins" { "No clean winner: tied successful margins" }
        "mutual_failure" { "No clean winner: both sides failed" }
        default { "No clear winner" }
    }
    outcome = $outcome
    winner_id = $winnerId
    loser_id = $loserId
    margin = $netMargin
    degree = (Get-Degree -Margin $netMargin)
    actor_success = $actorBreakdown.success
    defender_success = $defenderBreakdown.success
    limits = @("No campaign file was edited.", "Does not decide follow-up damage, wounds, or durable campaign consequences.")
}

$rollBreakdown = [pscustomobject]@{
    actor = $actorBreakdown
    defender = $defenderBreakdown
    margin = $netMargin
}

$outputStatus = if ($authorityStatus -eq "authoritative") { "resolved" } else { "provisional" }
New-Output -InputObject $inputObject -Status $outputStatus -Authority $inputObject.authority -Result $result -RollBreakdown $rollBreakdown -Citations $citations -Warnings @($warnings) -UnresolvedQuestions @($unresolved) -FilesRead $filesRead |
    ConvertTo-Json -Depth 10
