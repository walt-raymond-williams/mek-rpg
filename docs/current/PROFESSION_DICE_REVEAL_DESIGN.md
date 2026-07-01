# Profession Dice And Reveal-Level Design

Status: issue `#132` design. Runtime reveal resolution is not implemented.

Parent epic: `#127` Profession Capability System.

Related files:

- `docs/current/PROFESSION_CAPABILITY_SYSTEM.md`
- `docs/current/PROFESSION_ACTION_REGISTRY_DESIGN.md`
- `docs/current/PRE_MISSION_INTEL_CHECK.md`
- `rules/actions/pre-mission-intel-check.md`
- `rules/core/basic-action-resolution.md`
- `docs/current/MECHANIC_CONTRACT_SCHEMA.md`

## Purpose

Define how profession actions turn a resolved roll into a deterministic reveal level before any LLM-generated report is assembled.

The LLM may phrase an in-universe report after filtering, but it must not choose the reveal level, inspect hidden facts to decide how much to reveal, or improvise extra permissions from prose.

## Recommended Provisional Model

Use a target-number check compatible with the existing core summaries and mechanic resolver prototypes:

```text
roll 2d6
final_total = dice_total + explicit_modifiers
success = final_total >= target_number
margin = final_total - target_number
```

Policy id: `margin_2d6_target_number_v1`.

Reasons for choosing this model:

- It matches the committed core action-resolution summaries: roll 2D6, add modifiers, compare to a target number, and interpret margin.
- It aligns with `scripts/resolve-basic-check.ps1`, which already reports `final_total`, `target_number`, `margin`, and degree labels.
- It can consume future character-sheet skill values and supplied modifiers without inventing a new dice system.
- It keeps reveal decisions deterministic and auditable.

The alternative additive threshold model, `2d6 + modifiers` against fixed reveal thresholds, is deferred. It may be useful for generic RPG overlays later, but it fits the existing core summaries and helper prototypes less directly.

## Required Inputs

A future reveal helper must receive explicit values:

- action id;
- action metadata and status;
- lead actor profession lookup result;
- accepted support actors, if any;
- target number and source;
- roll expression, mode, and values or RNG policy;
- modifier list with labels, values, and sources;
- reveal map id;
- public briefing facts;
- hidden adjudication facts only after permission is accepted.

The helper must not infer target numbers, actor skills, support bonuses, fatigue penalties, or equipment modifiers from prose or memory.

## Target Number Source

Target number selection remains provisional until richer character records and skill mappings exist.

Allowed target-number sources for the first implementation:

- `gm_supplied`: the GM or caller supplies a target number and records why.
- `fixture_supplied`: tests provide a fixed target number.
- `profile_action_default`: a later issue may add an action default after source and balance review.
- `character_sheet`: a later rich character-record issue may supply exact skill/attribute inputs.

If no target number is supplied by an approved source, the action must return `invalid_input` or `cannot_adjudicate` and reveal only public briefing facts.

## Modifier Policy

Modifiers must be explicit input records:

```json
{
  "label": "Scout support",
  "value": 1,
  "source": "accepted support actor",
  "authority": "action-config"
}
```

Permitted modifier sources:

- action configuration;
- GM-supplied table ruling;
- fixture-controlled test input;
- later character-record fields after schema support exists;
- MekHQ-owned readiness facts only as explicit penalties or warnings, never as profession proof.

Default support behavior for `pre_mission_intel_check`: support actors add no modifier unless the action configuration or GM explicitly supplies one. Support can contribute filtered context after the reveal level is resolved, but it cannot bypass the owning-profession requirement or independently raise reveal level.

## Natural Roll Handling

Use `rules/core/basic-action-resolution.md` as the source-aware procedure:

- Natural 2 remains failure even if modifiers would otherwise succeed.
- Natural 12 may trigger high-roll handling only if a future helper is given the resolved high-roll result or implements that specific core procedure with proper authority.

Until high-roll handling is implemented, a natural 12 should be recorded in the roll breakdown as a warning or unresolved enhancement, not as permission for the LLM to raise reveal level beyond the supplied final margin.

## Reveal Map

Reveal map id: `pre_mission_intel_margin_v1`.

This map is for `pre_mission_intel_check` only. Later actions may define their own maps.

