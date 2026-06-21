# Agent Handoff

## Issue

- GitHub issue: `#66` Epic: track MekHQ bridge primitives follow-up
- Roadmap entry: MekHQ bridge primitives follow-up queue
- Mode: Project development / cross-workspace coordination
- Priority: Coordination epic

## Goal

Track MEK-RPG follow-up work from the MegaMek workspace bridge-primitives assessment without blurring the current read-only-first posture.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/current/MEGAMEK_WORKSPACE_BRIDGE_REQUEST.md`
- `C:\Users\waltr\Documents\megamek-workspace\docs\current\MEK_RPG_MEKHQ_BRIDGE_PRIMITIVES.md`
- GitHub issues `#66`, `#67`, `#68`, and `#69`

## Expected Output

- Keep child issues `#67`-`#69` visible and ordered.
- Preserve the recommendation that read-only checkpoint export comes before write automation.
- Keep headless day advancement marked risky until MekHQ source work separates GUI/prompt dependencies.
- Treat contract-market accept/decline as the first possible write-side probe only after stable IDs and prompt policy are validated.

## Files And Areas

Likely files to read or edit:

- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/current/MEGAMEK_WORKSPACE_BRIDGE_REQUEST.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- child issue handoffs under `docs/handoffs/active/`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
git diff --check
gh issue list --state open --limit 50
```

## Constraints

- Do not authorize direct `.cpnx`, `.cpnx.gz`, or XML editing.
- Do not commit raw MekHQ save/XML, protected source text, copied tables, purchased PDFs, or secrets.
- Keep MEK-RPG side focused on consumer contracts, workflow docs, validation plans, and pending-action reconciliation.

## Acceptance Criteria

- Child issues and handoffs exist.
- Roadmap and task board reflect the queue.
- Queue explicitly captures read-only export first, headless day-advance risk, and contract accept/decline as gated future work.
- Changes are committed and pushed.

## Open Questions

- Resolved for issue `#66`: MEK-RPG drafted the consumer JSON/contract first in issue `#67`. MegaMek-side implementation work should start from that contract or a MegaMek-owned sanitized export fixture.

## Completion Notes

- Child issue `#67` completed: `docs/current/MEKHQ_READ_ONLY_CHECKPOINT_EXPORT_CONTRACT.md`.
- Child issue `#68` completed: headless MekHQ day advancement remains manual UI advance/save/re-import only until MekHQ source work resolves GUI/prompt coupling.
- Child issue `#69` completed: `docs/current/MEKHQ_CONTRACT_MARKET_PROBE_PLAN.md`.
- Queue preserves read-only-first posture and keeps all write-side work gated behind source-backed selectors, prompt policy, disposable validation, and saved re-import confirmation.
