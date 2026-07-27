# Session Log

## Active Or Most Recent Session

Date: 2026-07-26

Mode: MekHQ-linked battalion TO&E staff review

Player characters:

- Sharpe "Sharpe" Williams (initial viewpoint; confirm before play)

## Summary

Live context from the refreshed API snapshot captured at `2026-07-26T19:41:30Z`:

- Campaign: Sharpe's Strikers
- Date/location: 3034-12-06 at Altorra
- Funds: 280,863,298 C-Bill
- Units/personnel: 62 units, 461 personnel
- Active contract: `3034 - CC - Altorra Objective Raid`, employer Capellan Confederation, end date 3034-12-26.
- Current pending deployments: five exposed by `GET /campaign/pending-deployments`; `Breakthrough` on 3034-12-06 has `Warhammer WHM-6R`, `Warhammer WHM-6R #2`, `Warhammer WHM-6R #3`, `Awesome AWS-8Q`, `Mechbuster #2`, and `Mechbuster #3` assigned.
- Current combat roster: 23 on-hand BattleMechs, 2 on-hand Aerospace Fighters, 3 on-hand Conventional Fighters, plus 13 combat units still inbound.
- Battalion TO&E, confirmed from `/campaign/commands` selectors: top-level forces are `Headquarters`, `3rd Expeditionary Force`, and `RESERVE`. The combat battalion parent is `3rd Expeditionary Force`, containing `Alpha Company`, `Bravo Company`, and `Charlie Company`.
- Alpha Company: `Command Lance` has Sharpe's `Awesome AWS-8Q` and three `Warhammer WHM-6R` units, currently deployed to `Breakthrough`; `Frontline Lance` has two Stalkers and two Grasshoppers; `Auxilary Lance` has two BattleMasters, a Flashman, and the Catapult.
- Bravo Company: `Strike Lance` has the Atlas, Thunderbolt, Champion, and `Exterminator EXT-4A #2`; `Patrol Lance` has `Exterminator EXT-4A`, Stinger, Locust, Shadow Hawk, and Phoenix Hawk; `Mechbuster #2` and `Mechbuster #3` are attached at company level and currently deployed to `Breakthrough`.
- Charlie Company: `LAM/ASF Force` has the two Phoenix Hawk LAMs; `ASF 1` has the two Riever F-100s; `Mechbuster CAS` has `Mechbuster #4`. This corrects an earlier voice-to-text misunderstanding: there are no `Terrafex` assets in the current discussion.
- API caveat: force/TO&E read data is available from `/campaign/commands` selectors, not the compact query views. TO&E mutation commands remain blocked/not implemented.

Staff setup: Sharpe calls the senior staff in to review the new battalion organization, test whether the structure is sound under the remaining Altorra contract pressure, and identify personnel, transport, maintenance, and aerospace expansion problems before the next wave of deliveries arrives.

Staff decisions from the TO&E review:

- After `Breakthrough`, move `Mechbuster #2` and `Mechbuster #3` from their temporary Bravo company-level attachment into Charlie Company with `Mechbuster #4`.
- Build Bravo Company's third lance around incoming light/scout BattleMechs, creating a second patrol/scout lance suitable for patrols, route security, contract footprint, and lower-risk deployments.
- Use incoming aerospace and conventional-fighter deliveries to fill Charlie Company into a complete air arm around the Phoenix Hawk LAMs, Rievers, and Mechbusters.
- Make Mule acquisition the next strategic purchase once a cheap enough viable hull appears. Current funds are believed sufficient, but purchase, condition, transport assignment, and maintenance costs remain MekHQ-owned until applied and verified.
- Visit a hiring hall to fill weak personnel areas before the full delivery pipeline arrives, with immediate attention to MekTechs, vehicle crews, mechanics, aerospace pilots/crew, AeroTeks, and conventional aircraft crew.
- Future expansion concept: after current deliveries, Mule acquisition, and hiring recovery are complete, consider one more major expansion into a second battalion built as a training/replacement battalion. Preferred model is three training companies using light and possibly medium BattleMechs, with Bravo Company's light/scout machines eventually cascading down as Bravo pilots graduate into heavier equipment. Intended purpose is pilot development, replacement depth, patrol coverage, and controlled-risk deployment of less critical assets.
- Training battalion doctrine: follow a Great House-style cadre/cadet system like formal cadre contracts. Training units deploy with an experienced formation that carries the real combat weight. Cadets use light machines for scouting, pursuit, screens, objective presence, and opportunistic support, not unsupported assaults or suicide rushes. Occasional losses of fragile Wasps/Stingers are accepted as a risk of combat, but waste of personnel or machines is not acceptable.

