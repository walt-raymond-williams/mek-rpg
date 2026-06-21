# MekHQ Pending Workflow Playtest Validation

Status: issue `#37` validation report.

Date: 2026-06-21

## Scenario

- MEK-RPG campaign id: `mekhq-pending-playtest`
- MekHQ save used: `C:\Users\waltr\Documents\megamek-workspace\external\installs\MekHQ-0.51.00\campaigns\mek-rpg-test.cpnx`
- MekHQ campaign: `The Learning Ropes`
- MekHQ campaign id: `ea0d334a-1582-459a-9084-b349f0baca5a`
- Test action: advance the MekHQ campaign by one day through the MekHQ UI, save, then re-import read-only.

## Result

- Initial read-only import confirmed MekHQ date `3025-07-24`.
- MEK-RPG created `campaigns/mekhq-pending-playtest/` from the summary JSON.
- Pending item `mekhq-pending-2026-06-21-001` was queued in `pending-mekhq-actions.md`.
- User advanced MekHQ one day in the UI and overwrote the save.
- Saved re-import confirmed MekHQ date `3025-07-25` for the same campaign id.
- Pending item final state: `resolved`.

## Notes

- The workflow proved the manual UI apply, save, re-import, and reconciliation loop for a day-advancement item.
- The helper remained read-only; no `.cpnx`, `.cpnx.gz`, XML, protected source text, or raw extracted payload was committed.
- PowerShell `>` redirection produced UTF-16 JSON during the first bootstrap attempt; writing the summary with explicit UTF-8 fixed the issue. This is a useful command-documentation follow-up, not a workflow blocker.
- The usual helper warnings remain: funds are calculated from serialized finance transactions, exact unit damage, final market prices, transport/cargo semantics, and daily report classification are still limited by the current prototype.

## Follow-Ups

- Document the UTF-8 summary file pattern in helper command docs if future manual bridge work repeats the bootstrap command.
- Consider a later manual validation with a richer ledger action, such as purchase, personnel hire, contract decision, or repair/logistics update, after the table needs one naturally.
