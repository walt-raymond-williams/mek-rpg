# Missions

MekHQ owns accepted contract ledger status, deadlines, scenario generation, payment, salvage, and tactical outcomes. MEK-RPG owns player-facing stakes, briefings, relationships, promises, and pending choices.

## Active Mission

Mission name: 3034 - CC - Lesalles Recon Raid

Status: Active MekHQ contract.

Description: Sharpe's Strikers are on a Capellan Confederation Recon Raid at Lesalles. The contract is active in the 3034-07-02 live API snapshot with two months remaining.

Date/location: 3034-07-02 at Lesalles (Confirmed from MekHQ live API; live context only).

Employer: Capellan Confederation.

Terms: Liaison command rights; 40% salvage; 100% straight support; monthly payout 6,954,019 C-Bill; support amount 2,255,869 C-Bill; transport amount 0 C-Bill because the Strikers are carrying themselves.

Player-facing stakes: the unit has been heavily downsized and must maintain enough active combat strength to satisfy contract obligations while protecting its new transport base, retaining turnover reserve, and avoiding another unsustainable expansion.

Active-force requirement: table/MekHQ UI report is a minimum of ten active combat units. The live API does not expose this requirement as a structured field.

Current combat posture: Alpha Company has fourteen deployable combat units in the live API snapshot, plus the retained jump infantry security element. Frontline Lance is currently committed to pending scenario `169`, `Frontline Disruption`; Command Lance remains a ready working combat lance and is expected to deploy regularly because the contract footprint leaves only a modest margin above the user's reported minimum requirement.

Pending scenarios exposed by the live API:

- `164` Facility Assault: pending, no assigned player force exposed.
- `166` Recon Evasion: pending, no assigned player force exposed.
- `167` Recon Evasion: pending, no assigned player force exposed.
- `169` Frontline Disruption: pending on 3034-07-02 with Frontline Lance assigned.

Command doctrine: use strong units. Do not preserve elite machines by leaving them idle; preserve them through maintenance discipline, pilot rotation, tactical support, and transport-first expansion planning.

## Active Transport Arc

Mission name: The Jade Passage

Status: Standing MEK-RPG transport and political arc supporting the current MekHQ contract.

Description: Long Transit Association has brought the Merchant-class JumpShip `Jade Passage` and Monarch-class DropShip `Celestial Garden` under pressure from a regional Capellan noble, hostile creditors, and customs officials. The cooperative wants a permanent charter with Sharpe's Strikers that gives the unit long-range mobility and a civilian home, while preserving cooperative ownership and shipboard authority.

Known constraints: the cooperative keeps its captains, crews, internal ship operations, family ownership shares, and refusal rights for piracy, smuggling, or suicidal missions.

Confirmed user setup: current movement cost zero separate transport C-bills; the real burden is maintaining the JumpShip, two DropShips, and two Small Craft after major layoffs and asset sales.

First arc missions:

- Recover the Records: find the cooperative's original financial archive and prove part of the debt was fabricated.
- Escort the Witness: move a former port official safely aboard `Celestial Garden` while preserving civilian cover.
- Rival Claimant: stop a hired mercenary seizure without destroying the `Jade Passage`, jump sails, docking collars, or crews.
- Tribunal: use the Strikers' Capellan reputation to validate the charter and invalidate the seizure.

## Live API Historical Contract Snapshot

The live API state includes completed or historical contracts. Entries below are imported ledger history/context, not the current active mission.

### 3025 - CC - Talitha Recon Raid

- Status: Success (Confirmed from MekHQ live API; live context only)
- Description: Unknown
- Dates: start `3025-03-09`, end `3025-06-09`, months left `-88`, travel days `68`.
- Stakes: employer `Capellan Confederation`, enemy `Unknown`, system `Talitha`.
- Terms: advance pct: 25; advance amount: 1,632,756 C-Bill; monthly payout: 1,632,757 C-Bill; transport comp: 100%; command rights: Liaison; salvage pct: 20%; straight support: 80%.
- Payment summary: total amount: 6,874,764 C-Bill; monthly payout: 1,632,757 C-Bill; advance amount: 1,632,756 C-Bill; estimated total profit: -6,729,620 C-Bill.
- Salvage/rental summary: salvage pct label: 20%; battle loss comp: 0%; rentals hospital beds: 0; kitchens: 1; holding cells: 0.

