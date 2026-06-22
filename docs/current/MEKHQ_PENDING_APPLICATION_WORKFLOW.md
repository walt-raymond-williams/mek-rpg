# MekHQ Pending Application Workflow

Status: issue `#35` design note, updated by issue `#111` command API strategy.

Purpose: define how MEK-RPG records RPG-side outcomes that may need MekHQ application before they become hard ledger facts.

## Core Decision

Use a dedicated campaign-local file:

```text
campaigns/<campaign-id>/pending-mekhq-actions.md
```

This file owns the pending MekHQ application queue. It is a checklist, command-proposal queue, and audit trail, not a MekHQ save, import artifact, or source of final ledger truth.

Use the normal campaign files for the narrative cause and consequence:

- `session-log.md`: scene where the pending action was created, rolls, rulings, and player choice.
- `assets.md`: money, units, cargo, repairs, purchases, sales, and logistics narrative overlays.
- `missions.md`: contract, scenario, employer, objective, and tactical handoff context.
- `pcs.md` and `npcs.md`: personal-scale condition, availability overlays, promises, and roleplaying consequences.
- `relationships.md`, `factions.md`, and `hooks.md`: favors, obligations, leverage, fallout, rumors, and future scene pressure.
- `mekhq-bridge.md`: latest import metadata, cross-references, unsupported fields, and bridge discrepancies.

When a normal campaign file mentions a pending hard ledger change, it should link to an item id in `pending-mekhq-actions.md`, such as `mekhq-pending-2026-06-21-001`.

## Authority Boundary

MekHQ remains authoritative for hard ledger facts. Early workflow used all three conditions below:

1. The user applies the change in MekHQ through the UI or a future source-backed safe path.
2. The user saves the MekHQ campaign.
3. MEK-RPG imports or summarizes the saved MekHQ state and confirms the result.

Issue `#111` updates the mature target: a future source-backed safe path can be an explicit MekHQ-owned command API, not only manual UI. Once such a command exists, confirmation can come from a live API reread that proves the MekHQ-owned state changed as expected. A saved import remains useful as a durable checkpoint or fallback, but it is not the only possible confirmation path for command-backed workflows.

For day advancement, the old safe path was the MekHQ UI because earlier source assessment found new-day processing could reach GUI state and prompts. If the MegaMek/MekHQ workspace exposes a safe advance-day command with prompt policy, baseline guards, and reread verification, MEK-RPG should treat that as an intended command integration candidate rather than a forbidden direction.

Until MekHQ confirms the command or manual action, the pending item is an intent, request, command proposal, or checklist. It is not final campaign funds, final unit condition, final contract status, final personnel availability, final salvage, final repair state, or final campaign date.

MEK-RPG remains authoritative for RPG memory: scenes, conversations, relationships, promises, secrets, hooks, A Time of War overlays, session logs, table rulings, safety/tone, and narrative uncertainty.

## Item Schema

Each pending item should use this checklist shape:

```markdown
### mekhq-pending-YYYY-MM-DD-NNN: Short title

- Status: proposed | queued | user-applied-in-mekhq | imported | resolved | blocked | abandoned
- Type: purchase-sale | contract | repair-logistics | personnel | injury-availability | tactical-outcome | day-advancement | finance | other
- Priority: before-day-advance | before-next-scene | end-of-session | optional | deferred
- Created: YYYY-MM-DD
- Updated: YYYY-MM-DD
- Source scene: `session-log.md` heading or summary
- Source files: `session-log.md`, `assets.md`, `missions.md`
- MekHQ target ids: campaign `Unknown`; person `Unknown`; unit `Unknown`; contract `Unknown`; scenario `Unknown`
- Current imported baseline: value from the last MekHQ import, or `Unknown`
- Proposed MekHQ action: concise manual UI action or source-backed command the user/agent should perform through MekHQ
- Manual application checklist:
  - Open the linked MekHQ campaign save named in `mekhq-bridge.md`.
  - Confirm the current MekHQ date/save matches the latest imported baseline.
  - Apply the action in the MekHQ UI.
  - Save the MekHQ campaign.
- Command application checklist:
  - Confirm the live MekHQ API campaign id/date/state revision matches the pending baseline.
  - Run dry-run/preflight if the command supports it.
  - Confirm target ids/selectors and guard fields.
  - Get user approval for campaign-significant changes unless an explicit automation policy exists.
  - Execute the MekHQ-owned command.
  - Re-read live MekHQ state and verify expected fields.
- Confirmation needed from next import: exact field or summary that should prove the action happened
- Affected campaign files after import: `assets.md`, `missions.md`, `current-state.md`
- Blockers or discrepancy notes: None
- Resolution notes: TBD
```

