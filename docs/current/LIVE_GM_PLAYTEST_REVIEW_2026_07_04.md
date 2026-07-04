# Live GM Playtest Review - 2026-07-04

Status: completed review for issue `#97` and parent issue `#95`.

Purpose: record the post-playtest campaign-file review and user interview after extended Learning Ropes and Sharpe's Strikers play.

## Scope

Reviewed campaign folders:

- `campaigns/the-learning-ropes/`
- `campaigns/sharpes-strikers/`

Current active campaign pointer:

- `campaign-state/active-campaign.md` selects `campaigns/sharpes-strikers/`.

No raw MekHQ saves, raw live API captures, PDFs, extracted source text, or secrets were parsed or staged for this review.

## Campaign File Structure Findings

Both reviewed campaign folders use the standard campaign-save shape:

- `overview.md` for campaign framing
- `current-state.md` for resume point and recent state
- `pcs.md` and `npcs.md` for character memory
- `assets.md` for funds, contracts, units, transport, salvage, and large assets
- `missions.md` for contract and scenario history
- `hooks.md`, `relationships.md`, `factions.md`, and `locations.md` for campaign-facing continuity
- `pending-mekhq-actions.md` for hard-ledger intents awaiting command execution, manual MekHQ action, or live reread verification
- `mekhq-bridge.md` and, for Learning Ropes, `mekhq-api-gaps.md` for MekHQ linkage context
- `session-log.md` and `previous-sessions.md` for active and archived session memory
- `rules-gaps.md`, `playtest-notes.md`, and `safety-and-tone.md` for support notes

Learning Ropes shows the first substantial API-first MekHQ-linked play arc. It captured guarded day advancement, manual fallback for contract acceptance, live reread verification, tactical aftermath, deployment discrepancies, casualty/damage outcomes, and early API timeout gaps. Its main structural weakness is staleness in summary files: top-level `current-state.md` and `mekhq-bridge.md` preserve older snapshots while later `session-log.md` entries advance the campaign farther.

Sharpe's Strikers is the current stronger workflow example. `current-state.md`, `missions.md`, `assets.md`, `pcs.md`, and `pending-mekhq-actions.md` preserve the Wallacia resume state, contract/salvage ledger, commander record, pending recovery-vehicle purchase, and MekHQ ownership boundaries well. The main structural weakness is growth and duplication: `session-log.md` and `current-state.md` contain long chronological histories, while some older `hooks.md`, `npcs.md`, and `mekhq-bridge.md` details still reflect prior Altorra or Butzfleth snapshots.

## Interview Findings

Confirmed by user:

- The live GM workflow worked well overall.
- The best loop was: pull current MekHQ data, summarize what changed, then let characters talk and react to those facts in scene.
- Stale facts mostly happened when the user advanced MekHQ outside MEK-RPG and did not ask the agent to refresh. When MEK-RPG itself advanced MekHQ through guarded commands and live rereads, synchronization was good.
- The user will manage manual refresh prompts for now. Do not create a staleness-warning or event-driven sync issue from this checkpoint.
- MekHQ live API data and compact query views were useful. Existing API gap tracking is the right place for missing data.
- Agents handled MekHQ-owned facts well enough, including marking unknowns and API gaps.
- Rules lookup worked in actual scenes and was useful.
- Rich character records help continuity and are not too heavy. Character continuity is a core goal for this RPG workflow.
- Sharpe's Strikers does not need a restructuring issue before continued play.

## Follow-Up Decisions

Created issue `#152`: plan MekHQ personnel assignment read/query and guarded reassignment workflow.

Reason: the user identified personnel assignment support as the next concrete useful experiment. The desired direction is to read the whole personnel roster and assignments in one request for now, support focused local queries by unit or person, then plan a simple guarded reassignment workflow that unassigns a person, confirms the destination slot is empty, assigns the person to the new unit, and verifies by live reread. Bulk rotation workflows and event-driven sync are later ideas, not current issue scope.

No issue created for staleness warnings or event-driven sync. The user explicitly deferred that and will request manual MekHQ refreshes for now.

No issue created for Sharpe's Strikers campaign restructuring. The user said the current structure is good enough to continue.

No broad issue created for every open API gap. Existing entries in `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md` remain useful producer inputs, especially finance transaction history, salvage itemization, transport capacity, reputation/XP history, player-force BV, and scenario force detail. Personnel assignment support is the only new concrete follow-up from this review.

## Verification

Passed:

```powershell
./scripts/validate-campaign-state.ps1 -StrictActive
```

Result: 0 errors, 0 warnings.

## Close-Out

Issue `#97` can close as complete after this report, task/roadmap updates, GitHub comments, and commit/push.

Parent issue `#95` can also close after issue `#97` closes because the remaining manual validation/playtest checkpoint child has been reconciled and the only new actionable follow-up is tracked separately as issue `#152`.
