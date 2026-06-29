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
  - tech
  - Needs API review: exact MekHQ technician, mechanic, astech, and chief-tech role labels
mekhq_owned_fields:
  - current job/role
  - technician assignment
  - repair queue or maintenance fields when exposed
  - unit condition
  - fatigue, injuries, and availability
  - spare parts and maintenance task state if exposed
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

Handles repair, maintenance, readiness, salvage practicality, and technical risk using MekHQ-owned unit and personnel state. This profile is an advisory MEK RPG overlay; MekHQ remains authoritative for actual repairs, assignments, parts, units, fatigue, injuries, and availability.

## Typical Capabilities

- Repair feasibility and downtime estimates.
- Salvage triage.
- Maintenance readiness warnings.
- Technical explanation for equipment failures or field modifications.
- Advice on whether a mission plan is realistic given known damage, parts, and time.

## Relevant MekHQ Fields

- current job/role
- technician assignment
- repair queue or maintenance fields when exposed
- unit condition
- fatigue, injuries, and availability
- spare parts and maintenance task state if exposed

## Relevant RPG Skills

- Technician, mechanic, electronics, engineering, or similar skills when summarized.
- Needs source review: exact A Time of War technician, electronics, and engineering skill names.

## Allowed Actions

- No first-milestone owning actions.

## Roll Rules

Not defined yet. Future maintenance actions must define difficulty, time pressure, parts availability, support behavior, and whether the result is advice, a proposed MekHQ command, or a scene-level outcome.

## Data Access Limits

Should access MekHQ-owned maintenance and unit condition data only through future action specs. Does not access hidden OpFor data by default. Repair narration must not mark units fixed, consume parts, or alter MekHQ queues unless a guarded MekHQ command path exists and is explicitly invoked.

## Failure Modes

- Underestimated repair time.
- Hidden parts shortage.
- Misdiagnosed field damage.
- Advice becomes stale after MekHQ maintenance state changes.

## Not Yet Implemented

- Maintenance action specs.
- Repair/readiness prompt assembly.
- MekHQ repair queue field mapping.
- Guarded-command boundary for any future repair mutation.

## Example Prompt/Interaction

The Tech Chief estimates whether a damaged unit can be patched before deployment, using MekHQ as the hard state authority and phrasing results as advice unless a future action has a supported command.

## Test Expectations

- Future tests should prove repair advice does not mutate MekHQ state unless a guarded MekHQ command exists.
- Future lookup tests should separate technician, astech, mechanic, and chief-tech aliases once MekHQ API evidence exists.
