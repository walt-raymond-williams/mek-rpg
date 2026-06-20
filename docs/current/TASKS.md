# Tasks

## Now

- No active project-development task is currently in progress.

## Next

- Create the next issue from the pipeline plan: summarize the personal combat and recovery minimum.
- Confirm whether future broad work should use direct-to-`master` or feature branches.
- Use `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md` as the controlling plan for extraction, mapping, summaries, routing, validation, and first playable GM mode.

## Backlog

- Create first playable campaign-state structure.
- Expand GM session logging procedure.
- Create verified paraphrased rule summaries.
- Expand rules routing indexes as summaries become available.
- Add tactical handoff notes for Classic BattleTech, MegaMek, and MekHQ.

## Blocked

- Broader source summarization, routing updates, and validation are blocked until the core pipeline proves out.
- Follow-up issues for mapping, summarization, validation, routing, and first playable GM mode should be created gradually from `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md`.

## Done

- Initial repository scaffold exists.
- GitHub issue `#1` created for workflow hardening.
- Issue `#1` implemented: current docs, templates, issue template, mode router, README pointer, legacy workflow pointers, archived handoff, and no PDF processing.
- GitHub label `user-task` created for user-only work.
- Issue `#2` planned the PDF-to-rules pipeline in `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md`; no PDF processing was performed.
- Issue `#3` created to track extraction of the legally owned PDF into ignored page text.
- Issue `#3` extracted 410 PDF pages into ignored `source/atow-text/page-####.txt` files and recorded safe extraction metadata in `source/extraction-notes.md`; no rule summaries, chapter maps, or rules indexes were created.
- Issue `#4` created to build the initial chapter and section map.
- Issue `#4` implemented: `source/atow-chapter-section-map.md` maps major chapters and candidate section ranges, records the numbered-page offset as `PDF page = printed page + 2`, and avoids live rules summaries or lookup-index updates.
- Issue `#5` created to summarize core resolution rules after mapping is complete.
- Issue `#5` implemented: core summaries under `rules/core/` cover Action Checks, Attribute Checks, Skill Checks, Opposed Actions, Basic Action Resolution, and Edge; live indexes and manifest route to the new summaries.
- Issue `#6` created to validate the core lookup flow after core summaries exist.
- Issue `#6` implemented: `docs/current/CORE_LOOKUP_VALIDATION.md` records scenario lookup tests for core resolution; narrow router and GM bridge fixes make live lookup start from `indexes/task-router.md`.
