# State Change Proposal Schema

Status: issue `#78` baseline.

Purpose: define how deterministic helpers can propose campaign state changes without editing campaign files, applying MekHQ actions, or treating unresolved hard-ledger intents as confirmed facts.

This schema extends `docs/current/MECHANIC_CONTRACT_SCHEMA.md` field `proposed_state_changes`. A helper may return zero or more proposal objects. Another agent step or the user must review and apply accepted proposals.

## Core Rules

- Helpers never mutate campaign files directly.
- Every proposal is inspectable, approval-gated, and tied to evidence.
- MEK-RPG memory proposals and MekHQ hard-ledger intents are different authority classes.
- Pending MekHQ actions are not confirmed ledger facts until the user applies them in MekHQ, saves, and MEK-RPG imports the saved result.
- Exact funds, repairs, injuries, tactical outcomes, equipment stats, market results, and table values must come from committed summaries, supplied inputs, saved imports, or user confirmation; helpers must not invent them.
- Proposals may be emitted as JSON. A human-facing Markdown checklist is allowed, but it must preserve the same fields.

## Top-Level Shape

```json
{
  "proposal_id": "proposal-YYYYMMDD-NNN",
  "schema_version": "0.1",
  "status": "proposed",
  "change_class": "rpg_memory",
  "change_type": "session_log",
  "target": {
    "campaign_id": "example-campaign",
    "file": "campaigns/example-campaign/session-log.md",
    "section": "State Changes",
    "entity_ref": "pc-ada"
  },
  "summary": "Record the visible consequence in one concise sentence.",
  "proposed_text": "- Ada opened the hatch before the patrol arrived; future patrol pressure is reduced.",
  "evidence": {
    "label": "mechanic-result",
    "source_request_id": "request-001",
    "source_mechanic_id": "core.basic_check",
    "result_status": "provisional",
    "citations": []
  },
  "authority": {
    "source": "mechanic_helper",
    "authority_status": "provisional",
    "owner": "MEK-RPG",
    "warnings": []
  },
  "approval": {
    "requires_approval": true,
    "approved_by": null,
    "approval_timestamp": null,
    "application_step": "Agent or user edits the target campaign file after review."
  },
  "mekhq_boundary": {
    "affects_mekhq_hard_ledger": false,
    "pending_item_id": null,
    "confirmation_required": null
  },
  "no_hidden_mutation": {
    "files_read": [],
    "files_written": [],
    "mekhq_write_attempted": false,
    "campaign_write_attempted": false,
    "protected_source_read": false,
    "notes": "Proposal only; no file was edited."
  },
  "unresolved_questions": []
}
```

## Required Fields

| Field | Required | Purpose |
| --- | --- | --- |
| `proposal_id` | yes | Stable id inside one helper result, unique enough to quote in review. |
| `schema_version` | yes | Proposal schema version, currently `0.1`. |
| `status` | yes | Lifecycle state from the list below. |
| `change_class` | yes | Authority class: `rpg_memory`, `mekhq_pending_intent`, or `workflow_note`. |
| `change_type` | yes | Specific update type such as `pc_condition`, `asset`, `mission`, `pending_mekhq_action`, or `rules_gap`. |
| `target` | yes | Campaign id, file, section, and optional entity reference. |
| `summary` | yes | One-sentence human summary. |
| `proposed_text` | yes | Text suitable for review before insertion; not auto-applied. |
| `evidence` | yes | Why the proposal exists. |
| `authority` | yes | Source and authority status behind the proposal. |
| `approval` | yes | Required review and application step. |
| `mekhq_boundary` | yes | Whether the proposal touches MekHQ-owned ledger facts. |
| `no_hidden_mutation` | yes | Proof that the helper did not edit files or MekHQ. |
| `unresolved_questions` | yes | Questions that must be answered before approval or application. |

## Status Values

- `proposed`: emitted by a helper or agent for review.
- `accepted`: user or agent approved the proposal for application.
- `applied`: the target campaign file was edited after review.
- `queued`: accepted MekHQ hard-ledger intent waiting for manual MekHQ application.
- `user_applied_in_mekhq`: user reports applying the change in MekHQ and saving.
- `import_confirmed`: saved MekHQ import appears to confirm the hard-ledger result.
- `resolved`: proposal or pending item is fully reconciled.
- `rejected`: reviewer decided not to apply it.
- `blocked`: cannot be applied or confirmed yet.
- `superseded`: replaced by a newer proposal or correction.

