# Roadmap

This is the durable planning source for MEK RPG. GitHub Issues are created gradually from these entries when work is ready for execution.

## Current Focus

- The legally owned A Time of War PDF has been extracted into ignored page-level text.
- Issue `#4` produced the initial chapter and section map in `source/atow-chapter-section-map.md`.
- Issue `#5` summarized core resolution rules from the mapped Basic Gameplay ranges.
- Issue `#6` validated the core lookup flow against scenario prompts.
- Issues `#7` through `#12` define the next playable-GM runway: personal combat, combat lookup validation, equipment minimum, campaign setting seed, first playable GM mode, and a manual playtest/bug pass.
- Issue `#7` summarized the personal combat and recovery minimum.
- Issue `#8` validated the personal combat lookup flow by hand.
- Issue `#9` added the minimum equipment lookup layer.
- Issue `#10` created the campaign setting seed and canon policy.
- Issue `#11` built the first playable GM mode around a session procedure, campaign-state structure, and `Checkpoint Ghosts` test mission.
- Issue `#12` ran the first manual playtest and captured follow-up gaps from a Galatea DropShip purchase scene.
- Issue `#13` designed durable campaign memory tracking around campaign-specific save folders/state roots.
- Issue `#14` tracks the follow-up review fix to align stale docs/router references with the new campaign save-folder model.
- Manual validation/playtest checkpoints should recur after new playable layers are added, so gaps become follow-up issues instead of silent assumptions.

## Ready For Issue

### Align campaign-memory references after issue `#13` review

- Status: Issue created; ready
- Issue: `#14`
- Handoff: `docs/handoffs/active/align-campaign-memory-references.md`
- Mode: Project development
- Expected output: update stale router, setting, profile, README, and GM references so persistent play state consistently uses `campaign-state/active-campaign.md` and the selected `campaigns/<campaign-id>/` save folder; add a lightweight session-history convention.

## Done

### Design durable campaign memory tracking

- Status: Done
- Issue: `#13`
- Handoff: `docs/handoffs/archive/design-durable-campaign-memory.md`
- Strategy: `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`
- Save folders: `campaigns/README.md`, `campaigns/_template/`, and `campaigns/playtest-galatea-dropship/`
- GM procedure: `gm/session-procedure.md` and `gm/state-save-checklist.md`
- Goal: Make campaign continuity durable without relying on chat context or Git history as the play-state mechanism.
- Acceptance: current flat campaign-state coverage was audited; campaign-local files now cover PCs, NPCs, factions, locations, assets, relationships, missions, hooks, session logs, rules gaps, playtest notes, and safety/tone; the Galatea DropShip playtest is isolated as a non-canon playtest save; GM play now has an active-campaign load step and state-save checklist.

### Run first manual playtest and file follow-up bugs

- Status: Done
- Issue: `#12`
- Handoff: `docs/handoffs/archive/run-first-manual-playtest-and-file-follow-up-bugs.md`
- Playtest record: `campaign-state/session-log.md`
- Goal: Run a short manual playtest of the first playable GM mode and turn rough edges into concrete follow-up notes.
- Acceptance: Galatea DropShip purchase scene was played with Walter and Sharpe; rules lookup used the router before a technical inspection roll; playtest-only PCs, NPCs, factions, hooks, rules gaps, and workflow bugs were recorded; issue `#13` handoff now includes the campaign-specific save-folder requirement.

### Build first playable GM mode

- Status: Done
- Issue: `#11`
- Handoff: `docs/handoffs/archive/build-first-playable-gm-mode.md`
- Session procedure: `gm/session-procedure.md`
- Mission scaffold: `campaign-state/current-mission.md`
- State files: `campaign-state/session-log.md`, `campaign-state/rules-gaps.md`, and `campaign-state/playtest-bugs.md`
- Goal: Turn the rules summaries, router, campaign-state files, and GM procedures into a first playable tabletop loop that can run a short mission scene.
- Acceptance: campaign-state structure covers current mission, PCs, NPCs, factions, session log, unresolved hooks, rules gaps, and playtest bugs; session procedure links scene loop, roll policy, task router, setting seed, and tactical handoff; `Checkpoint Ghosts` exists as the first manual playtest scaffold; issue `#12` is ready as the next task.

### Create BattleTech campaign setting seed

