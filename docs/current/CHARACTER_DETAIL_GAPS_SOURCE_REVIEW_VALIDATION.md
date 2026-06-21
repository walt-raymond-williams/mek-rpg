# Character Detail Gaps Source Review Validation

## Purpose

This report records issue `#60` validation for the character-detail expansion layer. The goal was to confirm that future agents can route sheet-review, field-selection, purchase-cleanup, trait-catalog, and skill-catalog questions without relying on model memory or copying protected source catalogs.

## Scope

- Mode: Source processing / project development.
- Source boundary: this issue explicitly permitted scoped source review for the target ranges. Raw source text and PDFs remain ignored and were not committed.
- New committed files checked: `rules/core/character-record-basics.md`, `rules/character-creation/skill-fields.md`, `rules/character-creation/purchasing-character-elements.md`, `rules/traits/trait-catalog-map.md`, and `rules/skills/skill-catalog-map.md`.
- Supporting lookup files checked: `indexes/task-router.md`, `indexes/page-reference-index.md`, `indexes/rules-map.md`, `indexes/subsystem-index.md`, and `indexes/manifest.yaml`.

## Scenario Results

| Scenario prompt | Router match | Followed files | Result | Notes |
| --- | --- | --- | --- | --- |
| The GM has a new PC section in `pcs.md` and wants to know which sheet areas are missing before session start. | `reviewing a character sheet, character record, missing sheet fields, combat data, inventory, biography, or vehicle notes` | `rules/core/character-record-basics.md`, `rules/character-creation/overview.md`, active campaign PC/NPC files | Pass | The route identifies personal data, attributes, traits, skills, combat data, biography, inventory, vehicle notes, and unresolved flags without copying the source record sheet. |
| A player wants a police/intelligence background and asks how Skill Fields work. | `skill fields, field prerequisites, professional training bundles...` | `rules/character-creation/skill-fields.md`, `rules/character-creation/lifepaths.md`, `rules/character-creation/skills.md` | Pass with source lookup caveat | The route explains prerequisites, field categories, exact field-list lookup, and sheet recording while preserving the catalog boundary. |
| A Life Module character has leftover XP, opposed traits, and partial skill XP before play. | `final character creation spending, purchasing attributes/traits/skills, optimization, opposed traits...` | `rules/character-creation/purchasing-character-elements.md`, existing character summaries | Pass with table caveat | The route gives the cleanup order and points to source pages for exact XP and opposed-trait tables. |
| A player asks whether a vehicle-related trait gives them a specific unit. | `trait catalog lookup, identity-based traits, vehicle traits...` | `rules/traits/trait-catalog-map.md`, `rules/character-creation/traits.md`, `rules/vehicles-and-mechs/overview.md` | Pass with source lookup boundary | The route separates vehicle access/trait handling from unit table lookup and tactical ownership. |
| A player asks whether `Technician/Myomer`, `Technician/Mechanical`, and `Technician/Nuclear` are interchangeable. | `skill catalog lookup, subskills, specialties, linked attributes...` | `rules/skills/skill-catalog-map.md`, `rules/character-creation/skills.md`, `rules/core/skill-checks.md` | Pass | The route emphasizes exact subskill recording and returning to core skill checks after choosing the skill. |

## Schema Check

All five new files include:

- `Purpose`
- `When to Use`
- `Do Not Use For`
- `Basic Procedure`
- `Practical GM Guidance`
- `Common Edge Cases`
- `Related Files`
- `Source References`
- `Status`

The two catalog-map files also include a `Page-Range Guide` so future agents can route to private source pages without copying catalogs.

## Index And Manifest Check

- `indexes/task-router.md` now routes character record basics, Skill Fields, final purchase cleanup, trait catalog lookup, and skill catalog lookup to the new files.
- `indexes/page-reference-index.md` promotes the five issue `#60` targets from mapped/partial-draft targets to committed source-reviewed files.
- `indexes/rules-map.md` describes the new character-detail layer and keeps exact catalogs/tables in private source lookup.
- `indexes/subsystem-index.md` lists the new character-creation, traits, and skills files.
- `indexes/manifest.yaml` records the five target IDs as committed entries with source pages and related IDs.

## Remaining Gaps

- Exact record-sheet layout, sample characters, Skill Field lists, XP cost tables, opposed-trait tables, trait descriptions, trait tables, random unit assignment tables, skill master-list values, and full skill descriptions remain private source lookups.
- A future character-output validator is still deferred until real PC/NPC sections stabilize.
- Trait and skill catalog maps are routing aids, not complete rules authority for each individual trait or skill.

## Source And Copyright Check

- New files are paraphrased and procedural.
- No raw source text, copied tables, copied catalogs, copied sample sheets, unit lists, or stat blocks were committed.
- Protected source paths remain expected to be ignored: `source/atow-pdf/` and `source/atow-text/`.

## Status

Passed for issue `#60` with source-table caveats. Character-detail lookup is now source-reviewed enough for sheet review, character creation cleanup, and catalog routing while keeping exact source-heavy material private.
