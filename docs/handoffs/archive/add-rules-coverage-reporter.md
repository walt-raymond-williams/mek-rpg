# Agent Handoff

## Issue

- GitHub issue: `#50` Add rules coverage reporter
- Roadmap entry: Rules coverage reporter automation
- Mode: Project development / automation
- Priority: After issue `#48`, or alongside issue `#49`

## Goal

Add a deterministic report that summarizes rules coverage by subsystem and status so agents can choose the next safe work item.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#50`

Task-specific context:

- `indexes/manifest.yaml`
- `indexes/page-reference-index.md`
- `indexes/task-router.md`
- `rules/`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`

## Expected Output

- Completed: added `scripts/report-rules-coverage.ps1` with text and JSON output.
- Completed: added `scripts/test-report-rules-coverage.ps1` and wired it into `scripts/test-all.ps1`.
- Completed: documented command usage and output shape in `scripts/README.md` and `docs/current/KNOWN_COMMANDS.md`.
- Completed: updated roadmap and task tracking.

## Files And Areas

Likely files to read or edit:

- `scripts/report-rules-coverage.ps1` or similar
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
./scripts/report-rules-coverage.ps1
git diff --check
git status --short --branch
```

## Constraints

- Use committed indexes, manifest, and summaries only.
- Do not read ignored source text or PDFs.
- Output should be useful in plain text, JSON, or both.

## Acceptance Criteria

- Reporter groups coverage by subsystem.
- Reporter distinguishes drafted/routed, validated, placeholder, mapped-only, and needs-source-review where data exists.
- Command is documented and smoke-tested.
- No protected raw source is committed.
- Changes are committed and pushed.

## Open Questions

- Resolved: default to human-readable text with `-Format json` for agent tooling.
