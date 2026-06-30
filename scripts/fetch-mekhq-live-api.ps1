param(
    [string]$ApiBaseUrl = "http://127.0.0.1:32180",
    [string]$OutputDirectory = ".\mekhq-live-api-capture",
    [string[]]$StateSections = @(
        "bridge_metadata",
        "campaign",
        "finances",
        "personnel",
        "units",
        "contracts",
        "scenarios",
        "repairs_and_logistics",
        "markets",
        "reports",
        "unsupported"
    ),
    [switch]$SelectorDetailFull,
    [switch]$SkipPendingDeployments,
    [string]$PendingDeploymentsPersonId,
    [string]$PendingDeploymentsPersonName,
    [string]$PersonnelDetailPersonId,
    [switch]$IncludePersonnelMedical,
    [switch]$IncludePersonnelPatient,
    [ValidateRange(1, 50)]
    [int]$PersonnelDetailLogLimit = 10,
    [switch]$ContinueOnError
)

$ErrorActionPreference = "Stop"

function ConvertTo-QueryString {
    param([hashtable]$Parameters)

    $pairs = @()
    foreach ($key in $Parameters.Keys) {
        $value = $Parameters[$key]
        if ($null -eq $value -or [string]::IsNullOrWhiteSpace([string]$value)) {
            continue
        }
        $pairs += ("{0}={1}" -f [System.Uri]::EscapeDataString($key), [System.Uri]::EscapeDataString([string]$value))
    }

    if ($pairs.Count -eq 0) {
        return ""
    }
    return "?" + ($pairs -join "&")
}

function Write-Utf8Json {
    param(
        [string]$Path,
        [object]$Value
    )

    $json = $Value | ConvertTo-Json -Depth 30
    [System.IO.File]::WriteAllText($Path, $json + [Environment]::NewLine, [System.Text.UTF8Encoding]::new($false))
}

function Invoke-CaptureGet {
    param(
        [string]$Name,
        [string]$Path,
        [string]$OutputFileName,
        [bool]$Required
    )

    $base = $ApiBaseUrl.TrimEnd("/")
    $uri = $base + $Path
    $outputPath = Join-Path $fullOutputDirectory $OutputFileName
    $timer = [System.Diagnostics.Stopwatch]::StartNew()

    try {
        $response = Invoke-RestMethod -Method Get -Uri $uri -TimeoutSec $timeoutSeconds
        $timer.Stop()
        Write-Utf8Json -Path $outputPath -Value $response
        Write-Host ("OK: {0} -> {1} ({2:N2}s)" -f $Name, $outputPath, $timer.Elapsed.TotalSeconds)
        return [pscustomobject][ordered]@{
            name = $Name
            method = "GET"
            path = $Path
            uri = $uri
            output_file = $OutputFileName
            required = $Required
            status = "captured"
            seconds = [math]::Round($timer.Elapsed.TotalSeconds, 3)
            error = $null
        }
    }
    catch {
        $timer.Stop()
        $errorFileName = [System.IO.Path]::GetFileNameWithoutExtension($OutputFileName) + ".error.json"
        $errorPath = Join-Path $fullOutputDirectory $errorFileName
        $errorRecord = [pscustomobject][ordered]@{
            name = $Name
            method = "GET"
            path = $Path
            uri = $uri
            required = $Required
            status = "failed"
            seconds = [math]::Round($timer.Elapsed.TotalSeconds, 3)
            error = $_.Exception.Message
        }
        Write-Utf8Json -Path $errorPath -Value $errorRecord
        Write-Host ("FAIL: {0} -> {1} ({2:N2}s)" -f $Name, $errorPath, $timer.Elapsed.TotalSeconds)

        return [pscustomobject][ordered]@{
            name = $Name
            method = "GET"
            path = $Path
            uri = $uri
            output_file = $errorFileName
            required = $Required
            status = "failed"
            seconds = [math]::Round($timer.Elapsed.TotalSeconds, 3)
            error = $_.Exception.Message
        }
    }
}

$timeoutSecondsByName = @{
    status = 5
    summary = 15
    state = 45
    commands = 20
    commands_full = 60
    pending_deployments = 15
    pending_deployments_viewpoint = 15
    personnel_detail = 20
}

$fullOutputDirectory = [System.IO.Path]::GetFullPath($OutputDirectory)
New-Item -ItemType Directory -Path $fullOutputDirectory -Force | Out-Null

$stateQuery = ConvertTo-QueryString @{ sections = ($StateSections -join ",") }
$requests = [System.Collections.Generic.List[object]]::new()
$requests.Add([pscustomobject]@{ Name = "status"; Path = "/status"; Output = "mekhq-status.json"; Required = $true }) | Out-Null
$requests.Add([pscustomobject]@{ Name = "summary"; Path = "/campaign/summary"; Output = "mekhq-summary.json"; Required = $true }) | Out-Null
$requests.Add([pscustomobject]@{ Name = "state"; Path = "/campaign/state$stateQuery"; Output = "mekhq-state.json"; Required = $true }) | Out-Null
$requests.Add([pscustomobject]@{ Name = "commands"; Path = "/campaign/commands"; Output = "mekhq-commands.json"; Required = $true }) | Out-Null

