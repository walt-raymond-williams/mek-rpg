# MegaMek Workspace Request: MEK-RPG / MekHQ Bridge Primitives

Status: shareable request for the MegaMek workspace team.

Date: 2026-06-21

Source workspace: `C:\Users\waltr\Documents\mek-rpg`

Target workspace: `C:\Users\waltr\Documents\megamek-workspace`

## Purpose

MEK-RPG is a private A Time of War rules-assistant and GM-assistant workspace. It can now read MekHQ campaign saves, bootstrap a MEK-RPG campaign folder from a read-only summary, queue hard-ledger intents, and reconcile a saved MekHQ re-import after the user applies a change in the MekHQ UI.

We are ready to ask the MegaMek workspace team for a focused MekHQ-side investigation: map safe bridge primitives that could eventually reduce manual UI work without direct save/XML editing.

This is not a request to implement broad writeback yet.

## Current Working Boundary

MekHQ owns hard ledger facts:

- campaign date and day advancement
- travel, markets, contracts, scenarios, repairs, logistics, and daily reports
- funds, payroll, purchases, sales, debt, cargo, and transport constraints
- units, personnel rosters, assignments, fatigue, injuries, unit condition, and repair state
- tactical consequences, salvage, casualties, prisoners, kill credit, and scenario results

MEK-RPG owns RPG continuity:

- A Time of War PC overlays, Edge, XP, traits, personal goals, and sheet gaps
- scene framing, conversations, promises, secrets, motives, relationships, hooks, and rumors
- player-facing mission stakes, safety/tone, table rulings, session logs, and rules gaps
- narrative uncertainty around MekHQ objects until the table commits a hard ledger outcome

Hard ledger changes created during play remain pending until:

1. the user applies the change in MekHQ through the UI or a future safe MekHQ-backed path
2. the user saves the MekHQ campaign
3. MEK-RPG imports or summarizes the saved result and reconciles the pending item

## Current MEK-RPG Bridge State

Implemented in MEK-RPG:

- `scripts/summarize-mekhq-save.py`
  - Reads explicit `.cpnx`, `.cpnx.gz`, or plain MekHQ XML paths.
  - Detects gzip by magic bytes.
  - Emits JSON or Markdown to stdout.
  - Does not write to the MekHQ save.
- `scripts/bootstrap-mekhq-campaign.py`
  - Consumes summary JSON.
  - Creates a MEK-RPG `campaigns/<campaign-id>/` folder.
  - Preserves MekHQ IDs and import metadata in `mekhq-bridge.md`.
  - Creates `pending-mekhq-actions.md`.
  - Does not edit MekHQ saves.
- `scripts/validate-mekhq-pending-actions.ps1`
  - Checks pending item structure and lifecycle values.
- `scripts/test-all.ps1`
  - Runs deterministic regression checks using sanitized committed fixtures and disposable output.

Manual UI validation is complete for one simple hard-ledger action:

- Test save: `mek-rpg-test.cpnx` under the local MekHQ install's `campaigns` folder.
- MekHQ campaign: `The Learning Ropes`.
- Test action: advance MekHQ one day through the MekHQ UI, save, then re-import read-only.
- Initial import date: `3025-07-24`.
- Saved re-import date: `3025-07-25`.
- Pending item: `mekhq-pending-2026-06-21-001`.
- Final pending item state: `resolved`.

No raw MekHQ save payload, raw XML, purchased A Time of War source text, extracted source text, copied tables, or secrets should be committed.

## Known Current Parser Limits

The read-only summary helper is useful, but still shallow in several MekHQ-specific areas:

- Funds are inferred by summing serialized finance transactions. Exact UI balance should still be confirmed in MekHQ when it matters.
- Unit market final prices are not fully exposed by the current parser; MekHQ derives final price from unit cost, offer percent, entity tech base, and campaign multipliers.
- Unit damage state is not deeply interpreted; entity and part mapping need MekHQ-side review before trust.
- Transport capacity and cargo pressure are not fully mapped.
- Daily report alerts may include presentation HTML and need classification.
- Contract market offers need more sample coverage and source/API inspection.
- Rank, role, assignment, personnel availability, injuries, fatigue, and repair/logistics semantics need stable field/API confirmation.

## Request To MegaMek Workspace Team

Please investigate safe MekHQ bridge primitives for MEK-RPG, with the following priority order.

### 1. Confirm Stable Read-Only Export Fields

Goal: identify the best MekHQ-supported or source-stable way to expose campaign checkpoint facts for external tools.

Fields MEK-RPG needs:

- campaign id, name, date, faction, save metadata, and current location/system
- funds and financial warnings
- personnel ids, display names, roles, ranks, assignments, injuries, fatigue, salaries, and availability
- unit ids, chassis/model/type, status, crew links, transport/cargo associations, and repair/damage summary
- active contracts, scenarios, deadlines, employers, terms summary, and status
- unit market offers, personnel market applicants, and contract market offers
- repair queues, shopping/acquisition queues, parts pressure, daily report alerts, and unsupported/unknown fields

Useful output from this investigation:

