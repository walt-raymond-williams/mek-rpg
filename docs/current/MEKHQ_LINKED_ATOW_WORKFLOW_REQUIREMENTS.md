# MekHQ-Linked A Time of War Workflow Requirements

Status: issue `#39` requirements and coverage matrix.

Purpose: define testable expectations for running A Time of War roleplaying scenes in MEK-RPG while MekHQ remains the hard BattleTech campaign ledger. These requirements guide issue `#38` regression coverage and child issues `#40` through `#45`.

## Authority Boundary

MekHQ is authoritative for hard ledger facts: campaign date, day advancement, travel, markets, funds, rosters, assignments, injuries or fatigue when represented in MekHQ, units, transport, cargo, repairs, contracts, scenarios, tactical results, salvage, casualties, and force history.

MEK-RPG is authoritative for RPG memory: A Time of War character overlays, scene framing, conversations, relationships, secrets, promises, hooks, player-facing mission stakes, session logs, table rulings, safety/tone notes, and narrative uncertainty around MekHQ objects until the table commits a hard ledger outcome.

Hard ledger changes created during play must be recorded as pending MekHQ application items until the user applies them in MekHQ, saves the MekHQ campaign, and MEK-RPG imports or summarizes the saved result.

## Requirement Status Terms

- `Automated`: covered by a committed deterministic script or test.
- `Manual`: requires human MekHQ UI use, a playtest, or judgment-heavy review.
- `Planned`: assigned to an open child issue.
- `Blocked`: cannot be automated until another design or external state exists.
- `Missing`: no current coverage or child issue is assigned.

## Requirements

### Import And Summary

`REQ-MEKHQ-ATOW-001`: The save summary helper must read an explicit `.cpnx`, `.cpnx.gz`, or plain MekHQ XML path without writing to the input save or any derived MekHQ save payload.

`REQ-MEKHQ-ATOW-002`: Summary output must preserve source metadata, including input path, save timestamp where available, import timestamp, helper version, gzip detection, save size, MekHQ save version, warnings, and unsupported sections.

`REQ-MEKHQ-ATOW-003`: Summary output must expose core hard ledger checkpoint facts when present: campaign identity, campaign date, faction, location or current system fields, funds, personnel, units, contracts, scenarios, repairs/logistics, and markets.

`REQ-MEKHQ-ATOW-004`: Unsupported or uncertain hard ledger fields must be labeled as `Unknown`, `Unsupported`, `Needs MekHQ inspection`, or `Inferred`; MEK-RPG must not invent exact ledger values.

### Campaign Bootstrap

`REQ-MEKHQ-ATOW-005`: The bootstrap helper must create a new `campaigns/<campaign-id>/` folder from summary JSON, refuse existing folders, enforce safe lowercase-hyphen campaign ids, and leave `campaign-state/active-campaign.md` unchanged.

`REQ-MEKHQ-ATOW-006`: Bootstrapped MekHQ-linked campaigns must include standard campaign files plus `mekhq-bridge.md` and `pending-mekhq-actions.md`.

`REQ-MEKHQ-ATOW-007`: Bootstrap output must preserve MekHQ IDs and import metadata in `mekhq-bridge.md`, while placing table-facing premise, scene state, and RPG overlays in normal campaign files.

`REQ-MEKHQ-ATOW-008`: Viewpoint selection must be explicit and deterministic: exactly one supplied selector, commander fallback, first personnel fallback, or embedded unlinked PC fallback.

### Pre-Session Checkpoint

`REQ-MEKHQ-ATOW-009`: Before MekHQ-linked play, the GM workflow must load `campaign-state/active-campaign.md`, exactly one selected campaign folder, current bridge metadata, unresolved pending MekHQ actions, and the relevant campaign memory files.

`REQ-MEKHQ-ATOW-010`: The MekHQ campaign date from the latest import must be treated as the current campaign day. If MEK-RPG state disagrees, the workflow must record a discrepancy instead of advancing MEK-RPG independently.

`REQ-MEKHQ-ATOW-011`: The checkpoint must surface unsupported fields and unresolved pending actions before framing new ledger-sensitive scenes.

### In-Day A Time Of War Play

`REQ-MEKHQ-ATOW-012`: MEK-RPG may run in-day RPG scenes that do not require MekHQ ledger or calendar advancement, including conversations, inspections, negotiations, personal-scale action, downtime focus scenes, and tactical preparation.

