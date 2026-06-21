# Agent Handoff

## Issue

- GitHub issue: `#55` Add tactical encounter handoff checklist
- Roadmap entry: Tactical encounter handoff from campaign save
- Mode: Project development / GM workflow
- Priority: Useful before Atlas Field reaches detailed tactical combat

## Goal

Add a lightweight checklist for preparing a Classic BattleTech, MegaMek, or MekHQ encounter from an active MEK-RPG campaign save when tactical combat matters.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#55`

Task-specific context:

- `gm/switch-to-classic-battletech.md`
- `gm/mission-template.md`
- `gm/state-save-checklist.md`
- `rules/vehicles-and-mechs/converting-to-classic-battletech.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`

## Expected Output

- New or updated GM handoff checklist.
- Links from existing tactical handoff guidance.
- Roadmap and task updates.

## Files And Areas

Likely files to read or edit:

- `gm/tactical-encounter-handoff-checklist.md` or similar
- `gm/switch-to-classic-battletech.md`
- `gm/README.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
rg -n "Classic BattleTech|MegaMek|MekHQ|tactical handoff|encounter" gm rules docs campaigns
git diff --check
git status --short --branch
```

## Constraints

- Do not implement tactical combat rules in MEK-RPG.
- Do not write MekHQ saves or imply direct writeback.
- Keep this as a prep and return-to-campaign checklist.

## Acceptance Criteria

- Checklist covers forces, pilots, skills, unit state, terrain, objectives, deployment, withdrawal, salvage, and return updates.
- Detailed tactical resolution routes to Classic BattleTech, MegaMek, or MekHQ.
- Post-encounter campaign updates are explicit.
- Existing GM docs link to the checklist.
- Changes are committed and pushed.

## Open Questions

- Should MekHQ-linked campaigns have a separate subsection for scenario IDs and re-import checkpoints?