| Roll outcome | Margin band | Reveal level | Meaning |
| --- | --- | --- | --- |
| Failure by 4+ | `margin <= -4` | 0 | Public briefing only, with stale or misleading-confidence risk if the GM wants a complication. |
| Failure by 1-3 | `-3 <= margin <= -1` | 0 | Public briefing only; no hidden facts. |
| Marginal success | `0 <= margin <= 1` | 1 | Enemy count estimate. |
| Solid success | `2 <= margin <= 3` | 2 | Weight-class or force-posture estimate. |
| Strong success | `4 <= margin <= 5` | 3 | Rounded BV band or relative strength. |
| Exceptional success | `6 <= margin <= 7` | 4 | Pilot quality band or elite-opposition warning. |
| Major success | `8 <= margin <= 9` | 5 | Exact enemy total BV and likely chassis, if those fields exist. |
| Extreme success | `margin >= 10` | 6 | Exact units and pilot skills, if those fields exist. |
| Extreme success with special-warning trigger | `margin >= 10` plus eligible hidden flags | 7 | Hidden objectives, deployment traps, or special scenario warnings. |

Level 7 is not a higher version of level 6. It grants special-warning categories when eligible hidden flags exist, but it does not automatically dump every exact unit detail unless level 6 is also granted by the map.

## Reveal Caps And Missing Inputs

Reveal level may be capped lower than the margin result:

- Missing hidden field: omit that category and report a gap.
- Unstable or unverified API field: cap to the highest level supported by fixture-reviewed data.
- Public-only action path: cap at level 0.
- Support-only actor as lead: deny action and cap at level 0.
- Planned or not-implemented action: deny execution and cap at level 0.
- Actor unavailable or lookup ambiguous: deny action and cap at level 0.
- Scenario timing mismatch: deny or cap according to action metadata.

Caps must be visible in output as warnings. The LLM should see only the capped filtered facts.

## Failure Modes

Failure must be deterministic and explicit:

- `no_useful_intel`: no hidden facts are revealed.
- `vague_report`: only public or very broad language is permitted.
- `stale_information`: the report may warn that data could be outdated.
- `misleading_confidence`: the GM may frame overconfidence as a complication, but must not reveal hidden truth through the failure text.
- `invalid_input`: missing target number, roll, permission, or metadata.
- `cannot_adjudicate`: route, authority, or field support is insufficient.

Failure text can add drama, cost, delay, or caution, but it cannot leak exact hidden data.

## Output Contract Sketch

A future helper should emit JSON-first results:

```json
{
  "schema_version": "mek-rpg-profession-reveal/v1",
  "action_id": "pre_mission_intel_check",
  "roll_policy": "margin_2d6_target_number_v1",
  "reveal_map_id": "pre_mission_intel_margin_v1",
  "status": "resolved",
  "roll_breakdown": {
    "expression": "2d6",
    "dice": [4, 5],
    "modifier_total": 1,
    "final_total": 10,
    "target_number": 7,
    "margin": 3
  },
  "reveal": {
    "raw_level": 2,
    "final_level": 2,
    "caps": [],
    "allowed_categories": [
      "public_briefing",
      "enemy_count_estimate",
      "weight_class_estimate"
    ]
  },
  "warnings": []
}
```

Denied or invalid requests should return no roll result and no hidden facts.

## Prompt Boundary

Prompt assembly receives only:

- action id and display name;
- final reveal level;
- allowed public and filtered hidden categories;
- failure mode or uncertainty language;
- support actor context already permitted by the final reveal level;
- forbidden-output rules for unrevealed categories.

Prompt assembly must not receive raw OpFor unit sheets, exact pilot skills, exact BV, hidden flags, or full scenario payloads unless the final reveal level permits those categories.

## Future Tests

Future tests should cover:

- missing target number returns invalid input and reveals no hidden data;
- support-only lead actor is denied before hidden data access;
- failure by 1 and failure by 4 both produce level 0 with different failure labels;
- margins 0, 2, 4, 6, 8, and 10 map to levels 1, 2, 3, 4, 5, and 6;
- level 7 requires both extreme success and eligible special-warning fields;
- missing hidden fields cap output without inventing facts;
- natural 2 forces failure;
- natural 12 is reported but does not auto-raise reveal without implemented high-roll handling;
- prompt context excludes categories above `final_level`.
