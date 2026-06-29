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
  - command liaison
  - Needs API review: MekHQ administrative and campaign staff roles
mekhq_owned_fields:
  - current job/role
  - assignment
  - contract metadata
  - employer/faction relationship if exposed
  - command or admin position
  - campaign finance/status fields if exposed
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

Handles contracts, bureaucracy, negotiation context, faction liaison work, and administrative framing for MekHQ-owned campaign facts. This profile is a MEK RPG overlay; MekHQ remains authoritative for the contract, campaign, assignment, and relationship data it exposes.

## Typical Capabilities

- Contract interpretation.
- Faction or employer liaison context.
- Administrative support for intelligence checks.
- Risk and authority recommendations.
- Translation of public mission objectives into employer, faction, and command consequences.

## Relevant MekHQ Fields

- current job/role
- assignment
- contract metadata
- employer/faction relationship if exposed
- command or admin position
- campaign finance/status fields if exposed

## Relevant RPG Skills

- Administration, protocol, negotiation, bureaucracy, leadership, or similar skills.
- Needs source review: exact A Time of War social, administration, and negotiation skill names.

## Allowed Actions

- `pre_mission_intel_check` as supporting profession.

## Roll Rules

Support role only for the first action. May help identify whether a scenario shape matches contract terms or withdrawal authority. Any modifier or support benefit must be defined by the future action spec.

## Data Access Limits

Does not access hidden OpFor detail by default. May contextualize public contract and objective information. Hidden scenario or exact enemy data can appear only if an owning profession's action and reveal level permit it.

## Failure Modes

- Misread contract authority.
- Political risk underestimated.
- Legal permission confused with tactical wisdom.
- Treats an employer preference as a confirmed hard rule.

## Not Yet Implemented

- Contract-risk action specs.
- MekHQ contract field mapping.
- Stable MekHQ admin/liaison alias mapping.

## Example Prompt/Interaction

The Liaison warns that refusing a battle may affect employer relations but confirms whether withdrawal authority exists, using public contract facts and any filtered intel already permitted.

## Test Expectations

- Cannot reveal hidden scenario data without an owning profession's successful action.
- Future tests should prove public contract context can support an intel check without exposing exact hidden enemy fields.
