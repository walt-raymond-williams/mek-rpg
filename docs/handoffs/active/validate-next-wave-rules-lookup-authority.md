# Agent Handoff

## Issue

- GitHub issue: `#94`
- Roadmap entry: Next rules source-review expansion wave
- Mode: Project development / validation
- Priority: Medium; run after issues `#91`-`#93` land

## Goal

Validate that the next source-review wave routes common live-play prompts correctly, preserves honest authority labels, and does not let deterministic helper gates overclaim incomplete or table-heavy rules.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md`
- `docs/current/RULING_AUTHORITY_GATE.md`
- `docs/current/RULING_REGRESSION_SCENARIOS.md`
- `tests/fixtures/rules-route-golden-prompts.fixture.json`
- `scripts/test-route-rules-prompt.ps1`
- `scripts/check-ruling-authority.ps1`
- `scripts/validate-rules-indexes.ps1`

## Expected Output

- Extend existing route/ruling fixtures or validation notes for the newly strengthened areas.
- Confirm source-reviewed, draft, partial-draft, source-lookup-only, and tactical-handoff statuses are reported honestly.
- Update command docs if new validation commands are added.

## Files And Areas

Likely files to read or edit:

- `tests/fixtures/rules-route-golden-prompts.fixture.json`
- `scripts/test-route-rules-prompt.ps1`
- `scripts/test-validate-rules-indexes.ps1`
- `docs/current/RULING_REGRESSION_SCENARIOS.md`
- `docs/current/KNOWN_COMMANDS.md`
- `scripts/README.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
./scripts/test-route-rules-prompt.ps1
./scripts/test-validate-rules-indexes.ps1
./scripts/test-all.ps1
```

## Constraints

- This validation issue should not require protected raw source files for normal committed tests.
- Do not add fixtures that embed copyrighted rulebook text.
- Use prompts and expected routing/authority outcomes, not copied source rules.

## Acceptance Criteria

- New or updated validation covers all completed child issue areas from the wave.
- Tests or manual scenarios prove table-heavy/source-lookup-only limits are still surfaced.
- `scripts/test-all.ps1` passes or any blocker is recorded clearly.
- No protected raw source is staged.

## Open Questions

- If only issue `#91` is completed before this runs, should validation stay narrow or wait for `#92` and `#93`?
