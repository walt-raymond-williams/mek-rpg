# Roadmap

This is the durable planning source for MEK RPG. GitHub Issues are created gradually from these entries when work is ready for execution.

## Current Focus

- The legally owned A Time of War PDF has been extracted into ignored page-level text.
- Issue `#4` produced the initial chapter and section map in `source/atow-chapter-section-map.md`.
- Core resolution, character creation, personal combat, equipment, campaign consequences, and vehicles/MechWarrior bridge have draft paraphrased summaries with live router coverage and validation reports where applicable.
- The term glossary now has source-reviewed universe terminology and common rules/workspace aliases; placeholder and partially covered subsystems now have mapped page-reference pointers; manifest metadata now distinguishes draft summaries from non-authoritative mapped targets.
- Campaign play now uses `campaign-state/active-campaign.md` plus exactly one selected `campaigns/<campaign-id>/` save folder. Legacy flat `campaign-state/` files remain historical prototype records.
- Helper scripts now cover creating campaign saves from `campaigns/_template/`, validating campaign-state structure, and rolling simple live-play dice expressions.
- Campaign-state lifecycle automation has a first validator for active campaign selection, template structure, and campaign save completeness.
- MekHQ bridge automation now has a read-only save summary helper that emits JSON or Markdown checkpoint facts from `.cpnx`, `.cpnx.gz`, or plain campaign XML without writing to the MekHQ save.
- MekHQ campaign bootstrap now creates a MEK-RPG campaign folder from read-only summary JSON, adds a campaign-local `mekhq-bridge.md`, and preserves the read-only MekHQ ownership boundary.
- MekHQ-linked campaign saves now use `pending-mekhq-actions.md` for RPG-side hard ledger intents that need manual MekHQ UI application and saved re-import confirmation.
- MekHQ pending workflow verification now has automated structural regression coverage from issue `#36` and human-in-the-loop MekHQ UI validation from issue `#37`.
- Regression coverage for the full MekHQ-linked A Time of War workflow is complete for deterministic agent-executable checks under epic issue `#38`; issue `#37` completed the manual UI apply/save/re-import validation checkpoint.
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

- Placeholder and partially covered subsystems remain non-authoritative until source-reviewed summaries are written.
- Deterministic index validation, coverage reporting, and route-helper support now exist for rules lookup infrastructure; keep them synchronized as future summaries are added.

### Validation Needs

- Existing draft summaries should be validated against scenario prompts after each major routing change.
- Placeholder summaries should not be treated as rules authority until source pages are reviewed, page references are added, and router paths pass lookup tests.
- The campaign save helper and dice roller were rechecked during the first real campaign setup and live-play session. Repeat manual validation/playtest after future major playable layers.
- MekHQ pending application workflow has automated structural regression coverage from issue `#36`; run `./scripts/test-mekhq-pending-workflow.ps1` after workflow or bootstrap changes.
- MekHQ-linked A Time of War regression coverage now has a requirements matrix in `docs/current/MEKHQ_LINKED_ATOW_WORKFLOW_REQUIREMENTS.md`, a top-level deterministic runner in `scripts/test-all.ps1`, bootstrap fixture coverage in `scripts/test-bootstrap-mekhq-campaign.ps1`, save-summary XML/gzip fixture coverage in `scripts/test-summarize-mekhq-save.ps1`, campaign-state validator coverage in `scripts/test-validate-campaign-state.ps1`, pending-action validator coverage in `scripts/test-validate-mekhq-pending-actions.ps1`, and MekHQ-linked GM context packet scenarios in `scripts/test-mekhq-context-packet.ps1`.
- MekHQ pending application workflow has human-in-the-loop UI validation from issue `#37` for the manual apply/save/re-import loop, using a one-day advancement item.
- MekHQ personnel parsing currently captures roster basics and bootstrap stubs; issue `#65` now tracks the missing workflow for turning parsed MekHQ personnel into durable MEK-RPG PC/NPC sheet entries.
- Rules lookup infrastructure now has completed glossary source review and aliases (`#46`), placeholder page-reference expansion (`#47`), manifest status normalization (`#48`), rules index validation (`#49`), rules coverage reporting (`#50`), and a rules route helper prototype (`#51`).
- The DropShip/large-asset gap from the Galatea playtest now has source-coverage mapping in issue `#52`, a narrowed transport/large-asset campaign procedure in issue `#53`, a Markdown-native asset sheet schema in issue `#54`, and tactical encounter handoff checklist support in issue `#55`.
- The read-only dashboard idea now has a boundary evaluation in issue `#56` and a read-only data adapter contract in issue `#57`; any future UI must sit on that contract. Campaign session archive helper work was implemented in issue `#58`.
- The next rules source-review expansion wave is now tracked under epic issue `#59`, with executable child issues `#60`-`#64` and active handoffs.
- MegaMek workspace bridge-primitives feedback has been consumed under epic issue `#66`, with child issues `#67`-`#69` completing read-only checkpoint export consumption, headless day-advance risk documentation, and gated contract-market accept/decline probe planning.
- Issue `#67` added `docs/current/MEKHQ_READ_ONLY_CHECKPOINT_EXPORT_CONTRACT.md` as the MEK-RPG-side consumer contract and gap map for a future MekHQ-owned read-only checkpoint export; the current Python helper remains a read-only prototype/fallback.
- Issue `#69` added `docs/current/MEKHQ_CONTRACT_MARKET_PROBE_PLAN.md` as the gated future-write plan for contract-market accept/decline; no write automation is authorized until stable offer IDs, prompt policy, disposable validation, and saved re-import confirmation exist.
- The MegaMek workspace checkpoint export review memo was completed as MEK-RPG issue `#84`, with child issues `#85`-`#89` covering adapter tests, prototype-output tests, consumed-field mapping, GM-facing diagnostics, and fixture edge cases. Cross-board dependency guidance lives in `docs/current/MEKHQ_CHECKPOINT_CROSS_BOARD_TRACKING_PROPOSAL.md`.
- Deterministic mechanics maturation is now tracked under epic issue `#70`, with child issues `#71`-`#79` covering the mechanics catalog, JSON contract, existing-script audit, golden route tests, resolver prototypes, state-change proposal schema, and later library/service migration evaluation.

