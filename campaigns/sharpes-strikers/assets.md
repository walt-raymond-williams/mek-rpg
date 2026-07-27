# Assets

MekHQ owns exact ledger values, unit condition, repairs, cargo, and market state. MEK-RPG may add narrative overlays, pending actions, and tactical handoff notes without changing the hard ledger.

## Finances

- Funds: 280,863,298 C-Bill (Confirmed from MekHQ live API capture at `2026-07-26T19:41:30Z`; live context only)
- Active loans: false
- Loan balance: 0 C-Bill
- Loan defaults: 0
- Finance warnings: Unknown
- Transport expense note: Confirmed by user for the current setup: Sharpe's Strikers has zero separate transport fee. The continuing price is maintaining the `Jade Passage` JumpShip, `Celestial Garden`, the Union, and associated Small Craft. Exact MekHQ finance entries remain MekHQ-owned.
- Planned `Vermilion Gate` lien model: Confirmed by user as campaign fiction, not MekHQ ledger fact. The sister Merchant-class JumpShip is tied to a claimed `900,000,000 C-Bill` lien, reduced by `10,000,000 C-Bill` per qualifying Capellan contract completed after conditional release under the proposed retainer. See `jade-passage-expansion.md`.

## Narrative Transport Charter Assets

These assets are MEK-RPG narrative/relationship state unless and until MekHQ represents them as hard ledger assets.

### Jade Passage

- Class: Merchant-class JumpShip
- Owner/operator: Long Transit Association, a small civilian transport cooperative.
- Role: Strategic transport, command hub, and commercial carrier.
- Status: Arrived at the Capella jump point carrying `Celestial Garden`; requesting protected status through Sharpe's Strikers.
- Docking collars: Two. Provisional charter use is one collar for the Strikers' Union and one for `Celestial Garden`.
- Small Craft bays: Two. Current intended/verified complement is one `Ares Assault Craft Mark VII` freight/landing craft and one `Dragonstar Passenger Transport` infantry/passenger/security craft.
- Authority boundary: Captain Damiane Meyer retains shipboard authority. The cooperative retains ownership shares and the right to refuse piracy, smuggling, or suicidal operations.
- Cost pressure: No separate transport fee for this move, but the Strikers inherit maintenance, escort, and protection obligations if the charter stands.
- Risks: Capellan customs impoundment order, creditor seizure, regional noble pressure, fragile legal protection, and expensive deferred maintenance.

### Celestial Garden

- Class: Monarch-class DropShip
- Owner/operator: Long Transit Association.
- Role: Passenger transport, mobile headquarters, family housing, administration, and civilian revenue source.
- Status: Docked to `Jade Passage`; available as the proposed community and headquarters ship under permanent charter.
- Internal spaces: Command offices, family quarters, classrooms, medical rooms, dining halls, recreation spaces, storage/workshop areas, temporary guest cabins, and commercial passenger sections.
- Authority boundary: Captain Nadežda Dunajski retains shipboard authority and protects the civilian character of the vessel.
- Risks: Civilian passenger safety, military encroachment on passenger life, spies, refugees, shortages, disease, and port politics.

### Strikers Union DropShip

- Class: Union-class DropShip
- Role: Military transport and BattleMech bay ship.
- Transport relationship: Intended to use one `Jade Passage` docking collar under the charter arrangement.
- MekHQ boundary: Exact ledger representation, cargo, unit loading, and hard transport capacity remain MekHQ-owned unless the live API exposes them.

### Vermilion Gate

- Class: Merchant-class JumpShip.
- Owner/operator: Long Transit Association.
- Role: Planned sister-ship recovery and long-term strategic transport expansion for the Strikers' battalion rebuild.
- Status: Proposed future narrative asset; trapped under lien, impound, or creditor control until established in play. GM/planning knowledge until revealed to Sharpe.
- Docking collars: Two. Preferred planning posture after release is one collar for a Strikers Mule and one open flexible collar.
- Debt/lien: Claimed `900,000,000 C-Bill` lien; intended narrative retainer credit is `10,000,000 C-Bill` per qualifying Capellan contract completed after conditional release. Fraud evidence, tribunal results, or Capellan political credit may reduce the real payoff burden.
- Authority boundary: Long Transit retains civilian ownership identity, crew, captain, and refusal rights. Sharpe's Strikers seeks long-term military charter rights, not seizure.
- MekHQ boundary: Not a hard ledger asset until represented or confirmed in MekHQ. Exact condition, transport assignments, maintenance costs, and cargo capacity remain MekHQ-owned or pending play confirmation.

