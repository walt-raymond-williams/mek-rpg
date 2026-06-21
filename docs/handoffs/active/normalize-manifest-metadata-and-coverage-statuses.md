# Agent Handoff

## Issue

- GitHub issue: `#48` Normalize manifest metadata and coverage statuses
- Roadmap entry: Glossary and deeper index metadata
- Mode: Project development / rules lookup infrastructure
- Priority: After basic page-reference cleanup, or before validators if useful

## Goal

Bring `indexes/manifest.yaml` into better alignment with routed summaries, placeholder sections, page references, and coverage status labels.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#48`

Task-specific context:

- `indexes/manifest.yaml`
- `indexes/page-reference-index.md`
- `indexes/task-router.md`
- `indexes/rules-map.md`
- `source/atow-chapter-section-map.md`
- Existing validation reports under `docs/current/`

## Expected Output

- Updated manifest metadata and coverage statuses.
- Documentation notes if status meanings need clarification.
- Roadmap and task updates.

## Files And Areas

Likely files to read or edit:

- `indexes/manifest.yaml`
- `indexes/README.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
rg -n "status:|manifest|validated|draft|placeholder|Needs source review" indexes rules docs/current
git diff --check
git status --short --branch
```

## Constraints

- Do not invent source-reviewed or validated status.
- Use `TBD`, `Unknown`, or `Needs source review` when evidence is incomplete.
- Do not commit raw source text.

## Acceptance Criteria

- Manifest includes stable IDs for current drafted/routed summaries.
- Placeholder or mapped-only subsystems are explicitly non-authoritative.
- Page references match committed summaries and source-map docs where available.
- No protected raw source is committed.
- Changes are committed and pushed.

## Open Questions

- Should the manifest become the source of truth for issue `#50` coverage reporting?