Scene development: during the staff meeting, Capellan liaison Sang-wei Qiao Ren calls Sharpe with a post-contract movement offer. House Liao has arranged matters so that, once the Altorra Objective Raid contract concludes, Sharpe's Strikers will have access to the Long Transit Association's `Vermilion Gate` and its attached Mule. The vessels are expected to be available in-system to help carry the Strikers to Capella. Qiao frames the trip as a Contract Completion Review, a protected-charter docket for Long Transit, and a retainer conference with Capellan civil and military authorities. Practical effect: the Strikers have an official reason to spend time on Capella for hiring hall access, market searches, repair recovery, and future-contract negotiation.

Sharpe's reply: the current Altorra campaign is going well and he expects the enemy to be routed soon. Once the contract is complete, Sharpe's Strikers will mothball and transport directly to Capella for the proceedings Qiao listed. Sharpe states that the command looks forward to working with the Capellan Confederation and closes with a loyal courtesy to the Celestial Wisdom.

## Previous Live Context

Live context from the refreshed API snapshot captured at `2026-07-26T00:41:27Z`:

- Campaign: Sharpe's Strikers
- Date/location: 3034-10-30 at Altorra
- Funds: 260,839,017 C-Bill
- Units/personnel: 59 units, 410 personnel
- Active contract: `3034 - CC - Altorra Objective Raid`, employer Capellan Confederation, end date 3034-12-26.
- Current pending deployments: six exposed by `GET /campaign/pending-deployments`; `Minor Engagement` on 3034-10-30 has `Stalker STK-3F`, `Stalker STK-3F #2`, `Grasshopper GHR-5H`, and `Grasshopper GHR-5H #2` assigned.
- Inbound rebuild pipeline: 31 units in transit, arriving in waves from 3034-11-14 to 3035-03-29.
- LAM headline: the Strikers have two Phoenix Hawk LAMs in the live roster. One is on hand, crewed, undamaged, and deployable; one arrives in 15 days, uncrewed and not deployable until assigned a pilot.

Staff setup: Sharpe needs to bring the command staff up to speed that the outfit is rebuilding aggressively, likely with a Mule acquisition path soon, and that the two Phoenix Hawk LAMs are not just hardware. The deal was unusually favorable and the seller sought out the Strikers; table inference is that someone in CCAF or Capellan-aligned procurement circles may be pleased with the unit. Treat this as political texture and a hook until confirmed in play or MekHQ notes.

## Earlier Live Context

Generated or refreshed this campaign save from a read-only MekHQ live API state payload, staged Chapter One of `The Jade Passage`, then refreshed again after the user's MekHQ setup pass.

Live context from the refreshed API snapshot captured at `2026-07-24T20:03:46Z`:

- Campaign: Sharpe's Strikers
- Date/location: 3034-07-02 at Lesalles
- Funds: 337,194,891 C-Bill
- Units/personnel: 26 units, 408 personnel
- Active contract: `3034 - CC - Lesalles Recon Raid`, two months remaining.
- Current pending deployments: four exposed by `GET /campaign/pending-deployments`; `Frontline Disruption` has Frontline Lance assigned.
- Current transport posture: user confirms zero separate transport costs; the continuing burden is maintenance for the `Jade Passage`, `Celestial Garden`, the Union, and the newly purchased Small Craft.