Keep entries concise. Do not paste raw MekHQ XML, raw save payloads, purchased rule text, or copied tables into the checklist.

## Lifecycle States

`proposed`: A scene produced a possible hard ledger change, but the table has not committed to applying it in MekHQ.

`queued`: The table committed the hard ledger intent and it should be applied in MekHQ before the relevant deadline, usually before day advancement.

`user-applied-in-mekhq`: The user reports that the action was applied in the MekHQ UI and the campaign was saved, but MEK-RPG has not imported or reread the result yet.

`command-executed-in-mekhq`: A MekHQ-owned command endpoint reports that it executed, but MEK-RPG has not yet verified the result by live reread or saved import.

`imported`: A later MekHQ import appears to show the expected hard ledger result. Review affected campaign files before marking resolved.

`live-verified`: A post-command live API reread appears to show the expected hard ledger result. Review affected campaign files before marking resolved.

`resolved`: The imported hard fact has been reconciled into the campaign files, RPG memory is updated, and no further pending action remains.

`blocked`: The action cannot currently be applied or confirmed. Record the specific blocker, such as missing MekHQ support, unclear target id, unavailable UI path, conflicting import, unsupported helper field, or a user decision still needed.

`abandoned`: The table chose not to pursue the hard ledger change. Keep the narrative consequence if it still matters, but do not present it as a pending MekHQ action.

## Creation Rules

Create a pending MekHQ item whenever play produces a committed or possible change to MekHQ-owned facts:

- purchase, sale, acquisition, cargo, transit, or market removal
- contract acceptance, decline, modification, completion, failure, payment, or salvage terms
- repair queue, part use, maintenance result, technician assignment, or logistics status
- hiring, firing, rank, role, assignment, salary, fatigue, injury, or availability
- tactical scenario outcome, damage, casualties, prisoners, salvage, kill credit, or scenario status
- day advancement, travel, deadline progress, market refresh, or daily report processing
- exact funds, debt, payroll, fee, reward, or financial warning

Do not create pending MekHQ items for MEK-RPG-only memory unless it is expected to alter a hard ledger field. Conversations, motives, promises, secrets, relationship shifts, rumors, and A Time of War overlays stay in the normal campaign files.

## Review Before Day Advancement

Before asking the user to advance a MekHQ day, review `pending-mekhq-actions.md`:

1. List all `queued`, `blocked`, `user-applied-in-mekhq`, and `command-executed-in-mekhq` items.
2. Identify any item with priority `before-day-advance`.
3. Separate items into manual MekHQ UI actions, artifact handoffs, future automation candidates, MEK-RPG-only memory, and abandoned ideas.
4. Ask the user to apply required MekHQ UI actions or approve available MekHQ-owned commands before day advancement.
5. If the user skips an item, mark it `blocked`, `deferred`, or `abandoned` with the reason.
6. After UI save or command execution, reread live MekHQ state or run the saved summary/import workflow before treating ledger results as final.

Do not advance `current-state.md` to the next MekHQ date unless live reread or saved MekHQ import confirms the date.

## Re-Import Reconciliation

