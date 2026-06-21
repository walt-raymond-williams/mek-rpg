# Tasks

## Now

- None.

## Next

- Issue `#27`: prototype read-only MekHQ save summary helper after issue `#26` establishes field priorities; handoff at `docs/handoffs/active/prototype-read-only-mekhq-save-summary-helper.md`; representative saves exist in `C:\Users\waltr\Documents\megamek-workspace\`.
- Issue `#31`: define GM context packet design after the current MekHQ ownership mapping pass, so play context can explicitly layer instructions, active campaign state, rules routes, recent events, summaries, retrieved memories, and optional MekHQ facts.
- Use `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md` as the controlling plan for future extraction, mapping, summaries, routing, and validation work.

## Backlog

- Issue `#25`: parent epic for the MekHQ-to-MEK-RPG campaign bridge.
- Issue `#30`: parent epic for GM context architecture informed by AI Dungeon-style memory lessons.
- Issue `#32`: define campaign memory strata and semantic checkpoints after or alongside issue `#31`.
- Issue `#33`: prototype GM context packet helper after issue `#31` defines packet shape.
- Issue `#34`: add GM context regression scenarios after issue `#31` defines expected context behavior.
- Issue `#28`: prototype MekHQ campaign bootstrap into a MEK-RPG save folder after issues `#26`, `#27`, and `#29` clarify mapping, summary input, and play/writeback boundaries.
- After real PC sheets, vehicle sheets, structured mission clocks, or richer contract records exist, add focused companion validators instead of expanding the generic campaign-state validator immediately.
- If the `Atlas Field` campaign reaches actual BattleMech movement or combat, build a lightweight handoff checklist for preparing a MegaMek, MekHQ, or Classic BattleTech encounter from the campaign save.
- Use direct-to-`master` for small coherent tasks in this private repo; use feature branches for broad, risky, or multi-issue work that needs review as a unit.
- Expand `indexes/task-router.md`, `indexes/page-reference-index.md`, and `indexes/manifest.yaml` as verified summaries are added.
- Add campaign-local session archive helper after more play if `previous-sessions.md` becomes cumbersome.
- Add richer DropShip and unit asset sheets after transport ownership rules are summarized.
- Repeat manual validation/playtest checkpoints after adding major playable layers.

## Blocked

- None.

## Done

