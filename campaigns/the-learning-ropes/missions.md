# Missions

MekHQ owns accepted contract ledger status, deadlines, scenario generation, payment, salvage, and tactical outcomes. MEK-RPG owns player-facing stakes, briefings, relationships, promises, and pending choices.

## Active Mission

Mission name: 3025 - FWL - Castrovia Objective Raid

Status: Active contract verified from MekHQ live API reread at `2026-06-23T16:35:50.765201Z`; pending item `mekhq-pending-2026-06-23-001` resolved after manual MekHQ acceptance and live verification.

Objective: Travel to Astrokaszy for a Free Worlds League House-command objective raid; brief the company on verified mission terms, opposition uncertainty, travel expectations, and command-risk safeguards.

Employer: Free Worlds League

Target system: Astrokaszy

Contract type: Objective Raid

Start date: 3025-08-28

End date: 3025-11-28

Travel estimate: Arrived at Astrokaszy as of MekHQ live API reread on 3025-08-28. Contract still reports `17` travel days in the contract object; treat that field as MekHQ-owned and inspect MekHQ UI if exact route bookkeeping matters.

Command rights: House

Support: 100% straight support; current report says the contract will begin with 0 Support Points due to Administration skill handling.

Salvage: 100%

Payment notes: advance `5,068,562 C-Bill`; monthly payout `5,068,562 C-Bill`; transport amount `16,272,182 C-Bill`; estimated total profit `7,735,474 C-Bill` after acceptance per MekHQ live API.

Known risks: enemy unknown; House command rights may constrain tactical discretion; long transit can conceal employer ambiguity until the unit is already committed.

Tactical handoff trigger: Switch to MekHQ/MegaMek/Classic BattleTech when exact unit combat, scenario outcome, damage, salvage, casualties, or scenario status matters.

## Imported Scenarios

- Scenario id `1`, `Frontier Assassination`, is linked to the active contract in MekHQ live API.
- Status: Pending.
- Scenario gist: eliminate an enemy VIP and destroy at least half of the escort force; enemy extraction or reinforcements are possible concerns.
- Map/conditions exposed by live API: ground map, `Light-craters`; daylight; clear weather; calm wind; standard atmosphere; 25 C; 1.0 gravity; no EMI; no fog.
- Current force/opposition details: not exposed in the live API response; tactical details remain MekHQ-owned until inspected or generated in MekHQ/MegaMek.
- Command notice: Double-M intends Majlinda Yusuf in the Flea FLE-4 and Jannat Karaganilla in the Locust LCT-1E to deploy in the first wave when this scenario becomes tactically actionable. This is MEK-RPG command intent only until assigned and launched in MekHQ/MegaMek.
- 3025-08-28 refresh: scenario remains pending; force/opposition/objective arrays are still not exposed by the live API. Tactical setup must be inspected or launched in MekHQ/MegaMek.
- 3025-08-29 refresh: scenario remains pending and force/opposition/objective arrays are still not exposed by the live API. Current report says Admin/Transport created 1 additional Support Point, but failure to meet contract requirements caused loss of a CVP. Inspect MekHQ UI for the missed requirement before further day advancement.
- 3025-08-30 pre-battle refresh: scenario force details exposed. `Frontier Assassination` was scenario id `1`, pending on `3025-08-30`, with 4 player units, 3 bot forces, and 2 objectives; map `RuralHomesteadsHotDesert`; dusk/dawn, clear, calm.
- 3025-08-30 post-battle refresh: `Frontier Assassination` status `Victory`. Objectives completed: destroy target force, and destroy/rout 50% of target forces. Total visible scenario award: 2 Scenario Victory Points.
- Deployed for scenario id `1`: Grasshopper GHR-5H, Stalker STK-4P, Stalker STK-4P #2, Crusader CRD-3R.
- Deployed for scenario id `2`: Griffin GRF-1N, Centurion CN9-A, Flea FLE-4, Crab CRB-20, Trebuchet TBT-5N.
- `TankBase - Hostile - Capture` remains pending as scenario id `2`, dated `3025-09-02`, with 5 player units, 4 bot forces, and 4 objectives; map `35x35 White Drift`; daylight, clear, calm.
- 3025-09-02 post-battle refresh: `TankBase - Hostile - Capture` status `Victory`. Completed defender-routing objective and control objective; failed intact-capture objective. MekHQ report says the facility will be destroyed but allied forces will control it.
- New pending scenario: `Decoy Engagement`, scenario id `3`, dated `3025-09-03`, with 4 player units, 1 bot force, and 2 objectives.
- 3025-09-06 post-Decoy refresh: `Decoy Engagement`, scenario id `3`, status `Victory`. Both visible objectives completed: engage the Independent OpFor for the required duration, and destroy/rout 75% of Independent OpFor. Total visible award: 4 Scenario Victory Points.
- Decoy force recorded from live API: Grasshopper GHR-5H, Stalker STK-4P, Stalker STK-4P #2, and Crusader CRD-3R. As of the 3025-09-06 refresh these units still show deployed to scenario id `4`; treat that as MekHQ-owned scenario bookkeeping until inspected in MekHQ.
- New current battle report: `Irregular Force Suppression` is today, 3025-09-06; deploy a formation from the TOE.
- 3025-09-14 refresh: `Irregular Force Suppression`, scenario id `4`, status `Victory`. Visible objective completed: destroy, cripple, or force the withdrawal of 50% of Independent Infantry and Independent Irregulars. Total visible award: 1 Scenario Victory Point.
- New pending scenario: `VIP Ambush`, scenario id `5`, dated `3025-09-16`, with 1 player force, 3 bot forces, and a visible objective to destroy the Independent VIP force for 1 Scenario Victory Point.
- New pending scenario: `Diversion Engagement`, scenario id `6`, dated `3025-09-16`, with 1 player force, 1 bot force, and visible objectives to reach the north edge with 50% of Mek Lance I (combat), and destroy/rout 75% of Independent OpFor. Total visible stakes: +4 SVP on full success, with failure penalties exposed in MekHQ.
- 3025-09-14 battle report says `VIP Ambush` reinforcement succeeded on roll 3 vs. 3.
- Note: the earlier MEK-RPG command intent placed Yusuf/Flea and Jannat/Locust in the first wave. Current MekHQ deployment does not match that intent for `Frontier Assassination`: Yusuf/Flea is deployed to scenario `2`, and Jannat/Locust is not deployed.
- 3025-09-28 live refresh: `Official Challenge`, scenario id `7`, status `Victory`. Visible objective completed: destroy or rout 95% of the opposing Independent Officer force, awarding 1 Scenario Victory Point. The cost was severe: Silas Trinh is Killed in Action after the user reported a Stinger headshot; Stinger STG-3R is inoperable/crippled; the company Grasshopper was destroyed/cored according to user tactical report; enemy-origin Grasshopper salvage entered the roster after a lucky headshot; the unit also got lucky against an enemy Warhammer, and live roster now shows additional Warhammer salvage/inoperable entries; Stalker STK-4P is moderate damage; Julietta Maitre and Nathan Lumsden have non-permanent injuries. New pending scenario remains `Isolated DropShip Defense`, scenario id `8`, dated 3025-09-30.

## Completed Missions

- None recorded in MEK-RPG yet.
