param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$helperPath = Join-Path $repoRoot "scripts\build-mekhq-status-note-command.ps1"
$summaryFixturePath = Join-Path $repoRoot "tests\fixtures\mekhq-live-campaign-summary.fixture.json"
$commandsFixturePath = Join-Path $repoRoot "tests\fixtures\mekhq-live-campaign-commands.fixture.json"
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) "mek-rpg-status-note-command-fixtures"

function Write-Step {
    param([string]$Message)
    Write-Host "TEST: $Message"
}

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Message
    )

    if (-not $Condition) {
        throw $Message
    }

    Write-Host "OK: $Message"
}

function Invoke-Helper {
    param(
        [string[]]$Arguments,
        [string]$Message
    )

    $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $helperPath @Arguments 2>&1
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        $output | ForEach-Object { Write-Host $_ }
        throw "$Message failed with exit code $exitCode."
    }

    Write-Host "OK: $Message"
    return ($output | Out-String)
}

function Invoke-HelperExpectFailure {
    param(
        [string[]]$Arguments,
        [string]$ExpectedPattern,
        [string]$Message
    )

    $oldErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $helperPath @Arguments 2>&1
    }
    finally {
        $ErrorActionPreference = $oldErrorActionPreference
    }
    $exitCode = $LASTEXITCODE
    Assert-True ($exitCode -ne 0) "$Message exits non-zero"
    $text = ($output | Out-String)
    Assert-True ($text -match $ExpectedPattern) "$Message reports expected failure"
    return $text
}

function Remove-TempFixtures {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
    }
}

