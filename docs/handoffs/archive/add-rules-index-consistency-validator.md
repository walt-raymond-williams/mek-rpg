# Agent Handoff

## Issue

- GitHub issue: `#49` Add rules index consistency validator
- Roadmap entry: Rules index validator automation
- Mode: Project development / automation
- Priority: After issue `#48`, unless implementing path-only checks first

## Goal

Add a deterministic validator that checks consistency between task router links, rules map entries, page-reference index entries, manifest IDs, and existing summary files.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#49`

Task-specific context:

- `indexes/task-router.md`
- `indexes/rules-map.md`
- `indexes/page-reference-index.md`
- `indexes/manifest.yaml`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`

## Expected Output

- Completed: added `scripts/validate-rules-indexes.ps1`.
- Completed: added `scripts/test-validate-rules-indexes.ps1` and wired it into `scripts/test-all.ps1`.
- Completed: documented commands in `scripts/README.md` and `docs/current/KNOWN_COMMANDS.md`.
- Completed: updated roadmap and task tracking.

## Files And Areas

Likely files to read or edit:

- `scripts/validate-rules-indexes.ps1` or similar
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
./scripts/validate-rules-indexes.ps1
git diff --check
git status --short --branch
```

## Constraints

- Do not require protected source files, real MekHQ saves, network access, or user interaction.
- Prefer deterministic path and metadata checks over fuzzy interpretation.
- Keep output readable for overnight agents.

## Acceptance Criteria

- Validator exits nonzero on missing linked files.
- Validator reports router links, manifest IDs, or page-reference relationships that are inconsistent.
- Command is documented.
- Verification is run or blocker recorded.
- Changes are committed and pushed.

## Open Questions

- Resolved for now: use PowerShell-only structural parsing so the validator has no extra runtime dependency.
