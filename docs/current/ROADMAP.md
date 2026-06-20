# Roadmap

This is the durable planning source for MEK RPG. GitHub Issues are created gradually from these entries when work is ready for execution.

## Current Focus

- The legally owned A Time of War PDF has been extracted into ignored page-level text.
- Next recommended issue: build the initial chapter and section map. Do not summarize rules or update rules indexes until mapping work is explicitly requested.

## Done

### Extract A Time of War PDF into ignored page text

- Status: Done
- Issue: `#3`
- Handoff: `docs/handoffs/archive/extract-atow-pdf-page-text.md`
- Notes: Extracted 410 PDF pages from the legally owned local PDF into ignored `source/atow-text/page-####.txt` files. Recorded extraction metadata in `source/extraction-notes.md`.
- Acceptance: `.gitignore` protects the source PDF and extracted text paths; raw source files remained ignored and unstaged; no rule summaries, chapter maps, or rules indexes were created or updated.

### Plan PDF-to-rules pipeline for playable A Time of War GM mode

- Status: Done
- Issue: `#2`
- Handoff: `docs/handoffs/archive/plan-pdf-to-rules-pipeline.md`
- Plan: `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md`
- Goal: Define a staged pipeline from private ignored PDF extraction through chapter mapping, paraphrased summaries, routing indexes, validation, and GM-mode integration.
- Acceptance: plan distinguishes ignored source from committed outputs; defines summary schema and routing cues; covers `indexes/task-router.md`, `rules-map.md`, `subsystem-index.md`, `page-reference-index.md`, and `manifest.yaml`; keeps source processing blocked until explicit user request and local PDF presence.

### Harden AI workflow using MegaMek workspace patterns

- Status: Done
- Issue: `#1`
- Handoff: `docs/handoffs/archive/harden-ai-workflow-from-megamek-workspace.md`
- Goal: Add durable current docs, templates, mode routing, and close-out discipline adapted to a private A Time of War rules and GM workspace.
- Acceptance: `AGENTS.md` routes play, rules lookup, project development, and source processing; current docs and templates exist; no PDF is processed; changes are committed and pushed.

## Ready For Issue

### Build initial chapter and section map

- Status: Ready for issue
- Mode: Source processing
- Expected output: chapter/section map with page references and uncertainty markers

### Summarize core resolution rules

- Status: Waiting on section map and source review
- Mode: Source processing / project development
- Expected output: paraphrased summaries for task checks, opposed checks, modifiers, and margin of success with page references

### Create first playable GM mode

- Status: Candidate
- Mode: Project development
- Expected output: usable campaign-state structure, session log procedure, initial scene flow, and player-facing safety posture

## Backlog

- Summarize character creation: lifepaths, attributes, traits, skills, and advancement.
- Summarize skills and traits: expand routing and source references.
- Summarize personal combat: initiative, attacks, and combat flow.
- Summarize damage and recovery: wounds, treatment, and recovery.
- Summarize BattleTech integration: MechWarrior skills and tactical conversion.
- Expand `indexes/task-router.md` after verified summaries exist.
- Fill `indexes/manifest.yaml` with stable IDs and source page arrays.
- Create first test campaign setup with PCs, NPCs, mission, and hooks.
- Validate all summaries against source pages.
- Add MekHQ / MegaMek integration notes for encounter handoff, pilot conversion, unit setup, and campaign updates.

## Existing Foundation

- Initial project scaffolding exists with `gm/`, `indexes/`, `rules/`, `source/`, scripts, and starter docs.
- PDF extraction script exists, but no PDF processing has been performed as part of issue `#1`.
- Issue `#1` implementation adds the `docs/current/` workflow layer, handoff template, GitHub issue template, mode router, and updated entry-point docs.
- GitHub labels `agent-task` and `user-task` exist for agent-executed work and user-only work.

## Open Questions

- Should future broad work use feature branches, or is direct-to-`master` acceptable for this private repo until the project grows?
- Should `issues/initial-issues.md` remain as a historical seed list after this roadmap exists?
