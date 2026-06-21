# Asset Sheet Schema

Status: issue `#54` design note.

Purpose: define a campaign-local Markdown shape for DropShips, large vehicles, BattleMechs, support craft, cargo assets, and unit-level resources without turning MEK-RPG into a hard logistics ledger.

## Design Decision

Keep large assets in each campaign's `assets.md` for now. Use repeatable Markdown entries with stable slugs and evidence labels. Do not introduce per-asset files or a dedicated validator yet.

Reasons:

- Current campaign saves already use `assets.md` as the owner for money, vehicles, ships, permits, repairs, debts, cargo, and contracts.
- The transport/large-asset summary from issue `#53` supports scene framing and save updates, but it does not provide exact DropShip economy, title law, crew payroll, or operating-cost rules.
- MekHQ-linked campaigns already treat MekHQ as the hard ledger for units, funds, dates, repairs, markets, rosters, contracts, cargo, and tactical outcomes.
- A richer schema is useful immediately, while a required per-asset file structure should wait until live play produces stable examples.

## Evidence Labels

Use one label per important field. Prefer explicit uncertainty over silent inference.

- `Confirmed from MekHQ import`: imported from a read-only MekHQ summary.
- `Confirmed by user`: established by the user or table.
- `Confirmed by play`: established in a played scene.
- `Table ruling`: decided by local canon because the current summaries do not settle it.
- `Inferred`: reasonable but needs later confirmation.
- `Unknown`: expected field not known yet.
- `Unsupported`: outside current MEK-RPG, A Time of War summary, or MekHQ bridge coverage.
- `Pending MekHQ application`: proposed hard ledger change not yet applied, saved, and re-imported from MekHQ.
- `Needs source/tool lookup`: requires private source inspection, MekHQ, Classic BattleTech, MegaMek, or another table-approved tool.

## Asset Categories

Use the same entry shape for all assets, but fill only the useful fields.

- `personal-vehicle`: cars, trucks, bikes, civilian flyers, small boats, and other personal transport.
- `support-vehicle`: utility vehicles, cargo haulers, repair platforms, medical vehicles, and non-frontline support.
- `combat-unit`: BattleMech, combat vehicle, battle armor squad, aerospace unit, turret, or other tactical unit.
- `spacecraft`: DropShip, JumpShip, shuttle, small craft, aerospace transport, or spacecraft access.
- `property`: facility, warehouse, office, repair bay, safehouse, berth, land, or legal holding.
- `cargo`: mission cargo, salvage, supplies, trade goods, prisoners, passengers, or sensitive freight.
- `contract-right`: salvage right, transport clause, berth access, repair promise, permit, or employer-provided support.
- `abstract-support`: patron backing, faction access, borrowed equipment pool, or temporary assigned resources.

## Entry Template

Use this as the standard asset entry inside `campaigns/<campaign-id>/assets.md`.

```markdown
### Asset Name

- Asset slug: example-asset-slug
- Category: spacecraft | support-vehicle | combat-unit | property | cargo | contract-right | abstract-support
- Status: active | pending | disputed | damaged | unavailable | lost | retired
- Evidence summary: Confirmed by user / Confirmed from MekHQ import / Inferred / Unknown

#### Identity

- Display name:
- Alternate names or registry:
- Type/model/class:
- Scale: personal | vehicle | tactical unit | spacecraft | property | abstract
- MekHQ unit id: Unknown / N/A / value
- MekHQ campaign/source reference: Unknown / N/A / save import timestamp or bridge note
- MEK-RPG related slugs: missions, NPCs, factions, relationships, hooks

#### Control And Ownership

- Current controller:
- Claimed owner:
- Custodian or operator:
- Ownership evidence:
- Legal status:
- Title/registration/permit status:
- Debts, liens, collateral, shares, or obligations:
- Contested claims:
- Pending MekHQ action ids:

#### Location And Access

- Current location:
- Last confirmed:
- Access requirements:
- Port, berth, bay, storage, or route notes:
- Security, locks, or remote-control concerns:
- Travel or deployment constraints:

#### Condition And Readiness

- Overall condition:
- Readiness: ready | limited | needs repair | unsafe | unknown
- Damage, defects, or inspection findings:
- Repair/maintenance state:
- Fuel, power, cargo, ammunition, or supply notes:
- Exact ledger source:
- Unsupported or unresolved logistics:

#### Crew And Roles

- Required crew or operators:
- Assigned crew:
- Key PCs/NPCs:
- Relevant skills:
- Loyalty, morale, or relationship notes:
- Missing personnel or training gaps:

#### Tactical Handoff

- Tactical system route: RPG scene | Classic BattleTech | MegaMek | MekHQ
- Handoff trigger:
- Known tactical assumptions:
- Pilot/gunnery/crew notes:
- Open unit-stat or rules lookups:

#### Narrative Overlay

- Why it matters:
- Current pressure:
- Faction interest:
- Promises, hooks, or secrets:
- Next review trigger:
```

