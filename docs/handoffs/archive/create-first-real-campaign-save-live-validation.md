# Agent Handoff

## Issue

- GitHub issue: `#24` Create first real campaign save and live helper validation
- Roadmap entry: Create first real campaign save / live helper validation
- Mode: Play mode / Project development close-out
- Priority: High

## Goal

Use real setup and play with the user to create the first table-canon campaign save, select it as active when confirmed, and validate the campaign helper scripts in a live workflow.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`
- `campaign-state/active-campaign.md`
- `campaign-state/setting-basics.md`
- `campaigns/README.md`
- `gm/session-procedure.md`
- `gm/state-save-checklist.md`
- `gm/scene-loop.md`
- `gm/roll-policy.md`
- `scripts/README.md`

## Expected Output

- New `campaigns/<campaign-id>/` folder created from `campaigns/_template/` after the user chooses a campaign frame.
- `campaign-state/active-campaign.md` updated only after user confirmation.
- Initial campaign files populated enough to resume play.
- Short setup or play scene with the user that tests the save loop.
- Validation results for `new-campaign-save.ps1`, `validate-campaign-state.ps1`, and `roll-dice.ps1` where useful.
- Follow-up issues or task notes for discovered rules, workflow, character-sheet, or validator gaps.

## Files And Areas

Likely files to read or edit:

- `campaign-state/active-campaign.md`
- `campaign-state/setting-basics.md`
- `campaigns/<campaign-id>/`
- `campaigns/README.md` only if workflow changes
- `gm/`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `scripts/validate-campaign-state.ps1` only if live setup changes shared save structure

## Commands

Useful commands or checks:

```powershell
git status --short --branch
./scripts/new-campaign-save.ps1 <campaign-id>
./scripts/validate-campaign-state.ps1 -CampaignId <campaign-id>
./scripts/validate-campaign-state.ps1 -StrictActive
./scripts/roll-dice.ps1 2d6 "Live validation"
git check-ignore source/atow-pdf/example.pdf source/atow-text/page-0001.txt
```

## Constraints

- Requires user decisions for campaign frame, campaign id, canon/tone, and active campaign selection.
- Do not mix Galatea playtest-only facts into table canon unless the user explicitly promotes them.
- Do not update the active campaign pointer without user confirmation.
- Play-mode save files may be updated during play; project-development close-out commits only when appropriate.

## Acceptance Criteria

- User selects campaign frame and confirms campaign id.
- `new-campaign-save.ps1` creates the save folder without overwriting existing data.
- Active campaign pointer is updated only with user confirmation.
- `validate-campaign-state.ps1 -CampaignId <campaign-id>` passes before play/setup continues.
- `validate-campaign-state.ps1 -StrictActive` passes after active pointer selection.
- A short setup or play scene is run with the user to test the save loop.
- `gm/state-save-checklist.md` is used after meaningful play.
- Real campaign save files are updated with persistent state and open gaps.
- Validator maintenance is considered for any new save files or sheet structures introduced.
- Follow-up issues are created or task notes updated for discovered gaps.
- No protected raw source is staged.
- Changes are committed and pushed unless the user chooses a play-mode-only save state.

## Open Questions

- What campaign frame, era, starting region, and initial player character concept should become table canon?
