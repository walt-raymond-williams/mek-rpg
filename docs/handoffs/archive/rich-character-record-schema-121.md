# Rich Character Record Schema Handoff

## Issue

- GitHub issue: `#121`
- Roadmap entry: Rich PC/NPC character records for play
- Mode: Project development
- Priority: First child story

## Goal

Define the canonical rich PC/NPC record schema that combines A Time of War sheet fields with LLM-facing personality and portrayal context.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `rules/core/character-record-basics.md`
- `rules/character-creation/overview.md`
- `rules/character-creation/attributes.md`
- `rules/character-creation/traits.md`
- `rules/character-creation/skills.md`
- `docs/current/CHARACTER_CREATION_PC_SHEET_RUNTHROUGH.md`
- `docs/current/MEKHQ_PERSONNEL_SHEET_WORKFLOW.md`

## Expected Output

- A durable schema/design doc under `docs/current/`.
- Field guidance for identity, sheet status, attributes, traits, skills, combat/readiness, inventory/assets, biography, goals, motives, tendencies, preferences, fears, relationships, secrets/uncertainty, speech/behavior cues, portrayal notes, and update history.
- Ownership rules for MekHQ-linked facts versus MEK-RPG overlays.
- A validator-maintenance decision for issue `#124`.

## Files And Areas

Likely files to read or edit:

- `docs/current/`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/handoffs/active/rich-character-record-schema-121.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
git diff --check
```

## Constraints

- Do not copy or recreate the source character sheet layout.
- Do not include copied trait catalogs, skill catalogs, tables, or sample characters.
- Mark unknown stat/rules fields as `Needs source lookup`, `Needs user decision`, or `Unknown`.
- Keep schema guidance compact enough to help live play.

## Acceptance Criteria

- Schema doc exists and is linked from roadmap/task state as needed.
- Source, campaign, and MekHQ ownership boundaries are explicit.
- The doc distinguishes mechanical sheet facts from portrayal and memory fields.
- Verification is run or a blocker is recorded.

## Open Questions

- Should the final schema recommend one combined `pcs.md` / `npcs.md` file per campaign, or allow future per-character files after records become large?
