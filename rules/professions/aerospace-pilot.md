---
schema_version: profession-profile/v1
profession_id: aerospace_pilot
display_name: Aerospace Pilot
status: not_implemented
aliases:
  - aerospace pilot
  - fighter pilot
  - aero pilot
  - aerospace
  - pilot aerospace
  - air support pilot
  - Needs API review: exact MekHQ aerospace crew role labels
mekhq_owned_fields:
  - current job/role
  - assigned aerospace unit
  - Gunnery/Piloting-like fields if exposed
  - fatigue, injury, and readiness
  - scenario assignment
  - air support or deployment relationship if exposed
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

# Aerospace Pilot

## Status

- Profession id: `aerospace_pilot`.
- Status: `not_implemented`.
- Schema: `profession-profile/v1`.

## Purpose

Handles aerospace operations, approach risk, airspace context, transport escort concerns, and air mission support. MekHQ remains authoritative for aerospace assignment, unit state, skills, fatigue, injury, and readiness.

## Typical Capabilities

- Airspace and approach assessment.
- Support to pre-mission intelligence where aerial observation is relevant.
- Tactical handoff context for aerospace combat.
- Evacuation or reinforcement feasibility comments.
- Warnings about weather, approach corridors, sensor coverage, or air-defense exposure when filtered data permits it.

## Relevant MekHQ Fields

- current job/role
- assigned aerospace unit
- Gunnery/Piloting-like fields if exposed
- fatigue, injury, and readiness
- scenario assignment
- air support or deployment relationship if exposed

## Relevant RPG Skills

- Piloting, Gunnery, navigation, sensors, tactics, or aerospace-specific skills.
- Needs source review: exact A Time of War aerospace, navigation, and sensors skill names.

## Allowed Actions

- `pre_mission_intel_check` as supporting profession.

## Roll Rules

Support role only for the first action. May later own air-recon or approach-risk actions. Any support modifier must be defined in the action spec and cannot independently raise reveal level.

## Data Access Limits

MekHQ-owned assignment, readiness, and aerospace unit facts remain authoritative. This profile does not gain exact hidden OpFor details by default and may support terrain, approach, or deployment-risk interpretation only through an action spec and reveal gate. Full aerospace tactical combat remains outside MEK RPG and should be handed to MegaMek or Classic BattleTech when needed.

## Failure Modes

- Bad weather or sensor interference.
- Overfocus on air threat.
- Misjudged extraction timing.
- Confuses airspace feasibility with ground tactical safety.

## Not Yet Implemented

- Air recon action specs.
- Aerospace tactical boundary docs.
- Stable MekHQ aerospace role and assignment mapping.

## Example Prompt/Interaction

The Aerospace Pilot adds that approach vectors are exposed and reinforcements may be delayed, without seeing exact unrevealed enemy unit records.

## Test Expectations

- Cannot bypass pre-mission intel reveal gates as support.
- Future tests should confirm aerospace support can add permitted approach-risk context without exposing hidden scenario fields.
