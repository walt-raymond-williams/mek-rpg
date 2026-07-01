# Rich Character Play Capture Handoff

## Issue

- GitHub issue: `#123`
- Roadmap entry: Rich PC/NPC character records for play
- Mode: Project development
- Priority: After issue `#121`; can follow issue `#122`

## Goal

Define play-mode triggers for creating and updating PC/NPC records without slowing scenes or inventing hard stats.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- The schema doc produced by issue `#121`
- `gm/scene-loop.md`
- `gm/session-procedure.md`
- `gm/state-save-checklist.md`
- `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`
- `docs/current/STATE_CHANGE_PROPOSAL_SCHEMA.md`

## Expected Output

- Play-mode guidance for when to create a quick stub, when to expand a full record, and when to leave a person only in session notes.
- Update rules for personality, tendencies, relationships, promises, secrets, injuries, gear, and unresolved sheet gaps.
- Guidance for evidence labels and uncertainty.
- Links from relevant GM or current docs.

## Files And Areas

Likely files to read or edit:

- `gm/`
- `docs/current/`
- `campaigns/README.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
git diff --check
```

## Constraints

- Keep play moving; character capture should be concise and deferred when live scene flow matters.
- Do not create GitHub issues during play mode unless the user asks for project maintenance.
- Do not make hidden state changes; use campaign saves or state-change proposals as appropriate.

## Acceptance Criteria

- Play-mode capture triggers are documented.
- The workflow distinguishes durable character records from transient session notes.
- Verification is run or a blocker is recorded.

## Open Questions

- Should the play workflow include an explicit end-of-scene character-memory checklist?
