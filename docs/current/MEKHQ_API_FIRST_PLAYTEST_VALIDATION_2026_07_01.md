# MekHQ API-First Playtest Validation

Status: issue `#114` validation for epic issue `#113`.

Date: 2026-07-01.

## Result

Live validation was attempted, but the MekHQ local control API was unavailable. This validation therefore used the documented Branch C path from `docs/current/MEKHQ_OPEN_CONNECTION_STARTUP_DECISION_TREE.md`: record the unavailable API, avoid active-save parsing, and rehearse the API-first workflow against sanitized fixtures.

Fixture-backed rehearsal passed. The workflow is ready for live use when the user has MekHQ open and the local API running.

Issue `#97` remains the user-present live GM play checkpoint. It should not be closed by this rehearsal because no live scene, rules lookup, or state-save behavior was exercised with the user present.

## Live API Probe

Attempted endpoint reads:

- `GET http://127.0.0.1:32180/status`
- `GET http://127.0.0.1:32180/campaign/summary`
- `GET http://127.0.0.1:32180/campaign/state?sections=bridge_metadata,campaign,finances,personnel,units,contracts,scenarios,repairs_and_logistics,markets,reports,unsupported`
- `GET http://127.0.0.1:32180/campaign/commands`

Observed result for each read: `Unable to connect to the remote server`.

Fallback used: fixture-backed rehearsal only. No active `.cpnx`, `.cpnx.gz`, XML, or raw MekHQ save was parsed.

Gap report entry: `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`, `2026-07-01 - Live local API unavailable during API-first validation`.

## Rehearsed Workflow

The expected live command sequence remains:

```powershell
./scripts/fetch-mekhq-live-api.ps1 -OutputDirectory .\mekhq-live-api-capture
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view summary --format json
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view play-context --format json
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view command-readiness --format json
```

The fixture rehearsal used `tests/fixtures/mekhq-live-campaign-summary.fixture.json`, `tests/fixtures/mekhq-live-campaign-state.fixture.json`, `tests/fixtures/mekhq-live-campaign-commands.fixture.json`, and `tests/fixtures/mekhq-live-pending-deployments.fixture.json`.

Validated fixture views:

- `summary`: emitted campaign identity, read-only proof, counts, warnings, and gap candidates.
- `play-context`: emitted scene-start identity, finance, contract, deployment, unit, personnel, report, command, warning, and gap facts.
- `command-readiness`: emitted available and blocked command facts without executing commands.

## Verification

Passed:

- `python ./scripts/query-mekhq-live-api.py --summary-file tests/fixtures/mekhq-live-campaign-summary.fixture.json --state-file tests/fixtures/mekhq-live-campaign-state.fixture.json --commands-file tests/fixtures/mekhq-live-campaign-commands.fixture.json --pending-deployments-file tests/fixtures/mekhq-live-pending-deployments.fixture.json --view summary --format json`
- `python ./scripts/query-mekhq-live-api.py --summary-file tests/fixtures/mekhq-live-campaign-summary.fixture.json --state-file tests/fixtures/mekhq-live-campaign-state.fixture.json --commands-file tests/fixtures/mekhq-live-campaign-commands.fixture.json --pending-deployments-file tests/fixtures/mekhq-live-pending-deployments.fixture.json --view play-context --format json`
- `python ./scripts/query-mekhq-live-api.py --summary-file tests/fixtures/mekhq-live-campaign-summary.fixture.json --state-file tests/fixtures/mekhq-live-campaign-state.fixture.json --commands-file tests/fixtures/mekhq-live-campaign-commands.fixture.json --pending-deployments-file tests/fixtures/mekhq-live-pending-deployments.fixture.json --view command-readiness --format json`
- `./scripts/validate-campaign-state.ps1 -StrictActive`
- `./scripts/test-query-mekhq-live-api.ps1`
- `./scripts/test-all.ps1 -Quick`
- `git diff --check`
- `git check-ignore -v mekhq-live-api-capture/mekhq-state.json`
- `git check-ignore -v source/atow-pdf/example.pdf`
- `git check-ignore -v source/atow-text/example.txt`

## Close-Out

Issue `#114` can close as a fixture-backed validation with live API unavailable. Epic issue `#113` can close because its child work is complete: static audit, startup SOP hardening, gap-report workflow, and validation/blocker recording.

Remaining live-play work belongs to issue `#97`, which is user-gated and should run only when the user is present and MekHQ is available.
