# Plan PDF-To-Rules Pipeline

## Issue

- GitHub issue: https://github.com/walt-raymond-williams/mek-rpg/issues/2
- Roadmap entry: Plan PDF-to-rules pipeline for playable A Time of War GM mode
- Mode: Project development
- Priority: High

## Goal

Create a concrete, staged plan for turning a legally owned A Time of War PDF into usable private rule documents for running an RPG campaign in this repository.

This issue is a planning task only. Do not process the PDF, extract text, summarize source pages, or write verified rules content as part of this issue.

The output should make the later source-processing work safe, resumable, and useful for actual play.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/SOURCE_PROCESSING_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `indexes/task-router.md`
- `indexes/rules-map.md`
- `indexes/manifest.yaml`
- `rules/README.md`
- `gm/scene-loop.md`
- `gm/switch-to-classic-battletech.md`
- `scripts/extract-pdf-pages.sh`
- `scripts/summarize-section-prompt.md`

## Expected Output

Create a durable planning document, recommended path:

- `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md`

The plan should define:

- goals for "usable to run an A Time of War RPG game"
- source-processing stages from PDF placement through verified summaries
- what files are private/ignored versus committed
- chapter and section mapping strategy
- page-reference and printed-page offset strategy
- rule-summary batching order
- summary validation process
- routing/index/manifest update process
- GM-mode integration points
- tactical BattleTech handoff integration points
- issue breakdown for the next executable tasks
- acceptance criteria for each stage
- risks, blockers, and open questions

## Files And Areas

Likely files to read or edit:

- `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/current/SOURCE_PROCESSING_WORKFLOW.md`
- `docs/handoffs/active/plan-pdf-to-rules-pipeline.md`
- possibly `issues/initial-issues.md` if it needs a pointer to the current roadmap

## Commands

Useful commands or checks:

```powershell
git status --short --branch
git check-ignore source/atow-pdf/example.pdf source/atow-text/page-0001.txt
gh issue view 2
```

## Constraints

- Do not process any PDF.
- Do not inspect, extract, OCR, summarize, or quote source book text.
- Do not commit purchased PDFs, raw extracted text, copied tables, or copyrighted rulebook passages.
- Keep the plan practical for both rules lookup and live GM play.
- Preserve the mode split: Play mode, Rules lookup mode, Project development mode, and Source processing mode.
- Commit and push completed project-development changes unless explicitly told not to.

## Acceptance Criteria

- `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md` exists and is specific enough for another agent to execute the source-processing work later.
- The plan distinguishes ignored private source files from committed paraphrased outputs.
- The plan defines a staged issue sequence for extraction, section mapping, summarization, validation, routing/index updates, and GM-mode usability.
- The plan explains how summaries become usable during actual play without relying on model memory.
- `docs/current/ROADMAP.md` and `docs/current/TASKS.md` are updated with the planning result and next recommended issue.
- No PDF processing is performed.
- Verification is run or a blocker is recorded.
- Changes are committed and pushed.

## Open Questions

- What exact PDF filename will the user place under `source/atow-pdf/`?
- Should the first playable summary target core resolution only, or include enough combat/recovery rules for a first session?
- Should tactical BattleTech handoff notes be planned before or after core RPG rules summaries?
