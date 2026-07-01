# MekHQ Open-Connection Startup Decision Tree

Status: issue `#115` startup SOP hardening.

Purpose: make MekHQ-linked play start from the open MekHQ local API connection whenever it is available, and make every fallback explicit.

Use this decision tree before treating any imported `mekhq-bridge.md`, generated campaign-local notes, saved checkpoint, or save-derived summary as current MekHQ-owned context.

## Required First Capture

When MekHQ is open, use the read helper before play:

```powershell
./scripts/fetch-mekhq-live-api.ps1 -OutputDirectory .\mekhq-live-api-capture
```

Add `-PendingDeploymentsPersonId` or `-PendingDeploymentsPersonName` when the scene depends on a viewpoint person's scenario/deployment commitment. Add `-SelectorDetailFull` only when entering a command workflow that needs expensive selectors or guard facts.

The helper captures these read-only calls into known JSON files:

1. `GET /status`
2. `GET /campaign/summary`
3. `GET /campaign/state` with `bridge_metadata`
4. `GET /campaign/pending-deployments` when the scene depends on current scenario, deployment, unit, or viewpoint-person commitment.
5. `GET /campaign/commands`

The standard files are `mekhq-status.json`, `mekhq-summary.json`, `mekhq-state.json`, `mekhq-commands.json`, `mekhq-pending-deployments.json`, optional selector/viewpoint files, and `mekhq-live-api-capture-manifest.json`.

`GET /status` confirms that the local control server is reachable and reports the loaded-campaign identity snapshot. `GET /campaign/summary` provides fast compact context. `GET /campaign/state` with `bridge_metadata` provides the live context and trust envelope. `GET /campaign/pending-deployments` is the purpose-built read for current scenario and personnel commitment lookup; use `personId` or `personName` when the viewpoint character matters because the API does not expose the currently selected MekHQ UI person. `GET /campaign/commands` reports read-only command readiness and safe selector discovery; it does not authorize mutation by itself.

After capture, query compact views before opening raw capture JSON:

```powershell
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view summary --format json
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view play-context --format json
```

Use focused views for the active question: `pending-deployments`, `person-commitment`, `unit-readiness`, `repair-pressure`, `reports`, `command-readiness`, `api-gaps`, or `person-detail`. Raw capture JSON is evidence for debugging, fixture work, or new view development; it is not the normal play-start input.

Use short timeouts for `/status`, `/campaign/summary`, and `/campaign/pending-deployments`; use a longer timeout for narrowed `/campaign/state` reads. Surface `response_status`, `partial_response`, warnings, unsupported entries, collector failures, and timeout results to the GM instead of treating missing fields as complete data.

## Branches

### Branch A: API Available And Sufficient

- Use the live API snapshot as current MekHQ-owned context for the session.
- Use compact query-view output as the normal agent-readable form of that snapshot.
- Treat live values as live context, not durable MEK-RPG memory, until saved/imported confirmation, explicit user approval, or a future controlled promotion flow.
- Use `scripts/sync-mekhq-live-campaign.py --live-state .\mekhq-live-api-capture\mekhq-state.json` when campaign-local generated context files need to be created or refreshed from captured state JSON.
- Check the `command-readiness` query view before routing hard-ledger actions to manual fallback.
- Rerun `scripts/fetch-mekhq-live-api.ps1 -SelectorDetailFull` only when entering a specific command workflow that needs expensive selectors or guard facts.

### Branch B: API Available But Missing Or Ambiguous Data

- Do not parse the active `.cpnx`, `.cpnx.gz`, XML, or raw save as a silent workaround.
- Add an entry to `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md` with the play context, needed data, attempted endpoint or query view, missing or ambiguous field, fallback used, expected read shape, and suggested producer/API change. The `api-gaps` query view can print candidate gap facts, but it does not edit the report automatically.
- Continue only with the missing fact labeled as `Unknown`, user-confirmed, or stale imported context with a warning.
- If the missing read blocks safe play, pause for user input or record the playtest blocker instead of inventing the hard ledger fact.

### Branch C: API Unavailable

- Record that the live API was unavailable and what was attempted.
- Ask whether to proceed from the last campaign-local snapshot, pause until MekHQ/API is available, or perform explicit offline/debug save inspection.
- If proceeding from campaign-local notes, label MekHQ-owned facts as stale until live API or saved/imported confirmation refreshes them.
- If the unavailable API reveals a repeatable playtest problem, add it to `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`.

### Branch D: User Explicitly Requests Offline Save Inspection

- Confirm that this is offline, legacy, fixture, or debugging inspection, not the normal live-play context path.
- Use `scripts/summarize-mekhq-save.py` only as a read-only parser of the explicit save path.
- Record the fallback and keep save-derived values subordinate to later live API or MekHQ-confirmed state.
- Do not commit raw `.cpnx`, `.cpnx.gz`, XML, or other raw MekHQ save payloads.

## Never Do This During Live Play Startup

- Do not parse the active save merely because a path is known.
- Do not use parser output to bypass missing live API fields.
- Do not treat generated campaign-local bridge notes as fresher than the open MekHQ API.
- Do not run mutating command endpoints from stale or parser-derived baseline state.
- Do not build commands from display-only state rows, display names, row indexes, or MEK-RPG-computed hashes. Build them from `GET /campaign/commands` readiness rows and selectors.
- Do not update final hard ledger facts in MEK-RPG without supported command execution plus live reread, manual MekHQ application plus saved/imported confirmation, or explicit user-approved provisional labeling.

## Startup Summary Line

At the table, summarize the selected branch in one sentence:

- Live API path: "MekHQ date and ledger are current through this live API snapshot; MEK-RPG is running scenes inside that day."
- Stale snapshot path: "MekHQ live API is unavailable, so these MekHQ facts are from the last campaign-local snapshot and remain stale until refreshed."
- Offline inspection path: "This is explicit offline/debug save inspection, not the normal live-play context source."
