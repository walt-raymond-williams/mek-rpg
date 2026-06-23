# MekHQ Bridge

This file records campaign-local bridge metadata for a read-only MekHQ live API context refresh. It is not a MekHQ save, not a durable checkpoint, and not authority to write to MekHQ.

## Live API Metadata

- MEK-RPG campaign id: `the-learning-ropes`
- Live API state JSON: `External captured live API JSON (not committed)`
- Adapter timestamp: `2026-06-23T15:17:19.944925+00:00`
- Schema: `mekhq-live-campaign-state` version `0.1`
- API mode: `local-read-only-live-context`
- Read-only proof: `true`
- MekHQ version: `0.51.01`
- State revision: `live-ea0d334a-1582-459a-9084-b349f0baca5a-3025-04-08-2026-06-23T15:17:19.278119Z`
- Snapshot id: `live-ea0d334a-1582-459a-9084-b349f0baca5a-3025-04-08-2026-06-23T15:17:19.278119Z`
- Dirty state: Unknown

## Ownership Boundary

- MekHQ owns campaign date, day advancement, travel, finances, rosters, unit condition, repairs, contracts, markets, scenarios, tactical outcomes, and hard logistics.
- MEK-RPG owns RPG scenes, A Time of War overlays, conversations, relationships, promises, secrets, hooks, session logs, safety/tone, and narrative uncertainty.
- Live API values are live context by default. Promote them to durable MEK-RPG memory only through a save/import checkpoint, explicit user approval, or a future controlled promotion flow.
- Do not write to `.cpnx`, `.cpnx.gz`, MekHQ XML, raw MekHQ save payloads, or MekHQ API write surfaces from this workspace.

## Campaign Snapshot

- MekHQ campaign id: `ea0d334a-1582-459a-9084-b349f0baca5a`
- Name: The Learning Ropes
- Date: 3025-04-08
- Location: Galatea
- Funds: 90,938,250 C-Bill
- Viewpoint: Michelle "Double-M" Moreno (`fd15b53b-14fa-4c36-ae9a-111c3ccd27ec`), Selected first active and available MekHQ live API personnel record.

## Counts

- Personnel: 106
- Units: 25
- Contracts: 0
- Scenarios: 0
- Market unit/personnel/contract offers: 37 / 30 / 1
- Current report lines: 3

## Cross-References

### Personnel

- `fd15b53b-14fa-4c36-ae9a-111c3ccd27ec` -> `michelle-double-m-moreno`: Michelle "Double-M" Moreno
- `085a1bb4-dba8-47ed-8bfb-c0b5fc625db1` -> `dr-martin-ito`: Dr Martin Ito
- `64975645-037a-4ac0-b6bb-0ffe7d25db63` -> `lazarus-olinger`: Lazarus Olinger
- `1dc8935b-0baa-4180-b6ce-86ec381761db` -> `tia-joe`: Tia Joe
- `f70d34cf-23ad-4f53-824a-6de935cc6ead` -> `majlinda-yusuf`: Majlinda Yusuf
- `6aeb2eee-b03c-4419-8a92-3dc2d4b6a879` -> `misbah-bin-hud`: Misbah bin Hud
- `e6bc6304-d0f4-4dfa-acda-2f7e19110e50` -> `silas-trinh`: Silas Trinh
- `c8b9a5a1-53ff-4dbe-b779-ca264aaef0fa` -> `ryuzaburo-ine`: Ryuzaburo Ine
- `7332852e-b41a-4621-a6ee-32b43ef482e2` -> `stephanie-prieler`: Stephanie Prieler
- `8e849bcc-a919-487f-84fc-2a667329c698` -> `hamengku-prieler`: Hamengku Prieler
- `e8c6fb88-8fa5-420d-954b-fdc2fcaa42c2` -> `jannat-karaganilla`: Jannat Karaganilla
- `09d54024-ea38-465e-a1d7-52a34d63dec1` -> `lisa-karaganilla`: Lisa Karaganilla
- `61341db6-bae6-448c-8910-63dca277f515` -> `manutapu-castro`: Manutapu Castro
- `bed8a64e-676e-4c63-884e-769d5e69ee48` -> `berta-turek`: Berta Turek
- `e9c06460-b1ac-42b7-9435-ad0a75d81f2d` -> `al-er`: Al Er
- `268edc07-525a-4585-a2bc-7aa899df966b` -> `martina-torres`: Martina Torres
- `b51e18a5-e3c3-4315-a914-d3a191010aa2` -> `fortunato-patacho`: Fortunato Patacho
- `a84b5e31-a263-482a-985e-f026b406ffe3` -> `firtha-weber`: Firtha Weber
- `eeaad066-a910-4962-9c99-10a10d4e0985` -> `dayo-sentwali`: Dayo Sentwali
- `26044925-2c68-4020-b344-4d46136d6313` -> `zina-salam`: Zina Salam

