# Ruling Regression Scenarios

Status: issue `#83` manual scenario baseline.

Purpose: define golden end-to-end ruling scenarios for retrieval, authority status, citation behavior, failure behavior, and state-change proposal boundaries. These scenarios sit above `tests/fixtures/rules-route-golden-prompts.fixture.json`: route tests confirm candidate files; these scenarios define what a safe ruling workflow should preserve.

These are manual regression scenarios, not strict scripted tests yet. A future harness can convert them into machine checks once ruling output has stable text and proposal envelopes.

## Global Expectations

Every scenario should preserve these invariants:

- Start in `Rules lookup mode` unless the command explicitly asks to play or save campaign state.
- Use `indexes/task-router.md`, then routed committed summaries, then page references if summaries are insufficient.
- Do not answer A Time of War rules from memory when committed summaries exist.
- Do not read protected source paths unless the user explicitly starts source processing or private source lookup.
- Cite committed summary files and source page references when available.
- Preserve authority status: `authoritative`, `provisional`, `source_lookup_required`, `external_authority_required`, `cannot_adjudicate`, or `blocked_missing_route`.
- Do not copy protected rule text, tables, stat blocks, or raw source excerpts.
- Emit proposed state changes only through `docs/current/STATE_CHANGE_PROPOSAL_SCHEMA.md` shape.
- Keep MekHQ hard-ledger facts as pending intents until manual MekHQ application, save, and re-import confirmation.

## Scenario Format

Each scenario defines:

- Starting state
- User command
- Expected lookup behavior
- Expected citation behavior
- Expected state-change behavior
- Expected failure behavior
- Manual pass checks

## RUL-001 Simple Skill Check

Starting state:

- No active campaign state is required.
- User supplies the target number, modifiers, and roll or asks for the procedure only.

User command:

```text
How do I resolve a Technician skill check to open a stuck hatch?
```

Expected lookup behavior:

- Route to `rules/core/action-checks.md`, `rules/core/skill-checks.md`, and `rules/core/basic-action-resolution.md`.
- If the user asks for actual resolution and supplies explicit inputs, the helper may use the `core.basic_check` contract.
- If target number or modifiers are not supplied, answer procedure-first and ask for missing inputs rather than inventing values.

Expected citation behavior:

- Cite the committed summaries and their source page references.
- Mark the ruling provisional when relying on draft summaries.

Expected state-change behavior:

- No campaign file is edited.
- If a consequence is requested, propose a `session_log` or `current_state` change through `STATE_CHANGE_PROPOSAL_SCHEMA.md`.

Expected failure behavior:

- If the prompt asks for exact table values not present in summaries, return source lookup guidance with page references.

Manual pass checks:

- The response explains when to roll, how to apply explicit modifiers, how to compare against the target, and how to interpret margin without reproducing tables.
- Missing mechanical inputs remain unresolved.

## RUL-002 Opposed Check

Starting state:

- Actor and defender are directly contesting one outcome.
- User supplies or can supply both target numbers and rolls.

User command:

```text
My scout sneaks past a sentry who is actively watching. How should the opposed check work?
```

Expected lookup behavior:

- Route to `rules/core/opposed-actions.md` and `rules/core/basic-action-resolution.md`.
- Explain that both sides roll appropriate checks and compare successful margins or no-clean-win states.
- If resolving with explicit inputs, use or align with `core.opposed_check`.

Expected citation behavior:

- Cite opposed action and basic resolution summaries, including page references.

Expected state-change behavior:

- A successful sneak may propose `session_log`, `relationship_update`, `npc_update`, or `hook_update`.
- A tie or mutual failure should propose unresolved GM follow-up rather than granting a clean win.

Expected failure behavior:

- If exact skill choices or modifiers are uncertain, state what must be chosen by GM/user.

Manual pass checks:

- The response does not favor the initiating actor on tied margins by default.
- No NPC alert state is silently written.

## RUL-003 Edge Use

Starting state:

- A roll is consequential and the player asks whether Edge can affect it.

User command:

```text
Can I spend Edge on this failed check, and what should I record?
```

Expected lookup behavior:

- Route to `rules/core/edge.md`, with related core resolution summaries as needed.
- If exact Edge timing or recovery details are not fully summarized, preserve uncertainty and cite pages.

Expected citation behavior:

- Cite the Edge summary and source page references.

Expected state-change behavior:

