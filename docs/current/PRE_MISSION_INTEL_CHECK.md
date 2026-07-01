# Pre-Mission Intel Check

## Status

- Status: Planned first action for the Profession Capability System.
- Parent design: `docs/current/PROFESSION_CAPABILITY_SYSTEM.md`.
- Action spec: `rules/actions/pre-mission-intel-check.md`.
- Registry design: `docs/current/PROFESSION_ACTION_REGISTRY_DESIGN.md`.
- Dice/reveal design: `docs/current/PROFESSION_DICE_REVEAL_DESIGN.md`.
- Hidden-data boundary: `docs/current/PROFESSION_HIDDEN_DATA_BOUNDARIES.md`.
- Implementation status: Not implemented.

## Purpose

Before launching a MekHQ or MegaMek scenario, a qualified character can analyze available information and produce an in-universe intelligence report. The raw adapter may know exact generated scenario data, but the report must be gated by action permissions and roll result.

The action is intended to answer player-facing questions such as:

- Is this fight routine, dangerous, or a probable trap?
- Is the enemy probably larger, heavier, or better trained than the public briefing implies?
- Should the commander seek reinforcements, refuse, delay, scout, or launch anyway?

It is not a raw scenario debugger, OpFor browser, or permission to show exact MekHQ/MegaMek scenario internals.

## Authority And Execution Flow

Runtime implementation remains blocked until hidden-data filtering and prompt assembly tests exist. The intended flow is:

1. Load action metadata for `pre_mission_intel_check`.
2. Resolve the lead actor through profession lookup.
3. Confirm the lead actor is an `intelligence_officer` or `scout_recon_specialist` owner.
4. Resolve support actors, if any, and accept only configured support professions.
5. Refuse planned/not-implemented, support-only, unmapped, ambiguous, unavailable, or timing-invalid requests before hidden data access.
6. Load public briefing facts.
7. Load hidden adjudication facts only after action permission passes.
8. Resolve the roll with `margin_2d6_target_number_v1`.
9. Map the margin through `pre_mission_intel_margin_v1`.
10. Cap the reveal level for missing, unstable, or unsupported fields.
11. Pass only filtered facts to prompt assembly.
12. Produce an in-universe report with uncertainty labels and no raw JSON/debug fields.

## Owning Professions

- Intelligence Officer.
- Scout / Recon Specialist.

## Supporting Professions

- Aerospace Pilot.
- Administrator / Liaison.
- MechWarrior.

Support roles may provide context or modifiers in a future implementation, but they should not bypass the lead profession's reveal gate.

Default support behavior: no automatic modifier. A support actor may be recorded as accepted context only when their profession lookup succeeds, their profile lists `pre_mission_intel_check: supporting`, and action configuration or GM input explicitly grants a modifier or context category.

## Action Spec

The canonical machine-readable metadata lives in the YAML front matter of `rules/actions/pre-mission-intel-check.md`. The sketch below is explanatory and should remain aligned with that front matter.

```yaml
action_id: pre_mission_intel_check
phase: pre_battle
roll_policy: margin_2d6_target_number_v1
reveal_map_id: pre_mission_intel_margin_v1
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
    - objectives
  hidden:
    - opfor_total_bv
    - opfor_unit_count
    - opfor_weight_classes
    - opfor_chassis
    - opfor_pilot_skills
    - special_scenario_flags
roll_required: true
reveal_levels:
  0: public briefing only
  1: enemy count estimate
  2: weight-class estimate
  3: BV range
  4: pilot quality band
  5: exact total BV and likely chassis
  6: exact units and pilot skills
  7: hidden objectives/deployment/special warnings
failure_modes:
  - no useful intel
  - vague report
  - stale information
  - misleading confidence
```

Runtime helpers must treat this action as non-executable until later issues add permission checks, dice/reveal mapping, hidden-data filtering, prompt assembly, and tests. A support-only actor cannot run the action as owner, and denied requests must not load hidden scenario data.

## Input Data Categories

