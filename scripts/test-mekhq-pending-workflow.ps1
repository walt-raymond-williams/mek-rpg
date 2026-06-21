param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$campaignsRoot = Join-Path $repoRoot "campaigns"
$fixturePath = Join-Path $repoRoot "tests\fixtures\mekhq-summary-minimal.json"
$campaignId = "mekhq-pending-regression-valid"
$missingCampaignId = "mekhq-pending-regression-missing"
$campaignPath = Join-Path $campaignsRoot $campaignId
$missingCampaignPath = Join-Path $campaignsRoot $missingCampaignId
$compiledBootstrapPath = Join-Path ([System.IO.Path]::GetTempPath()) "mek-rpg-bootstrap-mekhq-campaign.pyc"

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

function Assert-FileContains {
    param(
        [string]$Path,
        [string]$Pattern,
        [string]$Message
    )

    Assert-True (Test-Path -LiteralPath $Path -PathType Leaf) "File exists: $Path"
    $content = Get-Content -LiteralPath $Path -Raw
    Assert-True ($content -match $Pattern) $Message
}

function Invoke-Checked {
    param(
        [string]$FilePath,
        [string[]]$Arguments,
        [string]$Message
    )

    $output = & $FilePath @Arguments 2>&1
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        $output | ForEach-Object { Write-Host $_ }
        throw "$Message failed with exit code $exitCode."
    }

    Write-Host "OK: $Message"
    return $output
}

function Invoke-ExpectFailure {
    param(
        [string]$FilePath,
        [string[]]$Arguments,
        [string]$ExpectedPattern,
        [string]$Message
    )

    $output = & $FilePath @Arguments 2>&1
    $exitCode = $LASTEXITCODE
    Assert-True ($exitCode -ne 0) "$Message exits non-zero"
    $text = ($output | Out-String)
    Assert-True ($text -match $ExpectedPattern) "$Message reports expected failure"
    return $output
}

function Remove-TestCampaigns {
    foreach ($path in @($campaignPath, $missingCampaignPath)) {
        if (Test-Path -LiteralPath $path) {
            Remove-Item -LiteralPath $path -Recurse -Force
        }
    }
}

function Remove-TempFiles {
    if (Test-Path -LiteralPath $compiledBootstrapPath) {
        Remove-Item -LiteralPath $compiledBootstrapPath -Force
    }
}

Push-Location $repoRoot
try {
    Write-Step "Cleaning disposable campaign folders."
    Remove-TestCampaigns
    Remove-TempFiles

    Write-Step "Checking sanitized fixture and protected source ignore rules."
    Assert-True (Test-Path -LiteralPath $fixturePath -PathType Leaf) "Sanitized summary fixture is present."
    Invoke-Checked "git" @("check-ignore", "source/atow-pdf/example.pdf") "Protected PDF path is ignored" | Out-Null
    Invoke-Checked "git" @("check-ignore", "source/atow-text/page-001.txt") "Protected extracted text path is ignored" | Out-Null

    Write-Step "Compiling bootstrap helper."
    Invoke-Checked "python" @(
        "-c",
        "import py_compile, sys; py_compile.compile(sys.argv[1], cfile=sys.argv[2], doraise=True)",
        "scripts/bootstrap-mekhq-campaign.py",
        $compiledBootstrapPath
    ) "bootstrap-mekhq-campaign.py compiles" | Out-Null

    Write-Step "Bootstrapping disposable MekHQ-linked campaign from fixture."
    Invoke-Checked "python" @(
        "scripts/bootstrap-mekhq-campaign.py",
        "--summary",
        $fixturePath,
        "--campaign-id",
        $campaignId,
        "--viewpoint-person-id",
        "p-001"
    ) "Disposable campaign bootstrap" | Out-Null

    $pendingPath = Join-Path $campaignPath "pending-mekhq-actions.md"
    $bridgePath = Join-Path $campaignPath "mekhq-bridge.md"

    Write-Step "Checking generated pending workflow files."
    Assert-FileContains $pendingPath "hard ledger intents" "Pending actions file uses pending workflow language."
    Assert-FileContains $pendingPath "applies it in MekHQ, saves the MekHQ campaign, and MEK-RPG imports" "Pending actions file requires manual apply, save, and re-import."
    Assert-FileContains $bridgePath "pending-mekhq-actions\.md" "Bridge file points pending work to pending-mekhq-actions.md."
    Assert-FileContains $bridgePath "Do not write to .*\.cpnx.*\.cpnx\.gz.*MekHQ XML.*raw MekHQ save payloads" "Bridge file preserves no direct MekHQ save or XML writeback boundary."

    Write-Step "Running campaign validator positive check."
    Invoke-Checked "powershell" @(
        "-NoProfile",
        "-ExecutionPolicy",
        "Bypass",
        "-File",
        (Join-Path $repoRoot "scripts\validate-campaign-state.ps1"),
        $campaignId
    ) "Validator passes generated campaign" | Out-Null

    Write-Step "Running campaign validator negative check for missing pending actions file."
    Copy-Item -LiteralPath $campaignPath -Destination $missingCampaignPath -Recurse
    Remove-Item -LiteralPath (Join-Path $missingCampaignPath "pending-mekhq-actions.md") -Force
    Invoke-ExpectFailure "powershell" @(
        "-NoProfile",
        "-ExecutionPolicy",
        "Bypass",
        "-File",
        (Join-Path $repoRoot "scripts\validate-campaign-state.ps1"),
        $missingCampaignId
    ) "missing standard file: pending-mekhq-actions\.md" "Validator catches missing pending actions file" | Out-Null

    Write-Step "Checking workflow documentation writeback boundaries."
    Assert-FileContains (Join-Path $repoRoot "docs\current\MEKHQ_PENDING_APPLICATION_WORKFLOW.md") "write to .*\.cpnx.*\.cpnx\.gz.*MekHQ XML.*raw MekHQ save payloads" "Pending workflow doc forbids direct MekHQ save/XML writeback."
    Assert-FileContains (Join-Path $repoRoot "docs\current\MEKHQ_LINKED_PLAY_LOOP.md") "Direct .*\.cpnx.*\.cpnx\.gz.*XML edits" "Linked play loop keeps direct save/XML edits out of scope."
    Assert-FileContains (Join-Path $repoRoot "docs\current\MEKHQ_CAMPAIGN_BOOTSTRAP.md") "does not open, edit, or write a MekHQ .*\.cpnx.*\.cpnx\.gz.*XML save" "Bootstrap docs preserve read-only MekHQ save boundary."

    Write-Step "Ensuring no disposable campaign output remains after cleanup."
}
finally {
    Remove-TestCampaigns
    Remove-TempFiles
    Pop-Location
}

Assert-True (-not (Test-Path -LiteralPath $campaignPath)) "Disposable valid campaign folder removed."
Assert-True (-not (Test-Path -LiteralPath $missingCampaignPath)) "Disposable negative-test campaign folder removed."

Write-Host ""
Write-Host "MekHQ pending workflow regression tests passed."