`REQ-MEKHQ-ATOW-013`: Rules calls during play must start at `indexes/task-router.md` and committed summaries. Gaps must be recorded rather than filled with invented A Time of War procedures.

`REQ-MEKHQ-ATOW-014`: Scene results must split into MEK-RPG-owned memory updates and MekHQ-owned hard ledger intents.

`REQ-MEKHQ-ATOW-015`: MEK-RPG-owned memory must be saved in the active campaign folder after meaningful scenes: session log, current state, PCs, NPCs, relationships, hooks, missions, factions, assets overlays, rules gaps, and safety/tone where relevant.

### Pending Hard Ledger Intents

`REQ-MEKHQ-ATOW-016`: Any play result that may alter MekHQ-owned facts must create or update a concise item in `pending-mekhq-actions.md` instead of being treated as a final ledger fact.

`REQ-MEKHQ-ATOW-017`: Pending items must use stable item IDs, lifecycle status, type, priority, source scene, source files, target IDs, imported baseline, proposed action, manual checklist, confirmation field, affected files, blockers, and resolution notes.

`REQ-MEKHQ-ATOW-018`: Pending item lifecycle must distinguish `proposed`, `queued`, `user-applied-in-mekhq`, `imported`, `resolved`, `blocked`, and `abandoned`.

`REQ-MEKHQ-ATOW-019`: Normal campaign files may link to pending item IDs, but must label unresolved items as intents or manual-action checklists, not confirmed hard facts.

### Manual MekHQ Application And Re-Import

`REQ-MEKHQ-ATOW-020`: Manual hard ledger application requires the user to open the linked MekHQ campaign, confirm the expected baseline, apply the change in the MekHQ UI, and save the MekHQ campaign.

`REQ-MEKHQ-ATOW-021`: MEK-RPG must summarize or import the saved MekHQ campaign before treating manually applied hard ledger outcomes as final.

`REQ-MEKHQ-ATOW-022`: Re-import reconciliation must compare the latest import against pending item confirmation fields, mark matches as imported/resolved, and leave partial, absent, or contradictory results blocked with discrepancy notes.

`REQ-MEKHQ-ATOW-023`: MEK-RPG must preserve RPG-side scene memory when a hard ledger result differs, unless the table explicitly retcons the scene.

### Tactical Handoff

`REQ-MEKHQ-ATOW-024`: When hex movement, armor locations, heat, ammo, exact unit state, salvage, repairs, or scenario result details matter, MEK-RPG must hand off to Classic BattleTech, MegaMek, or MekHQ instead of resolving them as freeform RPG facts.

`REQ-MEKHQ-ATOW-025`: Tactical handoff preparation must preserve player-facing stakes, objectives, constraints, force intent, relevant RPG context, and the MekHQ-owned fields that must be confirmed after the tactical result.

`REQ-MEKHQ-ATOW-026`: Tactical outcomes that affect units, personnel, salvage, contracts, casualties, prisoners, kill credit, repairs, or scenario status must be imported from MekHQ or another tactical record before becoming final hard facts in MEK-RPG.

### GM Context Packet Boundaries

`REQ-MEKHQ-ATOW-027`: MekHQ-linked GM context packets must include latest bridge metadata, unresolved pending MekHQ items, relevant campaign memory files, rules routes, and safety/tone boundaries without mixing authority levels.

`REQ-MEKHQ-ATOW-028`: Context packets must label MekHQ-derived hard facts, MEK-RPG-owned RPG memory, narrative uncertainty, rules gaps, and pending ledger intents distinctly.

`REQ-MEKHQ-ATOW-029`: Context packet assembly must not require real MekHQ saves, protected A Time of War source text, direct MekHQ writeback, or invented rules interpretations.

### Regression Boundaries

`REQ-MEKHQ-ATOW-030`: Deterministic regression tests must use sanitized committed fixtures, disposable output folders, and explicit cleanup; they must not require real MekHQ saves, real MekHQ installs, purchased PDFs, extracted source text, network access, or direct MekHQ writeback.

`REQ-MEKHQ-ATOW-031`: Regression coverage must keep protected source paths ignored and unstaged, and must continue checking the no direct `.cpnx`, `.cpnx.gz`, XML, or raw MekHQ save writeback boundary.

## Coverage Matrix