| Category | Examples | Player-facing use |
| --- | --- | --- |
| Public briefing | scenario name, scenario type, terrain summary, weather, public objectives | Always allowed if the workflow would normally show the briefing. |
| MekHQ-owned personnel context | actor id/name, role, assignment, readiness, fatigue/injury warning | Used for permission, warnings, and modifiers only when explicitly supplied. |
| MekHQ-owned scenario metadata | scenario identity, pending deployment relationship, assigned force context | Used to connect the action to the correct scenario and avoid stale reports. |
| Hidden OpFor strength | total BV, unit count, weight classes, chassis | Filtered by reveal level; exact values require high reveal. |
| Hidden pilot quality | individual pilot skills or quality bands | Exact pilot skills require level 6; broad quality bands require level 4. |
| Hidden scenario shape | special flags, hidden objectives, deployment traps, unusual challenge markers | Requires level 7 and eligible hidden-warning fields. |
| Derived estimates | count estimate, relative BV band, quality band, special warning summary | Created after reveal resolution from permitted raw fields. |

If a hidden field is missing or unstable, do not invent it. Report a gap or cap the reveal level to the highest supported category.

## Reveal Levels

Level 0: public scenario briefing only.

Level 1: enemy count estimate. Use rough language such as `single lance`, `reinforced lance`, or `company-sized contact` where the fixture permits it. Do not provide exact unit records.

Level 2: weight-class estimate. Reveal broad classes or force posture such as light raiders, medium-heavy mixed lance, assault-heavy force, or vehicle-heavy contact.

Level 3: BV range. Reveal a rounded band or relative comparison, such as `roughly equal`, `about half again as strong`, or `around twice the assigned lance`. Do not reveal exact BV.

Level 4: pilot quality band. Reveal broad training warning, such as green, regular, veteran, elite, or legendary-grade opposition. Do not reveal individual pilot skill numbers.

Level 5: exact enemy total BV and likely chassis. Exact total BV may be revealed, but exact unit lists and pilot skills still remain hidden unless the action permits level 6.

Level 6: exact units and pilot skills. Reveal exact OpFor units and pilot skills only after high success and only if the action spec allows it.

Level 7: hidden objectives, deployment warnings, special scenario warnings. Reveal hidden danger, special objectives, deployment traps, or scenario-shape warnings as in-universe intelligence. This level may coexist with lower factual detail; it does not automatically reveal every exact unit detail unless level 6 is also permitted by the final mapping.

## Filtering Rules

- Exact units/pilot skills require high reveal level: exact unit lists and individual pilot skill values are allowed only at level 6 or higher, and only when the source fields are available and permitted.
- Level 0 may include public briefing facts and failure/caution language only.
- Level 1 may include approximate enemy count, not exact unit records.
- Level 2 may include broad force posture or weight-class mix, not chassis names.
- Level 3 may include rounded BV band or relative strength, not exact BV.
- Level 4 may include pilot quality band, not individual pilot skill values.
- Level 5 may include exact total BV and likely chassis, not exact unit list or pilot skills.
- Level 6 may include exact unit and pilot details only if the source fields are available and permitted.
- Level 7 may include hidden objective, deployment, trap, or special-warning categories, but should not automatically expose every exact unit field.
- Any field above the final reveal level must be absent from prompt context, not merely hidden by a prompt instruction.

## Provisional Roll Systems

### Option A: BattleTech-Style Target Number

- Roll `2d6`, add explicit modifiers, and compare final total to an explicit target number.
- Target number must come from an approved source such as GM-supplied input, fixture input, a later action default, or a later character-record source.
- Apply profession, support, fatigue, injury, equipment, or time-pressure modifiers only when supplied explicitly by the action configuration, fixture, GM, or future character-record support.
- Margin of success determines reveal level.

Provisional mapping from `docs/current/PROFESSION_DICE_REVEAL_DESIGN.md`:

| Margin | Reveal Level |
| --- | --- |
| `margin <= -4` | 0 with stale or misleading-confidence risk |
| `-3 <= margin <= -1` | 0 |
| `0 <= margin <= 1` | 1 |
| `2 <= margin <= 3` | 2 |
| `4 <= margin <= 5` | 3 |
| `6 <= margin <= 7` | 4 |
| `8 <= margin <= 9` | 5 |
| `margin >= 10` | 6, or 7 only when eligible special-warning flags exist |

