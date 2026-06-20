# Build A Time Of War Chapter And Section Map

## Issue

- GitHub issue: https://github.com/walt-raymond-williams/mek-rpg/issues/4
- Roadmap entry: Build initial chapter and section map
- Mode: Source processing
- Priority: High

## Goal

Build an initial chapter and section map from the ignored A Time of War page-level text so later agents can summarize one focused rules area at a time without scanning the whole source.

This issue is mapping only. Do not write rule summaries, paraphrase rule procedures, quote rulebook text, copy tables, or update live rules-routing indexes as part of this issue.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/SOURCE_PROCESSING_WORKFLOW.md`
- `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `source/extraction-notes.md`
- GitHub issue `#4` body

## Known Local State

- Issue `#3` extracted 410 PDF pages into ignored `source/atow-text/page-####.txt` files.
- The source PDF remains under ignored `source/atow-pdf/`.
- Page-number offset is currently `Unknown`.
- Some extracted pages are very small; page-level quality should be noted during mapping without copying source text.

## Expected Output

- A committed chapter/section map that identifies major chapters and candidate section boundaries without copied source text.
- Stable section IDs using a predictable pattern such as `atow.chapter.section-topic`.
- For each mapped section, record:
  - chapter or major subsystem
  - section title paraphrase or topic label
  - PDF page range
  - printed source page range when known
  - extraction-quality notes
  - candidate summary file path
  - candidate manifest ID
  - status: `mapped`, `needs source review`, or `blocked`
- Page-number offset notes in `source/extraction-notes.md`, or `Unknown` with the reason it remains unresolved.
- Updated `docs/current/ROADMAP.md` and `docs/current/TASKS.md` with the mapping result and next recommended issue.

## Files And Areas

Likely files to read:

- `source/atow-text/page-####.txt` files, only as needed to identify chapter and section boundaries.
- `source/extraction-notes.md`

Likely files to edit:

- A new committed mapping document under `source/` or `indexes/`, chosen to match the project plan.
- `source/extraction-notes.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- This handoff, moved to `docs/handoffs/archive/` after completion.

## Commands

Useful checks before mapping:

```powershell
git status --short --branch
git check-ignore source/atow-pdf/example.pdf source/atow-text/page-0001.txt
(Get-ChildItem source/atow-text -Filter 'page-*.txt' | Measure-Object).Count
```

Useful close-out checks:

```powershell
git status --short --branch
git check-ignore source/atow-pdf/example.pdf source/atow-text/page-0001.txt
git status --short
```

## Constraints

- Do not commit protected raw source files.
- Do not copy or quote source text into committed files or chat.
- Do not summarize rules or paraphrase procedures.
- Do not create verified rule summaries.
- Do not update live rules lookup indexes unless a narrow map-oriented placeholder is explicitly needed for future work.
- Preserve uncertainty with `Unknown`, `Needs source review`, or `blocked`.

## Acceptance Criteria

- Correct mode identified as Source processing mode.
- Extracted page text exists and remains ignored.
- `.gitignore` protection is confirmed for PDF, EPUB, and extracted text paths.
- Chapter/section map exists in a committed safe file.
- Mapping records stable IDs, topic labels, page ranges, extraction-quality notes, candidate summary paths, candidate manifest IDs, and status labels.
- Page-number offset is recorded or explicitly left `Unknown`.
- Raw source files are ignored and unstaged.
- Roadmap and task state are updated.
- Handoff is archived after completion.
- Changes are committed and pushed.
- GitHub issue `#4` is updated or closed with verification results.

## Open Questions

- Exact PDF-to-printed-page offset is still unknown.
- Final location and filename for the committed map should be chosen in sympathy with the existing project layout.