| Requirement | Current coverage | Status | Follow-up |
| --- | --- | --- | --- |
| `REQ-MEKHQ-ATOW-001` | `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md`; prototype script behavior | Planned | Issue `#42` should add sanitized XML and gzip fixture coverage. |
| `REQ-MEKHQ-ATOW-002` | Helper docs describe metadata fields | Planned | Issue `#42` should assert metadata output from fixtures. |
| `REQ-MEKHQ-ATOW-003` | Helper docs list output shape and mappings | Planned | Issue `#42` should assert representative hard ledger fields. |
| `REQ-MEKHQ-ATOW-004` | Helper docs and bridge data model require uncertainty labels | Planned | Issues `#42` and `#49` should verify unsupported and inferred field handling. |
| `REQ-MEKHQ-ATOW-005` | Bootstrap docs; pending workflow regression compiles and runs bootstrap once | Planned | Issue `#41` should add focused fixture coverage for refusal and selector behavior. |
| `REQ-MEKHQ-ATOW-006` | `scripts/test-mekhq-pending-workflow.ps1` checks generated pending and bridge files | Automated | Issue `#43` should broaden standard campaign-file validator coverage. |
| `REQ-MEKHQ-ATOW-007` | Bootstrap docs and regression bridge checks | Planned | Issue `#41` should assert ID and metadata preservation in generated files. |
| `REQ-MEKHQ-ATOW-008` | Bootstrap docs describe selector behavior | Planned | Issue `#41` should cover selector and fallback cases. |
| `REQ-MEKHQ-ATOW-009` | `gm/session-procedure.md`; linked play loop; `scripts/test-mekhq-context-packet.ps1` checks selected campaign, bridge metadata, pending actions, and campaign memory inputs | Automated | Expand only if future helper output changes. |
| `REQ-MEKHQ-ATOW-010` | Linked play loop documents date authority; `scripts/test-mekhq-context-packet.ps1` fixture includes MekHQ date and bridge discrepancy metadata | Manual | Date reconciliation still needs playtest judgment or a future bridge discrepancy validator. |
| `REQ-MEKHQ-ATOW-011` | Linked play loop and pending workflow docs; `scripts/test-mekhq-context-packet.ps1` checks unresolved pending item visibility and validator output | Automated | Expand if unsupported-field reporting gains a structured schema. |
| `REQ-MEKHQ-ATOW-012` | Linked play loop and GM scene docs | Manual | Issue `#37` manual playtest should validate UI-linked play flow. |
| `REQ-MEKHQ-ATOW-013` | GM session procedure and router workflow | Manual | Future GM context scenarios can assert route references, but rule interpretation remains judgment-heavy. |
| `REQ-MEKHQ-ATOW-014` | Linked play loop, state-save checklist, GM context design, and `scripts/test-mekhq-context-packet.ps1` authority-boundary checks | Automated | Scene-by-scene save quality remains a playtest concern. |
| `REQ-MEKHQ-ATOW-015` | State-save checklist | Manual | Could become scenario coverage in issue `#45`; no separate child issue currently required. |
| `REQ-MEKHQ-ATOW-016` | Pending workflow doc; pending regression checks generated owner file | Planned | Issue `#44` should add a pending-action validator. |
| `REQ-MEKHQ-ATOW-017` | Pending workflow item schema | Planned | Issue `#44` should validate required fields and accepted values. |
| `REQ-MEKHQ-ATOW-018` | Pending workflow lifecycle states | Planned | Issue `#44` should validate lifecycle states and transitions where deterministic. |
| `REQ-MEKHQ-ATOW-019` | Pending workflow context packet notes; pending-action validator; `scripts/test-mekhq-context-packet.ps1` checks unresolved item labeling | Automated | None current. |
| `REQ-MEKHQ-ATOW-020` | Pending workflow manual checklist | Manual | Issue `#37` manual playtest should validate real UI application steps. |
| `REQ-MEKHQ-ATOW-021` | Pending workflow authority boundary | Manual | Issue `#37` should validate saved re-import confirmation; issue `#42` covers helper fixtures. |
| `REQ-MEKHQ-ATOW-022` | Pending workflow reconciliation procedure | Planned | Issue `#44` should validate structure; issue `#45` can scenario-test blocked/mismatch context. |
| `REQ-MEKHQ-ATOW-023` | Pending workflow reconciliation notes | Manual | Keep as playtest/context scenario expectation unless repeated failures justify a new issue. |
| `REQ-MEKHQ-ATOW-024` | `gm/switch-to-classic-battletech.md`; linked play loop | Planned | Issue `#55` should add a tactical encounter handoff checklist. |
| `REQ-MEKHQ-ATOW-025` | Encounter template and linked play loop provide partial guidance | Planned | Issue `#55` should make handoff inputs explicit. |
| `REQ-MEKHQ-ATOW-026` | Linked play loop outcome handling | Planned | Issue `#55` should include post-tactical import confirmation prompts. |
| `REQ-MEKHQ-ATOW-027` | `docs/current/GM_CONTEXT_PACKET_DESIGN.md`; `scripts/build-gm-context-packet.ps1`; `scripts/test-mekhq-context-packet.ps1` | Automated | None current. |
| `REQ-MEKHQ-ATOW-028` | Authority boundary docs; pending-action validator output; `scripts/test-mekhq-context-packet.ps1` manual-intent and structured-state checks | Automated | Future machine-readable packets could make this stricter. |
| `REQ-MEKHQ-ATOW-029` | `scripts/build-gm-context-packet.ps1`; `scripts/test-mekhq-context-packet.ps1`; protected-source and no-writeback docs | Automated | None current. |
| `REQ-MEKHQ-ATOW-030` | `scripts/test-mekhq-pending-workflow.ps1` uses sanitized fixture and cleanup | Planned | Issue `#40` should make this the top-level runner contract. |
| `REQ-MEKHQ-ATOW-031` | Pending workflow regression checks protected-source ignores and no-writeback docs | Automated | Issue `#40` should keep this in the default deterministic suite. |

