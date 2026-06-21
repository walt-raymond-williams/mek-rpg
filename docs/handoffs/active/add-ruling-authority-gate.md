# Agent Handoff

## Issue

- GitHub issue: `#80`
- Roadmap entry: `docs/current/ROADMAP.md` > Ruling safety and deterministic mechanics maturation
- Mode: Project development
- Priority: P0

## Goal

Create a deterministic pre-ruling authority gate that tells the agent whether a routed rules answer is usable, provisional, source-lookup-only, externally owned, blocked, or impossible to adjudicate from current committed knowledge.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/current/MECHANIC_CONTRACT_SCHEMA.md` if issue `#72` is complete
- `indexes/task-router.md`
- `indexes/manifest.yaml`
- `indexes/page-reference-index.md`
- `gm/rules-adjudication-posture.md`
- `gm/switch-to-classic-battletech.md`
- `scripts/route-rules-prompt.ps1`

## Expected Output

- New documentation, likely `docs/current/RULING_AUTHORITY_GATE.md`.
- New helper, likely `scripts/check-ruling-authority.ps1`.
- New tests, likely `scripts/test-check-ruling-authority.ps1`.
- Command documentation and `scripts/test-all.ps1` integration.

## Files And Areas

Likely files to read or edit:

- `docs/current/RULING_AUTHORITY_GATE.md`
- `scripts/check-ruling-authority.ps1`
- `scripts/test-check-ruling-authority.ps1`
- `scripts/test-all.ps1`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `gm/rules-adjudication-posture.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
./scripts/route-rules-prompt.ps1 "BattleMech heat and tactical movement" -Format json
./scripts/validate-rules-indexes.ps1
./scripts/test-all.ps1
git status --short --branch
```

## Constraints

- The helper must not answer rules or reproduce protected source text.
- The helper must not read ignored raw source paths.
- The helper must not silently mutate campaign files.
- Tactical and MekHQ hard-ledger cases must route to external authority instead of being resolved.

## Acceptance Criteria

- Authority statuses include `authoritative`, `provisional`, `source lookup required`, `external authority required`, `cannot adjudicate`, and `blocked / missing route`.
- Draft, source-reviewed-routing-aid, mapped-only, partial-draft, source-lookup-only, needs-source-review, missing route, and tactical handoff cases are covered.
- Output includes routed files, manifest IDs/statuses, source/page references, warnings, and required next action.
- Tests are integrated into `scripts/test-all.ps1`.

## Open Questions

- Whether the helper should consume route-helper JSON directly or re-parse indexes independently.
