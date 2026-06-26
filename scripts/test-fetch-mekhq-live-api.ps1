param()

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$scriptPath = Join-Path $repoRoot "scripts\fetch-mekhq-live-api.ps1"
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) "mek-rpg-live-api-fetch-fixture"
$serverScriptPath = Join-Path $tempRoot "fake_mekhq_api.py"
$outputPath = Join-Path $tempRoot "capture"
$serverProcess = $null

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

function Remove-TempFixtures {
    if (Test-Path -LiteralPath $tempRoot) {
        Remove-Item -LiteralPath $tempRoot -Recurse -Force
    }
}

function Get-FreePort {
    $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Parse("127.0.0.1"), 0)
    $listener.Start()
    try {
        return $listener.LocalEndpoint.Port
    }
    finally {
        $listener.Stop()
    }
}

function Wait-ForServer {
    param(
        [string]$Url,
        [int]$TimeoutSeconds = 10
    )

    $deadline = [DateTime]::UtcNow.AddSeconds($TimeoutSeconds)
    while ([DateTime]::UtcNow -lt $deadline) {
        try {
            Invoke-RestMethod -Method Get -Uri "$Url/status" -TimeoutSec 1 | Out-Null
            return
        }
        catch {
            Start-Sleep -Milliseconds 200
        }
    }
    throw "Fake MekHQ API server did not become ready."
}

