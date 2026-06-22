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

## Blind Playtest Checklist

Use this checklist outside the new gameplay agent session. The goal is to test ordinary play behavior, so do not tell the gameplay agent about issue `#97`, this handoff, or the acceptance criteria unless the test has ended and you are doing close-out.

### Manual Prep Before Starting The New Agent

- Confirm this repository is clean with `git status --short --branch`.
- Confirm issue `#97` is open and no longer blocked.
- Optionally run `./scripts/validate-campaign-state.ps1 -StrictActive` yourself before the session.
- Decide whether you want to use the active campaign as-is or steer the scene with a natural table prompt.
- Do not ask the new gameplay agent to read this handoff, update GitHub issues, or run project-development close-out at session start.

### Prompt To Give The Gameplay Agent

Use an ordinary play prompt, such as:

```text
Let's continue the active MEK RPG campaign. Load the active campaign state and run the next short scene.
```

If you want a slightly more directed scene without exposing the test, use a natural prompt like:

```text
Let's continue the active MEK RPG campaign with a short scene that involves a meaningful uncertain action and could change the campaign state.
```

### What To Watch For During Play

- Did the agent load exactly one active campaign save without being told the test details?
- Did it use the GM flow docs naturally?
- Did it perform rules lookup from project summaries rather than memory when a rule mattered?
- Did it identify ruling authority or uncertainty instead of overclaiming?
- Did it ask for rolls only when failure mattered?
- Did it avoid full tactical BattleTech resolution inside MEK-RPG?
- Did it propose or make appropriate campaign-state updates when persistent facts changed?
- Did it capture rules gaps, workflow friction, or follow-up needs somewhere durable?

### Manual Close-Out After The Session

- Save the chat transcript or summarize the observed behavior before details fade.
- Check changed files with `git status --short --branch`.
- Run `./scripts/validate-campaign-state.ps1 -StrictActive`.
- If project files changed beyond campaign notes, run `./scripts/test-all.ps1 -Quick` or record why it was not run.
- Update this issue, `docs/current/TASKS.md`, and `docs/current/ROADMAP.md` with the result.
- Close issue `#97` only if the play checkpoint actually exercised rules lookup or authority behavior and state-save/checkpoint behavior was exercised or explicitly found unnecessary.
- Reconcile issue `#95` after `#97` is complete or explicitly deferred.
- Commit and push completed repository changes unless the user explicitly says not to.

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