## Active Work

- Issue `#59`: next rules source-review expansion wave tracks the open child issue queue for remaining high-value mapped-only and partial-draft rule areas.
- Issue `#65`: MekHQ personnel-to-PC/NPC sheet workflow tracks richer use of parsed MekHQ roster/personnel data in campaign-local character records.
- Issue `#66`: completed MekHQ bridge primitives follow-up queue from the MegaMek workspace assessment; child issues `#67`-`#69` are done.
- Issue `#70`: ruling safety and deterministic mechanics maturation planning is complete; child issues `#71`-`#83` remain open in dependency order.

## Ready For Issue Candidates

- None currently unissued. Checkpoint export adapter experiments issues `#84`-`#89` are complete; ruling safety and deterministic mechanics maturation is issued as `#70`-`#83`; rules source-review expansion is issued as `#59`-`#64`; MegaMek bridge-primitives follow-up issues `#66`-`#69` are complete. MekHQ bridge epic issue `#25`, manual MekHQ pending workflow validation issue `#37`, rules/index infrastructure issues `#46`-`#51`, transport/tactical support issues `#52`-`#55`, dashboard/session tooling issues `#56`-`#58`, MekHQ regression coverage issue `#38`, and GM context architecture issue `#30` are complete.

## Issue Tracks

### MekHQ checkpoint export adapter experiments

- Status: Complete
- Epic issue: `#84`
- Mode: Project development / cross-workspace coordination
- Source input: `C:\Users\waltr\Documents\megamek-workspace\docs\current\MEK_RPG_CHECKPOINT_EXPORT_REVIEW_MEMO.md`
- Tracking proposal: `docs/current/MEKHQ_CHECKPOINT_CROSS_BOARD_TRACKING_PROPOSAL.md`
- Goal: validate the MegaMek workspace read-only checkpoint export shape from the MEK-RPG consumer side before asking MegaMek to harden the exporter or freeze schema decisions.
- Key decisions:
  - MEK-RPG can create its own consumer-side issues without MegaMek confirmation.
  - MegaMek confirmation is needed before creating or treating producer-side tickets as accepted commitments, freezing the schema, or assigning exporter work to them.
  - Experimental prototype output may be consumed for adapter tests, but not as a production MekHQ export contract.
  - Market offers remain display/opportunity data only until stable source-confirmed identifiers exist.
- Child issues:
  1. Done issue `#85`: added checkpoint adapter tests using the sanitized MekHQ fixture.
  2. Done issue `#86`: added checkpoint adapter tests using sanitized disposable-save prototype output.
  3. Done issue `#87`: defined the MEK-RPG consumed-field mapping for MekHQ checkpoint exports.
  4. Done issue `#88`: defined GM-facing surfacing for checkpoint warnings and unsupported fields.
  5. Done issue `#89`: added checkpoint fixture edge cases for adapter robustness.
- Dependency order:
  1. Done in issue `#85`: start with sanitized fixture tests so the basic shape is executable in this repo.
  2. Done in issue `#86`: add prototype-output tests to validate real exporter-shaped data while preserving the experimental boundary.
  3. Done in issue `#87`: document consumed-field mapping before requesting field renames, removals, or schema hardening.
  4. Done in issue `#88`: define GM-facing warning and unsupported-field surfacing once the consumed-field categories are clear.
  5. Done in issue `#89`: add edge-case fixtures before treating adapter behavior as robust.
- Boundary: read-only only. Do not implement day advancement, contract accept/decline, hiring, repair, purchase, sale, assignment, tactical result application, direct save/XML mutation, or market-offer automation selectors in this queue.

### Ruling safety and deterministic mechanics maturation

- Status: Planning complete; child queue open
- Planning epic issue: `#70`
- Mode: Project development / rules-assistant automation planning
- Goal: preserve source-aware agent adjudication while adding enforceable ruling authority checks and deterministic helpers for stable, repeatable mechanics.
- Purpose and posture:
  - PowerShell scripts are acceptable as executable prototypes in this Windows-first workspace.
  - Scripts should evolve toward explicit JSON input/output contracts, including rule/source authority, manifest status, page references, warnings, failure behavior, and proposed state changes.
  - Stable contracts may later be promoted into a core library, CLI, local service, or dashboard adapter, but only after contracts and fixture tests stabilize.
  - This track is not a full rules-engine rewrite.
  - This track does not automate full BattleTech tactical combat, replace Classic BattleTech/MegaMek/MekHQ/tabletop authority, or take over MekHQ hard-ledger ownership.
  - The agent remains responsible for narration, source lookup, uncertainty handling, edge-case reasoning, and deciding when a source gap or tactical handoff matters.
  - Deterministic helpers should own repeatable math, check resolution, authority/failure reporting, and state-proposal procedures where the rule shape is stable.
  - The ruling authority gate should come before broad resolver use so missing, mapped-only, source-lookup-only, or tactical-hand-off cases cannot be silently overclaimed.
- Planning checkpoint:
  1. Done issue `#70`: confirmed the deterministic mechanics maturation track, dependency order, and boundaries.
- Child issues:
  1. Done issue `#71`: created the deterministic mechanics catalog.
  2. Done issue `#72`: defined the standard mechanic JSON contract.
  3. Done issue `#82`: defined BattleTech source precedence and conflict policy.
  4. Open issue `#74`: Add golden route tests for common RPG procedures.
  5. Open issue `#80`: Add ruling authority gate.
  6. Open issue `#73`: Audit existing scripts against mechanic contract.
  7. Open issue `#81`: Add page-reference and source-offset integrity checks.
  8. Open issue `#75`: Prototype basic check resolver contract.
  9. Open issue `#76`: Prototype opposed check resolver contract.
  10. Open issue `#78`: Add state-change proposal schema.
  11. Open issue `#83`: Add golden ruling regression scenarios.
  12. Open issue `#77`: Prototype RPG-scale personal-combat checkpoint contract.
  13. Open issue `#79`: Evaluate core library / CLI / local service migration path.