### Option B: Additive Skill Check

- Roll `2d6 + modifiers`.
- Higher totals determine reveal level.
- Character competence, profession match, support roles, time, tools, and scenario quality contribute modifiers.

This is easier for generic RPG checks, but may fit MekHQ numeric personnel skills less directly.

## Recommendation

Use Option A provisionally for this action because it matches the committed core action-resolution summaries and existing resolver prototype shape. Keep the implementation configurable until richer character records and skill mappings are finalized.

## Prompt Assembly Boundary

The LLM report prompt should receive only:

- public briefing facts;
- filtered hidden facts allowed by reveal level;
- required uncertainty language;
- in-universe report style instructions;
- explicit forbidden-output rules for unrevealed data.

The prompt should not receive raw hidden unit sheets or exact pilot skills unless the reveal level permits them.

## Example Player-Facing Outputs

Level 0, failed or public-only result:

> Public briefing confirms a pending engagement in rough conditions. No reliable threat estimate is available. Treat the contact report as incomplete rather than reassuring.

Level 3, rounded strength warning:

> Intel estimates the opposing force is materially stronger than the assigned lance, roughly in the half-again-to-double-strength band. Chassis and pilot detail are not confirmed.

Level 4, quality-band warning:

> Pilot quality indicators look unusually high. Expect veteran-grade opposition or better, even if the visible force count looks manageable.

Level 7, special-warning result:

> Intel indicates an elite or legendary-grade OpFor. Estimated enemy strength is roughly twice the assigned lance. Scenario shape resembles a challenge engagement rather than a normal contract battle. Recommend withdrawal authority, reinforcement, or a deliberate refusal before launch.

These are original in-universe examples, not source text. Implementation should vary wording, but not reveal categories beyond the final reveal level.

## Future Test Scenarios

Use sanitized fixture data with obvious fake values. Required future tests:

| Scenario | Input shape | Expected result |
| --- | --- | --- |
| Unqualified owner denied | MechWarrior as lead actor | Deny before hidden data access; public briefing only. |
| Support-only denied | Aerospace Pilot as lead actor | Deny as `support_only`; no hidden fields read. |
| Qualified owner, margin 0 | Intelligence Officer, level 1 margin | Enemy count estimate allowed; no weight classes, BV, chassis, or pilot skills. |
| Qualified owner, margin 4 | Scout/Recon Specialist, level 3 margin | Rounded BV/relative strength allowed; no exact BV. |
| Qualified owner, margin 6 | Intelligence Officer, level 4 margin | Pilot quality band allowed; no individual pilot numbers. |
| Qualified owner, margin 8 | Intelligence Officer, level 5 margin | Exact total BV and likely chassis allowed; no exact pilot skills. |
| Qualified owner, margin 10 | Intelligence Officer, level 6 margin | Exact units and pilot skills allowed when fixture fields exist. |
| Special-warning trigger | Margin 10 plus eligible hidden special flag | Level 7 warning allowed without automatically dumping all raw scenario fields. |
| Missing hidden field | Level would permit exact BV, but field absent | Output capped or gap reported; no invented exact value. |
| Prompt filter regression | Hidden fixture contains exact pilot skill above permitted level | Prompt context and final report omit the exact skill. |

## Test Expectations

Future implementation tests should verify:

- unqualified professions cannot run the action;
- support professions cannot bypass an owning profession requirement;
- reveal level 0 includes only public briefing facts;
- reveal level 3 can include rounded BV band but not exact BV;
- reveal level 4 can warn about elite pilots without exposing individual skill values;
- reveal level 5 can expose exact total BV and likely chassis but not exact pilot skills;
- reveal level 6 can expose exact unit and pilot details;
- reveal level 7 can expose special scenario warnings without automatically dumping all raw hidden data;
- generated reports never include raw hidden fields above the permitted reveal level.

## Implementation Readiness

Ready for later implementation only after issues `#135` and `#136` define fixture-backed reveal tests and prompt/context assembly. Hidden-data boundaries are defined in `docs/current/PROFESSION_HIDDEN_DATA_BOUNDARIES.md`, but this action remains design metadata and should not be offered as an executable helper until tests and prompt filtering exist.
