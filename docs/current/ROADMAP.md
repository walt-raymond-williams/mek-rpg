# Roadmap

This is the durable planning source for MEK RPG. GitHub Issues are created gradually from these entries when work is ready for execution.

## Current Focus

- The legally owned A Time of War PDF has been extracted into ignored page-level text.
- Issue `#4` produced the initial chapter and section map in `source/atow-chapter-section-map.md`.
- Core resolution, character creation, personal combat, equipment, campaign consequences, and vehicles/MechWarrior bridge have draft paraphrased summaries with live router coverage and validation reports where applicable.
- Glossary and deeper metadata remain placeholder-level and need source review before they can support serious rules lookup.
- Campaign play now uses `campaign-state/active-campaign.md` plus exactly one selected `campaigns/<campaign-id>/` save folder. Legacy flat `campaign-state/` files remain historical prototype records.
- Helper scripts now cover creating campaign saves from `campaigns/_template/`, validating campaign-state structure, and rolling simple live-play dice expressions.
- Campaign-state lifecycle automation has a first validator for active campaign selection, template structure, and campaign save completeness.
- Manual validation/playtest checkpoints should recur after new playable layers are added, so gaps become follow-up issues instead of silent assumptions.
- MekHQ-to-MEK-RPG campaign bootstrap is now tracked as a staged exploration epic. The goal is to test whether a MekHQ campaign save can seed a playable MEK-RPG campaign folder while MekHQ remains the hard logistics and tactical ledger.
- GM context architecture is now tracked as a staged design epic informed by AI Dungeon-style memory lessons. The goal is to assemble play context from explicit, inspectable layers while keeping rules summaries, structured campaign state, narrative memory, and MekHQ-owned facts separate.

## Coverage Status

### Drafted And Routed

- Core resolution: Action Checks, Attribute Checks, Skill Checks, Opposed Actions, Basic Action Resolution, and Edge.
- Character creation: overview, lifepaths/Life Modules, attributes, traits, skills, and XP advancement.
- Personal combat: overview/turn flow, initiative, action and movement, ranged attacks, melee attacks, damage, wounds/effects, end phase, and healing/recovery.
- Equipment: acquisition/use, weapons, armor/protection, electronics, medical gear, and personal gear.
- Campaign systems: consequence overview, advancement, contracts, contacts, reputation, injury recovery, downtime, and mission readiness.
- Vehicles and MechWarrior bridge: vehicle/BattleMech overview, Piloting, Gunnery, MechWarrior skills, RPG-to-Classic BattleTech conversion, and tactical handoff routing.
- GM flow: scene loop, roll policy, session procedure, state-save checklist, and tactical handoff procedure.

### Placeholder-Level

- Glossary and deeper index metadata: stable term definitions, expanded page references, and manifest coverage for placeholder subsystems.

### Validation Needs

- Existing draft summaries should be validated against scenario prompts after each major routing change.
- Placeholder summaries should not be treated as rules authority until source pages are reviewed, page references are added, and router paths pass lookup tests.
- The campaign save helper and dice roller were rechecked during the first real campaign setup and live-play session. Repeat manual validation/playtest after future major playable layers.

## Active Work

None.

## Ready For Issue Candidates

- None currently unissued. Open MekHQ bridge issues `#25`, `#27`, and `#28`, plus GM context architecture issues `#30`-`#34`, are the active staged exploration paths.

## Open Issues

### MekHQ-to-MEK-RPG campaign bridge epic

- Status: Open
- Epic issue: `#25`
- Mode: Project development / play workflow design
- Source context:
  - `C:\Users\waltr\Documents\megamek-workspace\docs\current\MEK_RPG_MEKHQ_COLLABORATION_BRIEF.md`
  - `C:\Users\waltr\Documents\megamek-workspace\docs\current\MEK_RPG_MEKHQ_INTEGRATION_ASSESSMENT.md`