- Dependency order:
  1. Done in issue `#70`: plan the track and confirm the child queue.
  2. Done in issue `#71`: catalog candidate procedures and ownership boundaries.
  3. Done in issue `#72`: define the standard JSON contract, including an authority envelope, before resolver prototypes.
  4. Done in issue `#82`: define source precedence before authority behavior and route fixtures.
  5. Add the ruling authority gate before broad resolver use.
  6. Audit existing scripts so infrastructure, authority gates, and mechanic helpers stay distinct.
  7. Add page-reference/source-offset checks to reduce stale citation risk.
  8. Prototype the basic check, then opposed check.
  9. Define state-change proposals before any helper is allowed to emit campaign update suggestions.
  10. Add golden ruling scenarios for end-to-end retrieval, citation, failure, and state-proposal behavior.
  11. Prototype RPG-scale personal-combat checkpointing only after state proposals and authority behavior are explicit.
  12. Evaluate library, CLI, local service, or dashboard migration only after repeated contract use and fixture coverage.
- Boundary: do not implement broad mechanic resolvers as part of roadmap setup; do not commit protected source text, copied tables, stat blocks, or raw extracted PDF text; do not let deterministic scripts silently mutate campaign state; preserve source/page citation metadata, manifest authority/status warnings, failure behavior, and uncertainty labels.

### MekHQ bridge primitives follow-up queue

- Status: Done
- Epic issue: `#66`
- Mode: Project development / cross-workspace coordination
- Source input: `C:\Users\waltr\Documents\megamek-workspace\docs\current\MEK_RPG_MEKHQ_BRIDGE_PRIMITIVES.md`
- Goal: consume the MegaMek workspace source-backed bridge-primitives assessment while keeping MEK-RPG on a read-only-first path and avoiding premature write automation.
- Key findings to preserve:
  - Read-only checkpoint export is the near-term recommendation.
  - Headless day advancement is not low-risk because `CampaignNewDayManager#newDay()` reaches GUI state and can trigger prompts/events.
  - The first possible write-side follow-up is a narrow contract-market accept/decline command, but only after stable contract IDs and prompt policy are validated.
- Child issues:
  - Done issue `#67`: added `docs/current/MEKHQ_READ_ONLY_CHECKPOINT_EXPORT_CONTRACT.md` for future MekHQ-owned read-only checkpoint export consumption and current-helper gap comparison.
  - Done issue `#68`: documented headless MekHQ day-advance risk and preserved manual UI advance/save/re-import as the current supported workflow.
  - Done issue `#69`: added `docs/current/MEKHQ_CONTRACT_MARKET_PROBE_PLAN.md` for a gated contract-market accept/decline probe.
- Dependency order:
  1. Done in issue `#67`: MEK-RPG now has a consumer contract, adapter plan, and gap map for a future MekHQ-owned read-only checkpoint export.
  2. Done in issue `#68`: MEK-RPG docs now state that headless day advancement is blocked on MekHQ source work and prompt policy because the new-day flow reaches GUI state.
  3. Done in issue `#69`: contract-market accept/decline is documented as a future MegaMek-side probe gated by stable IDs, prompt policy, disposable validation, and saved re-import confirmation.
- Boundary: do not create broad writeback automation, direct save/XML edits, or headless day-advance implementation issues from MEK-RPG until the MegaMek workspace supplies source-backed safe primitives and prompt policies.

### MekHQ personnel-to-PC/NPC sheet workflow

- Status: Done
- Issue: `#65`
- Handoff: `docs/handoffs/archive/mekhq-personnel-to-pc-npc-sheet-workflow.md`
- Mode: Project development
- Goal: define how parsed MekHQ personnel become useful MEK-RPG `pcs.md` and `npcs.md` entries while preserving MekHQ ownership of roster facts and MEK-RPG ownership of A Time of War overlays, motives, relationships, goals, secrets, scene memory, and sheet gaps.
- Starting point: `scripts/summarize-mekhq-save.py` already extracts person id, display name, role, rank, faction, assignment, availability, injury/fatigue flags, commander flags, and personnel market applicants; `bootstrap-mekhq-campaign.py` already writes a selected viewpoint PC stub, sampled NPC stubs, and bridge cross-references.
- Acceptance: document the reusable linked-person sheet shape, selection/expansion rules, import refresh behavior, discrepancy handling, and whether bootstrap/helper code should change now or later; add focused tests if generated output changes.
- Outcome: documentation-only first pass in `docs/current/MEKHQ_PERSONNEL_SHEET_WORKFLOW.md`; bootstrap remains a sparse one-time campaign creation helper, while a future personnel refresh/merge helper should wait for real play pressure and focused fixture coverage.
- Boundary: do not invent full A Time of War stats from MekHQ role/rank fields, do not write to MekHQ saves or raw XML, and do not commit raw MekHQ payloads.

### Next rules source-review expansion wave

- Status: Done
- Epic issue: `#59`
- Mode: Source processing / project development
- Goal: turn the highest-value mapped-only and partial-draft A Time of War areas into committed paraphrased summaries, routing aids, or GM procedures without trying to summarize the whole book in one pass.
- Parallel-track note: issue `#37` is complete; the rules wave does not depend on MekHQ UI validation.
- Child issues:
  - Done issue `#60`: source-reviewed character detail gaps, with archived handoff `docs/handoffs/archive/source-review-character-detail-gaps.md`.
  - Done issue `#61`: source-reviewed personal combat detail gaps, with archived handoff `docs/handoffs/archive/source-review-personal-combat-detail-gaps.md`.
  - Done issue `#62`: source-reviewed tactical addendum boundaries, with archived handoff `docs/handoffs/archive/source-review-tactical-addendum-boundaries.md`.
  - Done issue `#63`: source-reviewed equipment and hazard gaps, with archived handoff `docs/handoffs/archive/source-review-equipment-and-hazard-gaps.md`.
  - Done issue `#64`: source-reviewed GM and campaign orientation gaps, with archived handoff `docs/handoffs/archive/source-review-gm-campaign-orientation-gaps.md`.
