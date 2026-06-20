# Campaign Consequence Lookup Validation

Status: issue `#22` validation note.

## Scope

This pass replaced placeholder campaign-system summaries with draft, source-reviewed, paraphrased summaries for:

- campaign consequence overview
- advancement, XP, training, salary, bonuses, rank, and power
- contracts and mission aftermath
- contacts, favors, patrons, and borrowed resources
- reputation and faction standing
- injury recovery, medical downtime, and lasting wounds
- downtime and mission readiness

The summaries cite A Time of War source pages but do not reproduce tables, catalog entries, sample text, salary values, XP values, or contract economics.

## Scenario Lookup Tests

### Contract Aftermath

Prompt: "The crew completes a job, but collateral damage gives the employer a reason to reduce pay and a rival faction heard about it."

Route:

1. Start at `indexes/task-router.md`.
2. Match "contract aftermath, employment terms, payment, salvage expectations, breach, mission rewards, or employer obligations."
3. Read `rules/campaign/contracts.md`.
4. Also read `rules/campaign/reputation.md`, `rules/campaign/contacts.md`, `gm/mission-template.md`, active `campaigns/<campaign-id>/missions.md`, and active `campaigns/<campaign-id>/assets.md`.

Result: Pass. The route gives a procedure for comparing outcome to terms, saving payment/salvage/debt in `assets.md`, updating employer and faction posture, and marking dedicated force-level contract construction as an external-tool or later-source gap.

### Downtime Recovery

Prompt: "A wounded PC has two weeks before the next convoy raid and wants to heal, train, and buy medical supplies."

Route:

1. Start at `indexes/task-router.md`.
2. Match "downtime between missions, training time, work between sessions, recovery clocks, repair/acquisition prep, or mission readiness."
3. Read `rules/campaign/downtime-and-readiness.md`.
4. Also read `rules/campaign/injuries-recovery.md`, `rules/campaign/advancement.md`, `rules/equipment/overview.md`, and `rules/personal-combat/recovery.md`.

Result: Pass. The route separates healing, training, and acquisition instead of combining them into one invented roll. It tells the GM to record recovery clocks and readiness risks in the active campaign folder.

### Reputation And Contact Pressure

Prompt: "A PC asks an old military contact for restricted parts after a public scandal."

Route:

1. Start at `indexes/task-router.md`.
2. Match "NPCs, contacts, favors, patrons, informants, calling in connections, borrowing help, or contact pressure."
3. Read `rules/campaign/contacts.md`.
4. Also read `rules/campaign/reputation.md`, active `campaigns/<campaign-id>/npcs.md`, active `campaigns/<campaign-id>/factions.md`, and active `campaigns/<campaign-id>/relationships.md`.

Result: Pass. The route handles the contact request and the public-scandal pressure as related but distinct consequences. Exact trait tables and modifiers remain cited private source lookups.

### Mission Readiness

Prompt: "The next mission starts tomorrow, but the armor is damaged, a pilot is recovering, and the employer wants a quick answer."

Route:

1. Start at `indexes/task-router.md`.
2. Match "downtime between missions, training time, work between sessions, recovery clocks, repair/acquisition prep, or mission readiness."
3. Read `rules/campaign/downtime-and-readiness.md`.
4. Also read `rules/campaign/injuries-recovery.md`, `rules/equipment/overview.md`, `rules/campaign/contracts.md`, active `campaigns/<campaign-id>/assets.md`, and active `campaigns/<campaign-id>/missions.md`.

Result: Pass. The route makes readiness a save-state and risk-framing step, not a full tactical logistics engine.

## Save Guidance

The update keeps the existing campaign folder structure. Consequence ownership is:

- `pcs.md`: XP, injuries, fatigue, traits, training, advancement, personal gear, and character readiness.
- `npcs.md`: named contacts, patrons, enemies, doctors, trainers, employers, and intermediaries.
- `factions.md`: faction posture, public standing, employer reaction, political pressure, and organizational resources.
- `assets.md`: money, salary, bonuses, salvage expectations, medical costs, borrowed equipment, repairs, vehicles, contracts, debts, and property.
- `relationships.md`: favors, grudges, trust, leverage, obligations, and promises.
- `missions.md`: contract terms, outcome status, deadlines, readiness gates, breaches, and follow-up objectives.
- `hooks.md`: future pressure, unresolved obligations, rumors, retaliation, and delayed consequences.
- `current-state.md`: exact resume point, immediate readiness pressure, and next prompt.
- `session-log.md`: the table-facing record of what changed this session.

## Validator Maintenance Decision

Do not update `scripts/validate-campaign-state.ps1` for issue `#22`.

Reason: this task adds rules routes and save guidance but does not add, remove, or rename required campaign save files. The existing validator should remain focused on the shared campaign-save structure and active-campaign safety.

Future companion validator candidate: after a real campaign save accumulates contract records, injury clocks, contacts, faction posture, and asset changes, add a narrower campaign-consequence validator that checks for expected headings or unresolved markers inside `assets.md`, `missions.md`, `pcs.md`, `relationships.md`, and `factions.md`.

## Remaining Gaps

- Exact XP, salary, bonus, expense, property, rank, reputation, and contact values remain private source lookups.
- Dedicated mercenary-contract construction was not found in the reviewed A Time of War campaign ranges; use campaign-state procedure and external BattleTech campaign tools for force-scale contracts and logistics.
- Vehicle/BattleMech readiness remains placeholder-level until issue `#23`.
- The summaries are draft, not fully verified, until broader scenario validation is repeated during a real campaign setup/play session.
