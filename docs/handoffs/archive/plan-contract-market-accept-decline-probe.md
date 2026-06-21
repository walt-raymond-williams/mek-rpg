# Agent Handoff

## Issue

- GitHub issue: `#69` Plan contract-market accept-decline bridge probe
- Roadmap entry: MekHQ bridge primitives follow-up queue
- Mode: Project development / future write-side validation planning
- Priority: Third child issue in the bridge primitives follow-up queue

## Goal

Plan the first possible write-side MekHQ bridge probe as a narrow contract-market accept/decline command, but only after stable contract IDs and prompt policy are validated.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEGAMEK_WORKSPACE_BRIDGE_REQUEST.md`
- `C:\Users\waltr\Documents\megamek-workspace\docs\current\MEK_RPG_MEKHQ_BRIDGE_PRIMITIVES.md`
- GitHub issue `#69`

## Expected Output

- A validation plan for contract-market accept/decline as a future pending-action type.
- Preconditions for stable contract IDs, guard fields, prompt policy, disposable save validation, and saved re-import confirmation.
- Refusal policy for AtB/StratCon prompts or dialogs that cannot be answered safely.
- Follow-up issue candidates for MegaMek workspace implementation only if preconditions are satisfied.

## Files And Areas

Likely files to read or edit:

- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEGAMEK_WORKSPACE_BRIDGE_REQUEST.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- this handoff

## Commands

Useful commands or checks:

```powershell
git status --short --branch
rg -n "contract|accept|decline|pending" docs gm scripts campaigns
git diff --check
```

## Constraints

- Do not implement write automation in this issue.
- Do not authorize direct save/XML edits.
- Keep manual UI workflow as the current supported path until a source-backed command exists.
- Require disposable MekHQ validation before any real campaign use.

## Acceptance Criteria

- Contract accept/decline preconditions are documented.
- Saved re-import confirmation fields are defined.
- Prompt/dialog blockers and refusal policy are documented.
- Roadmap and task state are updated.
- Verification is run or a blocker is recorded.
- Changes are committed and pushed.

## Open Questions

- Resolved for issue `#69`: decline may have fewer side effects than accept, but it still changes market state and remains gated on stable selectors, source-confirmed semantics, disposable validation, and saved re-import confirmation. It should not be implemented first just because it appears simpler.

## Completion Notes

- Added `docs/current/MEKHQ_CONTRACT_MARKET_PROBE_PLAN.md`.
- Documented stable offer-id and guard-field preconditions.
- Defined accept and decline saved re-import confirmation fields.
- Documented AtB/StratCon prompt blockers and a refusal-first policy.
- Added a disposable validation sequence before any real campaign use.
- Added a future MegaMek-side issue candidate without authorizing MEK-RPG-side write automation.
- Updated `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`, `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`, `docs/current/MEGAMEK_WORKSPACE_BRIDGE_REQUEST.md`, `docs/current/MEGAMEK_WORKSPACE_SYNC_MEMO.md`, `docs/current/ROADMAP.md`, and `docs/current/TASKS.md`.
