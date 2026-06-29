---
schema_version: profession-profile/v1
profession_id: mechwarrior
display_name: MechWarrior
status: not_implemented
aliases:
  - mechwarrior
  - mech warrior
  - battlemech pilot
  - mech pilot
  - pilot
  - BattleMech Pilot
  - Needs API review: exact MekHQ primary combat-role labels
mekhq_owned_fields:
  - current job/role
  - assigned unit
  - Gunnery/Piloting-like fields where exposed
  - fatigue, injury, and readiness
  - scenario deployment assignment
  - force assignment and lance position if exposed
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

# MechWarrior

## Status

- Profession id: `mechwarrior`.
- Status: `not_implemented`.
- Schema: `profession-profile/v1`.

## Purpose

Represents BattleMech pilots and battlefield operators whose personal experience can contextualize tactical threats but should not grant unrestricted intelligence access. MekHQ remains authoritative for pilot identity, assignment, unit, skills, fatigue, injuries, and deployment state.

## Typical Capabilities

- Tactical feasibility commentary.
- Duel or lance-combat intuition.
- Support to pre-mission intelligence when assigned to the scenario.
- Tactical handoff awareness for MegaMek or Classic BattleTech play.
- Practical warnings about whether the assigned lance can survive an estimated threat.

## Relevant MekHQ Fields

- current job/role
- assigned unit
- Gunnery/Piloting-like fields where exposed
- fatigue, injury, and readiness
- scenario deployment assignment
- force assignment and lance position if exposed

## Relevant RPG Skills

- Gunnery, Piloting, Tactics, MechWarrior-related skills.
- Needs source review: exact A Time of War combat and piloting skill names.

## Allowed Actions

- `pre_mission_intel_check` as supporting profession.

## Roll Rules

Support role only for the first action. A later issue may define pilot-specific tactical read actions. Support should never improve reveal level unless the future action spec explicitly defines how pilot expertise modifies the owning profession's roll.

## Data Access Limits

MekHQ-owned pilot, assignment, unit, fatigue, injury, and readiness facts remain authoritative. This profile does not gain hidden OpFor data by default and may contextualize only filtered facts the owning profession has already earned through an action spec and reveal gate. Tactical details that require full BattleTech resolution should be handed to MegaMek, MekHQ, or Classic BattleTech.

## Failure Modes

- Personal bias from past combat.
- Overfocus on duel logic instead of mission objectives.
- Underestimates non-BattleMech threats.
- Treats a rounded intelligence estimate as exact tactical certainty.

## Not Yet Implemented

- Pilot-specific action list.
- Integration with tactical handoff checklist.
- Stable MekHQ role and unit-assignment alias mapping.

## Example Prompt/Interaction

After intel estimates elite opposition, the MechWarrior may comment on whether the assigned lance can survive the engagement, without seeing unrevealed OpFor sheets or pilot numbers.

## Test Expectations

- Cannot own `pre_mission_intel_check` in milestone 1.
- Cannot bypass reveal gates as a support profession.
- Future tests should confirm BattleMech tactical state remains MekHQ/MegaMek-owned rather than profile-owned.