Use `accepted`, `applied`, and `resolved` for MEK-RPG memory. Use `queued`, `user_applied_in_mekhq`, `import_confirmed`, and `resolved` for MekHQ hard-ledger workflows.

## Change Classes

### `rpg_memory`

Use for MEK-RPG-owned campaign memory: scenes, conditions, relationships, promises, hooks, rulings, known uncertainty, narrative asset notes, and table-facing consequences. These proposals target normal campaign files and can be applied after review.

### `mekhq_pending_intent`

Use when a scene creates a possible or committed change to MekHQ-owned facts such as funds, unit condition, contracts, repair queues, markets, personnel availability, tactical outcomes, salvage, or day advancement. The proposal may create or update an item in `pending-mekhq-actions.md`; it must not claim the ledger changed.

### `workflow_note`

Use for rules gaps, playtest friction, source-review needs, safety/tone notes, or helper limitations that should be saved for future sessions. These usually target `rules-gaps.md`, `playtest-notes.md`, or `safety-and-tone.md`.

## Change Types And Owners

| Change type | Target owner | Notes |
| --- | --- | --- |
| `current_state` | `current-state.md` | Resume point, location, active pressure, next prompt. |
| `session_log` | `session-log.md` | Recent choices, rolls, rulings, costs, rewards, state changes, pending ids. |
| `completed_session` | `previous-sessions.md` | Durable session archive after close-out. |
| `pc_condition` | `pcs.md` | Injury, fatigue, gear, goals, sheet gaps, personal notes. |
| `npc_update` | `npcs.md` | Whereabouts, attitude, promises, secrets, status. |
| `faction_update` | `factions.md` | Reputation, hostility, obligations, faction pressure. |
| `location_update` | `locations.md` | Access, hazards, discoveries, local contacts. |
| `asset_update` | `assets.md` | Money overlays, equipment, vehicles, cargo, permits, debts, repairs, evidence labels. |
| `relationship_update` | `relationships.md` | Trust, leverage, grudges, loyalty, favors, family or crew ties. |
| `mission_update` | `missions.md` | Objectives, contract context, deadlines, tactical handoff status. |
| `hook_update` | `hooks.md` | Future pressure, unresolved opportunities, threats, clues. |
| `rules_gap` | `rules-gaps.md` | Missing, provisional, or source-review-needed rule. |
| `playtest_note` | `playtest-notes.md` | Workflow friction, helper limitation, usability observation. |
| `safety_tone` | `safety-and-tone.md` | Player preference, child/co-player constraint, tone boundary. |
| `pending_mekhq_action` | `pending-mekhq-actions.md` | Manual MekHQ UI intent requiring later saved import confirmation. |

## Target Object

```json
{
  "campaign_id": "isekai-atlas-field",
  "file": "campaigns/isekai-atlas-field/pcs.md",
  "section": "PCs",
  "entity_ref": "pc-ada",
  "insertion_hint": "Under Ada / Current Condition",
  "conflict_policy": "structured_owner_overrides_old_summary"
}
```

`file` must be a normal campaign file or a documented project note. Helpers must not target protected source paths, raw MekHQ saves, extracted source text, purchased PDFs, or generated imports as write targets.

## Evidence Object

```json
{
  "label": "mechanic-result",
  "source_request_id": "request-001",
  "source_mechanic_id": "core.opposed_check",
  "result_status": "provisional",
  "result_summary": "Actor wins the opposed check",
  "source_files": ["rules/core/opposed-actions.md"],
  "citations": [
    {
      "kind": "summary",
      "path": "rules/core/opposed-actions.md",
      "manifest_id": "core.opposed-actions",
      "manifest_status": "draft",
      "source_pages": "A Time of War PDF pages 41-42 / printed pages 39-40"
    }
  ],
  "user_confirmation": null
}
```

Allowed evidence labels:

- `mechanic-result`
- `gm-ruling`
- `user-confirmed`
- `mekhq-import`
- `pending-mekhq-intent`
- `rules-route`
- `source-page-reference`
- `playtest-observation`
- `safety-preference`

## Authority Object

```json
{
  "source": "mechanic_helper",
  "authority_status": "provisional",
  "owner": "MEK-RPG",
  "routed_files": ["rules/core/skill-checks.md"],
  "warnings": [
    {
      "code": "draft-summary",
      "severity": "caution",
      "message": "Draft summaries can support source-aware play, but the ruling remains provisional."
    }
  ]
}
```

`owner` values:

