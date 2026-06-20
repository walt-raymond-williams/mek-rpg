# Character Creation Lookup Validation

## Purpose

This report records issue `#21` validation for the character-creation foundation layer. The goal was to confirm that a future GM assistant can start at `indexes/task-router.md`, follow committed links, and answer common character-creation setup questions from paraphrased summaries rather than model memory or raw source text.

## Scope

- Mode: Source processing / project development.
- Source boundary: summaries were written from mapped private page text under explicit source-processing scope. Raw source text and PDFs remain ignored and were not committed.
- Character summaries checked: `rules/character-creation/overview.md`, `rules/character-creation/lifepaths.md`, `rules/character-creation/attributes.md`, `rules/character-creation/traits.md`, `rules/character-creation/skills.md`, and `rules/character-creation/xp-advancement.md`.
- Supporting lookup files checked: `indexes/task-router.md`, `indexes/page-reference-index.md`, `indexes/rules-map.md`, `indexes/subsystem-index.md`, and `indexes/manifest.yaml`.

## Scenario Results

| Scenario prompt | Router match | Followed files | Result | Notes |
| --- | --- | --- | --- | --- |
| A player wants to start a new PC for the first real campaign and asks what choices must be made before spending XP. | `character creation, starting a PC, building a unique NPC, or reviewing a character sheet` | `rules/character-creation/overview.md`, `rules/character-creation/lifepaths.md`, `rules/character-creation/attributes.md`, `rules/character-creation/traits.md`, `rules/character-creation/skills.md`, `rules/character-creation/xp-advancement.md` | Pass | The path starts with campaign fit, concept, creation method, XP budget, mechanics, final touches, and unresolved sheet questions. |
| A player wants to build a MechWarrior through affiliation, childhood, academy training, and a tour of duty. | `lifepaths, life modules, affiliation, childhood, education, skill fields, or pre-play career history` | `rules/character-creation/lifepaths.md`, `rules/character-creation/overview.md`, `rules/character-creation/skills.md`, `rules/character-creation/traits.md` | Pass with source lookup caveat | The path explains stage selection and prerequisite handling, while exact module entries, field lists, and XP awards remain private source lookups. |
| A player is using points-only creation and asks how attributes, traits, skills, and leftover XP should be handled. | `character creation...` plus attribute, trait, and skill rows | `rules/character-creation/overview.md`, `rules/character-creation/attributes.md`, `rules/character-creation/traits.md`, `rules/character-creation/skills.md` | Pass with table caveat | The path supports purchase order, prerequisite checks, negative-trait XP boundaries, and leftover-XP tracking. Exact XP cost tables remain source lookup. |
| The GM reviews a character sheet and needs to identify missing fields before play. | `character creation, starting a PC, building a unique NPC, or reviewing a character sheet` | `rules/character-creation/overview.md`, active `campaigns/<campaign-id>/pcs.md` by related campaign guidance | Pass | The summary lists sheet implications: attributes, linked modifiers, traits with TP/page references, skills with levels and linked data, combat data, inventory, vehicles, and unresolved questions. |
| A player wants to improve a skill during downtime after a mission. | `XP awards, spending XP, training, downtime learning, aging effects, salary, rank, or post-creation advancement` | `rules/character-creation/xp-advancement.md`, `rules/character-creation/skills.md`, `rules/core/skill-checks.md` | Pass with table caveat | The path distinguishes Basic and Advanced skill advancement, trainer requirements, downtime, and source-table lookups for exact values. |
| A PC's rank, salary, and command responsibility become important after promotion. | `XP awards... salary, rank...` and campaign advancement row if campaign consequences matter | `rules/character-creation/xp-advancement.md`, `rules/campaign/advancement.md` | Pass with caveat | Character advancement routes salary/rank concepts and warns that campaign-scale consequences remain issue `#22` work. |

## Schema Check

All six character-creation summaries include:

- `Purpose`
- `When to Use`
- `Do Not Use For`
- `Basic Procedure`
- `Practical GM Guidance`
- `Common Edge Cases`
- `Related Files`
- `Source References`
- `Status`

## Index And Manifest Check

- `indexes/task-router.md` now treats character creation as draft coverage instead of placeholder coverage.
- `indexes/page-reference-index.md` includes page references for all six character-creation summaries.
- `indexes/rules-map.md` describes character creation as a routed procedural layer and keeps exact catalogs and tables in private source lookup.
- `indexes/subsystem-index.md` lists the character-creation summary files.
- `indexes/manifest.yaml` has draft manifest entries for character overview, lifepaths, attributes, traits, skills, and XP advancement, with related IDs that resolve.

## Character-Sheet Implications

For now, campaign saves should keep PC sheet state in `campaigns/<campaign-id>/pcs.md`, using one section per character. A durable PC section should capture at least:

- player and character concept
- creation method and source-review status
- affiliation, background, and campaign role
- attributes and unresolved attribute questions
- traits with trait points, descriptors, and source page references
- skills with subskills, specialties, levels, and unresolved training questions
- XP earned, XP spent, leftover XP, and advancement notes
- Edge, wounds/fatigue, armor, gear, money, vehicles, and other play-facing resources
- relationships, obligations, enemies, goals, and hooks created by character creation

Separate character files are deferred until a real campaign has enough PC detail to justify them. Starting inside `pcs.md` keeps issue `#24` simpler and avoids adding validation requirements before the first real campaign save exists.

## Validator-Maintenance Decision

Do not update `scripts/validate-campaign-state.ps1` for issue `#21`. The shared campaign-state validator should remain focused on active-campaign safety, template structure, and standard save-folder files.

Add a future character-output validator after the first real campaign creates one or more actual PC sections. That validator should check character sections or files for required headings, marked source-review status, unresolved sheet questions, campaign links, and no copied source tables.

## Remaining Gaps

- Exact Life Module entries, skill-field lists, trait catalogs, skill catalogs, XP tables, aging tables, salary tables, random unit assignment tables, and sample character sheets remain private source lookups.
- Campaign consequences for advancement, contacts, contracts, reputation, long-term downtime, and rank/power remain issue `#22`.
- MechWarrior pilot/gunnery bridge and tactical conversion remain issue `#23`.
- A live character creation walkthrough should occur during or after issue `#24` once a real campaign premise and PC concept exist.

## Source And Copyright Check

- Summaries are paraphrased and procedural.
- No raw source text, copied tables, copied module entries, copied trait catalogs, copied skill lists, or sample character sheets were committed.
- Protected source paths remain expected to be ignored: `source/atow-pdf/` and `source/atow-text/`.

## Status

Passed for issue `#21` with caveats. Character creation is now draft-routed and usable for campaign setup guidance, sheet review, and advancement routing, while exact table-heavy build details remain source-referenced.
