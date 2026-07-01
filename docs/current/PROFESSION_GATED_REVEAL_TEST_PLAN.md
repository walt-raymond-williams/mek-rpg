# Profession Gated Reveal Test Plan

Status: issue `#135` test/spec plan. Runtime reveal tests are blocked until a first filtering helper or prompt assembly helper exists.

Parent epic: `#127` Profession Capability System.

Related files:

- `docs/current/PROFESSION_HIDDEN_DATA_BOUNDARIES.md`
- `docs/current/PROFESSION_DICE_REVEAL_DESIGN.md`
- `docs/current/PRE_MISSION_INTEL_CHECK.md`
- `rules/actions/pre-mission-intel-check.md`

## Purpose

Define deterministic tests that prove profession actions do not leak hidden data below the permitted reveal level.

The first implementation target is `pre_mission_intel_check`, but the plan should become reusable for later profession actions.

## Automation Status

No runtime reveal helper exists yet. Therefore this issue creates the test/spec plan and defers automated tests until at least one of these exists:

- a permission and reveal-filter helper;
- a prompt payload assembly helper;
- a fixed-output report generator helper used only for tests.

When that runtime slice exists, add the focused test to `scripts/test-all.ps1 -Quick` if it is deterministic and does not need live MekHQ.

## Test Harness Choice

Use PowerShell for the first test harness to match the repo's current deterministic script test style:

- proposed test file: `scripts/test-profession-gated-reveal.ps1`;
- proposed helper under test: decided by the runtime implementation issue;
- fixture location: `tests/fixtures/profession-gated-reveal/` or disposable fixture construction inside the test;
- output checks: JSON-first where possible, then string absence checks against prompt payload and final report.

Use Python only if the filtering helper is implemented in Python and native JSON fixture comparison becomes materially cleaner.

## Fixture Shape

Use committed sanitized fixtures with fake values only.

Minimum fixture fields:

```json
{
  "schema_version": "mek-rpg-profession-gated-reveal-fixture/v1",
  "public_briefing": {
    "scenario_name": "Fixture Ridge Patrol",
    "scenario_type": "Patrol",
    "terrain_summary": "Broken hills",
    "weather": "Clear",
    "public_objectives": ["Hold the ridge"]
  },
  "hidden": {
    "opfor_total_bv": 12345,
    "opfor_unit_count": 6,
    "opfor_weight_classes": ["heavy", "assault"],
    "opfor_chassis": ["HIDDEN_CHASSIS_SENTINEL"],
    "opfor_pilot_skills": ["HIDDEN_EXACT_PILOT_SKILL_SENTINEL"],
    "special_scenario_flags": ["HIDDEN_SPECIAL_FLAG_SENTINEL"]
  }
}
```

Use sentinel strings and distinctive numbers that tests can search for:

- `HIDDEN_EXACT_BV_SENTINEL` or a distinctive fake BV such as `12345`;
- `HIDDEN_CHASSIS_SENTINEL`;
- `HIDDEN_EXACT_PILOT_SKILL_SENTINEL`;
- `HIDDEN_SPECIAL_FLAG_SENTINEL`;
- `RAW_SCENARIO_JSON_SENTINEL`.

Public fields should use separate safe strings so tests can prove public facts still pass through.

## Permission Tests

| Test | Lead actor | Support actors | Expected status | Hidden payload read? |
| --- | --- | --- | --- | --- |
| Qualified intelligence owner | `intelligence_officer` | none | permission accepted | yes, after permission |
| Qualified scout owner | `scout_recon_specialist` | none | permission accepted | yes, after permission |
| MechWarrior as lead | `mechwarrior` | none | denied `support_only` | no |
| Aerospace as lead | `aerospace_pilot` | none | denied `support_only` | no |
| Unknown profession | null/unmapped | none | denied `profession_unmapped` | no |
| Ambiguous profession | ambiguous lookup result | none | denied `profession_ambiguous` | no |
| Unavailable actor | matched but unavailable | none | denied `lookup_blocked` or `unavailable` | no |
| Not-implemented action | action status not executable | qualified owner | denied `action_not_implemented` | no |

Denied cases should assert both output status and absence of hidden sentinels in prompt/report outputs.

## Reveal-Level Tests

For accepted owner tests, fixture target numbers and rolls should produce deterministic margins:

| Margin | Expected level | Allowed | Must be absent |
| --- | --- | --- | --- |
| -4 | 0 | public briefing only | all hidden sentinels |
| -1 | 0 | public briefing only | all hidden sentinels |
| 0 | 1 | enemy count estimate | exact count, BV, chassis, pilot skills, hidden flags |
| 2 | 2 | weight/force posture estimate | chassis, exact BV, pilot skills, hidden flags |
| 4 | 3 | rounded BV/relative strength | exact BV `12345`, chassis, pilot skills, hidden flags |
| 6 | 4 | pilot quality band | individual pilot skill sentinel, chassis, hidden flags |
| 8 | 5 | exact total BV and likely chassis | pilot skill sentinel, hidden flag sentinel, raw JSON sentinel |
| 10 | 6 | exact units and pilot skills | special flag sentinel unless level 7 applies; raw JSON sentinel |
| 10 + flag trigger | 7 | special warning category | raw JSON sentinel and full unit sheet sentinel |

Every test should inspect:

- structured filtered prompt payload;
- final generated or fixture-controlled report text;
- debug/trace output.

## Prompt Payload Leak Tests

Required assertions:

- Forbidden sentinel strings are absent from filtered prompt payload.
- Forbidden sentinel strings are absent from final report text.
- Debug output uses redaction tokens instead of raw hidden values.
- Prompt payload includes only the `allowed_categories` for the final reveal level.
- Prompt payload does not include a raw payload object, raw scenario path, raw unit sheet, or full hidden section.

Absence from final prose alone is insufficient. The filtered prompt payload is the primary boundary.

## Missing And Unstable Field Tests

| Case | Expected behavior |
| --- | --- |
| Missing exact BV at level 5 | report gap or cap; do not invent exact BV |
| Missing pilot skill fields at level 6 | omit pilot skills; report field gap |
| Missing special flags at level 7 | no special-warning content; do not invent trap/objective |
| Field marked unstable/unreviewed | cap to reviewed category and emit warning |
| Filter helper error | no player-facing report; blocker status |

## Quick Suite Integration

Add the focused test to `scripts/test-all.ps1 -Quick` only after:

- the helper under test is deterministic;
- fixtures are committed and sanitized;
- no live MekHQ read is required;
- no protected source paths are read;
- the test finishes quickly enough for the existing quick suite.

Expected future suite label: `Profession gated reveal coverage`.

## Definition Of Done For Future Runtime Tests

Future implementation work should not mark gated reveal safe until tests prove:

- denied permissions do not load hidden payloads;
- every reveal level excludes forbidden sentinels;
- prompt payload and final report are both checked;
- debug output is redacted;
- missing/unstable fields fail closed;
- tests are deterministic and run through the quick suite when appropriate.
