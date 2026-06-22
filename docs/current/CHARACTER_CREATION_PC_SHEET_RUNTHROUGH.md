# Character Creation And PC Sheet Run-Through

## Scope

- Issue: `#98`
- Mode: Project development / manual validation.
- Uses committed character-creation summaries, character-record guidance, routing aids, and the campaign save model.
- Protected source PDFs, extracted source text, copied lifepath/module entries, trait catalogs, skill lists, XP tables, and sample characters were not read or reproduced.

## Route Check

Start from `indexes/task-router.md`:

- Character creation, starting a PC, building a unique NPC, or reviewing a character sheet routes to `rules/character-creation/overview.md`.
- Reviewing a character sheet routes to `rules/core/character-record-basics.md`.
- Lifepath/module choices route to `rules/character-creation/lifepaths.md`.
- Skill fields route to `rules/character-creation/skill-fields.md`.
- Final spending and cleanup route to `rules/character-creation/purchasing-character-elements.md`.
- Exact trait and skill catalog details route through `rules/traits/trait-catalog-map.md` and `rules/skills/skill-catalog-map.md`, then to private source lookup when exact values matter.

## Original PC-Style Record Walk-Through

This is a sheet-shape rehearsal only, not a legal finished A Time of War build.

### Candidate Record: Rin Varela

#### Identity

- Player: `Needs user decision`
- Concept: Periphery salvage technician and cautious vehicle operator.
- Campaign role: technical problem solver, salvage appraiser, local guide, backup driver.
- Affiliation/home: `Needs user decision`; likely Periphery or mercenary-adjacent.
- Creation method: `Needs user decision`; Life Modules preferred if the table wants background hooks, points-only acceptable for a fast playtest PC.

#### Attributes

- Strength: `Needs source lookup`
- Body: `Needs source lookup`
- Reflexes: `Needs source lookup`
- Dexterity: `Needs source lookup`
- Intelligence: `Needs source lookup`
- Willpower: `Needs source lookup`
- Charisma: `Needs source lookup`
- Edge: `Needs source lookup`
- XP stored toward attributes: `Unknown`

#### Traits

- Possible trait hooks: salvage contacts, vehicle access, debt, reputation, obligation, or enemy.
- Required recording shape: trait name, sign, trait points, descriptor, page reference, active/incomplete status, and campaign hook.
- Exact trait entries, values, restrictions, and opposed-trait cleanup remain private source lookup.

#### Skills

- Likely skills to verify from source: Technician subskill, Appraisal or relevant trade skill, Driving/Ground Vehicle, Perception, possible Security Systems or Computers.
- Required recording shape: exact skill/subskill, level, specialty if any, linked attributes, target number/complexity, XP stored toward next level, and page reference.
- Exact skill metadata and XP costs remain private source lookup.

#### Combat And Readiness

- Current condition: Uninjured unless campaign state says otherwise.
- Fatigue/stun/bleeding/unconscious: `None recorded`
- Movement/combat values: `Needs source lookup if combat is expected`
- Armor and ready weapons: `Needs equipment source lookup or campaign issue`
- Tactical vehicle/BattleMech data: external authority if unit-scale tactical combat matters.

#### Inventory And Assets

- Important gear: toolkit, diagnostic gear, travel kit, and personal weapon are plausible but unconfirmed.
- Asset links: any owned or assigned vehicle belongs in campaign `assets.md` once confirmed.
- Exact item stats, legality, availability, and costs remain source lookup.

#### Biography And Campaign Hooks

- Hook candidates: unpaid salvage lien, former employer, recovered memory core, family obligation, or disputed vehicle title.
- Relationships: `Needs user decision`
- Open sheet questions: creation method, affiliation, allowed era, starting XP, trait choices, exact skills/subskills, starting equipment, vehicle access, and campaign fit.

## Findings

- The committed summaries are enough to review a PC record shape and identify owner files without copying source material.
- The campaign save model can hold a compact Markdown PC record, but the template needed more specific character-record fields.
- A deterministic validator should not be added yet. The project still lacks at least one real completed PC sheet with stable table preferences, exact legal build data, and campaign-specific fields.
- A future validator should wait until real PC entries show repeated structure. It should check required headings and unresolved markers before checking build legality.

## Fixes Made

- Expanded `campaigns/_template/pcs.md` so new campaign saves prompt for identity, creation status, attributes, traits, skills, combat/readiness, inventory/assets, biography hooks, and open sheet questions.
- Kept MekHQ-linked PC overlay ownership separate from the ordinary A Time of War overlay.

## Follow-Up Decision

No new GitHub issue was created during this run-through. The validator need remains conditional on real PC sheets, and that condition is already tracked in the roadmap and task backlog.

