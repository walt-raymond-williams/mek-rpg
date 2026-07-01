# Rich Character Records Epic Handoff

## Issue

- GitHub issue: `#120`
- Roadmap entry: Rich PC/NPC character records for play
- Mode: Project development
- Priority: Backlog, issued and ready after current MekHQ API-first playtest work

## Goal

Coordinate the child stories that make concrete PC/NPC records a first-class play aid with A Time of War sheet categories plus LLM-usable roleplaying context.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `rules/core/character-record-basics.md`
- `docs/current/CHARACTER_CREATION_PC_SHEET_RUNTHROUGH.md`
- `docs/current/MEKHQ_PERSONNEL_SHEET_WORKFLOW.md`

## Expected Output

- Keep issues `#121` through `#125` aligned with the roadmap.
- Move completed child handoffs to `docs/handoffs/archive/`.
- Keep durable schema and play guidance in `docs/current/`, `gm/`, and `campaigns/_template/` as appropriate.

## Files And Areas

Likely files to read or edit:

- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/handoffs/active/`
- Child-story files listed in each child handoff

## Commands

Useful commands or checks:

```powershell
git status --short --branch
gh issue view 120 --comments
gh issue list --state open --limit 50
git diff --check
```

## Constraints

- Do not infer A Time of War stats from narrative role, personality, or MekHQ rank.
- Do not copy source character sheet layouts, source sample characters, catalogs, tables, purchased PDFs, raw extracted text, or raw MekHQ payloads.
- Do not edit the MegaMek workspace from this repository.
- Keep PC/NPC records useful for play, not bloated biography archives.

## Acceptance Criteria

- Child stories are completed or clearly blocked with issue comments.
- Roadmap and task state reflect completed children.
- Handoffs are archived when issues complete.
- Verification and protected-source checks are recorded for each child.

## Open Questions

- Which real campaign character should become the first fully rich PC/NPC record once templates exist?
