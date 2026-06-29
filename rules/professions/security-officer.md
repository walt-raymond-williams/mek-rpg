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
mekhq_owned_fields:
  - current job/role
  - assignment
  - security duty if exposed
  - unit location and deployment posture
  - personnel availability
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

Handles internal security, perimeter risk, prisoner handling, counterintelligence posture, and force-protection concerns.

## Typical Capabilities

- Base security review.
- Ambush and sabotage risk posture.
- Personnel threat screening when supported by data.
- Security scene framing.

## Relevant MekHQ Fields

- current job/role
- assignment
- security duty if exposed
- unit location and deployment posture
- personnel availability

## Relevant RPG Skills

- Security, investigation, small arms, tactics, perception, interrogation, or leadership skills.

## Allowed Actions

- No first-milestone owning actions.

## Roll Rules

Not defined yet.

## Data Access Limits

MekHQ-owned personnel, location, assignment, and deployment posture facts remain authoritative. This profile does not access hidden scenario data by default, and future counterintelligence actions must define exactly which hidden facts can be surfaced through a reveal gate.

## Failure Modes

- False sense of security.
- Overreaction to weak signals.
- Missed insider threat.

## Not Yet Implemented

- Security audit action specs.
- Counterintelligence reveal gates.

## Example Prompt/Interaction

The Security Officer reviews whether the unit's camp or DropShip berth is exposed to sabotage.

## Test Expectations

- Future tests should prevent security narration from inventing confirmed threats without evidence.
