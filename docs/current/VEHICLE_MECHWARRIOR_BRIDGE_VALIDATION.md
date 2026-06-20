# Vehicle And MechWarrior Bridge Validation

## Purpose

Validate that issue `#23` moved vehicle and MechWarrior lookup from placeholder-level routing to draft source-reviewed routing without importing full Classic BattleTech tactical rules into this workspace.

## Source Scope

- A Time of War PDF pages 142-154 / printed pages 140-152: skill-use guidance, Driving, Gunnery, Piloting, subskills, target numbers, linked attributes, and routine-use guidance.
- A Time of War PDF pages 202-227 / printed pages 200-225: tactical-combat addendum, vehicle-versus-infantry boundary, skill conversion, action sequence, movement, vehicular combat, heat, damage bridges, and Special Pilot Abilities.
- A Time of War PDF pages 323-327 / printed pages 321-325: personal vehicles and fuel.
- A Time of War PDF pages 108-130 / printed pages 106-128: vehicle, equipment, property, rank, and access traits relevant to vehicles and MechWarrior status.

## Lookup Tests

### Vehicle Skill Scene

Prompt: "A PC races a hovercar through rough streets while trying to shake a tail."

Route: `indexes/task-router.md` -> `rules/vehicles-and-mechs/overview.md` -> `rules/vehicles-and-mechs/piloting.md` or `rules/core/skill-checks.md` depending on vehicle category.

Result: Pass with caveat. The summaries route routine ground and surface vehicles to Driving, not Piloting, and use core skill checks for the risky action. Exact vehicle performance and terrain modifiers remain source or tactical-tool lookups.

### MechWarrior Skill Prompt

Prompt: "A MechWarrior needs pilot and gunnery notes before a tabletop encounter."

Route: `indexes/task-router.md` -> `rules/vehicles-and-mechs/mechwarrior-skills.md` -> `rules/vehicles-and-mechs/converting-to-classic-battletech.md`.

Result: Pass. The summaries identify Piloting and Gunnery subskills, support roles, conversion direction, and the need to record assumptions without building a full unit record.

### Tactical Combat Handoff

Prompt: "A lance fight starts and exact facing, heat, armor locations, and weapon ranges matter."

Route: `indexes/task-router.md` -> `gm/switch-to-classic-battletech.md` -> `gm/encounter-template.md`.

Result: Pass. The GM handoff remains the authority for Classic BattleTech, MegaMek, or MekHQ setup, while the vehicle summaries provide only the RPG-side skill and conversion notes needed for setup.

### Battle Armor Boundary

Prompt: "A battlesuit trooper fires at infantry, then is targeted by a BattleMech."

Route: `indexes/task-router.md` -> `rules/vehicles-and-mechs/overview.md`, `rules/vehicles-and-mechs/gunnery.md`, and `gm/switch-to-classic-battletech.md`.

Result: Pass with caveat. The summaries preserve the source distinction that battle armor can use personal-combat handling against infantry but vehicular handling against vehicle-scale opponents. Exact battle armor weapon conversion remains a source lookup.

### Vehicle Asset Save

Prompt: "The campaign gains a hovertruck and needs to record it."

Route: `indexes/task-router.md` -> `rules/vehicles-and-mechs/overview.md` -> active `campaigns/<campaign-id>/assets.md`.

Result: Pass. The summary tells the GM what asset facts to record. No dedicated vehicle sheet is introduced yet.

## Validator Decision

Do not update `scripts/validate-campaign-state.ps1` for issue `#23`.

Reason: this issue adds rules routing and GM handoff guidance, but it does not add, remove, or rename required campaign save files. Vehicle and unit assets should remain in active campaign `assets.md` until real play proves that dedicated vehicle or unit sheets are needed.

Future candidate: add a companion vehicle/asset validator only after the campaign has real vehicle records with stable required fields such as owner, location, condition, crew, fuel, legal status, debt, and tactical handoff notes.

## Copyright Boundary

All committed summaries are paraphrased procedural guidance with page references. Exact vehicle tables, Special Pilot Ability entries, tactical modifiers, damage conversion tables, fuel values, and unit stats remain in the private source pages or external BattleTech tools.

## Status

Issue `#23` validation pass. Vehicle and MechWarrior bridge summaries are draft, routed, and source-referenced, not verified full tactical rules.
