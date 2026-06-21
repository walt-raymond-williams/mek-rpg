# Agent Handoff

## Issue

- GitHub issue: `#74`
- Roadmap entry: `docs/current/ROADMAP.md` > Ruling safety and deterministic mechanics maturation
- Mode: Project development
- Priority: P0

## Goal

Add fixture-driven route tests for common RPG procedures so routing, manifest statuses, page references, and warnings are covered before resolver work starts.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `indexes/task-router.md`
- `indexes/manifest.yaml`
- `indexes/page-reference-index.md`
- `scripts/route-rules-prompt.ps1`
- `scripts/test-route-rules-prompt.ps1`
- `scripts/test-all.ps1`

## Expected Output

- Fixture-driven route tests, either expanding `scripts/test-route-rules-prompt.ps1` or adding a focused companion test.
- Coverage for common and failure-path prompts.
- Integration into `scripts/test-all.ps1`.

## Files And Areas

Likely files to read or edit:

- `scripts/test-route-rules-prompt.ps1`
- `scripts/test-all.ps1`
- possible fixtures under `tests/fixtures/`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
./scripts/route-rules-prompt.ps1 "Can I shoot from cover?" -Format json
./scripts/test-route-rules-prompt.ps1
./scripts/test-all.ps1
git status --short --branch
```

## Constraints

- Do not answer rules from the route helper.
- Do not read protected raw source text.
- Tests should assert structured route behavior where possible, not brittle prose only.

## Acceptance Criteria

- Tests cover simple check, opposed check, Edge use, initiative, ranged attack, melee attack, damage/wounds, healing/recovery, equipment use, campaign consequence, vehicle/piloting, tactical handoff, ambiguous rule, missing rule, and source-review gap.
- Candidate files, statuses, page-reference behavior, and warnings are checked.
- Verification is run or blocker recorded.

## Open Questions

- Whether to evolve route helper JSON output before adding deeper assertions.
