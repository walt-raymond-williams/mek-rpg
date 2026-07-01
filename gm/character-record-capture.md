# Character Record Capture

Use this during play when a PC or NPC becomes important enough to preserve beyond the current scene. This workflow keeps play moving while making durable character memory available for future sessions.

Related schema: `docs/current/RICH_CHARACTER_RECORD_SCHEMA.md`.

## Capture Levels

### Session Note Only

Use `session-log.md` only when the person is background color or a one-scene mention.

Examples:

- unnamed guard, clerk, passenger, or bystander
- a named person with no likely future scene role
- a roster name imported from MekHQ with no RPG relevance yet

Record only the name or role, scene context, and any immediate consequence.

### Quick Stub

Create or update a compact entry in `pcs.md` or `npcs.md` when the person may recur but does not need a full sheet yet.

Minimum quick stub:

- name and MEK-RPG slug if stable
- role in the scene or campaign
- current location/status
- relationship to PCs
- wants or knows
- secret, uncertainty, or open question if any
- relevant skill/rules route if a roll is likely
- last seen
- evidence label

Use quick stubs for recurring contacts, witnesses, subordinates, rivals, patients, prisoners, recruits, market applicants, patrons, and temporary viewpoint characters.

### Full Rich Record

Expand to the rich template when the person becomes mechanically or dramatically important.

Expansion triggers:

- the person becomes a PC, viewpoint, companion, patron, antagonist, or recurring command figure
- they need A Time of War attributes, traits, skills, Edge, XP, injuries, gear, or source/rules route tracking
- their motives, fears, preferences, secrets, promises, debts, relationships, or portrayal cues will shape future scenes
- a MekHQ-linked status creates RPG play, such as injury, fatigue, assignment, promotion, hiring, firing, market interview, morale pressure, or command tension
- the table needs hidden/GM-only notes separated from player-facing facts

## During-Scene Rule

During an active scene, capture only the smallest durable fact needed to avoid losing continuity. Prefer a quick note such as:

```markdown
- TODO character stub: Name, role, evidence, and why they matter.
```

Finish the immediate player-facing beat first. Expand the character during an end-of-scene or after-play save pass unless the record is needed before the next decision.

## Update Triggers

Update a PC or NPC record when play establishes or changes:

- current location, status, last-seen context, or scene role
- injuries, fatigue, readiness, gear, assets, or unresolved sheet gaps
- goals, motives, fears, preferences, beliefs, decision tendencies, or pressure points
- relationship state, trust, command tension, favors, debts, promises, threats, or obligations
- player-known facts, GM-only secrets, rumors, uncertainty, reveal conditions, or retcons
- speech cues, behavior cues, portrayal notes, tone-profile links, or what to avoid
- MekHQ person id, imported roster facts, assignment, availability, injury/fatigue ledger flags, or discrepancies

Do not invent hard A Time of War stats, exact trait values, skill levels, gear stats, MekHQ roster facts, or tactical unit state. Mark those as `Unknown`, `Needs source lookup`, `Needs user decision`, `Needs GM ruling`, or `Confirmed from MekHQ import` as appropriate.

## Evidence And Visibility

Every durable character update should preserve why the fact is trusted.

Use schema labels such as:

- `Confirmed by user`
- `Confirmed in play`
- `Confirmed from MekHQ import`
- `Confirmed from summary`
- `Confirmed from source reference`
- `Inferred`
- `Unknown`
- `Needs source lookup`
- `Needs user decision`
- `Needs GM ruling`

Separate player-facing facts from GM-only secrets. Do not put hidden motives or unrevealed secrets into a player-facing summary.

## MekHQ-Linked Characters

For linked personnel, match by MekHQ person id before display name. Refresh only the MekHQ-owned roster fields from imports or live query views. Preserve MEK-RPG overlays, motives, secrets, relationships, portrayal notes, and scene memory unless the table changes them.

If a scene implies a hard ledger change, record an item in `pending-mekhq-actions.md` or reference an existing pending item. Do not treat that change as final until a guarded command plus live reread, manual MekHQ action plus saved import, or other supported confirmation verifies it.

## End-Of-Scene Character Memory Check

At the end of a meaningful scene, ask these silently as part of the save pass:

- Did a new person become likely to recur?
- Did an existing PC/NPC gain or lose injury, gear, trust, obligation, leverage, or status?
- Did the scene reveal or create a secret, rumor, motive, fear, preference, or pressure point?
- Did an NPC voice, behavior, command style, or portrayal cue become important enough to reuse?
- Does the fact belong in `pcs.md`/`npcs.md`, `relationships.md`, `hooks.md`, or only `session-log.md`?

If the answer matters for future play, update the structured owner file. If not, leave the detail in the session log.

## State-Change Proposals

When using deterministic helper output, character-memory proposals should use `docs/current/STATE_CHANGE_PROPOSAL_SCHEMA.md`.

Recommended mappings:

- PC injury, readiness, Edge/XP, sheet gaps, or personal gear: `pc_condition`
- NPC location, attitude, motive, secret, status, or portrayal note: `npc_update`
- trust, loyalty, promise, favor, debt, threat, command tension, or family/crew tie: `relationship_update`
- future reveal, returning contact, unresolved pressure, or personal subplot: `hook_update`
- MekHQ hard-ledger implication: `pending_mekhq_action`

Proposals are reviewable notes until applied. Do not allow helper output to mutate campaign files invisibly.