- `MEK-RPG`: RPG memory and table-facing continuity.
- `MekHQ`: hard ledger facts imported from saved MekHQ state.
- `Table`: explicit user/table decision.
- `External tactical authority`: Classic BattleTech, MegaMek, MekHQ, or tabletop tactical result.
- `Unknown`: cannot safely apply until clarified.

## Approval Object

```json
{
  "requires_approval": true,
  "approved_by": null,
  "approval_timestamp": null,
  "application_step": "After review, append proposed_text to campaigns/example/session-log.md under State Changes.",
  "rollback_note": "If incorrect, mark the applied note Corrected or Superseded in the owner file."
}
```

For project-development helpers, `requires_approval` should stay `true` unless the user explicitly asked the agent to apply the change in the same turn. For play mode, helpers may propose during resolution, but the GM save step applies only the accepted proposals needed for durable continuity.

## MekHQ Boundary Object

```json
{
  "affects_mekhq_hard_ledger": true,
  "pending_item_id": "mekhq-pending-2026-06-21-001",
  "pending_status": "proposed",
  "confirmation_required": "Saved MekHQ import shows unit SRM Carrier marked damaged.",
  "ledger_fields": ["unit condition"],
  "rpg_memory_files": ["session-log.md", "assets.md", "missions.md"]
}
```

If `affects_mekhq_hard_ledger` is true, the proposal must target `pending-mekhq-actions.md` or reference an existing pending id. It may also propose RPG memory notes for the narrative cause, but those notes must say the ledger result is pending until confirmed by saved import.

## No-Hidden-Mutation Proof

The proposal must carry the helper's mutation proof or a narrower proposal-level proof:

```json
{
  "files_read": ["tests/fixtures/opposed-check-success.fixture.json"],
  "files_written": [],
  "mekhq_write_attempted": false,
  "campaign_write_attempted": false,
  "protected_source_read": false,
  "notes": "Proposal only; no campaign or MekHQ state was edited."
}
```

`campaign_write_attempted` must remain false for deterministic mechanic helpers. A later apply step may edit files, but that edit is no longer hidden; it must be visible in git diff or the user's explicit action.

## Optional Markdown Review Wrapper

For human review, proposals may be rendered as Markdown:

```markdown
### proposal-20260621-001: Session log consequence

- Status: proposed
- Change class: rpg_memory
- Change type: session_log
- Target: `campaigns/example/session-log.md` > `State Changes`
- Evidence: mechanic-result from `core.basic_check`, provisional
- Authority owner: MEK-RPG
- Requires approval: yes
- MekHQ hard-ledger effect: no
- Proposed text: Ada opened the hatch before the patrol arrived; patrol pressure is reduced.
- Application step: append after review.
- Mutation proof: no files written; no MekHQ write attempted.
```

The Markdown wrapper is only a view. The JSON object remains the canonical helper output.

## Examples

### Skill-Check Consequence

```json
{
  "proposal_id": "proposal-20260621-001",
  "schema_version": "0.1",
  "status": "proposed",
  "change_class": "rpg_memory",
  "change_type": "session_log",
  "target": {
    "campaign_id": "example",
    "file": "campaigns/example/session-log.md",
    "section": "State Changes",
    "entity_ref": "pc-ada"
  },
  "summary": "Record that Ada opened the hatch before the patrol arrived.",
  "proposed_text": "- Ada opened the maintenance hatch before the patrol arrived; patrol pressure for the next beat is reduced.",
  "evidence": {
    "label": "mechanic-result",
    "source_request_id": "fixture-basic-success",
    "source_mechanic_id": "core.basic_check",
    "result_status": "provisional",
    "result_summary": "Success with margin 1",
    "source_files": ["rules/core/skill-checks.md", "rules/core/basic-action-resolution.md"],
    "citations": []
  },
  "authority": {
    "source": "resolve-basic-check.ps1",
    "authority_status": "provisional",
    "owner": "MEK-RPG",
    "warnings": []
  },
  "approval": {
    "requires_approval": true,
    "approved_by": null,
    "approval_timestamp": null,
    "application_step": "Append proposed_text to session-log.md after GM review."
  },
  "mekhq_boundary": {
    "affects_mekhq_hard_ledger": false,
    "pending_item_id": null,
    "confirmation_required": null
  },
  "no_hidden_mutation": {
    "files_read": [],
    "files_written": [],
    "mekhq_write_attempted": false,
    "campaign_write_attempted": false,
    "protected_source_read": false,
    "notes": "Proposal only."
  },
  "unresolved_questions": []
}
```

### Opposed-Check Consequence

