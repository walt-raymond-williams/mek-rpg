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

## Automation Strategy

Use scripts for deterministic repository, routing, validation, and arithmetic work. Keep the LLM responsible for judgment-heavy work: GM narration, player-facing scene flow, rules interpretation from summaries, provisional rulings, source paraphrase, and deciding what matters in context.

Automation is useful now, even before full rules coverage, if it is treated as workflow infrastructure rather than encoded game authority. Early scripts should reduce token use, prevent repeated file-scanning, and make future summaries easier to maintain. Avoid scripts that hard-code incomplete A Time of War procedures before the relevant summaries are source-reviewed.

Preferred early automation targets:

- `Rules route helper`: take a natural-language rules or play prompt and return the matching `indexes/task-router.md` row, files to read, manifest status, and source-reference warnings.
- `Rules index validator`: check that manifest entries, router links, page-reference entries, related IDs, and summary files agree.
- `Source-boundary checker`: verify ignored PDF and extracted-text paths remain ignored and unstaged before commits.
- `Active campaign context loader`: resolve `campaign-state/active-campaign.md`, identify the selected `campaigns/<campaign-id>/` folder, list standard campaign files, and flag missing files.
- `Campaign save validator`: check that a campaign save has the expected files and does not mix active campaign state with legacy flat `campaign-state/` files.
- `Rules coverage reporter`: summarize draft, placeholder, needs-source-review, and verified coverage by subsystem.
- `Roll/check arithmetic helper`: perform deterministic dice and margin math after the GM or rules summary has chosen the applicable procedure.
- `Issue and handoff scaffolder`: create standard issue or handoff shapes when a task is ready, without forcing exploratory planning ideas into GitHub Issues too early.

PowerShell is the default scripting choice for this Windows-first workspace because existing helpers use it, it works naturally with the local shell, and it is enough for file checks, git checks, routing reports, and simple arithmetic. Use Python only when the task needs stronger parsing, YAML handling, PDF/text tooling, or data transformation that would be awkward in PowerShell. Whichever language is used, scripts should accept explicit inputs, produce plain text or JSON output, and avoid silently editing campaign or rules files unless the command name and documentation make that behavior obvious.

Introduce automation in layers:

1. First automate safety and navigation: source-boundary checks, index validation, route lookup, and active-campaign loading.
2. Then automate reporting: coverage status, missing metadata, stale references, and campaign-save completeness.
3. Then automate controlled calculations: dice totals, modifiers, margins, and other math already described by committed summaries.
4. Defer rules-authoritative automation until the relevant summaries are source-reviewed, routed, and validated.

Do not maintain duplicate truth where a generated file can replace a manual one. If a script generates or validates an index, document which file is the source of truth and which output is derived. When automation changes expected workflow behavior, update `docs/current/KNOWN_COMMANDS.md`, `scripts/README.md`, and this section.

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
3. Use sub-agent review before commit only when it materially improves substantial or high-risk work. Do not use a dedicated copyright reviewer by default; the main agent handles the source-boundary checklist by confirming summaries are paraphrased, page-referenced, and free of staged raw source files. Use two reviewers only for broad workflow changes, complex implementation, large continuity-sensitive edits, or explicit user requests. Do not let unavailable sub-agent tooling block close-out.
4. Check `git status --short`.
5. Stage only files belonging to the completed work.
6. Commit a coherent change that references the issue when practical.
7. Push to the tracked branch unless the user explicitly says not to push.
8. Confirm `git status --short --branch` does not show the branch ahead of upstream.
9. Comment on or close the GitHub issue when appropriate.

For play mode, the close-out path is lighter: update campaign state or session logs when useful, but do not create development issues or commits unless the user intentionally asked for repository changes.
