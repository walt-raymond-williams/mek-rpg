# DropShip / Transport Crew

## Status

- Profession id: `dropship_transport_crew`.
- Status: Planned stub.

## Purpose

Handles transport operations, embarkation, cargo movement, deployment timing, extraction feasibility, and shipboard scene support.

## Typical Capabilities

- Drop and extraction feasibility.
- Cargo and passenger movement planning.
- Transport readiness context.
- Shipboard risk assessment.

## Relevant MekHQ Fields

- current job/role
- transport assignment
- ship or transport asset if exposed
- fatigue, injury, and readiness
- deployment relationship

## Relevant RPG Skills

- Piloting, navigation, technician, administration, logistics, or shipboard operations skills.

## Allowed Actions

- No first-milestone owning actions.

## Roll Rules

Not defined yet.

## Data Access Limits

May use transport and deployment data through future action specs. Does not expose hidden OpFor data by default.

## Failure Modes

- Extraction window misjudged.
- Cargo or passenger bottleneck.
- Transport readiness assumed from incomplete data.

## Not Yet Implemented

- Transport readiness action specs.
- Deployment/extraction risk reveal gates.
- MekHQ transport field mapping.

## Example Prompt/Interaction

The transport crew estimates whether the unit can withdraw quickly if the mission turns bad.

## Test Expectations

- Future tests should keep transport advice separate from MekHQ-owned assignment and transport state.