```json
{
  "proposal_id": "proposal-20260621-002",
  "schema_version": "0.1",
  "status": "proposed",
  "change_class": "rpg_memory",
  "change_type": "relationship_update",
  "target": {
    "campaign_id": "example",
    "file": "campaigns/example/relationships.md",
    "section": "Crew And Contacts",
    "entity_ref": "npc-sentry"
  },
  "summary": "Record that the sentry was outmaneuvered but not harmed.",
  "proposed_text": "- The sentry failed to spot the scout in the corridor; future suspicion may rise if later evidence appears.",
  "evidence": {
    "label": "mechanic-result",
    "source_request_id": "fixture-opposed-success",
    "source_mechanic_id": "core.opposed_check",
    "result_status": "provisional",
    "result_summary": "Actor wins the opposed check",
    "source_files": ["rules/core/opposed-actions.md"],
    "citations": []
  },
  "authority": {
    "source": "resolve-opposed-check.ps1",
    "authority_status": "provisional",
    "owner": "MEK-RPG",
    "warnings": []
  },
  "approval": {
    "requires_approval": true,
    "approved_by": null,
    "approval_timestamp": null,
    "application_step": "Add or update a relationship/NPC note after GM review."
  },
  "mekhq_boundary": {
    "affects_mekhq_hard_ledger": false,
    "pending_item_id": null,
    "confirmation_required": null
  },
  "no_hidden_mutation": {
    "files_read": [],
    "files_written": [],
    "mekhq_write_attempted": false,
    "campaign_write_attempted": false,
    "protected_source_read": false,
    "notes": "Proposal only."
  },
  "unresolved_questions": []
}
```

### Injury Or Damage Consequence

```json
{
  "proposal_id": "proposal-20260621-003",
  "schema_version": "0.1",
  "status": "proposed",
  "change_class": "rpg_memory",
  "change_type": "pc_condition",
  "target": {
    "campaign_id": "example",
    "file": "campaigns/example/pcs.md",
    "section": "Current Condition",
    "entity_ref": "pc-ada"
  },
  "summary": "Record a source-bound injury consequence after GM approval.",
  "proposed_text": "- Ada has a bruised shoulder from the fall. Exact wound penalties remain pending source/user confirmation.",
  "evidence": {
    "label": "gm-ruling",
    "source_request_id": "combat-checkpoint-001",
    "source_mechanic_id": "combat.personal_checkpoint",
    "result_status": "provisional",
    "result_summary": "Personal-scale damage consequence proposed",
    "source_files": ["rules/personal-combat/damage.md", "rules/personal-combat/wounds.md"],
    "citations": []
  },
  "authority": {
    "source": "GM ruling plus routed summaries",
    "authority_status": "provisional",
    "owner": "MEK-RPG",
    "warnings": [
      {
        "code": "exact-wound-table-not-applied",
        "severity": "caution",
        "message": "Do not record exact wound penalties until supplied by user or source lookup."
      }
    ]
  },
  "approval": {
    "requires_approval": true,
    "approved_by": null,
    "approval_timestamp": null,
    "application_step": "Update pcs.md only after GM confirms the injury description and any mechanical effect."
  },
  "mekhq_boundary": {
    "affects_mekhq_hard_ledger": false,
    "pending_item_id": null,
    "confirmation_required": null
  },
  "no_hidden_mutation": {
    "files_read": [],
    "files_written": [],
    "mekhq_write_attempted": false,
    "campaign_write_attempted": false,
    "protected_source_read": false,
    "notes": "Proposal only."
  },
  "unresolved_questions": ["Confirm whether this injury has a mechanical penalty or is narrative only."]
}
```

### Equipment Loss

```json
{
  "proposal_id": "proposal-20260621-004",
  "schema_version": "0.1",
  "status": "proposed",
  "change_class": "rpg_memory",
  "change_type": "asset_update",
  "target": {
    "campaign_id": "example",
    "file": "campaigns/example/assets.md",
    "section": "Personal Gear",
    "entity_ref": "gear-demo-kit"
  },
  "summary": "Record that a supplied kit was lost during the scene.",
  "proposed_text": "- Demo kit was lost in the scramble. Exact replacement cost is Unknown until user/source lookup supplies it.",
  "evidence": {
    "label": "gm-ruling",
    "source_request_id": "equipment-scene-001",
    "source_mechanic_id": "core.opposed_check",
    "result_status": "provisional",
    "result_summary": "Failed opposed check with declared gear-loss stakes",
    "source_files": ["rules/equipment/personal-gear.md"],
    "citations": []
  },
  "authority": {
    "source": "GM-approved stakes",
    "authority_status": "provisional",
    "owner": "MEK-RPG",
    "warnings": []
  },
  "approval": {
    "requires_approval": true,
    "approved_by": null,
    "approval_timestamp": null,
    "application_step": "Update assets.md after review; do not invent replacement cost."
  },
  "mekhq_boundary": {
    "affects_mekhq_hard_ledger": false,
    "pending_item_id": null,
    "confirmation_required": null
  },
  "no_hidden_mutation": {
    "files_read": [],
    "files_written": [],
    "mekhq_write_attempted": false,
    "campaign_write_attempted": false,
    "protected_source_read": false,
    "notes": "Proposal only."
  },
  "unresolved_questions": ["Replacement cost and availability are Unknown."]
}
```

