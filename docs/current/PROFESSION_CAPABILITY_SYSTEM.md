# Profession Capability System

## Status

- Status: Planned epic scaffold.
- Epic issue: `#127`.
- First target action: Pre-Mission Intel Check.
- Authority boundary: MekHQ remains the source of truth for personnel, campaign, logistics, assignment, injury, history, job, fatigue, and scenario state.
- MEK RPG role: rules overlay, action gating, reveal gating, prompt assembly, and in-universe presentation.

This document defines the roadmap for using MekHQ personnel roles and jobs as RPG-capable professions without creating a separate authoritative character model.

## Core Idea

Professions define what characters can plausibly do, what data they can access, and what rolls they can trigger.

MekHQ may expose more campaign or scenario data than a character could know. MEK RPG must keep raw data access separate from character knowledge. A profession profile and action spec decide whether a character may attempt an action, which MekHQ fields matter, what roll is required, and what level of hidden information can be surfaced to the player.

## Conceptual Pipeline

```text
MekHQ campaign/personnel/scenario data
        |
MEK RPG data adapter
        |
character role/job/profession lookup
        |
profession profile
        |
allowed action
        |
dice roll / adjudication
        |
reveal level
        |
LLM-generated in-universe report
```

The adapter may hold exact facts such as OpFor BV, unit count, pilot quality, scenario flags, and hidden objectives. Player-facing output may only include the subset permitted by the profession, action, and roll result.

## Milestone 1 Scope

This first milestone is planning and scaffold only:

- Define the profession profile shape.
- Add initial stub profiles.
- Define the action registry concept.
- Define the Pre-Mission Intel Check action.
- Define reveal-level boundaries for hidden scenario information.
- Create GitHub issues for implementation slices.
- Create a handoff for future agents.
- Avoid runtime engine work unless a later issue chooses a narrow, deterministic slice.

## Non-Goals

- Do not replace MekHQ personnel sheets or campaign state.
- Do not infer RPG character facts that MekHQ owns, such as injuries, spouse, life history, generated history, current job, fatigue, assignment, or hard logistics.
- Do not expose hidden scenario data directly in LLM context visible to the player.
- Do not implement a broad runtime engine in this scaffold milestone.
- Do not copy copyrighted BattleTech or A Time of War text.

## Planned Components

### Profession Profiles

Location: `rules/professions/`

Profile format:

- Markdown file with YAML front matter.
- Schema version: `profession-profile/v1`.
- Template: `rules/professions/profile-template.md`.
- Validation: `scripts/validate-profession-profiles.ps1`.
- Status remains `not_implemented` until runtime lookup, action permission, roll behavior, and prompt assembly are implemented and tested.

Each profile includes:

- Purpose.
- Typical capabilities.
- Relevant MekHQ fields.
- Relevant RPG skills.
- Allowed actions.
- Roll rules.
- Data access limits.
- Failure modes.
- Not-yet-implemented items.
- Example prompts/interactions.
- Test expectations.

Profession profiles are MEK RPG rules overlays. They are not character sheets.

### Action Registry

Planned shape:

- `action_id`
- phase or timing
- owning professions
- supporting professions
- input data categories
- roll requirement
- reveal levels
- failure modes
- prompt/context assembly rules
- test expectations

Initial location: `rules/actions/`

A later implementation issue should decide whether a machine-readable YAML front matter block is enough, or whether a separate manifest should index actions and professions.

### Profession Lookup

Lookup should start from MekHQ personnel data:

- current job or role
- assignment
- rank or title if exposed
- skills and SPA-like tactical fields when available
- fatigue, injuries, or availability only as MekHQ-owned constraints

MEK RPG should map MekHQ job/role strings to a profession profile by deterministic aliases. If no match exists, the system should return `unmapped profession` and offer only public/common actions.

### Dice And Reveal Gates

The LLM may write the in-universe report, but it must not decide reveal level by improvisation. Reveal level must be determined by rules, dice, and action configuration before the LLM sees or summarizes hidden facts.

Provisional roll design:

- Recommended default: BattleTech-style target number, `2d6 >= target number`.
- Lower skill values are better when using MekHQ-style Gunnery/Piloting-like values.
- Margin of success determines reveal level.
- Alternative supported design: additive check, `2d6 + modifiers`, with thresholds determining reveal level.

Keep this configurable until core dice mechanics are finalized.

## Initial Profession Set

- Intelligence Officer.
- Scout / Recon Specialist.
- MechWarrior.
- Tech Chief / Mechanic.
- Doctor.
- Administrator / Liaison.
- Quartermaster.
- Security Officer.
- Aerospace Pilot.
- DropShip / Transport Crew.

## Hidden Data Policy

Hidden data may be read by a MEK RPG adapter only as protected adjudication input. It must not be placed directly into player-facing prompt context. Use this flow instead:

1. Load raw scenario/personnel data into an internal context object.
2. Resolve actor profession and permitted action.
3. Roll or adjudicate reveal level.
4. Filter raw data to the permitted reveal fields.
5. Pass only filtered facts plus tone instructions to the LLM.
6. Produce an in-universe report.

Tests for any runtime implementation must prove that exact hidden data is absent when the reveal level does not permit it.

## First Target Action

See `docs/current/PRE_MISSION_INTEL_CHECK.md` and `rules/actions/pre-mission-intel-check.md`.

The motivating case is a MekHQ-generated scenario where MEK RPG can read exact scenario data before MegaMek launches. A qualified Intelligence Officer or Scout/Recon Specialist should be able to warn the player that the opposition appears elite, oversized, or unusually dangerous without dumping exact unit sheets or pilot skills unless a high reveal level permits it.

## Roadmap

1. Create the profession profile schema/template. Status: complete in issue `#128`.
2. Add initial profession profile documents. Status: complete in issue `#129`.
3. Design deterministic profession lookup from MekHQ personnel fields.
4. Design the action registry and machine-readable action metadata.
5. Decide the first dice and reveal-level mapping.
6. Implement Pre-Mission Intel Check as a deterministic, testable slice.
7. Add hidden-data boundary tests.
8. Add LLM prompt/context assembly guidance and tests.
9. Validate against a sanitized MekHQ scenario fixture.
10. Expand profession actions only after the first action proves the pattern.

## GitHub Issue Plan

- Epic: `#127` Profession Capability System.
- `#128`: Add Profession Profile Schema/Template.
- `#129`: Add Initial Profession Profile Documents. Complete.
- `#130`: Add Profession Lookup Design.
- `#131`: Add Profession Action Registry Design.
- `#132`: Add Dice-Roll And Reveal-Level Design.
- `#133`: Add Pre-Mission Intel Check Design.
- `#134`: Define Hidden-Data Access Boundaries.
- `#135`: Add Tests/Spec Plan For Gated Data Reveal.
- `#136`: Add LLM Prompt/Context Assembly Design.
- `#137`: Add Handoff Documentation.
- `#138`: Update Roadmap.

## Open Questions

- Which MekHQ live API fields will reliably expose personnel job/role, assignment, and current scenario metadata?
- Resolved for issue `#128`: profession profiles use YAML front matter inside Markdown. A separate manifest may be added later only if lookup tooling needs it.
- Which core dice model should become canonical for non-combat RPG action checks?
- How should support roles contribute to a lead actor's roll: flat modifier, advantage-like reroll, separate support reveal, or narrative-only assistance?
- Which hidden scenario flags can be safely fixture-tested without tying MEK RPG to unstable MekHQ internals?
