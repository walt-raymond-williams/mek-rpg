# MekHQ Pending Application Workflow

Status: issue `#35` design note.

Purpose: define how MEK-RPG records RPG-side outcomes that may need manual MekHQ application before they become hard ledger facts.

## Core Decision

Use a dedicated campaign-local file:

```text
campaigns/<campaign-id>/pending-mekhq-actions.md
```

This file owns the pending MekHQ application queue. It is a checklist and audit trail, not a MekHQ save, import artifact, or source of final ledger truth.

Use the normal campaign files for the narrative cause and consequence:

- `session-log.md`: scene where the pending action was created, rolls, rulings, and player choice.
- `assets.md`: money, units, cargo, repairs, purchases, sales, and logistics narrative overlays.
- `missions.md`: contract, scenario, employer, objective, and tactical handoff context.
- `pcs.md` and `npcs.md`: personal-scale condition, availability overlays, promises, and roleplaying consequences.
- `relationships.md`, `factions.md`, and `hooks.md`: favors, obligations, leverage, fallout, rumors, and future scene pressure.
- `mekhq-bridge.md`: latest import metadata, cross-references, unsupported fields, and bridge discrepancies.

When a normal campaign file mentions a pending hard ledger change, it should link to an item id in `pending-mekhq-actions.md`, such as `mekhq-pending-2026-06-21-001`.

## Authority Boundary

MekHQ remains authoritative for hard ledger facts until all three conditions are true:

1. The user applies the change in MekHQ through the UI or a future source-backed safe path.
2. The user saves the MekHQ campaign.
3. MEK-RPG imports or summarizes the saved MekHQ state and confirms the result.

For day advancement, use the MekHQ UI as the current safe application path. The source-backed bridge assessment found that MekHQ's new-day processing reaches GUI state and can trigger prompts or events, so headless day advancement must stay blocked until MekHQ source work provides a safe command boundary and prompt policy.

Until then, the pending item is an intent, request, or checklist. It is not final campaign funds, final unit condition, final contract status, final personnel availability, final salvage, final repair state, or final campaign date.

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
- Proposed MekHQ action: concise manual action the user should perform in MekHQ
- Manual application checklist:
  - Open the linked MekHQ campaign save named in `mekhq-bridge.md`.
  - Confirm the current MekHQ date/save matches the latest imported baseline.
  - Apply the action in the MekHQ UI.
  - Save the MekHQ campaign.
- Confirmation needed from next import: exact field or summary that should prove the action happened
- Affected campaign files after import: `assets.md`, `missions.md`, `current-state.md`
- Blockers or discrepancy notes: None
- Resolution notes: TBD
```

Keep entries concise. Do not paste raw MekHQ XML, raw save payloads, purchased rule text, or copied tables into the checklist.

## Lifecycle States

`proposed`: A scene produced a possible hard ledger change, but the table has not committed to applying it in MekHQ.

`queued`: The table committed the hard ledger intent and it should be applied in MekHQ before the relevant deadline, usually before day advancement.

`user-applied-in-mekhq`: The user reports that the action was applied in the MekHQ UI and the campaign was saved, but MEK-RPG has not imported the saved result yet.

`imported`: A later MekHQ import appears to show the expected hard ledger result. Review affected campaign files before marking resolved.

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

1. List all `queued`, `blocked`, and `user-applied-in-mekhq` items.
2. Identify any item with priority `before-day-advance`.
3. Separate items into manual MekHQ UI actions, artifact handoffs, future automation candidates, MEK-RPG-only memory, and abandoned ideas.
4. Ask the user to apply required MekHQ UI actions before day advancement.
5. If the user skips an item, mark it `blocked`, `deferred`, or `abandoned` with the reason.
6. After the user saves MekHQ, run the read-only summary/import workflow before treating ledger results as final.

Do not advance `current-state.md` to the next MekHQ date unless the saved MekHQ import confirms the date.

## Re-Import Reconciliation

After a saved MekHQ import:

1. Compare the import metadata in `mekhq-bridge.md` to the pending item baseline.
2. For each `user-applied-in-mekhq` item, inspect the confirmation field or imported summary.
3. If the result matches, mark the item `imported`, then update affected campaign files and mark it `resolved`.
4. If the result partially matches, leave it `blocked` with discrepancy notes and preserve MekHQ as the hard ledger authority.
5. If the result is absent because the helper does not expose the needed field, mark it `blocked` with `Needs MekHQ inspection` or `Unsupported helper field`.
6. Keep the RPG-side scene memory even when the hard ledger result differs, unless the table explicitly retcons the scene.

## Category Guidance

Purchases and sales: record the intended unit/item, seller, negotiated narrative result, price if known from MekHQ UI, and confirmation needed for funds, market removal, asset arrival, cargo, and transit.

Contracts: record accept/decline/resolve intent, employer, target contract id, player-facing terms, and confirmation needed for contract status, deadline, scenario generation, payment, and salvage.

Repairs and logistics: record target unit or part, desired repair or queue change, technician/part implications, and confirmation needed for queue state, part use, completion, and availability.

Personnel: record target person/applicant id, hire/fire/assign/rank/injury/availability intent, and confirmation needed for roster, assignment, salary, fatigue, healing, or status.

Tactical outcomes: record the tactical tool or table result to apply, scenario id, units/personnel affected, and confirmation needed for damage, casualties, salvage, prisoners, kill credit, and scenario result.

Day advancement: record all prerequisites, actions to complete first, and confirmation needed for MekHQ date, travel, deadlines, market refreshes, repairs, payroll, and daily report effects. Do not describe the pending action as headless or automatic; the user advances the day in the MekHQ UI unless a later MekHQ-owned command has resolved GUI and prompt dependencies.

## Context Packet Use

For MekHQ-linked play, a GM context packet should include:

- latest `mekhq-bridge.md` import metadata and warnings
- all unresolved `pending-mekhq-actions.md` items with statuses other than `resolved` or `abandoned`
- linked narrative context from `session-log.md`, `assets.md`, `missions.md`, `pcs.md`, `npcs.md`, `relationships.md`, `factions.md`, and `hooks.md` as needed

The packet must label unresolved pending items as intents or manual-action checklists, not confirmed hard facts.

## MekHQ-Side Request Decision

No MegaMek workspace request is created by this issue. The current workflow deliberately uses manual MekHQ UI application plus saved re-import confirmation, and the possible MekHQ-side needs are still broad: safe APIs, supported import/export artifacts, command helpers, and source-backed write paths.

Create a focused MegaMek workspace request later when repeated pending items show a concrete need, such as "apply a purchase from a checklist artifact", "export contract market offers with stable IDs", or "provide a supported command for personnel assignment." Until then, MEK-RPG should not imply that direct writeback is available or safe.

## Unsafe Current Behaviors

Do not:

- write to `.cpnx`, `.cpnx.gz`, MekHQ XML, or raw MekHQ save payloads
- apply hard ledger facts only by editing MEK-RPG Markdown
- invent exact funds, unit state, repair duration, contract status, personnel availability, or tactical outcomes when the MekHQ import is missing or unsupported
- commit raw MekHQ saves, protected A Time of War source text, purchased PDFs, extracted source text, secrets, copied tables, or copied rulebook text