### Pending MekHQ Ledger Intent

```json
{
  "proposal_id": "proposal-20260621-005",
  "schema_version": "0.1",
  "status": "proposed",
  "change_class": "mekhq_pending_intent",
  "change_type": "pending_mekhq_action",
  "target": {
    "campaign_id": "example",
    "file": "campaigns/example/pending-mekhq-actions.md",
    "section": "Pending Items",
    "entity_ref": "mekhq-pending-2026-06-21-001"
  },
  "summary": "Queue a manual MekHQ repair-logistics intent for later application and import confirmation.",
  "proposed_text": "### mekhq-pending-2026-06-21-001: Apply repair result\n\n- Status: proposed\n- Type: repair-logistics\n- Priority: before-day-advance\n- Proposed MekHQ action: User reviews and applies the repair/logistics result in MekHQ UI.\n- Confirmation needed from next import: saved MekHQ import shows the expected unit repair state.\n- Resolution notes: TBD",
  "evidence": {
    "label": "pending-mekhq-intent",
    "source_request_id": "combat-checkpoint-002",
    "source_mechanic_id": "combat.personal_checkpoint",
    "result_status": "provisional",
    "result_summary": "Scene produced a possible MekHQ-owned repair consequence.",
    "source_files": ["session-log.md", "assets.md"],
    "citations": []
  },
  "authority": {
    "source": "GM/table intent",
    "authority_status": "provisional",
    "owner": "MekHQ",
    "warnings": [
      {
        "code": "pending-not-ledger-fact",
        "severity": "blocker",
        "message": "This item is not a confirmed MekHQ ledger change until manual application, save, and import confirmation."
      }
    ]
  },
  "approval": {
    "requires_approval": true,
    "approved_by": null,
    "approval_timestamp": null,
    "application_step": "After review, add the pending item to pending-mekhq-actions.md; user later applies it in MekHQ UI and saves."
  },
  "mekhq_boundary": {
    "affects_mekhq_hard_ledger": true,
    "pending_item_id": "mekhq-pending-2026-06-21-001",
    "pending_status": "proposed",
    "confirmation_required": "Saved MekHQ import confirms the repair/logistics state.",
    "ledger_fields": ["unit repair state"],
    "rpg_memory_files": ["session-log.md", "assets.md"]
  },
  "no_hidden_mutation": {
    "files_read": [],
    "files_written": [],
    "mekhq_write_attempted": false,
    "campaign_write_attempted": false,
    "protected_source_read": false,
    "notes": "Proposal only."
  },
  "unresolved_questions": ["Exact MekHQ target ids are Unknown until imported or selected by the user."]
}
```

## Review And Application Procedure

1. Read each proposal summary, target, evidence, authority, warnings, and unresolved questions.
2. Reject or block any proposal with insufficient authority, missing target, invented exact value, protected-source dependency, or unclear MekHQ boundary.
3. For accepted MEK-RPG memory proposals, edit the target campaign file deliberately and keep the diff inspectable.
4. For accepted MekHQ hard-ledger intents, add or update `pending-mekhq-actions.md`; do not update final ledger facts until saved import confirmation exists.
5. After application, record the proposal id or pending item id in `session-log.md` when useful.
6. Keep `no_hidden_mutation` proof from the helper result in logs or test fixtures when debugging helper behavior.

## Validation Checklist

Before applying a proposal, confirm:

- target file is a normal campaign or project note file
- change class matches the authority owner
- evidence names the source mechanic, route, user confirmation, import, or GM ruling
- provisional authority stays labeled provisional
- pending MekHQ actions are not described as final facts
- exact numeric/table values are supplied or marked `Unknown`
- protected source paths and raw MekHQ saves are not write targets
- application step says who or what applies the change
- helper reported no hidden mutation
