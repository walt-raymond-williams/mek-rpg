# Agent Handoff

## Issue

- GitHub issue: `#68` Document headless MekHQ day-advance risk
- Roadmap entry: MekHQ bridge primitives follow-up queue
- Mode: Project development / workflow documentation
- Priority: Second child issue in the bridge primitives follow-up queue

## Goal

Update MEK-RPG bridge docs so they clearly reflect that headless MekHQ day advancement is not currently low-risk, because `CampaignNewDayManager#newDay()` reaches GUI state and may trigger prompts/events.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- `docs/current/MEKHQ_PENDING_WORKFLOW_PLAYTEST_VALIDATION.md`
- `C:\Users\waltr\Documents\megamek-workspace\docs\current\MEK_RPG_MEKHQ_BRIDGE_PRIMITIVES.md`
- GitHub issue `#68`

## Expected Output

- Docs preserve manual UI day advancement plus saved re-import as the current supported path.
- Roadmap/task wording keeps headless day advancement behind future MekHQ source work and prompt policy decisions.
- Any stale wording that suggests easy headless day advancement is corrected.

## Files And Areas

Likely files to read or edit:

- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- `docs/current/MEGAMEK_WORKSPACE_BRIDGE_REQUEST.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- this handoff

## Commands

Useful commands or checks:

```powershell
git status --short --branch
rg -n "headless|day advancement|newDay|CampaignNewDayManager|advance day" docs gm scripts campaigns
git diff --check
```

## Constraints

- Do not implement day-advance automation.
- Do not imply direct XML edits or low-risk headless day advancement.
- Preserve issue `#37` as validation of manual UI day advancement, not headless automation.

## Acceptance Criteria

- Headless day advancement risk is documented in the relevant MEK-RPG docs.
- Manual UI apply/save/re-import remains the recommended current workflow.
- No issue or doc implies direct XML edits or low-risk headless day advancement.
- Verification is run or a blocker is recorded.
- Changes are committed and pushed.

## Open Questions

- Should MEK-RPG ever track a future headless day-advance issue, or should that live entirely in the MegaMek workspace until the GUI dependency is resolved?