### Planned Mule

- Class: Mule-class DropShip.
- Owner/operator: Intended Sharpe's Strikers MekHQ purchase or acquisition.
- Role: Strategic cargo lift for mothballed BattleMechs during interstellar transit, parts, armor, ammo, salvage, and rebuilding toward battalion scale.
- Transport relationship: Intended first regular DropShip attached to `Vermilion Gate` after conditional release. Until then, it may require commercial collar fees or temporary lift if acquired early.
- Doctrine note: The Mule is strategic lift, not permanent inactive storage. The player intent is to unmothball carried BattleMechs after arrival and operate the full battalion once the deployment window permits.
- MekHQ boundary: Purchase, price, cargo assignment, mothballing behavior, personnel movement, and transport capacity must be handled and verified in MekHQ.

## Latest Live API Roster Summary

Snapshot: MekHQ live API capture at `2026-07-26T19:41:30Z`; campaign date `3034-12-06`; location `Altorra`.

- Total units: 62.
- Personnel: 461.
- Active contract: `3034 - CC - Altorra Objective Raid`, employer `Capellan Confederation`, end date `3034-12-26`.
- Unit type counts: 28 Mek, 15 Tank, 7 Aerospace Fighter, 6 Conventional Fighter, 2 Dropship, 2 Small Craft, 1 Jumpship, 1 Infantry.
- Deployability headline: 40 deployable units; 0 damaged units; repair pressure lists 1 unit needing parts/service attention and 0 units under repair.
- Inbound rebuild pipeline remaining: 22 units are `In transit`, all currently uncrewed and blocked from deployment by missing pilots/crew until assigned.
- Pending scenario commitment: `Breakthrough` on 3034-12-06 has `Warhammer WHM-6R`, `Warhammer WHM-6R #2`, `Warhammer WHM-6R #3`, `Awesome AWS-8Q`, `Mechbuster #2`, and `Mechbuster #3` assigned.

### Battalion TO&E Review

TO&E source boundary: MekHQ `/campaign/commands` command-readiness selectors expose the current force tree, formation IDs, unit memberships, and unit formation names for planning. Mutating TO&E endpoints are still blocked/not implemented, so MEK-RPG can read the structure but cannot safely change it through the API.

- Battalion HQ / HQ section: command, admin, medical, transport, recovery, and ship-support functions. On-hand support assets include `Union (2708)`, `Monarch (2759)`, `Merchant JumpShip (2503)`, `Ares Assault Craft Mark VII`, `Dragonstar Passenger Transport`, `Jump Platoon (Laser)`, mobile canteen, MASH truck, four flatbeds, and other support vehicles.
- `3rd Expeditionary Force`: battalion combat parent, containing `Alpha Company`, `Bravo Company`, and `Charlie Company`.
- Alpha Company: `Command Lance`, `Frontline Lance`, and `Auxilary Lance`. Earlier doctrine keeps Command Lance as a working combat lance, not a glass-case reserve.
- Bravo Company: `Strike Lance` and `Patrol Lance`, plus two deployed Mechbusters attached at company level. A third Mek lance is pending future BattleMech deliveries.
- Charlie Company: `LAM/ASF Force`, `ASF 1`, and `Mechbuster CAS`. This is the LAM/aerospace/conventional-fighter arm and the natural home for future aerospace expansion.

### Current Force Tree

- `Headquarters`
  - `Commissary`: `Sherpa Armored Truck (Mobile Canteen)`.
  - `Medical`: `MASH Truck (Small)`.
  - `Security`: `Jump Platoon (Laser)`.
  - `Recovery Operations`: no units currently assigned.
  - `Logistics`: four `Flatbed Truck` units.
  - `Space Transport`: `Union (2708)`, `Monarch (2759)`, `Merchant JumpShip (2503)`, `Ares Assault Craft Mark VII`, `Dragonstar Passenger Transport`.
