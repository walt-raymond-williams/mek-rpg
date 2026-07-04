# MekHQ Bridge

Last live capture: 2026-06-30

Capture folder: `mekhq-live-api-capture/`

Startup branch: Branch A, live API available and sufficient for opening scene context.

## Loaded Campaign

- Campaign name: Sharpe's Strikers
- Campaign id: `7fbbb5da-0bcd-46f1-8f61-846848c2f148`
- Campaign date: 3026-04-16
- Current system: Altorra
- Current location: Altorra
- MekHQ version: 0.51.01
- API mode: local read-only live context

## Scene-Facing Snapshot

- Balance: 4,269,735 C-bills
- Active contract: 3025 - CC - Altorra Garrison Duty
- Previous contract: 3025 - CC - Talitha Recon Raid, Success, inactive.
- Contract start: 3025-12-04
- Contract end: 3027-05-04
- Contract employer: Capellan Confederation
- Contract travel days reported: 18
- Contract active today: true
- Contract pay read: monthly payout 786,083 C-bills; total monthly payout 5,937,986 C-bills; advance amount 4,454,471 C-bills; support amount 0 C-bills; transit amount 1,053,000 C-bills; transport amount 6,373,700 C-bills; estimated total profit 7,908,871 C-bills.
- Contract terms: command rights House; 0% straight support; 100% transport compensation; 20% salvage; current salvage percent 9; salvage exchange false; 40% battle loss compensation.
- Recent victory: Frontline Breakthrough, scenario id `11`, dated 3026-04-07. Destination-edge objective completed; enemy-rout objective failed.
- Recent victory: Critical Convoy Escort, scenario id `12`, dated 3026-04-09. Convoy reach, enemy rout, and convoy preservation objectives all completed.
- Pending scenario: Intercept Engagement, scenario id `13`, dated 3026-04-16. No assigned units exposed by the current pending-deployments read.
- Recent victory: Critical Convoy Escort, scenario id `10`, dated 3026-03-25.
- Recent victory: DropShip Raid, scenario id `9`, dated 3026-03-20.
- Talitha contract late outcomes: Recon Evasion Victory; Frontline Disruption Victory; VIP Ambush Refused Engagement; Talitha Recon Raid final status Success.
- Personnel: 226 total; 159 active; 1 injured/hit personnel.
- Units: 24 total; 0 deployed; 22 available; 23 deployable by the exposed API flag.
- Repair pressure: 8 units needing service, 2 units needing parts, 2 parts needed, 0 units under repair, 33 service items total.
- Commander: Captain Sharpe "Shooter" Williams, MekWarrior, active. Same MekHQ person id previously recorded for Alamen "Eruption" Orlikowski.
- Current reports: Sunday, April 16, 3026.
- Opposition intel exposed by API: `Intercept Engagement` says an intercepted force must break north to safety or destroy/rout 75% of an elite-marked Federated Suns OpFor. Exposed OpFor is 1 unit / 1,766 BV, with minor prior battle damage. Exact unit type, pilot, deployment position, and armor state are not exposed.

## Known API Caveats

- Dirty/unsaved MekHQ save state is not source-confirmed by the V1 API.
- Current MekHQ UI-selected person is not exposed by the API.
- Exact pending-scenario OpFor unit lists, BV, pilots, deployment zones, and bot-force composition are not exposed by the live API.
- Final employer-satisfaction, reputation impact, and any nonstandard payout penalty for failed/refused scenarios are not exposed by the current API; the contract remains Active in the hard ledger.
- Current reputation, faction-standing delta, employer-satisfaction score, and pending contract-resolution reputation effect are not exposed by the current API.
- Exact convoy vehicle list/count for `Critical Convoy Escort` is not exposed in the compact pending-deployments summary.
- Full personnel skill export is omitted by the V1 live endpoint; Sharpe Williams' exact changed skills need user confirmation or another source.
- Market and many command rows are display/readiness context only unless a specific guarded command workflow is entered.
- Month-boundary prompts, including personnel advancement award prompts, are not yet inspectable through a safe structured MEK-RPG workflow; the 3025-03-01 prompt was handled manually by the user.
- Latest time advance used guarded MekHQ API commands only; no API save was requested.

## Use Policy

- Refresh the live API before hard ledger decisions.
- Do not parse the active MekHQ save as routine live-play context.
- Treat this file as a pointer and table-facing summary, not as a replacement for MekHQ-owned state.
