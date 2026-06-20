# Tasks

## Now

- No active local implementation task. Source processing is blocked until the user explicitly requests it and the legally owned PDF is present locally.

## Next

- After explicit user request and local PDF placement, create/start the extraction issue: extract the legally owned A Time of War PDF into ignored page text.
- Confirm whether future broad work should use direct-to-`master` or feature branches.
- Use `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md` as the controlling plan for extraction, mapping, summaries, routing, validation, and first playable GM mode.

## Backlog

- Create first playable campaign-state structure.
- Expand GM session logging procedure.
- Build section map after source extraction.
- Create verified paraphrased rule summaries.
- Expand rules routing indexes as summaries become available.
- Add tactical handoff notes for Classic BattleTech, MegaMek, and MekHQ.

## Blocked

- PDF extraction and source summarization are blocked until the user explicitly requests source processing and the legally owned PDF is present under `source/atow-pdf/`.
- Follow-up issues for mapping, summarization, validation, routing, and first playable GM mode should be created gradually from `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md` as blockers clear.

## Done

- Initial repository scaffold exists.
- GitHub issue `#1` created for workflow hardening.
- Issue `#1` implemented: current docs, templates, issue template, mode router, README pointer, legacy workflow pointers, archived handoff, and no PDF processing.
- GitHub label `user-task` created for user-only work.
- Issue `#2` planned the PDF-to-rules pipeline in `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md`; no PDF processing was performed.