- Dependency order:
  1. Done in issue `#60`: character detail gaps now support future PC/NPC sheet review and eventual focused validators.
  2. Done in issue `#61`: personal-combat details now cover armor/barriers and opt-in optional rules after the current minimum combat layer.
  3. Done in issue `#62`: tactical addendum routing now refines handoff decisions after personal-scale gaps are clearer.
  4. Done in issue `#63`: equipment and hazard routing now supports missions, injury aftermath, and vehicle/asset scenes.
  5. Done in issue `#64`: GM/campaign orientation now stays procedure- and routing-focused rather than lore-heavy.
- Boundary: this wave permits explicit source-processing for scoped page ranges only. Do not commit protected raw source, copied tables, catalog lists, stat blocks, adventure text, or long lore passages. Use paraphrase, page references, route guidance, and uncertainty labels.

### Rules lookup infrastructure and metadata queue

- Status: Done
- Mode: Project development / source processing where explicitly noted
- Goal: make rules lookup safer for autonomous agents by improving terminology, page references, manifest status, deterministic validation, coverage reporting, and route discovery without turning placeholder areas into rules authority.
- Child issues:
  - Done in issue `#46`: source-review glossary and term alias coverage.
  - Done in issue `#47`: expand page-reference index for placeholder subsystems.
  - Done in issue `#48`: normalize manifest metadata and coverage statuses.
  - Done in issue `#49`: add rules index consistency validator.
  - Done in issue `#50`: add rules coverage reporter.
  - Done in issue `#51`: prototype rules route helper.
- Dependency order:
  1. Done in issues `#46` and `#47`: term aliases and human-readable page references.
  2. Done in issue `#48`: manifest status and IDs are more reliable.
  3. Done in issues `#49` and `#50`: deterministic validation and coverage reporting.
  4. Done in issue `#51`: route helper uses improved metadata to route natural-language prompts to candidate summaries and warnings.
- Boundary: do not read or commit protected raw source except in explicit source-review work; the helper in issue `#51` must route to committed summaries and indexes, not answer rules directly.

### Transport, large-asset, and tactical handoff queue

- Status: Done
- Mode: Source processing / project development
- Goal: address the DropShip and large-asset gaps discovered during play while preserving the boundary between A Time of War summaries, table rulings, Classic BattleTech/MegaMek/MekHQ tactical handling, and MEK-RPG campaign memory.
- Child issues:
  - Done in issue `#52`: map transport acquisition and large-asset ownership source coverage.
  - Done in issue `#53`: summarize transport acquisition and large-asset procedures using the narrowed scope in `docs/current/TRANSPORT_LARGE_ASSET_SOURCE_COVERAGE.md`.
  - Done in issue `#54`: design richer DropShip and unit asset sheet schema after summary coverage or with clearly marked provisional fields.
  - Done in issue `#55`: add tactical encounter handoff checklist.
- Dependency order:
  1. Done in issue `#52`: mapped what the source actually supports.
  2. Done in issue `#53`: wrote a narrowed paraphrased summary for acquisition/asset procedure and explicitly preserved unsupported DropShip economy/legal gaps.
  3. Done in issue `#54`: designed asset sheets from the confirmed/provisional coverage.
  4. Done in issue `#55`: added a GM workflow checklist linked to asset-sheet work.
- Boundary: direct MekHQ writeback, tactical rules implementation, copied equipment/price tables, raw source text, definitive DropShip title/lien law, and exact DropShip operating economics remain out of scope.

### Read-only dashboard and session tooling queue

- Status: Done
- Mode: Project development / design and automation
- Goal: test whether read-only visibility tooling is worth building, define a safe data contract before UI implementation, and add a conservative session archive helper when safe.
- Child issues:
  - Done in issue `#56`: evaluate read-only MEK-RPG dashboard boundaries.
  - Done in issue `#57`: design read-only dashboard data adapter contract after issue `#56` recommended proceeding.
  - Done in issue `#58`: add campaign-local session archive helper.
- Dependency order:
  1. Done in issue `#56`: dashboard scope and exclusions are documented.
  2. Done in issue `#57`: data ownership and serialization are defined before any frontend exists.
  3. Done in issue `#58`: session archive automation stays conservative with live campaign logs.
- Boundary: no dashboard write controls, live movement controls, Sunnytown-derived gameplay surface, direct MekHQ writeback, protected source display, or raw MekHQ save reads in the dashboard layer.
- Decision: issue `#56` recommends campaign state audit and GM context inspection as the first dashboard value, and issue `#57` defines a file/CLI JSON contract before any UI or local HTTP wrapper exists.

### Automated regression coverage for MekHQ-linked A Time of War workflow

- Status: Done
- Epic issue: `#38`
- Mode: Project development / test strategy
- Goal: increase automated regression and unit-style coverage around the MEK-RPG workflow for A Time of War play tied to MekHQ, so future changes identify behavior regressions before live campaign use.
- Starting point: the repository currently has one automated regression harness, `scripts/test-mekhq-pending-workflow.ps1`, plus manual validation reports.
- Coverage posture: tests should use sanitized committed fixtures, disposable output, deterministic assertions, no real MekHQ saves, no protected source text, and no direct MekHQ `.cpnx`, `.cpnx.gz`, or XML writeback.
- Requirements contract: `docs/current/MEKHQ_LINKED_ATOW_WORKFLOW_REQUIREMENTS.md`.
- Child issues:
  - Done in issue `#39`: define MekHQ-linked A Time of War workflow requirements and coverage matrix.
  - Done in issue `#40`: add top-level deterministic test runner.
  - Done in issue `#41`: add `bootstrap-mekhq-campaign.py` unit-style fixture coverage.
  - Done in issue `#42`: add `summarize-mekhq-save.py` sanitized XML fixture coverage.
  - Done in issue `#43`: add campaign-state validator automated coverage.
  - Done in issue `#44`: add pending MekHQ actions validator.
  - Done in issue `#45`: add GM context packet regression scenarios for MekHQ-linked play.
