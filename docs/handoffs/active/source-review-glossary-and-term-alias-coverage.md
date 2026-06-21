# Agent Handoff

## Issue

- GitHub issue: `#46` Source-review glossary and term alias coverage
- Roadmap entry: Glossary and deeper index metadata
- Mode: Source processing / rules lookup infrastructure
- Priority: After or alongside rules index metadata cleanup

## Goal

Turn the placeholder term glossary into a source-reviewed lookup aid with stable terminology, aliases, routing notes, and page references.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/SOURCE_PROCESSING_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#46`

Task-specific context:

- `indexes/term-glossary.md`
- `indexes/task-router.md`
- `indexes/page-reference-index.md`
- `source/atow-chapter-section-map.md`

## Expected Output

- Updated `indexes/term-glossary.md`.
- Related router, rules-map, manifest, or page-reference updates only where useful.
- Roadmap and task updates.

## Files And Areas

Likely files to read or edit:

- `indexes/term-glossary.md`
- `indexes/task-router.md`
- `indexes/page-reference-index.md`
- `indexes/manifest.yaml`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
rg -n "glossary|term|alias|Needs source review|TBD" indexes rules docs/current
git status --short --branch
git check-ignore source/atow-pdf/example.pdf
git check-ignore source/atow-text/page-001.txt
```

## Constraints

- Paraphrase only; do not copy glossary entries wholesale.
- Do not commit raw extracted text, PDFs, tables, or copied source lists.
- Mark incomplete or uncertain entries as `Needs source review`, `Unknown`, or `TBD`.

## Acceptance Criteria

- Glossary entries are concise, paraphrased, and page-referenced where source-reviewed.
- Common aliases help route play and rules questions to existing summaries.
- Placeholder warnings are narrowed only where source review is complete.
- No protected raw source is committed.
- Changes are committed and pushed.

## Open Questions

- Should the glossary stay purely human-readable Markdown, or should issue `#48` later mirror key aliases in manifest metadata?
