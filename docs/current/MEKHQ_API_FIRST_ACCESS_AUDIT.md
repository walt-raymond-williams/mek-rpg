# MekHQ API-First Access Audit

Date: 2026-06-26

Status: issue `#116` static audit; completed and archived at `docs/handoffs/archive/mekhq-api-first-access-audit-116.md`.

Purpose: check MEK-RPG play-mode docs, scripts, tests, and workflow references for places that still steer live MekHQ play toward raw save parsing instead of the open local API.

## Result

The active play startup path is API-first through the standard capture helper in the current top-level instructions:

1. `AGENTS.md` requires `scripts/fetch-mekhq-live-api.ps1` when MekHQ is open so `/status`, `/campaign/summary`, `/campaign/state` with `bridge_metadata`, `/campaign/pending-deployments`, and `/campaign/commands` are captured into known JSON files.
2. `gm/session-procedure.md` repeats the same helper-first startup rule and says missing API reads go to `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`.
3. `docs/current/MEKHQ_LINKED_PLAY_LOOP.md` uses helper-captured live API reads as the normal pre-session refresh path and limits active-save parsing to explicit fallback use.
4. `scripts/sync-mekhq-live-campaign.py` rejects `.cpnx`, `.cpnx.gz`, and XML input paths and consumes captured live API state JSON only.
5. `scripts/export-dashboard-data.ps1` rejects raw save/XML input for live API dashboard data and labels live API data as non-durable context.
6. `scripts/README.md` and `docs/current/KNOWN_COMMANDS.md` describe `summarize-mekhq-save.py` as offline, fallback, fixture, legacy, or debugging use, not active loaded-campaign startup.

No audited current play procedure was found that presents raw active-save parsing as the normal path when the live MekHQ API is available.

## Correct API-First Paths

- `AGENTS.md`: play-mode startup, helper-captured reads, and missing-read reporting.
- `gm/session-procedure.md`: before-play and during-play MekHQ-linked helper instructions.
- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`: gap sink and repeatable entry schema.
- `docs/current/MEKHQ_LIVE_API_SAVE_COVERAGE_AUDIT.md`: prior planning audit preserving the API-first decision.
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`: one-day loop and fallback handling.
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`: live API load section before offline summary helper.
- `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md`: explicit fallback/prototype posture.
- `docs/current/KNOWN_COMMANDS.md` and `scripts/README.md`: command examples labeling `scripts/fetch-mekhq-live-api.ps1` as the active live API path and fallback parser path.
- `scripts/sync-mekhq-live-campaign.py` and `scripts/test-sync-mekhq-live-campaign.ps1`: live-state-only adapter and raw-save rejection coverage.
- `scripts/export-dashboard-data.ps1` and `scripts/test-export-dashboard-data.ps1`: sanitized live API input handling and raw-save rejection.

## Valid Save-Parser Fallback Paths

These uses remain valid and should not be removed:

- offline inspection when MekHQ is not running or the live API is unavailable
- legacy campaign bootstrap and disposable bootstrap experiments
- sanitized regression fixture coverage
- debugging differences between serialized save facts and live method-backed API values
- explicit user-requested save inspection, with the fallback recorded

The save parser still must not write to `.cpnx`, `.cpnx.gz`, XML, or raw MekHQ save payloads.

## Fixes From This Audit

- Corrected durable task and roadmap child-issue mappings to match the actual GitHub issue numbers:
  - `#114`: validate API-first MekHQ playtest workflow
  - `#115`: harden open-connection-first startup
  - `#116`: audit live-play MekHQ API-first access paths
  - `#117`: add MekHQ playtest API gap reporting workflow
- Corrected active handoff issue numbers where the handoff content still reflected the earlier intended numbering.
- Tightened `docs/current/GM_CONTEXT_PACKET_DESIGN.md` so MekHQ-linked packets name live API snapshot/gap context as first-class bridge inputs.

## Follow-Ups

- Issue `#115` should continue with the startup decision tree and can build on this audit instead of repeating the static search.
- Issue `#117` should wire any additional gap-report checks or templates needed after the startup SOP is tightened.
- Issue `#114` should validate the workflow through live API or explicitly record live MekHQ unavailability as the blocker.

## Verification Notes

Static search command used:

```powershell
rg -n "summarize-mekhq-save|cpnx|cpnx.gz|XML|save parsing|save parser|campaign/state|campaign/summary|MekHqLiveApiJson|MekHQ save|raw save|active save|save-derived" AGENTS.md gm docs/current scripts tests
```

No live MekHQ instance was queried, and no raw MekHQ save was opened for this audit.
