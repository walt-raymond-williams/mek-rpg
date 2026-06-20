# Source Processing Workflow

Source processing converts a legally owned A Time of War source into private extracted text and committed paraphrased summaries. It is explicit-request-only.

Do not process any PDF unless the user directly asks for source extraction, source mapping, or source summarization.

## Protected Boundary

- PDFs belong in ignored `source/atow-pdf/`.
- Extracted text belongs in ignored `source/atow-text/`.
- Committed summaries must be paraphrased, concise, procedural, and page-referenced.
- Do not commit purchased PDFs, EPUBs, raw extracted text, copied tables, or long verbatim passages.
- When uncertain, write `Needs source review` with page references instead of inventing details.

## Workflow

1. Confirm the user explicitly requested source processing.
2. Confirm the legally owned PDF is under `source/atow-pdf/`.
3. Confirm ignored paths are still ignored.
4. Extract page-level text into `source/atow-text/`.
5. Record extraction issues, page offsets, and source quirks in `source/extraction-notes.md`.
6. Build a chapter and section map before writing summaries.
7. Summarize one focused rules area at a time.
8. Use the standard summary schema in `rules/`.
9. Preserve page references and uncertainty.
10. Update `indexes/task-router.md`, `indexes/page-reference-index.md`, `indexes/subsystem-index.md`, `indexes/rules-map.md`, `indexes/term-glossary.md`, and `indexes/manifest.yaml` as relevant.
11. Run a staging check to confirm raw source is not staged.
12. Commit only paraphrased summaries, indexes, notes, and workflow docs.

## Summary Expectations

Each rule summary should include:

- purpose
- when to use
- when not to use
- procedure
- GM guidance
- edge cases
- related files
- source references
- status

Use `TBD`, `Unknown`, or `Needs source review` where source verification is incomplete.

## Validation

Before marking a summary verified:

1. Compare it against the page references in the legally owned source.
2. Confirm no copied source text remains.
3. Confirm the router points to the summary.
4. Confirm the manifest records stable IDs and page arrays.
5. Note any source ambiguity in the summary status.

## Source-Processing Close-Out

For development changes resulting from source processing:

```powershell
git status --short --branch
git check-ignore source/atow-pdf/example.pdf
git check-ignore source/atow-text/page-001.txt
```

Then commit and push only safe files. If a raw source file appears in `git status`, stop and fix the staging or ignore issue before committing.
