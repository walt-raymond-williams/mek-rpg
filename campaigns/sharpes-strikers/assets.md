# Assets

Use this file for campaign money, ships, vehicles, BattleMechs, cargo, property, permits, debts, contracts, repairs, and other durable resources.

For richer vehicle, DropShip, and unit entries, follow `docs/current/ASSET_SHEET_SCHEMA.md`. Keep hard facts, evidence labels, and narrative overlays separate. In MekHQ-linked campaigns, MekHQ owns exact funds, unit state, repairs, markets, rosters, cargo, contracts, and tactical ledger changes; record pending intents here or in `pending-mekhq-actions.md` until a live reread or saved import verifies them.

## Funds And Ledger Summary

- Current funds: 44,806,926 C-bills
- Evidence label: Confirmed from MekHQ live API snapshot.
- MekHQ import reference: `mekhq-live-api-capture/mekhq-state.json`, captured 2026-07-04.
- Known debts, payroll, fees, or upkeep: No active loans reported by MekHQ snapshot; payroll/upkeep remains MekHQ-owned. Recent visible 3027-11-22 transactions are maintenance charges for Wasp WSP-1A #2, Locust LCT-1V, Clint CLNT-2-3T, Rifleman RFL-3N, and Stalker STK-3F. The Mule upkeep problem remains resolved.
- Unsupported or unresolved finance questions: Dirty/unsaved save state is not source-confirmed by the V1 API. Exact salvage transport capacity and some historical transaction details remain API-limited.

## Assets

### Wallacia Objective Raid Contract

- Asset slug: wallacia-objective-raid-contract
- Category: contract
- Status: active
- Evidence summary: MekHQ live API on 3027-11-22 reports `3027 - CC - Wallacia Objective Raid` as Active, active on the campaign date, with 3 months left.
- Employer: Capellan Confederation.
- Enemy: Unknown.
- Location: Wallacia.
- Contract dates: 3027-11-16 to 3028-02-16.
- Command rights: House.
- Payment summary: base amount 3,985,200 C-bills; total amount 17,208,018 C-bills; total amount plus fees/bonuses 16,347,617 C-bills; monthly payout 4,086,904 C-bills; total monthly payout 10,226,517 C-bills; advance amount 4,086,904 C-bills; fee amount 860,401 C-bills; overhead amount 16,932 C-bills; support amount 1,426,928 C-bills; transit amount 3,044,250 C-bills; transport amount 8,734,708 C-bills; estimated total profit 12,347,773 C-bills.
- Support and transport: 100% straight support; 100% transport compensation.
- Salvage: 70% salvage; current salvage percent 62; salvage exchange false; salvaged by unit 2,757,103 C-bills; salvaged by employer 1,732,502 C-bills; 0% battle loss compensation.
- Current funds under contract: 44,806,926 C-bills, no active loans exposed.
- Salvage sale note: user reports recent salvage was sold after the latest battle. MekHQ confirms aggregate contract salvage value and current funds, but the current live API capture does not expose itemized sale lines or the exact sold salvage list.
- MekHQ reference: `mekhq-live-api-capture/mekhq-state.json`.

### Butzfleth Pirate Hunting Contract

- Asset slug: butzfleth-pirate-hunting-contract
- Category: contract
- Status: completed; Success.
- Evidence summary: MekHQ live API on 3027-11-18 reports `3027 - Magistracy of Canopus - Butzfleth Pirate Hunting` as Success and no longer active.
- Employer: Magistracy of Canopus.
- Enemy: Pirates / Unknown exact opposition.
- Location: Butzfleth.
- Contract dates: 3027-07-28 to 3027-09-02.
- Command rights: Liaison.
- Payment summary: base amount 3,506,250 C-bills; total amount 16,707,433 C-bills; total amount plus fees/bonuses 15,872,061 C-bills; monthly payout 2,380,809 C-bills; total monthly payout 7,339,989 C-bills; advance amount 3,968,016 C-bills; fee amount 835,372 C-bills; overhead amount 26,210 C-bills; support amount 1,998,982 C-bills; transit amount 2,409,750 C-bills; transport amount 8,766,241 C-bills; estimated total profit 2,570,813 C-bills.
- Support and transport: 100% straight support; 100% transport compensation.
- Salvage: 60% salvage; current salvage percent 60; salvage exchange false; salvaged by unit 17,517,158 C-bills; salvaged by employer 12,070,307 C-bills; 0% battle loss compensation.
- Current funds after contract close: 42,060,485 C-bills, no active loans exposed.
- MekHQ reference: `mekhq-live-api-capture/mekhq-state.json`.

### Altorra Garrison Duty Contract

