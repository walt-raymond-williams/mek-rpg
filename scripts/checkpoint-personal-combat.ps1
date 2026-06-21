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
        notes = "Checkpoint reads only the supplied JSON input and writes only JSON to stdout."
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
            foreach ($id in @($file.manifest_ids)) {
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
    )
}

function New-Proposal {
    param(
        [object]$Request,
        [object]$InputObject,
        [int]$Index,
        [string]$AuthorityStatus,
        [object[]]$AuthorityWarnings,
        [string[]]$FilesRead
    )

    $proposalId = if ($Request.PSObject.Properties.Name.Contains("proposal_id") -and -not [string]::IsNullOrWhiteSpace([string]$Request.proposal_id)) {
        [string]$Request.proposal_id
    }
    else {
        "proposal-{0:D3}" -f $Index
    }

    $target = if ($Request.PSObject.Properties.Name.Contains("target")) { $Request.target } else { $null }
    $mekhqBoundary = if ($Request.PSObject.Properties.Name.Contains("mekhq_boundary")) {
        $Request.mekhq_boundary
    }
    else {
        [pscustomobject]@{
            affects_mekhq_hard_ledger = $false
            pending_item_id = $null
            confirmation_required = $null
        }
    }

    [pscustomobject]@{
        proposal_id = $proposalId
        schema_version = "0.1"
        status = "proposed"
        change_class = $Request.change_class
        change_type = $Request.change_type
        target = $target
        summary = $Request.summary
        proposed_text = $Request.proposed_text
        evidence = [pscustomobject]@{
            label = if ($Request.PSObject.Properties.Name.Contains("evidence_label")) { $Request.evidence_label } else { "mechanic-result" }
            source_request_id = $InputObject.request_id
            source_mechanic_id = $InputObject.mechanic_id
            result_status = if ($AuthorityStatus -eq "authoritative") { "resolved" } else { "provisional" }
            result_summary = if ($Request.PSObject.Properties.Name.Contains("result_summary")) { $Request.result_summary } else { $Request.summary }
            source_files = if ($Request.PSObject.Properties.Name.Contains("source_files")) { @($Request.source_files) } else { @() }
            citations = @()
            user_confirmation = $null
        }
        authority = [pscustomobject]@{
            source = "checkpoint-personal-combat.ps1"
            authority_status = $AuthorityStatus
            owner = if ($Request.PSObject.Properties.Name.Contains("authority_owner")) { $Request.authority_owner } else { "MEK-RPG" }
            warnings = @($AuthorityWarnings)
        }
        approval = [pscustomobject]@{
            requires_approval = $true
            approved_by = $null
            approval_timestamp = $null
            application_step = if ($Request.PSObject.Properties.Name.Contains("application_step")) { $Request.application_step } else { "Review before editing the target campaign file." }
        }
        mekhq_boundary = $mekhqBoundary
        no_hidden_mutation = (New-NoHiddenMutation -FilesRead $FilesRead)
        unresolved_questions = if ($Request.PSObject.Properties.Name.Contains("unresolved_questions")) { @($Request.unresolved_questions) } else { @() }
    }
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
        [object[]]$ProposedStateChanges,
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
        proposed_state_changes = @($ProposedStateChanges)
        unresolved_questions = @($UnresolvedQuestions)
        no_hidden_mutation = (New-NoHiddenMutation -FilesRead $FilesRead)
        debug = [pscustomobject]@{
            fixture_safe = $true
            prototype = "combat.personal_checkpoint"
        }
    }
}

$resolvedInputPath = (Resolve-Path $InputFile).Path
$inputObject = Get-Content -LiteralPath $resolvedInputPath -Raw | ConvertFrom-Json
$filesRead = @($resolvedInputPath)
$warnings = [System.Collections.Generic.List[object]]::new()
$unresolved = [System.Collections.Generic.List[string]]::new()

