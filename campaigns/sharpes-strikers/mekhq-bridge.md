# MekHQ Bridge

This file records campaign-local bridge metadata for a read-only MekHQ live API context refresh. It is not a MekHQ save, not a durable checkpoint, and not authority to write to MekHQ.

## Live API Metadata

- MEK-RPG campaign id: `sharpes-strikers`
- Live API state JSON: `mekhq-live-api-capture/mekhq-state.json`
- Adapter timestamp: `2026-07-24T20:03:46.3601745+00:00`
- Schema: `mekhq-live-campaign-state` version `0.1`
- API mode: `local-read-only-live-context`
- Read-only proof: `true`
- MekHQ version: `0.51.01`
- State revision: `live-7fbbb5da-0bcd-46f1-8f61-846848c2f148-3034-07-02-2026-07-24T20:03:45.031689600Z`
- Snapshot id: `live-7fbbb5da-0bcd-46f1-8f61-846848c2f148-3034-07-02-2026-07-24T20:03:45.031689600Z`
- Dirty state: Unknown

## Ownership Boundary

- MekHQ owns campaign date, day advancement, travel, finances, rosters, unit condition, repairs, contracts, markets, scenarios, tactical outcomes, and hard logistics.
- MEK-RPG owns RPG scenes, A Time of War overlays, conversations, relationships, promises, secrets, hooks, session logs, safety/tone, and narrative uncertainty.
- Live API values are live context by default. Promote them to durable MEK-RPG memory only through a save/import checkpoint, explicit user approval, or a future controlled promotion flow.
- Do not write to `.cpnx`, `.cpnx.gz`, MekHQ XML, raw MekHQ save payloads, or MekHQ API write surfaces from this workspace.

## Campaign Snapshot

- MekHQ campaign id: `7fbbb5da-0bcd-46f1-8f61-846848c2f148`
- Name: Sharpe's Strikers
- Date: 3034-07-02
- Location: Lesalles
- Funds: 337,194,891 C-Bill
- Viewpoint: Sharpe "Sharpe" Williams (`c9548e24-d495-444d-aaa7-467449fdc290`), Selected first active and available MekHQ live API personnel record.

## Counts

- Personnel: 408
- Units: 26
- Contracts: 12
- Scenarios: 129
- Market unit/personnel/contract offers: 55 / 60 / 0
- Current report lines: 1
- Pending deployments: 4

## Cross-References

### Personnel

- `c9548e24-d495-444d-aaa7-467449fdc290` -> `sharpe-sharpe-williams`: Sharpe "Sharpe" Williams
- `b50b1104-7ad6-451d-a7d0-395a80c40855` -> `truda-floyd-pavlischev`: Truda "Floyd" Pavlischev
- `bc592bb3-a3a9-48e4-acc0-c62af2c7183f` -> `pietrek-deepfield-bonnet`: Pietrek "Deepfield" Bonnet
- `42415cbf-a39d-46dd-98a7-9d784cd4a008` -> `benedikt-cypher-crystar`: Benedikt "Cypher" Crystar
- `4b81c57e-5ae7-4a68-81c3-b8aeb97864cc` -> `bonny-jean-smith`: Bonny-jean Smith
- `1a4eb306-d543-4021-9a92-960e62e05b00` -> `bryan-gayagoy-battistella`: Bryan Gayagoy-Battistella
- `09c97b81-f393-4d97-b8ba-6d49021ad833` -> `patricia-battistella`: Patricia Battistella
- `b2ae2c5b-f5e4-4cee-a6f3-0f78268b2131` -> `pascale-lemoine`: Pascale Lemoine
- `4e2f6d05-53c6-42bc-a2c9-372e4b4e7562` -> `vivian-yamamoto`: Vivian Yamamoto
- `c2de1456-9907-462d-a6a5-1e10248de325` -> `marietta-beiro`: Marietta Beiro
- `e42f5162-d8d5-4082-9437-8276a2901634` -> `manny-beiro`: Manny Beiro
- `b9cfe10b-8180-4b46-b2b4-d0a7a48dbd2f` -> `lewis-beiro`: Lewis Beiro
- `3e24edb2-435b-4fef-b7dd-1211e7e576b9` -> `soeko-kato`: Soeko Kato
- `5b8ec5ba-0c98-41c9-a301-2c92c8fd7027` -> `jennie-van-huizen`: Jennie van Huizen
- `ad30510d-4009-4201-9a00-49b0f70dcf94` -> `shunnar-mu-ayyad`: Shunnar Mu'ayyad
- `b878aed4-7af6-41ae-a8b3-0e04a2a731c0` -> `yunis-palijo`: Yunis Palijo
- `5acb39a4-8c41-45ef-9198-e3bc4fd6fb66` -> `minh-duc-lang`: Minh-Duc Lang
- `8f194fe2-073c-4832-a16c-50a5a402cd27` -> `gavina-markham`: Gavina Markham
- `b15a0795-f32f-4ca7-b6a1-1df23492584a` -> `my-markham`: My Markham
- `da5a8606-975d-4a6c-a90c-d4e4f54b4d83` -> `vetle-yashodhar`: Vetle Yashodhar