- Dependency order:
  1. Done in issue `#39`: requirements and coverage matrix define stable `REQ-MEKHQ-ATOW-*` IDs and child issue ownership.
  2. Done in issue `#40`: `scripts/test-all.ps1` runs deterministic suites and initially wraps existing tests.
  3. Done in issue `#41`: bootstrap helper fixture coverage is integrated into `scripts/test-all.ps1`.
  4. Done in issue `#42`: save-summary XML/gzip fixture coverage is integrated into `scripts/test-all.ps1`.
  5. Done in issue `#43`: campaign-state validator coverage is integrated into `scripts/test-all.ps1`.
  6. Done in issue `#44`: pending-action structural validation is integrated into `scripts/test-all.ps1`.
  7. Done in issue `#45`: MekHQ-linked context packet scenarios validate bridge metadata, pending intents, stale-memory avoidance, rules/tactical route references, protected-source boundaries, and no-writeback behavior.

### MekHQ-to-MEK-RPG campaign bridge epic

- Status: Done, including manual UI validation from issue `#37`.
- Epic issue: `#25`
- Mode: Project development / play workflow design
- Source context:
  - `C:\Users\waltr\Documents\megamek-workspace\docs\current\MEK_RPG_MEKHQ_COLLABORATION_BRIEF.md`
  - `C:\Users\waltr\Documents\megamek-workspace\docs\current\MEK_RPG_MEKHQ_INTEGRATION_ASSESSMENT.md`
- Goal: explore whether MEK-RPG can import or summarize a MekHQ `.cpnx` / `.cpnx.gz` campaign save, generate a playable `campaigns/<campaign-id>/` folder, support one-day RPG play from a selected character viewpoint, and preserve RPG-only memory while keeping MekHQ authoritative for hard logistics.
- Ownership boundary: MekHQ should own campaign date, funds, unit rosters, personnel ledger fields, repairs, contracts, markets, tactical consequences, and scenario outcomes. MEK-RPG should own A Time of War PCs, RPG scenes, NPC motives, relationship memory, promises, secrets, hooks, safety/tone, and narrative uncertainty.
- Cross-workspace option: when MEK-RPG identifies MekHQ-side needs, create focused request or memo tickets for the MegaMek workspace group. That sister workspace is the right place to investigate safe MekHQ APIs, UI-assisted import/export, artifact formats, source-backed writeback options, or implementation on the MekHQ side.
- Initial child issues:
  - Done in issue `#26`: define MekHQ bridge data model and campaign-folder mapping.
  - Done in issue `#29`: define MekHQ-linked one-day play loop and writeback boundaries before campaign bootstrap implies write behavior.
  - Done in issue `#27`: prototype read-only MekHQ save summary helper after issue `#26` sets field priorities.
  - Done in issue `#28`: prototype MekHQ campaign bootstrap into a MEK-RPG save folder after mapping, summary input, and play/writeback boundaries are clear.
  - Done in issue `#35`: define the pending MekHQ application checklist workflow so RPG-side ledger intents have a concrete manual-application path before context packet work consumes them.
  - Done in issue `#36`: add automated MekHQ pending workflow regression tests to guard queue ownership, bootstrap output, validator coverage, and no-writeback boundaries.
  - Done in issue `#37`: ran a human-in-the-loop MekHQ pending workflow playtest to validate the manual UI apply, save, re-import, and reconciliation loop.
- Deferred until source-backed confidence improves: direct MekHQ save writes, headless day advancement, automatic purchase/contract/repair writeback, and any broad changes to MekHQ internals.

### Dependency Order

1. Done in issue `#26`: `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md` defines the ownership model, campaign-folder mapping, ID preservation, and uncertainty policy.
2. Done in issue `#29`: `docs/current/MEKHQ_LINKED_PLAY_LOOP.md` defines the one-day play loop and writeback boundaries so later bootstrap work does not imply unsafe direct MekHQ writes.
3. Done in issue `#27`: `scripts/summarize-mekhq-save.py` builds the read-only save summary helper using the issue `#26` field priorities. Representative disposable saves under `C:\Users\waltr\Documents\megamek-workspace\` verified plain and gzip parsing; no purchased A Time of War source is involved.
4. Done in issue `#28`: `scripts/bootstrap-mekhq-campaign.py` uses the mapping, read-only summary output, and play/writeback boundaries to generate a MEK-RPG campaign folder without overwriting existing saves.
5. Done in issue `#35`: `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md` defines the pending MekHQ application checklist workflow for manual UI application, re-import confirmation, and unresolved ledger-intent tracking.
6. Done in issue `#36`: automated regression checks cover the pending workflow's structural and documentation contracts.
7. Done in issue `#37`: a user-selected MekHQ save validated the manual UI apply, save, re-import, and reconciliation loop with a one-day advancement item.
8. Done in issue `#25`: the agent-executable staged bridge exploration is complete.

### Not Yet Promoted

- Direct `.cpnx` / `.cpnx.gz` writeback.
- Headless MekHQ day advancement.
- Automatic purchases, contract acceptance, repair changes, or personnel changes in MekHQ.
- Broad MekHQ source changes.
- Dedicated validators for MekHQ-linked campaign folders beyond issue `#36`'s pending-workflow checks and issue `#44`'s pending-action validator; add broader validators only after repeated linked-campaign use shows stable generated file conventions.

### GM context architecture epic

