# MegaMek / MekHQ TO&E And Pilot Assignment API Handoff

Date: 2026-06-28

Status: handoff-ready MEK-RPG producer request.

Audience: MegaMek / MekHQ workspace team.

Purpose: request a guarded MekHQ local API surface for assigning pilots to units, swapping pilots between units, and modifying the campaign TO&E/force organization without MEK-RPG editing raw saves or reimplementing MekHQ validation rules.

## Background

During live MEK-RPG play for `Sharpe's Strikers`, the player needed to plan first-lance assignments and pilot rotations:

- The company has 13 active MekWarriors.
- The Talitha operation window currently has four available BattleMechs once unmothballed: Catapult CPLT-C1, Griffin GRF-1N, Wolverine WVR-6R, and Jenner JR7-D.
- MekHQ live API output exposes the personnel and units, but all current unit/person assignment fields appear as `Unknown` in the current snapshot.
- MEK-RPG can narratively decide that Sharpe wants a rotation plan, but it should not directly edit `.cpnx`, `.cpnx.gz`, XML, or Markdown to make hard MekHQ ledger changes.

This creates a concrete command gap: MEK-RPG needs a supported MekHQ-owned way to request pilot assignment and TO&E changes, with MekHQ validating the request and refusing bad assignments.

## Requested Design Principle

Expose pilot assignment and TO&E modification as a self-contained MekHQ command surface.

MEK-RPG should be able to submit an intent such as "assign this MekWarrior to this BattleMech" or "move this unit into this lance" and let MekHQ decide whether the action is valid. The command should return structured success or structured refusal. MEK-RPG should not need to know or duplicate every MekHQ rule about role eligibility, crew slot compatibility, force organization rules, scenario locks, deployment state, personnel status, or edge cases.

In short: MekHQ should be the black box that validates and applies the roster/TO&E mutation.

## Requested Readiness Rows

`GET /campaign/commands` should expose command readiness for this family when safe:

- `units.assign_pilot`
- `units.unassign_pilot`
- `units.swap_pilots`
- `toe.move_unit`
- `toe.create_force`
- `toe.rename_force`
- `toe.delete_empty_force`
- Optional later: `toe.batch_update`

Readiness should include whether the command is available, blocked, or selector-detail-deferred, plus the exact selectors and guard facts required for a safe request.

## Requested Read Model

The live state API or command readiness endpoint should expose enough read context to build a valid request without raw save parsing:

### Personnel Selectors

- Stable person id.
- Display name and title.
- Primary and secondary role.
- Status and prisoner/deployment state.
- Current unit id/name if assigned.
- Fatigue, hits, injury summary, and availability flags.
- Eligibility hints where safe, such as `can_pilot_mek`, `can_pilot_aerospace`, `can_crew_vehicle`, or structured `eligible_unit_types`.

### Unit Selectors

- Stable unit id.
- Display name, chassis, model, type, and weight.
- Current status: active, mothballed, in transit, deployed, under repair, etc.
- Current crew slots and occupant person ids.
- Required crew/role shape where source-backed.
- Scenario assignment/deployment locks.
- Force/TO&E location.
- Validation hints such as `pilot_assignment_supported`, `crew_slots_available`, and `assignment_blockers`.

### TO&E Selectors

- Stable force ids.
- Parent/child force tree.
- Force display names.
- Unit ids currently in each force.
- Command/formation metadata needed to move units safely.
- Any constraints that would block mutation, such as deployed scenarios, non-empty delete, or stale force ids.

## Requested Command Shape

Use the guarded command-envelope style already used by other MekHQ local API command candidates:

