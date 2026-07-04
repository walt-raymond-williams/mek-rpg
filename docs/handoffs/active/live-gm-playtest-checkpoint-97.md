# Agent Handoff

## Issue

- GitHub issue: `#97` Post-playtest interview and campaign-file review for live GM workflow
- Parent issue: `#95` Manual validation and playtest checkpoint after rules expansion
- Mode: Project development with play-mode review context
- Priority: Current user-gated review task

## Goal

Finish the live GM playtest checkpoint by reviewing the real campaign files produced during extended MEK-RPG play, interviewing the user about what worked and failed, and converting concrete findings into follow-up issues or closing `#97` as good enough.

The original `#97` blind/live playtest has effectively already happened through normal use. The next agent should not try to stage another blind playtest first.

## Current Campaign Evidence

Review these campaign folders:

- `campaigns/the-learning-ropes/`: earlier MekHQ-linked Learning Ropes campaign arc. This folder exists and has substantial tracked changes from live play.
- `campaigns/sharpes-strikers/`: current active campaign save. This folder exists and is now selected in `campaign-state/active-campaign.md`.

The active campaign pointer currently selects:

```text
campaigns/sharpes-strikers/
```

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `gm/session-procedure.md`
- `gm/scene-loop.md`
- `gm/state-save-checklist.md`
- `campaign-state/active-campaign.md`

Task-specific context:

- `campaigns/the-learning-ropes/`
- `campaigns/sharpes-strikers/`
- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`
- `docs/current/MEKHQ_OPEN_CONNECTION_STARTUP_DECISION_TREE.md`
- `docs/current/MEKHQ_QUERY_VIEW_WORKFLOW_VALIDATION.md`
- `docs/current/RICH_CHARACTER_RECORD_SCHEMA.md`
- `gm/character-record-capture.md`

## Expected Output

- Inspect and summarize how the Learning Ropes and Sharpe's Strikers campaign files are structured.
- Interview the user about the extended MEK-RPG playtest experience.
- Identify concrete follow-up issues only where there is a real recurring bug, missing API capability, workflow gap, documentation gap, or validation gap.
- If no further action is needed, update `#97` with the review result and close it.
- Reconcile parent issue `#95` after `#97` is closed or explicitly deferred.

## Suggested Interview Questions

Ask concise questions in batches. Do not dump all questions at once if the conversation would work better interactively.

1. What worked well enough that we should preserve it as the default MEK-RPG play workflow?
2. Where did the agent repeatedly use stale campaign notes, stale MekHQ facts, or the wrong campaign folder?
3. Where did the MekHQ live API provide the right data at the right time?
4. Where did the MekHQ live API fail, time out, or omit data that blocked play?
5. Which campaign-state files were most useful during play: `current-state.md`, `session-log.md`, `missions.md`, `assets.md`, `pcs.md`, `npcs.md`, `pending-mekhq-actions.md`, or others?
6. Which files became too long, noisy, stale, duplicated, or hard to trust?
7. Did the GM context packet and compact MekHQ query views make play faster, or did agents still over-scan raw files?
8. Did agents handle MekHQ-owned facts correctly, especially avoiding active save parsing and marking unknowns/API gaps?
9. Did rules lookup and ruling authority work in actual scenes, or did the GM mostly improvise?
10. Did rich character records improve continuity, or are they too heavy for current play?
11. What parts of Sharpe's Strikers need better structure before continued play?
12. What should be a GitHub issue versus just a table habit or GM preference?

## Campaign File Review Checklist

- Confirm `campaign-state/active-campaign.md` selects exactly one folder.
- Confirm `campaigns/sharpes-strikers/` has all standard template files.
- Confirm `campaigns/the-learning-ropes/` remains available for historical review.
- Inspect `session-log.md`, `current-state.md`, `missions.md`, `assets.md`, `pcs.md`, `npcs.md`, `hooks.md`, `pending-mekhq-actions.md`, and `mekhq-bridge.md` for each relevant campaign.
- Identify whether files contain durable facts, temporary transcript-like material, stale facts, API-gap notes, or unresolved pending MekHQ actions.
- Check whether `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md` duplicates campaign-local gap notes or needs a follow-up producer issue.
- Run `./scripts/validate-campaign-state.ps1 -StrictActive`.
- If campaign state or docs are changed, run `git diff --check` and stage only relevant files.

## Commands

Useful commands:

```powershell
git status --short --branch
./scripts/validate-campaign-state.ps1 -StrictActive
./scripts/build-gm-context-packet.ps1
gh issue view 97 --comments
```

Optional, when reviewing file shape:

```powershell
rg -n "^#|^##|^###" campaigns/the-learning-ropes campaigns/sharpes-strikers
```

## Constraints

- Do not run source processing.
- Do not implement profession-gated reveal or Pre-Mission Intel Check runtime work; issue `#127` is blocked.
- Do not parse active MekHQ saves as the routine live context path.
- Keep raw live API captures, raw saves, PDFs, extracted text, and secrets unstaged.
- Do not turn every preference into a GitHub issue. File issues only for actionable, repeatable work.
- Keep campaign facts inside the relevant campaign save folder.

## Acceptance Criteria

- Campaign files for Learning Ropes and Sharpe's Strikers are inspected and summarized.
- User interview captures concrete feedback on workflow, API, campaign-state, rules lookup, context loading, and continuity.
- Follow-up issues are created only for actionable work, or non-actions are documented.
- `#97` is either closed with the review result or left open with a specific remaining blocker.
- Parent issue `#95` is reconciled after `#97`.
- Relevant changes are committed and pushed.