## Child Issue Mapping

- Issue `#40`: owns the top-level deterministic runner for all automated requirements and should include `REQ-MEKHQ-ATOW-030` and `REQ-MEKHQ-ATOW-031` as default suite rules.
- Issue `#41`: owns focused bootstrap fixture coverage for `REQ-MEKHQ-ATOW-005` through `REQ-MEKHQ-ATOW-008`.
- Issue `#42`: owns sanitized XML/gzip save summary coverage for `REQ-MEKHQ-ATOW-001` through `REQ-MEKHQ-ATOW-004` and supports re-import confirmation checks for `REQ-MEKHQ-ATOW-021`.
- Issue `#43`: owns campaign-state validator coverage, especially standard file expectations from `REQ-MEKHQ-ATOW-006` and campaign selection/checkpoint prerequisites from `REQ-MEKHQ-ATOW-009`.
- Issue `#44`: owns deterministic pending-action structure validation for `REQ-MEKHQ-ATOW-016` through `REQ-MEKHQ-ATOW-019` and parts of `REQ-MEKHQ-ATOW-022`.
- Issue `#45`: done; owns GM context packet regression scenarios for MekHQ-linked packet assembly, especially `REQ-MEKHQ-ATOW-009`, `REQ-MEKHQ-ATOW-011`, `REQ-MEKHQ-ATOW-014`, `REQ-MEKHQ-ATOW-019`, and `REQ-MEKHQ-ATOW-027` through `REQ-MEKHQ-ATOW-029`.
- Issue `#37`: owns manual UI playtest evidence for `REQ-MEKHQ-ATOW-012`, `REQ-MEKHQ-ATOW-020`, `REQ-MEKHQ-ATOW-021`, and `REQ-MEKHQ-ATOW-023`.
- Issue `#55`: owns tactical handoff checklist work for `REQ-MEKHQ-ATOW-024` through `REQ-MEKHQ-ATOW-026`.

## Open Coverage Gaps

- `REQ-MEKHQ-ATOW-013` remains mostly procedural because rules lookup requires judgment after deterministic route discovery. Future context packet scenarios can assert that route references are present, but should not pretend to validate full A Time of War rulings.
- `REQ-MEKHQ-ATOW-015` is currently a save discipline requirement rather than a standalone deterministic check. It can be folded into context packet or campaign-state scenarios if repeated play finds drift.
- `REQ-MEKHQ-ATOW-023` requires table judgment when imported hard facts differ from scene memory. Manual playtest notes should preserve examples before any validator is attempted.

## Verification Guidance

Run these checks after changes to MekHQ-linked workflow, bootstrap, pending actions, protected-source boundaries, or regression infrastructure:

```powershell
./scripts/test-mekhq-pending-workflow.ps1
git diff --check
git check-ignore source/atow-pdf/example.pdf
git check-ignore source/atow-text/page-001.txt
```

No requirement in this document authorizes source processing, direct MekHQ save writes, raw MekHQ save fixture commits, purchased PDF commits, extracted A Time of War text commits, copied rulebook tables, or invented hard ledger facts.
