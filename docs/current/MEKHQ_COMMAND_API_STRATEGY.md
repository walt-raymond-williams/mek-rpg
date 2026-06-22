# MekHQ Command API Strategy

Date: 2026-06-22

Status: planning baseline for issue `#111`.

Purpose: update MEK-RPG's MekHQ integration posture from permanent read-only/manual UI caution to controlled MekHQ-owned command integration.

## Posture Update

Early MEK-RPG bridge work treated MekHQ as read-only because the project was still proving campaign context, save boundaries, fixture shape, and trust envelopes. That caution was appropriate for prototypes that parsed saves or consumed read-only exports.

The mature goal is broader:

- MEK-RPG should use live read-only API data for current context.
- MEK-RPG should be able to request explicit MekHQ-owned commands when the MegaMek/MekHQ workspace exposes safe command endpoints.
- MekHQ should remain the hard ledger for campaign date, finances, rosters, units, contracts, markets, repairs, scenarios, tactical outcomes, and saves.
- MEK-RPG should never mutate raw `.cpnx`, `.cpnx.gz`, XML, or save payloads directly.

The boundary is no longer "never mutate MekHQ." The boundary is "never perform hidden, ambiguous, or raw-file mutation." Explicit source-backed commands through MekHQ-owned code are in scope.

## Command Pattern

A safe MekHQ command workflow should follow this loop:

1. Read live state from MekHQ.
2. Select a command with stable target ids or selectors.
3. Capture baseline guards: campaign id, campaign date, state revision/snapshot id, target id, display name, relevant price/status/counts, and any prompt-sensitive fields.
4. Run dry-run or preflight if the endpoint supports it.
5. Present the proposed MekHQ mutation to the user or GM when the action is campaign-significant.
6. Execute the MekHQ-owned command only after approval or an explicit automation policy.
7. Re-read live state.
8. Verify the expected state change from MekHQ's new state, not from MEK-RPG intent text.
9. Record RPG narrative context and the confirmed hard-ledger result separately.
10. Record discrepancies as blocked reconciliation items instead of guessing.

## Command Envelope

Future command adapters should preserve this shape, even if the exact JSON varies by endpoint:

```json
{
  "command_id": "mekhq.advance_day",
  "mode": "dry_run | execute",
  "baseline": {
    "campaign_id": "example",
    "campaign_date": "3025-04-08",
    "state_revision": "live-...",
    "snapshot_id": "live-..."
  },
  "target": {
    "type": "market_offer | contract_offer | personnel | unit | repair_work | campaign",
    "id": "stable-id-or-null",
    "guard_fields": {}
  },
  "rpg_context": {
    "scene_id": "session-log heading or request id",
    "summary": "Why the RPG table is asking MekHQ to do this."
  },
  "approval": {
    "required": true,
    "approved_by": null,
    "approved_at": null
  },
  "result": {
    "status": "pending | executed | refused | blocked | verified",
    "messages": [],
    "warnings": []
  },
  "verification": {
    "reread_required": true,
    "expected_fields": [],
    "verified_from_live_state": false
  }
}
```

## First Good Command Candidates

### Advance Day

This is the best first command candidate because the campaign date and daily processing are central to MekHQ-linked play, and the user reports the MegaMek workspace already exposed or can expose the ability to advance the campaign by one day.

Useful acceptance criteria:

- dry-run or preflight reports prompts/blockers if daily processing would need user interaction
- execute advances exactly one loaded campaign day through MekHQ-owned code
- command refuses when baseline campaign id/date/state revision does not match
- post-command live state shows the new date, report changes, finances, repairs, market changes, travel, contract deadlines, and personnel/unit effects where exposed
- MEK-RPG records the RPG scene context and confirmed MekHQ result after reread

### Market Purchase Or Asset Acquisition

This is attractive for play because an RPG scene can negotiate or discover a unit, DropShip, cargo, or equipment purchase, then ask MekHQ to apply the final hard-ledger result.

Useful acceptance criteria:

- stable offer id or stable source-owned selector
- guard fields for campaign id, date, market type, offer id, display name, seller/source, price, and availability
- dry-run reports exact target and expected side effects
- execute purchases through MekHQ-owned logic
- post-command reread confirms funds, market removal, asset addition, cargo/transport implications, and reports

### Contract Accept/Decline

This remains a strong candidate, but it can be prompt-heavy. Use `docs/current/MEKHQ_CONTRACT_MARKET_PROBE_PLAN.md` as the starting point and revise it under this command strategy.

### Repair Assignment Or Execution

This should wait until stable repair work ids and prompt policy exist. The expanded live API still reports stable repair work ids as unsupported, so repair commands remain a later candidate.

## Relationship To Existing Pending Actions

`pending-mekhq-actions.md` remains useful, but its role changes:

- Before command endpoints exist, pending items are manual UI checklists.
- Once a command endpoint exists, pending items can become command proposals with target ids, guard fields, dry-run output, approval status, command result, and reread verification.
- After live reread verifies the command, the pending item can resolve without requiring a separate raw save parse.

Saved import can still be useful as a durable checkpoint, audit artifact, or offline fallback. It is not the only possible confirmation path once a live command plus live reread can prove the result.

## Producer Requests

When MEK-RPG needs a new mutation capability, create a producer request that asks for:

- one narrow command, not broad arbitrary writeback
- stable source-owned selectors
- guard fields and baseline state revision checks
- dry-run/preflight mode when side effects are nontrivial
- explicit prompt policy
- refusal behavior for unsafe or ambiguous cases
- post-command result metadata
- live state fields sufficient to verify success after reread
- disposable validation fixtures or smoke commands

## Non-Goals

- No direct `.cpnx`, `.cpnx.gz`, XML, or raw save mutation by MEK-RPG.
- No broad "apply any pending action" command.
- No command execution from stale baseline state.
- No hidden mutation during rules lookup, dashboard rendering, or context packet assembly.
- No treating MEK-RPG narrative intent as proof that MekHQ changed.

## Planning Impact

Issue `#111` owns the first planning pass for this strategy. It should update older docs that describe manual UI or read-only-only behavior as the permanent workflow.

Issue `#110` remains the expanded read-only state consumption pass. It should preserve the live state surface that command adapters will use for preflight and post-command verification.