Chapter One setup: the Long Transit Association's Merchant-class JumpShip `Jade Passage` has arrived at the Capella jump point carrying the Monarch-class DropShip `Celestial Garden`. Tora Wichers requests that Sharpe board the Monarch under the protection of the Strikers' House Liao standing before Capellan customs can impound both ships. The proposed permanent charter would give the Strikers strategic mobility and a civilian home, but it also brings maintenance bills, shipboard civilian politics, legal exposure, and a Capellan noble with a grudge.

Confirmed by user: after major layoffs and asset sales, current transportation cost zero separate C-bills; the burden is maintaining the JumpShip and two DropShips tied to the arrangement.

Expansion planning confirmed by user: the Jade Passage arc may grow into a `Vermilion Gate` sister-ship recovery path. Preferred direction is another modest Merchant-class JumpShip, not an Invader, released from a claimed `900,000,000 C-Bill` lien through Capellan political leverage and a simple narrative retainer clock: `10,000,000 C-Bill` credited against the lien per qualifying Capellan contract completed after conditional release. Sharpe's near-term practical step is to acquire one Mule so the Strikers can rebuild toward battalion scale while the second Merchant solves the collar bottleneck.

## Important Rolls

- None.

## State Changes

- MekHQ live API polled and captured on 2026-07-26.
- Updated campaign-local current state and asset notes to reflect the 3034-12-06 Altorra battalion TO&E review snapshot.
- Added battalion TO&E summary from `/campaign/commands` force selectors and corrected the voice-to-text misunderstanding around Phoenix Hawk LAMs.
- Recorded staff decisions for post-`Breakthrough` Mechbuster reassignment, Bravo third patrol lance, Charlie aerospace expansion, Mule-first purchasing, and hiring-hall priorities.
- Recorded future second-battalion concept as a training/replacement formation after the current battalion and transport plan are stabilized.
- Added cadre/cadet operating doctrine for future training battalion deployments.
- Added in-scene Capellan liaison offer: post-Altorra movement to Capella using `Vermilion Gate` and its attached Mule for a contract review, Long Transit protected-charter docket, and retainer conference.
- Recorded Sharpe's acceptance of Qiao's post-contract Capella movement plan.
- Updated campaign-local current state and asset notes to reflect the 3034-10-30 Altorra Objective Raid snapshot.
- Added inbound unit-wave summary and Phoenix Hawk LAM staff agenda.
- Created or refreshed campaign-local MekHQ live API bridge/context notes.
- Added `The Jade Passage` as the active MEK-RPG narrative arc.
- Added `Jade Passage`, `Celestial Garden`, and the Strikers' Union transport relationship as narrative assets.
- Added Tora Wichers, Captain Damiane Meyer, Captain Nadežda Dunajski, and Chief Engineer Damon Dimas as MEK-RPG civilian/cooperative NPCs.
- Retired the original Jade Passage story aliases `Lian Zhou`, `Captain Mei Ren`, `Captain Tomas Vale`, and `Chief Engineer Aron Vesk`; MEK-RPG now uses the actual Sharp's Strikers MekHQ names for those roles instead of renaming MekHQ personnel.
- Added Long Transit Association relationship and charter hooks.
- Staff meeting personnel-cut policy established: keep Veteran/Elite/Heroic personnel where possible; cut Green/Regular unless they fill a required billet or named story/ship role.
- Ground vehicle crew cuts were paused pending manual MekHQ unmothballing of retained ground vehicles and a fresh live API crew-need read; this was later resolved by the 3033-10-08 live API snapshot.
- Small Craft procurement intent established for the `Jade Passage`: seek one `Mark VII Landing Craft` for freight lift and one `Dragonstar Passenger Transport` for infantry/passenger/security lift. Refreshed MekHQ market check on 3032-12-04 did not show either target craft.
- Small Craft procurement resolved in MekHQ: live API now confirms `Ares Assault Craft Mark VII` and `Dragonstar Passenger Transport` as owned, undamaged 150-ton Small Craft. The API also confirms one `Jump Platoon (Laser)` in the roster. Table logistics ruling: during interstellar movement, the Dragonstar has enough infantry transport capacity for that jump platoon, avoiding the need to hire another troop transport vessel.
- Staff meeting called by Sharpe on 3033-10-08 at Randar for lance leaders, administrators, medical staff, head techs, and transport officers to settle post-downsizing objectives and the operating relationship with `Jade Passage`, `Celestial Garden`, and the new Small Craft.
- Retained ground vehicles verified as unmothballed in the 3033-10-08 live API snapshot: mobile canteen, small MASH truck, and four flatbed trucks are undamaged, available, deployable, and not mothballed.
- Budget-cut decision: Sharpe declared the current staffing level acceptable for now. The unit is keeping personnel depth to absorb turnover and future growth, including an intentionally generous admin staff that has been with the command through the hard years.
- Expansion doctrine established: the Strikers may expand again later, but no new combat arm, support arm, or civilian dependency burden gets added unless transport capacity is identified first.
- Doctrine correction for Alpha Company: Command Lance is not a rarely held reserve. Under the current active contract, the user's table/MekHQ UI read is that at least ten active combat units are required, while Alpha Company has fourteen deployable combat units. Command Lance is part of the working force and should be used regularly, with risk managed through support, rotation, and maintenance rather than idling the strongest pilots and machines.
- Jade Passage expansion plan recorded in `jade-passage-expansion.md`: recover `Vermilion Gate`, use a simple Capellan-contract debt clock, acquire a Mule first, and rebuild toward at least a BattleMech battalion with Alpha as the elite high-BV force and Bravo/Charlie as lower-BV line/training companies.
- Transport retainer roadmap added in `transport-retainer-roadmap.md`: current negotiated direction is a 3034-3043 Capellan license/retainer, Capellan-approved work during the term, no anti-Liao contracts afterward, 100% eligible transport reimbursement on future Capellan contracts using Long Transit craft, first Mule before further hull complexity, and rented/temporary personnel lift until play proves a dedicated passenger hull is needed.

