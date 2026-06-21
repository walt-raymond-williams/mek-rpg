# Tactical Addendum Boundary Source Review Validation

## Scope

Issue `#62` reviewed A Time of War PDF pages 202-227 / printed pages 200-225 for tactical addendum routing. The resulting files are paraphrased routing aids under `rules/tactical/`; they do not replace Classic BattleTech, Total Warfare, Tactical Operations, MegaMek, or MekHQ.

## Added Coverage

- `rules/tactical/tactical-combat-overview.md`: tactical scale, unit categories, battle armor boundary, map/terrain need, warrior roles, skill conversion, and modifier conversion.
- `rules/tactical/tactical-turn-and-initiative.md`: tactical turn structure, force initiative, out-of-contact routing, action sequence, and simultaneous resolution.
- `rules/tactical/vehicle-actions.md`: vehicle action and movement routing, jumping, stacking, footprints, range conversion, and vehicle attacks against infantry.
- `rules/tactical/tactical-damage-and-traits.md`: damage conversion routing, weapon trait boundaries, battle armor weapon handling, pilot/crew injury, physical attacks, stealth, and End Phase notes.
- `rules/tactical/heat-and-pilot-abilities.md`: heat routing and Special Pilot Ability acquisition/use boundaries.

## Scenario Checks

### BattleMech Duel With Exact Heat And Armor

Prompt: two BattleMechs exchange fire and the players care about heat, armor locations, exact weapon ranges, and critical hits.

Expected route: `gm/switch-to-classic-battletech.md`, `gm/tactical-encounter-handoff-checklist.md`, and external tactical tooling. The new tactical files can help prepare pilot skills, heat notes, and handoff assumptions, but they must not resolve the duel.

### Vehicle Chase With One Dramatic Risk

Prompt: a PC drives a ground vehicle through a checkpoint while a turret threatens one decisive shot.

Expected route: `rules/vehicles-and-mechs/overview.md`, `rules/tactical/vehicle-actions.md`, and `rules/vehicles-and-mechs/gunnery.md` if the shot matters. If exact range, scatter, or damage to named characters matters, switch to source/tool lookup before resolving.

### Battle Armor Against Conventional Infantry

Prompt: a battlesuit squad engages dismounted soldiers in close terrain.

Expected route: `rules/tactical/tactical-combat-overview.md`, `rules/tactical/tactical-damage-and-traits.md`, and personal combat summaries. The battle armor boundary should be explicit before choosing personal or vehicle-scale handling.

### Commander Cut Off By ECM

Prompt: a tactical force has a commander, separated units, Combat Sense, Combat Paralysis, and ECM interference.

Expected route: `rules/tactical/tactical-turn-and-initiative.md` for routing and source page references. Exact out-of-contact handling remains a source lookup or tactical-tool matter.

### Special Pilot Ability Request

Prompt: a player wants a heat-focused or movement-focused pilot ability after several missions.

Expected route: `rules/tactical/heat-and-pilot-abilities.md` and `rules/vehicles-and-mechs/mechwarrior-skills.md`. Verify prerequisites, XP cost, class limit, platform scope, and GM approval in the private source before adding the ability.

## Copyright Boundary Check

- No tactical tables, weapon conversion tables, Special Pilot Ability catalog entries, record sheets, or modifier lists were copied into committed summaries.
- Raw source paths remain ignored and must not be staged: `source/atow-pdf/`, `source/atow-text/`.
- The new files cite page ranges and provide routing/procedure guidance only.

## Verification Commands

- `./scripts/validate-rules-indexes.ps1`
- `./scripts/report-rules-coverage.ps1`
- `./scripts/test-all.ps1`
- `git diff --check`
- `git check-ignore source/atow-pdf/example.pdf`
- `git check-ignore source/atow-text/page-001.txt`

## Status

Validation note for issue `#62`. Scenario checks passed by inspection after index updates; automated repository checks should be run before commit.
