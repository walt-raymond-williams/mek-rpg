# Agent Handoff

## Issue

- GitHub issue: `#118` Align MEK-RPG processes with live MekHQ API contract
- Roadmap entry: `docs/current/ROADMAP.md` -> `MekHQ live API contract alignment`
- Mode: Project development
- Priority: High follow-up after issue `#117` / before or alongside issue `#114` live validation

## Goal

Study the current consumer-facing live MekHQ API contract from the MegaMek workspace and update MEK-RPG's durable procedures, docs, scripts, fixtures, and tests so live play and command workflows use the API correctly.

## Completion Notes

- Completed issue `#118` contract alignment in MEK-RPG.
- Updated startup/play guidance to begin with `/status`, use `/campaign/pending-deployments` for current scenario and viewpoint-person commitment lookup, include `bridge_metadata` in selected state reads, and surface partial responses, warnings, unsupported entries, collector failures, and timeouts.
- Updated command guidance to build workflows from `/campaign/commands`, request `selectorDetail=full` only when entering command workflows that need deferred selectors, use guarded command envelopes with state revision, idempotency key, prompt policy, client audit context, dry-run/preflight for high-value actions, and opt-in `saveAfterSuccess`.
- Added `tests/fixtures/mekhq-live-pending-deployments.fixture.json` and expanded `scripts/test-mekhq-live-api-fixtures.ps1` coverage.
- Live MekHQ smoke checks were not run; this was a static contract-consumption pass.
- The MegaMek workspace contract and fixture were read for evidence; that workspace was not edited.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `C:/Users/waltr/Documents/megamek-workspace/docs/current/MEK_RPG_LIVE_MEKHQ_API_CONTRACT.md`

Related MEK-RPG docs likely to matter:

- `docs/current/MEKHQ_OPEN_CONNECTION_STARTUP_DECISION_TREE.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEKHQ_COMMAND_API_STRATEGY.md`
- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`
- `docs/current/MEKHQ_LIVE_API_EXPANSION_TRACKING.md`
- `docs/current/MEKHQ_LIVE_API_SAVE_COVERAGE_AUDIT.md`
- `docs/current/MEGAMEK_LIVE_API_CHANGE_REQUEST.md`
- `docs/current/KNOWN_COMMANDS.md`
- `scripts/README.md`
- `gm/session-procedure.md`
- `gm/scene-loop.md`

## Expected Output

- Audit MEK-RPG process docs and consumer scripts/tests against the contract.
- Update read workflow guidance for `/status`, `/campaign/summary`, `/campaign/state`, `/campaign/pending-deployments`, selected sections, `bridge_metadata`, partial responses, warnings, unsupported entries, and timeout expectations.
- Update command workflow guidance so available commands come from `/campaign/commands`; expensive selectors are requested with `selectorDetail=full` only when entering a command workflow; high-value mutations dry-run first; command requests include guard facts, state revision, idempotency key, prompt policy, and audit context; `saveAfterSuccess` remains opt-in.
- Update fixtures, adapters, tests, or follow-up gap records where the current MEK-RPG consumer shape has drifted from the contract.
- Record producer/API gaps in MEK-RPG's existing gap/change-request path instead of editing the MegaMek workspace.

## Files And Areas

Likely files to read or edit:

- `AGENTS.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/current/MEKHQ_OPEN_CONNECTION_STARTUP_DECISION_TREE.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEKHQ_COMMAND_API_STRATEGY.md`
- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`
- `docs/current/KNOWN_COMMANDS.md`
- `scripts/README.md`
- `scripts/sync-mekhq-live-campaign.py`
- `scripts/export-dashboard-data.ps1`
- `tests/fixtures/mekhq-live-*.json`
- related `scripts/test-*mekhq*` suites

## Commands

Useful commands or checks:

```powershell
git status --short --branch
rg -n "campaign/summary|campaign/state|campaign/commands|pending-deployments|advance-day|save parser|cpnx|selectorDetail|saveAfterSuccess|dryRun|bridge_metadata|TimeoutSec" AGENTS.md docs gm scripts tests
./scripts/test-all.ps1 -Quick
git diff --check
git check-ignore source/atow-pdf source/atow-text
```

Live MekHQ smoke checks are optional and user-gated:

```powershell
Invoke-RestMethod -Method Get -Uri 'http://127.0.0.1:32180/status' -TimeoutSec 5
Invoke-RestMethod -Method Get -Uri 'http://127.0.0.1:32180/campaign/summary' -TimeoutSec 15
Invoke-RestMethod -Method Get -Uri 'http://127.0.0.1:32180/campaign/pending-deployments' -TimeoutSec 15
Invoke-RestMethod -Method Get -Uri 'http://127.0.0.1:32180/campaign/commands' -TimeoutSec 20
Invoke-RestMethod -Method Get -Uri 'http://127.0.0.1:32180/campaign/state?sections=bridge_metadata,campaign,contracts,scenarios,reports' -TimeoutSec 45
```

## Constraints

- Route the task into project development mode before editing.
- Do not include unrelated user changes already present in campaign/playtest files.
- Do not edit the MegaMek workspace from this repository unless the user separately asks for that repository to be changed.
- Do not commit purchased PDFs, raw extracted text, copied source text, or secrets.
- Do not parse an active `.cpnx`, `.cpnx.gz`, XML, or raw MekHQ save as the routine live-context path.
- Treat missing live data as a producer gap or explicit unsupported field, not permission to inspect the active save silently.
- Mutations must route through MekHQ-owned command endpoints, not direct save/XML writes.

## Acceptance Criteria

- GitHub issue `#118` remains linked from the roadmap and this handoff.
- MEK-RPG docs describe the current read endpoints, command readiness, selector behavior, guarded command envelope, dry-run policy, prompt policy, idempotency, opt-in saving, and timeout expectations.
- Scripts, fixtures, or tests are updated where needed, or explicit follow-up gaps are recorded.
- Optional live checks are either run with user-visible MekHQ present or explicitly recorded as not run.
- `git diff --check` passes.
- Relevant test suite runs, preferably `./scripts/test-all.ps1 -Quick`, or a blocker is recorded.
- Protected source paths remain ignored and unstaged.
- Changes are committed and pushed unless the user explicitly disables that close-out.

## Open Questions

- Should issue `#118` be completed before issue `#114`, or should `#114` live validation proceed and feed contract-alignment observations into `#118`?
- Do MEK-RPG fixture names and locations need to mirror the MegaMek workspace `docs/templates/` fixture names, or is the current local fixture naming sufficient if contract semantics match?