- Issue `#29` implemented: added `docs/current/MEKHQ_LINKED_PLAY_LOOP.md` to define the safe one-day MekHQ-linked RPG play loop, day ownership boundary, pre-session checkpoint, in-day scene handling, post-scene and end-of-day save expectations, MEK-RPG memory handling, MekHQ application queues, and writeback boundary matrix; direct MekHQ save/XML edits remain unsafe and out of scope.
- Issue `#26` implemented: added `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md` to define the read-only MekHQ bridge ownership boundary, campaign-folder mapping, overlay strategy, MekHQ ID preservation and MEK-RPG slug policy, unknown/unsupported field handling, non-goals, and follow-on priorities for issues `#27`-`#29`.
- Issue `#24` implemented: created the first table-canon campaign save `campaigns/isekai-atlas-field/`, selected it as active after user confirmation, ran a short isekai Atlas-field opening scene, validated campaign save helpers in the live workflow, used the state-save checklist, recorded open rules and workflow gaps, and deferred deeper companion validators until real structured sheets exist.
- Issue `#23` implemented: added source-reviewed draft vehicle and MechWarrior bridge summaries for overview, piloting, gunnery, MechWarrior skills, and RPG-to-Classic BattleTech conversion; strengthened tactical handoff and encounter templates; updated router, rules map, subsystem index, page-reference index, manifest, campaign save guidance, and state-save routing; recorded scenario validation and deferred vehicle/asset companion validation until real vehicle records exist.
- Issue `#22` implemented: added source-reviewed draft campaign consequence summaries for overview, advancement, contracts, contacts, reputation, injuries/recovery, and downtime/mission readiness; updated router, rules map, subsystem index, page-reference index, manifest, GM save guidance, and campaign save docs; recorded scenario validation and deferred a campaign-consequence companion validator until real campaign records exist.
- Issue `#21` implemented: added source-reviewed draft character-creation summaries for overview, lifepaths, attributes, traits, skills, and XP advancement; updated router, rules map, subsystem index, page-reference index, and manifest; recorded scenario validation and deferred character-output validation until real PC sections exist.
- Issue `#20` implemented: added `docs/current/DRAFT_COVERAGE_AND_HELPER_VALIDATION.md`, validated draft core/personal-combat/equipment/tactical-handoff/campaign-save routing, manually checked helper scripts with valid and invalid inputs, added a task-router coverage warning for placeholder rows, and recorded follow-ups for issues `#21`-`#24`.
- Issue `#19` implemented: added `scripts/validate-campaign-state.ps1` to validate the active campaign pointer, campaign template files, and active or explicitly supplied campaign save folders; documented usage and verified default, explicit campaign, and strict active-selection behavior.
- Issue `#18` implemented: ran repository stale-reference searches, fixed active stale planning and legacy-campaign guidance, distinguished historical flat campaign-state references from live campaign-save guidance, and verified no protected raw source is staged.
- Issue `#17` implemented: refreshed the roadmap and task board around completed draft coverage, remaining placeholder subsystems, validation needs, future source-processing waves, and current issue candidates.
- Issue `#16` implemented: added `scripts/roll-dice.ps1` for simple `NdM`, `NdM+K`, and `NdM-K` live-play rolls with individual dice, modifier, total, labels, documentation, and manual verification.
- Issue `#15` implemented: added `scripts/new-campaign-save.ps1` to create a campaign save from `campaigns/_template/`, reject unsafe ids, refuse overwrites, document usage, and preserve manual active-campaign selection.
- Issue `#14` implemented: aligned stale live references with `campaign-state/active-campaign.md` and selected `campaigns/<campaign-id>/` save folders, added campaign-local `previous-sessions.md` archives to the template and Galatea playtest save, and labeled legacy flat files as prototype/history records.
- Issue `#13` implemented: audited flat campaign-state coverage, documented durable campaign memory strategy, added active-campaign pointer, created `campaigns/_template/`, isolated the Galatea DropShip playtest in `campaigns/playtest-galatea-dropship/`, and added the GM state-save checklist.
- Issue `#12` implemented: ran the first manual playtest using a Galatea DropShip purchase scene with Walter and Sharpe, recorded playtest-only campaign memory, captured rules gaps and workflow bugs, and fed campaign-specific save-folder requirements into issue `#13`.
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
- Issues `#7` through `#12` created with active handoffs for personal combat, personal-combat validation, equipment minimum, campaign setting seed, first playable GM mode, and first manual playtest/bug capture.
- Issue `#7` implemented: personal combat and recovery summaries under `rules/personal-combat/` cover overview/turn flow, initiative, action and movement, ranged attacks, melee attacks, damage, wounds/effects, end phase, and healing/recovery; live indexes and manifest route to the new summaries.
- Issue `#8` implemented: `docs/current/PERSONAL_COMBAT_LOOKUP_VALIDATION.md` records manual lookup tests for initiative, ranged attacks, melee/grappling, damage/wounds, treatment/recovery, and tactical BattleTech handoff; no router bug was found, and caveats are recorded for equipment, campaign recovery, and table-heavy details.
- Issue `#9` implemented: equipment summaries under `rules/equipment/` cover acquisition/use, weapons, armor/protection, electronics, medical gear, and personal gear; live indexes and manifest route to the new summaries while exact item stats and table-heavy details remain source-cited.
- Issue `#10` implemented: `campaign-state/setting-basics.md` creates a table-facing BattleTech setting seed with canon policy, open user choices, faction seed, starter premises, and first-session hooks; GM and campaign-state docs link to the seed.
- Issue `#11` implemented: `gm/session-procedure.md` now defines the first playable GM loop, `campaign-state/current-mission.md` contains the `Checkpoint Ghosts` manual playtest scaffold, campaign-state files cover PCs, NPCs, factions, hooks, session log, rules gaps, and playtest bugs, and issue `#12` is ready for the first manual playtest.
