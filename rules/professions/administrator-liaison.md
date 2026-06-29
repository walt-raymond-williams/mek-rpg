---
schema_version: profession-profile/v1
profession_id: administrator_liaison
display_name: Administrator / Liaison
status: not_implemented
aliases:
  - administrator
  - liaison
  - administrator/liaison
  - admin
  - contract liaison
mekhq_owned_fields:
  - current job/role
  - assignment
  - contract metadata
  - employer/faction relationship if exposed
  - command or admin position
mek_rpg_overlay_fields:
  - purpose
  - typical capabilities
  - relevant RPG skills
  - allowed actions
  - roll rules
  - data access limits
  - failure modes
  - examples
  - test expectations
allowed_actions:
  - pre_mission_intel_check: supporting
---

# Administrator / Liaison

## Status

- Profession id: `administrator_liaison`.
- Status: `not_implemented`.
- Schema: `profession-profile/v1`.

## Purpose

Handles contracts, bureaucracy, negotiation context, faction liaison work, and administrative framing for MekHQ-owned campaign facts.

## Typical Capabilities

- Contract interpretation.
- Faction or employer liaison context.
- Administrative support for intelligence checks.
- Risk and authority recommendations.

## Relevant MekHQ Fields

- current job/role
- assignment
- contract metadata
- employer/faction relationship if exposed
- command or admin position

## Relevant RPG Skills

- Administration, protocol, negotiation, bureaucracy, leadership, or similar skills.

## Allowed Actions

- `pre_mission_intel_check` as supporting profession.

## Roll Rules

Support role only for the first action. May help identify whether a scenario shape matches contract terms or withdrawal authority.

## Data Access Limits

Does not access hidden OpFor detail by default. May contextualize public contract and objective information.

## Failure Modes

- Misread contract authority.
- Political risk underestimated.
- Legal permission confused with tactical wisdom.

## Not Yet Implemented

- Contract-risk action specs.
- MekHQ contract field mapping.

## Example Prompt/Interaction

The Liaison warns that refusing a battle may affect employer relations but confirms whether withdrawal authority exists.

## Test Expectations

- Cannot reveal hidden scenario data without an owning profession's successful action.
