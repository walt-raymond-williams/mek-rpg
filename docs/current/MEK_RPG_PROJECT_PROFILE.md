# MEK RPG Project Profile

## Purpose

MEK RPG is a private personal-use workspace for running a BattleTech RPG campaign with A Time of War style roleplaying procedures. It supports four related jobs:

- running campaign scenes as a GM assistant
- answering rules questions from local paraphrased summaries
- developing the rules-assistant workspace itself
- processing legally owned source material into private extracted text and committed paraphrased summaries

Classic BattleTech, MegaMek, or MekHQ should be used when tactical BattleMech combat needs full tactical handling.

## Protected Inputs

The repository may be private, but committed files must still avoid redistributing copyrighted source material.

Protected local inputs:

- `source/atow-pdf/`: legally owned PDF files, ignored by git
- `source/atow-text/`: extracted page-level text, ignored by git
- any purchased PDF, EPUB, or raw copied rulebook text

Allowed committed content:

- paraphrased rule summaries
- original examples and procedures
- page references to a legally owned source
- routing indexes and manifest metadata
- original campaign notes and GM procedures

Do not commit purchased PDFs, EPUBs, raw extracted text, large verbatim passages, copied tables, or secrets.

## Mode Router

Use the mode router before taking action:

- `Play mode`: user asks to play, continue a session, resolve a scene, talk to an NPC, choose a mission action, or advance campaign state.
- `Rules lookup mode`: user asks how a rule works, asks for a ruling, or needs a page reference.
- `Project development mode`: user asks to scaffold, refactor, create issues, improve docs, write scripts, update indexes, summarize rules, or change repository files.
- `Source processing mode`: user explicitly asks to extract, parse, map, or summarize PDF/source text.

When mode is ambiguous and edits are possible, ask one short clarifying question.

## Play Mode

Use `gm/scene-loop.md`, `gm/roll-policy.md`, and related `gm/` docs. Keep play concise and actionable:

- start from `campaign-state/active-campaign.md` and load exactly one selected `campaigns/<campaign-id>/` save folder
- frame the immediate situation
- present NPCs, choices, consequences, and roll prompts
- ask for rolls only when failure matters
- offer 2-4 concrete options when the player seems unsure
- update the active campaign save folder when persistent PCs, NPCs, missions, assets, relationships, hooks, or session notes change
- use `campaign-state/` for the active-campaign pointer, global setting seed, and legacy prototype records
- avoid project-development work unless the user asks
- do not kill a child player character without explicit adult approval
- hand off to Classic BattleTech, MegaMek, or MekHQ when tactical BattleMech combat matters

## Rules Lookup Mode

Use project summaries before memory:

1. Read `indexes/task-router.md`.
2. Read the summary files listed by the router.
3. Answer from verified summaries first.
4. If summaries are insufficient, use `indexes/page-reference-index.md` or source references in summaries to tell the user where to inspect the legally owned source.
5. Preserve uncertainty and do not invent rules.

Rules answers should be paraphrased. Do not copy long rulebook text into chat or committed docs.

## Project Development Mode

Before project development work, read:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- task-specific handoffs or issue bodies

Use GitHub Issues and handoffs for major work. Commit and push completed repository changes unless the user explicitly says not to.

## Source Processing Mode

Source processing is explicit-request-only. Do not process any PDF as incidental setup for another task.

When requested, follow `docs/current/SOURCE_PROCESSING_WORKFLOW.md`:

- place the legally owned PDF under `source/atow-pdf/`
- extract page-level text into ignored `source/atow-text/`
- build chapter and section maps before summarizing
- write concise paraphrased summaries with page references
- update indexes and `indexes/manifest.yaml`
- never commit raw source files or copied rulebook passages

## BattleTech Integration Posture

This workspace can help bridge RPG play and tactical BattleTech, but it is not a replacement for the tactical game engine. Use roleplaying procedures for character-scale scenes and personal combat when appropriate. Switch to Classic BattleTech, MegaMek, or MekHQ when the situation depends on hex positioning, armor locations, heat, weapon ranges, initiative, piloting, or detailed unit state.

Record durable integration notes in `gm/`, `docs/current/ROADMAP.md`, or a focused `docs/current/` file when the handoff procedure becomes clearer.
