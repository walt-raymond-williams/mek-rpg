$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$scriptPath = Join-Path $repoRoot "scripts\archive-campaign-session.ps1"
$campaignsRoot = Join-Path $repoRoot "campaigns"
$fixtureId = "archive-helper-fixture"
$fixturePath = Join-Path $campaignsRoot $fixtureId
$backupRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("mek-rpg-archive-helper-test-" + [System.Guid]::NewGuid().ToString("N"))

function Write-Step {
    param([string]$Message)
    Write-Output "TEST: $Message"
}

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Message
    )

    if (-not $Condition) {
        throw "ASSERTION FAILED: $Message"
    }

    Write-Output "OK: $Message"
}

function Invoke-Archive {
    param(
        [string[]]$Arguments,
        [int]$ExpectedExitCode,
        [string]$Message
    )

    $previousErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $output = & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath @Arguments 2>&1
        $exitCode = $LASTEXITCODE
    }
    finally {
        $ErrorActionPreference = $previousErrorActionPreference
    }

    if ($exitCode -ne $ExpectedExitCode) {
        $output | ForEach-Object { Write-Output $_ }
        throw "ASSERTION FAILED: $Message exited with $exitCode; expected $ExpectedExitCode."
    }

    Write-Output "OK: $Message"
    return ($output -join "`n")
}

try {
    Write-Step "Creating disposable campaign fixture."
    if (Test-Path -LiteralPath $fixturePath) {
        $resolvedFixture = (Resolve-Path $fixturePath).Path
        $resolvedCampaigns = (Resolve-Path $campaignsRoot).Path
        Assert-True ($resolvedFixture.StartsWith($resolvedCampaigns, [System.StringComparison]::OrdinalIgnoreCase)) "Disposable campaign path stays inside campaigns/."
        Remove-Item -LiteralPath $fixturePath -Recurse -Force
    }

    Copy-Item -LiteralPath (Join-Path $campaignsRoot "_template") -Destination $fixturePath -Recurse

    $sessionText = @"
# Session Log

## Active Or Most Recent Session

Date: 3025-08-03

Mode: Play mode

## Summary

The crew finished a test scene and made choices worth preserving.

## Next Session

- Follow the archived hook.
"@

    Set-Content -LiteralPath (Join-Path $fixturePath "session-log.md") -Value $sessionText -Encoding UTF8
    Set-Content -LiteralPath (Join-Path $fixturePath "previous-sessions.md") -Value "# Previous Sessions`n`n## Session Entries`n" -Encoding UTF8

    Write-Step "Checking helper refuses mutation without confirmation."
    $refusal = Invoke-Archive -Arguments @($fixtureId, "-RepoRoot", $repoRoot, "-ArchiveTitle", "Refused Test", "-BackupRoot", $backupRoot) -ExpectedExitCode 1 -Message "Archive without -ConfirmArchive refuses"
    Assert-True (($refusal -join "`n") -match "Refusing to change files without -ConfirmArchive") "Refusal message explains -ConfirmArchive requirement."

    Write-Step "Checking WhatIf does not change files."
    $beforePrevious = Get-Content -LiteralPath (Join-Path $fixturePath "previous-sessions.md") -Raw
    $beforeSession = Get-Content -LiteralPath (Join-Path $fixturePath "session-log.md") -Raw
    Invoke-Archive -Arguments @($fixtureId, "-RepoRoot", $repoRoot, "-ArchiveTitle", "Preview Test", "-BackupRoot", $backupRoot, "-WhatIf") -ExpectedExitCode 0 -Message "WhatIf archive preview" | Out-Null
    Assert-True ((Get-Content -LiteralPath (Join-Path $fixturePath "previous-sessions.md") -Raw) -eq $beforePrevious) "WhatIf leaves previous-sessions.md unchanged."
    Assert-True ((Get-Content -LiteralPath (Join-Path $fixturePath "session-log.md") -Raw) -eq $beforeSession) "WhatIf leaves session-log.md unchanged."

    Write-Step "Archiving without reset preserves session log and appends exact text."
    Invoke-Archive -Arguments @($fixtureId, "-RepoRoot", $repoRoot, "-ArchiveTitle", "Test Session", "-BackupRoot", $backupRoot, "-ConfirmArchive") -ExpectedExitCode 0 -Message "Archive without reset" | Out-Null
    $previousAfterArchive = Get-Content -LiteralPath (Join-Path $fixturePath "previous-sessions.md") -Raw
    $sessionAfterArchive = Get-Content -LiteralPath (Join-Path $fixturePath "session-log.md") -Raw
    Assert-True ($previousAfterArchive -match "### Test Session") "Archive entry title is appended."
    Assert-True ($previousAfterArchive -match "The crew finished a test scene") "Archive preserves original session text."
    Assert-True ($sessionAfterArchive -eq $beforeSession) "Archive without reset leaves session-log.md unchanged."

    Write-Step "Archiving with reset appends exact text and resets session log."
    Set-Content -LiteralPath (Join-Path $fixturePath "session-log.md") -Value ($sessionText -replace "test scene", "second scene") -Encoding UTF8
    Invoke-Archive -Arguments @($fixtureId, "-RepoRoot", $repoRoot, "-ArchiveTitle", "Reset Session", "-BackupRoot", $backupRoot, "-ConfirmArchive", "-ResetSessionLog") -ExpectedExitCode 0 -Message "Archive with reset" | Out-Null
    $previousAfterReset = Get-Content -LiteralPath (Join-Path $fixturePath "previous-sessions.md") -Raw
    $sessionAfterReset = Get-Content -LiteralPath (Join-Path $fixturePath "session-log.md") -Raw
    Assert-True ($previousAfterReset -match "### Reset Session") "Reset archive entry title is appended."
    Assert-True ($previousAfterReset -match "The crew finished a second scene") "Reset archive preserves original session text."
    Assert-True ($sessionAfterReset -match "Previous session-log contents were archived") "Reset writes archive note to session-log.md."
    Assert-True ($sessionAfterReset -match "Date: TBD") "Reset restores session-log template fields."

    Write-Step "Validating disposable campaign after archive operations."
    & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $repoRoot "scripts\validate-campaign-state.ps1") -RepoRoot $repoRoot -CampaignId $fixtureId | Out-Host
    if ($LASTEXITCODE -ne 0) {
        throw "Campaign validator failed for archive helper fixture."
    }

    Write-Output ""
    Write-Output "Archive campaign session helper tests passed."
}
finally {
    if (Test-Path -LiteralPath $fixturePath) {
        $resolvedFixture = (Resolve-Path $fixturePath).Path
        $resolvedCampaigns = (Resolve-Path $campaignsRoot).Path
        if ($resolvedFixture.StartsWith($resolvedCampaigns, [System.StringComparison]::OrdinalIgnoreCase)) {
            Remove-Item -LiteralPath $fixturePath -Recurse -Force
            Write-Output "OK: Disposable campaign fixture removed."
        }
    }

    if (Test-Path -LiteralPath $backupRoot) {
        Remove-Item -LiteralPath $backupRoot -Recurse -Force
        Write-Output "OK: Disposable backup fixture removed."
    }
}