- `3rd Expeditionary Force`
  - `Alpha Company`
    - `Command Lance`: `Awesome AWS-8Q`, `Warhammer WHM-6R`, `Warhammer WHM-6R #2`, `Warhammer WHM-6R #3`; deployed to `Breakthrough`.
    - `Frontline Lance`: `Stalker STK-3F`, `Stalker STK-3F #2`, `Grasshopper GHR-5H`, `Grasshopper GHR-5H #2`.
    - `Auxilary Lance`: `BattleMaster BLR-1G`, `BattleMaster BLR-1G #2`, `Flashman FLS-7K`, `Catapult CPLT-C1`.
  - `Bravo Company`
    - Company-level attachments: `Mechbuster #2`, `Mechbuster #3`; both deployed to `Breakthrough`.
    - `Strike Lance`: `Atlas AS7-D`, `Thunderbolt TDR-5S`, `Champion CHP-2N`, `Exterminator EXT-4A #2`.
    - `Patrol Lance`: `Exterminator EXT-4A`, `Stinger STG-3R`, `Locust LCT-1V`, `Shadow Hawk SHD-2H`, `Phoenix Hawk PXH-1`.
  - `Charlie Company`
    - `LAM/ASF Force`: `Phoenix Hawk LAM PHX-HK2`, `Phoenix Hawk LAM PHX-HK2 #2`.
    - `ASF 1`: `Riever F-100`, `Riever F-100 #2`.
    - `Mechbuster CAS`: `Mechbuster #4`.
- `RESERVE`: no units currently assigned.

### On-Hand Combat Roster

- BattleMechs: `Catapult CPLT-C1`, `Grasshopper GHR-5H`, `Grasshopper GHR-5H #2`, `Warhammer WHM-6R`, `Warhammer WHM-6R #2`, `Warhammer WHM-6R #3`, `Stalker STK-3F`, `Stalker STK-3F #2`, `BattleMaster BLR-1G`, `BattleMaster BLR-1G #2`, `Flashman FLS-7K`, `Awesome AWS-8Q`, `Stinger STG-3R`, `Champion CHP-2N`, `Phoenix Hawk LAM PHX-HK2`, `Phoenix Hawk LAM PHX-HK2 #2`, `Atlas AS7-D`, `Thunderbolt TDR-5S`, `Locust LCT-1V`, `Shadow Hawk SHD-2H`, `Phoenix Hawk PXH-1`, `Exterminator EXT-4A`, `Exterminator EXT-4A #2`.
- Aerospace fighters: `Riever F-100`, `Riever F-100 #2`.
- Conventional fighters: `Mechbuster #2`, `Mechbuster #3`, `Mechbuster #4`.

### Inbound Unit Waves

- 3034-12-15: `Thrush TR-7`, `Lightning LTN-G15`, `Wolverine WVR-6M`, `Wasp WSP-1A`.
- 3034-12-29: `BattleMech Recovery Vehicle #4`, `Mechbuster #5`, `Mechbuster #6`.
- 3035-01-01: `BattleMech Recovery Vehicle`, `BattleMech Recovery Vehicle #2`, `BattleMech Recovery Vehicle #3`, `Stinger STG-3R #2`.
- 3035-01-15: `Mechbuster`.
- 3035-01-29: `Locust LCT-1V #2`, `Apocalypse World Rover`, `Ballista Self-Propelled Artillery Tank`, `BattleMech Recovery Vehicle #6`.
- 3035-02-01: `Transgressor TR-13`.
- 3035-03-01: `BattleMech Recovery Vehicle #5`, `Manticore Heavy Tank`.
- 3035-03-06: `Grasshopper GHR-5H #3`.
- 3035-03-29: `Eagle EGL-R6`, `Riever F-100 #3`.

### Delivery Allocation Plan

- Bravo Company third lance: build as a patrol/scout lance from incoming light/scout BattleMechs, with likely candidates including `Wasp WSP-1A`, `Stinger STG-3R #2`, `Locust LCT-1V #2`, and other appropriate arrivals once MekHQ confirms delivery and pilot assignment.
- Bravo reserve or heavier fill: `Wolverine WVR-6M` and `Grasshopper GHR-5H #3` are stronger candidates for Bravo depth, reserve rotation, or a heavier patrol/response mix depending on pilot availability and maintenance load.
- Charlie Company expansion: after `Breakthrough`, move `Mechbuster #2` and `Mechbuster #3` out of their Bravo company-level attachment and into Charlie with `Mechbuster #4`. Incoming `Thrush TR-7`, `Lightning LTN-G15`, `Transgressor TR-13`, `Eagle EGL-R6`, `Riever F-100 #3`, `Mechbuster`, `Mechbuster #5`, and `Mechbuster #6` should round out Charlie as the aerospace/conventional-fighter arm.
- Recovery and vehicle support: incoming BattleMech Recovery Vehicles, `Ballista Self-Propelled Artillery Tank`, `Manticore Heavy Tank`, and `Apocalypse World Rover` create vehicle crew and mechanic demand before they create useful operational capability.
- Mule purchase: priority strategic acquisition once a cheap enough Mule appears. The battalion rebuild is expected to outgrow current cargo and transport margin without it.

