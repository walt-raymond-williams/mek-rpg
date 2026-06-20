# Create BattleTech Campaign Setting Seed

## Issue

- GitHub issue: https://github.com/walt-raymond-williams/mek-rpg/issues/10
- Roadmap entry: Create BattleTech campaign setting seed
- Mode: Project development
- Priority: Medium
- Status: Ready

## Goal

Create a durable campaign setting seed so live play has stable assumptions for era, faction focus, canon strictness, tone, starting region, and initial scenario hooks.

This should support faction-aware play involving groups such as the Draconis Combine, Magistracy of Canopus, Inner Sphere states, Periphery powers, mercenary units, and other BattleTech setting elements without requiring every session to rediscover context.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `gm/scene-loop.md`
- `gm/roll-policy.md`
- GitHub issue `#10`

## Expected Output

- A campaign setting basics file under `campaign-state/` or `gm/`.
- A lightweight faction/canon policy covering table canon, lookup-needed canon, and improvisable setting color.
- Starter scenario hooks compatible with the project posture.
- Links from relevant GM docs or campaign-state indexes.
- Open choices marked `TBD` or `Needs user decision`.

## Files And Areas

Likely files to read:

- `campaign-state/`
- `gm/`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

Likely files to edit:

- `campaign-state/setting-basics.md` or similar
- `campaign-state/faction-roster.md`, if useful
- `gm/scene-loop.md` or another GM procedure only if a link is needed
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

```powershell
git status --short --branch
```

## Constraints

- Do not copy copyrighted lore text.
- Do not pretend uncertain canon is confirmed; use `TBD`, `Needs user decision`, `Inferred`, or `Needs lookup`.
- Use web lookup only when a precise canon fact is needed for this task. Prefer a fillable local campaign-canon template if user choices are missing.
- Keep the setting seed table-facing and playable, not an encyclopedia.

## Acceptance Criteria

- Correct mode identified as Project development.
- Durable setting seed or fillable campaign-canon template created.
- GM docs or campaign-state files link to the setting seed.
- User choices are marked clearly where needed.
- No copied copyrighted lore text included.
- Roadmap/task state updated and handoff archived.
- Changes committed, pushed, and issue updated/closed.

## Open Questions

- User choices likely needed: era, starting region, main faction pressure, player unit concept, canon strictness, and tone.
