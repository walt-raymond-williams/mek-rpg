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
- `docs/current/MEKHQ_LIVE_API_QUERY_VIEW_CONTRACT.md`
- `scripts/fetch-mekhq-live-api.ps1`
- `scripts/sync-mekhq-live-campaign.py`
- `scripts/test-fetch-mekhq-live-api.ps1`

## Expected Output

- Query helper under `scripts/`, planned as `scripts/query-mekhq-live-api.py`.
- Focused tests with sanitized fixtures.
- Basic output for manifest/campaign identity/read-only proof/state revision, using `schema_version: mek-rpg-mekhq-live-api-query-view/v1`.
- Command documentation in `scripts/README.md` and `docs/current/KNOWN_COMMANDS.md`.

## Files And Areas

Likely files to read or edit:

- `scripts/`
- `tests/fixtures/`
- `docs/current/MEKHQ_LIVE_API_QUERY_VIEW_CONTRACT.md`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/current/TASKS.md`
- `docs/handoffs/active/mekhq-live-api-play-context-view.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view summary --format json
./scripts/test-fetch-mekhq-live-api.ps1
./scripts/test-all.ps1 -Quick
git check-ignore -v mekhq-live-api-capture/mekhq-state.json
```

## Constraints

- Reject raw `.cpnx`, `.cpnx.gz`, and XML input paths.
- Require live API read-only proof for state-based views where relevant.
- Do not make narrative or tactical decisions.
- Keep fixtures sanitized and intentionally small.
- Keep JSON as the primary output format; text output may be added as a rendering of the same compact facts.
- Use one helper command with `--view` rather than separate subcommands.

## Contract Decisions From Issue `#140`

- Contract doc: `docs/current/MEKHQ_LIVE_API_QUERY_VIEW_CONTRACT.md`.
- Language: Python for nested JSON querying and compact view assembly; PowerShell remains the capture boundary.
- Planned helper: `scripts/query-mekhq-live-api.py`.
- Planned common arguments: `--capture-dir`, `--view`, and `--format json|text`.
- Initial helper target: implement the core loader plus `summary` view before later play/focused views.
- Output schema: top-level `schema_version`, `view`, `generated_at`, `status`, `source`, `identity`, `facts`, `counts`, `warnings`, `gaps`, and `next_actions`.
- Status values: `ok`, `partial`, `blocked`, and `error`.
- Evidence labels: `confirmed_live_api`, `confirmed_capture_manifest`, `computed_from_live_api`, `unsupported_by_api`, `missing_from_capture`, `capture_failed`, `partial_response`, `stale_or_unverified`, and `unknown`.
- Initial views to preserve for later issues: `summary`, `play-context`, `pending-deployments`, `person-commitment`, `unit-readiness`, `repair-pressure`, `command-readiness`, `reports`, and `api-gaps`.
- Fixture strategy: reuse sanitized live API fixtures under `tests/fixtures/`; add only minimal synthetic capture-directory fixtures if manifest/multi-file behavior needs them.
- Privacy boundary: do not commit personal `mekhq-live-api-capture*/` directories, raw saves, extracted XML, protected source text, or long raw JSON excerpts.

## Required Close-Out Step

Before closing, review `docs/handoffs/active/mekhq-live-api-play-context-view.md` and update it with the actual helper script name, supported arguments, output examples, fixture paths, and any limitations discovered during implementation.

## Acceptance Criteria

- Helper reads an explicit capture directory or explicit capture files.
- Helper reports failed/partial manifest status clearly.
- Tests cover valid capture, missing files, failed manifest, and missing read-only proof.
- State-based views reject missing/false `bridge_metadata.read_only` and wrong `bridge_metadata.api_mode`.
- Raw capture directories remain ignored and unstaged.
- Changes are verified, committed, and pushed.

## Open Questions

- Can existing extraction functions from `sync-mekhq-live-campaign.py` be safely shared, or should this helper start separate and converge later?
- Should issue `#141` implement text output immediately, or defer text rendering until `#142` once the play-context view exists?
