# Personal Combat Detail Gaps Source Review Validation

## Purpose

This report records issue `#61` validation for the personal-combat detail expansion layer. The goal was to confirm that future agents can route armor/barrier and optional personal-combat questions from committed summaries without relying on model memory or copying protected source tables.

## Scope

- Mode: Source processing / project development.
- Source boundary: this issue explicitly permitted scoped source review for the target ranges. Raw source text and PDFs remain ignored and were not committed.
- New committed files checked: `rules/combat/armor-and-barriers.md` and `rules/combat/optional-personal-combat.md`.
- Supporting lookup files checked: `indexes/task-router.md`, `indexes/page-reference-index.md`, `indexes/rules-map.md`, `indexes/subsystem-index.md`, and `indexes/manifest.yaml`.

## Scenario Results

| Scenario prompt | Router match | Followed files | Result | Notes |
| --- | --- | --- | --- | --- |
| A gunshot passes through a window and then a PC's body armor. | `armor, barriers, cover penetration, armor degradation, stacked armor...` | `rules/combat/armor-and-barriers.md`, `rules/personal-combat/damage.md`, `rules/equipment/armor.md` | Pass with table caveat | The route gives layer order, AP/BAR comparison, degradation, and source lookup for exact values. |
| A player asks whether stacked personal armor is allowed. | `armor, barriers... stacked armor...` | `rules/combat/armor-and-barriers.md`, `rules/equipment/armor.md` | Pass | The route notes layer sequencing, encumbrance, and source layer limits without copying examples. |
| The GM wants morale checks after an ambush kills an allied NPC. | `optional personal combat, morale checks...` | `rules/combat/optional-personal-combat.md`, `rules/personal-combat/end-phase.md` | Pass | The route marks morale as optional and uses Willpower/Leadership guidance without turning it on by default. |
| The table asks for hit locations in a gritty duel. | `optional personal combat, hit locations...` | `rules/combat/optional-personal-combat.md`, `rules/combat/armor-and-barriers.md`, `rules/personal-combat/wounds.md` | Pass with table caveat | The route explains opt-in status, location-specific armor, specific wound effects, and surgery/recovery implications. |
| A melee hit might knock a character off balance. | `optional personal combat, knockdown checks...` | `rules/combat/optional-personal-combat.md`, `rules/personal-combat/melee-attacks.md`, `rules/personal-combat/wounds.md` | Pass | The route identifies knockdown as optional/contextual and preserves the source page reference for exact triggers. |
| The GM wants a less lethal campaign. | `optional personal combat... lethality reduction...` | `rules/combat/optional-personal-combat.md`, `gm/kid-friendly-mode.md` | Pass | The route presents increased capacity and armor-effectiveness options as explicit campaign-tone choices. |

## Schema Check

Both new summaries include:

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

- `indexes/task-router.md` now routes armor/barrier and optional personal-combat questions to the new files.
- `indexes/page-reference-index.md` promotes `combat.armor-barriers` and `combat.optional-personal` from mapped-only targets to committed draft summaries.
- `indexes/rules-map.md` describes the new detail layer and the optional-rule opt-in boundary.
- `indexes/subsystem-index.md` lists the new `rules/combat/` detail files.
- `indexes/manifest.yaml` records the two target IDs as committed draft entries with source pages and related IDs.

## Remaining Gaps

- Exact BAR values, barrier integrity values, battle armor BAR values, hit-location rolls, location-effect results, fatigue values, and worked examples remain private source lookups.
- Full tactical armor-location play remains outside MEK-RPG and should route to Classic BattleTech, MegaMek, or MekHQ.
- Optional personal combat rules are not default campaign policy; they must be explicitly enabled.

## Source And Copyright Check

- New files are paraphrased and procedural.
- No raw source text, copied tables, copied examples, copied modifier lists, hit-location tables, unit stats, or stat blocks were committed.
- Protected source paths remain expected to be ignored: `source/atow-pdf/` and `source/atow-text/`.

## Status

Passed for issue `#61` with source-table caveats. Personal-combat detail lookup is now source-reviewed enough for armor/barrier rulings and optional-rule routing while keeping exact source-heavy material private.