- Status: Done
- Epic issue: `#30`
- Mode: Project development / play workflow design
- Research input: AI Dungeon and Latitude public memory/model-development notes suggest that long-running AI RPG play benefits from explicit context layers, distinct summary and memory roles, semantic checkpoints, portable model assumptions, and regression-style evaluation.
- Goal: define a repeatable GM context packet workflow that assembles the active campaign, current scene, structured campaign files, rules routes, recent event history, older summaries, relevant hooks or memories, and optional MekHQ bridge facts without blurring ownership boundaries.
- Design note: `docs/current/GM_CONTEXT_PACKET_DESIGN.md`.
- Ownership boundary: rules summaries and indexes should guide procedures; campaign save files should own persistent RPG state; narrative summaries should compress continuity but not override structured sheets; MekHQ should remain authoritative for hard logistics where the bridge applies; the LLM should frame scenes and make judgment calls from the assembled context.
- Initial child issues:
  - Done in issue `#31`: define GM context packet design.
  - Done in issue `#32`: define campaign memory strata and semantic checkpoints.
  - Done in issue `#33`: prototype GM context packet helper after issue `#31` defines the packet shape.
  - Done in issue `#34`: add GM context regression scenarios after issue `#31` defines expected context behavior.
- Deferred until the design proves useful: vector-memory experiments, model-specific prompt tuning, automatic narrative summary rewrites, and any direct MekHQ writeback behavior.

### GM Context Dependency Order

1. Done in issue `#35`: pending MekHQ application item handling uses `pending-mekhq-actions.md`, so MekHQ-linked context packets have a concrete pending-action source.
2. Done in issue `#31`: `docs/current/GM_CONTEXT_PACKET_DESIGN.md` defines packet layers, authority order, source files, mode differences, MekHQ pending-intent handling, and helper requirements.
3. Done in issue `#32`: `docs/current/CAMPAIGN_MEMORY_STRATEGY.md` defines memory strata, checkpoint triggers, file ownership, correction handling, MekHQ intent boundaries, and stale-summary precedence.
4. Done in issue `#33`: `scripts/build-gm-context-packet.ps1` reports packet inputs without inventing facts, interpreting rules, reading protected source, or mutating campaign files.
5. Done in issue `#34`: `docs/current/GM_CONTEXT_REGRESSION_SCENARIOS.md` and `scripts/test-gm-context-regressions.ps1` validate continuity, rules routing, structured-state precedence, stale-memory avoidance, protected-source boundaries, tactical handoff expectations, and MekHQ ownership boundaries against repeatable scenarios.
6. Done in epic issue `#30`: the context-packet workflow is documented, has a helper, and has regression coverage for general and MekHQ-linked packet boundaries.

## Done

### Complete MekHQ-linked workflow regression coverage epic

- Status: Done
- Issue: `#38`
- Requirements: `docs/current/MEKHQ_LINKED_ATOW_WORKFLOW_REQUIREMENTS.md`
- Runner: `scripts/test-all.ps1`
- Mode: Project development / test strategy
- Goal: Create durable automated regression and unit-style coverage around the MEK-RPG workflow for A Time of War play tied to MekHQ.
- Acceptance: requirements matrix, deterministic runner, bootstrap fixture coverage, save-summary XML/gzip fixture coverage, campaign-state validator coverage, pending-action validator coverage, GM context packet scenarios, protected-source/no-writeback boundary checks, and manual UI apply/save/re-import validation from issue `#37` are complete.

### Complete GM context architecture epic

- Status: Done
- Issue: `#30`
- Design: `docs/current/GM_CONTEXT_PACKET_DESIGN.md`
- Regression scenarios: `docs/current/GM_CONTEXT_REGRESSION_SCENARIOS.md`
- Mode: Project development / play workflow design
- Goal: Create a staged project track for improving GM context architecture using explicit context layers, separate memory roles, semantic checkpoints, and repeatable validation.
- Acceptance: child issues `#31` through `#34` are complete; the architecture preserves MEK RPG's rule-bound, source-bound, structured-state, and MekHQ ownership boundaries; helper and regression coverage are in place.

### Add GM context packet regression scenarios for MekHQ-linked play

- Status: Done
- Issue: `#45`
- Handoff: `docs/handoffs/archive/add-gm-context-packet-regression-scenarios-for-mekhq-linked-play.md`
- Tests: `scripts/test-mekhq-context-packet.ps1`
- Mode: Project development / regression scenarios
- Goal: Add regression scenarios that verify context assembly preserves MekHQ/MEK-RPG authority boundaries and uses pending actions correctly.
- Acceptance: scripted fixture checks bridge metadata and unresolved pending actions are included; pending actions are labeled as manual-action intents, not confirmed ledger facts; structured campaign state remains distinct from stale summaries; rules and tactical handoff route references are present without rules interpretation; protected source, raw save, no-writeback, and read-only boundaries are preserved; scenario docs, test runner, command docs, coverage matrix, roadmap, and tasks are updated.

### Add GM context regression scenarios

- Status: Done
- Issue: `#34`
- Scenarios: `docs/current/GM_CONTEXT_REGRESSION_SCENARIOS.md`
- Tests: `scripts/test-gm-context-regressions.ps1`
- Mode: Project development / validation
- Goal: Create regression scenarios for GM context, continuity, rules routing, and state ownership so future changes can be checked against known failure modes.
- Acceptance: scenario document covers continuity, rules routing, state ownership, corrected/stale memory, tactical handoff, and MekHQ boundary cases; scripted suite verifies active campaign selection, recent and durable memory separation, structured-state precedence, rules routing inputs, missing-file warnings, protected-source boundaries, and read-only helper behavior; manual checks are separated from scripted checks; `scripts/test-all.ps1`, command docs, roadmap, and tasks are updated.

### Prototype GM context packet helper

- Status: Done
- Issue: `#33`
- Script: `scripts/build-gm-context-packet.ps1`
- Tests: `scripts/test-build-gm-context-packet.ps1`
- Mode: Project development / helper
- Goal: Prototype a deterministic helper that assembles or reports GM context packet sources for the active campaign without inventing campaign facts or performing rules interpretation.
- Acceptance: helper reads the active campaign pointer or explicit campaign id, reports packet sections in the issue `#31` order, flags missing files and unsafe active pointers, keeps raw source and direct MekHQ writeback out of scope, optionally appends campaign and pending-action validator output, documents usage in `scripts/README.md` and `docs/current/KNOWN_COMMANDS.md`, and has disposable fixture coverage integrated into `scripts/test-all.ps1`.

