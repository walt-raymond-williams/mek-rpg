# Profession Hidden-Data Boundaries

Status: issue `#134` design. Runtime hidden-data filtering is not implemented.

Parent epic: `#127` Profession Capability System.

Related files:

- `docs/current/PROFESSION_CAPABILITY_SYSTEM.md`
- `docs/current/PROFESSION_ACTION_REGISTRY_DESIGN.md`
- `docs/current/PROFESSION_DICE_REVEAL_DESIGN.md`
- `docs/current/PRE_MISSION_INTEL_CHECK.md`
- `rules/actions/pre-mission-intel-check.md`

## Purpose

Define the boundary between raw scenario data a MEK RPG adapter may inspect for adjudication and the filtered facts that may reach prompt assembly or player-facing output.

MekHQ or MegaMek scenario data may include exact OpFor units, total BV, pilot skills, hidden deployment, special objectives, or scenario flags before the table should know them. Profession actions may use those facts internally only after action permission succeeds and only to produce reveal-filtered outputs.

## Data Layers

Use these layers consistently:

| Layer | Owner | May contain hidden facts? | Player-facing? | Purpose |
| --- | --- | --- | --- | --- |
| Raw adapter payload | MekHQ/MegaMek or sanitized fixture | Yes | No | Captured source data, never passed directly to the LLM. |
| Internal adjudication context | MEK RPG helper | Yes, after permission succeeds | No | Permission-accepted action input for roll, reveal, and filtering. |
| Filtered prompt payload | MEK RPG helper | Only fields allowed by final reveal level | Not directly; LLM input only | Safe context for report generation. |
| Player-facing report | LLM/GM after filtering | Only permitted facts | Yes | In-universe briefing, warning, or failure text. |
| Debug/trace output | MEK RPG helper | Redacted or fixture-safe only | No | Verification and troubleshooting without leaking hidden strings. |

Raw payloads must not be placed in prompt context as convenience data. Filter first, then prompt.

## Access Order

Hidden data access must be ordered:

1. Read action metadata.
2. Resolve actor profession and availability.
3. Deny unknown, planned/not-implemented, retired, support-only, unmapped, ambiguous, unavailable, or timing-invalid requests.
4. Load public briefing facts if the workflow permits public facts.
5. Load hidden adjudication facts only after permission succeeds.
6. Resolve roll and reveal level.
7. Apply caps for missing or unsupported fields.
8. Build a filtered prompt payload containing only allowed categories.
9. Generate player-facing output from the filtered payload.
10. Emit debug/trace output with hidden values redacted unless the fixture is explicitly safe.

Denied requests must stop before step 5.

## Forbidden Prompt Fields

For `pre_mission_intel_check`, prompt payloads must exclude these fields until the final reveal level permits them:

| Field category | Examples | Minimum reveal level |
| --- | --- | --- |
| Exact OpFor unit count | exact integer count, exact lance composition | 6 for exact records; level 1 may include estimates only |
| Exact weight/chassis records | chassis names, model names, exact unit list | 5 for likely chassis, 6 for exact unit records |
| Exact BV | exact total BV, exact unit BV | 5 for total BV; level 3 may include rounded/relative band only |
| Individual pilot skills | gunnery/piloting values, named pilot quality values | 6 |
| Hidden scenario flags | trap flag, ambush flag, challenge marker, hidden objective key | 7 |
| Raw scenario/debug identifiers | internal IDs, raw JSON paths, generator flags | Never player-facing by default |
| Full raw unit sheets | armor, weapons, quirks, heat, ammo, full pilot record | Never through this action; use tactical authority/handoff when exact unit sheets matter |

The filter should remove forbidden values entirely. Do not rely on prompt instructions that merely tell the LLM not to mention hidden fields.

## Allowed Output By Reveal Level

