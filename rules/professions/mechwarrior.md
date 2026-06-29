# MechWarrior

## Status

- Profession id: `mechwarrior`.
- Status: Planned stub.

## Purpose

Represents BattleMech pilots and battlefield operators whose personal experience can contextualize tactical threats but should not grant unrestricted intelligence access.

## Typical Capabilities

- Tactical feasibility commentary.
- Duel or lance-combat intuition.
- Support to pre-mission intelligence when assigned to the scenario.
- Tactical handoff awareness for MegaMek or Classic BattleTech play.

## Relevant MekHQ Fields

- current job/role
- assigned unit
- Gunnery/Piloting-like fields where exposed
- fatigue, injury, and readiness
- scenario deployment assignment

## Relevant RPG Skills

- Gunnery, Piloting, Tactics, MechWarrior-related skills.

## Allowed Actions

- `pre_mission_intel_check` as supporting profession.

## Roll Rules

Support role only for the first action. A later issue may define pilot-specific tactical read actions.

## Data Access Limits

Does not gain hidden OpFor data by default. May contextualize filtered facts the owning profession has already earned.

## Failure Modes

- Personal bias from past combat.
- Overfocus on duel logic instead of mission objectives.
- Underestimates non-BattleMech threats.

## Not Yet Implemented

- Pilot-specific action list.
- Integration with tactical handoff checklist.

## Example Prompt/Interaction

After intel estimates elite opposition, the MechWarrior may comment on whether the assigned lance can survive the engagement.

## Test Expectations

- Cannot own `pre_mission_intel_check` in milestone 1.
- Cannot bypass reveal gates as a support profession.
