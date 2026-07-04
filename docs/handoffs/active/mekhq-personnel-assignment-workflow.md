# Agent Handoff

## Issue

- GitHub issue: `#152` Plan MekHQ personnel assignment read/query and guarded reassignment workflow
- Mode: Project development with MekHQ producer-coordination context
- Priority: Next actionable follow-up from issue `#97`

## Goal

Document the MEK-RPG-side requirements for reading MekHQ personnel assignments and planning a first safe personnel reassignment workflow.

The user wants this because Sharpe's Strikers play is now stable enough to move from passive roster reading toward useful assignment support: who is assigned to which Mek, what a specific pilot/person is assigned to, and eventually a simple guarded transfer from one unit slot to another.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/current/LIVE_GM_PLAYTEST_REVIEW_2026_07_04.md`
- `docs/current/RICH_CHARACTER_MEKHQ_API_NEEDS.md`
- `docs/current/MEKHQ_LIVE_API_QUERY_VIEW_CONTRACT.md`
- `docs/current/MEKHQ_COMMAND_API_STRATEGY.md`
- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`

## User Direction From Issue `#97`

- Read the whole personnel roster and assignment state in one request for now.
- Do not introduce pagination for this first design unless a later producer constraint makes it unavoidable.
- Support local parsing/query views over the captured data.
- Support focused questions such as which people are assigned to a specific Mek or vehicle, and what a specific pilot/person is assigned to.
- Plan the first mutation as a simple personnel transfer: unassign the person from the current unit, confirm the destination has no occupant for that slot, assign the person to the destination unit, then live reread and reconcile.
- Larger lance-rotation workflows are future work.
- Event-driven sync or messaging is future work and should not be implemented now.
- Issue `#127` profession runtime work remains blocked and out of scope.

## Expected Output

- A focused doc or update to existing MekHQ personnel/API docs defining personnel assignment read/query needs.
- A first guarded reassignment workflow with prerequisites, guard fields, dry-run/preflight expectations, prompt/approval policy, live reread verification, and failure handling.
- Project-local producer/API change-request text if the MekHQ API does not yet expose the required read or mutation shape.
- Roadmap and task updates.

## Boundaries

- Do not edit another repository from this issue.
- Do not parse the active MekHQ save as the routine live context path.
- Do not add bulk rotation, event-driven sync, or profession-gated reveal/runtime work.
- Do not commit raw live API captures, raw MekHQ saves, PDFs, extracted source text, or secrets.

## Verification

Minimum expected close-out:

```powershell
./scripts/validate-campaign-state.ps1 -StrictActive
git diff --check
git status --short --branch
```

Add focused tests only if scripts or query helpers are changed.
