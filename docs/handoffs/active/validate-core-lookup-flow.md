# Validate Core Lookup Flow

## Issue

- GitHub issue: https://github.com/walt-raymond-williams/mek-rpg/issues/6
- Roadmap entry: Validate core lookup flow
- Mode: Project development
- Priority: High
- Status: Blocked until issue `#5` creates core summaries and routing entries

## Goal

Validate that the GM assistant can answer common core-resolution play situations from repository files instead of model memory.

The validation should start at `indexes/task-router.md`, follow only committed links, and confirm that the core summaries created in issue `#5` are usable, routed, page-referenced, and copyright-safe.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- GitHub issue `#5` output and committed summaries
- GitHub issue `#6` body

## Blocker

Do not start validation until issue `#5` creates core resolution summaries and updates the routing/index layer.

## Expected Output

- A committed validation report or durable doc update showing scenario lookup paths, pass/fail status, and routing gaps.
- Narrow fixes to core router/index/summary gaps found during validation, if safe and in scope.
- Follow-up tasks or issues for gaps outside the validation scope.
- Updated `docs/current/ROADMAP.md` and `docs/current/TASKS.md` with completion status and the next recommended issue.

## Files And Areas

Likely files to read:

- `indexes/task-router.md`
- Core summaries created by issue `#5`
- `indexes/page-reference-index.md`
- `indexes/manifest.yaml`
- `gm/roll-policy.md`
- `gm/scene-loop.md`

Likely files to edit:

- A validation report or focused current doc, chosen to match existing project layout
- Narrow router/index/summary fixes when clearly required
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- This handoff, moved to `docs/handoffs/archive/` after completion

## Validation Prompts

Use scenario-based lookup tests such as:

- A character tries to bypass a security lock under time pressure.
- Two characters both try to grab the same object first.
- A character attempts a difficult task with situational pressure and possible modifiers.
- A scene needs the GM to interpret how well or poorly a successful roll went.

Start each test at `indexes/task-router.md` and follow only committed links.

## Commands

Useful checks:

```powershell
git status --short --branch
git check-ignore source/atow-pdf/example.pdf source/atow-text/page-0001.txt
git status --short
```

## Constraints

- Validate committed summaries and indexes, not model memory.
- Do not inspect raw source text unless a narrow follow-up requires source review.
- Do not copy source prose, tables, or long verbatim passages.
- Record gaps instead of inventing rules.
- Confirm raw source files are ignored and unstaged before committing.

## Acceptance Criteria

- Correct mode identified as Project development.
- Scenario lookup tests start at `indexes/task-router.md`.
- Each test reaches appropriate core summary material or records a clear gap.
- Summaries include `When to Use`, `Do Not Use For`, procedure, related files, source references, and status.
- Answers can be given as paraphrased procedures or uncertainty/page-reference pointers without copied source text.
- Narrow routing/index/summary gaps are fixed when safe, or follow-up work is recorded.
- Roadmap and task state are updated.
- Handoff is archived after completion.
- Changes are committed and pushed.

## Open Questions

- Final report location should be chosen after issue `#5` establishes the summary and index layout.
