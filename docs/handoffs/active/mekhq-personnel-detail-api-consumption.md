# Agent Handoff

## Issue

- GitHub issue: `#146`
- Roadmap entry: MekHQ live API query/context views
- Mode: Project development
- Priority: Backlog; coordinate with epic `#139` and issue `#125`.

## Goal

Make MEK-RPG use the new MekHQ personnel detail endpoint for character/person context while preserving privacy, read-only, raw-capture, and MekHQ-ownership boundaries.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/current/MEKHQ_LIVE_API_QUERY_VIEW_CONTRACT.md`
- `docs/handoffs/active/mekhq-live-api-query-views-epic.md`
- `docs/handoffs/active/rich-character-record-mekhq-api-needs-125.md`

Producer-side references are read-only evidence from the sibling workspace:

- `C:/Users/waltr/Documents/megamek-workspace/docs/current/MEK_RPG_LIVE_MEKHQ_API_CONTRACT.md`
- `C:/Users/waltr/Documents/megamek-workspace/docs/current/MEK_RPG_LIVE_MEKHQ_PERSONNEL_DETAIL_API.md`
- `C:/Users/waltr/Documents/megamek-workspace/docs/templates/mekhq-live-personnel-detail.fixture.json`

## Expected Output

- MEK-RPG fetch/query support for `GET /campaign/personnel/detail?personId=<uuid>`.
- Sanitized fixture coverage for a personnel detail payload.
- Compact output fields suitable for GM play, profession lookup, and rich character context.
- Documentation explaining when play/query workflows should request a personnel detail read.
- Explicit opt-in handling for medical and patient logs.

## Files And Areas

Likely files to read or edit:

- `scripts/fetch-mekhq-live-api.ps1`
- `scripts/query-mekhq-live-api.py`
- `scripts/test-fetch-mekhq-live-api.ps1`
- `scripts/test-query-mekhq-live-api.ps1`
- `tests/fixtures/`
- `docs/current/MEKHQ_LIVE_API_QUERY_VIEW_CONTRACT.md`
- `docs/current/KNOWN_COMMANDS.md`
- `scripts/README.md`
- `gm/session-procedure.md`
- `docs/current/GM_CONTEXT_PACKET_DESIGN.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
./scripts/test-all.ps1 -Quick
```

Focused tests should be added or updated with the implementation.

## Constraints

- Route the task into project development mode before editing.
- Do not edit the MegaMek workspace from this repository.
- Do not include unrelated user changes.
- Do not commit purchased PDFs, raw extracted text, raw live captures, or secrets.
- Keep raw `mekhq-live-api-capture*/` files ignored and unstaged.
- Treat MekHQ as authoritative for personnel ledger facts.
- Keep medical and patient logs excluded by default; require explicit opt-in parameters and a bounded `logLimit`.
- Commit and push completed project-development changes unless explicitly told not to.

## Acceptance Criteria

- `GET /campaign/personnel/detail?personId=<uuid>` is represented in MEK-RPG tooling or in an implementation-ready contract if the helper architecture changes first.
- Sanitized personnel detail fixture coverage exists.
- Compact query/play output can surface useful character/person facts without dumping raw logs.
- Medical and patient logs are excluded by default and only included through explicit parameters.
- GM workflow docs tell agents when to request a detail read.
- Verification is run, or the live endpoint blocker is recorded.
- No protected raw source or raw live capture is staged.

## Open Questions

- Should detail reads be captured by `scripts/fetch-mekhq-live-api.ps1` directly, or should the first implementation live in `scripts/query-mekhq-live-api.py` as a focused on-demand query over raw captures?
- Which compact fields should feed the profession capability lookup versus rich PC/NPC sheets?
- Should the endpoint support batch detail reads later, or is one explicit `personId` per query enough for the near-term play workflow?
