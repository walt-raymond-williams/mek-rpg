# Scout / Recon Specialist

## Status

- Profession id: `scout_recon_specialist`.
- Status: Planned stub.

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

May receive only filtered hidden scenario facts. Exact chassis, pilot skills, or hidden objectives require the action's high reveal levels.

## Failure Modes

- Mistaken contact count.
- Misread terrain or sensor returns.
- Lost detail due to time pressure or poor conditions.

## Not Yet Implemented

- Profile schema.
- MekHQ job alias mapping.
- Terrain-specific roll modifiers.

## Example Prompt/Interaction

The Scout reviews pending deployment data and reports likely contact size, mobility, and battlefield risk in character-facing language.

## Test Expectations

- Can own `pre_mission_intel_check`.
- Does not reveal exact pilot skills below level 6.