### Future Training Battalion Concept

- Timing: future-only, after current deliveries, Mule acquisition, and hiring recovery are complete.
- Purpose: create a second battalion as a training/replacement command with three training companies.
- Equipment model: mostly light BattleMechs, possibly with some mediums. As Bravo pilots advance into heavier machines, cascade older light/scout machines into the training battalion.
- Operational model: use a Great House-style cadre/cadet system. Training units deploy with an experienced formation that provides the main combat power and recovery margin.
- Training roles: patrol, route security, contract footprint, scouting, pursuit of fast-moving targets, screening, reinforcement, objective presence, and opportunistic support. Do not use training units for suicide rushes or unsupported assaults.
- Risk posture: losing a fragile light machine such as a Wasp or Stinger is an accepted possibility in combat, but the command goal is controlled risk, not wasted people or machines.
- Boundary: not a MekHQ hard ledger change until units, pilots, commanders, formation entries, transport space, and support staff are created or assigned in MekHQ.

### Hiring Hall Priorities

- MekTechs: hire at least a couple more immediately, then reassess after deliveries. Live API shows 25 MekTechs and 36 Astechs against a growing BattleMech roster.
- Vehicle crews: hire ahead of the recovery vehicle and heavy vehicle arrivals, especially for large combat/support vehicles.
- Aerospace and conventional aircraft personnel: Charlie's expansion needs additional Aerospace Pilots, Conventional Aircraft Crew, AeroTeks, and mechanics as fighters arrive.
- Support staff: preserve enough admin/logistics depth to keep the battalion structure from becoming another oversized, under-supported force.

### Phoenix Hawk LAMs

- `Phoenix Hawk LAM PHX-HK2`: on hand, undamaged, crewed, deployable.
- `Phoenix Hawk LAM PHX-HK2 #2`: on hand, undamaged, crewed, deployable.
- Narrative overlay: user established that the LAM deal came through unusually favorably, with the seller seeking out the Strikers. Treat possible CCAF satisfaction or quiet Capellan sponsorship as a staff-level concern and opportunity, not a confirmed MekHQ ledger fact.

## Cooperative Loyalty

- Rating: 1 / 5, cautious provisional trust.
- Increases when Sharpe's Strikers protect the ships, pay agreed operating costs, respect captains' authority, rescue civilians, invest in repairs, and honor the charter.
- Decreases when the Strikers expose the ships to unnecessary danger, ignore maintenance, seize civilian cargo, use `Celestial Garden` like a frontline combat vessel, interfere with shipboard authority, or abandon cooperative personnel.

## Earlier Expanded Live API Unit Snapshot

The expanded unit entries below were generated from an earlier `2026-07-24T20:03:46Z` capture and are stale for total roster counts, current location, finances, and in-transit purchases. Use the latest live API roster summary above, or the current `mekhq-live-api-capture/` JSON files, for current MekHQ-owned facts.

### Catapult CPLT-C1

- MekHQ unit id: `4d3c4e0c-7eee-4352-b026-13bf843eebeb`
- Type: Mek
- Chassis/model/weight: Catapult / CPLT-C1 / 65.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: d834f7d9-579d-4139-b497-10f0c14222de
- Commander/maintenance: commander `d834f7d9-579d-4139-b497-10f0c14222de`, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: assigned `Unknown`, carried units `Unknown`
- Legal status: Unknown unless established by MekHQ or play.
- Narrative overlay: Sparse/TBD
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.

### Sherpa Armored Truck (Mobile Canteen)

- MekHQ unit id: `e0187a2c-6bfd-4f72-aa31-814232e2d81a`
- Type: Tank
- Chassis/model/weight: Sherpa Armored Truck / (Mobile Canteen) / 35.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: Unknown
- Commander/maintenance: commander `Unknown`, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: assigned `Unknown`, carried units `Unknown`
- Legal status: Unknown unless established by MekHQ or play.
- Narrative overlay: Sparse/TBD
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.

### MASH Truck (Small)

