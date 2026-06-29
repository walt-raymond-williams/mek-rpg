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
  - physician
  - Needs API review: exact MekHQ doctor, medic, and medical staff role labels
mekhq_owned_fields:
  - current job/role
  - medical assignment
  - patient injury state
  - fatigue and recovery state
  - availability
  - medical facility or care capacity if exposed
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

Handles medical evaluation, treatment feasibility, recovery advice, triage, and medical risk while MekHQ remains authoritative for actual injuries, recovery state, medical assignment, fatigue, and availability.

## Typical Capabilities

- Injury interpretation.
- Recovery and readiness advice.
- Triage under mission pressure.
- Medical scene support.
- Risk framing for deployment, evacuation, or delayed care.

## Relevant MekHQ Fields

- current job/role
- medical assignment
- patient injury state
- fatigue and recovery state
- availability
- medical facility or care capacity if exposed

## Relevant RPG Skills

- Medicine, surgery, first aid, science, or related skills when summarized.
- Needs source review: exact A Time of War medical, surgery, and first-aid skill names.

## Allowed Actions

- No first-milestone owning actions.

## Roll Rules

Not defined yet. Future medical actions must define whether a result is diagnosis, treatment advice, scene triage, or a guarded MekHQ medical command.

## Data Access Limits

May use MekHQ injury and readiness fields through future medical action specs. Does not replace MekHQ injury records. Player-facing advice may summarize readiness risk, but it must not clear wounds, change recovery timers, or invent medical facility capacity.

## Failure Modes

- Incomplete diagnosis.
- Stabilized but not mission-ready patient.
- Treatment requires unavailable facility or supplies.
- Advice becomes stale after MekHQ recovery or injury state changes.

## Not Yet Implemented

- Medical action specs.
- Recovery advice reveal gates.
- MekHQ medical API field mapping.
- Guarded-command boundary for any future treatment mutation.

## Example Prompt/Interaction

The Doctor advises whether an injured pilot can safely deploy, with MekHQ injury state treated as authoritative and the output framed as medical risk rather than a ledger update.

## Test Expectations

- Future tests should prove medical narration does not overwrite MekHQ injuries.
- Future lookup tests should distinguish doctor, medic, and surgeon aliases once MekHQ API evidence exists.
