# Agent Handoff

## Issue

- GitHub issue: `#105` Add live MekHQ API fixture and contract coverage
- Roadmap entry: live MekHQ campaign-state API consumer track under issue `#102`
- Mode: Project development
- Priority: Next

## Goal

Bring the MegaMek live API prototype fixtures and contract implications into MEK-RPG's durable consumer-side planning and tests without requiring a running MekHQ instance.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `../megamek-workspace/docs/current/MEK_RPG_LIVE_MEKHQ_API_PROTOTYPE.md`
- `docs/current/MEK_RPG_LIVE_MEKHQ_API_RESPONSE_MEMO.md`
- `docs/current/MEKHQ_READ_ONLY_CHECKPOINT_EXPORT_CONTRACT.md`
- `docs/current/MEKHQ_CHECKPOINT_CONSUMED_FIELD_MAPPING.md`
- `docs/current/MEKHQ_CHECKPOINT_WARNING_SURFACING.md`
- `docs/current/READ_ONLY_DASHBOARD_DATA_CONTRACT.md`

## Expected Output

- Add sanitized live API fixture copies or derived fixture excerpts under `tests/fixtures/`.
- Add fixture validation tests for live summary, full state, and warning-heavy shapes.
- Update durable docs so live API JSON is classified as live context by default, distinct from durable save/import checkpoint facts.
- Update command docs and `scripts/test-all.ps1` if a new test script is added.

## Files And Areas

Likely files to read or edit:

- `tests/fixtures/`
- `scripts/test-all.ps1`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/current/MEKHQ_READ_ONLY_CHECKPOINT_EXPORT_CONTRACT.md`
- `docs/current/MEKHQ_CHECKPOINT_CONSUMED_FIELD_MAPPING.md`
- `docs/current/READ_ONLY_DASHBOARD_DATA_CONTRACT.md`

Producer fixture sources:

- `../megamek-workspace/docs/templates/mekhq-live-campaign-summary.fixture.json`
- `../megamek-workspace/docs/templates/mekhq-live-campaign-state.fixture.json`
- `../megamek-workspace/docs/templates/mekhq-live-campaign-warning-heavy.fixture.json`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
./scripts/test-all.ps1 -Quick
```

If a focused test script is added, run it directly before `test-all -Quick`.

## Constraints

- Route the task into project development mode before editing.
- Do not call the live API in this issue.
- Do not require a running MekHQ GUI.
- Do not treat live fixture values as real campaign facts.
- Do not include unrelated user changes.
- Do not commit purchased PDFs, raw extracted text, raw MekHQ saves, or copyrighted rulebook passages.
- Preserve the read-only and live-context-not-durable boundary.
- Commit and push completed project-development changes unless explicitly told not to.

## Acceptance Criteria

- Local fixtures validate summary/state/warning-heavy live API shapes.
- Validation covers trust-envelope fields, unsupported/blocking entries, read-only metadata, and no local raw-save/source path leakage.
- Durable docs explain how live API JSON differs from saved checkpoint/import JSON.
- Relevant test runner and command docs are updated if needed.
- Verification is run or a blocker is recorded.
- No protected raw source or raw MekHQ save data is staged.

## Open Questions

- Should local fixture files be exact copies of the producer fixtures or trimmed derived excerpts?
- Should live API fixture validation extend existing checkpoint fixture tests or use a separate focused script?
