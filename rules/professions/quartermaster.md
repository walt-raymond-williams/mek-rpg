# Quartermaster

## Status

- Profession id: `quartermaster`.
- Status: Planned stub.

## Purpose

Handles supply, equipment availability, ammunition, transport loading, procurement, and mission logistics while MekHQ remains the hard logistics ledger.

## Typical Capabilities

- Supply readiness review.
- Mission equipment feasibility.
- Procurement and scarcity advice.
- Load planning support.

## Relevant MekHQ Fields

- current job/role
- warehouse/supply fields when exposed
- unit ammo and equipment state
- procurement queue
- transport capacity if exposed

## Relevant RPG Skills

- Administration, logistics, negotiation, technician-adjacent skills, or relevant equipment skills.

## Allowed Actions

- No first-milestone owning actions.

## Roll Rules

Not defined yet.

## Data Access Limits

May use MekHQ logistics data through future action specs. Does not mutate inventory or finance without guarded MekHQ command support.

## Failure Modes

- Supply shortfall discovered late.
- Incorrect assumption about delivery timing.
- Hidden procurement or transport bottleneck.

## Not Yet Implemented

- Logistics readiness action specs.
- MekHQ warehouse/procurement field mapping.

## Example Prompt/Interaction

The Quartermaster checks whether the unit has enough ammunition and spare parts for an extended deployment.

## Test Expectations

- Future tests should separate advice from MekHQ ledger mutation.
