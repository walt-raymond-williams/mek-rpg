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
  - recon
  - Needs API review: MekHQ scout or recon job strings
mekhq_owned_fields:
  - current job/role
  - assignment
  - unit or lance attachment
  - fatigue/injury/readiness constraints
  - scenario deployment relationship
  - terrain/weather/deployment fields if exposed
  - hidden contact data only as adjudication input
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

Interprets field observation, terrain, movement, and contact reports to estimate enemy strength and battlefield risk. This profile is a MEK RPG overlay; MekHQ remains authoritative for the character's job, assignment, unit attachment, and readiness.

## Typical Capabilities

- Reconnaissance interpretation.
- Terrain and deployment risk assessment.
- Enemy count and weight-class estimation.
- Support or ownership of pre-mission intelligence checks.
- Early warning about ambush posture, bad approaches, or poor extraction conditions when reveal level permits it.

## Relevant MekHQ Fields

- current job/role
- assignment
- unit or lance attachment
- fatigue/injury/readiness constraints
- scenario deployment relationship
- terrain/weather/deployment fields if exposed
- hidden contact data only as reveal-gated adjudication input

## Relevant RPG Skills

- Scouting, perception, sensor operations, survival, or tactics-adjacent skills when available.
- Needs source review: exact A Time of War scouting, sensors, and perception skill names.

## Allowed Actions

- `pre_mission_intel_check` as owning profession.

## Roll Rules

Use the action's configured roll gate. Scout/recon results may be strongest for terrain, count, approach, and deployment warnings. Exact enemy records still require the action's reveal levels and later dice/reveal design.

## Data Access Limits

MekHQ-owned assignment, readiness, and scenario relationship facts remain authoritative. This profile may receive only filtered hidden scenario facts, and exact chassis, pilot skills, or hidden objectives require the action's high reveal levels. Recon language should stay approximate unless the action explicitly grants exact detail.

## Failure Modes

- Mistaken contact count.
- Misread terrain or sensor returns.
- Lost detail due to time pressure or poor conditions.
- Correct contact spotted too late to improve the plan.

## Not Yet Implemented

- Stable MekHQ job alias mapping.
- Terrain-specific roll modifiers.
- Support behavior when recon data comes from an NPC, unit, drone, or aerospace observer.

## Example Prompt/Interaction

The Scout reviews pending deployment data and reports likely contact size, mobility, and battlefield risk in character-facing language, such as "reinforced contact moving through poor visibility" rather than exact unit sheets.

## Test Expectations

- Can own `pre_mission_intel_check`.
- Does not reveal exact pilot skills below level 6.
- Future lookup tests should keep unknown scout/recon aliases as `Needs API review` instead of granting automatic ownership.