- Goal: explore whether MEK-RPG can import or summarize a MekHQ `.cpnx` / `.cpnx.gz` campaign save, generate a playable `campaigns/<campaign-id>/` folder, support one-day RPG play from a selected character viewpoint, and preserve RPG-only memory while keeping MekHQ authoritative for hard logistics.
- Ownership boundary: MekHQ should own campaign date, funds, unit rosters, personnel ledger fields, repairs, contracts, markets, tactical consequences, and scenario outcomes. MEK-RPG should own A Time of War PCs, RPG scenes, NPC motives, relationship memory, promises, secrets, hooks, safety/tone, and narrative uncertainty.
- Initial child issues:
  - Issue `#26`: define MekHQ bridge data model and campaign-folder mapping.
  - Done in issue `#29`: define MekHQ-linked one-day play loop and writeback boundaries before campaign bootstrap implies write behavior.
  - Issue `#27`: prototype read-only MekHQ save summary helper after issue `#26` sets field priorities; handoff at `docs/handoffs/active/prototype-read-only-mekhq-save-summary-helper.md`.
  - Issue `#28`: prototype MekHQ campaign bootstrap into a MEK-RPG save folder after mapping, summary input, and play/writeback boundaries are clear.
- Deferred until source-backed confidence improves: direct MekHQ save writes, headless day advancement, automatic purchase/contract/repair writeback, and any broad changes to MekHQ internals.

### Dependency Order

1. Done in issue `#26`: `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md` defines the ownership model, campaign-folder mapping, ID preservation, and uncertainty policy.
2. Done in issue `#29`: `docs/current/MEKHQ_LINKED_PLAY_LOOP.md` defines the one-day play loop and writeback boundaries so later bootstrap work does not imply unsafe direct MekHQ writes.
3. Issue `#27` builds the read-only save summary helper using the issue `#26` field priorities. Representative disposable saves already exist under `C:\Users\waltr\Documents\megamek-workspace\`; no purchased A Time of War source is involved.
4. Issue `#28` uses the mapping, read-only summary output, and play/writeback boundaries to generate a MEK-RPG campaign folder without overwriting existing saves.
5. The epic issue `#25` stays open until the staged bridge proves useful or is deliberately abandoned.

### Not Yet Promoted

- Direct `.cpnx` / `.cpnx.gz` writeback.
- Headless MekHQ day advancement.
- Automatic purchases, contract acceptance, repair changes, or personnel changes in MekHQ.
- Broad MekHQ source changes.
- Dedicated validators for MekHQ-linked campaign folders; add them only after issue `#28` establishes stable generated file conventions.

### GM context architecture epic

- Status: Open
- Epic issue: `#30`
- Mode: Project development / play workflow design
- Research input: AI Dungeon and Latitude public memory/model-development notes suggest that long-running AI RPG play benefits from explicit context layers, distinct summary and memory roles, semantic checkpoints, portable model assumptions, and regression-style evaluation.
- Goal: define a repeatable GM context packet workflow that assembles the active campaign, current scene, structured campaign files, rules routes, recent event history, older summaries, relevant hooks or memories, and optional MekHQ bridge facts without blurring ownership boundaries.
- Ownership boundary: rules summaries and indexes should guide procedures; campaign save files should own persistent RPG state; narrative summaries should compress continuity but not override structured sheets; MekHQ should remain authoritative for hard logistics where the bridge applies; the LLM should frame scenes and make judgment calls from the assembled context.
- Initial child issues:
  - Issue `#31`: define GM context packet design.
  - Issue `#32`: define campaign memory strata and semantic checkpoints.
  - Issue `#33`: prototype GM context packet helper after issue `#31` defines the packet shape.
  - Issue `#34`: add GM context regression scenarios after issue `#31` defines expected context behavior.
- Deferred until the design proves useful: vector-memory experiments, model-specific prompt tuning, automatic narrative summary rewrites, and any direct MekHQ writeback behavior.

### GM Context Dependency Order