Push-Location $repoRoot
try {
    Write-Step "Starting fake MekHQ live API server."
    Remove-TempFixtures
    New-Item -ItemType Directory -Path $tempRoot | Out-Null
    $port = Get-FreePort
    $apiBaseUrl = "http://127.0.0.1:$port"

    @'
import json
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import parse_qs, urlparse

PORT = int(sys.argv[1])


def body_for(path, query):
    if path == "/status":
        return {
            "status": "ready",
            "campaignId": "11111111-2222-3333-4444-555555555555",
            "campaignName": "Fetch Fixture Campaign",
            "campaignDate": "3025-04-11",
            "visibleDialogs": 0,
            "saveAttempted": False,
        }
    if path == "/campaign/summary":
        return {
            "status": "ready",
            "apiMode": "local-read-only-live-context",
            "readOnly": True,
            "campaignId": "11111111-2222-3333-4444-555555555555",
            "campaignName": "Fetch Fixture Campaign",
            "campaignDate": "3025-04-11",
            "stateRevision": "live-fetch-fixture-3025-04-11",
        }
    if path == "/campaign/state":
        sections = query.get("sections", [""])[0].split(",")
        return {
            "bridge_metadata": {
                "schema_name": "mekhq-live-campaign-state",
                "api_mode": "local-read-only-live-context",
                "read_only": True,
                "state_revision": "live-fetch-fixture-3025-04-11",
                "requested_sections": sections,
            },
            "campaign": {
                "id": {"value": "11111111-2222-3333-4444-555555555555"},
                "name": {"value": "Fetch Fixture Campaign"},
                "date": {"value": "3025-04-11"},
            },
            "unsupported": [],
        }
    if path == "/campaign/commands":
        selector_detail = query.get("selectorDetail", ["cheap"])[0]
        return {
            "status": "ready",
            "schema_name": "mekhq-live-campaign-commands",
            "read_only": True,
            "selector_detail": selector_detail,
            "command_readiness": [
                {
                    "command": "campaign.status_note",
                    "endpoint": "/campaign/command/status-note",
                    "status": "available",
                    "dry_run_supported": True,
                    "requires_command_envelope": True,
                }
            ],
        }
    if path == "/campaign/pending-deployments":
        return {
            "schema_name": "mekhq-live-pending-deployments",
            "read_only": True,
            "query": query,
            "pending_scenario_count": 1,
        }
    return None


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        parsed = urlparse(self.path)
        payload = body_for(parsed.path, parse_qs(parsed.query))
        if payload is None:
            self.send_response(404)
            self.end_headers()
            return
        data = json.dumps(payload).encode("utf-8")
        self.send_response(200)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def log_message(self, format, *args):
        return


HTTPServer(("127.0.0.1", PORT), Handler).serve_forever()
'@ | Set-Content -LiteralPath $serverScriptPath -Encoding UTF8

    $serverProcess = Start-Process -FilePath "python" -ArgumentList @($serverScriptPath, $port) -PassThru -WindowStyle Hidden
    Wait-ForServer -Url $apiBaseUrl

    Write-Step "Capturing live API JSON files from fake server."
    $captureOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath `
        -ApiBaseUrl $apiBaseUrl `
        -OutputDirectory $outputPath `
        -StateSections @("bridge_metadata", "campaign", "unsupported") `
        -SelectorDetailFull `
        -PendingDeploymentsPersonName "Moreno" 2>&1
    if ($LASTEXITCODE -ne 0) {
        $captureOutput | ForEach-Object { Write-Host $_ }
        throw "fetch-mekhq-live-api.ps1 failed with exit code $LASTEXITCODE."
    }

    $expectedFiles = @(
        "mekhq-status.json",
        "mekhq-summary.json",
        "mekhq-state.json",
        "mekhq-commands.json",
        "mekhq-commands-full.json",
        "mekhq-pending-deployments.json",
        "mekhq-pending-deployments-viewpoint.json",
        "mekhq-live-api-capture-manifest.json"
    )
    foreach ($file in $expectedFiles) {
        Assert-True (Test-Path -LiteralPath (Join-Path $outputPath $file) -PathType Leaf) "Captured file exists: $file"
    }

    $status = Get-Content -LiteralPath (Join-Path $outputPath "mekhq-status.json") -Raw | ConvertFrom-Json
    $summary = Get-Content -LiteralPath (Join-Path $outputPath "mekhq-summary.json") -Raw | ConvertFrom-Json
    $state = Get-Content -LiteralPath (Join-Path $outputPath "mekhq-state.json") -Raw | ConvertFrom-Json
    $commands = Get-Content -LiteralPath (Join-Path $outputPath "mekhq-commands.json") -Raw | ConvertFrom-Json
    $commandsFull = Get-Content -LiteralPath (Join-Path $outputPath "mekhq-commands-full.json") -Raw | ConvertFrom-Json
    $pendingViewpoint = Get-Content -LiteralPath (Join-Path $outputPath "mekhq-pending-deployments-viewpoint.json") -Raw | ConvertFrom-Json
    $manifest = Get-Content -LiteralPath (Join-Path $outputPath "mekhq-live-api-capture-manifest.json") -Raw | ConvertFrom-Json

    Assert-True ($status.status -eq "ready") "Status capture preserves ready status."
    Assert-True ($summary.apiMode -eq "local-read-only-live-context") "Summary capture preserves API mode."
    Assert-True ($state.bridge_metadata.read_only -eq $true) "State capture preserves read-only proof."
    Assert-True ($state.bridge_metadata.requested_sections -contains "bridge_metadata") "State capture sends requested sections."
    Assert-True ($commands.selector_detail -eq "cheap") "Default command readiness capture is cheap."
    Assert-True ($commandsFull.selector_detail -eq "full") "Full selector command readiness capture is optional and explicit."
    Assert-True ($pendingViewpoint.query.personName[0] -eq "Moreno") "Viewpoint pending-deployments query is captured."
    Assert-True ($manifest.status -eq "captured") "Manifest reports captured status."
    Assert-True (@($manifest.results | Where-Object { $_.status -eq "captured" }).Count -eq $expectedFiles.Count - 1) "Manifest records every endpoint capture."

    $statusBytes = [System.IO.File]::ReadAllBytes((Join-Path $outputPath "mekhq-status.json"))
    $hasUtf8Bom = $statusBytes.Length -ge 3 -and $statusBytes[0] -eq 0xEF -and $statusBytes[1] -eq 0xBB -and $statusBytes[2] -eq 0xBF
    Assert-True (-not $hasUtf8Bom) "Captured JSON is UTF-8 without BOM."

    Write-Step "Checking failure mode writes error file and nonzero exit."
    $badOutputPath = Join-Path $tempRoot "failed-capture"
    $badOutput = & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath `
        -ApiBaseUrl "http://127.0.0.1:$($port + 1)" `
        -OutputDirectory $badOutputPath 2>&1
    Assert-True ($LASTEXITCODE -ne 0) "Required capture failure exits non-zero."
    Assert-True (Test-Path -LiteralPath (Join-Path $badOutputPath "mekhq-status.error.json") -PathType Leaf) "Failure capture writes endpoint error JSON."
    Assert-True (Test-Path -LiteralPath (Join-Path $badOutputPath "mekhq-live-api-capture-manifest.json") -PathType Leaf) "Failure capture writes manifest."
    $failureManifest = Get-Content -LiteralPath (Join-Path $badOutputPath "mekhq-live-api-capture-manifest.json") -Raw | ConvertFrom-Json
    Assert-True ($failureManifest.status -eq "failed") "Failure manifest reports failed status."
}
finally {
    if ($null -ne $serverProcess -and -not $serverProcess.HasExited) {
        Stop-Process -Id $serverProcess.Id -Force
    }
    Remove-TempFixtures
    Pop-Location
}

Assert-True (-not (Test-Path -LiteralPath $tempRoot)) "Temporary live API fetch fixture folder removed."

Write-Host ""
Write-Host "MekHQ live API fetch helper tests passed."