- If Edge is spent, propose a `pc_condition` or `pc_resource`-style note targeting `pcs.md`.
- If recovery timing matters, propose a `rules_gap` or unresolved question unless the source/user confirms it.

Expected failure behavior:

- Do not invent Edge recovery timing, costs, or special exceptions.

Manual pass checks:

- The response separates permission to use Edge from durable resource tracking.

## RUL-004 Combat Initiative

Starting state:

- Personal/RPG-scale combat is starting.

User command:

```text
We are in a five-second personal combat turn. How do we handle initiative?
```

Expected lookup behavior:

- Route to `rules/personal-combat/initiative.md` and related action/movement summaries if needed.
- Keep the scope personal/RPG-scale.

Expected citation behavior:

- Cite initiative summary and source page references.

Expected state-change behavior:

- Propose only temporary `current_state` or `session_log` checkpoint notes unless a durable consequence occurs.

Expected failure behavior:

- If the scene involves full BattleMech tactical combat, warn and route to tactical handoff instead.

Manual pass checks:

- The response does not import Classic BattleTech initiative rules into A Time of War personal combat.

## RUL-005 Ranged Attack With Modifiers

Starting state:

- Personal-scale ranged attack with cover, range, weapon profile, and target context.

User command:

```text
I shoot at a guard in cover with my pistol. What modifiers do we need?
```

Expected lookup behavior:

- Route to `rules/personal-combat/ranged-attacks.md`, `rules/core/skill-checks.md`, and possibly `rules/equipment/weapons.md`.
- Ask for explicit weapon/range/cover/modifier inputs when exact values are not in committed summaries.

Expected citation behavior:

- Cite ranged attack and relevant equipment/page-reference summaries.

Expected state-change behavior:

- If ammunition, injury, or alert status changes, propose `asset_update`, `pc_condition`, `npc_update`, `hook_update`, or `pending_mekhq_action` as appropriate.

Expected failure behavior:

- Exact weapon stats, range bands, or modifier tables should produce `source_lookup_required` unless supplied by user or source review.

Manual pass checks:

- The ruling does not copy or invent weapon tables.

## RUL-006 Damage Resolution

Starting state:

- A personal-scale attack has hit and the user asks what damage/wounds happen.

User command:

```text
The attack hit. How do I resolve damage and wounds?
```

Expected lookup behavior:

- Route to `rules/personal-combat/damage.md`, `rules/personal-combat/wounds.md`, and related recovery summaries when needed.
- Keep exact table values source-bound if not summarized.

Expected citation behavior:

- Cite damage/wound summaries and page references.

Expected state-change behavior:

- Propose `pc_condition`, `npc_update`, `current_state`, and `session_log` changes through the state proposal schema.
- Include unresolved questions for exact penalties, recovery clocks, or source-bound tables when not supplied.

Expected failure behavior:

- Do not silently kill a child player character; require explicit adult approval if that boundary is relevant.
- Do not invent exact wound penalties.

Manual pass checks:

- Injury state is proposed, not written.
- Sensitive harm details remain controlled and concise.

## RUL-007 Piloting Or Control Check

Starting state:

- RPG-scale vehicle maneuver, not a hex-scale tactical BattleMech exchange.

User command:

```text
The driver tries to keep control during a rough extraction. What check applies?
```

Expected lookup behavior:

- Route to `rules/vehicles-and-mechs/piloting.md` and core resolution summaries.
- If tactical movement, BattleMech combat, heat, unit damage, or exact vehicle rules matter, warn and hand off.

Expected citation behavior:

- Cite vehicle/piloting and tactical handoff references as applicable.

Expected state-change behavior:

- RPG-scale outcomes may propose `current_state`, `mission_update`, `asset_update`, or `hook_update`.
- MekHQ-owned unit condition changes become `pending_mekhq_action`, not confirmed damage.

Expected failure behavior:

- Return `external_authority_required` for tactical precision, MegaMek/MekHQ-owned combat, or full BattleTech unit resolution.

Manual pass checks:

- The response does not try to run hex-scale vehicle or BattleMech combat.

## RUL-008 Equipment Lookup

Starting state:

- User asks for exact gear stats, price, legality, or catalog details.

User command:

```text
What is the exact cost and game effect of this electronics kit?
```

Expected lookup behavior:

- Route to `rules/equipment/electronics.md`, `rules/equipment/personal-gear.md`, or page-reference index.
- If exact table values are not in committed summaries, require source lookup or user-supplied values.

