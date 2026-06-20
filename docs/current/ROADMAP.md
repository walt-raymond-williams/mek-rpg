# Roadmap

This is the durable planning source for MEK RPG. GitHub Issues are created gradually from these entries when work is ready for execution.

## Current Focus

- Issue `#2` is ready for an agent to plan the PDF-to-rules pipeline. No PDF processing should happen as part of that planning issue.

## Done

### Harden AI workflow using MegaMek workspace patterns

- Status: Done
- Issue: `#1`
- Handoff: `docs/handoffs/archive/harden-ai-workflow-from-megamek-workspace.md`
- Goal: Add durable current docs, templates, mode routing, and close-out discipline adapted to a private A Time of War rules and GM workspace.
- Acceptance: `AGENTS.md` routes play, rules lookup, project development, and source processing; current docs and templates exist; no PDF is processed; changes are committed and pushed.

## Ready For Issue

### Plan PDF-to-rules pipeline for playable A Time of War GM mode

- Status: Issue created
- Issue: `#2`
- Handoff: `docs/handoffs/active/plan-pdf-to-rules-pipeline.md`
- Mode: Project development
- Expected output: a durable pipeline plan for converting a legally owned PDF into private extracted text, paraphrased rule summaries, routing indexes, validation steps, and GM-mode usable procedures
- Notes: This is a planning task only. Do not extract, parse, or summarize the PDF during this issue.

### Extract A Time of War PDF into ignored page text

- Status: Blocked on explicit user request and local PDF placement
- Mode: Source processing
- Expected output: page-level text in ignored `source/atow-text/`, extraction notes, no committed raw source
- Notes: Do not start this from another issue as incidental setup.

### Build initial chapter and section map

- Status: Waiting on extracted page text
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
