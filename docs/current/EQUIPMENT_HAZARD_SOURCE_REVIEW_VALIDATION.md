# Equipment And Hazard Source Review Validation

## Scope

Issue `#63` reviewed scoped A Time of War source ranges for special conditions, creatures, diseases, battle armor/exoskeletons, prosthetics/implants, drugs/poisons, and personal vehicles. The resulting files are paraphrased routing aids and procedures, not copied catalogs or medical/tactical rules engines.

## Added Coverage

- `rules/special/planetary-conditions.md`
- `rules/special/creatures.md`
- `rules/special/diseases.md`
- `rules/equipment/battle-armor-and-exoskeletons.md`
- `rules/equipment/prosthetics-and-implants.md`
- `rules/equipment/drugs-and-poisons.md`
- `rules/equipment/personal-vehicles.md`

## Scenario Checks

### Hostile Atmosphere Extraction

Prompt: the squad crosses a toxic industrial zone in damaged environmental suits while a storm reduces visibility.

Expected route: `rules/special/planetary-conditions.md`, `rules/equipment/armor.md`, `rules/equipment/personal-gear.md`, and recovery summaries if exposure occurs. Exact taint, suit breach, visibility, and weather modifiers remain source lookups.

### Predator Ambush With Venom

Prompt: an alien predator ambushes a PC and injects venom.

Expected route: `rules/special/creatures.md` for encounter and creature routing, then `rules/equipment/drugs-and-poisons.md` and recovery files for venom treatment. Exact creature stats and venom values remain source lookups.

### Disease Plot Clock

Prompt: a traveler develops symptoms after a failed inoculation and the crew must find treatment before the next mission.

Expected route: `rules/special/diseases.md`, `rules/equipment/medical-gear.md`, and `rules/campaign/injuries-recovery.md`. The summary keeps the disease as a campaign clock and avoids copied random-disease tables.

### Battle Armor In A Boarding Action

Prompt: a PC tries to don battle armor during an alarm and fight dismounted boarders.

Expected route: `rules/equipment/battle-armor-and-exoskeletons.md`, `rules/tactical/tactical-combat-overview.md`, and personal combat summaries. If vehicles, armor locations, mounted weapons, or exact suit movement matter, switch to tactical source/tool handling.

### Prosthetic Replacement After Injury

Prompt: a PC loses a hand and wants a replacement before the next deployment.

Expected route: `rules/equipment/prosthetics-and-implants.md`, `rules/campaign/injuries-recovery.md`, and trait summaries. Exact type, cost, surgery, recovery, and trait offset remain source lookups.

### Performance Drug Or Poison In Play

Prompt: a player considers a combat drug, or an NPC uses poison.

Expected route: `rules/equipment/drugs-and-poisons.md`, medical gear, and safety-conscious GM handling. Exact drug/poison stats, addiction, and treatment values remain private source lookups.

### Personal Vehicle And Fuel Question

Prompt: the crew buys a utility vehicle for a mission and needs fuel planning.

Expected route: `rules/equipment/personal-vehicles.md`, `rules/campaign/transport-and-large-assets.md`, and `rules/vehicles-and-mechs/overview.md`. Exact vehicle and fuel table values remain source lookups.

## Copyright Boundary Check

- No equipment catalogs, creature stat blocks, disease tables, drug/poison tables, vehicle tables, or battle armor stat blocks were copied.
- Raw source paths remain ignored and must not be staged: `source/atow-pdf/`, `source/atow-text/`.
- Sensitive medical, poison, addiction, disease, and implant topics are framed as fictional game procedures only.

## Verification Commands

- `./scripts/validate-rules-indexes.ps1`
- `./scripts/report-rules-coverage.ps1`
- `./scripts/test-all.ps1`
- `git diff --check`
- `git check-ignore source/atow-pdf/example.pdf`
- `git check-ignore source/atow-text/page-001.txt`

## Status

Validation note for issue `#63`. Run the listed checks before commit.