Push-Location $repoRoot
try {
    Write-Step "Creating disposable helper output paths."
    Remove-TempFixtures
    New-Item -ItemType Directory -Path $tempRoot | Out-Null

    $requestPath = Join-Path $tempRoot "status-note-request.json"

    Write-Step "Checking valid request creation from live API summary and command-readiness fixtures."
    Invoke-Helper @(
        "-StatusJson", $summaryFixturePath,
        "-CommandReadinessJson", $commandsFixturePath,
        "-OutputFile", $requestPath,
        "-NoteText", "Fixture status-note dry-run.",
        "-IdempotencyKey", "mek-rpg-fixture-status-note-001",
        "-Actor", "codex-test",
        "-SceneId", "fixture-scene",
        "-ActionId", "fixture-action",
        "-Reason", "Verify structured clientContext."
    ) "Build status-note dry-run request" | Out-Null

    Assert-True (Test-Path -LiteralPath $requestPath -PathType Leaf) "Request JSON file was written."
    $requestText = Get-Content -LiteralPath $requestPath -Raw
    $request = $requestText | ConvertFrom-Json

    Assert-True ($request.command -eq "campaign.status_note") "Request command is campaign.status_note."
    Assert-True ($request.commandVersion -eq 1) "Request command version is set."
    Assert-True ($request.idempotencyKey -eq "mek-rpg-fixture-status-note-001") "Request preserves idempotency key."
    Assert-True ($request.expectedCampaignId -eq "11111111-2222-3333-4444-555555555555") "Request uses campaign id from status fixture."
    Assert-True ($request.expectedCampaignName -eq "Example Live Campaign") "Request uses campaign name from status fixture."
    Assert-True ($request.expectedDate -eq "3025-04-09") "Request uses campaign date from status fixture."
    Assert-True ($request.expectedStateRevision -like "live-*") "Request includes state revision from status fixture."
    Assert-True ($request.noteText -eq "Fixture status-note dry-run.") "Request includes note text."
    Assert-True ($request.dryRun -eq $true) "Request is dry-run."
    Assert-True ($request.promptPolicy -eq "refuse_if_prompt") "Request refuses prompts."
    Assert-True ($request.saveAfterSuccess -eq $false) "Request does not request save after success."
    Assert-True ($null -eq $request.savePath) "Request has no save path."

    $clientContextNames = @($request.clientContext.PSObject.Properties.Name)
    Assert-True ($clientContextNames.Count -eq 4) "clientContext has exactly four fields."
    foreach ($field in @("actor", "sceneId", "actionId", "reason")) {
        Assert-True ($clientContextNames -contains $field) "clientContext includes $field."
    }
    Assert-True ($request.clientContext.actor -eq "codex-test") "clientContext actor is structured."
    Assert-True ($request.clientContext.sceneId -eq "fixture-scene") "clientContext sceneId is structured."
    Assert-True ($request.clientContext.actionId -eq "fixture-action") "clientContext actionId is structured."
    Assert-True ($request.clientContext.reason -eq "Verify structured clientContext.") "clientContext reason is structured."

    $bytes = [System.IO.File]::ReadAllBytes($requestPath)
    $hasUtf8Bom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
    Assert-True (-not $hasUtf8Bom) "Request JSON is UTF-8 without BOM."

    Write-Step "Checking explicit input path without fixture files."
    $explicitOutput = Invoke-Helper @(
        "-ExpectedCampaignName", "Explicit Campaign",
        "-ExpectedDate", "3025-04-10",
        "-ExpectedStateRevision", "live-explicit-3025-04-10",
        "-NoteText", "Explicit smoke.",
        "-IdempotencyKey", "mek-rpg-explicit-status-note-001",
        "-Actor", "codex-test",
        "-SceneId", "explicit-scene",
        "-ActionId", "explicit-action",
        "-Reason", "Verify explicit guarded input."
    ) "Build status-note request from explicit inputs"
    $explicitRequest = $explicitOutput | ConvertFrom-Json
    Assert-True ($explicitRequest.expectedCampaignName -eq "Explicit Campaign") "Explicit request keeps campaign name guard."
    Assert-True ($explicitRequest.expectedDate -eq "3025-04-10") "Explicit request keeps date guard."
    Assert-True ($explicitRequest.expectedCampaignId -eq $null) "Explicit request allows campaign name guard when id is unavailable."
    Assert-True ($explicitRequest.dryRun -eq $true) "Explicit request remains dry-run."
    Assert-True ($explicitRequest.saveAfterSuccess -eq $false) "Explicit request remains non-saving."

    Write-Step "Checking malformed clientContext shapes fail before request output."
    $stringContextPath = Join-Path $tempRoot "client-context-string.json"
    $extraContextPath = Join-Path $tempRoot "client-context-extra.json"
    [System.IO.File]::WriteAllText($stringContextPath, '"plain string"', [System.Text.UTF8Encoding]::new($false))
    [System.IO.File]::WriteAllText($extraContextPath, '{"actor":"codex","sceneId":"scene","actionId":"action","reason":"reason","source":"extra"}', [System.Text.UTF8Encoding]::new($false))

    Invoke-HelperExpectFailure @(
        "-ExpectedCampaignId", "11111111-2222-3333-4444-555555555555",
        "-ExpectedDate", "3025-04-09",
        "-NoteText", "Bad context.",
        "-IdempotencyKey", "mek-rpg-bad-context-001",
        "-ClientContextJson", $stringContextPath
    ) "clientContext must be a structured JSON object" "String clientContext refusal" | Out-Null

    Invoke-HelperExpectFailure @(
        "-ExpectedCampaignId", "11111111-2222-3333-4444-555555555555",
        "-ExpectedDate", "3025-04-09",
        "-NoteText", "Bad context.",
        "-IdempotencyKey", "mek-rpg-bad-context-002",
        "-ClientContextJson", $extraContextPath
    ) "unsupported field\(s\): source" "Extra clientContext field refusal" | Out-Null

    Write-Step "Checking missing guard fields fail before request output."
    Invoke-HelperExpectFailure @(
        "-ExpectedCampaignId", "11111111-2222-3333-4444-555555555555",
        "-NoteText", "Missing date.",
        "-IdempotencyKey", "mek-rpg-missing-date-001",
        "-Actor", "codex-test",
        "-SceneId", "scene",
        "-ActionId", "action",
        "-Reason", "reason"
    ) "Missing required value: ExpectedDate" "Missing date guard refusal" | Out-Null

    Invoke-HelperExpectFailure @(
        "-ExpectedDate", "3025-04-09",
        "-NoteText", "Missing identity.",
        "-IdempotencyKey", "mek-rpg-missing-identity-001",
        "-Actor", "codex-test",
        "-SceneId", "scene",
        "-ActionId", "action",
        "-Reason", "reason"
    ) "At least one campaign identity guard is required" "Missing campaign identity guard refusal" | Out-Null
}
finally {
    Remove-TempFixtures
    Pop-Location
}

Assert-True (-not (Test-Path -LiteralPath $tempRoot)) "Temporary status-note command fixture folder removed."

Write-Host ""
Write-Host "MekHQ status-note command helper tests passed."
