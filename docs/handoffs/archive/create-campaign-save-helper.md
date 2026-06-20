# Create Campaign Save Helper

## Issue

- GitHub issue: https://github.com/walt-raymond-williams/mek-rpg/issues/15
- Roadmap entry: Create helper script to start a new campaign save folder from `campaigns/_template/`
- Mode: Project development
- Priority: High
- Status: Done

## Goal

Add a small, repeatable helper script that creates a new campaign save folder from `campaigns/_template/` without overwriting an existing campaign.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`
- `campaign-state/active-campaign.md`
- `campaigns/README.md`
- GitHub issue `#15`

## Expected Output

- A script under `scripts/` that copies `campaigns/_template/` to `campaigns/<campaign-id>/`.
- Validation that prevents path traversal and refuses to overwrite existing campaign folders.
- Usage documentation in `scripts/README.md`, `campaigns/README.md`, or another current doc.
- Roadmap/task updates and archived handoff after completion.

## Files And Areas

Likely files to read or edit:

- `scripts/`
- `scripts/README.md`
- `campaigns/README.md`
- `campaign-state/active-campaign.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
Get-ChildItem -Name scripts
Get-ChildItem -Name campaigns/_template
git diff --check
git diff --cached --check
git diff --cached --name-only | Select-String -Pattern '^(source/atow-pdf/|source/atow-text/)'
```

## Constraints

- Keep the script small and local.
- Do not build a database or application.
- Do not overwrite existing campaign folders.
- Do not write outside `campaigns/`.
- Do not change the active campaign pointer automatically unless behavior is documented and intentional.

## Acceptance Criteria

- Correct mode identified as Project development.
- Script creates a new campaign folder from `campaigns/_template/`.
- Script refuses to overwrite an existing campaign folder.
- Script prevents path traversal or writes outside `campaigns/`.
- Usage documented.
- Roadmap/tasks updated and handoff archived after completion.
- Verification run or blocker recorded.
- No protected raw source committed.
- Changes committed and pushed.

## Open Questions

- Resolved: selection remains a manual step. The script documents that it does not update `campaign-state/active-campaign.md`.

## Completion Notes

- Added `scripts/new-campaign-save.ps1`.
- Documented usage in `scripts/README.md`, `campaigns/README.md`, and `docs/current/KNOWN_COMMANDS.md`.
- Verified create, overwrite refusal, and invalid-id failure paths.
