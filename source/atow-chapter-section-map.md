# A Time Of War Chapter And Section Map

## Status

- Mapping issue: GitHub issue `#4`
- Mapping date: 2026-06-20
- Source text: ignored private files under `source/atow-text/page-####.txt`
- Scope: mapping only; no GM-ready rule summaries are included here.
- Copyright boundary: topic labels, paraphrased mapping abstracts, page ranges, and candidate future summary targets only.

## Page Offset

- Numbered interior pages use a consistent offset: `PDF page = printed page + 2`.
- Example checks:
  - PDF page 18 contains printed page 16 material.
  - PDF page 40 contains printed page 38 material.
  - PDF page 388 contains printed page 386 material.
- Front matter before printed page 1 and advertising/back-cover matter after the main book should be cited by PDF page only unless source review needs a different convention.

## Extraction Quality Notes

- The page text is usable for chapter and section mapping.
- The table of contents spans PDF pages 4-6 and provides reliable high-level boundaries.
- Many rules pages use multi-column layout; section starts are generally visible, but detailed table-heavy rules should be marked `Needs source review` during summary authoring.
- Equipment, tactical combat, special-case rules, GM rewards, ranks, and reference tables include table-heavy material. Future summaries should cite those pages without reproducing tables.
- Some front matter and fiction pages have minimal or narrative-only text and are not candidate rule-summary targets.

## Candidate Section Map