- Asset slug: altorra-garrison-duty-contract
- Category: contract
- Status: completed; Success.
- Evidence summary: MekHQ live API on 3027-08-16 reports `3025 - CC - Altorra Garrison Duty` as Success and no longer active.
- Employer: Capellan Confederation.
- Enemy: Unknown.
- Location: Altorra.
- Contract dates: 3025-12-04 to 3027-05-04.
- Command rights: House.
- Payment summary: base amount 11,153,700 C-bills; total amount 18,755,668 C-bills; total amount plus fees/bonuses 17,817,885 C-bills; monthly payout 786,083 C-bills; total monthly payout 5,937,986 C-bills; advance amount 4,454,471 C-bills; fee amount 937,783 C-bills; overhead amount 175,268 C-bills; support amount 0 C-bills; transit amount 1,053,000 C-bills; transport amount 6,373,700 C-bills; signing bonus 0 C-bills; estimated total profit 7,908,871 C-bills.
- Support and transport: 0% straight support; 100% transport compensation.
- Salvage: 20% salvage; current salvage percent 9; salvage exchange false; salvaged by unit 89,300 C-bills; salvaged by employer 978,181 C-bills.
- Battle loss compensation: 40%.
- Sharpe's pay-risk read: this is a long garrison job with better battle-loss protection than Talitha, but no straight support. The employer has House command rights, so the Strikers have less tactical independence on paper than Sharpe probably likes.
- MekHQ reference: `mekhq-live-api-capture/mekhq-state.json`.

### Talitha Recon Raid Contract

- Asset slug: talitha-recon-raid-contract
- Category: contract
- Status: completed; Success
- Evidence summary: MekHQ live API on 3026-03-25 reports `3025 - CC - Talitha Recon Raid` as Success and no longer active.
- Employer: Capellan Confederation.
- Enemy: Unknown.
- Location: Talitha.
- Contract dates: 3025-03-09 to 3025-06-09.
- Command rights: Liaison.
- Payment summary: base amount 1,555,200 C-bills; total amount 6,874,764 C-bills; total amount plus fees/bonuses 6,531,026 C-bills; monthly payout 1,632,756 C-bills; total monthly payout 3,343,798 C-bills; advance amount 1,632,756 C-bills; total advance amount 1,632,756 C-bills; fee amount 343,738 C-bills; overhead amount 29,353 C-bills; support amount 660,131 C-bills; transit amount 594,000 C-bills; transport amount 4,036,080 C-bills; signing bonus 0 C-bills; estimated total profit 2,449,594 C-bills.
- Support and transport: 80% straight support; 100% transport compensation.
- Salvage: 20% exchange salvage; current salvage percent 0; salvaged by unit 0 C-bills; salvaged by employer 0 C-bills.
- Battle loss compensation: 0%.
- Sharpe's retrospective read: the contract closed as Success despite withdrawals and defeats along the way. The later Recon Evasion and Frontline Disruption wins likely helped keep the final ledger from matching the worst camp gossip.
- MekHQ reference: `mekhq-live-api-capture/mekhq-state.json`.

### Contracted Transport To Talitha

- Asset slug: contracted-transport-talitha
- Category: contract-right
- Status: historical; tied to completed Talitha contract
- Evidence summary: MekHQ contract terms report 100% transport compensation, 4,036,080 C-bills transport amount, 594,000 C-bills transit amount, and 20 travel days.
- Controller/owner claim: Transport is part of the Capellan Confederation Talitha recon raid contract, not a confirmed Sharpe's Strikers-owned ship.
- Ownership evidence: No owned transport vessel is exposed in the current live API snapshot.
- Location: Talitha.
- Condition/readiness: Exact carrier, bay capacity, ship name, and loading plan are not exposed by the V1 live API.
- Legal, title, permit, debt, lien, or obligation notes: Employer-paid transport under contract terms.
- Crew/operators: Unknown; likely contracted or employer-arranged transport unless later confirmed.
- Fuel, cargo, ammunition, repair, or supply notes: MekHQ transport/cargo read reports no ship transport assignments or carried unit references in the snapshot; capacity math and load/unload commands are not exposed in V1.
- MekHQ reference: `mekhq-live-api-capture-sharpes-strikers/mekhq-state.json`.
- Tactical handoff route: Use MekHQ/MegaMek/Classic BattleTech only after forces are assigned and tactical combat begins.
- Hooks or next review: Sharpe should confirm carrier identity, berth/bay access, unloading order, and who controls the arrival schedule before landing.

### MekHQ Combat And Support Unit Pool

