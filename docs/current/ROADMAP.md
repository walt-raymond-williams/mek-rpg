# Roadmap

This is the durable planning source for MEK RPG. GitHub Issues are created gradually from these entries when work is ready for execution.

## Current Focus

- The legally owned A Time of War PDF has been extracted into ignored page-level text.
- Issue `#4` produced the initial chapter and section map in `source/atow-chapter-section-map.md`.
- Issue `#5` summarized core resolution rules from the mapped Basic Gameplay ranges.
- Issue `#6` validated the core lookup flow against scenario prompts.
- Issues `#7` through `#12` define the next playable-GM runway: personal combat, combat lookup validation, equipment minimum, campaign setting seed, first playable GM mode, and a manual playtest/bug pass.
- Issue `#7` summarized the personal combat and recovery minimum.
- The next execution task is issue `#8`: validate the personal combat lookup flow by hand.
- Manual validation/playtest checkpoints should recur after new playable layers are added, so gaps become follow-up issues instead of silent assumptions.

## Done

### Summarize personal combat and recovery minimum

- Status: Done
- Issue: `#7`
- Handoff: `docs/handoffs/archive/summarize-personal-combat-recovery-minimum.md`
- Summaries: `rules/personal-combat/overview.md`, `rules/personal-combat/initiative.md`, `rules/personal-combat/action-and-movement.md`, `rules/personal-combat/ranged-attacks.md`, `rules/personal-combat/melee-attacks.md`, `rules/personal-combat/damage.md`, `rules/personal-combat/wounds.md`, `rules/personal-combat/end-phase.md`, and `rules/personal-combat/recovery.md`
- Goal: Create the first playable personal-combat rules layer for initiative, turn flow, movement/action basics, ranged attacks, melee attacks, damage, wounds/effects, end phase, and healing/recovery.
- Acceptance: summaries follow the standard schema, preserve mapped source page references, route live lookup through indexes and manifest, keep tactical BattleTech handoff explicit, and avoid committed raw source text or copied tables.

### Validate core lookup flow

- Status: Done
- Issue: `#6`
- Handoff: `docs/handoffs/archive/validate-core-lookup-flow.md`
- Report: `docs/current/CORE_LOOKUP_VALIDATION.md`
- Goal: Confirm that common core-resolution scenarios can start at `indexes/task-router.md` and reach usable committed summaries without model memory or raw source text.
- Acceptance: scenario lookup tests pass or record clear gaps; narrow routing and GM bridge gaps are fixed; protected source files remain ignored and unstaged.

### Summarize core resolution rules

- Status: Done
- Issue: `#5`
- Handoff: `docs/handoffs/archive/summarize-core-resolution-rules.md`
- Summaries: `rules/core/action-checks.md`, `rules/core/attribute-checks.md`, `rules/core/skill-checks.md`, `rules/core/opposed-actions.md`, `rules/core/basic-action-resolution.md`, and `rules/core/edge.md`
- Goal: Create GM-ready, paraphrased core resolution summaries from the mapped Basic Gameplay source ranges.
- Acceptance: summaries follow the standard schema, preserve source page references, route live lookup through indexes, and avoid committed raw source text or copied tables.

### Build initial chapter and section map

- Status: Done
- Issue: `#4`
- Handoff: `docs/handoffs/archive/build-atow-chapter-section-map.md`
- Map: `source/atow-chapter-section-map.md`
- Goal: Build an initial chapter and section map from ignored A Time of War page text without writing GM-ready summaries or updating live lookup indexes.
- Acceptance: mapped major chapters and candidate section boundaries with stable IDs, PDF and printed page ranges, extraction-quality notes, candidate summary paths, candidate manifest IDs, and status labels. Recorded the numbered-page offset as `PDF page = printed page + 2`.

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
- Acceptance: plan distinguishes ignored source from committed outputs; defines summary schema and routing cues; covers `indexes/task-router.md`, `indexes/rules-map.md`, `indexes/subsystem-index.md`, `indexes/page-reference-index.md`, and `indexes/manifest.yaml`; keeps source processing blocked until explicit user request and local PDF presence.

### Harden AI workflow using MegaMek workspace patterns

- Status: Done
- Issue: `#1`
- Handoff: `docs/handoffs/archive/harden-ai-workflow-from-megamek-workspace.md`
- Goal: Add durable current docs, templates, mode routing, and close-out discipline adapted to a private A Time of War rules and GM workspace.
- Acceptance: `AGENTS.md` routes play, rules lookup, project development, and source processing; current docs and templates exist; no PDF is processed; changes are committed and pushed.

## Ready For Issue

### Validate personal combat lookup flow by hand

- Status: Issue created
- Issue: `#8`
- Handoff: `docs/handoffs/active/validate-personal-combat-lookup-flow.md`
- Mode: Project development / manual validation
- Expected output: scenario lookup report, narrow routing fixes, and follow-up issues for personal-combat lookup bugs.

### Add equipment minimum summaries

- Status: Issue created; recommended after issue `#7`
- Issue: `#9`
- Handoff: `docs/handoffs/active/add-equipment-minimum-summaries.md`
- Mode: Source processing / project development
- Expected output: paraphrased gear, weapons, armor/protection, electronics, and medical/personal gear lookup summaries with page references and no copied tables.

### Create BattleTech campaign setting seed

- Status: Issue created
- Issue: `#10`
- Handoff: `docs/handoffs/active/create-battletech-campaign-setting-seed.md`
- Mode: Project development
- Expected output: durable campaign setting assumptions for era, faction focus, canon strictness, tone, starting region, and initial scenario hooks.

### Build first playable GM mode

- Status: Issue created; blocked until enough play summaries and setting seed exist
- Issue: `#11`
- Handoff: `docs/handoffs/active/build-first-playable-gm-mode.md`
- Mode: Project development
- Expected output: usable campaign-state structure, session procedure, first test mission/scaffold, and bug/gap reporting path.

### Run first manual playtest and file follow-up bugs

- Status: Issue created; blocked until issue `#11`
- Issue: `#12`
- Handoff: `docs/handoffs/active/run-first-manual-playtest-and-file-follow-up-bugs.md`
- Mode: Play mode / project development close-out
- Expected output: short manual playtest, campaign/playtest state updates, and follow-up bug or missing-rule issues.

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
- Repeat manual validation after each new playable layer: source summaries, routing, GM procedure, playtest, bug issues.

## Existing Foundation

- Initial project scaffolding exists with `gm/`, `indexes/`, `rules/`, `source/`, scripts, and starter docs.
- PDF extraction script exists, but no PDF processing has been performed as part of issue `#1`.
- Issue `#1` implementation adds the `docs/current/` workflow layer, handoff template, GitHub issue template, mode router, and updated entry-point docs.
- GitHub labels `agent-task` and `user-task` exist for agent-executed work and user-only work.

## Open Questions

- Should future broad work use feature branches, or is direct-to-`master` acceptable for this private repo until the project grows?
- Should `issues/initial-issues.md` remain as a historical seed list after this roadmap exists?
