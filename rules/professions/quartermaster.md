---
schema_version: profession-profile/v1
profession_id: quartermaster
display_name: Quartermaster
status: not_implemented
aliases:
  - quartermaster
  - supply officer
  - logistics officer
  - procurement officer
  - stores officer
  - logistics
  - Needs API review: exact MekHQ logistics, warehouse, and procurement role labels
mekhq_owned_fields:
  - current job/role
  - warehouse/supply fields when exposed
  - unit ammo and equipment state
  - procurement queue
  - transport capacity if exposed
  - finance or purchasing constraints if exposed
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

# Quartermaster

## Status

- Profession id: `quartermaster`.
- Status: `not_implemented`.
- Schema: `profession-profile/v1`.

## Purpose

Handles supply, equipment availability, ammunition, transport loading, procurement, and mission logistics while MekHQ remains the hard logistics ledger for inventory, finance, procurement, transport capacity, and unit equipment state.

## Typical Capabilities

- Supply readiness review.
- Mission equipment feasibility.
- Procurement and scarcity advice.
- Load planning support.
- Warnings about ammunition, spare parts, delivery timing, and transport bottlenecks.

## Relevant MekHQ Fields

- current job/role
- warehouse/supply fields when exposed
- unit ammo and equipment state
- procurement queue
- transport capacity if exposed
- finance or purchasing constraints if exposed

## Relevant RPG Skills

- Administration, logistics, negotiation, technician-adjacent skills, or relevant equipment skills.
- Needs source review: exact A Time of War logistics, administration, and negotiation skill names.

## Allowed Actions

- No first-milestone owning actions.

## Roll Rules

Not defined yet. Future logistics actions must define whether the output is a readiness advisory, a purchase recommendation, a guarded MekHQ command proposal, or a scene prompt.

## Data Access Limits

May use MekHQ logistics data through future action specs. Does not mutate inventory or finance without guarded MekHQ command support. Hidden enemy or scenario data is outside this profile unless another action explicitly grants filtered context.

## Failure Modes

- Supply shortfall discovered late.
- Incorrect assumption about delivery timing.
- Hidden procurement or transport bottleneck.
- Advice becomes stale after a market, procurement, finance, or inventory update.

## Not Yet Implemented

- Logistics readiness action specs.
- MekHQ warehouse/procurement field mapping.
- Guarded-command boundary for future purchasing or inventory mutation.

## Example Prompt/Interaction

The Quartermaster checks whether the unit has enough ammunition and spare parts for an extended deployment, presenting advice without changing MekHQ inventory or finances.

## Test Expectations

- Future tests should separate advice from MekHQ ledger mutation.
- Future lookup tests should keep unknown logistics aliases marked `Needs API review` until MekHQ role evidence exists.
