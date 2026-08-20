param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

$ErrorActionPreference = "Stop"

function Assert-True {
    param(
        [bool]$Condition,
        [string]$Message
    )
    if (-not $Condition) {
        throw "ASSERTION FAILED: $Message"
    }
}

function Write-Step {
    param([string]$Message)
    Write-Host "[test-report-mekhq-education-tracker] $Message"
}

$scriptPath = Join-Path $RepoRoot "scripts/report-mekhq-education-tracker.py"
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("mek-rpg-education-tracker-test-" + [System.Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tempRoot | Out-Null

try {
    $statePath = Join-Path $tempRoot "mekhq-state.json"
    $csvPath = Join-Path $tempRoot "education.csv"
    $markdownPath = Join-Path $tempRoot "education.md"

    $state = [ordered]@{
        bridge_metadata = [ordered]@{
            api_mode = "local-read-only-live-context"
            read_only = $true
            snapshot_id = "fixture-snapshot"
            state_revision = "fixture-revision"
        }
        campaign = [ordered]@{
            id = "fixture-campaign"
            name = "Fixture Campaign"
            date = "3044-01-16"
            location = "Fixture World"
        }
        personnel = @(
            [ordered]@{
                id = "student-1"
                display_name = "Current Student"
                full_title = "Recruit Current Student"
                status = [ordered]@{ label = "Student" }
                rank = [ordered]@{ label = "Recruit" }
                primary_role = [ordered]@{ label = "Professional" }
                secondary_role = [ordered]@{ label = "" }
                assignments = [ordered]@{ joined_campaign = "3044-01-01"; recruitment_date = "3044-01-01"; employed = $true; deployed = $false; unit_name = ""; unit_id = ""; crew_role = ""; formation_id = ""; formation_name = "" }
                salary = [ordered]@{ value = 100 }
            },
            [ordered]@{
                id = "graduate-candidate-1"
                display_name = "Likely Graduate"
                full_title = "Recruit Likely Graduate"
                status = [ordered]@{ label = "Active" }
                rank = [ordered]@{ label = "Recruit" }
                primary_role = [ordered]@{ label = "MekWarrior" }
                secondary_role = [ordered]@{ label = "" }
                assignments = [ordered]@{ joined_campaign = "3044-01-02"; recruitment_date = "3044-01-02"; employed = $true; deployed = $false; unit_name = "Training Lance"; unit_id = "unit-1"; crew_role = "Pilot"; formation_id = ""; formation_name = "" }
                salary = [ordered]@{ value = 200 }
            },
            [ordered]@{
                id = "background-1"
                display_name = "Background Specialist"
                full_title = "Background Specialist"
                status = [ordered]@{ label = "Background Character" }
                rank = [ordered]@{ label = "" }
                primary_role = [ordered]@{ label = "Lawyer" }
                secondary_role = [ordered]@{ label = "" }
                assignments = [ordered]@{ joined_campaign = "3044-01-03"; recruitment_date = "3044-01-03"; employed = $true; deployed = $false; unit_name = ""; unit_id = ""; crew_role = ""; formation_id = ""; formation_name = "" }
                salary = [ordered]@{ value = 300 }
            },
            [ordered]@{
                id = "dependent-1"
                display_name = "Active Dependent"
                full_title = "Active Dependent"
                status = [ordered]@{ label = "Camp Follower" }
                rank = [ordered]@{ label = "" }
                primary_role = [ordered]@{ label = "Dependent" }
                secondary_role = [ordered]@{ label = "" }
                assignments = [ordered]@{ joined_campaign = "3044-01-04"; recruitment_date = "3044-01-04"; employed = $true; deployed = $false; unit_name = ""; unit_id = ""; crew_role = ""; formation_id = ""; formation_name = "" }
                salary = [ordered]@{ value = 400 }
            },
            [ordered]@{
                id = "departed-1"
                display_name = "Departed Dependent"
                full_title = "Departed Dependent"
                status = [ordered]@{ label = "Left" }
                rank = [ordered]@{ label = "" }
                primary_role = [ordered]@{ label = "Dependent" }
                secondary_role = [ordered]@{ label = "" }
                assignments = [ordered]@{ joined_campaign = "3044-01-05"; recruitment_date = "3044-01-05"; employed = $false; deployed = $false; unit_name = ""; unit_id = ""; crew_role = ""; formation_id = ""; formation_name = "" }
                salary = [ordered]@{ value = 0 }
            },
            [ordered]@{
                id = "ignored-1"
                display_name = "Ignored Veteran"
                full_title = "Sergeant Ignored Veteran"
                status = [ordered]@{ label = "Active" }
                rank = [ordered]@{ label = "Sergeant" }
                primary_role = [ordered]@{ label = "MekWarrior" }
                secondary_role = [ordered]@{ label = "" }
                assignments = [ordered]@{ joined_campaign = "3044-01-06"; recruitment_date = "3044-01-06"; employed = $true; deployed = $false; unit_name = "Line Lance"; unit_id = "unit-2"; crew_role = "Pilot"; formation_id = ""; formation_name = "" }
                salary = [ordered]@{ value = 500 }
            }
        )
    }
    $stateJson = @'
{
  "bridge_metadata": {
    "api_mode": "local-read-only-live-context",
    "read_only": true,
    "snapshot_id": "fixture-snapshot",
    "state_revision": "fixture-revision"
  },
  "campaign": {
    "id": "fixture-campaign",
    "name": "Fixture Campaign",
    "date": "3044-01-16",
    "location": "Fixture World"
  },
  "personnel": [
    {
      "id": "student-1",
      "display_name": "Current Student",
      "full_title": "Recruit Current Student",
      "status": { "label": "Student" },
      "rank": { "label": "Recruit" },
      "primary_role": { "label": "Professional" },
      "secondary_role": { "label": "" },
      "assignments": { "joined_campaign": "3044-01-01", "recruitment_date": "3044-01-01", "employed": true, "deployed": false, "unit_name": "", "unit_id": "", "crew_role": "", "formation_id": "", "formation_name": "" },
      "salary": { "value": 100 }
    },
    {
      "id": "graduate-candidate-1",
      "display_name": "Likely Graduate",
      "full_title": "Recruit Likely Graduate",
      "status": { "label": "Active" },
      "rank": { "label": "Recruit" },
      "primary_role": { "label": "MekWarrior" },
      "secondary_role": { "label": "" },
      "assignments": { "joined_campaign": "3044-01-02", "recruitment_date": "3044-01-02", "employed": true, "deployed": false, "unit_name": "Training Lance", "unit_id": "unit-1", "crew_role": "Pilot", "formation_id": "", "formation_name": "" },
      "salary": { "value": 200 }
    },
    {
      "id": "background-1",
      "display_name": "Background Specialist",
      "full_title": "Background Specialist",
      "status": { "label": "Background Character" },
      "rank": { "label": "" },
      "primary_role": { "label": "Lawyer" },
      "secondary_role": { "label": "" },
      "assignments": { "joined_campaign": "3044-01-03", "recruitment_date": "3044-01-03", "employed": true, "deployed": false, "unit_name": "", "unit_id": "", "crew_role": "", "formation_id": "", "formation_name": "" },
      "salary": { "value": 300 }
    },
    {
      "id": "dependent-1",
      "display_name": "Active Dependent",
      "full_title": "Active Dependent",
      "status": { "label": "Camp Follower" },
      "rank": { "label": "" },
      "primary_role": { "label": "Dependent" },
      "secondary_role": { "label": "" },
      "assignments": { "joined_campaign": "3044-01-04", "recruitment_date": "3044-01-04", "employed": true, "deployed": false, "unit_name": "", "unit_id": "", "crew_role": "", "formation_id": "", "formation_name": "" },
      "salary": { "value": 400 }
    },
    {
      "id": "departed-1",
      "display_name": "Departed Dependent",
      "full_title": "Departed Dependent",
      "status": { "label": "Left" },
      "rank": { "label": "" },
      "primary_role": { "label": "Dependent" },
      "secondary_role": { "label": "" },
      "assignments": { "joined_campaign": "3044-01-05", "recruitment_date": "3044-01-05", "employed": false, "deployed": false, "unit_name": "", "unit_id": "", "crew_role": "", "formation_id": "", "formation_name": "" },
      "salary": { "value": 0 }
    },
    {
      "id": "ignored-1",
      "display_name": "Ignored Veteran",
      "full_title": "Sergeant Ignored Veteran",
      "status": { "label": "Active" },
      "rank": { "label": "Sergeant" },
      "primary_role": { "label": "MekWarrior" },
      "secondary_role": { "label": "" },
      "assignments": { "joined_campaign": "3044-01-06", "recruitment_date": "3044-01-06", "employed": true, "deployed": false, "unit_name": "Line Lance", "unit_id": "unit-2", "crew_role": "Pilot", "formation_id": "", "formation_name": "" },
      "salary": { "value": 500 }
    }
  ]
}
'@
    [System.IO.File]::WriteAllText($statePath, $stateJson, [System.Text.UTF8Encoding]::new($false))

    Write-Step "Generating tracker CSV and Markdown from fixture live state."
    & python $scriptPath --state-file $statePath --csv-out $csvPath --markdown-out $markdownPath --limit 10
    if ($LASTEXITCODE -ne 0) {
        throw "report-mekhq-education-tracker.py exited with $LASTEXITCODE"
    }

    $csvCheckScript = @'
import csv
import json
import sys
from collections import Counter

with open(sys.argv[1], "r", encoding="utf-8-sig", newline="") as handle:
    rows = list(csv.DictReader(handle))

counts = Counter(row["tracking_status"] for row in rows)
print(json.dumps({"total": len(rows), "counts": dict(counts)}))
'@
    $classification = ($csvCheckScript | python - $csvPath) | ConvertFrom-Json
    Assert-True ($classification.total -eq 5) "Only tracked education candidates are emitted."
    Assert-True ($classification.counts.enrolled_current -eq 1) "Current student is classified."
    Assert-True ($classification.counts.graduation_candidate -eq 1) "Likely graduate is classified."
    Assert-True ($classification.counts.background_role_review -eq 1) "Background specialist is classified."
    Assert-True ($classification.counts.dependent_on_payroll_review -eq 1) "Active dependent is classified."
    Assert-True ($classification.counts.departed_dependent -eq 1) "Departed dependent is classified."
    Assert-True ((Get-Content -Raw $markdownPath).Contains("Likely missed-graduation/job candidates: 1")) "Markdown summarizes graduation candidates."
    Assert-True (-not ((Get-Content -Raw $markdownPath).Contains("Ignored Veteran"))) "Ignored personnel are omitted from Markdown snapshot."
}
finally {
    if (Test-Path $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
    }
}

Write-Host "OK: report-mekhq-education-tracker fixture tests passed."