1. Issue `#31` defines the packet layers, authority order, source files, and mode differences.
2. Issue `#32` defines checkpoint triggers and how campaign-local files divide recent log, compressed summary, structured state, hooks, rules gaps, and corrected facts.
3. Issue `#33` builds a deterministic helper that reports or assembles packet inputs without inventing facts or interpreting rules.
4. Issue `#34` validates continuity, rules routing, structured-state precedence, stale-memory avoidance, and MekHQ ownership boundaries against repeatable scenarios.
5. The epic issue `#30` stays open until the context-packet workflow is documented, usable in play, and validated enough to become normal GM procedure.

## Done

### Define MekHQ-linked one-day play loop and writeback boundaries

- Status: Done
- Issue: `#29`
- Handoff: `docs/handoffs/archive/define-mekhq-linked-one-day-play-loop.md`
- Design note: `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- Mode: Project development / play workflow design
- Goal: define the safe one-day RPG play loop for MekHQ-linked campaigns and document what remains MEK-RPG-only memory, what the user applies manually in MekHQ, what can be handed off as artifacts, what needs future source-backed automation, and what is unsafe.
- Acceptance: design note covers MekHQ ownership of day advancement and hard ledger changes; MEK-RPG ownership of scenes, RPG memory, A Time of War overlays, relationships, hooks, session logs, rules gaps, and safety/tone; pre-session import/checkpoint expectations; in-day scene handling; post-scene and end-of-day save/update expectations; conversation, promise, relationship, hidden motive, hook, and session-log storage; purchases, injuries, contract decisions, repairs, personnel changes, and battle outcome queues; and a writeback boundary matrix that keeps direct `.cpnx`, `.cpnx.gz`, and XML edits unsafe and out of scope.

### Define MekHQ bridge data model and campaign-folder mapping

- Status: Done
- Issue: `#26`
- Handoff: `docs/handoffs/archive/define-mekhq-bridge-data-model.md`
- Design note: `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- Mode: Project development / design
- Goal: Define how MekHQ-owned hard campaign facts map into MEK-RPG campaign folders, how MekHQ IDs are preserved, and how RPG-only narrative memory stays separate.
- Acceptance: design note covers MekHQ-owned hard facts; MEK-RPG-owned RPG, narrative, and A Time of War facts; campaign-file mapping for date, location, funds, personnel, units, assets, contracts, scenarios, repairs, logistics alerts, and markets; overlay mapping for PCs, NPC memory, relationships, hooks, missions, session logs, rules gaps, and safety/tone; ID and slug strategy; unknown/unsupported handling; read-only import boundary; and explicit non-goals.

### Create first real campaign save and live helper validation

- Status: Done
- Issue: `#24`
- Handoff: `docs/handoffs/archive/create-first-real-campaign-save-live-validation.md`
- Save folder: `campaigns/isekai-atlas-field/`
- Mode: Play mode / project development close-out
- Goal: Create the first table-canon campaign save from a user-confirmed premise and validate campaign helper scripts in a live workflow.
- Acceptance: user confirmed the isekai Atlas-field campaign frame and active campaign selection; `new-campaign-save.ps1` created the save folder without moving the active pointer; `validate-campaign-state.ps1 -CampaignId isekai-atlas-field` and `-StrictActive` passed; a short live-play scene exercised the save loop; `gm/state-save-checklist.md` guided persistent updates; validator maintenance was considered and deferred because no required save-file structure changed; follow-up validator and tactical-handoff needs were recorded as task notes.

### Build vehicles and MechWarrior bridge