## Field Ownership

| Field group | MEK-RPG owns | MekHQ owns when linked | Boundary |
| --- | --- | --- | --- |
| Identity | Slugs, nicknames, narrative aliases, table-facing descriptions | MekHQ unit IDs, imported display names, unit types | Keep slugs stable even if MekHQ display names change. |
| Ownership and control | Scene claims, title rumors, disputed custody, promises, legal ambiguity | Final purchased/sold asset state, assignment, cargo, funds, market removal | Treat legal/title systems as table rulings unless a source or MekHQ confirms a hard fact. |
| Condition and readiness | Inspection findings, player-facing defects, hidden risks, readiness clocks | Exact unit condition, damage, ammo, parts, repairs, transport capacity, cargo | Do not invent exact technical state in MEK-RPG when MekHQ is linked. |
| Crew and roles | Loyalty, motives, missing trust, A Time of War overlays, scene roles | Personnel roster, assignments, salary, injury/fatigue availability | Record crew drama in MEK-RPG; apply roster changes in MekHQ. |
| Finance and obligations | Debts as story pressure, promises, guarantors, disputed liens | Funds, payroll, purchase/sale price, maintenance, fees, loan-like ledger facts if tracked | Exact economics require MekHQ, private source lookup, or table ruling. |
| Tactical handoff | Objectives, stakes, pilot/crew notes, narrative constraints | Unit records, damage resolution, salvage, scenario outcome | Use Classic BattleTech, MegaMek, or MekHQ when tactical precision matters. |

## Minimal Entry

Use a minimal entry when an asset matters but the GM does not need the full template yet.

```markdown
### Asset Name

- Asset slug:
- Category:
- Status:
- Evidence summary:
- Controller/owner claim:
- Location:
- Condition/readiness:
- Legal/debt/obligation notes:
- Crew/operators:
- MekHQ reference:
- Hooks or next review:
```

## Save Workflow

1. Create or update an entry when an asset changes future play.
2. Put hard facts and narrative overlays in different fields rather than mixing them in one sentence.
3. Cross-reference active missions, NPCs, factions, relationships, hooks, and pending MekHQ action ids.
4. If a MekHQ-linked scene changes a hard ledger fact, record `Pending MekHQ application` until the user applies it in MekHQ and a later import confirms it.
5. If exact values are unavailable, mark `Unknown`, `Unsupported`, or `Needs source/tool lookup`.
6. When the asset triggers a tactical scene, prepare a tactical handoff and bring only the resulting campaign consequences back into `assets.md`.

## Validator Implications

Do not expand `scripts/validate-campaign-state.ps1` for this issue. The generic validator should continue checking required campaign files and active-campaign safety only.

A focused asset companion validator is a good future task after live campaign files contain multiple real asset entries. Candidate checks:

- asset slug is present and stable
- category and status use known values
- evidence labels are present on ownership, condition, and MekHQ references
- MekHQ-linked entries do not mark pending actions as confirmed facts
- tactical handoff fields are present for combat units, spacecraft, and large vehicles
- no raw MekHQ save payloads or protected source text appear in committed asset files

## Related Files

- `campaigns/_template/assets.md`
- `campaigns/README.md`
- `gm/state-save-checklist.md`
- `rules/campaign/transport-and-large-assets.md`
- `rules/vehicles-and-mechs/overview.md`
- `gm/tactical-encounter-handoff-checklist.md`
- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`

## Unsupported Areas

- Exact DropShip pricing, operating costs, crew payroll, docking fees, cargo income, loan schedules, and maintenance budgets.
- Definitive title-transfer law, liens, insurance, port permits, customs, registration, or co-op ownership rules.
- Full tactical unit records, heat, ammo, armor locations, damage, salvage, and repair math.
- Direct writes to MekHQ `.cpnx`, `.cpnx.gz`, XML, or raw save payloads.
