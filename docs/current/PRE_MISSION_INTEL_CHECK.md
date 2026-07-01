# Pre-Mission Intel Check

## Status

- Status: Planned first action for the Profession Capability System.
- Parent design: `docs/current/PROFESSION_CAPABILITY_SYSTEM.md`.
- Action spec: `rules/actions/pre-mission-intel-check.md`.
- Registry design: `docs/current/PROFESSION_ACTION_REGISTRY_DESIGN.md`.
- Implementation status: Not implemented.

## Purpose

Before launching a MekHQ or MegaMek scenario, a qualified character can analyze available information and produce an in-universe intelligence report. The raw adapter may know exact generated scenario data, but the report must be gated by action permissions and roll result.

## Owning Professions

- Intelligence Officer.
- Scout / Recon Specialist.

## Supporting Professions

- Aerospace Pilot.
- Administrator / Liaison.
- MechWarrior.

Support roles may provide context or modifiers in a future implementation, but they should not bypass the lead profession's reveal gate.

## Action Spec

The canonical machine-readable metadata lives in the YAML front matter of `rules/actions/pre-mission-intel-check.md`. The sketch below is explanatory and should remain aligned with that front matter.

```yaml
action_id: pre_mission_intel_check
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

## Reveal Levels

Level 0: public scenario briefing only.

Level 1: enemy count estimate. Use rough language such as `single lance`, `reinforced lance`, or `company-sized contact` where the fixture permits it. Do not provide exact unit records.

Level 2: weight-class estimate. Reveal broad classes or force posture such as light raiders, medium-heavy mixed lance, assault-heavy force, or vehicle-heavy contact.

Level 3: BV range. Reveal a rounded band or relative comparison, such as `roughly equal`, `about half again as strong`, or `around twice the assigned lance`. Do not reveal exact BV.

Level 4: pilot quality band. Reveal broad training warning, such as green, regular, veteran, elite, or legendary-grade opposition. Do not reveal individual pilot skill numbers.

Level 5: exact enemy total BV and likely chassis. Exact total BV may be revealed, but exact unit lists and pilot skills still remain hidden unless the action permits level 6.

Level 6: exact units and pilot skills. Reveal exact OpFor units and pilot skills only after high success and only if the action spec allows it.

Level 7: hidden objectives, deployment warnings, special scenario warnings. Reveal hidden danger, special objectives, deployment traps, or scenario-shape warnings as in-universe intelligence. This level may coexist with lower factual detail; it does not automatically reveal every exact unit detail unless level 6 is also permitted by the final mapping.

## Provisional Roll Systems

### Option A: BattleTech-Style Target Number

- Roll `2d6 >= target number`.
- Lower skill values are better where MekHQ-style skill ratings are used.
- Set base target from action difficulty, then apply profession, support, fatigue, injury, equipment, or time-pressure modifiers.
- Margin of success determines reveal level.

Example provisional mapping:

| Margin | Reveal Level |
| --- | --- |
| Failure by 4+ | 0 with misleading or stale risk |
| Failure by 1-3 | 0 |
| Success by 0-1 | 1 |
| Success by 2-3 | 2 |
| Success by 4-5 | 3 |
| Success by 6-7 | 4 |
| Success by 8-9 | 5 |
| Success by 10+ | 6 or 7, if scenario flags justify it |

### Option B: Additive Skill Check

- Roll `2d6 + modifiers`.
- Higher totals determine reveal level.
- Character competence, profession match, support roles, time, tools, and scenario quality contribute modifiers.

This is easier for generic RPG checks, but may fit MekHQ numeric personnel skills less directly.

## Recommendation

Use Option A provisionally for this action because it can map to BattleTech-flavored skill numbers and margin-of-success language. Keep the implementation configurable until the project's core dice mechanics are finalized.

## Prompt Assembly Boundary

The LLM report prompt should receive only:

- public briefing facts;
- filtered hidden facts allowed by reveal level;
- required uncertainty language;
- in-universe report style instructions;
- explicit forbidden-output rules for unrevealed data.

The prompt should not receive raw hidden unit sheets or exact pilot skills unless the reveal level permits them.

## Example Player-Facing Output

For a very dangerous challenge scenario, an allowed high-level warning might say:

> Intel indicates an elite or legendary-grade OpFor. Estimated enemy strength is roughly twice the assigned lance. Scenario shape resembles a challenge engagement rather than a normal contract battle. Recommend withdrawal authority, reinforcement, or a deliberate refusal before launch.

This is original in-universe guidance, not source text.

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
