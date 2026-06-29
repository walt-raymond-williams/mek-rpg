# Intelligence Officer

## Status

- Profession id: `intelligence_officer`.
- Status: Planned stub.

## Purpose

Turns reports, scenario metadata, reconnaissance, signals, and command context into actionable but uncertainty-aware briefings.

## Typical Capabilities

- Pre-mission threat assessment.
- Enemy strength and quality estimation.
- Hidden objective or ambush risk warning when the action and roll permit it.
- Briefing translation from raw MekHQ/scenario data into in-universe advice.

## Relevant MekHQ Fields

- personnel id/name
- current job/role
- assignment
- rank/title if exposed
- fatigue/injury/readiness constraints
- scenario assignment or command relationship

## Relevant RPG Skills

- Intelligence analysis or equivalent if summarized later.
- Tactics or strategy-adjacent skills when available.
- Communications, administration, or research support where appropriate.

## Allowed Actions

- `pre_mission_intel_check` as owning profession.

## Roll Rules

Use the action's configured roll gate. This profile should usually be the best fit for intelligence reveal checks.

## Data Access Limits

May access hidden scenario intelligence only through action reveal levels. Raw hidden data must not be exposed directly to the player.

## Failure Modes

- Overconfident wrong read.
- Stale report.
- Understated elite threat.
- Vague warning without actionable detail.

## Not Yet Implemented

- Profile schema.
- MekHQ job alias mapping.
- Deterministic roll modifiers.
- Prompt assembly tests.

## Example Prompt/Interaction

The GM asks the Intelligence Officer to brief a pending scenario. The system rolls, filters hidden facts by reveal level, then outputs an in-universe warning without raw debug data.

## Test Expectations

- Can own `pre_mission_intel_check`.
- Cannot reveal exact units or pilot skills unless the action resolves to the required reveal level.
