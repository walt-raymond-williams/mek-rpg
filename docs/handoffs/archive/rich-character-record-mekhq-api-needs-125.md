# Rich Character MekHQ API Needs Handoff

## Issue

- GitHub issue: `#125`
- Roadmap entry: Rich PC/NPC character records for play
- Mode: Project development / cross-workspace coordination
- Priority: After or alongside issue `#121`

## Goal

Identify MekHQ personnel and character-detail API needs that would help linked rich character records while preserving MEK-RPG ownership of RPG overlays.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/current/MEKHQ_PERSONNEL_SHEET_WORKFLOW.md`
- `docs/current/MEKHQ_LIVE_API_EXPANSION_TRACKING.md`
- `docs/current/MEGAMEK_LIVE_API_CHANGE_REQUEST.md`
- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`
- The schema doc produced by issue `#121` if available

## Expected Output

- A MEK-RPG-side memo or change-request update listing useful personnel fields, selectors, evidence labels, and missing API details.
- Clear statement of what remains MEK-RPG-only: A Time of War stats, motives, personality, secrets, preferences, portrayal notes, and scene memory.
- No edits to the MegaMek workspace unless explicitly requested by the user.

## Files And Areas

Likely files to read or edit:

- `docs/current/`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/handoffs/active/rich-character-record-mekhq-api-needs-125.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
git diff --check
```

## Constraints

- Do not infer A Time of War stats, personality, motives, secrets, or preferences from MekHQ role/rank.
- Do not edit the MegaMek workspace from this repository.
- Keep producer requests focused, evidence-based, and compatible with the live API-first workflow.

## Acceptance Criteria

- API needs are documented in a durable MEK-RPG current doc or existing change-request doc.
- Ownership boundaries are explicit.
- Verification is run or a blocker is recorded.

## Open Questions

- Which personnel fields are actually present in the current live API response versus only in older save-summary prototypes?
