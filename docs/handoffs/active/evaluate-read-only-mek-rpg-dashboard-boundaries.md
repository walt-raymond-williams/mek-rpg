# Agent Handoff

## Issue

- GitHub issue: `#56` Evaluate read-only MEK-RPG dashboard boundaries
- Roadmap entry: Read-only MEK-RPG dashboard future feature
- Mode: Project development / product design
- Priority: Exploratory; do before any UI or data adapter implementation

## Goal

Evaluate a read-only MEK-RPG web dashboard concept focused on campaign visibility, state-audit debugging, NPC/history review, GM context inspection, and optional MekHQ summary display.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#56`

Task-specific context:

- `campaigns/README.md`
- `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`
- `docs/current/GM_CONTEXT_PACKET_DESIGN.md` if issue `#31` is complete
- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`

## Expected Output

- Design/evaluation note under `docs/current/`.
- Recommendation on whether issue `#57` should proceed.
- Roadmap and task updates.

## Files And Areas

Likely files to read or edit:

- `docs/current/READ_ONLY_DASHBOARD_EVALUATION.md` or similar
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
rg -n "dashboard|context packet|campaign save|MekHQ|read-only|writeback" docs campaigns gm scripts
git diff --check
git status --short --branch
```

## Constraints

- No UI implementation in this issue.
- No write controls, live movement controls, direct MekHQ writeback, or Sunnytown-derived surface.
- Keep protected source and raw MekHQ save boundaries explicit.

## Acceptance Criteria

- Defines target users and read-only workflows.
- Identifies data sources and ownership boundaries.
- Explicitly excludes writeback and control actions.
- Lists privacy, protected-source, and MekHQ-save boundaries.
- Recommends whether to proceed to data adapter/API design.

## Open Questions

- Is the first dashboard value GM context inspection, campaign state audit, or session/NPC review?
