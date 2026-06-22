# Agent Handoff

## Issue

- GitHub issue: `#97` Run live GM playtest checkpoint using current workflow tools
- Roadmap entry: Repeat manual validation/playtest checkpoints after adding major playable layers
- Mode: Play mode with project-development close-out
- Priority: User-gated / blocked

## Goal

Run a short live GM scene through the current workflow and capture bugs, friction, missing rules, and state-save issues.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `gm/session-procedure.md`
- `gm/scene-loop.md`
- `gm/roll-policy.md`
- `gm/state-save-checklist.md`
- `campaign-state/active-campaign.md`

Task-specific context:

- `scripts/build-gm-context-packet.ps1`
- `scripts/check-ruling-authority.ps1`
- `docs/current/STATE_CHANGE_PROPOSAL_SCHEMA.md`
- `docs/current/RULING_AUTHORITY_GATE.md`

## Expected Output

- A short live play checkpoint with at least one meaningful rules lookup or authority-gate decision.
- Campaign-local session notes or playtest notes if persistent state changes.
- Follow-up issues for bugs, rules gaps, or workflow friction.

## Files And Areas

Likely files to read or edit:

- `campaigns/<campaign-id>/session-log.md`
- `campaigns/<campaign-id>/current-state.md`
- `campaigns/<campaign-id>/rules-gaps.md`
- `campaigns/<campaign-id>/playtest-notes.md` if present
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
./scripts/build-gm-context-packet.ps1
./scripts/validate-campaign-state.ps1 -StrictActive
```

## Constraints

- This issue requires live user participation for a meaningful playtest.
- It is labeled `user-task` and `blocked`; autonomous agents should skip it unless the user is present and explicitly asks to run the playtest.
- Load exactly one active campaign save folder.
- Do not resolve tactical BattleTech combat inside MEK-RPG; hand off to Classic BattleTech, MegaMek, or MekHQ when tactical detail matters.

## Acceptance Criteria

- User is present for the live play checkpoint.
- Active campaign context is loaded through the current procedure.
- At least one rules lookup or authority-gate decision is exercised.
- State-save/checkpoint behavior is exercised or explicitly found unnecessary.
- Bugs or gaps are captured as notes or follow-up issues.
- Changes are committed and pushed.

## Open Questions

- Which campaign and scene should be used for the playtest checkpoint?