## Rewards And Costs

- Planned reward path: conditional release and long-term charter rights for `Vermilion Gate`, a second Long Transit Merchant-class JumpShip, if Sharpe can use Capellan leverage, prove or pressure down fraudulent debt, and commit to the retainer.
- Planned cost path: claimed `900,000,000 C-Bill` lien, narrative `10,000,000 C-Bill` credit per qualifying Capellan contract completed after conditional release, continued Long Transit shipboard authority, maintenance obligations, and Capellan first-refusal pressure until settlement.
- Planned retainer cost path: the Strikers risk becoming too dependent on House Liao if the retainer language is too broad. Keep the distinction between Capellan-favored mercenary command and House-owned troops explicit in future scenes.

## Rules Gaps

- A Time of War sheet details for the selected viewpoint remain TBD.
- MekHQ-owned ledger changes must be applied in MekHQ and confirmed before becoming hard facts.
- Exact MekHQ representation of Small Craft bay occupancy, hard transport capacity, maintenance expenses, and any command support remains incomplete in the V1 API unless exposed by future reads or applied/verified in MekHQ.

## Command Policy

- No further personnel cuts are planned immediately.
- Preserve enough reserve personnel to cover injury, resignation, death, illness, and ordinary turnover.
- Veteran, elite, specialist, and long-serving staff may be retained even when the unit is temporarily overstaffed, if they support future expansion or institutional continuity.
- Any future expansion must be transport-first: secure berths, bays, crew, maintenance capacity, and shipboard space before adding units or dependents that need to move.

## Next Session

For the immediate MekHQ table state, continue the 3034-07-02 Lesalles Alpha Company force review under the active Recon Raid contract. Review each lance in operational terms, starting with Command Lance.