- MekHQ unit id: `1b60147c-14ed-4a51-bb26-d89a06eeb61e`
- Type: Tank
- Chassis/model/weight: MASH Truck / (Small) / 15.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: Unknown
- Commander/maintenance: commander `Unknown`, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: assigned `Unknown`, carried units `Unknown`
- Legal status: Unknown unless established by MekHQ or play.
- Narrative overlay: Sparse/TBD
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.

### Flatbed Truck

- MekHQ unit id: `e979cd74-bfb9-460d-8fa5-083b24594e28`
- Type: Tank
- Chassis/model/weight: Flatbed Truck / Unknown / 10.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: Unknown
- Commander/maintenance: commander `Unknown`, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: assigned `Unknown`, carried units `Unknown`
- Legal status: Unknown unless established by MekHQ or play.
- Narrative overlay: Sparse/TBD
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.

### Flatbed Truck #2

- MekHQ unit id: `cbca7e39-2974-4afb-aade-2a7f91ed82e6`
- Type: Tank
- Chassis/model/weight: Flatbed Truck / Unknown / 10.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: Unknown
- Commander/maintenance: commander `Unknown`, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: assigned `Unknown`, carried units `Unknown`
- Legal status: Unknown unless established by MekHQ or play.
- Narrative overlay: Sparse/TBD
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.

### Flatbed Truck #3

- MekHQ unit id: `5835d1f1-6a7a-494e-9ef7-fab47aae232e`
- Type: Tank
- Chassis/model/weight: Flatbed Truck / Unknown / 10.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: Unknown
- Commander/maintenance: commander `Unknown`, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: assigned `Unknown`, carried units `Unknown`
- Legal status: Unknown unless established by MekHQ or play.
- Narrative overlay: Sparse/TBD
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.

### Flatbed Truck #4

- MekHQ unit id: `4da80ed1-daeb-49d5-8769-9c4231ede34e`
- Type: Tank
- Chassis/model/weight: Flatbed Truck / Unknown / 10.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: Unknown
- Commander/maintenance: commander `Unknown`, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: assigned `Unknown`, carried units `Unknown`
- Legal status: Unknown unless established by MekHQ or play.
- Narrative overlay: Sparse/TBD
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.

### Riever F-100

- MekHQ unit id: `55763f16-e5a2-4411-8add-5a90e6d7b15e`
- Type: Aerospace Fighter
- Chassis/model/weight: Riever / F-100 / 100.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: cb5cd549-8126-4f1d-80b5-b920e0268e8a
- Commander/maintenance: commander `cb5cd549-8126-4f1d-80b5-b920e0268e8a`, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: assigned `Unknown`, carried units `Unknown`
- Legal status: Unknown unless established by MekHQ or play.
- Narrative overlay: Sparse/TBD
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.

### Grasshopper GHR-5H

- MekHQ unit id: `8cfb8277-6ac2-4b94-91c4-368255a517b2`
- Type: Mek
- Chassis/model/weight: Grasshopper / GHR-5H / 70.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: 239ee267-4b34-4028-abf4-cde9f96c3e56
- Commander/maintenance: commander `239ee267-4b34-4028-abf4-cde9f96c3e56`, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: assigned `Unknown`, carried units `Unknown`
- Legal status: Unknown unless established by MekHQ or play.
- Narrative overlay: Sparse/TBD
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.

### Warhammer WHM-6R

- MekHQ unit id: `62f5bb1e-1664-4bb9-a705-220f226b9010`
- Type: Mek
- Chassis/model/weight: Warhammer / WHM-6R / 70.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: aebaebfa-ef2a-4624-b33f-95ed121a39f1
- Commander/maintenance: commander `aebaebfa-ef2a-4624-b33f-95ed121a39f1`, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: assigned `Unknown`, carried units `Unknown`
- Legal status: Unknown unless established by MekHQ or play.
- Narrative overlay: Sparse/TBD
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.

### Warhammer WHM-6R #2

- MekHQ unit id: `175e5aa7-684c-4e3f-9c27-8f4e7bf09491`
- Type: Mek
- Chassis/model/weight: Warhammer / WHM-6R / 70.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: aa61bf26-3ded-42c7-b0a8-d1d8f368afe3
- Commander/maintenance: commander `aa61bf26-3ded-42c7-b0a8-d1d8f368afe3`, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: assigned `Unknown`, carried units `Unknown`
- Legal status: Unknown unless established by MekHQ or play.
- Narrative overlay: Sparse/TBD
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.