| Stable section ID | Chapter or subsystem | Topic label / mapping abstract | PDF page range | Printed page range | Extraction quality | Candidate summary path | Candidate manifest ID | Status |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `atow.front.cover-ad` | Front matter | Cover, title, credits, table of contents, and publishing front matter. Not a rules-summary target. | 1-7 | Unknown | Mixed front matter; TOC usable. | N/A | N/A | mapped |
| `atow.fiction.gathering-players` | Fiction | Opening fiction before setting and rules introduction. | 8-17 | 6-15 | Narrative text; not a rules-summary target. | N/A | N/A | mapped |
| `atow.universe.welcome` | The Universe Before You | RPG orientation, table roles, needed materials, and introductory play expectations. | 18-23 | 16-21 | Usable prose; low table density. | `rules/universe/intro-to-play.md` | `universe.intro-to-play` | mapped |
| `atow.universe.factions-history` | The Universe Before You | Major factions, historical eras, and setting context for campaign orientation. | 23-29 | 21-27 | Usable prose; setting-heavy. | `rules/universe/factions-and-history.md` | `universe.factions-history` | mapped |
| `atow.universe.glossary` | The Universe Before You | Introductory universe glossary and setting terminology reference. | 30-32 | 28-30 | Reference/list material; use for terminology only. | `indexes/term-glossary.md` | `universe.glossary-source-map` | needs source review |
| `atow.universe.product-line` | The Universe Before You | How A Time of War relates to other BattleTech books, fiction, maps, and tactical tools. | 33-34 | 31-32 | Usable prose; route tactical detail elsewhere. | `gm/battletech-source-handoff.md` | `gm.battletech-source-handoff` | needs source review |
| `atow.universe.rules-posture` | The Universe Before You | Rules-selection and GM adjudication posture. | 35 | 33 | Short section; source review needed before using live. | `gm/rules-adjudication-posture.md` | `gm.rules-adjudication-posture` | needs source review |
| `atow.basic.characters` | Basic Gameplay | Character sheet concepts, attributes, traits, skills, personal/combat/vehicle data. | 36-39 | 34-37 | Usable overview; some cross-reference density. | `rules/core/character-record-basics.md` | `core.character-record-basics` | mapped |
| `atow.basic.actions-overview` | Basic Gameplay | When dice are used, attribute checks versus skill checks, and action-check framing. | 40 | 38 | Core rules text; summary author should review carefully. | `rules/core/action-checks.md` | `core.action-checks` | mapped |
| `atow.basic.attribute-checks` | Basic Gameplay | Single-attribute and double-attribute checks. | 40-41 | 38-39 | Core rules text with examples. | `rules/core/attribute-checks.md` | `core.attribute-checks` | mapped |
| `atow.basic.skill-checks` | Basic Gameplay | Skill checks, linked attributes, trained/untrained use, and target numbers. | 41 | 39 | Core rules text; compact. | `rules/core/skill-checks.md` | `core.skill-checks` | mapped |
| `atow.basic.opposed-actions` | Basic Gameplay | Contests between actors and opposed-action resolution. | 41-42 | 39-40 | Core rules text; summary target for issue `#5`. | `rules/core/opposed-actions.md` | `core.opposed-actions` | mapped |
| `atow.basic.action-resolution` | Basic Gameplay | Basic action resolution, modifiers, margin of success/failure, and related check outcome concepts. | 42-44 | 40-42 | Core rules text with tables/examples; table reproduction prohibited. | `rules/core/basic-action-resolution.md` | `core.basic-action-resolution` | mapped |
| `atow.basic.edge` | Basic Gameplay | Edge use in basic play. | 44-45 | 42-43 | Short rules section; needs careful source review. | `rules/core/edge.md` | `core.edge` | needs source review |
| `atow.fiction.calm-before` | Fiction | Fiction bridge before character creation. | 46-49 | 44-47 | Narrative text; not a rules-summary target. | N/A | N/A | mapped |
| `atow.creation.overview` | Character Creation | Character concept, creation basics, points-only option, prerequisites, and experience accumulation. | 50-53 | 48-51 | Usable prose; multiple cross-references. | `rules/character-creation/overview.md` | `character.creation-overview` | mapped |
| `atow.creation.life-modules` | Character Creation | Life-module stages, affiliations, childhood, education, and real-life modules. | 54-84 | 52-82 | Long, list-heavy module material; future summaries should avoid copying entries. | `rules/character-creation/life-modules.md` | `character.life-modules` | mapped |
| `atow.creation.skill-fields` | Character Creation | Skill-field and module selections connected to life paths. | 84-87 | 82-85 | Dense structured material; needs source review. | `rules/character-creation/skill-fields.md` | `character.skill-fields` | needs source review |
| `atow.creation.purchasing` | Character Creation | Buying attributes, traits, skills, additional experience, optional point design, and worked purchasing examples. | 87-92 | 85-90 | Table/example heavy; cite pages, do not reproduce tables or worked text. | `rules/character-creation/purchasing-character-elements.md` | `character.purchasing-elements` | needs source review |
| `atow.creation.final-touches` | Character Creation | Defining features, background, equipment, and sample-character handoff. | 93-103 | 91-101 | Mixed prose and examples; sample characters are not summary targets. | `rules/character-creation/final-touches.md` | `character.final-touches` | mapped |
| `atow.fiction.mission-begins` | Fiction | Fiction bridge before traits. | 104-107 | 102-105 | Narrative text; not a rules-summary target. | N/A | N/A | mapped |
| `atow.traits.overview` | Traits | Trait point concepts, vehicle traits, positive/negative/flexible traits, multiple traits, opposing traits, and variable levels. | 108-109 | 106-107 | Usable overview; connects to many descriptions. | `rules/traits/overview.md` | `traits.overview` | mapped |
| `atow.traits.descriptions` | Traits | Individual trait descriptions and vehicle-trait reference material. | 110-137 | 108-135 | Long catalog/table material; future summaries should group by use case, not copy entries. | `rules/traits/trait-catalog-map.md` | `traits.catalog-map` | needs source review |
| `atow.fiction.securing-lz` | Fiction | Fiction bridge before skills. | 138-141 | 136-139 | Narrative text; not a rules-summary target. | N/A | N/A | mapped |
| `atow.skills.overview` | Skills | Skill overview, skill use, linked attributes, target numbers, complexity, subskills, specialties, and tiered skills. | 142-143 | 140-141 | Core skill reference; suitable for lookup summary. | `rules/skills/overview.md` | `skills.overview` | mapped |
| `atow.skills.catalog` | Skills | Individual skill descriptions from Acrobatics through Zero-G Operations. | 143-161 | 141-159 | Long catalog; group or route by common play trigger. | `rules/skills/skill-catalog-map.md` | `skills.catalog-map` | needs source review |
| `atow.fiction.recon` | Fiction | Fiction bridge before personal combat. | 162-165 | 160-163 | Narrative text; not a rules-summary target. | N/A | N/A | mapped |
| `atow.combat.turn-overview` | Combat | Personal combat overview and turn structure. | 166 | 164 | Core combat setup. | `rules/combat/personal-combat-overview.md` | `combat.personal-overview` | mapped |
| `atow.combat.initiative` | Combat | Personal combat initiative, group/squad/team initiative, modifiers, and holding action. | 166-168 | 164-166 | Rules-dense; summary target for personal combat issue. | `rules/combat/initiative.md` | `combat.initiative` | mapped |
| `atow.combat.action-movement` | Combat | Action phase, movement modes, terrain/encumbrance, previous movement, and command cohesion. | 168-172 | 166-170 | Rules and modifier dense. | `rules/combat/action-and-movement.md` | `combat.action-movement` | mapped |
| `atow.combat.ranged` | Combat | Ranged combat resolution, attack rolls, line of sight, modifiers, and special effects. | 173-176 | 171-174 | Table/modifier heavy; cite pages. | `rules/combat/ranged-combat.md` | `combat.ranged` | needs source review |
| `atow.combat.melee` | Combat | Melee combat rolls, limits, range/line of sight, modifiers, and special effects. | 177-179 | 175-177 | Table/modifier heavy; cite pages. | `rules/combat/melee-combat.md` | `combat.melee` | needs source review |
| `atow.combat.damage-resolution` | Combat | Damage notation, standard/fatigue damage, ranged/melee damage, continuous damage, falling damage, and fatigue. | 179-184 | 177-182 | Rules and table heavy. | `rules/combat/damage-resolution.md` | `combat.damage-resolution` | needs source review |
| `atow.combat.damage-effects` | Combat | Injury, fatigue, consciousness, bleeding, death, tactical kill, stun, and trait interactions. | 184-187 | 182-185 | Rules-dense; important for live play. | `rules/combat/damage-effects.md` | `combat.damage-effects` | needs source review |
| `atow.combat.armor-barriers` | Combat | Armor/barrier types, AP vs. BAR, degradation, and stacked armor. | 187-190 | 185-188 | Table-heavy; cite pages. | `rules/combat/armor-and-barriers.md` | `combat.armor-barriers` | needs source review |
| `atow.combat.end-phase` | Combat | End phase, bleeding/continuous damage/fatigue, extended actions, and automatic events. | 191 | 189 | Compact but rules-dense. | `rules/combat/end-phase.md` | `combat.end-phase` | mapped |
| `atow.combat.optional-rules` | Combat | Morale, hit locations, knockdown, lethality reduction. | 191-194 | 189-192 | Optional and table-heavy. | `rules/combat/optional-personal-combat.md` | `combat.optional-personal` | needs source review |
| `atow.combat.healing-recovery` | Combat | General healing, normal healing, assisted healing, and surgery. | 194-197 | 192-195 | Rules-dense; important for campaign consequences. | `rules/combat/healing-and-recovery.md` | `combat.healing-recovery` | mapped |
| `atow.fiction.heavy-artillery` | Fiction | Fiction bridge before tactical combat addendum. | 198-201 | 196-199 | Narrative text; not a rules-summary target. | N/A | N/A | mapped |
| `atow.tactical.overview` | Tactical Combat Addendum | Tactical combat scope and vehicular versus infantry unit framing. | 202-203 | 200-201 | Bridge to BattleTech tactical systems. | `rules/tactical/tactical-combat-overview.md` | `tactical.overview` | mapped |
| `atow.tactical.turn-initiative` | Tactical Combat Addendum | Tactical combat turn, initiative phase, tactical action sequence, and action resolution. | 204-207 | 202-205 | Rules-dense; tactical handoff should remain explicit. | `rules/tactical/tactical-turn-and-initiative.md` | `tactical.turn-initiative` | needs source review |
| `atow.tactical.action-vehicles` | Tactical Combat Addendum | Tactical action phase, movement actions, vehicular combat, and weapon damage conversion. | 208-213 | 206-211 | Dense tactical material; route full tactical play to Classic BattleTech/MegaMek/MekHQ. | `rules/tactical/vehicle-actions.md` | `tactical.vehicle-actions` | needs source review |
| `atow.tactical.margin-traits-armor` | Tactical Combat Addendum | Margin of success/failure in tactical combat, vehicular weapon traits, battle armor weapons, pilot/MechWarrior damage, and physical attacks. | 214-220 | 212-218 | Table-heavy and cross-system. | `rules/tactical/tactical-damage-and-traits.md` | `tactical.damage-traits` | needs source review |
| `atow.tactical.heat-pilot-abilities` | Tactical Combat Addendum | Heat, gunnery abilities, piloting abilities, and miscellaneous special pilot abilities. | 220-227 | 218-225 | Cross-system and table-heavy. | `rules/tactical/heat-and-pilot-abilities.md` | `tactical.heat-pilot-abilities` | needs source review |
| `atow.fiction.journey` | Fiction | Fiction bridge before special-case rules. | 228-231 | 226-229 | Narrative text; not a rules-summary target. | N/A | N/A | mapped |
| `atow.special.planetary-conditions` | Special Case Rules | Planetary conditions, movement modifiers, terrain, weather, exotic conditions, and gravity. | 232-240 | 230-238 | Modifier/table heavy. | `rules/special/planetary-conditions.md` | `special.planetary-conditions` | source reviewed for issue `#92`; exact tables remain private lookup |
| `atow.special.creatures` | Special Case Rules | Creature encounters, attributes, skills, combat, compendium entries, and creature table. | 240-247 | 238-245 | Catalog/table heavy. | `rules/special/creatures.md` | `special.creatures` | source reviewed for issue `#92`; exact catalog/stat blocks remain private lookup |
| `atow.special.diseases` | Special Case Rules | Disease medical maintenance and random disease effects. | 247-251 | 245-249 | Table-heavy. | `rules/special/diseases.md` | `special.diseases` | source reviewed for issue `#92`; exact disease tables remain private lookup |
| `atow.fiction.storming-objective` | Fiction | Fiction bridge before equipment. | 252-255 | 250-253 | Narrative text; not a rules-summary target. | N/A | N/A | mapped |
| `atow.equipment.overview-acquisition` | Equipment | Equipment overview, supply and demand, ratings, acquiring gear, using equipment, equipment data, and repairs. | 256-261 | 254-259 | Rules and table heavy; important for gear lookup. | `rules/equipment/acquiring-and-using-gear.md` | `equipment.acquire-use` | mapped |
| `atow.equipment.weapons` | Equipment | Melee/archaic weapons, small arms, support weapons, explosives, ammunition, weapon accessories, and weapon table continuations. | 262-288 | 260-286 | Large catalog; future summaries should group by use case and cite tables. | `rules/equipment/weapons-map.md` | `equipment.weapons-map` | needs source review |
| `atow.equipment.armor-protection` | Equipment | Personal protective equipment, armor types, accessories, kits, hostile environment gear, stealth gear, and non-combat attire. | 289-300 | 287-298 | Catalog/table heavy. | `rules/equipment/personal-protection.md` | `equipment.personal-protection` | needs source review |
| `atow.equipment.battle-armor-exoskeletons` | Equipment | Battle armor, exoskeletons, and related special game rules. | 300-302 | 298-300 | Cross-system and table-heavy. | `rules/equipment/battle-armor-and-exoskeletons.md` | `equipment.battle-armor-exoskeletons` | needs source review |
| `atow.equipment.electronics` | Equipment | Communications, audio/video/trideo equipment, computers, surveillance gear, optics, and remote sensors. | 302-307 | 300-305 | Catalog/table heavy. | `rules/equipment/electronics.md` | `equipment.electronics` | needs source review |
| `atow.equipment.power-misc-health` | Equipment | Power packs, rechargers, miscellaneous gear, health care, medical equipment, and health-care table continuations. | 308-315 | 306-313 | Catalog/table heavy. | `rules/equipment/power-misc-health.md` | `equipment.power-misc-health` | needs source review |
| `atow.equipment.prosthetics-implants` | Equipment | Prosthetics, limb/organ replacements, elective implants, and related special rules. | 316-320 | 314-318 | Rules-dense and sensitive; needs careful source review. | `rules/equipment/prosthetics-and-implants.md` | `equipment.prosthetics-implants` | needs source review |
| `atow.equipment.drugs-poisons` | Equipment | Drugs, poisons, and related special rules. | 319-323 | 317-321 | Table-heavy; source review required. | `rules/equipment/drugs-and-poisons.md` | `equipment.drugs-poisons` | needs source review |
| `atow.equipment.personal-vehicles-fuel` | Equipment | Personal vehicles, fuel, and equipment-section continuation before the next fiction bridge. | 323-327 | 321-325 | Catalog/table and transition material. | `rules/equipment/personal-vehicles.md` | `equipment.personal-vehicles` | needs source review |
| `atow.fiction.burnout` | Fiction | Fiction bridge before gamemastering guide. | 328-331 | 326-329 | Narrative text; not a rules-summary target. | N/A | N/A | mapped |
| `atow.gm.advancement` | Gamemastering Guide | Rewards, character advancement, aging, attributes, traits, skills, training, downtime, wealth/property, and rank/power. | 332-338 | 330-336 | Tables and campaign procedures; do not reproduce tables. | `rules/campaign/advancement-and-rewards.md` | `campaign.advancement-rewards` | source reviewed for issue `#91`; exact tables remain private lookup |
| `atow.gm.npcs-encounters` | Gamemastering Guide | NPC templates, NPC types, and random encounters. | 338-344 | 336-342 | Template/table heavy. | `rules/gamemastering/npcs-and-encounters.md` | `gamemastering.npcs-encounters` | needs source review |
| `atow.gm.tips-stories` | Gamemastering Guide | GM advice, story approaches, plot/sandbox/combined methods, and reminders. | 344-349 | 342-347 | Usable prose; table-light. | `gm/gamemastering-tips.md` | `gm.tips-stories` | mapped |
| `atow.gm.adventure-seeds` | Gamemastering Guide | Adventure seed material. | 349-351 | 347-349 | Mostly scenario prompts; not a rules-summary priority. | `gm/adventure-seeds-map.md` | `gm.adventure-seeds-map` | mapped |
| `atow.gm.power-rank` | Gamemastering Guide | Political and military power, titles, ranks, and Clan social rank references. | 351-360 | 349-358 | Reference/list heavy. | `rules/campaign/power-rank-and-title.md` | `campaign.power-rank-title` | needs source review |
| `atow.gm.universal-aesthetics` | Gamemastering Guide | Worlds, people, politics, technology, and MechWarriors with their machines as campaign flavor tools. | 361-364 | 359-362 | Setting guidance; table-light. | `gm/universal-aesthetics.md` | `gm.universal-aesthetics` | mapped |
| `atow.gm.touring-stars` | Gamemastering Guide | Society, culture, economics, industries, and world-building tour material. | 364-376 | 362-374 | Setting-heavy; not first-line rules lookup. | `gm/touring-the-stars.md` | `gm.touring-stars` | mapped |
| `atow.gm.whistle-stop-tour` | Gamemastering Guide | Example world profiles and campaign location references. | 376-388 | 374-386 | Setting profile material; table-like world facts. | `gm/whistle-stop-tour.md` | `gm.whistle-stop-tour` | mapped |
| `atow.back.index` | Back matter | Index. | 388-402 | 386-400 | Search aid only; not a rules-summary target. | N/A | N/A | mapped |
| `atow.back.record-sheets-tables` | Back matter | Record sheets and reference tables. | 403-409 | 401-407 | Table/image-heavy; source review only. | N/A | N/A | needs source review |
| `atow.back.ad` | Back matter | Back-cover advertising. | 410 | Unknown | Not a rules-summary target. | N/A | N/A | mapped |

## Issue 5 Core Summary Targets

Issue `#5` should start with these mapped sections:

| Candidate manifest ID | Candidate path | Source range |
| --- | --- | --- |
| `core.action-checks` | `rules/core/action-checks.md` | PDF page 40 / printed page 38 |
| `core.attribute-checks` | `rules/core/attribute-checks.md` | PDF pages 40-41 / printed pages 38-39 |
| `core.skill-checks` | `rules/core/skill-checks.md` | PDF page 41 / printed page 39 |
| `core.opposed-actions` | `rules/core/opposed-actions.md` | PDF pages 41-42 / printed pages 39-40 |
| `core.basic-action-resolution` | `rules/core/basic-action-resolution.md` | PDF pages 42-44 / printed pages 40-42 |
| `core.edge` | `rules/core/edge.md` | PDF pages 44-45 / printed pages 42-43 |

## Follow-Up Notes

- Do not treat candidate paths or manifest IDs as live lookup entries until the corresponding summaries are written.
- Future summaries should keep status as `draft` or `needs source review` unless they have been checked against the legally owned source and routed through lookup validation.
- Table-heavy sections should describe what the table is used for and cite the source pages instead of reproducing the table.
