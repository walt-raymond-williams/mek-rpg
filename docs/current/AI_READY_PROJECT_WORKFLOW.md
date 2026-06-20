# AI-Ready Project Workflow

This workspace uses documentation as durable memory for AI-assisted play, rules lookup, source processing, and project development. The goal is to let a future session recover the current operating model without relying on chat history.

## Core Pattern

Keep these kinds of memory separate:

- `Agent instructions`: behavior, safety rules, mode routing, and close-out expectations in `AGENTS.md`.
- `Current knowledge`: durable project facts and workflows in `docs/current/`.
- `Execution state`: `docs/current/TASKS.md`, GitHub Issues, and handoff documents.
- `Domain profile`: protected inputs, rules-summary boundaries, campaign posture, and BattleTech integration in `docs/current/MEK_RPG_PROJECT_PROFILE.md`.

If two docs disagree, prefer `docs/current/` over older notes unless the user gives newer instructions.

## Repository Shape

```text
AGENTS.md
README.md
docs/
  current/
    AI_READY_PROJECT_WORKFLOW.md
    DOCUMENTATION_WORKFLOW.md
    GITHUB_ISSUE_WORKFLOW.md
    KNOWN_COMMANDS.md
    MEK_RPG_PROJECT_PROFILE.md
    ROADMAP.md
    SOURCE_PROCESSING_WORKFLOW.md
    TASKS.md
  handoffs/
    active/
    archive/
  templates/
    AGENT_HANDOFF.md
.github/
  ISSUE_TEMPLATE/
    agent-task.md
campaign-state/
gm/
indexes/
rules/
source/
```

Project-specific folders keep their existing roles. Raw source inputs under `source/atow-pdf/` and `source/atow-text/` are ignored local payload and must not be committed.

## Mode Router

Route each request into one primary mode before acting:

- `Play mode`: run campaign scenes, frame NPCs and consequences, request rolls only when failure matters, and update campaign state or session logs when useful.
- `Rules lookup mode`: answer rules questions from `indexes/task-router.md` and verified project summaries first, then cite page references or mark gaps when summaries are incomplete.
- `Project development mode`: work repository tasks, GitHub Issues, docs, indexes, summaries, scripts, and workflow changes with commits and pushes.
- `Source processing mode`: extract, map, or summarize legally owned source material only after explicit user request, preserving copyright and ignored-source boundaries.

If the requested mode is ambiguous and file edits could result, ask a short clarifying question before editing.

## Work Intake

Use `docs/current/ROADMAP.md` for durable planning and issue candidates. Use GitHub Issues for executable work that needs tracking, handoff, or outside review. Use `docs/current/TASKS.md` as the local board:

- `Now`: work currently in progress.
- `Next`: ready near-term work.
- `Backlog`: useful work not ready or not urgent.
- `Blocked`: work waiting on a specific condition.
- `Done`: recent completions that matter for continuity.

Before starting project development work, move or note the task in `Now`. When it completes, move it to `Done` and record issue, commit, and verification details when available.

## Handoffs

Use one handoff document per agent-executed GitHub issue when the issue needs context beyond the issue body.

- Active handoffs live in `docs/handoffs/active/`.
- Completed handoffs move to `docs/handoffs/archive/` after the issue is complete.
- Handoffs contain execution context. Durable process, source, campaign, or rules knowledge belongs in `docs/current/`, `gm/`, `indexes/`, `rules/`, or `campaign-state/`.

Use `docs/templates/AGENT_HANDOFF.md` for new handoffs.

## Close-Out

For project development mode:

1. Run relevant verification or record the blocker.
2. Update durable docs, indexes, task state, and handoffs.
3. Check `git status --short`.
4. Stage only files belonging to the completed work.
5. Commit a coherent change that references the issue when practical.
6. Push to the tracked branch unless the user explicitly says not to push.
7. Confirm `git status --short --branch` does not show the branch ahead of upstream.
8. Comment on or close the GitHub issue when appropriate.

For play mode, the close-out path is lighter: update campaign state or session logs when useful, but do not create development issues or commits unless the user intentionally asked for repository changes.