- source files/classes/methods to use as authoritative readers
- which fields are safe serialized facts versus derived UI/business-logic values
- which fields need method calls rather than XML parsing
- sample JSON shape or recommended export contract

### 2. Map Safe MekHQ Method Calls For Pending Action Types

Goal: find the MekHQ-side APIs or flows that apply each pending action type using MekHQ's own campaign logic.

Pending action types from MEK-RPG:

- `day-advancement`
- `purchase-sale`
- `contract`
- `repair-logistics`
- `personnel`
- `injury-availability`
- `tactical-outcome`
- `finance`

For each type, please identify:

- the relevant MekHQ classes/methods/commands
- required ids or object references
- preconditions and validation rules
- dialogs/prompts or GUI dependencies that block noninteractive operation
- whether the action can be safely driven by a command/helper later
- what saved fields should confirm success on re-import

### 3. Investigate A Checklist/Command Interface

Goal: determine whether a future MekHQ-side helper could accept a structured pending-action artifact and apply it safely.

Candidate command shape, illustrative only:

```text
mekhq apply-pending-action --campaign path\to\campaign.cpnx --action pending-action.json --save
```

Initial target actions should be small and source-backed. Good candidates:

- advance one day and save, if GUI/dialog dependencies can be handled safely
- accept or decline a contract by stable id
- hire a personnel-market applicant by stable id
- buy a unit-market offer by stable id or stable offer selector
- assign a person to a unit/role by stable ids
- queue or update a repair/logistics action by stable ids

This investigation should explicitly say when noninteractive operation is unsafe or too GUI-coupled.

### 4. Clarify Tactical Result Artifact Paths

Goal: identify the safest existing artifact workflows for tactical outcomes.

MEK-RPG needs to hand tactical resolution to Classic BattleTech, MegaMek, or MekHQ when detailed unit state matters. After resolution, MekHQ should remain authoritative for:

- unit damage
- casualties and injuries
- salvage
- prisoners
- kill credit
- scenario status
- repairs and force history

Useful output:

- which MUL or battle-result workflows are already supported
- what data can be imported safely
- what cannot be represented through existing artifacts
- what MEK-RPG should include in a tactical handoff packet

## Non-Goals For This Request

Please do not treat this as a request for:

- direct `.cpnx`, `.cpnx.gz`, or XML editing
- broad MekHQ internals refactors
- a complete MEK-RPG integration implementation
- a full headless MekHQ replacement for UI play
- storing MEK-RPG narrative secrets, relationships, or A Time of War sheets inside MekHQ
- rewriting MekHQ campaign logic in MEK-RPG

The first useful outcome is a source-backed map of safe integration points and blockers.

## Proposed MegaMek Workspace Issue

Title:

```text
Map safe MekHQ bridge primitives for MEK-RPG pending actions
```

Goal:

```text
Identify stable MekHQ APIs, serialized fields, supported artifacts, and GUI blockers needed for MEK-RPG to safely read campaign facts and eventually apply selected pending hard-ledger actions through MekHQ-owned logic rather than direct save/XML edits.
```

Acceptance criteria:

- Document stable read-only campaign export fields and the best source/API owner for each.
- Document unsupported or derived fields that should not be trusted from raw XML alone.
- Map safe method/API candidates for day advancement, purchase/sale, contract decisions, repairs/logistics, personnel changes, injury/availability updates, tactical outcomes, and finance actions.
- Identify GUI/dialog dependencies that block noninteractive use.
- Recommend one or two smallest safe future implementation issues.
- Preserve the rule that MEK-RPG must not directly edit MekHQ save/XML payloads.

## Relevant MEK-RPG Files

From `C:\Users\waltr\Documents\mek-rpg`:

- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- `docs/current/MEKHQ_LINKED_ATOW_WORKFLOW_REQUIREMENTS.md`
- `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md`
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`
- `docs/current/MEKHQ_PENDING_WORKFLOW_PLAYTEST_VALIDATION.md`
- `gm/tactical-encounter-handoff-checklist.md`
- `scripts/summarize-mekhq-save.py`
- `scripts/bootstrap-mekhq-campaign.py`
- `scripts/validate-mekhq-pending-actions.ps1`
- `scripts/test-all.ps1`

From `C:\Users\waltr\Documents\megamek-workspace`:

- `docs/current/MEK_RPG_MEKHQ_COLLABORATION_BRIEF.md`
- `docs/current/MEK_RPG_MEKHQ_INTEGRATION_ASSESSMENT.md`
- `docs/current/TABLETOP_RESULT_MUL_WORKFLOW.md`
- `docs/current/MECH_ROSTER_CONTROL_WORKFLOWS.md`
- `docs/current/SAVE_FORMAT_NOTES.md`

## Suggested First Response From MegaMek Workspace

A useful first response would be a short source-backed assessment:

- "These fields should be read via these methods/classes, not by raw XML parsing."
- "These pending action types have safe command/helper potential."
- "These action types are currently GUI-coupled."
- "The first implementation issue should be X, because it is low-risk and high-value."
- "The following direct writeback ideas are unsafe and should stay out of scope."
