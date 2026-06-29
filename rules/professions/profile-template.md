---
schema_version: profession-profile/v1
profession_id: replace_with_snake_case_id
display_name: Replace With Display Name
status: not_implemented
aliases:
  - replace with MekHQ job or role alias
mekhq_owned_fields:
  - current job/role
  - assignment
  - readiness constraints
mek_rpg_overlay_fields:
  - purpose
  - typical capabilities
  - allowed actions
  - roll rules
  - data access limits
  - failure modes
  - examples
  - test expectations
allowed_actions:
  - action_id as owning or supporting profession
---

# Replace With Display Name

## Purpose

Describe what this profession can plausibly do as a MEK RPG rules overlay. Do not restate MekHQ-owned character facts as profile-owned state.

## Typical Capabilities

- Capability placeholder.

## Relevant MekHQ Fields

- MekHQ-owned field placeholder.

## Relevant RPG Skills

- Skill placeholder or `Unknown`.

## Allowed Actions

- `action_id` as owning or supporting profession, or `None defined yet`.

## Roll Rules

Not implemented. Future action specs must define target numbers, modifiers, support behavior, and reveal-level mapping before this profile can resolve rolls.

## Data Access Limits

MekHQ-owned data may be used only through an action spec and reveal gate. Hidden or exact state must not be exposed directly to player-facing prompts.

## Failure Modes

- Failure mode placeholder.

## Not Yet Implemented

- Runtime profession lookup.
- Action permission enforcement.
- Roll modifiers.
- Prompt assembly tests.

## Example Prompt/Interaction

Example placeholder.

## Test Expectations

- Validate front matter and required headings.
- Prove profile output respects MekHQ-owned data and reveal-gate boundaries.