- Asset slug: mekhq-unit-pool-current
- Category: combat-unit
- Status: available with service pressure after the April 9 convoy victory.
- Evidence summary: MekHQ live API reports 24 units total, 0 deployed, 22 available, and 23 deployable by exposed API flag.
- Controller/owner claim: Sharpe's Strikers, MekHQ-owned hard ledger.
- Ownership evidence: Confirmed from MekHQ live API snapshot.
- Location: Altorra.
- Condition/readiness: MekHQ live API on 3026-04-16 reports 24 units total, 0 deployed, 22 available, 23 deployable by the exposed API flag, 8 units needing service, 2 units needing parts, 0 units under repair, 2 parts needed, and 33 service items total.
- Legal, title, permit, debt, lien, or obligation notes: Unknown.
- Crew/operators: The four landed BattleMechs now have crew ids exposed in the API snapshot; final RPG-side cockpit rotation and backup pilot assignments still need command confirmation before tactical use.
- Fuel, cargo, ammunition, repair, or supply notes: Jenner JR7-D needs 1 part and has 5 service items; Locust LCT-1V now reports Undamaged but still needs 1 part and has 1 service item. Recent convoy force service items: Catapult 5, Griffin 1, Wolverine 7, Riever 4, Clint 1, Shadow Hawk 9.
- MekHQ reference: `mekhq-live-api-capture/mekhq-state.json`.
- Tactical handoff route: Use MekHQ/MegaMek/Classic BattleTech when units are assigned to a scenario.
- Hooks or next review: Resolve pilot/unit assignments and mothball readiness before mission pressure escalates.

#### BattleMechs

- Catapult CPLT-C1, 65 tons. Available; undamaged, 5 service items. Pilot: Captain Sharpe "Shooter" Williams, fatigue 1.
- Griffin GRF-1N, 55 tons. Available; undamaged, 1 service item. Pilot: Sergeant Truda "Floyd" Pavlischev, fatigue 1.
- Wolverine WVR-6R, 55 tons. Available; undamaged, 7 service items. Pilot: Sergeant Pietrek "Deepfield" Bonnet, fatigue 1.
- Jenner JR7-D, 35 tons. Available; Moderate Damage, 1 part needed, 5 service items. Pilot: Sergeant Benedikt "Cypher" Crystar, fatigue 0.
- Clint CLNT-2-3T, 40 tons. Available; undamaged, 1 service item. Pilot: Altafesta Moran, fatigue 2.
- Shadow Hawk SHD-2H, 55 tons. Available; undamaged, 9 service items. Pilot: Coletta Birkeland-Yoshida, fatigue 2.
- Locust LCT-1V, 20 tons. Available; currently reports Undamaged, 1 part needed, 1 service item. Pilot: Komala Taksa, fatigue 2. Table note: damaged during `Frontline Breakthrough` by an actuator hit and repeated falls while trying to stand; status improved by the April 16 snapshot but parts pressure remains.
- Stinger STG-3R, 20 tons. Available, undamaged. Pilot: Loman Muir.
- Stinger STG-3R #2, 20 tons. Available, undamaged. Pilot: Abu Hasan.
- Wasp WSP-1A, 20 tons. Available, undamaged. Pilot: Marcie Yi.
- Wasp WSP-1A #2, 20 tons. Available, undamaged. Pilot: Felix Lorentsen.

#### Aerospace

- Riever F-100, 100 tons. Available; undamaged, 4 service items. Pilot: Frank Narusov, fatigue 2.
- Stingray F-90, 60 tons. Not present in the current unit list returned by the live API snapshot; prior status should be treated as superseded until confirmed.

#### Ground, Support, And Infantry

- 7 BattleMech Recovery Vehicles, 50 tons each. Four are landed and undamaged; `BattleMech Recovery Vehicle #5` is in transit for 9 days; `BattleMech Recovery Vehicle #6` and `BattleMech Recovery Vehicle #7` are in transit for 40 days.
- 4 Flatbed Trucks, 10 tons each. Landed, undamaged, available, deployable by API flag.
- Salvage fleet expansion decision: Sharpe will expand BattleMech Recovery Vehicle capacity only. Current confirmed roster is 7 BattleMech Recovery Vehicles and 4 Flatbed Trucks. Target is 8 BattleMech Recovery Vehicles; no additional Flatbed Trucks are needed per user direction.
- Sherpa Armored Truck (Mobile Canteen), 35 tons. Landed, undamaged, available, deployable by API flag.
- MASH Truck (Small), 15 tons. Landed, undamaged, available, not deployable by the exposed API flag.
- Foot Platoon (Rifle), 0.5 tons. Landed, undamaged, available, deployable by API flag.

#### Sharpe's Read

