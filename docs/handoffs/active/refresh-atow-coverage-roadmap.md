# Refresh AToW Coverage Roadmap

## Issue

- GitHub issue: https://github.com/walt-raymond-williams/mek-rpg/issues/17
- Roadmap entry: Refresh roadmap for full A Time of War coverage
- Mode: Project development
- Priority: High
- Status: Ready

## Goal

Revise the roadmap and task board so the remaining path toward broad A Time of War support is explicit, current, and broken into actionable issue candidates.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/SOURCE_PROCESSING_WORKFLOW.md`
- `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `indexes/manifest.yaml`
- `indexes/page-reference-index.md`
- `rules/`
- GitHub issue `#17`

## Expected Output

- Roadmap sections that distinguish completed draft coverage, remaining placeholder subsystems, validation needs, and future source-processing waves.
- A prioritized sequence for character creation, campaign systems, vehicles/MechWarrior bridge, validation/indexing, and play tooling.
- Backlog cleanup so completed #7-#14 work is not duplicated as future work.
- Task board updated to match the revised roadmap.

## Files And Areas

Likely files to read or edit:

- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md` if the plan needs a current-status note
- `indexes/manifest.yaml`
- `indexes/page-reference-index.md`
- `rules/`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
rg "Status: placeholder|status: placeholder|Status: Draft placeholder|Needs source review" rules indexes docs/current
rg "Summarize personal combat|damage and recovery|campaign-state structure|first playable" docs/current/ROADMAP.md docs/current/TASKS.md
git diff --check
git diff --cached --check
git diff --cached --name-only | Select-String -Pattern '^(source/atow-pdf/|source/atow-text/)'
```

## Constraints

- Do not process source PDFs or extracted text.
- Do not create every future source-processing issue unless the work is genuinely ready and scoped.
- Preserve the copyright boundary and uncertainty labels.

## Acceptance Criteria

- Correct mode identified as Project development.
- Roadmap accurately reflects issues `#1`-`#18` and the remaining AToW coverage path.
- Stale duplicate backlog items are removed or reworded.
- Remaining large subsystems are grouped into issue-sized future work.
- `TASKS.md` matches roadmap priorities.
- Roadmap/tasks updated and handoff archived after completion.
- Verification run or blocker recorded.
- No protected raw source committed.
- Changes committed and pushed.

## Open Questions

- Should source-processing waves resume with character creation first, or should campaign systems come first because they affect ongoing play more directly?
