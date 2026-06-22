# Special Equipment Source Review Validation

## Scope

- Issue: `#93`
- Source ranges reviewed:
  - A Time of War PDF pages 300-302 / printed pages 298-300: battle armor, exoskeletons, donning, emergency egress, and infantry/vehicle boundary.
  - A Time of War PDF pages 316-320 / printed pages 314-318: prosthetics, bionic and cloned replacements, elective implants, Enhanced Imaging, surgery, repair, and recovery.
  - A Time of War PDF pages 319-323 / printed pages 317-321: drugs, poisons, medicine handling, addiction, treatment, and creation framework.
  - A Time of War PDF pages 323-327 / printed pages 321-325: personal vehicles, vehicle table boundaries, fuel types, and support-vehicle routing.
- Updated summaries:
  - `rules/equipment/battle-armor-and-exoskeletons.md`
  - `rules/equipment/prosthetics-and-implants.md`
  - `rules/equipment/drugs-and-poisons.md`
  - `rules/equipment/personal-vehicles.md`

## Source Boundary

The committed summaries paraphrase live-play procedure and routing only. They do not copy suit statistics, prosthetic tables, implant entries, drug or poison tables, creation tables, vehicle lists, fuel prices, tactical modifiers, or source prose.

Exact equipment rows, costs, ratings, doses, strengths, durations, fuel values, vehicle statistics, and tactical effects remain private source lookup or external tactical-tool work.

## Validation Scenarios

| Prompt | Expected route | Result |
| --- | --- | --- |
| A PC has to scramble into powered armor during a boarding alarm. | `rules/equipment/battle-armor-and-exoskeletons.md` | Pass: routes to suit custody/readiness, donning or egress source lookup, and tactical handoff if vehicle-scale opposition matters. |
| A lost arm replacement affects the next mission's readiness. | `rules/equipment/prosthetics-and-implants.md` | Pass: routes to injury consequence, restorative versus elective replacement, surgery/recovery tracking, and private lookup for exact trait offsets. |
| A predator venom needs field treatment without the proper antidote. | `rules/equipment/drugs-and-poisons.md` | Pass: routes to vector/protection, resistance, stabilization versus cure, MedTech treatment, and campaign-state poison clock. |
| A player wants a combat drug before a raid. | `rules/equipment/drugs-and-poisons.md` | Pass: routes to short-term effect, side effects, legality, addiction risk, and source lookup for exact drug values. |
| The crew buys a utility truck and needs fuel for a remote trip. | `rules/equipment/personal-vehicles.md` | Pass: routes to broad vehicle class, asset recording, fuel readiness clock, source lookup for exact range/fuel values, and MekHQ pending intent if ledger-owned. |

## Status Decision

These files are now `draft` play-facing summaries rather than `source-reviewed-routing-aid` entries. They can support cautious live GM rulings for access, readiness, treatment, recovery, and logistics. Exact catalogs, values, and tactical unit handling still require private source lookup, Classic BattleTech, MegaMek, MekHQ, or a relevant tactical source.

## Verification

Run these checks after issue `#93` changes:

```powershell
./scripts/validate-rules-indexes.ps1
./scripts/test-route-rules-prompt.ps1
./scripts/test-report-rules-coverage.ps1
./scripts/test-all.ps1
```
