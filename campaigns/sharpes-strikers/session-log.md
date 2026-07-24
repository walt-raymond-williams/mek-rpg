# Session Log

## Active Or Most Recent Session

Date: 2026-07-24

Mode: MekHQ-linked live API context load

Player characters:

- Sharpe "Sharpe" Williams (initial viewpoint; confirm before play)

## Summary

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

## Important Rolls

- None.

## State Changes

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

## Rewards And Costs

- None.

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