if ($inputObject.mechanic_id -ne "combat.personal_checkpoint") {
    $warnings.Add((New-Warning -Code "invalid-mechanic" -Severity "blocker" -Message "This prototype only resolves mechanic_id combat.personal_checkpoint."))
    New-Output -InputObject $inputObject -Status "invalid_input" -Authority $inputObject.authority -Result $null -RollBreakdown $null -Citations @() -Warnings @($warnings) -ProposedStateChanges @() -UnresolvedQuestions @("Use mechanic_id combat.personal_checkpoint.") -FilesRead $filesRead |
        ConvertTo-Json -Depth 12
    exit 0
}

$authorityStatus = Get-AuthorityStatus -InputObject $inputObject
if ([string]::IsNullOrWhiteSpace($authorityStatus)) {
    $warnings.Add((New-Warning -Code "missing-authority" -Severity "blocker" -Message "Input must include an authority envelope from the ruling authority gate."))
    New-Output -InputObject $inputObject -Status "invalid_input" -Authority $inputObject.authority -Result $null -RollBreakdown $null -Citations @() -Warnings @($warnings) -ProposedStateChanges @() -UnresolvedQuestions @("Run scripts/check-ruling-authority.ps1 and provide its authority output.") -FilesRead $filesRead |
        ConvertTo-Json -Depth 12
    exit 0
}

$citations = @(Get-Citations -Authority $inputObject.authority)
if ($inputObject.authority.PSObject.Properties.Name.Contains("warnings")) {
    foreach ($warning in @($inputObject.authority.warnings)) {
        $warnings.Add($warning)
    }
}

$checkpoint = $inputObject.checkpoint
if ($null -eq $checkpoint) {
    $warnings.Add((New-Warning -Code "missing-checkpoint" -Severity "blocker" -Message "checkpoint object is required."))
    New-Output -InputObject $inputObject -Status "invalid_input" -Authority $inputObject.authority -Result $null -RollBreakdown $null -Citations $citations -Warnings @($warnings) -ProposedStateChanges @() -UnresolvedQuestions @("Provide checkpoint.turn, checkpoint.phase, and checkpoint.scene_scale.") -FilesRead $filesRead |
        ConvertTo-Json -Depth 12
    exit 0
}

$sceneScale = [string]$checkpoint.scene_scale
$tacticalTriggers = if ($checkpoint.PSObject.Properties.Name.Contains("tactical_handoff_triggers")) { @($checkpoint.tactical_handoff_triggers) } else { @() }
$handoffRequired = ($sceneScale -ne "personal") -or ($tacticalTriggers.Count -gt 0)

if ($authorityStatus -notin @("authoritative", "provisional")) {
    $warnings.Add((New-Warning -Code "authority-refusal" -Severity "blocker" -Message "Authority status '$authorityStatus' cannot be checkpointed by the personal combat prototype."))
    $status = switch ($authorityStatus) {
        "source_lookup_required" { "source_lookup_required" }
        "external_authority_required" { "external_authority_required" }
        "cannot_adjudicate" { "cannot_adjudicate" }
        "blocked_missing_route" { "invalid_input" }
        default { "cannot_adjudicate" }
    }

    New-Output -InputObject $inputObject -Status $status -Authority $inputObject.authority -Result $null -RollBreakdown $null -Citations $citations -Warnings @($warnings) -ProposedStateChanges @() -UnresolvedQuestions @("Resolve authority status '$authorityStatus' before checkpointing personal combat.") -FilesRead $filesRead |
        ConvertTo-Json -Depth 12
    exit 0
}

