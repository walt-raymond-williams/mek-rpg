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
mekhq_owned_fields:
  - current job/role
  - assigned aerospace unit
  - Gunnery/Piloting-like fields if exposed
  - fatigue, injury, and readiness
  - scenario assignment
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

Handles aerospace operations, approach risk, airspace context, transport escort concerns, and air mission support.

## Typical Capabilities

- Airspace and approach assessment.
- Support to pre-mission intelligence where aerial observation is relevant.
- Tactical handoff context for aerospace combat.
- Evacuation or reinforcement feasibility comments.

## Relevant MekHQ Fields

- current job/role
- assigned aerospace unit
- Gunnery/Piloting-like fields if exposed
- fatigue, injury, and readiness
- scenario assignment

## Relevant RPG Skills

- Piloting, Gunnery, navigation, sensors, tactics, or aerospace-specific skills.

## Allowed Actions

- `pre_mission_intel_check` as supporting profession.

## Roll Rules

Support role only for the first action. May later own air-recon or approach-risk actions.

## Data Access Limits

MekHQ-owned assignment, readiness, and aerospace unit facts remain authoritative. This profile does not gain exact hidden OpFor details by default and may support terrain, approach, or deployment-risk interpretation only through an action spec and reveal gate.

## Failure Modes

- Bad weather or sensor interference.
- Overfocus on air threat.
- Misjudged extraction timing.

## Not Yet Implemented

- Air recon action specs.
- Aerospace tactical boundary docs.

## Example Prompt/Interaction

The Aerospace Pilot adds that approach vectors are exposed and reinforcements may be delayed.

## Test Expectations

- Cannot bypass pre-mission intel reveal gates as support.
