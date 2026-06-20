# Full Stale-Reference Review

## Issue

- GitHub issue: https://github.com/walt-raymond-williams/mek-rpg/issues/18
- Roadmap entry: Full repository stale-reference and consistency review
- Mode: Project development / review
- Priority: High
- Status: Ready

## Goal

Perform a full repository review for stale references, contradictory workflow guidance, obsolete campaign-state paths, outdated issue/task status, and broken routing after the #13-#16 planning changes.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`
- `campaign-state/README.md`
- `campaign-state/active-campaign.md`
- `campaigns/README.md`
- `gm/session-procedure.md`
- `indexes/task-router.md`
- GitHub issue `#18`

## Expected Output

- A repo-wide stale-reference review with notes on active stale guidance versus acceptable historical references.
- Fixes for active docs, routers, GM procedures, scripts docs, and indexes where references are stale or contradictory.
- Follow-up issues only where fixes are substantial enough to deserve separate work.
- Roadmap/task updates and archived handoff after completion.

## Files And Areas

Likely files to inspect:

- `AGENTS.md`
- `README.md`
- `docs/current/`
- `docs/handoffs/active/`
- `gm/`
- `indexes/`
- `rules/`
- `campaign-state/`
- `campaigns/`
- `scripts/`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
rg "campaign-state/(current|player|npc|faction|unresolved|session-log|rules-gaps|playtest-bugs)" AGENTS.md README.md docs gm campaign-state campaigns indexes rules scripts
rg "Ready For Issue|Now|Next|Backlog|Status: Ready|Status: Done|active/" docs/current docs/handoffs
rg "TODO|TBD|placeholder|Needs source review|Needs lookup|Needs user decision" AGENTS.md README.md docs gm campaign-state campaigns indexes rules scripts
git diff --check
git diff --cached --check
git diff --cached --name-only | Select-String -Pattern '^(source/atow-pdf/|source/atow-text/)'
```

## Constraints

- This is a review task, not a feature task.
- Do not process source PDFs or extracted text.
- Do not erase useful history. If a stale-looking reference is historical, leave it or label it clearly.
- Fix active guidance that could misroute future agents.

## Acceptance Criteria

- Correct mode identified as Project development / review.
- Repo-wide stale-reference searches run and documented.
- Active stale references are fixed or explicitly recorded as follow-up work.
- Historical references are left alone when clearly historical, or labeled when ambiguous.
- Router, GM docs, campaign docs, roadmap, task board, README, and AGENTS/profile guidance are checked.
- Roadmap/tasks updated and handoff archived after completion.
- Verification run or blocker recorded.
- No protected raw source committed.
- Changes committed and pushed.

## Open Questions

- Should this review happen before the dice roller and helper script, or after those two tooling tasks add their docs?