| Reveal level | Allowed filtered facts | Forbidden examples |
| --- | --- | --- |
| 0 | Public briefing, uncertainty, no-useful-intel language | Enemy count, BV, pilot quality, hidden flags |
| 1 | Enemy count estimate | Exact count, chassis, BV, pilot skills |
| 2 | Broad weight-class or force-posture estimate | Chassis list, exact BV, pilot skills |
| 3 | Rounded BV band or relative strength | Exact BV, exact unit list, pilot skills |
| 4 | Pilot quality band or elite-opposition warning | Individual pilot skill values |
| 5 | Exact enemy total BV and likely chassis | Exact unit list, exact pilot skills, hidden flags |
| 6 | Exact units and pilot skills when fields exist | Hidden objectives or deployment traps unless level 7 also applies |
| 7 | Hidden objectives, deployment traps, special-warning categories | Full raw scenario payload or raw debug data |

If a category is not present in the filtered payload, final prose must not imply certainty about it.

## Debug And Logging Boundary

Debug output must be safe to paste into an issue or test failure:

- Prefer field names, reveal levels, caps, counts, and redaction markers.
- Do not log exact hidden strings, exact pilot skill values, raw unit sheet text, or raw scenario JSON.
- Use deterministic redaction tokens such as `[hidden:opfor_pilot_skills:redacted]`.
- Test fixtures may include obvious fake hidden strings, but test logs should still prove they are absent from filtered prompt payloads and final reports.
- If a helper needs a full raw payload path for local troubleshooting, keep it in ignored local captures and do not include it in committed output.

## Failure Behavior

Fail closed whenever the boundary cannot be proven:

- Missing action metadata: deny action, no hidden data.
- Planned/not-implemented action: deny execution, no hidden data.
- Actor lookup missing, unmapped, ambiguous, unavailable, or support-only: deny action, no hidden data.
- Missing target number or invalid roll input: no reveal above level 0.
- Missing hidden field: cap or omit the category; do not invent a value.
- Unstable API field: cap to the highest fixture-reviewed category and emit a gap.
- Filter error: return no player-facing report rather than passing raw data through.
- Prompt assembly error: discard prompt payload and report the blocker.

## Fixture Strategy

Use sanitized committed fixtures only. Good fixture traits:

- obvious fake scenario names and unit names;
- distinctive hidden sentinel strings such as `HIDDEN_EXACT_PILOT_SKILL_SENTINEL`;
- exact fake BV and pilot numbers chosen to be easy to search;
- separate public briefing fields that are safe to appear;
- special-warning flags with fake names;
- expected filtered prompt payloads for each reveal level;
- expected final report text or string-absence assertions.

Tests should search both filtered prompt payload and generated/fixed report text for forbidden sentinel strings. Absence from final prose is not enough if the prompt payload still contains unrevealed data.

## Test Matrix

Future implementation tests should cover:

| Test | Reveal level or state | Must be absent |
| --- | --- | --- |
| Denied owner | denied before hidden access | all hidden sentinels; raw payload read marker |
| Support-only lead | denied before hidden access | all hidden sentinels; exact values |
| Level 0 | public only | count estimate, BV, chassis, pilot skills, hidden flags |
| Level 1 | count estimate | exact count, chassis, BV, pilot skills, hidden flags |
| Level 2 | weight-class estimate | chassis names, exact BV, pilot skills, hidden flags |
| Level 3 | rounded strength band | exact BV, exact unit list, pilot skills, hidden flags |
| Level 4 | quality band | individual pilot numbers, exact unit list, hidden flags |
| Level 5 | exact total BV and likely chassis | individual pilot skills, hidden flags, raw unit sheets |
| Level 6 | exact units and pilot skills | hidden objectives/deployment flags unless level 7 applies |
| Level 7 | special warning | raw scenario JSON, debug identifiers, full unit sheets |
| Missing field cap | any capped level | invented values and unsupported certainty |
| Filter failure | error path | player-facing report |

## Implementation Notes

Issue `#135` turned this boundary into the fixture-backed test/spec plan in `docs/current/PROFESSION_GATED_REVEAL_TEST_PLAN.md`. Issue `#136` should ensure prompt/context assembly consumes only the filtered prompt payload and cannot reach raw hidden data.