## Imported Scenarios

- `1` Facility Assault: status Defeat, date 3025-05-13, type HOSTILE_FACILITY, map board type: Ground; map: 35x35 Castle Hill; map size x: 35; map size y: 35.
- `2` VIP Ambush: status Refused Engagement, date 3025-06-02, type NONE, map board type: Ground; map: CityHotDesert; map size x: 0; map size y: 0.
- `3` Picket Line Breakthrough: status Victory, date 3025-03-11, type NONE, map board type: Ground; map: 32x17 (CSV) Kozice Ranch Station; map size x: 32; map size y: 17.
- `4` Deep Raid Defense: status Refused Engagement, date 3025-03-29, type NONE, map board type: Ground; map: HillsHotDesert; map size x: 32; map size y: 34.
- `5` Decoy Engagement: status Victory, date 3025-04-12, type NONE, map board type: Ground; map: 35x35 Hyner 2750; map size x: 35; map size y: 35.
- `6` Official Challenge: status Defeat, date 3025-04-19, type OFFICIAL_CHALLENGE, map board type: Ground; map: Savannah; map size x: 32; map size y: 34.
- `7` Recon Evasion: status Victory, date 3025-05-15, type NONE, map board type: Ground; map: RuralHomesteadsHotDesert; map size x: 32; map size y: 34.
- `8` Frontline Disruption: status Victory, date 3025-05-20, type NONE, map board type: Ground; map: River-wetlands; map size x: 32; map size y: 34.
- `9` DropShip Raid: status Victory, date 3026-03-20, type NONE, map board type: Ground; map: 32x34 DesertCity1 NE; map size x: 32; map size y: 34.
- `10` Critical Convoy Escort: status Victory, date 3026-03-25, type CONVOY, map board type: Ground; map: CityHotJungle; map size x: 80; map size y: 34.
- `11` Frontline Breakthrough: status Victory, date 3026-04-07, type NONE, map board type: Ground; map: SeaHotJungle; map size x: 32; map size y: 34.
- `12` Critical Convoy Escort: status Victory, date 3026-04-09, type CONVOY, map board type: Ground; map: 32x34 DesertCity1 SE; map size x: 32; map size y: 34.
- `13` Intercept Engagement: status Victory, date 3026-04-16, type NONE, map board type: Ground; map: Savannah; map size x: 32; map size y: 34.
- `14` Convoy Raid: status Victory, date 3026-06-06, type CONVOY, map board type: Ground; map: Light-craters; map size x: 64; map size y: 34.
- `15` Annihilation: status Victory, date 3026-06-13, type NONE, map board type: Ground; map: Hills-RiverRoad; map size x: 32; map size y: 34.
- `16` AirBase - Allied - Evacuate: status Victory, date 3026-06-19, type NONE, map board type: Ground; map: CityHotJungle; map size x: 32; map size y: 34.
- `17` Frontline Disruption: status Victory, date 3026-08-30, type NONE, map board type: Ground; map: Mountain-high; map size x: 32; map size y: 34.
- `18` Frontier Assassination: status Victory, date 3026-10-18, type NONE, map board type: Ground; map: Hills-RiverRoad; map size x: 32; map size y: 34.
- `19` Irregular Force Assault: status Victory, date 3026-12-18, type NONE, map board type: Ground; map: CityHotDesert; map size x: 48; map size y: 34.
- `20` Heavy Recon Evasion: status Victory, date 3027-03-13, type NONE, map board type: Ground; map: SeaHotJungle; map size x: 32; map size y: 34.

## Completed Missions

- None recorded in MEK-RPG yet.
