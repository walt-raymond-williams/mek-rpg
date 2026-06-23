# MekHQ-Linked Workflow Rehearsal

## Scope

- Issue: `#99`
- Mode: Project development / manual validation.
- Rehearses the current MekHQ-linked workflow using committed fixtures, existing helper scripts, and the existing `campaigns/mekhq-pending-playtest/` validation save.
- Does not open MekHQ, mutate MekHQ saves, edit raw XML, accept/decline contracts, buy/sell units, advance days, or apply hard ledger changes.

## Rehearsed Flow

1. Read the bridge ownership docs:
   - `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
   - `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
   - `docs/current/MEKHQ_READ_ONLY_CHECKPOINT_EXPORT_CONTRACT.md`
   - `docs/current/MEKHQ_CHECKPOINT_WARNING_SURFACING.md`
   - `docs/current/GM_CONTEXT_PACKET_DESIGN.md`
2. Ran the pending-action workflow regression to confirm disposable MekHQ-linked campaign bootstrap, pending queue ownership, no-writeback wording, protected-source guards, and cleanup behavior.
3. Ran MekHQ-linked context packet regression scenarios to confirm bridge metadata, unresolved pending items, manual-intent labeling, structured-state precedence, tactical route references, protected-source boundaries, no-writeback boundaries, and read-only behavior.
4. Ran checkpoint fixture and edge-case fixture tests to confirm read-only checkpoint shape, warning/unsupported surfacing, stable-selector blockers, sparse/unknown fields, and no-mutation fixture behavior.
5. Built a GM context packet for `campaigns/mekhq-pending-playtest/` with validators enabled.
6. Checked `campaigns/mekhq-pending-playtest/pending-mekhq-actions.md` directly with unresolved-item reporting.

## Findings

- The read-only import/checkpoint path is covered by committed sanitized fixtures and explicit read-only checks.
- The GM context packet includes MekHQ bridge metadata, pending MekHQ intents, pending workflow docs, and checkpoint warning policy for MekHQ-linked saves.
- Pending actions are labeled as command proposals/results or manual fallback intents, not confirmed hard ledger facts.
- The existing `mekhq-pending-playtest` save validates cleanly and has no unresolved pending items.
- The `mekhq-pending-playtest` bridge records the prior issue `#37` manual UI validation: the user advanced MekHQ one day, saved, and a read-only re-import confirmed date `3025-07-25`.
- Current warnings remain appropriate: exact funds, final market prices, exact unit damage state, transport capacity/cargo pressure, and daily report classification require MekHQ UI, MekHQ-owned exporter support, or manual inspection before precise use.

## User-Assisted Boundary

No new MekHQ UI action was performed for this issue. The saved re-import requirement was checked as workflow behavior and confirmed against the existing issue `#37` validation record, not newly re-run.

Any future hard ledger rehearsal that asks to advance a day, buy or sell, accept or decline a contract, apply repairs, change personnel, or import tactical results still requires the user to perform the MekHQ UI step, save the campaign, and provide a new saved import for confirmation.

## Result

The current MekHQ-linked workflow is ready for ordinary read-only GM checkpoint use and pending-intent tracking. It is not a writeback workflow. No follow-up issue is needed from this rehearsal; existing docs already preserve the unsupported field and future exporter boundaries.
