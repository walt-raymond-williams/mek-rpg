# MekHQ Live API Smoke Follow-Up - 2026-06-26

Status: live smoke follow-up after issue `#118`.

Purpose: record issues and consumer lessons found while verifying the current MEK-RPG live MekHQ API process against a running MekHQ instance.

## Context

- Date run: 2026-06-26.
- Running MekHQ campaign: `The Learning Ropes`.
- Local API base URL: `http://127.0.0.1:32180`.
- MEK-RPG commit under verification: `8b4c5c8`.
- Mode: project-development verification with a running local MekHQ API.
- Mutation boundary: no apply command was executed. The only command endpoint test used `dryRun=true` and `saveAfterSuccess=false`.

## Smoke Results

| Endpoint | Result | Notes |
| --- | --- | --- |
| `GET /status` | Passed | Returned `ready`, campaign `The Learning Ropes`, campaign id `ea0d334a-1582-459a-9084-b349f0baca5a`, date `3025-04-08`, `visibleDialogs=0`, `saveAttempted=false`. |
| `GET /campaign/summary` | Passed | Returned `ready`, `apiMode=local-read-only-live-context`, `readOnly=true`, and live state revision. |
| `GET /campaign/pending-deployments` | Passed | Returned pending-deployments schema, read-only proof, and `pending_scenario_count=0`. |
| `GET /campaign/pending-deployments?personName=Moreno` | Passed | Lookup was supported and returned `commitment_count=0`. |
| `GET /campaign/commands` | Passed | Returned 12 readiness rows. `contracts.accept` and `markets.unit_offers.purchase` were blocked with `selector_generation_deferred`, as expected for the default cheap readiness pass. |
| `GET /campaign/state?sections=bridge_metadata,campaign,contracts,scenarios,reports` | Passed | Returned selected live state quickly with `bridge_metadata`, campaign date `3025-04-08`, no contracts/scenarios, and current reports. |
| `GET /campaign/commands?selectorDetail=full` | Passed | Took about 11.4 seconds, within the documented 60-second selector-detail guidance; `contracts.accept` and `markets.unit_offers.purchase` became available with selectors. |
| `POST /campaign/command/status-note` with `dryRun=true` | Passed after request-shape correction | Returned `status=dry_run`, `statusReason=validated`, `reportCountBefore=3`, `reportCountAfter=3`, `saveRequested=false`, `saveAttempted=false`, and no visible dialogs. |

Final post-dry-run status still reported campaign date `3025-04-08`, `visibleDialogs=0`, and `saveAttempted=false`.

## Issues Found

### 1. Guarded command envelopes are easy to shape incorrectly by hand

Observed behavior:

- A first `campaign.status_note` dry-run with `clientContext` as a plain string was refused as `invalid_json`.
- A second attempt with a structured object that included an unsupported `source` field was also refused as `invalid_json`.
- The successful shape used `clientContext` exactly as the producer record expects: `actor`, `sceneId`, `actionId`, and `reason`.

Why this matters:

- MEK-RPG docs correctly say command envelopes need audit context, idempotency, guards, prompt policy, dry-run, and opt-in saving, but a live caller can still build a malformed JSON shape.
- The producer refusal is safe, but an agent or helper should not learn command envelopes by trial and error during live play.
- Command calls should be generated from a deterministic MEK-RPG-side helper or fixture-backed template that validates the exact request shape before sending anything.

Recommended MEK-RPG fix:

- Add a small guarded-command smoke/helper path that can build a `campaign.status_note` dry-run request from live `/status` data.
- Validate `clientContext` shape locally before calling MekHQ.
- Use UTF-8 JSON request files or a known-good HTTP client path.
- Keep the first helper dry-run only by default.
- Add fixture tests for accepted and rejected request shapes.

### 2. Selector-detail behavior works and should be treated as the normal command-entry path

Observed behavior:

- Default `GET /campaign/commands` deferred expensive selectors for `contracts.accept` and `markets.unit_offers.purchase`.
- `GET /campaign/commands?selectorDetail=full` returned within the expected timeout and exposed available command rows/selectors.

Why this matters:

- The issue `#118` process alignment is correct: default readiness is cheap, full selector detail belongs at command-entry time.
- Future command helpers should explicitly perform this two-step read instead of treating `selector_generation_deferred` as a failure.

Recommended MEK-RPG fix:

- The same guarded-command helper should model this two-step readiness flow.
- For commands that need selectors, helper output should show whether full selectors were requested, which command row changed status, and what guard fields are required before dry-run.

## Proposed Follow-Up

Create an agent-task issue to add a deterministic MEK-RPG guarded-command smoke helper and tests. The helper should begin with `campaign.status_note` dry-run because it is low risk, source-backed, and validates the shared command envelope without mutating the campaign.

## Non-Issues

- No evidence of a read endpoint timeout during this smoke pass.
- No evidence that the `dryRun=true` status-note request mutated MekHQ state.
- No need to edit the MegaMek workspace from this finding; the consumer-side problem is MEK-RPG lacking a safe envelope-building helper.
