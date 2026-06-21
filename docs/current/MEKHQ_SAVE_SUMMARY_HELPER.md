# MekHQ Save Summary Helper

Status: issue `#27` prototype.

Purpose: document the first read-only helper for summarizing MekHQ `.cpnx`, `.cpnx.gz`, or plain campaign XML saves into MEK-RPG bridge facts.

## Helper

Script:

```powershell
python ./scripts/summarize-mekhq-save.py "C:\path\to\campaign.cpnx" --format json
python ./scripts/summarize-mekhq-save.py "C:\path\to\campaign.cpnx.gz" --format markdown
```

The helper reads an explicit save path, detects gzip compression by magic bytes, parses the XML with Python's structured XML API, and writes JSON or Markdown to stdout. It has no output-file argument and does not write to the MekHQ save.

## Output Shape

JSON output is the primary integration format for later bootstrap work:

- `bridge_metadata`: helper version, input path, save timestamp, import timestamp, save size, gzip status, MekHQ save version, warnings, and unsupported section names.
- `campaign`: campaign ID, name, date, start date, faction, current system/location fields, reputation, GM mode, and calculated funds.
- `finances`: calculated balance by currency, transaction count, recent transactions, loans/assets counts, loan defaults, and failed collateral.
- `personnel`: MekHQ person ID, display name, role, rank, faction, assignment, availability, injury/fatigue flags, commander flags, and evidence label.
- `units`: MekHQ unit ID, chassis/model/type, assignment/status IDs, crew IDs and linked display names, linked part count, and maintenance report summary.
- `contracts`: active saved mission/contract facts such as ID, name, type, employer, status, deadline, system, and selected terms.
- `scenarios`: scenario IDs, contract IDs, names, status, date, and objective/status summaries when present.
- `repairs_and_logistics`: shopping-list parts, part counts, technician and medic pool fields, and unsupported transport/cargo pressure notice.
- `markets`: unit market offers, personnel market applicants, contract-market metadata, and direct contract offer elements if present.
- `unsupported`: known gaps and fields that need more MekHQ inspection.

## Confirmed Field Mappings

Evidence label: `Confirmed from MekHQ import`.

| Output area | MekHQ XML source | Notes |
| --- | --- | --- |
| Campaign ID, date, name, faction | `campaign/info/id`, `calendar`, `name`, `faction` | Read directly from the save. |
| Current location | `campaign/locations/location/currentSystemId` plus transit fields | Current system ID is useful; richer route/base semantics need later mapping. |
| Personnel IDs and display names | `campaign/humanResources/personnel/person` | Uses person `id`, `givenName`, `surname`, and optional `callsign`. |
| Personnel roles/status | `primaryRole`, `rank`, `status`, `unitId`, fatigue and healing fields | Rank is still a raw MekHQ rank code in this prototype. |
| Unit IDs and model identity | `campaign/units/unit` plus child `entity` attributes | Uses unit `id` and entity `chassis`, `model`, and `type`. |
| Unit crew links | `driverId`, `gunnerId`, `techId` | Helper cross-references linked personnel names when available. |
| Contracts and scenarios | `campaign/missions/mission` and child `scenarios/scenario` | Reads saved mission/contract fields and scenario summaries. |
| Shopping list | `campaign/shoppingList/part` | Reads parts as logistics pressure, not as final repair authority. |
| Unit market offers | `campaign/unitMarket/offer` | Reads market, unit type, unit name, offer percent, and transit duration. |
| Personnel market applicants | `campaign/personnelMarket/person` | Reads applicants with the same personnel summarizer used for roster personnel. |

## Derived Or Inferred Fields

Evidence label: `Inferred`.

- Funds are calculated by summing serialized finance transaction amounts by currency. MekHQ source confirms `Finances.getBalance()` calculates balance from transactions, but users should confirm in MekHQ UI when exact funds matter.
- Unit repair/damage summary counts parts linked by `unitId` and includes a cleaned maintenance report excerpt. The helper does not interpret armor, internal structure, critical slots, repair difficulty, or repair duration.

## Unsupported Or Needs Inspection

- Unit market final prices: MekHQ derives final price from unit cost, offer percent, entity tech base, and campaign multipliers. The save offer exposes percent and unit name, not a final price.
- Exact unit damage state: needs deeper entity and part mapping before it can be trusted.
- Transport capacity and cargo pressure: current location and units are available, but transport semantics are not mapped yet.
- Daily report alerts: report fields can contain presentation HTML and need classification before becoming reliable logistics alerts.
- Contract market offers: the sample save exposes contract-market metadata but no direct contract offer elements. The helper will read direct `contract` or `mission` children if present, but broader StratCon/AtB market mapping needs more sample coverage.

## Verification Fixture

The initial verification used disposable sister-workspace saves:

- `C:\Users\waltr\Documents\megamek-workspace\analysis\tmp\issue-22\Autosave-1-The Learning Ropes-30250720.cpnx`
- `C:\Users\waltr\Documents\megamek-workspace\analysis\tmp\issue-22\Autosave-1-The Learning Ropes-30250720.cpnx.gz`

These files are not committed to MEK-RPG. No A Time of War PDF or extracted source text was processed for this issue.