- The Strikers are no longer a four-BattleMech outfit. The current force includes Catapult, Griffin, Wolverine, Jenner, Clint, Shadow Hawk, Locust, two Stingers, two Wasps, and Riever aerospace support.
- The April 9 convoy force did the job cleanly: Sharpe's team destroyed the enemy pressure, preserved the convoy, and came back with no pilot hits and no assigned-unit damage statuses. The bill is mostly in maintenance hours and service parts, not blood or wreckage.
- The April 16 intercept is also a clean ledger win, completing both the escape and enemy destroy/rout objectives. No current pilot hits or fatigue remain exposed for key named pilots in the May 1 live read.
- Aerospace strength has shifted: Riever F-100 is active and deployed; Stingray F-90 is not present in the current unit list and needs confirmation before being used in play.
- The recovery assets make the company unusually serious about salvage, field recovery, and keeping damaged machines moving.
- Salvage is now a major profit engine, and Sharpe intends to invest in the bottleneck by expanding BattleMech Recovery Vehicle capacity rather than relying on battlefield luck.
- Tech depth is a strength: MekHQ reports 11 MekTechs, 10 astechs, 5 mechanics, and 3 AeroTeks, giving the company a strong support base if salvageable units can be recovered.
- The MASH truck and mobile canteen point to a company trying to care for its people, not just win fights.
- The rifle platoon is now landed and API-deployable, but still needs RPG-side organization and command intent before it is treated as a useful field element.
- Infantry reinforcement assessment: MekHQ reports 42 active Soldier-role personnel with no fatigue or hits and no unit assignment exposed in the API snapshot. Sharpe's command assessment is that there are enough unassigned soldiers to rebuild or reinforce the crippled rifle platoon, pending MekHQ-supported assignment/reconstitution workflow or manual confirmation of infantry organization rules.

## Pending Asset Questions

- User reports a Warhammer was salvaged after the latest battle, but the 3026-06-21 live API capture does not expose it as a unit, repair item, or other state field. Need user/MekHQ UI confirmation of where it landed or whether it still needs manual salvage application.
- Confirm exact landed staging area and which assets are physically unloaded versus merely available in MekHQ.
- What is the name/type/operator of the contracted transport carrying Sharpe's Strikers?
- Confirm whether any manual MekHQ crew, force, or scenario assignment work is needed before tactical deployment.
- Confirm whether the under-repair flag on deployed Catapult, Griffin, and Riever reflects repair carryover, maintenance state, or a display/API nuance.
- Confirm what happened to the Stingray F-90 between Talitha and the current Altorra snapshot.
- What MekHQ action or manual workflow turns unassigned Soldier-role personnel into a reinforced Foot Platoon (Rifle)?

## Long-Term Asset Goals

### Company-Owned DropShip

- Goal slug: company-owned-dropship
- Desired asset: Union-class DropShip or equivalent company transport; prior RPG opportunity was a Mule-class DropShip.
- Current status: abandoned as an active company goal for this vessel. MekHQ confirms `Mule (2737)` has been removed from the unit roster after maintenance costs threatened the company's solvency.
- Character note: Sharpe wants Sharpe's Strikers to stop depending on contracted lift. A Leopard would already be too tight for the company he is building. The Mule proved that a hull without sustainable support can be a liability instead of independence.
- Custody evidence: Capellan liaison agreed in-scene to provisional military custody pending inspection, lock/cargo control, no inherited debt without explicit agreement, and one more clean contract action.
- Transfer condition status: completed. The April 16 `Intercept Engagement` is a Victory with both exposed objectives completed.
- Operating rights: granted by Sang-wei Qiao Ren after Sharpe's Leadership check succeeded exactly. Strikers may crew, inspect, maintain, secure, and reposition `Carried Interest` for Altorra theater contract support under provisional Capellan military custody.
- MekHQ hard ledger update: user manually added the ship earlier, then disposed of it. Live API on 3027-03-23 reports `Mule (2737) has been removed from the unit roster.` No Mule appears in the current unit list, and no mothballed units are exposed.
- Restrictions: no active restrictions remain on the Strikers in MekHQ because the Mule is no longer on the roster. Any lingering title/legal dispute is now a Capellan or Altorra-port issue unless it returns in play.
- Remaining RPG-side transfer issues: none active for the Strikers after the hard roster removal; keep missing-module and title-dispute facts as historical hooks only.
- Constraint: exact DropShip economics, crew payroll, operating costs, and title law remain outside the current AToW summary; use table ruling and MekHQ hard state for future transport acquisitions.
- Near-term implication: this specific DropShip is no longer a Strikers asset. The long-term transport goal survives, but the company has hard proof that taking a DropShip without support can wreck the ledger.

