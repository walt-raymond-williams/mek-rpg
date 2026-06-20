# MEK RPG

MEK RPG is a private personal-use workspace for running a BattleTech RPG campaign with A Time of War style roleplaying rules. It supports rules lookup, GM assistance, campaign state tracking, and handoff to Classic BattleTech, MegaMek, or MekHQ when tactical BattleMech combat is needed.

## What It Is Not
This project is not a redistribution of copyrighted rulebooks. It should not contain purchased PDFs, EPUBs, or large verbatim extracted passages in committed files.

## How to Use This Project
1. Use `indexes/task-router.md` to decide which summaries answer a question.
2. Read the relevant files under `rules/` or `gm/`.
3. If a summary is incomplete, use source page references to inspect your legally owned copy.
4. Track campaign changes in `campaign-state/`.

## PDF Placement
Put your legally owned PDF in:

```text
source/atow-pdf/
```

The PDF path is ignored by git. Do not commit the PDF.

## Extraction Workflow
Later, run:

```sh
./scripts/extract-pdf-pages.sh "source/atow-pdf/A Time of War.pdf"
```

The script will extract one text file per page into `source/atow-text/` if `pdftotext` is installed. Extracted text is ignored by git.

## Summary Structure
Rule summaries live under `rules/` and follow a standard schema: purpose, when to use, when not to use, procedure, GM guidance, edge cases, related files, source references, and status.

## GM Mode
GM procedures live under `gm/`. The agent should frame scenes concisely, ask for rolls only when failure matters, offer concrete choices, track state, and switch to tactical BattleTech tools when the fight becomes a BattleMech-scale tactical engagement.

## GitHub Issues
The issue workflow is documented in `docs/github-issues.md`. Initial issue drafts are listed in `issues/initial-issues.md`.

## Copyright Boundary
Committed files should contain paraphrased summaries, page references, indexes, campaign notes, and procedures. Purchased source files and raw extracted text stay local and ignored.
