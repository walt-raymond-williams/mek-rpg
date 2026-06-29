param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path

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

function Read-RepoFile {
    param([string]$RelativePath)

    $path = Join-Path $repoRoot $RelativePath
    Assert-True (Test-Path -LiteralPath $path -PathType Leaf) "File exists: $RelativePath"
    return Get-Content -LiteralPath $path -Raw
}

function Assert-Contains {
    param(
        [string]$Content,
        [string]$Pattern,
        [string]$Message
    )

    Assert-True ($Content -match $Pattern) $Message
}

Push-Location $repoRoot
try {
    Write-Step "Checking gap report schema and operating rule."
    $report = Read-RepoFile "docs\current\MEKHQ_PLAYTEST_API_GAP_REPORT.md"
    Assert-Contains $report "scripts/fetch-mekhq-live-api\.ps1" "Gap report names the live API fetch helper."
    Assert-Contains $report "Raw save parsing remains an explicit offline, legacy, fixture, or debugging fallback only" "Gap report keeps raw save parsing out of normal live play."

    foreach ($field in @(
        "Play context",
        "Needed data",
        "Attempted API read",
        "Missing, stale, ambiguous, or unsupported field",
        "Why it mattered for play",
        "Fallback used",
        "Expected read shape",
        "Suggested producer/API change",
        "Related issue or handoff",
        "Status"
    )) {
        Assert-Contains $report ("- " + [regex]::Escape($field) + ":") "Gap report entry schema includes '$field'."
    }

    Write-Step "Checking play startup and loop references."
    $agentInstructions = Read-RepoFile "AGENTS.md"
    Assert-Contains $agentInstructions "MEKHQ_PLAYTEST_API_GAP_REPORT\.md" "Agent instructions route missing live reads to the gap report."
    Assert-Contains $agentInstructions "Missing API data is a producer gap, not permission to silently read the active save" "Agent instructions forbid save parsing as a gap workaround."

    $sessionProcedure = Read-RepoFile "gm\session-procedure.md"
    Assert-Contains $sessionProcedure 'update `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT\.md` immediately' "Session startup requires immediate gap-report updates."
    Assert-Contains $sessionProcedure "instead of routing around the API with active-save parsing" "During-play guidance blocks active-save parsing as a workaround."
    Assert-Contains $sessionProcedure "confirm any live API read gaps discovered during play were added" "After-play guidance includes gap-report close-out."

    $linkedLoop = Read-RepoFile "docs\current\MEKHQ_LINKED_PLAY_LOOP.md"
    Assert-Contains $linkedLoop 'Use `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT\.md` for playtest gaps' "Linked play loop points to the gap report."
    Assert-Contains $linkedLoop "before continuing with a stale, unknown, or user-confirmed workaround" "Linked play loop records gap before fallback use."

    $startupDecisionTree = Read-RepoFile "docs\current\MEKHQ_OPEN_CONNECTION_STARTUP_DECISION_TREE.md"
    Assert-Contains $startupDecisionTree 'Add an entry to `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT\.md`' "Startup decision tree records missing reads in the gap report."

    Write-Step "Checking helper documentation references."
    $scriptsReadme = Read-RepoFile "scripts\README.md"
    Assert-Contains $scriptsReadme "record that fallback" "Script docs require recording live API fallback use."
    Assert-Contains $scriptsReadme "Missing or unsupported live API fields are recorded as API gaps and producer-change-request inputs" "Script docs route missing live fields to gap tracking."

    $knownCommands = Read-RepoFile "docs\current\KNOWN_COMMANDS.md"
    Assert-Contains $knownCommands "prefer the live API over save parsing" "Known commands document live API preference."
    Assert-Contains $knownCommands "summarize-mekhq-save\.py.*offline/fallback only" "Known commands label save summary as offline or fallback only."
}
finally {
    Pop-Location
}

Write-Host ""
Write-Host "MekHQ API gap reporting workflow checks passed."