### Mule-Class DropShip Carried Interest

- Asset slug: mule-carried-interest
- Category: DropShip / transport asset
- Status: removed from MekHQ unit roster after maintenance costs threatened bankruptcy.
- Evidence summary: RPG-side AToW scene on 3026-05-01. Qiao Ren refused immediate up-front title after Sharpe's failed Strategy push, then granted operating rights after Sharpe's Leadership check succeeded exactly. Live API on 3027-03-13 confirmed the hard unit was Mothballed; live API on 3027-03-23 confirms `Mule (2737)` has been removed from the unit roster.
- Controller/owner claim: no longer controlled by Sharpe's Strikers in MekHQ.
- Ownership evidence: acquisition report confirms roster removal; prior provisional custody is historical context only.
- Location: last known Altorra secondary pad; no current Strikers roster location.
- Condition/readiness: no longer a Strikers unit in the live MekHQ roster.
- Known defects or concerns: missing component/control module from a secondary control trunk near the cargo lift; possible tampering, hidden registry/lockout, cargo-control, or comms issue.
- Financial concern: user confirms the Mule's maintenance bills were heavy enough to threaten bankruptcy before mothballing. Exact per-unit cost history is not exposed by the live API.
- Disposition decision: resolved in MekHQ. The ship was removed from the Strikers' unit roster, and the associated DropShip crew were removed from the personnel roster.

### DropShip Raid Coordinate Sale

- Asset slug: dropship-raid-coordinate-sale
- Category: cash / intelligence sale
- Status: table-confirmed; current balance confirmed by MekHQ.
- Evidence summary: user reports the Strikers sold coordinates of the damaged enemy Condor DropShip after the 3027-03-22 `DropShip Raid` for 5,000,000 C-bills. Live API confirms current funds of 7,721,469 C-bills, but the finance endpoint only exposes the last five transactions and does not show this sale line in the current capture.
- Related mission: `DropShip Raid`, MekHQ scenario id `21`, Victory.
- Notes: MekHQ scenario data identifies the enemy target as `Dionysus's Starfire Vikings DropShip`, 1 unit, 1,978 BV. The captured scenario object does not expose the exact DropShip chassis; `Condor` is user/table report unless later confirmed by MekHQ or MegaMek records.
- MekHQ reference: `mekhq-live-api-capture/mekhq-state.json`, scenario id `21`, finance balance on 3027-03-23.
- Follow-up: if a broader transaction export becomes available, verify the exact 5,000,000 C-bill sale line and description.

### BattleMech Expansion Loop

- Goal slug: battlemech-expansion-loop
- Desired asset: Additional salvageable or purchasable BattleMechs.
- Current status: Strategic priority.
- Character note: Sharpe sees the path clearly: survive early contracts, recover or buy more machines, use the tech base to repair them, field more of the 13 available MekWarriors, qualify for bigger contracts, build cash reserves, and eventually buy the company-owned DropShip.
- Constraint: Salvage rights on the Talitha contract are only 20% and exchange-based, so the company may need exceptional battlefield opportunities, careful negotiation, or future contracts with better salvage terms.
- Near-term implication: Prioritize intelligence, battlefield recovery, and tech readiness whenever a scenario creates salvageable enemy machines.

### Pending Warhammer Salvage

- Goal slug: pending-warhammer-salvage
- Desired asset: Warhammer BattleMech.
- Current status: confirmed in MekHQ as `Warhammer WHM-6R`; additional `Warhammer WHM-6R #2` also present.
- Evidence summary: live API on 3027-03-23 confirms `Warhammer WHM-6R`, 70-ton Mek, status Heavy Damage, and `Warhammer WHM-6R #2`, status Inoperable.
- MekHQ status: `Warhammer WHM-6R` is available, present, serviceable, deployable, not deployed, crewed by Sepi Haukedal, with 9 service items and no parts needed. `Warhammer WHM-6R #2` is available/present/serviceable but not deployable because it is not functional, with 8 service items and no pilot.
- Negotiated correction: Sharpe quickly contacted the Capellan liaison and arranged to return the 1,362,625 C-bill `Unit sales for AirBase - Allied - Evacuate` payout in exchange for the crippled Warhammer being released to Sharpe's Strikers.
- Confirmed funds effect: 3026-06-21 transaction, `Miscellaneous`, -1,362,625 C-bills, `undo sell warhammer`.
- Current action: assign pilot/tech and manage repairs/parts before treating it as combat power.
- API gap note: earlier actual salvage-result inventory was not exposed until the user manually reversed/applied the unit; see `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`.