### Define campaign memory strata and semantic checkpoints

- Status: Done
- Issue: `#32`
- Design: `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`
- Checklist: `gm/state-save-checklist.md`
- Mode: Project development / design
- Goal: Define campaign memory strata and semantic checkpoint rules so play updates logs, summaries, hooks, sheets, structured state, rules gaps, and MekHQ-linked pending intents at meaningful moments.
- Acceptance: memory strategy distinguishes current resume state, active session record, completed-session archive, structured state sheets, rules/workflow memory, safety/tone, and MekHQ bridge/pending-intent layers; defines scene, mission, relationship, character/asset, combat/tactical, day-boundary/downtime, and session-close checkpoints; explains corrected, superseded, contradicted, and retconned facts; updates the GM state-save checklist and campaign README.

### Define GM context packet design

- Status: Done
- Issue: `#31`
- Handoff: `docs/handoffs/archive/define-gm-context-packet-design.md`
- Design: `docs/current/GM_CONTEXT_PACKET_DESIGN.md`
- Mode: Project development / design
- Goal: Define the canonical GM context packet: the ordered, inspectable bundle of instructions, campaign state, rules routes, recent events, summaries, retrieved memories, and optional MekHQ bridge facts used before or during play.
- Acceptance: design defines authority order, packet layers, file and index inputs, mode differences for play/rules lookup/MekHQ-linked play/project development, protected-source and no-writeback boundaries, pending MekHQ item treatment as intents, stale-context failure modes, a packet skeleton, and helper requirements for issue `#33`; `gm/session-procedure.md` now points play setup at the packet design.

### Add pending MekHQ actions validator

- Status: Done
- Issue: `#44`
- Handoff: `docs/handoffs/archive/add-pending-mekhq-actions-validator.md`
- Validator: `scripts/validate-mekhq-pending-actions.ps1`
- Test: `scripts/test-validate-mekhq-pending-actions.ps1`
- Mode: Project development / validation
- Goal: Create deterministic validation for `pending-mekhq-actions.md` item structure after requirements define the stable schema enough to automate.
- Acceptance: validator accepts the default empty file, validates lifecycle statuses, allowed types, priorities, required fields, date shapes, duplicate ids, and invalid values, reports unresolved pending intents with `-ReportUnresolved`, labels unresolved entries as manual-action checklists rather than confirmed hard ledger facts, and runs from `scripts/test-all.ps1`.

### Add campaign-state validator automated coverage

- Status: Done
- Issue: `#43`
- Handoff: `docs/handoffs/archive/add-campaign-state-validator-automated-coverage.md`
- Script: `scripts/test-validate-campaign-state.ps1`
- Mode: Project development / testing
- Goal: Add deterministic positive and negative tests for `scripts/validate-campaign-state.ps1` so campaign save structure regressions are caught quickly.
- Acceptance: validator now has a `-RepoRoot` test hook; fixture test uses a disposable temp repository to check valid explicit campaign success, missing required file failure, missing top-level heading warning without failure, `-StrictActive` failure when no active campaign is selected, legacy `campaign-state/` active pointer failure, unsafe campaign id rejection, live explicit campaign validation, cleanup, and `scripts/test-all.ps1` integration.

### Add summarize-mekhq-save sanitized XML fixture coverage

- Status: Done
- Issue: `#42`
- Handoff: `docs/handoffs/archive/add-summarize-mekhq-save-sanitized-xml-fixture-coverage.md`
- Script: `scripts/test-summarize-mekhq-save.ps1`
- Fixture: `tests/fixtures/mekhq-save-sanitized.xml`
- Mode: Project development / testing
- Goal: Add automated fixture coverage for `scripts/summarize-mekhq-save.py` using tiny sanitized XML and gzip fixtures instead of real MekHQ saves.
- Acceptance: fixture test compiles the helper, parses plain XML and temp-generated gzip XML, checks JSON top-level keys and representative campaign, finance, personnel, unit, contract, scenario, market, warning, and unsupported-field values, smoke-tests Markdown output, verifies sparse missing-section XML does not crash, confirms no adjacent output file is created, verifies the committed fixture hash is unchanged, and runs from `scripts/test-all.ps1`.

### Add bootstrap-mekhq-campaign unit-style fixture coverage

- Status: Done
- Issue: `#41`
- Handoff: `docs/handoffs/archive/add-bootstrap-mekhq-campaign-unit-fixture-coverage.md`
- Script: `scripts/test-bootstrap-mekhq-campaign.ps1`
- Fixture: `tests/fixtures/mekhq-summary-minimal.json`
- Mode: Project development / testing
- Goal: Expand automated coverage for `scripts/bootstrap-mekhq-campaign.py` using sanitized summary fixtures and disposable campaign output.
- Acceptance: fixture test compiles the bootstrap helper, verifies invalid campaign id rejection, valid bootstrap by viewpoint id, exact name, commander fallback, and embedded PC, confirms existing target folder refusal, checks generated headings and ownership/no-writeback language, confirms the active campaign pointer is unchanged, cleans disposable output, and runs from `scripts/test-all.ps1`.

### Add top-level deterministic test runner

- Status: Done
- Issue: `#40`
- Handoff: `docs/handoffs/archive/add-top-level-deterministic-test-runner.md`
- Script: `scripts/test-all.ps1`
- Mode: Project development / testing
- Goal: Add a single local command that runs all deterministic MEK-RPG regression and unit-style checks and exits nonzero on failure.
- Acceptance: runner executes from the repository root, preserves child suite output, reports failing child commands clearly, exits nonzero on failure, currently wraps `scripts/test-mekhq-pending-workflow.ps1`, is documented in `scripts/README.md` and `docs/current/KNOWN_COMMANDS.md`, and does not require real MekHQ saves, protected source files, network access, or user interaction.

### Define MekHQ-linked A Time of War workflow requirements and coverage matrix

