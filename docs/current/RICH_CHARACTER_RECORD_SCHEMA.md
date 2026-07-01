# Rich Character Record Schema

Status: issue `#121` design baseline.

Purpose: define the canonical MEK-RPG shape for player characters and important NPCs. A rich character record combines the A Time of War character-record categories with campaign memory and LLM-facing portrayal guidance, while preserving MekHQ as the hard roster authority for linked personnel.

This is a schema and ownership guide, not a copied character sheet, legal-build validator, trait catalog, skill catalog, sample character, or tactical unit record.

## Use Cases

Create or expand a rich record when a person is likely to affect play:

- a PC, player viewpoint, or recurring embedded protagonist
- an NPC who speaks on screen, gives orders, creates obligations, carries a secret, or recurs across scenes
- a MekHQ-linked person whose roster status creates RPG scenes, such as injury, fatigue, assignment, hire/fire, promotion, market interview, or morale pressure
- a character expected to make A Time of War rolls, carry personal-scale injuries, spend Edge or XP, use named gear, or anchor relationships

Leave a person as a session-log mention, bridge cross-reference, or roster entry when they are only background color and no durable memory is needed yet.

## Storage Model

Default storage remains campaign-local Markdown:

- PCs live in active `campaigns/<campaign-id>/pcs.md`.
- Important NPCs live in active `campaigns/<campaign-id>/npcs.md`.
- Full rosters, background names, and technical import cross-references can stay in `mekhq-bridge.md` for MekHQ-linked campaigns.

For now, prefer one scan-friendly `pcs.md` and `npcs.md` file per campaign. Future per-character files are acceptable when individual records become too large to scan, but the index file should still list every expanded record and its path.

## Evidence Labels

Use explicit labels when the source of a fact matters:

- `Confirmed by user`: stated directly by the player or table.
- `Confirmed from summary`: grounded in a committed paraphrased rules summary.
- `Confirmed from source reference`: the committed summary points to a private source page, but the exact value still needs private lookup.
- `Confirmed from MekHQ import`: read from a MekHQ API capture, checkpoint export, or documented import.
- `Confirmed in play`: established in a played scene and recorded in campaign state.
- `Inferred`: reasonable from context, but not established enough to become hard fact.
- `Unknown`: deliberately not known.
- `Needs source lookup`: exact A Time of War value, option, or legality must be checked privately.
- `Needs user decision`: table preference, player choice, or campaign-sensitive decision is required.
- `Needs GM ruling`: the GM must decide because committed summaries do not settle it.

Do not smooth `Unknown`, `Inferred`, `Needs source lookup`, or `Needs user decision` into final values.

## Ownership Boundary

### A Time of War Mechanical Overlay

MEK-RPG owns campaign-local A Time of War overlays:

- attributes, Edge, XP, active values, and stored XP toward future increases
- traits, trait signs, descriptors, page references, active/incomplete status, and trait-related hooks
- skills, subskills, specialties, levels, linked attributes, target/complexity notes, page references, and stored XP
- personal-scale condition overlay, wounds, fatigue, stun, bleeding, armor, ready weapons, and important personal gear
- open sheet questions, source lookup needs, and GM rulings

Do not infer these fields from MekHQ rank, role, unit assignment, narrative archetype, personality, or social status.

### MekHQ-Owned Roster Facts

For linked personnel, MekHQ owns hard roster and ledger facts when available:

- MekHQ person id, imported display name, role, rank, faction, assignment, commander flags, and market/employment status
- availability, injury/healing ledger state, fatigue, salary, personnel transaction, hiring/firing, promotion, assignment, and day-advance effects
- hard roster changes confirmed by live API read, command result, saved checkpoint, or supported import

Update only MekHQ-owned fields from MekHQ refreshes. Preserve MEK-RPG overlay, motives, secrets, relationships, and scene memory unless the user or table explicitly changes them.

### MEK-RPG Narrative Overlay

MEK-RPG owns table-facing RPG memory:

- concept, role in the campaign, affiliation or home as used by the table, background hooks, current location, last seen, current status
- goals, motives, fears, preferences, beliefs, loyalties, grudges, promises, debts, obligations, threats, contacts, and relationships
- secrets, rumors, hidden motives, uncertain loyalties, player-facing impressions, and GM-only notes
- speech cues, behavior cues, decision tendencies, portrayal notes, tone constraints, and scene-use notes

