# Agent Handoff

## Issue

- GitHub issue: `#109` Package live MekHQ API producer change requests
- Roadmap entry: live MekHQ API producer change-request package
- Mode: Project development / cross-workspace coordination
- Priority: Next / can proceed alongside issue `#107`

## Goal

Maintain a MEK-RPG-owned memo and handoff package that tells the MegaMek/MekHQ team what live API data MEK-RPG needs so active campaign loading does not depend on raw save parsing.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/MEKHQ_LIVE_API_SAVE_COVERAGE_AUDIT.md`
- `docs/current/MEGAMEK_LIVE_API_CHANGE_REQUEST.md`
- `docs/current/MEK_RPG_LIVE_MEKHQ_API_RESPONSE_MEMO.md`
- `docs/current/MEKHQ_CHECKPOINT_CROSS_BOARD_TRACKING_PROPOSAL.md`

## Expected Output

- Keep `docs/current/MEGAMEK_LIVE_API_CHANGE_REQUEST.md` current as issue `#107` discovers concrete missing fields.
- Ensure requested producer changes are framed as API additions or schema improvements, not MEK-RPG-side save parsing workarounds.
- Provide clear suggested producer-side tickets, acceptance criteria, and non-goals.

## Files And Areas

Likely files to read or edit:

- `docs/current/MEGAMEK_LIVE_API_CHANGE_REQUEST.md`
- `docs/current/MEK_RPG_LIVE_MEKHQ_API_RESPONSE_MEMO.md`
- `docs/current/MEKHQ_LIVE_API_SAVE_COVERAGE_AUDIT.md`
- `docs/current/MEKHQ_CHECKPOINT_CROSS_BOARD_TRACKING_PROPOSAL.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
gh issue view 107
gh issue view 108
gh issue view 109
```

## Constraints

- Do not edit, stage, commit, push, open issues, close issues, or update roadmaps in the MegaMek workspace unless the user explicitly asks for work in that repository.
- Keep write/action APIs out of this request unless a future issue explicitly scopes them with stable selectors, prompt policy, disposable validation, and saved/import confirmation.
- Do not include raw MekHQ save payloads or local private paths in committed examples.

## Acceptance Criteria

- Producer change request memo exists and is linked from roadmap/task planning.
- Requested API fields are grouped by response section.
- Non-goals make read-only boundaries explicit.
- MEK-RPG issue links identify the consumer work that depends on the request.
- Verification is run or blocker recorded.
- Changes are committed and pushed.

## Open Questions

- Which MegaMek/MekHQ team workflow should receive this package first: a copied memo, a linked issue comment, or a repository-local handoff in the MegaMek workspace?
