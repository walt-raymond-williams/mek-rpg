# Pre-Mission Intel Check

## Status

- Action id: `pre_mission_intel_check`.
- Phase: `pre_battle`.
- Status: Planned.
- Parent design: `docs/current/PRE_MISSION_INTEL_CHECK.md`.

## Owning Professions

- `intelligence_officer`
- `scout_recon_specialist`

## Supporting Professions

- `aerospace_pilot`
- `administrator_liaison`
- `mechwarrior`

## Purpose

Allow a qualified character to analyze a generated MekHQ scenario before tactical launch and produce an in-universe intelligence report. Hidden scenario data must be filtered through reveal levels before it reaches player-facing prose.

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

Yes. The provisional recommendation is a `2d6 >= target number` check with margin of success mapping to reveal level. The final implementation may use a configurable roll policy.

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

## Failure Modes

- No useful intel.
- Vague report.
- Stale information.
- Misleading confidence.

## Test Expectations

- Verify reveal-level filtering with sanitized scenario fixtures.
- Verify no exact BV appears below level 5.
- Verify no exact pilot skill values appear below level 6.
- Verify special hidden scenario flags do not appear below level 7.
- Verify unqualified professions are rejected.
