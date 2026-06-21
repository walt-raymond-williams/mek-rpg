# Agent Handoff

## Issue

- GitHub issue: `#58` Add campaign-local session archive helper
- Roadmap entry: Campaign-local session archive helper
- Mode: Project development / automation
- Priority: Convenience work; keep conservative

## Goal

Add a helper that moves or summarizes completed session-log material into `previous-sessions.md` when a campaign log becomes cumbersome.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#58`

Task-specific context:

- `campaigns/README.md`
- `campaigns/_template/session-log.md`
- `campaigns/_template/previous-sessions.md`
- `gm/state-save-checklist.md`
- `scripts/README.md`

## Expected Output

- Conservative helper script and documentation, or a design note if safe automation is not ready.
- Roadmap and task updates.

## Files And Areas

Likely files to read or edit:

- `scripts/archive-campaign-session.ps1` or similar
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `campaigns/README.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
./scripts/validate-campaign-state.ps1
git diff --check
git status --short --branch
```

## Constraints

- Do not silently rewrite narrative state.
- Require explicit campaign id or clear active-campaign handling.
- Test on disposable campaign copies before touching live saves.
- Do not commit unrelated campaign-state changes.

## Acceptance Criteria

- Helper or design requires explicit intent before changing files.
- Completed-session text is preserved and not invented.
- Command and safety behavior are documented.
- Disposable verification is run or blocker recorded.
- Changes are committed and pushed.

## Open Questions

- Should the first version only move exact marked sections, leaving summarization to the LLM?
