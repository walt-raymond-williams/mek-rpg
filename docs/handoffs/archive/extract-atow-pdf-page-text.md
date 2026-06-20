# Extract A Time Of War PDF Page Text

## Issue

- GitHub issue: https://github.com/walt-raymond-williams/mek-rpg/issues/3
- Roadmap entry: Extract A Time of War PDF into ignored page text
- Mode: Source processing
- Priority: High
- Status: Complete

## Goal

Extract the legally owned A Time of War PDF into private ignored page-level text so later source-processing work can build a chapter/section map.

This issue was extraction only. No rule summaries, chapter maps, rule indexes, copied rulebook text, or verified rule summaries were created as part of this issue.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/SOURCE_PROCESSING_WORKFLOW.md`
- `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `scripts/extract-pdf-pages.sh`

## Result

- User explicitly requested source processing on 2026-06-20.
- The PDF was present under `source/atow-pdf/`.
- Extraction produced 410 page-level text files under ignored `source/atow-text/`.
- Extraction metadata was recorded in `source/extraction-notes.md`.
- Raw source files remained ignored and unstaged.

## Notes

- Poppler was installed with `winget` because `pdftotext` and `pdfinfo` were not initially available on PATH.
- The repository shell script was reviewed, but the installed Windows binaries were visible from WSL as `.exe` files and the local PDF filename contains spaces. Extraction therefore used the same Poppler page loop from PowerShell.
- Page-number offset is still unknown and should be determined during the chapter and section mapping issue.

## Next Issue After Completion

After extraction, the next recommended issue is:

- Build initial chapter and section map.

That follow-up can now start from the ignored page-level text and `source/extraction-notes.md`.
