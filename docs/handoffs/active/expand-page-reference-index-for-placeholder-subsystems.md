# Agent Handoff

## Issue

- GitHub issue: `#47` Expand page-reference index for placeholder subsystems
- Roadmap entry: Glossary and deeper index metadata
- Mode: Project development / rules lookup infrastructure
- Priority: Near-term rules infrastructure

## Goal

Expand `indexes/page-reference-index.md` so placeholder and partially covered subsystems have usable source page pointers before deeper summaries are written.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#47`

Task-specific context:

- `indexes/page-reference-index.md`
- `indexes/task-router.md`
- `indexes/manifest.yaml`
- `source/atow-chapter-section-map.md`

## Expected Output

- Expanded page-reference entries for mapped-but-unsummarized subsystems.
- Clear non-authoritative status labels for placeholder areas.
- Roadmap and task updates.

## Files And Areas

Likely files to read or edit:

- `indexes/page-reference-index.md`
- `indexes/manifest.yaml`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
rg -n "Needs source review|placeholder|TBD|Unknown" indexes rules docs/current
git diff --check
git status --short --branch
```

## Constraints

- Do not create new rules summaries in this issue.
- Do not process PDFs or copy raw source text.
- Preserve uncertainty for table-heavy or mapped-only sections.

## Acceptance Criteria

- Page references cover major mapped placeholder subsystems.
- Entries cite PDF and printed page ranges when known.
- Existing verified summary references remain intact.
- No protected raw source is committed.
- Changes are committed and pushed.

## Open Questions

- Should page-reference status labels be standardized here, or left for issue `#48` manifest normalization?
