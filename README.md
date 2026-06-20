# MEK RPG

MEK RPG is a private personal-use workspace for running a BattleTech RPG campaign with A Time of War style roleplaying rules. It supports rules lookup, GM assistance, campaign state tracking, and handoff to Classic BattleTech, MegaMek, or MekHQ when tactical BattleMech combat is needed.

## What It Is Not

This project is not a redistribution of copyrighted rulebooks. It should not contain purchased PDFs, EPUBs, copied tables, raw extracted text, or large verbatim extracted passages in committed files.

## Operating Modes

- `Play mode`: run scenes, present choices and consequences, request rolls only when failure matters, start from `campaign-state/active-campaign.md`, and update the selected `campaigns/<campaign-id>/` save folder when persistent state changes.
- `Rules lookup mode`: start at `indexes/task-router.md`, answer from paraphrased summaries, and cite page references when summaries are incomplete.
- `Project development mode`: improve the repository using `docs/current/`, GitHub Issues, handoffs, commits, and pushes.
- `Source processing mode`: explicitly requested PDF extraction, section mapping, and paraphrased summarization under strict copyright boundaries.

The full mode router is in `AGENTS.md` and `docs/current/MEK_RPG_PROJECT_PROFILE.md`.

## Current Workflow Docs

- `docs/current/AI_READY_PROJECT_WORKFLOW.md`: durable AI workflow pattern.
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`: project profile, protected inputs, modes, and BattleTech posture.
- `docs/current/ROADMAP.md`: durable planning source.
- `docs/current/TASKS.md`: current work board.
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`: issue and handoff lifecycle.
- `docs/current/DOCUMENTATION_WORKFLOW.md`: where durable knowledge belongs.
- `docs/current/SOURCE_PROCESSING_WORKFLOW.md`: PDF extraction and summarization workflow.
- `docs/current/KNOWN_COMMANDS.md`: repeatable local commands.

## PDF Placement

Put your legally owned PDF in:

```text
source/atow-pdf/
```

The PDF path is ignored by git. Do not commit the PDF.

## Extraction Workflow

Only after an explicit source-processing request, run:

```sh
./scripts/extract-pdf-pages.sh "source/atow-pdf/A Time of War.pdf"
```

The script extracts one text file per page into ignored `source/atow-text/` if `pdftotext` is installed. Extracted text is ignored by git.

## Summary Structure

Rule summaries live under `rules/` and follow a standard schema: purpose, when to use, when not to use, procedure, GM guidance, edge cases, related files, source references, and status.

## GM Mode

GM procedures live under `gm/`. The agent should frame scenes concisely, ask for rolls only when failure matters, offer concrete choices, track state in the active campaign save folder under `campaigns/`, and switch to tactical BattleTech tools when the fight becomes a BattleMech-scale tactical engagement.

Campaign save folders live under `campaigns/`. Use `campaign-state/active-campaign.md` to select the save before play; `campaign-state/` also keeps the global setting seed and legacy prototype notes from early playtests.

## GitHub Issues

Issue workflow is documented in `docs/current/GITHUB_ISSUE_WORKFLOW.md`. Initial issue drafts remain in `issues/initial-issues.md`; durable planning now lives in `docs/current/ROADMAP.md`.
