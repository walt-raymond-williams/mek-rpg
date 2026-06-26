# Rich Character Validator Handoff

## Issue

- GitHub issue: `#124`
- Roadmap entry: Rich PC/NPC character records for play
- Mode: Project development
- Priority: After issues `#121` and `#122`

## Goal

Prototype a focused validator for rich PC/NPC records, or document why implementation remains premature.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- The schema doc produced by issue `#121`
- Template changes from issue `#122`
- `scripts/validate-campaign-state.ps1`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`

## Expected Output

- A companion validator script and tests, or a clear blocker explaining why the schema still lacks stable examples.
- Checks should focus on required headings, unresolved markers, evidence labels, source-boundary warnings, and preservation of RPG memory.
- Documentation for any new command.

## Files And Areas

Likely files to read or edit:

- `scripts/`
- `tests/fixtures/` if fixtures are needed
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
./scripts/test-all.ps1 -Quick
git diff --check
```

## Constraints

- Do not attempt full A Time of War legal-build validation.
- Do not expand the generic campaign-state validator if a focused companion script is cleaner.
- Do not require raw source files or real MekHQ saves.

## Acceptance Criteria

- Validator exists with tests and docs, or blocker is recorded in roadmap/tasks and the issue.
- Protected-source boundaries remain intact.
- Verification is run or a blocker is recorded.

## Open Questions

- Are template fixtures enough, or does this need one real rich character record before implementation?