### Units

- `21d83f0a-a3c9-435c-a6eb-d6043ddde12f` -> `griffin-grf-1n`: Griffin GRF-1N
- `6fd0fcca-cf52-4a7b-b459-ef54ecd00d62` -> `locust-lct-1e`: Locust LCT-1E
- `9899788b-fe00-4595-912b-fe46526a7003` -> `centurion-cn9-a`: Centurion CN9-A
- `b7ffea69-ceaf-4155-8e17-d2e0702352e5` -> `flea-fle-4`: Flea FLE-4
- `4653009b-0108-465c-bad3-cc19c3cb742c` -> `crab-crb-20`: Crab CRB-20
- `66763236-66f0-451e-a273-6cb740b76a5a` -> `trebuchet-tbt-5n`: Trebuchet TBT-5N
- `931be1f0-ec7e-4c13-9042-868a0ae39f15` -> `stinger-stg-3r`: Stinger STG-3R
- `73be4ed1-429d-42a8-be7a-41dbcb4eade7` -> `spider-sdr-5v`: Spider SDR-5V
- `ecf64e7c-3f4b-49e4-a39d-fbf9fa2b7971` -> `flatbed-truck`: Flatbed Truck
- `e5139ba9-fa78-4040-9549-f451b96c004f` -> `flatbed-truck-2`: Flatbed Truck #2
- `c6573efc-e2d9-47fa-af94-15aec6de80c6` -> `flatbed-truck-3`: Flatbed Truck #3
- `0297b4dd-1326-438a-9e6d-6e47c418cac1` -> `scorpion-light-tank`: Scorpion Light Tank
- `ea9e5925-3b2c-416e-93d4-18119848642b` -> `scorpion-light-tank-2`: Scorpion Light Tank #2
- `5ed3790f-5bb9-4adf-8849-f17794bd7cd7` -> `foot-squad-rifle`: Foot Squad (Rifle)
- `cc18d328-9fa4-4c7d-bae8-c0ef2583a745` -> `leopard-2537-voice-of-canopus`: Leopard (2537) - Voice of Canopus
- `43cba584-04f9-4cad-8315-9369b49b3292` -> `grasshopper-ghr-5h`: Grasshopper GHR-5H
- `23744290-3886-4ffd-916e-23c34e9c1abf` -> `stalker-stk-4p`: Stalker STK-4P
- `eb6d60a7-d9ac-4f08-b1fc-af447f1c6ca8` -> `stalker-stk-4p-2`: Stalker STK-4P #2
- `fc819fbb-9314-49ae-9fcf-0474af6f7a72` -> `crusader-crd-3r`: Crusader CRD-3R
- `3ee49cdb-890c-4773-b410-4271b929bcda` -> `mash-truck-small`: MASH Truck (Small)

### Contracts

- None reported by the live API.

## Warnings

- {"area": "dirty_state", "evidence": "Unknown", "message": "No source-confirmed dirty/unsaved campaign flag is exposed by this V1 local API pass.", "source_owner": "MekHQ GUI save-state tracking"}

## API Gaps

- See `mekhq-api-gaps.md`.