After a saved MekHQ import or post-command live reread:

1. Compare the import metadata in `mekhq-bridge.md` to the pending item baseline.
2. For each `user-applied-in-mekhq` item, inspect the confirmation field or imported summary.
3. If the result matches, mark the item `imported` or `live-verified`, then update affected campaign files and mark it `resolved`.
4. If the result partially matches, leave it `blocked` with discrepancy notes and preserve MekHQ as the hard ledger authority.
5. If the result is absent because the helper does not expose the needed field, mark it `blocked` with `Needs MekHQ inspection` or `Unsupported helper field`.
6. Keep the RPG-side scene memory even when the hard ledger result differs, unless the table explicitly retcons the scene.

## Category Guidance

Purchases and sales: record the intended unit/item, seller, negotiated narrative result, price if known from MekHQ UI, and confirmation needed for funds, market removal, asset arrival, cargo, and transit.

Contracts: record accept/decline/resolve intent, employer, target contract id, player-facing terms, and confirmation needed for contract status, deadline, scenario generation, payment, and salvage. For future contract-market accept/decline command planning, use `docs/current/MEKHQ_CONTRACT_MARKET_PROBE_PLAN.md`; until its preconditions are satisfied, contract decisions remain manual MekHQ UI actions plus saved re-import confirmation.

Repairs and logistics: record target unit or part, desired repair or queue change, technician/part implications, and confirmation needed for queue state, part use, completion, and availability.

Personnel: record target person/applicant id, hire/fire/assign/rank/injury/availability intent, and confirmation needed for roster, assignment, salary, fatigue, healing, or status.

Tactical outcomes: record the tactical tool or table result to apply, scenario id, units/personnel affected, and confirmation needed for damage, casualties, salvage, prisoners, kill credit, and scenario result.

Day advancement: record all prerequisites, actions to complete first, and confirmation needed for MekHQ date, travel, deadlines, market refreshes, repairs, payroll, and daily report effects. The user advances the day in the MekHQ UI unless a MekHQ-owned command has resolved GUI and prompt dependencies; once that command exists, it is an intended integration path.

## Context Packet Use

For MekHQ-linked play, a GM context packet should include:

- latest `mekhq-bridge.md` import metadata and warnings
- all unresolved `pending-mekhq-actions.md` items with statuses other than `resolved` or `abandoned`
- linked narrative context from `session-log.md`, `assets.md`, `missions.md`, `pcs.md`, `npcs.md`, `relationships.md`, `factions.md`, and `hooks.md` as needed

The packet must label unresolved pending items as intents or manual-action checklists, not confirmed hard facts.

## MekHQ-Side Request Decision

No MegaMek workspace request is created by this issue. The current workflow deliberately uses manual MekHQ UI application plus saved re-import confirmation, and the possible MekHQ-side needs are still broad: safe APIs, supported import/export artifacts, command helpers, and source-backed write paths.

Create a focused MegaMek workspace request when a concrete command need appears, such as "advance the campaign one day with prompt policy", "apply a purchase from a checklist artifact", "export contract market offers with stable IDs", or "provide a supported command for personnel assignment." Issue `#111` defines the general command API strategy. Issue `#69` defines a gated contract-market accept/decline probe plan, but it should be read as an early candidate under the broader command strategy rather than as a permanent warning against write APIs.

## Unsafe Current Behaviors

Do not:

- write to `.cpnx`, `.cpnx.gz`, MekHQ XML, or raw MekHQ save payloads
- execute a MekHQ command from stale baseline state or ambiguous selectors
- apply hard ledger facts only by editing MEK-RPG Markdown
- invent exact funds, unit state, repair duration, contract status, personnel availability, or tactical outcomes when the MekHQ import is missing or unsupported
- commit raw MekHQ saves, protected A Time of War source text, purchased PDFs, extracted source text, secrets, copied tables, or copied rulebook text