Keep hidden or GM-only material clearly marked. Do not expose secrets in player-facing summaries unless play has revealed them.

## Record Sections

### 1. Header And Link

Use this section to identify the record and its authority.

Recommended fields:

- Display name
- MEK-RPG slug
- Record type: `PC`, `viewpoint PC`, `major NPC`, `minor recurring NPC`, `MekHQ-linked PC`, `MekHQ-linked NPC`, or `narrative-only`
- Link status: `unlinked`, `linked`, `market applicant`, `former roster member`, `embedded PC`, `needs confirmation`, or `retired`
- MekHQ person id, if any
- Controlling player, if any
- Last updated
- Last imported, if linked to MekHQ
- Evidence summary
- Player-facing visibility: `player-known`, `GM-only`, or `mixed`

### 2. Identity And Concept

Use this section for table-facing identity, not full biography.

Recommended fields:

- Concept
- Campaign role
- Affiliation, home, unit, family, or culture
- Physical description and obvious tells
- Creation method and status
- Current location
- Current status
- Last seen

### 3. A Time of War Sheet Status

Use this section to keep mechanical readiness visible without reproducing the source sheet layout.

Recommended fields:

- Sheet status: `complete`, `playable draft`, `stub`, `needs source lookup`, `needs user decision`, or `not needed`
- Creation or advancement notes
- XP total, available XP, and stored XP where known
- Open sheet questions
- Source/rules route
- Validator status: `not checked`, `manual checked`, `future validator`, or `blocked`

### 4. Attributes

Record the eight A Time of War attributes when they matter:

- Strength
- Body
- Reflexes
- Dexterity
- Intelligence
- Willpower
- Charisma
- Edge
- Stored XP toward attributes
- Attribute notes, caps, prerequisites, or source lookup needs

Use `Needs source lookup` rather than estimating values.

### 5. Traits

Recommended fields for each trait entry:

- Trait name
- Sign: positive, negative, neutral, or flexible
- Trait points or rating, if known
- Descriptor for identity-based or repeated traits
- Active/incomplete/stored-XP status
- Page reference or lookup route
- Campaign hook or consequence
- Opposed-trait or cleanup notes

Do not copy trait catalog text or table values into the record.

### 6. Skills

Recommended fields for each skill entry:

- Exact skill and subskill
- Specialty, if any
- Level
- Linked attributes, target number, and complexity notes when known
- Active/incomplete/stored-XP status
- Page reference or lookup route
- Training, prerequisite, or advancement notes

Do not merge subskills into broad labels when the source treats them separately.

### 7. Combat And Readiness

Use this section for RPG-scale condition and quick scene readiness.

Recommended fields:

- Current condition
- Wounds or personal-scale injury notes
- Fatigue, stun, bleeding, unconsciousness, or recovery status
- Armor and ready weapons
- Movement or combat data when known
- Personal-scale medical limits
- Tactical unit or assigned asset link
- Handoff route when full BattleTech tactical state matters

MekHQ remains authoritative for linked personnel ledger injury and availability when a supported read is available. MEK-RPG can still track temporary personal-scale overlays until those changes are confirmed or queued as pending MekHQ actions.

### 8. Inventory, Gear, And Assets

Recommended fields:

- Important carried gear
- Armor, weapons, medical kit, tools, electronics, or survival gear
- Gear location or custody
- Controlled assets
- Vehicle or unit links
- Asset sheet references
- Source lookup needs for exact stats, costs, legality, or availability

Do not copy equipment tables or stat blocks. Link to campaign `assets.md` when the item is a meaningful asset.

### 9. Biography And Memory

Keep this useful for scenes rather than exhaustive.

Recommended fields:

- Short background
- Education, career stages, former unit, former employer, or major life events
- Goals
- Motives
- Fears
- Preferences
- Beliefs or principles
- Known limits, lines, or pressure points
- Past choices that should influence future decisions

### 10. Relationships And Obligations

Recommended fields:

- Relationship to PCs
- Relationship to named NPCs
- Relationship to factions, employers, patrons, enemies, dependents, or rivals
- Promises
- Debts
- Favors owed or held
- Threats
- Trust, loyalty, command tension, morale, or reputation notes
- Related records in `relationships.md`, `factions.md`, or `hooks.md`

### 11. Secrets, Uncertainty, And Visibility

Separate hidden facts from player-known facts.

Recommended fields:

- Player-known facts
- GM-only secrets
- Rumors
- Suspicions
- Unverified claims
- Unknowns
- Reveal conditions
- Consequences if revealed

Mark uncertainty explicitly. A secret should not become canon only because it sounds interesting.

### 12. Speech, Behavior, And Portrayal

This is LLM-facing play support, not a script.

Recommended fields:

- Voice or speech cues
- Behavior cues
- Decision tendencies
- Emotional triggers
- Scene functions
- What to avoid when portraying the character
- Tone-profile links, if any
- Example in-world phrasing, original and brief

Keep cues compact enough to use at the table. Do not write long monologues into the record.

### 13. Update History

Recommended fields:

- Date or session
- Changed fields
- Evidence label
- Reason for change
- Source file, import, scene, or issue reference
- Pending follow-up

Update history should explain why a fact changed without becoming a second session log.

## PC And NPC Differences

PC records usually need fuller mechanical tracking: player, Edge, XP, attributes, traits, skills, personal gear, injuries, choices, goals, and advancement notes.

NPC records can stay lighter until the character becomes mechanically active. Important NPCs still need motives, secrets or uncertainty, relationships, scene role, portrayal cues, and any stats or skills required for expected rolls.

Quick NPCs can use a stub:

- name
- role
- current location/status
- wants/knows
- relationship to PCs
- secrets or uncertainty
- relevant skills or rules route if a roll is likely
- last seen

Expand the stub only when play makes the person recurring or mechanically important.

## MekHQ Refresh Rules

For linked personnel:

1. Match by MekHQ person id before display name.
2. Refresh MekHQ-owned roster facts only.
3. Preserve MEK-RPG overlays and RPG memory.
4. If the person disappears from the import, mark `needs confirmation` or `former roster member`; do not delete scene memory.
5. If display name changes but id is stable, keep the MEK-RPG slug stable and record the discrepancy.
6. If a scene changes a hard ledger fact before MekHQ confirms it, record a pending MekHQ action or command verification note.
7. If imported facts conflict with scene memory, MekHQ wins for hard ledger state and MEK-RPG memory remains as the table's account unless retconned.

## Source Boundaries

- Do not copy the source character sheet layout.
- Do not copy trait catalogs, skill catalogs, equipment tables, sample characters, XP tables, or raw extracted source text.
- Do not commit purchased PDFs, raw source text, raw MekHQ saves, raw XML, personal live API captures, secrets, or large raw JSON payload excerpts.
- Use paraphrase, page references, summary links, and lookup routes.
- Mark exact rules values as `Needs source lookup` when not already in committed summaries.

## Validator Decision

Issue `#124` should own validator implementation. This schema is stable enough to support a focused companion validator after issue `#122` updates the templates.

Recommended validator scope:

- required top-level headings for rich PC and NPC entries
- allowed evidence labels and unresolved markers
- warning when linked records mix MekHQ-owned fields into MEK-RPG overlay sections
- warning when hidden/GM-only material lacks a visibility label
- warning when exact rules values appear without a page reference or lookup route
- source-boundary checks for protected paths and raw-source markers

Do not attempt full A Time of War legal-build validation. That would require private source tables, user decisions, and real completed sheets. If issue `#124` lacks stable template fixtures or a real rich record, it should record that blocker and defer code.

## Related Files

- `rules/core/character-record-basics.md`
- `rules/character-creation/overview.md`
- `rules/character-creation/attributes.md`
- `rules/character-creation/traits.md`
- `rules/character-creation/skills.md`
- `docs/current/CHARACTER_CREATION_PC_SHEET_RUNTHROUGH.md`
- `docs/current/MEKHQ_PERSONNEL_SHEET_WORKFLOW.md`
- `campaigns/_template/pcs.md`
- `campaigns/_template/npcs.md`
- `gm/state-save-checklist.md`

