# Profession Prompt Context Assembly

Status: issue `#136` design. Runtime prompt assembly is not implemented.

Parent epic: `#127` Profession Capability System.

Related files:

- `docs/current/PROFESSION_HIDDEN_DATA_BOUNDARIES.md`
- `docs/current/PROFESSION_GATED_REVEAL_TEST_PLAN.md`
- `docs/current/PROFESSION_DICE_REVEAL_DESIGN.md`
- `docs/current/PRE_MISSION_INTEL_CHECK.md`
- `rules/actions/pre-mission-intel-check.md`

## Purpose

Define how action permission and reveal outputs become safe LLM prompt context for in-universe profession reports.

The LLM can write voice, emphasis, and table-facing presentation. It must not decide action permission, reveal level, hidden-data filtering, or whether raw MekHQ/MegaMek scenario facts are player-known.

## Required Inputs

Prompt assembly may consume only structured, filtered inputs:

- action id and display name;
- action status and prompt policy;
- lead profession id and display name;
- accepted support profession ids and allowed support context;
- final reveal level and reveal map id;
- allowed categories;
- public briefing facts;
- filtered hidden or derived facts permitted by final reveal level;
- uncertainty/confidence labels;
- failure mode, if any;
- forbidden-output rules derived from reveal level;
- tone/profile instructions that do not add facts.

Prompt assembly must not consume:

- raw adapter payloads;
- raw hidden scenario JSON;
- full unit sheets;
- hidden fields above final reveal level;
- internal debug traces;
- ignored local source paths;
- real MekHQ save/XML paths;
- protected source text.

## Prompt Layers

Assemble prompts from these layers in order:

1. `system_boundary`: states that the LLM receives filtered data only and must not invent hidden facts.
2. `action_context`: action id, phase, owner/support roles, and report purpose.
3. `reveal_context`: final reveal level, allowed categories, confidence/caps, and forbidden categories.
4. `filtered_facts`: public and permitted derived/hidden facts only.
5. `style_context`: in-universe voice, brevity, and uncertainty guidance.
6. `output_contract`: expected report shape and no-debug/no-raw-data rules.

No layer may include a raw hidden payload for "reference."

## Prompt Payload Sketch

```json
{
  "schema_version": "mek-rpg-profession-prompt-context/v1",
  "action_id": "pre_mission_intel_check",
  "display_name": "Pre-Mission Intel Check",
  "lead_profession": {
    "profession_id": "intelligence_officer",
    "display_name": "Intelligence Officer"
  },
  "support_professions": [
    {
      "profession_id": "mechwarrior",
      "display_name": "MechWarrior",
      "permitted_context": ["assigned force feasibility"]
    }
  ],
  "reveal": {
    "final_level": 3,
    "reveal_map_id": "pre_mission_intel_margin_v1",
    "allowed_categories": [
      "public_briefing",
      "enemy_count_estimate",
      "weight_class_estimate",
      "bv_strength_band"
    ],
    "forbidden_categories": [
      "exact_bv",
      "exact_units",
      "pilot_skill_values",
      "hidden_scenario_flags",
      "raw_scenario_json"
    ],
    "caps": []
  },
  "filtered_facts": {
    "public_briefing": {
      "scenario_name": "Fixture Ridge Patrol",
      "terrain_summary": "Broken hills"
    },
    "derived": {
      "enemy_count_estimate": "reinforced lance-sized contact",
      "bv_strength_band": "materially stronger than assigned force"
    }
  },
  "uncertainty": {
    "confidence": "medium",
    "required_language": ["estimate", "appears", "not confirmed"]
  },
  "output_rules": {
    "voice": "in-universe intelligence briefing",
    "forbid_raw_json": true,
    "forbid_debug_fields": true,
    "forbid_unlisted_hidden_facts": true
  }
}
```

## In-Universe Report Rules

Reports should:

- speak as a briefing, warning, or staff assessment;
- preserve uncertainty when facts are estimates;
- recommend options only when supported by permitted facts;
- distinguish known, estimated, missing, and unreliable information;
- avoid raw field names such as `opfor_total_bv` unless the output contract explicitly asks for diagnostic text.

Reports must not:

- reveal forbidden categories;
- mention that hidden data exists above the reveal level;
- expose raw JSON keys, internal IDs, fixture sentinel names, or debug traces;
- imply exact certainty from rounded or banded facts;
- fabricate units, pilots, objectives, or traps.

## Confidence Language

Use deterministic labels supplied by the reveal/filter helper:

- `confirmed`: permitted exact field from a reviewed fixture/source.
- `estimated`: derived band or approximation.
- `missing`: field absent; do not infer.
- `unstable`: field exists but lacks fixture/API confidence.
- `blocked`: action denied or filter failed.

The LLM may vary prose, but it must preserve these labels' meaning.

## Denied And Failure Prompts

Denied action requests should not create an intel report. They may create a short refusal or public-only note:

- `owner_required`: "No qualified intelligence lead is available for a gated intel check."
- `support_only`: "This character can advise a qualified lead but cannot run the check."
- `action_not_implemented`: "This action is designed but not executable yet."
- `invalid_input`: "The check cannot resolve because required inputs are missing."

Denied prompts must not include hidden facts or hint at hidden truth.

## Test Expectations

Future tests should inspect structured prompt payloads before generated prose:

- prompt payload has no raw payload object;
- prompt payload has no hidden sentinels above final reveal level;
- `forbidden_categories` is present and matches the reveal level;
- `filtered_facts` includes only allowed categories;
- denied actions produce no intel prompt payload with hidden data;
- debug traces are absent or redacted;
- final report text contains no forbidden sentinels.

The first automated prompt tests should use fixed report text or deterministic prompt payload inspection before relying on variable LLM prose.

## Implementation Notes

Prompt assembly should be a pure transformation from filtered reveal result to safe prompt payload. It should not read files, call live MekHQ, roll dice, resolve permissions, or inspect raw hidden data. If it needs a fact that is not present in `filtered_facts`, it must report a missing input instead of reaching around the filter.