- Status: Done
- Issue: `#23`
- Handoff: `docs/handoffs/archive/build-vehicles-mechwarrior-bridge.md`
- Report: `docs/current/VEHICLE_MECHWARRIOR_BRIDGE_VALIDATION.md`
- Summaries: `rules/vehicles-and-mechs/overview.md`, `rules/vehicles-and-mechs/piloting.md`, `rules/vehicles-and-mechs/gunnery.md`, `rules/vehicles-and-mechs/mechwarrior-skills.md`, and `rules/vehicles-and-mechs/converting-to-classic-battletech.md`
- Mode: Source processing / project development
- Goal: Build the first reliable bridge between RPG-scale vehicle or MechWarrior rules and tactical BattleTech handoff.
- Acceptance: summaries follow the standard schema, preserve source page references, route through indexes and manifest, keep Classic BattleTech/MegaMek/MekHQ as the route for full tactical play, strengthen GM handoff docs, record scenario validation, and defer vehicle/asset companion validation until real vehicle records exist.

### Summarize campaign consequence systems

- Status: Done
- Issue: `#22`
- Handoff: `docs/handoffs/archive/summarize-campaign-consequence-systems.md`
- Report: `docs/current/CAMPAIGN_CONSEQUENCE_LOOKUP_VALIDATION.md`
- Summaries: `rules/campaign/overview.md`, `rules/campaign/advancement.md`, `rules/campaign/contracts.md`, `rules/campaign/contacts.md`, `rules/campaign/reputation.md`, `rules/campaign/injuries-recovery.md`, and `rules/campaign/downtime-and-readiness.md`
- Mode: Source processing / project development
- Goal: Create source-reviewed campaign consequence summaries for ongoing-play aftermath and campaign-save updates.
- Acceptance: summaries follow the standard schema, preserve source page references, route through indexes and manifest, identify dedicated contract construction as a gap, record scenario validation, and defer a campaign-consequence companion validator until real campaign records exist.

### Summarize character creation foundation

- Status: Done
- Issue: `#21`
- Handoff: `docs/handoffs/archive/summarize-character-creation-foundation.md`
- Report: `docs/current/CHARACTER_CREATION_LOOKUP_VALIDATION.md`
- Summaries: `rules/character-creation/overview.md`, `rules/character-creation/lifepaths.md`, `rules/character-creation/attributes.md`, `rules/character-creation/traits.md`, `rules/character-creation/skills.md`, and `rules/character-creation/xp-advancement.md`
- Mode: Source processing / project development
- Goal: Create source-reviewed, paraphrased character creation foundation summaries for future campaign setup and sheet review.
- Acceptance: summaries follow the standard schema, preserve source page references, route through indexes and manifest, avoid copied catalogs/tables/sample sheets, record scenario validation, and defer deterministic character-output validation until real PC sections exist.

### Validate existing draft coverage

- Status: Done
- Issue: `#20`
- Handoff: `docs/handoffs/archive/validate-existing-draft-coverage.md`
- Report: `docs/current/DRAFT_COVERAGE_AND_HELPER_VALIDATION.md`
- Mode: Project development / review
- Goal: Validate existing draft coverage and helper workflow before adding more rules layers.
- Acceptance: scenario lookup tests covered core, personal combat, equipment, tactical handoff, campaign-save routing, and placeholder boundaries; helper scripts were checked with valid and invalid inputs; protected source paths remain ignored; follow-up work remains in issues `#21`, `#22`, `#23`, and `#24`.

### Build campaign-state validator

- Status: Done
- Issue: `#19`
- Handoff: `docs/handoffs/archive/build-campaign-state-validator.md`
- Script: `scripts/validate-campaign-state.ps1`
- Mode: Project development
- Goal: Add deterministic validation for `campaign-state/active-campaign.md`, `campaigns/_template/`, and selected or explicit `campaigns/<campaign-id>/` save folders.
- Acceptance: validator reports active pointer state, checks standard template and campaign save files, rejects invalid campaign ids and legacy flat `campaign-state/` active paths where deterministic, supports `-StrictActive`, documents usage, and does not edit campaign state.

### Perform full stale-reference and consistency review

