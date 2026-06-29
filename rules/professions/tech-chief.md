---
schema_version: profession-profile/v1
profession_id: tech_chief
display_name: Tech Chief / Mechanic
status: not_implemented
aliases:
  - tech chief
  - mechanic
  - technician
  - astech
  - chief technician
mekhq_owned_fields:
  - current job/role
  - technician assignment
  - repair queue or maintenance fields when exposed
  - unit condition
  - fatigue, injuries, and availability
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

# Tech Chief / Mechanic

## Status

- Profession id: `tech_chief`.
- Status: `not_implemented`.
- Schema: `profession-profile/v1`.

## Purpose

Handles repair, maintenance, readiness, salvage practicality, and technical risk using MekHQ-owned unit and personnel state.

## Typical Capabilities

- Repair feasibility and downtime estimates.
- Salvage triage.
- Maintenance readiness warnings.
- Technical explanation for equipment failures or field modifications.

## Relevant MekHQ Fields

- current job/role
- technician assignment
- repair queue or maintenance fields when exposed
- unit condition
- fatigue, injuries, and availability

## Relevant RPG Skills

- Technician, mechanic, electronics, engineering, or similar skills when summarized.

## Allowed Actions

- No first-milestone owning actions.

## Roll Rules

Not defined yet.

## Data Access Limits

Should access MekHQ-owned maintenance and unit condition data only through future action specs. Does not access hidden OpFor data by default.

## Failure Modes

- Underestimated repair time.
- Hidden parts shortage.
- Misdiagnosed field damage.

## Not Yet Implemented

- Maintenance action specs.
- Repair/readiness prompt assembly.
- MekHQ repair queue field mapping.

## Example Prompt/Interaction

The Tech Chief estimates whether a damaged unit can be patched before deployment, using MekHQ as the hard state authority.

## Test Expectations

- Future tests should prove repair advice does not mutate MekHQ state unless a guarded MekHQ command exists.
