param(
    [string]$RepoRoot
)

$ErrorActionPreference = "Stop"

if (-not $RepoRoot) {
    $RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}
else {
    $RepoRoot = (Resolve-Path $RepoRoot).Path
}

$profilesRoot = Join-Path $RepoRoot "rules\professions"
$requiredFrontMatterFields = @(
    "schema_version",
    "profession_id",
    "display_name",
    "status",
    "aliases",
    "mekhq_owned_fields",
    "mek_rpg_overlay_fields",
    "allowed_actions"
)
$requiredHeadings = @(
    "## Purpose",
    "## Typical Capabilities",
    "## Relevant MekHQ Fields",
    "## Relevant RPG Skills",
    "## Allowed Actions",
    "## Roll Rules",
    "## Data Access Limits",
    "## Failure Modes",
    "## Not Yet Implemented",
    "## Example Prompt/Interaction",
    "## Test Expectations"
)

function Get-FrontMatter {
    param([string]$Content)

    if ($Content -notmatch "(?s)\A---\r?\n(?<front>.*?)\r?\n---\r?\n") {
        return $null
    }

    return $Matches.front
}

function Get-ScalarFrontMatterValue {
    param(
        [string]$FrontMatter,
        [string]$Key
    )

    $match = [regex]::Match($FrontMatter, "(?m)^$([regex]::Escape($Key)):\s*(?<value>.+?)\s*$")
    if (-not $match.Success) {
        return $null
    }

    return $match.Groups["value"].Value.Trim()
}

function Test-ListHasValue {
    param(
        [string]$FrontMatter,
        [string]$Key
    )

    $lines = $FrontMatter -split "\r?\n"
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match "^$([regex]::Escape($Key)):\s*(?<inline>\[.*\])?\s*$") {
            if ($Matches.inline) {
                return ($Matches.inline -ne "[]")
            }

            for ($j = $i + 1; $j -lt $lines.Count; $j++) {
                if ($lines[$j] -match "^[A-Za-z0-9_]+:") {
                    return $false
                }
                if ($lines[$j] -match "^\s*-\s+\S") {
                    return $true
                }
            }

            return $false
        }
    }

    return $false
}

$errors = @()
$warnings = @()

if (-not (Test-Path -LiteralPath $profilesRoot)) {
    Write-Host "ERROR: Missing profession profile directory: rules/professions"
    exit 1
}

$profileFiles = @(Get-ChildItem -LiteralPath $profilesRoot -Filter "*.md" |
    Where-Object { $_.Name -notin @("README.md", "profile-template.md") } |
    Sort-Object Name)

if ($profileFiles.Count -eq 0) {
    $errors += "No profession profile files found under rules/professions."
}

$seenIds = @{}

foreach ($file in $profileFiles) {
    $relativePath = "rules/professions/$($file.Name)"
    $content = Get-Content -Raw -LiteralPath $file.FullName
    $frontMatter = Get-FrontMatter -Content $content

    if (-not $frontMatter) {
        $errors += "$relativePath lacks YAML front matter."
        continue
    }

    foreach ($field in $requiredFrontMatterFields) {
        if ($frontMatter -notmatch "(?m)^$([regex]::Escape($field)):") {
            $errors += "$relativePath missing front matter field '$field'."
        }
    }

    $schemaVersion = Get-ScalarFrontMatterValue -FrontMatter $frontMatter -Key "schema_version"
    if ($schemaVersion -ne "profession-profile/v1") {
        $errors += "$relativePath has schema_version '$schemaVersion' instead of 'profession-profile/v1'."
    }

    $professionId = Get-ScalarFrontMatterValue -FrontMatter $frontMatter -Key "profession_id"
    if (-not $professionId -or $professionId -notmatch "^[a-z][a-z0-9_]*$") {
        $errors += "$relativePath has invalid profession_id '$professionId'."
    }
    elseif ($seenIds.ContainsKey($professionId)) {
        $errors += "$relativePath duplicates profession_id '$professionId' from $($seenIds[$professionId])."
    }
    else {
        $seenIds[$professionId] = $relativePath
    }

    $status = Get-ScalarFrontMatterValue -FrontMatter $frontMatter -Key "status"
    if ($status -ne "not_implemented") {
        $warnings += "$relativePath status is '$status'; ensure runtime lookup, action enforcement, roll behavior, and tests exist."
    }

    foreach ($listField in @("aliases", "mekhq_owned_fields", "mek_rpg_overlay_fields")) {
        if (-not (Test-ListHasValue -FrontMatter $frontMatter -Key $listField)) {
            $errors += "$relativePath front matter list '$listField' must contain at least one value."
        }
    }

    foreach ($heading in $requiredHeadings) {
        if ($content -notmatch "(?m)^$([regex]::Escape($heading))\s*$") {
            $errors += "$relativePath missing required heading '$heading'."
        }
    }

    if ($content -notmatch "(?i)MekHQ.*authoritative|MekHQ-owned|MekHQ remains") {
        $errors += "$relativePath does not clearly preserve the MekHQ-owned fact boundary."
    }

    if ($content -notmatch "(?i)reveal gate|reveal level|action spec|Data Access Limits") {
        $errors += "$relativePath does not mention action/reveal-gated data access."
    }
}

foreach ($warning in $warnings) {
    Write-Host "WARNING: $warning"
}

if ($errors.Count -gt 0) {
    foreach ($errorItem in $errors) {
        Write-Host "ERROR: $errorItem"
    }
    exit 1
}

Write-Host "Profession profile schema validation passed for $($profileFiles.Count) profile files."
exit 0