### Units

- `4d3c4e0c-7eee-4352-b026-13bf843eebeb` -> `catapult-cplt-c1`: Catapult CPLT-C1
- `e0187a2c-6bfd-4f72-aa31-814232e2d81a` -> `sherpa-armored-truck-mobile-canteen`: Sherpa Armored Truck (Mobile Canteen)
- `1b60147c-14ed-4a51-bb26-d89a06eeb61e` -> `mash-truck-small`: MASH Truck (Small)
- `e979cd74-bfb9-460d-8fa5-083b24594e28` -> `flatbed-truck`: Flatbed Truck
- `cbca7e39-2974-4afb-aade-2a7f91ed82e6` -> `flatbed-truck-2`: Flatbed Truck #2
- `5835d1f1-6a7a-494e-9ef7-fab47aae232e` -> `flatbed-truck-3`: Flatbed Truck #3
- `4da80ed1-daeb-49d5-8769-9c4231ede34e` -> `flatbed-truck-4`: Flatbed Truck #4
- `55763f16-e5a2-4411-8add-5a90e6d7b15e` -> `riever-f-100`: Riever F-100
- `8cfb8277-6ac2-4b94-91c4-368255a517b2` -> `grasshopper-ghr-5h`: Grasshopper GHR-5H
- `62f5bb1e-1664-4bb9-a705-220f226b9010` -> `warhammer-whm-6r`: Warhammer WHM-6R
- `175e5aa7-684c-4e3f-9c27-8f4e7bf09491` -> `warhammer-whm-6r-2`: Warhammer WHM-6R #2
- `3961dcc4-a1ab-44fd-b9fd-afe69b0a5032` -> `stalker-stk-3f`: Stalker STK-3F
- `f8153824-6566-4456-9c3c-2005a91d9b9d` -> `stalker-stk-3f-2`: Stalker STK-3F #2
- `a49d781c-29a7-45ba-b7b1-bd321a7d5e33` -> `battlemaster-blr-1g`: BattleMaster BLR-1G
- `33d58048-1f85-4f35-a52f-cf874e577ebc` -> `riever-f-100-2`: Riever F-100 #2
- `3e310095-bea0-4aa2-9487-9768edaebd50` -> `grasshopper-ghr-5h-2`: Grasshopper GHR-5H #2
- `a89ca2b9-5309-4736-80ff-0d434cad0355` -> `warhammer-whm-6r-3`: Warhammer WHM-6R #3
- `82e168b6-f5b2-4f57-b07e-e3f2a99d9f74` -> `flashman-fls-7k`: Flashman FLS-7K
- `2831ff21-65e3-4e5e-adfe-eedf00339b1b` -> `awesome-aws-8q`: Awesome AWS-8Q
- `a91a9a70-d0d9-4ec6-9f80-b4c16031fab6` -> `battlemaster-blr-1g-2`: BattleMaster BLR-1G #2
- `b284fa8a-4106-4790-bfe7-d6cc06cfe1dc` -> `ares-assault-craft-mark-vii`: Ares Assault Craft Mark VII
- `403d4123-8918-429c-a5f4-6e4818fa1e1b` -> `dragonstar-passenger-transport`: Dragonstar Passenger Transport
- `925c5d87-47a5-4d7d-87f9-23e62378d664` -> `jump-platoon-laser`: Jump Platoon (Laser)

### Contracts

- `1` -> `3025-cc-talitha-recon-raid`: 3025 - CC - Talitha Recon Raid
- `2` -> `3025-cc-altorra-garrison-duty`: 3025 - CC - Altorra Garrison Duty
- `3` -> `3027-magistracy-of-canopus-butzfleth-pirate-hunting`: 3027 - Magistracy of Canopus - Butzfleth Pirate Hunting
- `4` -> `3027-cc-wallacia-objective-raid`: 3027 - CC - Wallacia Objective Raid
- `5` -> `3028-cc-weldry-objective-raid`: 3028 - CC - Weldry Objective Raid
- `6` -> `3028-cc-pinard-objective-raid`: 3028 - CC - Pinard Objective Raid
- `7` -> `3029-cc-shoreham-objective-raid`: 3029 - CC - Shoreham Objective Raid
- `8` -> `3029-cc-styk-relief-duty`: 3029 - CC - Styk Relief Duty
- `9` -> `3030-cc-corey-garrison-duty`: 3030 - CC - Corey Garrison Duty
- `10` -> `3031-cc-adler-planetary-assault`: 3031 - CC - Adler Planetary Assault
- `11` -> `3032-cc-no-return-pirate-hunting`: 3032 - CC - No Return Pirate Hunting

## Warnings

- {"area": "dirty_state", "evidence": "Unknown", "message": "No source-confirmed dirty/unsaved campaign flag is exposed by this V1 local API pass.", "source_owner": "MekHQ GUI save-state tracking"}

## API Gaps

- See `mekhq-api-gaps.md`.