if ($SelectorDetailFull) {
    $requests.Add([pscustomobject]@{ Name = "commands_full"; Path = "/campaign/commands?selectorDetail=full"; Output = "mekhq-commands-full.json"; Required = $true }) | Out-Null
}

if (-not $SkipPendingDeployments) {
    $requests.Add([pscustomobject]@{ Name = "pending_deployments"; Path = "/campaign/pending-deployments"; Output = "mekhq-pending-deployments.json"; Required = $true }) | Out-Null
}

if (-not [string]::IsNullOrWhiteSpace($PendingDeploymentsPersonId) -or -not [string]::IsNullOrWhiteSpace($PendingDeploymentsPersonName)) {
    $viewpointQuery = ConvertTo-QueryString @{
        personId = $PendingDeploymentsPersonId
        personName = $PendingDeploymentsPersonName
    }
    $requests.Add([pscustomobject]@{ Name = "pending_deployments_viewpoint"; Path = "/campaign/pending-deployments$viewpointQuery"; Output = "mekhq-pending-deployments-viewpoint.json"; Required = $true }) | Out-Null
}

if ($IncludePersonnelMedical -or $IncludePersonnelPatient) {
    if ([string]::IsNullOrWhiteSpace($PersonnelDetailPersonId)) {
        throw "Personnel medical or patient log inclusion requires -PersonnelDetailPersonId."
    }
}

if (-not [string]::IsNullOrWhiteSpace($PersonnelDetailPersonId)) {
    $personnelDetailQuery = ConvertTo-QueryString @{
        personId = $PersonnelDetailPersonId
        includeMedical = if ($IncludePersonnelMedical) { "true" } else { $null }
        includePatient = if ($IncludePersonnelPatient) { "true" } else { $null }
        logLimit = if ($IncludePersonnelMedical -or $IncludePersonnelPatient) { $PersonnelDetailLogLimit } else { $null }
    }
    $requests.Add([pscustomobject]@{ Name = "personnel_detail"; Path = "/campaign/personnel/detail$personnelDetailQuery"; Output = "mekhq-personnel-detail.json"; Required = $true }) | Out-Null
}

$results = [System.Collections.Generic.List[object]]::new()

foreach ($request in $requests) {
    $timeoutSeconds = $timeoutSecondsByName[$request.Name]
    $results.Add((Invoke-CaptureGet -Name $request.Name -Path $request.Path -OutputFileName $request.Output -Required $request.Required)) | Out-Null
}

$failedRequired = @($results | Where-Object { $_.required -eq $true -and $_.status -ne "captured" })
$manifest = [pscustomobject][ordered]@{
    schema_version = "mek-rpg-mekhq-live-api-capture/v1"
    api_base_url = $ApiBaseUrl.TrimEnd("/")
    captured_at = [DateTimeOffset]::UtcNow.ToString("o")
    output_directory = $fullOutputDirectory
    state_sections = $StateSections
    selector_detail_full = [bool]$SelectorDetailFull
    pending_deployments_skipped = [bool]$SkipPendingDeployments
    pending_deployments_person_id = if ([string]::IsNullOrWhiteSpace($PendingDeploymentsPersonId)) { $null } else { $PendingDeploymentsPersonId }
    pending_deployments_person_name = if ([string]::IsNullOrWhiteSpace($PendingDeploymentsPersonName)) { $null } else { $PendingDeploymentsPersonName }
    personnel_detail_person_id = if ([string]::IsNullOrWhiteSpace($PersonnelDetailPersonId)) { $null } else { $PersonnelDetailPersonId }
    personnel_detail_include_medical = [bool]$IncludePersonnelMedical
    personnel_detail_include_patient = [bool]$IncludePersonnelPatient
    personnel_detail_log_limit = if ($IncludePersonnelMedical -or $IncludePersonnelPatient) { $PersonnelDetailLogLimit } else { $null }
    status = if ($failedRequired.Count -eq 0) { "captured" } elseif ($ContinueOnError) { "partial" } else { "failed" }
    results = @($results)
}

Write-Utf8Json -Path (Join-Path $fullOutputDirectory "mekhq-live-api-capture-manifest.json") -Value $manifest

if ($failedRequired.Count -gt 0) {
    Write-Host ""
    Write-Host "Required MekHQ live API captures failed:"
    foreach ($failure in $failedRequired) {
        Write-Host ("- {0}: {1}" -f $failure.name, $failure.error)
    }
    if (-not $ContinueOnError) {
        exit 1
    }
}

Write-Host ""
Write-Host "MekHQ live API capture manifest: $fullOutputDirectory\mekhq-live-api-capture-manifest.json"