- Status: Done
- Issue: `#10`
- Handoff: `docs/handoffs/archive/create-battletech-campaign-setting-seed.md`
- Seed: `campaign-state/setting-basics.md`
- Goal: Create durable campaign setting assumptions and open-choice prompts for era, faction focus, canon strictness, tone, starting region, and initial scenario hooks.
- Acceptance: setting seed records table canon versus lookup-needed canon versus improvisable color, marks user choices as `Needs user decision` or `TBD`, provides starter hooks, links from campaign-state and GM docs, and avoids copied copyrighted lore text.

### Add equipment minimum summaries

- Status: Done
- Issue: `#9`
- Handoff: `docs/handoffs/archive/add-equipment-minimum-summaries.md`
- Summaries: `rules/equipment/overview.md`, `rules/equipment/weapons.md`, `rules/equipment/armor.md`, `rules/equipment/electronics.md`, `rules/equipment/medical-gear.md`, and `rules/equipment/personal-gear.md`
- Goal: Create the minimum equipment lookup layer for acquiring and using gear, weapons, armor/protection, electronics, medical gear, and common personal mission gear.
- Acceptance: summaries follow the standard schema, preserve mapped source page references, route live lookup through indexes and manifest, keep table-heavy item details page-referenced, and avoid committed raw source text, copied tables, item lists, or stat blocks.

### Validate personal combat lookup flow by hand

- Status: Done
- Issue: `#8`
- Handoff: `docs/handoffs/archive/validate-personal-combat-lookup-flow.md`
- Report: `docs/current/PERSONAL_COMBAT_LOOKUP_VALIDATION.md`
- Goal: Confirm that common personal-combat scenarios can start at `indexes/task-router.md` and reach usable committed summaries without model memory or raw source text.
- Acceptance: scenario lookup tests cover initiative, ranged attacks, melee/grappling, damage/wounds, treatment/recovery, and tactical handoff; router paths pass with caveats recorded for equipment, campaign recovery, and table-heavy details.

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

## Historical Ready Issues

### Validate personal combat lookup flow by hand

- Status: Done; see Done section
- Issue: `#8`
- Handoff: `docs/handoffs/archive/validate-personal-combat-lookup-flow.md`
- Mode: Project development / manual validation
- Output: `docs/current/PERSONAL_COMBAT_LOOKUP_VALIDATION.md`

### Create BattleTech campaign setting seed

- Status: Done; see Done section
- Issue: `#10`
- Handoff: `docs/handoffs/archive/create-battletech-campaign-setting-seed.md`
- Mode: Project development
- Output: `campaign-state/setting-basics.md`

### Build first playable GM mode

- Status: Done; see Done section
- Issue: `#11`
- Handoff: `docs/handoffs/archive/build-first-playable-gm-mode.md`
- Mode: Project development
- Output: `gm/session-procedure.md`, `campaign-state/current-mission.md`, `campaign-state/session-log.md`, `campaign-state/rules-gaps.md`, and `campaign-state/playtest-bugs.md`.

### Run first manual playtest and file follow-up bugs

- Status: Done; see Done section
- Issue: `#12`
- Handoff: `docs/handoffs/archive/run-first-manual-playtest-and-file-follow-up-bugs.md`
- Mode: Play mode / project development close-out
- Output: playtest record, campaign-state updates, rules gaps, workflow bugs, and issue `#13` memory-design input.

### Design durable campaign memory tracking

- Status: Done; see Done section
- Issue: `#13`
- Handoff: `docs/handoffs/archive/design-durable-campaign-memory.md`
- Mode: Project development
- Output: `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`, `campaign-state/active-campaign.md`, `campaigns/`, and `gm/state-save-checklist.md`.

## Backlog

- Summarize character creation: lifepaths, attributes, traits, skills, and advancement.
- Summarize skills and traits: expand routing and source references.
- Summarize personal combat: initiative, attacks, and combat flow.
- Summarize damage and recovery: wounds, treatment, and recovery.
- Summarize BattleTech integration: MechWarrior skills and tactical conversion.
- Expand `indexes/task-router.md` after verified summaries exist.
- Fill `indexes/manifest.yaml` with stable IDs and source page arrays.
- Create first test campaign setup with PCs, NPCs, mission, and hooks.
- Create helper script to start a new campaign save folder from `campaigns/_template/`.
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
