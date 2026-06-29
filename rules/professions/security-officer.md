---
schema_version: profession-profile/v1
profession_id: security_officer
display_name: Security Officer
status: not_implemented
aliases:
  - security officer
  - security
  - force protection
  - provost
  - counterintelligence
  - guard commander
  - Needs API review: exact MekHQ security or force-protection role labels
mekhq_owned_fields:
  - current job/role
  - assignment
  - security duty if exposed
  - unit location and deployment posture
  - personnel availability
  - prisoner, dependent, or facility security fields if exposed
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

# Security Officer

## Status

- Profession id: `security_officer`.
- Status: `not_implemented`.
- Schema: `profession-profile/v1`.

## Purpose

Handles internal security, perimeter risk, prisoner handling, counterintelligence posture, and force-protection concerns. MekHQ remains authoritative for personnel, assignments, locations, deployment posture, and any exposed security duty state.

## Typical Capabilities

- Base security review.
- Ambush and sabotage risk posture.
- Personnel threat screening when supported by data.
- Security scene framing.
- Advice about whether a public situation looks like a sabotage, ambush, or insider-risk problem.

## Relevant MekHQ Fields

- current job/role
- assignment
- security duty if exposed
- unit location and deployment posture
- personnel availability
- prisoner, dependent, or facility security fields if exposed

## Relevant RPG Skills

- Security, investigation, small arms, tactics, perception, interrogation, or leadership skills.
- Needs source review: exact A Time of War security, investigation, and perception skill names.

## Allowed Actions

- No first-milestone owning actions.

## Roll Rules

Not defined yet. Future security actions must define evidence sources, hidden-data categories, false-positive handling, and whether the output is an advisory, a scene prompt, or a guarded command proposal.

## Data Access Limits

MekHQ-owned personnel, location, assignment, and deployment posture facts remain authoritative. This profile does not access hidden scenario data by default, and future counterintelligence actions must define exactly which hidden facts can be surfaced through a reveal gate. It must not invent confirmed traitors, sabotage, or enemy plans from weak or missing data.

## Failure Modes

- False sense of security.
- Overreaction to weak signals.
- Missed insider threat.
- Confuses a possible risk with confirmed hostile action.

## Not Yet Implemented

- Security audit action specs.
- Counterintelligence reveal gates.
- Stable MekHQ security alias and duty-field mapping.

## Example Prompt/Interaction

The Security Officer reviews whether the unit's camp or DropShip berth is exposed to sabotage, flagging risk and uncertainty instead of asserting hidden facts without evidence.

## Test Expectations

- Future tests should prevent security narration from inventing confirmed threats without evidence.
- Future tests should confirm hidden-data claims require an explicit action spec and reveal gate.
