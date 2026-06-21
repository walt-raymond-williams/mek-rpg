# MEK-RPG / MegaMek Workspace Sync Memo

Date: 2026-06-21

From: MEK-RPG workspace

To: MegaMek workspace team

## Purpose

MEK-RPG has incorporated the MegaMek workspace bridge-primitives feedback and is ready to proceed on MEK-RPG-side follow-up work. This memo clarifies what we can work on independently, what we need from the MegaMek side, and where we should avoid premature implementation.

## Current Shared Contract

MEK-RPG and MekHQ should stay separated by ownership:

- MekHQ owns hard campaign ledger facts: date, day advancement, funds, rosters, assignments, injuries/fatigue when represented in MekHQ, units, markets, repairs, contracts, scenarios, tactical outcomes, salvage, casualties, and force history.
- MEK-RPG owns RPG memory: A Time of War overlays, scene framing, conversations, relationships, secrets, promises, hooks, player-facing mission stakes, session logs, rules gaps, and narrative uncertainty.

Current safe workflow:

1. MEK-RPG queues a hard-ledger intent in `pending-mekhq-actions.md`.
2. User applies the action manually in MekHQ UI.
3. User saves MekHQ.
4. MEK-RPG re-imports or summarizes the saved MekHQ state.
5. MEK-RPG reconciles the pending item only after the saved import confirms the result.

Issue `#37` validated this loop for one day-advancement item.

## MegaMek Feedback Received

We received the following guidance from `docs/current/MEK_RPG_MEKHQ_BRIDGE_PRIMITIVES.md` in the MegaMek workspace:

- Near-term recommendation: read-only checkpoint export first, not write automation.
- Headless day advancement is not currently low-risk because `CampaignNewDayManager#newDay()` reaches GUI state and can trigger prompt/event flows.
- First possible write-side follow-up: a narrow contract-market accept/decline command, but only after stable contract IDs and prompt policy are validated.

MEK-RPG has now tracked that feedback in issues:

- `#66`: Epic: track MekHQ bridge primitives follow-up
- `#67`: Consume future MekHQ read-only checkpoint export
- `#68`: Document headless MekHQ day-advance risk
- `#69`: Plan contract-market accept-decline bridge probe

## MEK-RPG Work Starting Now

MEK-RPG will start with:

1. Issue `#68`: document headless day-advance risk.
   - Goal: make sure MEK-RPG docs clearly say manual UI day advancement plus saved re-import is the current supported path.
   - No implementation or automation.

2. Issue `#67`: consume future MekHQ read-only checkpoint export.
   - Goal: compare current `scripts/summarize-mekhq-save.py` JSON with the recommended MekHQ-owned checkpoint export.
   - Output: MEK-RPG-side consumer expectations, adapter/contract notes, and a gap list.
   - No write automation.

MEK-RPG can also continue independent rules/source-review work and personnel sheet workflow work without blocking on MegaMek.

## Requested MegaMek-Side Work

Please consider creating or owning a MegaMek workspace issue for:

```text
Define or prototype MekHQ read-only checkpoint export for MEK-RPG
```

Useful acceptance criteria:

- Identify the MekHQ method/API owners for campaign date, location, funds, personnel, units, contracts, scenarios, markets, repairs/logistics, and reports.
- Distinguish serialized facts from method-derived values.
- Recommend a JSON export shape or source-backed field contract.
- Preserve stable MekHQ IDs where available.
- Include warnings/unsupported fields for values that should not be trusted from raw XML alone.
- Do not implement writeback as part of this first step.

Fields MEK-RPG most needs from a checkpoint export:

- campaign id, name, date, faction, save metadata, current location/system
- funds and financial warnings
- personnel ids, display names, roles, ranks, assignments, injuries, fatigue, salaries, availability
- unit ids, chassis/model/type, status, crew links, transport/cargo associations, repair/damage summary
- active contracts, scenarios, deadlines, employers, status, and selected terms summary
- unit market offers, personnel market applicants, contract market offers
- repair queues, shopping/acquisition queues, parts pressure, daily report alerts, unsupported/unknown fields

## Coordination Boundaries

MEK-RPG should not start these without MegaMek confirmation:

- Headless day-advance implementation.
- Contract accept/decline command implementation.
- Purchase/sale automation.
- Repair/logistics automation.
- Personnel hire/assignment automation.
- Injury/availability automation.
- Tactical result write automation.

Those all need source-backed selectors, method ownership, prompt policy, disposable validation, and saved re-import confirmation.

## First Possible Write-Side Probe

The first plausible write-side probe remains:

```text
contract-market accept/decline by stable contract id
```

But MEK-RPG will only plan this for now. Before implementation, we need MegaMek-side confirmation of:

- stable contract offer IDs in saved or exported market state
- guard fields such as name, employer, date/deadline, and campaign id
- prompt/dialog policy for AtB/StratCon flows
- refusal behavior when prompts cannot be answered safely
- saved re-import fields that prove accept/decline succeeded

## Desired Next Sync Point

After MEK-RPG completes issues `#68` and the planning portion of `#67`, we should sync on:

- whether MegaMek will own the read-only checkpoint exporter
- whether MEK-RPG should draft the consumer JSON schema first
- which field group should be validated first with disposable saves
- whether contract-market accept/decline is still the right first write-side probe

## Relevant MEK-RPG Files

- `docs/current/MEGAMEK_WORKSPACE_BRIDGE_REQUEST.md`
- `docs/current/MEGAMEK_WORKSPACE_SYNC_MEMO.md`
- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md`
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`
- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEKHQ_PENDING_WORKFLOW_PLAYTEST_VALIDATION.md`
- `docs/handoffs/active/consume-mekhq-read-only-checkpoint-export.md`
- `docs/handoffs/active/document-headless-day-advance-risk.md`
- `docs/handoffs/active/plan-contract-market-accept-decline-probe.md`
