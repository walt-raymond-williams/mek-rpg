# Agent Handoff

## Issue

- GitHub issue: `#108` Audit roadmap for live MekHQ API-first campaign loading
- Roadmap entry: live MekHQ API-first campaign load and save-parser fallback realignment
- Mode: Project development
- Priority: Completed planning cleanup

## Goal

Review and align MEK-RPG planning docs so active loaded MekHQ campaigns use the read-only live API first, while raw save parsing remains an explicit offline, legacy, fixture, or debugging fallback.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/current/MEKHQ_LIVE_API_SAVE_COVERAGE_AUDIT.md`
- `docs/current/MEK_RPG_LIVE_MEKHQ_API_RESPONSE_MEMO.md`
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`

## Expected Output

- Roadmap and task board identify the correct near-term order: audit, producer-gap package, live API campaign-load adapter, then blind/live playtest.
- Save parsing is described as fallback/offline/fixture support when live API is available.
- Missing live API fields are routed to issue `#109` rather than direct edits in the MegaMek workspace.

## Files And Areas

Likely files to read or edit:

- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/current/MEKHQ_LIVE_API_SAVE_COVERAGE_AUDIT.md`
- `docs/current/MEK_RPG_LIVE_MEKHQ_API_RESPONSE_MEMO.md`
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/KNOWN_COMMANDS.md`
- `scripts/README.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
rg -n "summarize-mekhq-save|\\.cpnx|save parsing|live API|GET /campaign" docs/current scripts/README.md
./scripts/validate-campaign-state.ps1 -StrictActive
```

## Constraints

- Do not edit the MegaMek workspace.
- Do not parse live raw saves as part of this audit.
- Do not demote the save parser entirely; it remains valid for offline fallback and fixtures.
- Keep issue `#97` user/playtest work separate from the project-development audit.

## Acceptance Criteria

- Roadmap and task board reflect the API-first order.
- Audit memo exists and links to producer request package.
- Producer-side gaps are captured in project-local documents.
- Verification is run or blocker recorded.
- Changes are committed and pushed.

## Open Questions

- Should issue `#109` remain open until MegaMek/MekHQ has accepted or copied the change request into its own board?
