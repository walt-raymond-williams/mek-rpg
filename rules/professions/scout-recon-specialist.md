---
schema_version: profession-profile/v1
profession_id: scout_recon_specialist
display_name: Scout / Recon Specialist
status: not_implemented
aliases:
  - scout
  - recon specialist
  - reconnaissance specialist
  - scout/recon
  - forward observer
mekhq_owned_fields:
  - current job/role
  - assignment
  - unit or lance attachment
  - fatigue/injury/readiness constraints
  - scenario deployment relationship
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
  - pre_mission_intel_check: owning
---

# Scout / Recon Specialist

## Status

- Profession id: `scout_recon_specialist`.
- Status: `not_implemented`.
- Schema: `profession-profile/v1`.

## Purpose

Interprets field observation, terrain, movement, and contact reports to estimate enemy strength and battlefield risk.

## Typical Capabilities

- Reconnaissance interpretation.
- Terrain and deployment risk assessment.
- Enemy count and weight-class estimation.
- Support or ownership of pre-mission intelligence checks.

## Relevant MekHQ Fields

- current job/role
- assignment
- unit or lance attachment
- fatigue/injury/readiness constraints
- scenario deployment relationship

## Relevant RPG Skills

- Scouting, perception, sensor operations, survival, or tactics-adjacent skills when available.

## Allowed Actions

- `pre_mission_intel_check` as owning profession.

## Roll Rules

Use the action's configured roll gate. Scout/recon results may be stronger for terrain, count, and deployment warnings than for exact enemy records.

## Data Access Limits

MekHQ-owned assignment, readiness, and scenario relationship facts remain authoritative. This profile may receive only filtered hidden scenario facts, and exact chassis, pilot skills, or hidden objectives require the action's high reveal levels.

## Failure Modes

- Mistaken contact count.
- Misread terrain or sensor returns.
- Lost detail due to time pressure or poor conditions.

## Not Yet Implemented

- MekHQ job alias mapping.
- Terrain-specific roll modifiers.

## Example Prompt/Interaction

The Scout reviews pending deployment data and reports likely contact size, mobility, and battlefield risk in character-facing language.

## Test Expectations

- Can own `pre_mission_intel_check`.
- Does not reveal exact pilot skills below level 6.