Expected citation behavior:

- Cite the summary or page-reference row that points to the private source pages.

Expected state-change behavior:

- If the item is acquired or lost, propose `asset_update`.
- If MekHQ owns the purchase, cost, market removal, or ledger result, propose `pending_mekhq_action`.

Expected failure behavior:

- Return `source_lookup_required`; do not copy or invent catalog rows.

Manual pass checks:

- The response gives where to check, not the protected table content.

## RUL-009 Ambiguous Lookup

Starting state:

- User gives an unclear prompt that could route to several procedures.

User command:

```text
What do I roll to get through security?
```

Expected lookup behavior:

- Route likely candidates such as stealth, electronics, social, or opposed checks depending on clarified fiction.
- Ask one concise clarification when a ruling would otherwise pick the wrong subsystem.

Expected citation behavior:

- Cite the candidate routes only after narrowing, or cite the router/summary candidates as provisional.

Expected state-change behavior:

- No proposal unless the user supplies stakes/outcome.

Expected failure behavior:

- Return `cannot_adjudicate` or a clarification request rather than inventing a single procedure.

Manual pass checks:

- The response offers concrete resolution options without pretending ambiguity is resolved.

## RUL-010 Source Conflict

Starting state:

- A committed summary, old campaign note, and user memory appear to disagree.

User command:

```text
This summary says one thing, but I remember the rule working differently. Which should we use?
```

Expected lookup behavior:

- Prefer current user correction for table decision, but keep rules authority source-bound.
- Use page references and summary status to identify where to verify.
- If conflict cannot be resolved from committed summaries, mark source lookup required.

Expected citation behavior:

- Cite the conflicting committed summary and page-reference index row.

Expected state-change behavior:

- If the table makes a provisional ruling, propose `rules_gap` and maybe `session_log`.

Expected failure behavior:

- Do not overwrite summaries or campaign notes during rules lookup unless the user asks for project maintenance.

Manual pass checks:

- The response distinguishes table ruling, committed draft summary, and private source verification.

## RUL-011 Missing Rule Or Page Reference

Starting state:

- User asks about a rule that has no route, missing summary, or missing page reference.

User command:

```text
How do underwater vibroblade attacks work in this system?
```

Expected lookup behavior:

- Run route lookup; if no committed route exists, say so.
- Check page-reference index only if a related row exists.

Expected citation behavior:

- Cite missing route or related page-reference result; do not fabricate a page.

Expected state-change behavior:

- If during play, propose `rules_gap` with `source_lookup_required`.
- If project maintenance is requested, create or suggest a GitHub issue.

Expected failure behavior:

- Return `blocked_missing_route` or `source_lookup_required`.

Manual pass checks:

- The response says what is known, what is not known, and where to verify if available.

## RUL-012 Campaign Persistence

Starting state:

- A scene creates durable narrative facts but no MekHQ hard-ledger result.

User command:

```text
We convinced the informant to help later. What should be saved?
```

Expected lookup behavior:

- Use campaign memory workflow rather than rules lookup unless a rule is requested.
- Target `session-log.md`, `npcs.md`, `relationships.md`, and `hooks.md` as appropriate.

Expected citation behavior:

- Cite workflow docs such as `docs/current/CAMPAIGN_MEMORY_STRATEGY.md` and `gm/state-save-checklist.md` if explaining process.

Expected state-change behavior:

- Emit proposal objects for `session_log`, `npc_update`, `relationship_update`, and `hook_update`.
- Do not edit files unless in play close-out or the user approves application.

Expected failure behavior:

- If no active campaign is selected, ask which save folder owns the memory.

Manual pass checks:

- Structured owner files outrank old summaries.

## RUL-013 Salvage, Repair, Or Cost Workflow

Starting state:

- MekHQ-linked campaign or tactical aftermath may alter funds, salvage, repairs, contracts, unit condition, or markets.

User command:

```text
We salvaged parts and need to repair the damaged vehicle. What should happen in the campaign files and MekHQ?
```

Expected lookup behavior:

- Route campaign/equipment/repair context as needed.
- Use `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md` for hard-ledger intents.
- Use tactical handoff docs when exact battlefield salvage or unit damage is external.

Expected citation behavior:

- Cite workflow docs and any relevant rules summaries/page references.

Expected state-change behavior:

- Propose RPG memory updates for narrative cause and mission aftermath.
- Propose `pending_mekhq_action` for exact funds, salvage, repairs, unit condition, market removal, or contract changes.
- Pending item must include manual application and saved import confirmation fields.

Expected failure behavior:

- Do not mark final funds, repair state, salvage ownership, or unit condition as confirmed until MekHQ import proves it.
- Return `external_authority_required` when MegaMek/MekHQ/tactical result ownership is needed.

Manual pass checks:

- The response labels pending actions as intents/checklists.
- It does not imply direct MekHQ save or XML writeback.

## RUL-014 Advancement And Rewards

Starting state:

- A session, downtime period, promotion, or mission aftermath just ended.

User command:

```text
How much XP should I award after session feedback, and what do we record for salary and rank?
```

Expected lookup behavior:

- Route to `rules/campaign/advancement-and-rewards.md`, with related advancement and campaign summaries as needed.
- Authority gate status should be `provisional`.
- Exact XP, salary, bonus, expense, rank, power, and aging table values remain source lookup unless already supplied by the user.

Expected citation behavior:

- Cite the advancement/rewards summary and page references.

Expected state-change behavior:

- Propose session-log, PC advancement, rank/status, and asset or pending MekHQ intent updates as separate approval-gated changes.

Expected failure behavior:

- Return `source_lookup_required` for exact table values not committed in the summary.

Manual pass checks:

- Campaign context files in the route do not cause `cannot_adjudicate` when draft summaries are present.
- The response does not invent award tables or salary values.

## RUL-015 Special Hazards And Illness

Starting state:

- A live scene involves terrain, weather, atmosphere, a creature, venom, disease, quarantine, or inoculation.

User command:

```text
The squad crosses deep snow in a blizzard, then a local predator's venom creates a quarantine scare.
```

Expected lookup behavior:

- Route to the relevant `rules/special/` summaries and `rules/equipment/drugs-and-poisons.md` when venom or treatment matters.
- Authority gate status should be `provisional` for procedure prompts.

Expected citation behavior:

- Cite the special-case summaries and their source page references.

Expected state-change behavior:

- Propose mission clocks, medical conditions, asset/equipment damage, or quarantine notes only through state-change proposals.

Expected failure behavior:

- Exact environmental modifiers, creature stats, venom values, disease tables, and treatment values require private source lookup.

Manual pass checks:

- The response uses clocks and visible stakes without copying tables.
- Real-world medical or survival advice stays out of scope.

## RUL-016 Special Equipment Authority

Starting state:

- A character uses battle armor, a prosthetic or implant, a drug/poison, or a personal vehicle/fuel asset.

User command:

```text
A PC scrambles into powered armor while another PC needs field treatment for venom and the crew's utility truck is low on fuel.
```

Expected lookup behavior:

- Route to `rules/equipment/battle-armor-and-exoskeletons.md`, `rules/equipment/drugs-and-poisons.md`, and `rules/equipment/personal-vehicles.md` as applicable.
- Authority gate status should be `provisional` for RPG-scale readiness, treatment, and logistics.

Expected citation behavior:

- Cite the equipment summaries and page references.

Expected state-change behavior:

- Propose suit readiness, medical condition, drug/poison clock, vehicle asset, fuel readiness, and MekHQ pending intents separately.

Expected failure behavior:

- Exact suit stats, prosthetic/implant values, drug/poison values, vehicle entries, fuel values, and tactical battle armor combat require source lookup or external tactical authority.
- Battle armor hex movement, mounted weapons, heat, full tactical turns, or MekHQ hard-ledger facts should return `external_authority_required`.

Manual pass checks:

- Battle armor readiness is not forced into tactical handoff unless tactical precision matters.
- Exact equipment table requests are not answered from committed summaries.

## Future Script Harness Notes

A future scripted harness can use these scenarios by checking:

- route candidates include expected files
- authority gate status matches expected class
- response mentions required citation/page-reference fields
- protected source path content is absent
- `proposed_state_changes` are empty or match `STATE_CHANGE_PROPOSAL_SCHEMA.md`
- MekHQ hard-ledger proposals use `pending_mekhq_action`
- failure scenarios surface `source_lookup_required`, `external_authority_required`, `cannot_adjudicate`, or `blocked_missing_route`

Do not script assertions against long natural-language ruling prose until the ruling output format is stable.