if ($handoffRequired) {
    $warnings.Add((New-Warning -Code "tactical-handoff-required" -Severity "blocker" -Message "This scene requires Classic BattleTech, MegaMek, MekHQ, or tabletop tactical handling instead of the personal-combat checkpoint prototype."))
    New-Output -InputObject $inputObject -Status "external_authority_required" -Authority $inputObject.authority -Result ([pscustomobject]@{
            summary = "Tactical handoff required"
            personal_checkpoint_allowed = $false
            handoff_required = $true
            tactical_handoff_triggers = @($tacticalTriggers)
            required_next_action = "Prepare a tactical handoff packet using gm/switch-to-classic-battletech.md."
            limits = @("Does not resolve hex movement, facing, heat, armor locations, ammunition, critical hits, salvage, repairs, or MekHQ ledger results.")
        }) -RollBreakdown $null -Citations $citations -Warnings @($warnings) -ProposedStateChanges @() -UnresolvedQuestions @("Use external tactical authority before returning campaign consequences.") -FilesRead $filesRead |
        ConvertTo-Json -Depth 12
    exit 0
}

$allowedPhases = @("setup", "initiative", "action", "end", "closeout")
$phase = [string]$checkpoint.phase
if ($phase -notin $allowedPhases) {
    $warnings.Add((New-Warning -Code "invalid-phase" -Severity "blocker" -Message "checkpoint.phase must be one of: $($allowedPhases -join ', ')."))
    New-Output -InputObject $inputObject -Status "invalid_input" -Authority $inputObject.authority -Result $null -RollBreakdown $null -Citations $citations -Warnings @($warnings) -ProposedStateChanges @() -UnresolvedQuestions @("Provide a supported personal-combat phase.") -FilesRead $filesRead |
        ConvertTo-Json -Depth 12
    exit 0
}

$proposalRequests = if ($inputObject.PSObject.Properties.Name.Contains("state_change_requests")) { @($inputObject.state_change_requests) } else { @() }
$proposals = @()
$proposalIndex = 1
foreach ($request in $proposalRequests) {
    $proposals += New-Proposal -Request $request -InputObject $inputObject -Index $proposalIndex -AuthorityStatus $authorityStatus -AuthorityWarnings @($warnings) -FilesRead $filesRead
    $proposalIndex += 1
}

$phaseNextStep = switch ($phase) {
    "setup" { "Confirm participants, sides, positions, cover, visible weapons, scale, and initiative method." }
    "initiative" { "Resolve initiative order, then move to Action Phase." }
    "action" { "Resolve active actor movement and declared action, then advance to the next initiative entry." }
    "end" { "Resolve continuous effects, fatigue, extended actions, and automatic events, then decide whether combat continues." }
    "closeout" { "Summarize consequences and review accepted state-change proposals." }
}

$outputStatus = if ($authorityStatus -eq "authoritative") { "resolved" } else { "provisional" }
$result = [pscustomobject]@{
    summary = "Personal-combat checkpoint ready"
    personal_checkpoint_allowed = $true
    handoff_required = $false
    scene_scale = $sceneScale
    turn = $checkpoint.turn
    phase = $phase
    active_actor_id = if ($checkpoint.PSObject.Properties.Name.Contains("active_actor_id")) { $checkpoint.active_actor_id } else { $null }
    initiative_order = if ($checkpoint.PSObject.Properties.Name.Contains("initiative_order")) { @($checkpoint.initiative_order) } else { @() }
    participants = if ($checkpoint.PSObject.Properties.Name.Contains("participants")) { @($checkpoint.participants) } else { @() }
    active_effects = if ($checkpoint.PSObject.Properties.Name.Contains("active_effects")) { @($checkpoint.active_effects) } else { @() }
    declared_actions = if ($checkpoint.PSObject.Properties.Name.Contains("declared_actions")) { @($checkpoint.declared_actions) } else { @() }
    next_step = $phaseNextStep
    limits = @("Tracks RPG-scale checkpoint state only.", "Does not resolve full tactical BattleTech, MegaMek, or MekHQ combat.", "Does not silently edit campaign files.")
}

New-Output -InputObject $inputObject -Status $outputStatus -Authority $inputObject.authority -Result $result -RollBreakdown $null -Citations $citations -Warnings @($warnings) -ProposedStateChanges @($proposals) -UnresolvedQuestions @($unresolved) -FilesRead $filesRead |
    ConvertTo-Json -Depth 12
