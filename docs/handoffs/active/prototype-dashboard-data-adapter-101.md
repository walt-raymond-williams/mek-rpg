# Prototype Dashboard Data Adapter Handoff

## Issue

- GitHub issue: `#101`
- Roadmap entry: `docs/current/ROADMAP.md` -> Read-only dashboard and session tooling queue
- Mode: Project development
- Priority: Next after unblocked verification/runtime work, or earlier if dashboard visibility becomes the immediate need.

## Goal

Prototype `scripts/export-dashboard-data.ps1` as a deterministic read-only JSON adapter for the future MEK-RPG dashboard.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/READ_ONLY_DASHBOARD_EVALUATION.md`
- `docs/current/READ_ONLY_DASHBOARD_DATA_CONTRACT.md`
- `docs/current/GM_CONTEXT_PACKET_DESIGN.md`
- `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`

## Expected Output

- `scripts/export-dashboard-data.ps1` emits `dashboard-data/v1` JSON for an explicit campaign or the active campaign pointer.
- Fixture-backed tests follow existing disposable fixture patterns and prove read-only behavior.
- Command documentation is added to `scripts/README.md` and `docs/current/KNOWN_COMMANDS.md`.
- Roadmap and task state are updated when the issue is completed.

## Files And Areas

Likely files to read or edit:

- `scripts/export-dashboard-data.ps1`
- `scripts/test-export-dashboard-data.ps1`
- `tests/fixtures/`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

Likely existing helpers to inspect:

- `scripts/validate-campaign-state.ps1`
- `scripts/validate-mekhq-pending-actions.ps1`
- `scripts/build-gm-context-packet.ps1`
- `scripts/test-validate-campaign-state.ps1`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
./scripts/test-export-dashboard-data.ps1
./scripts/test-all.ps1
```

If `./scripts/test-all.ps1` is still too slow for routine close-out, record that and reference issue `#100` rather than treating it as a failure of this issue.

## Constraints

- No manual testing or user presence is required for this issue.
- Do not implement a dashboard UI or local HTTP server in this issue.
- Do not add write controls, campaign edits, git actions, issue actions, MekHQ writeback, raw MekHQ save reads, protected source reads, or tactical resolution.
- The adapter may show that protected categories are excluded, but must not list, read, hash, excerpt, or count protected source contents.
- Keep output deterministic and testable.

## Acceptance Criteria

- `scripts/export-dashboard-data.ps1` supports the v1 command shape from `docs/current/READ_ONLY_DASHBOARD_DATA_CONTRACT.md` or records any deliberate narrower v1 choice.
- JSON output includes schema version, repo, selection, authority, health, panels, warnings, and errors.
- Explicit campaign selection and active-pointer selection are covered.
- Fixture tests prove selected campaign files, pending-action files, active pointer, protected source paths, and raw MekHQ save paths are not modified or opened.
- Missing/invalid campaign selection fails safely.
- Existing validator/context-helper output is included or clearly deferred without reinterpreting rules.
- Documentation is updated.
- Changes are committed and pushed.

## Open Questions

- Should `IncludeExcerpts` be implemented in v1 or deferred to headings/source links only?
- Should `IncludePrivate` ever show safety/tone excerpts, or only reveal file presence and privacy labels?
- Should `repo.is_dirty` remain `null` for v1 as the contract suggests, or include read-only git status later?