```json
{
  "command": "units.assign_pilot",
  "commandVersion": "0.1",
  "idempotencyKey": "mek-rpg-unique-key",
  "expectedCampaignId": "7fbbb5da-0bcd-46f1-8f61-846848c2f148",
  "expectedDate": "3025-02-20",
  "expectedStateRevision": "live-...",
  "unitId": "unit-uuid",
  "personId": "person-uuid",
  "expectedUnit": {
    "displayName": "Catapult CPLT-C1",
    "type": "Mek",
    "status": "Mothballed"
  },
  "expectedPerson": {
    "displayName": "Captain Sharpe \"Shooter\" Williams",
    "primaryRole": "MekWarrior",
    "status": "ACTIVE"
  },
  "assignmentPolicy": {
    "allowMothballedUnitAssignment": true,
    "replaceExistingPilot": false,
    "allowUnavailablePersonnel": false,
    "allowDeployedUnitChange": false
  },
  "dryRun": true,
  "promptPolicy": "refuse_if_prompt",
  "saveAfterSuccess": false,
  "clientContext": {
    "actor": "MEK-RPG",
    "sceneId": "sharpes-strikers-3025-02-20-zosma",
    "actionId": "pilot-assignment-plan",
    "reason": "Assign Talitha first-lance pilots after user approval."
  }
}
```

The exact field names can vary, but the command should preserve:

- current campaign/date/state guards
- stable target selectors
- expected display/role/status guard facts
- dry-run or validation-only mode
- explicit prompt policy
- explicit save policy
- structured client context
- post-command result metadata

## Requested Validation And Error Behavior

The API should validate inside MekHQ and return refusal responses for invalid assignments. Important refusal cases include:

- Trying to assign a non-MekWarrior to a BattleMech pilot slot.
- Trying to assign an aerospace pilot to a BattleMech unless MekHQ source rules explicitly allow it.
- Trying to assign a MekWarrior to a vehicle crew slot with incompatible role requirements.
- Assigning one person to multiple incompatible units at the same time.
- Assigning a person who is dead, left, retired, prisoner, missing, inactive, deployed elsewhere, hospitalized, or otherwise unavailable.
- Assigning a pilot to a unit that is not owned by the campaign.
- Assigning a pilot to a unit in transit when MekHQ rules forbid it.
- Assigning a pilot to a deployed scenario unit when the scenario state should lock the roster.
- Replacing an existing pilot when `replaceExistingPilot` is false.
- Changing a unit or force from a stale campaign date/state revision.
- Moving a unit into an invalid TO&E parent/child structure.
- Deleting a non-empty force.
- Creating duplicate or invalid force names if MekHQ disallows them.
- Any prompt/dialog requirement when `promptPolicy` is `refuse_if_prompt`.

Refusal responses should be structured and machine-readable:

```json
{
  "status": "refused",
  "reasonCode": "invalid_role_for_unit",
  "message": "Person is not eligible to pilot Mek units.",
  "target": {
    "unitId": "unit-uuid",
    "personId": "person-uuid"
  },
  "validation": {
    "personPrimaryRole": "Doctor",
    "requiredRole": "MekWarrior",
    "unitType": "Mek"
  },
  "saveAttempted": false,
  "visibleDialogs": 0
}
```

## Requested Success Response

Successful apply responses should include enough data for MEK-RPG to verify by live reread:

```json
{
  "status": "applied",
  "reasonCode": "pilot_assigned",
  "campaignId": "7fbbb5da-0bcd-46f1-8f61-846848c2f148",
  "dateBefore": "3025-02-20",
  "dateAfter": "3025-02-20",
  "unitId": "unit-uuid",
  "unitDisplayName": "Catapult CPLT-C1",
  "assignedPersonId": "person-uuid",
  "assignedPersonName": "Captain Sharpe \"Shooter\" Williams",
  "previousPilotId": null,
  "reportAppended": true,
  "saveRequested": false,
  "saveAttempted": false,
  "visibleDialogs": 0,
  "stateRevisionAfter": "live-..."
}
```

After apply, `GET /campaign/state` should show the updated unit crew/person assignment, and `GET /campaign/commands` should expose the new selectors/guards.

## TO&E Batch Update Request

Pilot assignment and force organization are often one command decision from the player's point of view. Consider a validation-only and apply-capable batch endpoint for force organization changes:

```json
{
  "command": "toe.batch_update",
  "commandVersion": "0.1",
  "expectedCampaignId": "7fbbb5da-0bcd-46f1-8f61-846848c2f148",
  "expectedDate": "3025-02-20",
  "expectedStateRevision": "live-...",
  "operations": [
    {
      "op": "create_force",
      "clientTempId": "first-lance",
      "parentForceId": "root-force-id",
      "name": "First Lance"
    },
    {
      "op": "move_unit",
      "unitId": "catapult-unit-id",
      "targetForceRef": "first-lance"
    },
    {
      "op": "assign_pilot",
      "unitId": "catapult-unit-id",
      "personId": "pilot-person-id"
    }
  ],
  "dryRun": true,
  "promptPolicy": "refuse_if_prompt",
  "saveAfterSuccess": false
}
```

Batch validation should be atomic: either the whole request is valid and can apply, or the response identifies every blocking operation. If partial application is ever supported, it should be explicit and opt-in.

## MEK-RPG Verification Flow

MEK-RPG would consume this API with the standard command loop:

1. `GET /status`
2. `GET /campaign/state` with `bridge_metadata`, `personnel`, `units`, and TO&E/force sections
3. `GET /campaign/commands`
4. Build a guarded dry-run request from readiness selectors
5. Present the intended assignment/TO&E mutation to the user
6. Apply only after approval
7. Reread live state
8. Verify unit crew/person assignment and force tree from MekHQ state
9. Update MEK-RPG campaign notes from verified state only

## Acceptance Criteria

- Readiness reports pilot-assignment and TO&E commands as available or blocked with machine-readable reasons.
- Dry-run validates valid and invalid assignments without mutation.
- Applying a valid pilot assignment changes MekHQ-owned unit/person assignment through MekHQ source logic.
- Applying a valid TO&E move changes MekHQ-owned force organization through MekHQ source logic.
- Invalid assignments are refused with clear `reasonCode` values.
- A non-MekWarrior assigned to a BattleMech is refused.
- A stale campaign id/date/state guard is refused.
- Duplicate/incompatible pilot assignments are refused unless a specific replacement/swap command allows them.
- Commands do not answer arbitrary dialogs; prompt requirements are refused unless explicitly supported.
- `saveAfterSuccess=false` is honored; save attempts happen only when explicitly requested.
- Post-command `GET /campaign/state` exposes enough updated crew/TO&E data for MEK-RPG to verify the result.

## Non-Goals

- MEK-RPG should not edit MekHQ saves or XML.
- MEK-RPG should not infer pilot eligibility from display names or local Markdown.
- The API should not expose a broad arbitrary save-writeback command.
- The API should not silently coerce invalid assignments into nearby valid ones.
- The API should not require MEK-RPG to duplicate MekHQ's internal assignment validators.

## MEK-RPG Consumer Evidence Links

- Command strategy: `docs/current/MEKHQ_COMMAND_API_STRATEGY.md`
- Live API startup decision tree: `docs/current/MEKHQ_OPEN_CONNECTION_STARTUP_DECISION_TREE.md`
- Playtest API gap report: `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`
- Sharpe's Strikers current campaign notes: `campaigns/sharpes-strikers/`
- Current play evidence: pilot/unit planning during the Talitha contract transit, where live API exposed 13 MekWarriors, four Talitha-window BattleMechs, and `Unknown` assignments.

## Suggested Producer-Side Ticket Split

1. Read surface: expose source-confirmed force tree and richer unit/person assignment eligibility fields.
2. Pilot assignment commands: assign, unassign, and swap pilots with dry-run validation.
3. TO&E commands: create/rename/delete empty force and move unit between forces.
4. Batch command: optional atomic validation/apply endpoint for combined lance setup.
5. Fixture/smoke coverage: include valid assignment, invalid role assignment, stale guard refusal, duplicate assignment refusal, and post-command reread verification.

## Boundary

This document is a MEK-RPG-side handoff request only. It does not authorize MEK-RPG agents to edit the MegaMek workspace. The MegaMek/MekHQ team should decide whether and how to implement the request under that repository's own workflow.
