# Agent Handoff

## Issue

- GitHub issue: `#54` Design richer DropShip and unit asset sheet schema
- Roadmap entry: Richer DropShip and unit asset sheets
- Mode: Project development / campaign state design
- Priority: After issue `#53`, unless clearly marked provisional

## Goal

Design campaign-local asset sheet fields for DropShips, large vehicles, and unit-level assets without hard-coding unsupported logistics rules.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#54`

Task-specific context:

- Issue `#52` and `#53` outputs if complete
- `campaigns/README.md`
- `campaigns/_template/assets.md`
- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `gm/state-save-checklist.md`

## Expected Output

- Asset schema design doc or template updates.
- Validator implications recorded.
- Roadmap and task updates.

## Files And Areas

Likely files to read or edit:

- `campaigns/README.md`
- `campaigns/_template/assets.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- New `docs/current/` design note if needed

## Commands

Useful commands or checks:

```powershell
rg -n "asset|DropShip|vehicle|MekHQ|ownership|condition|liens|repairs" campaigns docs gm rules
./scripts/validate-campaign-state.ps1
git diff --check
```

## Constraints

- Keep MekHQ-owned hard ledger facts separate from MEK-RPG overlays.
- Mark provisional fields clearly if rules coverage is incomplete.
- Do not commit real MekHQ save payloads or protected source text.

## Acceptance Criteria

- Fields cover identity, ownership evidence, crew, condition, location, debts/liens, hooks, and MekHQ references where applicable.
- Confirmed hard facts are distinguished from RPG narrative memory.
- Template or documentation is updated, or a reason is recorded for deferral.
- Validator follow-up is recorded if structure changes.
- Changes are committed and pushed.

## Open Questions

- Should large assets remain one Markdown file, or should future linked campaigns split assets into per-asset records?
