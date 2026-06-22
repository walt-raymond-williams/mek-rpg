# Special Case Rules Source Review Validation

## Scope

- Issue: `#92`
- Source ranges reviewed:
  - A Time of War PDF pages 232-240 / printed pages 230-238: planetary conditions, terrain, weather, gravity, atmosphere, and vacuum.
  - A Time of War PDF pages 240-247 / printed pages 238-245: creatures, creature skills, creature combat, training, catalog examples, and venom routing.
  - A Time of War PDF pages 247-251 / printed pages 245-249: disease framing, inoculation, random disease procedure, recovery, treatment, and caution guidance.
- Updated summaries:
  - `rules/special/planetary-conditions.md`
  - `rules/special/creatures.md`
  - `rules/special/diseases.md`

## Source Boundary

The committed summaries paraphrase live-play procedures and routing only. They do not copy terrain modifier tables, exact weather values, creature stat blocks, creature catalog entries, venom values, disease tables, disease examples, treatment values, or source prose.

Exact terrain, weather, atmospheric, creature, venom, disease, and treatment values remain private source lookup.

## Validation Scenarios

| Prompt | Expected route | Result |
| --- | --- | --- |
| The squad crosses deep snow in a blizzard with poor visibility. | `rules/special/planetary-conditions.md` | Pass: routes to layered terrain/weather pressure, player-visible risk, and source lookup for exact modifiers. |
| A PC's vacuum suit is hit during a hull walk. | `rules/special/planetary-conditions.md` | Pass: routes to sealed protection, breach risk, continuous-damage/oxygen-clock lookup, and tactical handoff if unit combat matters. |
| A predator ambushes the patrol and has venom. | `rules/special/creatures.md` | Pass: routes to creature motive, AniMelee/personal combat, source lookup for stats, and poison/venom follow-up. |
| The crew wants to train a captured mount during downtime. | `rules/special/creatures.md` | Pass: routes to Animal Handling/training downtime and source lookup for exact training XP/time details. |
| A new-world illness creates a quarantine clock. | `rules/special/diseases.md` | Pass: routes to prevention, symptom/frequency/severity handling, MedTech recovery, and campaign-state consequences. |
| Failed inoculation causes a local allergic complication. | `rules/special/diseases.md` | Pass: routes to source lookup for exact failure/fumble effects and keeps real-world medical advice out of scope. |

## Status Decision

These files are now `draft` play-facing summaries rather than `source-reviewed-routing-aid` entries. They can support cautious live GM rulings from committed summaries, but table/catalog values still require private source lookup and tactical cases still hand off to Classic BattleTech, MegaMek, MekHQ, or the relevant tactical source.

## Verification

Run these checks after issue `#92` changes:

```powershell
./scripts/validate-rules-indexes.ps1
./scripts/test-route-rules-prompt.ps1
./scripts/test-report-rules-coverage.ps1
./scripts/test-all.ps1
```
