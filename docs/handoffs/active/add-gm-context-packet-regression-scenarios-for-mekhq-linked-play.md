# Agent Handoff

## Issue

- GitHub issue: `#45` Add GM context packet regression scenarios for MekHQ-linked play
- Parent epic: `#38`
- Related epic: `#30` GM context architecture
- Roadmap entry: Automated regression coverage for MekHQ-linked A Time of War workflow
- Mode: Project development / regression scenarios
- Priority: Blocked until issue `#31` defines context packet design and likely issue `#33` creates a helper to test.

## Goal

After context packet design exists, add regression scenarios that verify context assembly preserves MekHQ/MEK-RPG authority boundaries and uses pending actions correctly.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issues `#30`, `#31`, `#33`, `#38`, `#39`, and `#45`
- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/handoffs/active/define-gm-context-packet-design.md`

## Expected Output

- Scenario fixtures and deterministic checks for GM context packet behavior.
- Documentation updates and test runner integration if `scripts/test-all.ps1` exists.

## Files And Areas

Likely files to read or edit after dependencies exist:

- GM context design/helper files from issues `#31` and `#33`
- `tests/fixtures/`
- `scripts/test-gm-context-packet.ps1` or equivalent
- `scripts/test-all.ps1` if present
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
rg "context packet|pending-mekhq-actions|mekhq-bridge" docs gm scripts campaigns
./scripts/test-all.ps1
git diff --check
```

## Constraints

- Do not start this issue until context packet design exists.
- Pending MekHQ actions must be labeled as intents/manual checklists, not confirmed hard facts.
- Do not invent rules or MekHQ ledger state in fixtures.
- Do not process protected source material.

## Acceptance Criteria

- Context includes latest bridge metadata and unresolved pending actions.
- Pending MekHQ actions are labeled as intents/manual checklists, not confirmed hard facts.
- Structured campaign state takes precedence over stale narrative summaries.
- Rules routes are referenced without inventing rules.
- Protected source/no-writeback boundaries are preserved.
- Scenarios cover continuity, stale-memory avoidance, and tactical handoff triggers.
- Verification is run or blocker recorded.
- Changes are committed and pushed.

## Open Questions

- Which context packet helper output format should become the stable test target?
