# MekHQ Query View Workflow Validation

Status: issue `#145` validation for epic issue `#139`.

Date: 2026-07-01.

## Result

Fixture-backed validation passed. Live MekHQ validation was attempted against `http://127.0.0.1:32180/status` and was unavailable because no local MekHQ control server was reachable.

The workflow is ready for normal play use:

1. Capture live MekHQ API JSON with `scripts/fetch-mekhq-live-api.ps1`.
2. Read compact query views with `scripts/query-mekhq-live-api.py`.
3. Feed compact query output into GM context instead of raw capture JSON.
4. Use raw capture JSON only for debugging, source-shape investigation, or new view development.
5. Route missing, unsupported, failed, or partial live reads to `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`.

## Validated Command Sequence

Normal startup command shape:

```powershell
./scripts/fetch-mekhq-live-api.ps1 -OutputDirectory .\mekhq-live-api-capture
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view summary --format json
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view play-context --format json
```

Focused view command shapes:

```powershell
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view pending-deployments --format json
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view person-commitment --person-name Moreno --format json
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view unit-readiness --format json
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view repair-pressure --format json
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view reports --format json
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view command-readiness --format json
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view api-gaps --format json
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view person-detail --format json
```

## Verification

Passed:

- `./scripts/test-query-mekhq-live-api.ps1`
- `./scripts/test-mekhq-api-gap-reporting.ps1`
- `./scripts/test-build-gm-context-packet.ps1`
- `./scripts/test-mekhq-context-packet.ps1`
- `./scripts/test-all.ps1 -Quick`
- `git diff --check`
- `git check-ignore -v mekhq-live-api-capture/mekhq-state.json`
- `git check-ignore -v source/atow-pdf/example.pdf`
- `git check-ignore -v source/atow-text/example.txt`

Live validation:

- Attempted `GET http://127.0.0.1:32180/status`.
- Result: unavailable, connection failed.
- Blocker: no live MekHQ local control server reachable during this validation pass.
- Fallback used: fixture-backed validation only.

## Boundary Check

Raw live capture directories remain ignored by `.gitignore` via `mekhq-live-api-capture*/`.

Protected A Time of War source paths remain ignored:

- `source/atow-pdf/`
- `source/atow-text/`

No raw capture files, raw MekHQ saves, protected source text, PDFs, EPUBs, or secrets are part of this validation.

## Remaining Work

No follow-up query-view implementation issue is required from this validation. Live validation can happen later as part of issue `#114` or a playtest checkpoint when MekHQ is open.

Recommended next project task after closing epic `#139`: issue `#114`, API-first MekHQ playtest workflow validation, because it is the remaining child under epic `#113` and can exercise the query-view workflow during an actual MekHQ-linked playtest when the user has MekHQ available.
