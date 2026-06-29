# Doctor

## Status

- Profession id: `doctor`.
- Status: Planned stub.

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
