---
schema_version: profession-action/v1
action_id: pre_mission_intel_check
display_name: Pre-Mission Intel Check
status: planned
phase: pre_battle
owning_professions:
  - intelligence_officer
  - scout_recon_specialist
supporting_professions:
  - aerospace_pilot
  - administrator_liaison
  - mechwarrior
input_data:
  public:
    - scenario_name
    - scenario_type
    - terrain_summary
    - weather
    - public_objectives
  mekhq_owned:
    - personnel_identity
    - personnel_role
    - personnel_assignment
    - personnel_readiness
    - scenario_metadata
  hidden:
    - opfor_total_bv
    - opfor_unit_count
    - opfor_weight_classes
    - opfor_chassis
    - opfor_pilot_skills
    - special_scenario_flags
  derived:
    - enemy_count_estimate
    - weight_class_estimate
    - bv_strength_band
    - pilot_quality_band
    - special_warning_summary
roll_required: true
roll_policy: margin_2d6_target_number_v1
reveal_map_id: pre_mission_intel_margin_v1
reveal_levels:
  - public_briefing_only
  - enemy_count_estimate
  - weight_class_estimate
  - bv_range_or_relative_strength
  - pilot_quality_band
  - exact_total_bv_and_likely_chassis
  - exact_units_and_pilot_skills
  - hidden_objectives_deployment_or_special_warnings
prompt_policy: reveal_filtered_in_universe_report
failure_modes:
  - no_useful_intel
  - vague_report
  - stale_information
  - misleading_confidence
test_expectations:
  - reject_unqualified_professions
  - reject_support_only_actor_as_owner
  - deny_hidden_data_before_permission
  - filter_exact_bv_below_level_5
  - filter_pilot_skills_below_level_6
  - filter_special_flags_below_level_7
---

# Pre-Mission Intel Check

## Status

- Action id: `pre_mission_intel_check`.
- Phase: `pre_battle`.
- Status: Planned design metadata; runtime execution is not implemented.
- Parent design: `docs/current/PRE_MISSION_INTEL_CHECK.md`.
- Registry design: `docs/current/PROFESSION_ACTION_REGISTRY_DESIGN.md`.
- Dice/reveal design: `docs/current/PROFESSION_DICE_REVEAL_DESIGN.md`.
- Hidden-data boundary: `docs/current/PROFESSION_HIDDEN_DATA_BOUNDARIES.md`.
- Prompt/context assembly: `docs/current/PROFESSION_PROMPT_CONTEXT_ASSEMBLY.md`.

## Owning Professions

- `intelligence_officer`
- `scout_recon_specialist`

## Supporting Professions

- `aerospace_pilot`
- `administrator_liaison`
- `mechwarrior`

## Purpose

Allow a qualified character to analyze a generated MekHQ scenario before tactical launch and produce an in-universe intelligence report. Hidden scenario data must be filtered through reveal levels before it reaches player-facing prose.

The action should warn commanders about threat size, quality, unusual danger, and go/no-go risk without exposing raw scenario JSON, exact unit records, or pilot skills below the required reveal level.

## Input Data

Public:

- scenario name
- scenario type
- terrain summary
- weather
- public objectives

Hidden:

- OpFor total BV
- OpFor unit count
- OpFor weight classes
- OpFor chassis
- OpFor pilot skills
- special scenario flags

## Roll Required

Yes. The provisional policy is `margin_2d6_target_number_v1`: roll `2d6`, add explicit modifiers, compare final total to an explicit target number, and map margin to reveal level using `pre_mission_intel_margin_v1`. The final implementation may keep this configurable, but the LLM must not choose reveal level.

## Reveal Levels

0. Public briefing only.
1. Enemy count estimate.
2. Weight-class estimate.
3. Enemy BV range or relative strength band.
4. Pilot quality band or elite-opposition warning.
5. Exact enemy total BV and likely chassis.
6. Exact enemy units and pilot skills.
7. Hidden objectives, deployment warnings, and special scenario warnings.

## Data Access Limits

- The LLM must not receive raw hidden scenario data above the resolved reveal level.
- Exact unit sheets and pilot skills require level 6.
- Hidden scenario warnings require level 7.
- Support professions can add context or modifiers only if the future roll design permits it.
- Denied, support-only, not-implemented, ambiguous, unmapped, or unavailable actor requests must not load hidden scenario data.

## Failure Modes

- No useful intel.
- Vague report.
- Stale information.
- Misleading confidence.

## Test Expectations

- Verify action metadata cross-checks owning and supporting professions against profession profile `allowed_actions`.
- Verify denied, support-only, or not-implemented requests do not load hidden scenario data.
- Verify prompt context, not only final prose, excludes unrevealed hidden fields.
- Verify reveal-level filtering with sanitized scenario fixtures.
- Verify no exact BV appears below level 5.
- Verify no exact pilot skill values appear below level 6.
- Verify special hidden scenario flags do not appear below level 7.
- Verify unqualified professions are rejected.
