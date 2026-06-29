---
schema_version: profession-profile/v1
profession_id: doctor
display_name: Doctor
status: not_implemented
aliases:
  - doctor
  - medic
  - surgeon
  - medical officer
  - field medic
mekhq_owned_fields:
  - current job/role
  - medical assignment
  - patient injury state
  - fatigue and recovery state
  - availability
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
allowed_actions: []
---

# Doctor

## Status

- Profession id: `doctor`.
- Status: `not_implemented`.
- Schema: `profession-profile/v1`.

## Purpose

Handles medical evaluation, treatment feasibility, recovery advice, triage, and medical risk while MekHQ remains authoritative for actual injuries and recovery state.

## Typical Capabilities

- Injury interpretation.
- Recovery and readiness advice.
- Triage under mission pressure.
- Medical scene support.

## Relevant MekHQ Fields

- current job/role
- medical assignment
- patient injury state
- fatigue and recovery state
- availability

## Relevant RPG Skills

- Medicine, surgery, first aid, science, or related skills when summarized.

## Allowed Actions

- No first-milestone owning actions.

## Roll Rules

Not defined yet.

## Data Access Limits

May use MekHQ injury and readiness fields through future medical action specs. Does not replace MekHQ injury records.

## Failure Modes

- Incomplete diagnosis.
- Stabilized but not mission-ready patient.
- Treatment requires unavailable facility or supplies.

## Not Yet Implemented

- Medical action specs.
- Recovery advice reveal gates.
- MekHQ medical API field mapping.

## Example Prompt/Interaction

The Doctor advises whether an injured pilot can safely deploy, with MekHQ injury state treated as authoritative.

## Test Expectations

- Future tests should prove medical narration does not overwrite MekHQ injuries.
