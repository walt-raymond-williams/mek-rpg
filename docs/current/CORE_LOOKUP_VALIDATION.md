# Core Lookup Validation

## Purpose

This report records issue `#6` validation for the first core-resolution lookup layer. The goal was to confirm that a GM assistant can start at `indexes/task-router.md`, follow committed links, and answer common core-resolution situations from paraphrased summaries rather than model memory.

## Scope

- Mode: Project development.
- Source boundary: validation used committed summaries and indexes only. Raw source text under `source/atow-text/` and PDFs under `source/atow-pdf/` were not inspected.
- Core summaries checked: `rules/core/action-checks.md`, `rules/core/attribute-checks.md`, `rules/core/skill-checks.md`, `rules/core/opposed-actions.md`, `rules/core/basic-action-resolution.md`, and `rules/core/edge.md`.
- Supporting lookup files checked: `indexes/task-router.md`, `indexes/page-reference-index.md`, `indexes/rules-map.md`, `indexes/subsystem-index.md`, `indexes/manifest.yaml`, `gm/roll-policy.md`, and `gm/scene-loop.md`.

## Scenario Results

| Scenario prompt | Router match | Followed files | Result | Notes |
| --- | --- | --- | --- | --- |
| A character tries to bypass a security lock under time pressure. | `bypassing a lock, disabling a device, or handling a technical task under pressure` | `rules/core/skill-checks.md`, `rules/core/action-checks.md`, `rules/core/basic-action-resolution.md` | Pass | The path supports a trained Skill Check when the character has the relevant Skill, with Basic Action Resolution handling time pressure and modifiers. If the character lacks the Skill, Skill Checks routes to Attribute Checks. |
| Two characters both try to grab the same object first. | `two characters racing, grabbing, resisting, sneaking past, or spotting each other` | `rules/core/opposed-actions.md`, `rules/core/basic-action-resolution.md`, `rules/core/edge.md` | Pass | The path reaches opposed margin comparison and includes Edge as a related option for consequential rolls. |
| A character attempts a difficult task with situational pressure and possible modifiers. | `difficult circumstances, time pressure, injury, fatigue, visibility, or environmental pressure on a roll` | `rules/core/basic-action-resolution.md`, `rules/core/action-checks.md`, `rules/core/skill-checks.md` | Pass | The path reaches modifier guidance without reproducing table values. Exact table values remain source-reference lookups. |
| A scene needs the GM to interpret how well or poorly a successful roll went. | `interpreting how well or poorly a roll succeeded or failed` | `rules/core/basic-action-resolution.md`, `rules/core/action-checks.md`, `rules/core/opposed-actions.md` | Pass | The path reaches margin guidance and opposed net-margin handling. The summary supports paraphrased narration without copied margin tables. |
| A player wants to spend Edge after a failed important roll. | `spending or recovering Edge` | `rules/core/edge.md`, `rules/core/basic-action-resolution.md`, `rules/campaign/advancement.md` | Pass with caveat | Edge timing and one-use limits are summarized. Long-term recovery and advancement remain outside the core range and should be handled by future campaign/advancement summaries. |

## Schema Check

All six core summaries include:

- `Purpose`
- `When to Use`
- `Do Not Use For`
- `Basic Procedure`
- `Practical GM Guidance`
- `Common Edge Cases`
- `Related Files`
- `Source References`
- `Status`

## Routing Fixes Made

- Added natural-language core scenario cues to `indexes/task-router.md` for lock bypasses, direct contests, pressured/difficult rolls, and margin interpretation.
- Updated `gm/scene-loop.md` so live play starts at `indexes/task-router.md` before a meaningful roll.
- Updated `gm/roll-policy.md` to require using committed summaries when they exist and to check `Do Not Use For` before applying a subsystem.

## Remaining Gaps

- Exact target-number, modifier, and margin table values are intentionally not reproduced in committed summaries. Live lookup should cite `indexes/page-reference-index.md` or the summary source references when exact table values are needed.
- `rules/campaign/advancement.md` remains a placeholder dependency for long-term Edge recovery and advancement.
- Personal combat, damage, treatment, equipment, and vehicle prompts are outside the core-resolution validation scope and should be covered by later summary issues.

## Source And Copyright Check

- Validation did not inspect or quote raw source text.
- Core summaries remain paraphrased and page-referenced.
- Protected source paths remain expected to be ignored: `source/atow-pdf/` and `source/atow-text/`.

## Status

Passed for issue `#6`. Core lookup is usable for common action checks, skill checks, opposed contests, modifiers, margin interpretation, and Edge prompts, with caveats recorded above.
