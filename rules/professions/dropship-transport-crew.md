---
schema_version: profession-profile/v1
profession_id: dropship_transport_crew
display_name: DropShip / Transport Crew
status: not_implemented
aliases:
  - dropship crew
  - transport crew
  - dropship pilot
  - transport pilot
  - ship crew
  - dropship captain
  - Needs API review: exact MekHQ DropShip, naval, vessel, and transport crew role labels
mekhq_owned_fields:
  - current job/role
  - transport assignment
  - ship or transport asset if exposed
  - fatigue, injury, and readiness
  - deployment relationship
  - cargo/passenger capacity or transport status if exposed
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

# DropShip / Transport Crew

## Status

- Profession id: `dropship_transport_crew`.
- Status: `not_implemented`.
- Schema: `profession-profile/v1`.

## Purpose

Handles transport operations, embarkation, cargo movement, deployment timing, extraction feasibility, and shipboard scene support. MekHQ remains authoritative for transport assignments, ship or transport assets, readiness, deployment relationships, cargo, and passenger state.

## Typical Capabilities

- Drop and extraction feasibility.
- Cargo and passenger movement planning.
- Transport readiness context.
- Shipboard risk assessment.
- Advice about whether a withdrawal, reinforcement, or relocation plan is plausible.

## Relevant MekHQ Fields

- current job/role
- transport assignment
- ship or transport asset if exposed
- fatigue, injury, and readiness
- deployment relationship
- cargo/passenger capacity or transport status if exposed

## Relevant RPG Skills

- Piloting, navigation, technician, administration, logistics, or shipboard operations skills.
- Needs source review: exact A Time of War piloting, navigation, shipboard, and logistics skill names.

## Allowed Actions

- No first-milestone owning actions.

## Roll Rules

Not defined yet. Future transport actions must define time pressure, asset readiness, cargo constraints, and whether output is advice, a scene prompt, or a guarded MekHQ command proposal.

## Data Access Limits

May use transport and deployment data through future action specs. Does not expose hidden OpFor data by default. Transport narration must not move assets, load cargo, change assignments, or alter MekHQ state unless a guarded command path exists.

## Failure Modes

- Extraction window misjudged.
- Cargo or passenger bottleneck.
- Transport readiness assumed from incomplete data.
- Advice becomes stale after deployment, transport, cargo, or passenger state changes.

## Not Yet Implemented

- Transport readiness action specs.
- Deployment/extraction risk reveal gates.
- MekHQ transport field mapping.
- Guarded-command boundary for any future transport mutation.

## Example Prompt/Interaction

The transport crew estimates whether the unit can withdraw quickly if the mission turns bad, using MekHQ transport state as the authority and keeping the result advisory.

## Test Expectations

- Future tests should keep transport advice separate from MekHQ-owned assignment and transport state.
- Future lookup tests should distinguish pilot, crew, captain, vessel, and transport aliases once MekHQ API evidence exists.
