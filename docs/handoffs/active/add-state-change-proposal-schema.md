# Agent Handoff

## Issue

- GitHub issue: `#78`
- Roadmap entry: `docs/current/ROADMAP.md` > Ruling safety and deterministic mechanics maturation
- Mode: Project development
- Priority: P1

## Goal

Define how deterministic helpers propose campaign state changes without silently editing files.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/current/MECHANIC_CONTRACT_SCHEMA.md` if issue `#72` is complete
- `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`
- `docs/current/GM_CONTEXT_PACKET_DESIGN.md`
- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- `campaigns/README.md`
- `gm/state-save-checklist.md`

## Expected Output

- New durable schema doc, likely `docs/current/STATE_CHANGE_PROPOSAL_SCHEMA.md`.
- Examples for RPG memory changes and pending MekHQ hard-ledger intents.
- Roadmap and task state updated.

## Files And Areas

Likely files to read or edit:

- `docs/current/STATE_CHANGE_PROPOSAL_SCHEMA.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/current/MECHANIC_CONTRACT_SCHEMA.md` only if cross-links are needed
- `scripts/README.md` only if future command references are added

## Commands

Useful commands or checks:

```powershell
./scripts/test-all.ps1
git status --short --branch
```

## Constraints

- This issue should define proposals, not automatic file mutation.
- MekHQ hard-ledger facts remain pending intents until user application, save, and re-import confirmation.
- Do not invent exact funds, repairs, injuries, tactical outcomes, or equipment stats.
- Do not copy protected rule text or tables.

## Acceptance Criteria

- Schema covers PCs, NPCs, assets, missions, hooks, relationships, session log, rules gaps, and pending MekHQ actions.
- Schema distinguishes proposed RPG memory from confirmed MekHQ hard-ledger facts.
- Schema includes proposal status, target file/section, evidence label, authority source, approval/application step, and no-hidden-mutation proof.
- Examples include skill-check consequence, opposed-check consequence, injury/damage consequence, equipment loss, and pending MekHQ ledger intent.

## Open Questions

- Whether proposals should use JSON only or allow a Markdown checklist wrapper for human review.
