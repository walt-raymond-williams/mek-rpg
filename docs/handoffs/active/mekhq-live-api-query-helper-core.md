# Agent Handoff

## Issue

- GitHub issue: `#141`
- Roadmap entry: MekHQ live API query/context views
- Mode: Project development
- Priority: Depends on issue `#140`

## Goal

Implement the first query helper core that reads MekHQ live API capture files and emits compact validated output.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/handoffs/active/mekhq-live-api-query-views-epic.md`
- Contract doc created by issue `#140`
- `scripts/fetch-mekhq-live-api.ps1`
- `scripts/sync-mekhq-live-campaign.py`
- `scripts/test-fetch-mekhq-live-api.ps1`

## Expected Output

- Query helper under `scripts/`.
- Focused tests with sanitized fixtures.
- Basic output for manifest/campaign identity/read-only proof/state revision.
- Command documentation in `scripts/README.md` and `docs/current/KNOWN_COMMANDS.md`.

## Files And Areas

Likely files to read or edit:

- `scripts/`
- `tests/fixtures/`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/current/TASKS.md`
- `docs/handoffs/active/mekhq-live-api-play-context-view.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
./scripts/test-fetch-mekhq-live-api.ps1
./scripts/test-all.ps1 -Quick
git check-ignore -v mekhq-live-api-capture/mekhq-state.json
```

## Constraints

- Reject raw `.cpnx`, `.cpnx.gz`, and XML input paths.
- Require live API read-only proof for state-based views where relevant.
- Do not make narrative or tactical decisions.
- Keep fixtures sanitized and intentionally small.

## Required Close-Out Step

Before closing, review `docs/handoffs/active/mekhq-live-api-play-context-view.md` and update it with the actual helper script name, supported arguments, output examples, fixture paths, and any limitations discovered during implementation.

## Acceptance Criteria

- Helper reads an explicit capture directory or explicit capture files.
- Helper reports failed/partial manifest status clearly.
- Tests cover valid capture, missing files, failed manifest, and missing read-only proof.
- Raw capture directories remain ignored and unstaged.
- Changes are verified, committed, and pushed.

## Open Questions

- Can existing extraction functions from `sync-mekhq-live-campaign.py` be safely shared, or should this helper start separate and converge later?
