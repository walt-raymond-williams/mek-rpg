# Extract A Time Of War PDF Page Text

## Issue

- GitHub issue: https://github.com/walt-raymond-williams/mek-rpg/issues/3
- Roadmap entry: Extract A Time of War PDF into ignored page text
- Mode: Source processing
- Priority: High

## Goal

Extract the legally owned A Time of War PDF into private ignored page-level text so later source-processing work can build a chapter/section map.

This issue is extraction only. Do not summarize rules, map chapters, update rule indexes, quote rulebook text, or write verified rule summaries as part of this issue.

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

## Known Local State

- User explicitly requested source processing on 2026-06-20.
- A PDF is present under `source/atow-pdf/`.
- Open issue: `#3`.
- No extraction has been run as part of creating this handoff.

## Expected Output

- Private ignored page text under `source/atow-text/page-####.txt`.
- Committed `source/extraction-notes.md` with:
  - extraction date
  - PDF filename
  - extraction command
  - tool/version notes when available
  - page count when available
  - observed extraction problems
  - page-number offset notes or `Unknown`
- No committed PDF, EPUB, raw extracted text, copied tables, or rulebook passages.

## Commands

Useful checks before extraction:

```powershell
git status --short --branch
git check-ignore source/atow-pdf/example.pdf source/atow-text/page-0001.txt
Get-ChildItem -Force source/atow-pdf
```

Useful tooling checks:

```powershell
pdftotext -v
pdfinfo -v
```

Expected extraction path, after confirming the exact PDF filename:

```powershell
bash scripts/extract-pdf-pages.sh "source/atow-pdf/<PDF filename>"
```

If `bash`, `pdftotext`, or `pdfinfo` is unavailable, record the blocker in `source/extraction-notes.md` or the issue rather than using an unsafe workaround.

## Constraints

- Do not process any PDF other than the legally owned PDF under `source/atow-pdf/`.
- Do not write summaries, chapter maps, or rules index updates in this issue.
- Do not inspect extracted text for rules meaning beyond checking that extraction produced page files.
- Do not copy source text into committed files or chat.
- Do not stage `source/atow-pdf/` or `source/atow-text/` contents.

## Acceptance Criteria

- Correct mode identified as Source processing mode.
- `.gitignore` protection is confirmed for protected paths.
- PDF presence is confirmed under `source/atow-pdf/`.
- Extraction produces page-level files under ignored `source/atow-text/`.
- `source/extraction-notes.md` records extraction metadata without copied rule text.
- Raw source files are ignored and unstaged.
- Changes are committed and pushed.
- GitHub issue `#3` is updated or closed with verification results.

## Next Issue After Completion

After extraction completes, the next recommended issue is:

- Build initial chapter and section map.

That follow-up should remain blocked until page-level text exists and extraction notes identify any page count or page offset concerns.