- Status: Done
- Issue: `#39`
- Handoff: `docs/handoffs/archive/define-mekhq-linked-atow-workflow-requirements-and-coverage-matrix.md`
- Requirements: `docs/current/MEKHQ_LINKED_ATOW_WORKFLOW_REQUIREMENTS.md`
- Mode: Project development / requirements
- Goal: Define testable MekHQ-linked A Time of War workflow requirements and map them to current, planned, manual, blocked, or missing coverage.
- Acceptance: stable `REQ-MEKHQ-ATOW-*` requirements cover import, bootstrap, pre-session checkpoint, in-day RPG play, pending hard ledger intents, manual MekHQ application, re-import reconciliation, tactical handoff, GM context packet boundaries, and regression safety boundaries; the matrix maps existing coverage, child issues `#40`-`#45`, manual issue `#37`, tactical handoff issue `#55`, and open gaps without authorizing source processing or direct MekHQ writeback.

### Add automated MekHQ pending workflow regression tests

- Status: Done
- Issue: `#36`
- Handoff: `docs/handoffs/archive/add-automated-mekhq-pending-workflow-regression-tests.md`
- Script: `scripts/test-mekhq-pending-workflow.ps1`
- Fixture: `tests/fixtures/mekhq-summary-minimal.json`
- Mode: Project development
- Goal: Add repeatable regression checks for the MekHQ pending application workflow's queue ownership, bootstrap output, validator coverage, no-writeback boundaries, protected-source guards, and disposable cleanup.
- Acceptance: regression script bootstraps a disposable MekHQ-linked campaign from a sanitized fixture, verifies generated `pending-mekhq-actions.md` and `mekhq-bridge.md` contracts, runs campaign validator positive and missing-pending-file negative checks, verifies workflow docs still forbid direct MekHQ save/XML writeback, confirms protected source paths are ignored, removes disposable campaign output, and documents the command.

### Define pending MekHQ application checklist workflow

- Status: Done
- Issue: `#35`
- Handoff: `docs/handoffs/archive/define-pending-mekhq-application-checklist.md`
- Design note: `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- Campaign file: `pending-mekhq-actions.md`
- Mode: Project development / play workflow design
- Goal: define how RPG-side hard ledger intents are recorded, manually applied in MekHQ, and confirmed by later saved import before becoming final facts.
- Acceptance: workflow defines a dedicated campaign-local owner file, item schema, lifecycle states, day-advance review, re-import reconciliation, context-packet use, no direct MekHQ save/XML writeback, no current MegaMek workspace ticket because the needed MekHQ-side support is not yet concrete, and updates live play/bootstrap guidance plus issue `#31` handoff.

### Prototype MekHQ campaign bootstrap

- Status: Done
- Issue: `#28`
- Handoff: `docs/handoffs/archive/prototype-mekhq-campaign-bootstrap.md`
- Script: `scripts/bootstrap-mekhq-campaign.py`
- Design note: `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`
- Mode: Project development / prototype helper
- Goal: Create a playable MEK-RPG `campaigns/<campaign-id>/` save folder from read-only MekHQ summary JSON while keeping MekHQ hard ledger facts separate from MEK-RPG narrative overlays.
- Acceptance: helper consumes `summarize-mekhq-save.py` JSON, refuses overwrites, preserves MekHQ IDs, supports MekHQ-person or embedded-PC viewpoint selection, leaves `campaign-state/active-campaign.md` unchanged, generates campaign stubs and `mekhq-bridge.md`, documents the bridge convention, and verifies against disposable `The Learning Ropes` summary output without committing raw MekHQ saves or protected source files.

### Prototype read-only MekHQ save summary helper

- Status: Done
- Issue: `#27`
- Handoff: `docs/handoffs/archive/prototype-read-only-mekhq-save-summary-helper.md`
- Script: `scripts/summarize-mekhq-save.py`
- Mapping note: `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md`
- Mode: Project development / prototype helper
- Goal: Read a MekHQ `.cpnx`, `.cpnx.gz`, or plain campaign XML save and emit MEK-RPG-readable hard campaign facts without modifying the save.
- Acceptance: helper detects gzip saves by magic bytes, parses XML with structured APIs, emits JSON or Markdown, reports campaign metadata/date/location/funds, personnel, units, contracts, scenarios, repairs/logistics, markets, and unsupported fields; preserves MekHQ IDs where present; documents confirmed and unsupported mappings; verifies against disposable plain and gzip `The Learning Ropes` saves in the sister workspace.

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
- Expand `indexes/task-router.md` after verified summaries exist; the current metadata validator, coverage reporter, and route helper from issues `#46`-`#51` should be kept in sync with future summary work.
- Keep `indexes/manifest.yaml`, `indexes/task-router.md`, and helper scripts synchronized as future summaries are added.
- Validate all summaries against source pages.
- Add deeper MekHQ / MegaMek integration notes for encounter handoff, unit setup, campaign updates, and save-backed campaign bootstrapping as live play proves new gaps; initial tactical handoff checklist work is complete in issue `#55`.
- Future feature idea: investigate a read-only MEK-RPG web dashboard as a visibility and debugging layer over the active campaign save, GM context packets, session/NPC conversation history, state-audit warnings, and optional MekHQ bridge summaries. Boundary evaluation in issue `#56` recommends this direction, and issue `#57` defines the data contract; keep live movement, Sunnytown-derived game surfaces, and write/control actions out of scope.
- Repeat manual validation after each new playable layer: source summaries, routing, GM procedure, playtest, bug issues.

## Existing Foundation

- Initial project scaffolding exists with `gm/`, `indexes/`, `rules/`, `source/`, scripts, and starter docs.
- PDF extraction script exists, but no PDF processing has been performed as part of issue `#1`.
- Issue `#1` implementation adds the `docs/current/` workflow layer, handoff template, GitHub issue template, mode router, and updated entry-point docs.
- GitHub labels `agent-task` and `user-task` exist for agent-executed work and user-only work.

## Open Questions

- Branching posture: direct-to-`master` remains acceptable for small coherent tasks in this private repo; use feature branches for broad, risky, or multi-issue work that needs review as a unit.
- Should `issues/initial-issues.md` remain as a historical seed list after this roadmap exists?
