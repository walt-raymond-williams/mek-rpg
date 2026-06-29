---
schema_version: profession-profile/v1
profession_id: intelligence_officer
display_name: Intelligence Officer
status: not_implemented
aliases:
  - intelligence officer
  - intelligence
  - intel officer
  - analyst
  - intelligence analyst
  - S2
  - Needs API review: stable MekHQ intelligence staff job names
mekhq_owned_fields:
  - personnel id/name
  - current job/role
  - assignment
  - rank/title if exposed
  - fatigue/injury/readiness constraints
  - scenario assignment or command relationship
  - scenario public briefing fields if exposed
  - hidden scenario fields only as adjudication input
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
  - pre_mission_intel_check: owning
---

# Intelligence Officer

## Status

- Profession id: `intelligence_officer`.
- Status: `not_implemented`.
- Schema: `profession-profile/v1`.

## Purpose

Turns reports, scenario metadata, reconnaissance, signals, and command context into actionable but uncertainty-aware briefings. This profile is a MEK RPG overlay for deciding whether an intelligence-focused character can attempt an action; MekHQ remains authoritative for the character's job, assignment, readiness, and scenario state.

## Typical Capabilities

- Pre-mission threat assessment.
- Enemy strength and quality estimation.
- Hidden objective or ambush risk warning when the action and roll permit it.
- Briefing translation from raw MekHQ/scenario data into in-universe advice.
- Confidence framing: what is known, estimated, stale, or unsupported.

## Relevant MekHQ Fields

- personnel id/name
- current job/role
- assignment
- rank/title if exposed
- fatigue/injury/readiness constraints
- scenario assignment or command relationship
- scenario public briefing fields if exposed
- hidden scenario fields only as adjudication input, not player-facing context

## Relevant RPG Skills

- Intelligence analysis or equivalent if summarized later.
- Tactics or strategy-adjacent skills when available.
- Communications, administration, or research support where appropriate.
- Needs source review: exact A Time of War skill names and modifiers.

## Allowed Actions

- `pre_mission_intel_check` as owning profession.

## Roll Rules

Use the action's configured roll gate. This profile should usually be the best fit for intelligence reveal checks, but it must not define target numbers or reveal thresholds locally; those belong to the action spec and later dice/reveal design.

## Data Access Limits

MekHQ-owned personnel and scenario facts remain authoritative. This profile may access hidden scenario intelligence only through action reveal levels, and raw hidden data must not be exposed directly to the player. Below the relevant reveal level, use broad warnings such as relative strength, quality band, or uncertainty language instead of exact BV, unit lists, pilot numbers, or hidden scenario flags.

## Failure Modes

- Overconfident wrong read.
- Stale report.
- Understated elite threat.
- Vague warning without actionable detail.
- Correct facts framed with misleading certainty.

## Not Yet Implemented

- Stable MekHQ job alias mapping.
- Deterministic roll modifiers.
- Prompt assembly tests.
- Exact hidden-field filtering rules for each reveal level.

## Example Prompt/Interaction

The GM asks the Intelligence Officer to brief a pending scenario. The system rolls, filters hidden facts by reveal level, then outputs an in-universe warning such as "enemy quality appears unusually high" without raw debug data, exact pilot skills, or hidden flags unless the action permits them.

## Test Expectations

- Can own `pre_mission_intel_check`.
- Cannot reveal exact units or pilot skills unless the action resolves to the required reveal level.
- Unknown or unsupported MekHQ job strings should produce an unmapped/needs-review result in future lookup tests rather than silently granting this profile.