- Status: Done
- Issue: `#18`
- Handoff: `docs/handoffs/archive/full-stale-reference-review.md`
- Mode: Project development / review
- Goal: Check active workflow docs, routers, GM docs, campaign docs, scripts docs, README, and planning files for stale references after campaign-save and tooling changes.
- Acceptance: repository stale-reference searches were run; active stale planning text was fixed; `campaign-state/current-campaign.md` now clearly identifies itself as a legacy prototype; historical archived handoff references were left alone; no protected raw source was staged.

### Refresh roadmap for full A Time of War coverage

- Status: Done
- Issue: `#17`
- Handoff: `docs/handoffs/archive/refresh-atow-coverage-roadmap.md`
- Mode: Project development
- Goal: Make the remaining path toward broad A Time of War support explicit and actionable.
- Acceptance: roadmap now separates drafted/routed coverage, placeholder-level subsystems, validation needs, and next issue candidates; `TASKS.md` matches the revised priorities.

### Add simple dice roller script

- Status: Done
- Issue: `#16`
- Handoff: `docs/handoffs/archive/add-simple-dice-roller.md`
- Script: `scripts/roll-dice.ps1`
- Mode: Project development
- Goal: Add a small live-play dice roller for common roll expressions.
- Acceptance: script supports `NdM`, `NdM+K`, and `NdM-K`; reports expression, dice, modifier, and total; rejects invalid expressions; usage is documented in `scripts/README.md` and `docs/current/KNOWN_COMMANDS.md`.

### Create campaign save-folder helper script

- Status: Done
- Issue: `#15`
- Handoff: `docs/handoffs/archive/create-campaign-save-helper.md`
- Script: `scripts/new-campaign-save.ps1`
- Mode: Project development
- Goal: Create a repeatable helper for starting a new campaign save folder from `campaigns/_template/`.
- Acceptance: script creates `campaigns/<campaign-id>/`, refuses existing folders, rejects unsafe ids, stays under `campaigns/`, leaves `campaign-state/active-campaign.md` unchanged, and is documented in `campaigns/README.md`, `scripts/README.md`, and `docs/current/KNOWN_COMMANDS.md`.

### Align campaign-memory references after issue `#13` review

- Status: Done
- Issue: `#14`
- Handoff: `docs/handoffs/archive/align-campaign-memory-references.md`
- Mode: Project development
- Goal: Make play/rules-routing consistently use `campaign-state/active-campaign.md` and the selected `campaigns/<campaign-id>/` save folder instead of legacy flat `campaign-state/` files.
- Acceptance: live router, setting seed, profile, README, GM procedure, campaign save docs, and campaign-rule placeholders now route persistent play state through the active campaign save folder; `previous-sessions.md` defines a lightweight campaign-local session archive; legacy flat files are labeled as prototype/history records.

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

- Expand personal combat, equipment, damage, and recovery beyond the current draft minimum only where play or validation finds missing detail.
- Expand `indexes/task-router.md` after verified summaries exist.
- Fill `indexes/manifest.yaml` with stable IDs and source page arrays.
- Validate all summaries against source pages.
- Add deeper MekHQ / MegaMek integration notes for encounter handoff, unit setup, campaign updates, and save-backed campaign bootstrapping after issues `#26`-`#29` produce findings.
- Repeat manual validation after each new playable layer: source summaries, routing, GM procedure, playtest, bug issues.

## Existing Foundation

- Initial project scaffolding exists with `gm/`, `indexes/`, `rules/`, `source/`, scripts, and starter docs.
- PDF extraction script exists, but no PDF processing has been performed as part of issue `#1`.
- Issue `#1` implementation adds the `docs/current/` workflow layer, handoff template, GitHub issue template, mode router, and updated entry-point docs.
- GitHub labels `agent-task` and `user-task` exist for agent-executed work and user-only work.

## Open Questions

- Branching posture: direct-to-`master` remains acceptable for small coherent tasks in this private repo; use feature branches for broad, risky, or multi-issue work that needs review as a unit.
- Should `issues/initial-issues.md` remain as a historical seed list after this roadmap exists?