### Stalker STK-3F

- MekHQ unit id: `3961dcc4-a1ab-44fd-b9fd-afe69b0a5032`
- Type: Mek
- Chassis/model/weight: Stalker / STK-3F / 85.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: 64e04931-e0ad-4d0f-8586-3050780277a2
- Commander/maintenance: commander `64e04931-e0ad-4d0f-8586-3050780277a2`, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: assigned `Unknown`, carried units `Unknown`
- Legal status: Unknown unless established by MekHQ or play.
- Narrative overlay: Sparse/TBD
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.

### Stalker STK-3F #2

- MekHQ unit id: `f8153824-6566-4456-9c3c-2005a91d9b9d`
- Type: Mek
- Chassis/model/weight: Stalker / STK-3F / 85.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: 98afe1de-8571-4cea-991a-720c3ec23bf1
- Commander/maintenance: commander `98afe1de-8571-4cea-991a-720c3ec23bf1`, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: assigned `Unknown`, carried units `Unknown`
- Legal status: Unknown unless established by MekHQ or play.
- Narrative overlay: Sparse/TBD
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.

### BattleMaster BLR-1G

- MekHQ unit id: `a49d781c-29a7-45ba-b7b1-bd321a7d5e33`
- Type: Mek
- Chassis/model/weight: BattleMaster / BLR-1G / 85.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: 42415cbf-a39d-46dd-98a7-9d784cd4a008
- Commander/maintenance: commander `42415cbf-a39d-46dd-98a7-9d784cd4a008`, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: assigned `Unknown`, carried units `Unknown`
- Legal status: Unknown unless established by MekHQ or play.
- Narrative overlay: Sparse/TBD
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.

### Riever F-100 #2

- MekHQ unit id: `33d58048-1f85-4f35-a52f-cf874e577ebc`
- Type: Aerospace Fighter
- Chassis/model/weight: Riever / F-100 / 100.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: 49854443-76a0-413d-9229-a071a7ff0ba1
- Commander/maintenance: commander `49854443-76a0-413d-9229-a071a7ff0ba1`, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: assigned `Unknown`, carried units `Unknown`
- Legal status: Unknown unless established by MekHQ or play.
- Narrative overlay: Sparse/TBD
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.

### Grasshopper GHR-5H #2

- MekHQ unit id: `3e310095-bea0-4aa2-9487-9768edaebd50`
- Type: Mek
- Chassis/model/weight: Grasshopper / GHR-5H / 70.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: 502ccd12-19dc-442c-8bac-844714736c85
- Commander/maintenance: commander `502ccd12-19dc-442c-8bac-844714736c85`, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: assigned `Unknown`, carried units `Unknown`
- Legal status: Unknown unless established by MekHQ or play.
- Narrative overlay: Sparse/TBD
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.

### Warhammer WHM-6R #3

- MekHQ unit id: `a89ca2b9-5309-4736-80ff-0d434cad0355`
- Type: Mek
- Chassis/model/weight: Warhammer / WHM-6R / 70.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: b50b1104-7ad6-451d-a7d0-395a80c40855
- Commander/maintenance: commander `b50b1104-7ad6-451d-a7d0-395a80c40855`, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: assigned `Unknown`, carried units `Unknown`
- Legal status: Unknown unless established by MekHQ or play.
- Narrative overlay: Sparse/TBD
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.

### Flashman FLS-7K

- MekHQ unit id: `82e168b6-f5b2-4f57-b07e-e3f2a99d9f74`
- Type: Mek
- Chassis/model/weight: Flashman / FLS-7K / 75.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: 79d8be94-cdf4-4161-8eb6-ea74ceab2741
- Commander/maintenance: commander `79d8be94-cdf4-4161-8eb6-ea74ceab2741`, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: assigned `Unknown`, carried units `Unknown`
- Legal status: Unknown unless established by MekHQ or play.
- Narrative overlay: Sparse/TBD
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.

### Awesome AWS-8Q

- MekHQ unit id: `2831ff21-65e3-4e5e-adfe-eedf00339b1b`
- Type: Mek
- Chassis/model/weight: Awesome / AWS-8Q / 80.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: c9548e24-d495-444d-aaa7-467449fdc290
- Commander/maintenance: commander `c9548e24-d495-444d-aaa7-467449fdc290`, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: assigned `Unknown`, carried units `Unknown`
- Legal status: Unknown unless established by MekHQ or play.
- Narrative overlay: Sparse/TBD
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.

