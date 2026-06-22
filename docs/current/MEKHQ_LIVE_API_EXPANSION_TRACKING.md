# MekHQ Live API Expansion Tracking

Date: 2026-06-22

Status: producer-side expansion complete locally; MEK-RPG consumer follow-up tracked in issue `#110`.

Purpose: preserve the MegaMek/MekHQ live API expansion memo in MEK-RPG planning so future adapter, fixture, dashboard, and playtest work can consume the expanded read-only state shape without relying on chat history.

## Producer Status

Confirmed by MegaMek/MekHQ workspace memo:

- Source checkout: local MekHQ source under the MegaMek workspace.
- Source branch: `codex/mekhq-advance-day-control-api`.
- Original endpoint commit: `7d3b345327` (`Add local live campaign state API`).
- Expansion commits:
  - `dc214d946d` (`Harden live campaign state metadata`)
  - `d38a500960` (`Deepen live campaign personnel unit finance state`)
  - `495b58faef` (`Deepen live campaign contract scenario state`)
  - `911a338788` (`Deepen live campaign logistics market reports`)
- MegaMek workspace documentation/fixture commit: `41aef57`.
- MegaMek workspace issues `#39`, `#40`, `#41`, `#42`, and epic `#38` are closed.

Durable producer notes live at:

- `../megamek-workspace/docs/current/MEK_RPG_LIVE_MEKHQ_API_PROTOTYPE.md`

Updated producer fixtures live at:

- `../megamek-workspace/docs/templates/mekhq-live-campaign-summary.fixture.json`
- `../megamek-workspace/docs/templates/mekhq-live-campaign-state.fixture.json`
- `../megamek-workspace/docs/templates/mekhq-live-campaign-warning-heavy.fixture.json`

## Boundary

The live API remains:

- disabled by default
- loopback-only
- read-only
- source-owned inside the running MekHQ GUI app
- a freshness layer over loaded campaigns, not a save-file parser or writeback path

The source commits are currently local because pushing to upstream `MegaMek/mekhq` is blocked by repository permissions. MEK-RPG can still consume the expanded shape from the local source-built MekHQ during validation. A writable fork or upstream collaboration path is needed before treating the source branch as shareable outside the local workspace.

## Expanded Read-Only Coverage

The producer memo reports these completed additions:

- Hardened `bridge_metadata`, selected-section behavior, dirty-state unsupported metadata, and current location labels.
- Finance depth: loan/default summaries and financial warnings.
- Personnel depth: assignment dates, deployed/employed flags, injury summary, leadership markers, and market membership.
- Unit depth: availability/deployability, commander/tech/engineer ids, maintenance site, repair summary, transport assignment, and carried-unit context.
- Contract depth: descriptions, dates, travel days, payment/salvage/rental summaries, and scenario links.
- Scenario depth: descriptions, linked scenarios, StratCon type, map and planetary-condition summaries, player forces, salvage assignments, objectives, bot forces, and tactical-result context.
- Logistics/report/market depth: repair pressure, display-only repair queue, shopping-list pressure/rows, cargo/transport relationship summaries, report metadata/counts, market summaries/rows, and explicit automation guards.

## Still Unsupported

The API still does not expose command or write behavior. These remain unsupported and guarded:

- market purchase
- personnel hire/fire
- contract accept/decline
- market refresh or negotiation
- repair execution
- repair assignment
- shopping-list purchase or priority mutation
- save/writeback
- stable market offer selectors
- stable repair work ids

MEK-RPG consumers must keep these as display-only or unsupported context. Do not create pending MekHQ actions from these fields unless a later issue explicitly defines a safe manual-intent flow.

## Verification Reported By Producer

The MegaMek/MekHQ workspace reports:

- `.\gradlew.bat :MekHQ:compileJava` passed.
- `.\gradlew.bat :MekHQ:checkstyleMain` passed.
- Updated JSON fixtures parse successfully with PowerShell `ConvertFrom-Json`.

## MEK-RPG Follow-Up

Issue `#110` tracks the MEK-RPG-side consumption pass:

- refresh or add sanitized fixtures from the expanded API shape
- update live API adapter mappings where the new fields should appear in campaign-local context
- update dashboard/context consumption where useful
- preserve live-context-not-durable behavior
- preserve all write-command and unstable-selector boundaries
- record remaining producer gaps instead of parsing active save files

This follow-up is useful for issue `#97` playtest readiness, but it does not have to block ordinary live context refresh if the current adapter still parses the existing fixture shape.
