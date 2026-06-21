# Agent Handoff

## Issue

- GitHub issue: `#51` Prototype rules route helper
- Roadmap entry: Rules route helper automation
- Mode: Project development / automation
- Priority: After index metadata is stable enough to be useful

## Goal

Prototype a helper that takes a short rules or play prompt and reports likely `indexes/task-router.md` rows, files to read, manifest status, and source-reference warnings.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#51`

Task-specific context:

- `indexes/task-router.md`
- `indexes/manifest.yaml`
- `indexes/page-reference-index.md`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`

## Expected Output

- Completed: added `scripts/route-rules-prompt.ps1` with text and JSON output.
- Completed: added `scripts/test-route-rules-prompt.ps1` and wired it into `scripts/test-all.ps1`.
- Completed: documented the helper and its non-authority boundary in `scripts/README.md` and `docs/current/KNOWN_COMMANDS.md`.
- Completed: updated roadmap and task tracking.

## Files And Areas

Likely files to read or edit:

- `scripts/route-rules-prompt.ps1` or similar
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
./scripts/route-rules-prompt.ps1 "Can I shoot from cover?"
git diff --check
git status --short --branch
```

## Constraints

- Do not read ignored raw source text.
- Do not answer the rule; report candidate routes and warnings.
- Keep matching deterministic and transparent.

## Acceptance Criteria

- Helper reads committed router/index data.
- Helper returns candidate summary files and status/warnings.
- Output tells the agent to read the summaries before ruling.
- Command is documented and smoke-tested.
- Changes are committed and pushed.

## Open Questions

- Resolved for prototype: simple deterministic keyword scoring is enough, with transparent scores and routed files.