### BattleMaster BLR-1G #2

- MekHQ unit id: `a91a9a70-d0d9-4ec6-9f80-b4c16031fab6`
- Type: Mek
- Chassis/model/weight: BattleMaster / BLR-1G / 85.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: bc592bb3-a3a9-48e4-acc0-c62af2c7183f
- Commander/maintenance: commander `bc592bb3-a3a9-48e4-acc0-c62af2c7183f`, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: assigned `Unknown`, carried units `Unknown`
- Legal status: Unknown unless established by MekHQ or play.
- Narrative overlay: Sparse/TBD
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, movement, heat, armor, weapons, ammo, damage, repair, and salvage.

### Ares Assault Craft Mark VII

- MekHQ unit id: `b284fa8a-4106-4790-bfe7-d6cc06cfe1dc`
- Type: Small Craft
- Chassis/model/weight: Ares Assault Craft / Mark VII / 150.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Formation: `Sharpe's Strikers / Headquarters / Space Transport`
- Crew links: Dong-po Ts'ong, Abhiraja Rathore, Theron Gislenus, Adriane Litzmann, Pauli Faruq
- Commander/maintenance: commander Dong-po Ts'ong, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport role: Intended `Jade Passage` Small Craft bay freight/landing craft. Exact Small Craft bay occupancy is not exposed by the V1 API.
- Legal status: MekHQ-owned hard ledger unit; narrative relationship to the `Jade Passage` remains a MEK-RPG overlay unless MekHQ exposes bay assignment.
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, bay capacity, cargo, infantry transport legality, movement, armor, weapons, ammo, damage, repair, and salvage.

### Dragonstar Passenger Transport

- MekHQ unit id: `403d4123-8918-429c-a5f4-6e4818fa1e1b`
- Type: Small Craft
- Chassis/model/weight: Dragonstar Passenger Transport / Unknown / 150.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Crew links: Abdul Qadir Patti
- Commander/maintenance: commander Abdul Qadir Patti, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport role: Intended `Jade Passage` Small Craft bay passenger/security craft with jump-infantry capacity.
- Infantry lift note: The Dragonstar is the planned strategic lift for the Strikers' `Jump Platoon (Laser)` during interstellar movement. No current MekHQ carried-unit assignment is asserted; the V1 API transport output reports zero carried/assigned units.
- Legal status: MekHQ-owned hard ledger unit; narrative relationship to the `Jade Passage` remains a MEK-RPG overlay unless MekHQ exposes bay assignment.
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact unit state, infantry bay capacity, movement, armor, weapons, ammo, damage, repair, and salvage.

### Jump Platoon (Laser)

- MekHQ unit id: `925c5d87-47a5-4d7d-87f9-23e62378d664`
- Type: Infantry
- Chassis/model/weight: Jump Platoon / (Laser) / 4.0
- Status: Undamaged (Confirmed from MekHQ live API)
- Availability/deployability: available `true`, deployable `true`, deployed `false`
- Commander/maintenance: commander Christian Johns, maintenance site `Facility - Basic`
- Damage state: Undamaged
- Transport: During interstellar movement, this platoon is planned to ride in the `Dragonstar Passenger Transport` so the Strikers do not need to hire a separate troop transport vessel. No current MekHQ carried-unit assignment is asserted.
- Legal status: MekHQ-owned hard ledger unit.
- Tactical handoff notes: Use MekHQ/MegaMek/Classic BattleTech for exact infantry state, transport loading, deployment, damage, and casualty handling.

- Additional live API units not expanded here: 3. See `mekhq-bridge.md`.

## Repairs And Logistics

- Repair pressure: parts needed count: 1; parts needing service count: 1; units needing parts count: 1; units needing service count: 1; units under repair count: 0
- Parts/shopping pressure: shopping list item count: 0; shopping list part item count: 0; total buy cost: 0 C-Bill
- Shopping list sample: Unknown
- Cargo/transport warnings: Cargo output summarizes transport relationships only; capacity math and load/unload commands are not exposed in V1.
- Automation guard: repair execution `false`, procurement execution `false`, stable work ids `false`
- Warnings: Repair and procurement output is display-only context, not a complete work-order command queue.
- Pending MekHQ application: None yet; create item ids in `pending-mekhq-actions.md`.
