# BattleTech Source Precedence

Status: issue `#82` conflict policy. Use this before the ruling authority gate or a mechanic helper decides whether a question is adjudicable, provisional, source-lookup-required, or external-authority-required.

Purpose: define how MEK-RPG resolves or refuses conflicts between A Time of War summaries, private source pages, Classic BattleTech-style tactical procedures, MegaMek, MekHQ, table canon, and campaign-local state.

## Core Rule

Use the narrowest authority that owns the fact being decided. Do not blend authorities when they disagree. State which authority won, which authority was set aside, and whether the result is source-bound, table-canon, provisional, or externally resolved.

## Precedence By Fact Type

| Fact or question type | Highest authority | Lower authority / fallback | Conflict policy |
| --- | --- | --- | --- |
| User instruction in the current turn | User's latest explicit instruction, within safety and project boundaries | Older chat, older summaries, default procedure | Follow the latest user instruction unless it asks for unsafe, copyrighted, or out-of-scope behavior. |
| Active campaign fact | Structured `campaigns/<campaign-id>/` files and `campaign-state/active-campaign.md` | Older `previous-sessions.md`, stale notes, chat memory | Current structured campaign files win. Record conflicts instead of merging stale memory. |
| MekHQ-linked hard ledger fact | Latest saved MekHQ import or checkpoint summary | MEK-RPG narrative overlays, unresolved pending actions, guesses | MekHQ wins for date, funds, roster, unit state, repairs, contracts, markets, scenarios, salvage, and tactical outcomes. Pending actions are intents until saved re-import confirms them. |
| RPG-scale A Time of War procedure | Committed routed summary plus manifest/page references; private source page when precision matters | GM judgment, old ruling, fiction | Use committed summaries first. If insufficient, require private source lookup or make a labeled temporary ruling. |
| Full tactical BattleTech combat | Classic BattleTech, MegaMek, MekHQ, or table-selected tactical rules/tool | A Time of War tactical routing aids, RPG narration | External tactical authority wins for hex movement, facing, heat, armor locations, weapon ranges, ammo, critical hits, and full unit turns. |
| Equipment, unit, record sheet, or exact table value | Private owned source, official record sheet, MegaMek/MekHQ data, or user-supplied profile | Committed summary text, model memory | Do not invent exact stats, prices, ranges, catalogs, or unit records. Route to source/tool or require supplied data. |
| Sourcebook lore or published setting canon | Private owned source or table-adopted canon note | Summary, memory, fiction tone | Exact canon requires lookup. The table may override it as table canon, clearly labeled as such. |
| Fiction or in-universe flavor | Table canon if explicitly adopted | Rules summaries or hard ledger facts | Fiction can inspire scenes but does not override mechanics, hard ledger facts, or tactical outcomes by itself. |
| Optional or advanced rules | Table opt-in decision plus routed summary/source page | Default procedure | Optional rules apply only when the table chose them. Otherwise use default/simple procedure or a provisional ruling. |
| Safety/tone or child-player constraint | `safety-and-tone.md`, user instruction, project safety rule | Rules detail, realism, source tone | Safety and tone boundaries win over source detail and tactical precision. |

## Authority Order For Rulings

When a request touches multiple fact types, evaluate in this order:

1. Current user instruction and safety/tone boundaries.
2. Mode procedure and project source/copyright boundaries.
3. Active structured campaign state.
4. Latest MekHQ import for MekHQ-owned hard ledger facts.
5. Table canon or explicit house rules recorded in campaign files.
6. Routed committed A Time of War summaries and GM procedures.
7. Private source page lookup when committed summaries are insufficient.
8. External tactical/logistics authority when exact tactical or hard ledger resolution matters.
9. GM temporary ruling, labeled as provisional and recorded if consequential.

This order does not mean a narrative file can override MekHQ ledger facts or a rules summary can override tactical combat. The fact type still determines ownership.

## Conflict Examples

### RPG-Scale Action

Conflict: A PC wants to bypass a lock. `rules/core/skill-checks.md` supports a skill check, but the exact tool modifier is not in committed summaries.

Policy: Run the RPG-scale check only if the GM supplies the modifier or accepts a provisional modifier. If exact gear modifiers matter, require private source lookup. Record any temporary modifier if it affects later play.

### Tactical Combat

Conflict: A BattleMech firefight starts during a scene, and an RPG summary mentions tactical bridge concepts.

Policy: Stop RPG-scale resolution and use `gm/switch-to-classic-battletech.md`. Tactical rules/tool output owns movement, heat, damage locations, ammo, and scenario outcome. MEK-RPG records the returned consequences afterward.

### MekHQ Ledger State

Conflict: A session log says a unit was repaired, but the latest MekHQ import still shows the unit damaged.

Policy: MekHQ wins for unit condition. Keep the session log as narrative intent or discrepancy, create/update a pending MekHQ item if needed, and do not treat the repair as final until a saved MekHQ re-import confirms it.

### Equipment Stat Lookup

Conflict: A player asks for an exact weapon range or armor value, but the committed equipment summary only routes to the relevant source pages.

Policy: Do not answer from memory or invent the value. Ask the user to inspect the owned source or provide the stat profile. A helper should return `source_lookup_required`.

### Sourcebook Lore

Conflict: Published setting material and the table's established campaign canon disagree about a minor faction detail.

Policy: If the table has explicitly adopted its version, table canon controls the campaign scene and should be labeled as a table-canon override. Do not claim the override is published canon.

### Table-Canon Override

Conflict: The table wants a faster, less detailed injury recovery ruling than the committed summaries imply.

Policy: The GM may make a table-canon or temporary ruling for momentum, but must label it, preserve safety/tone boundaries, and record it if it affects PC condition, mission readiness, or future rules expectations.

## Authority-Gate Implications

Future issue `#80` should map this policy to gate statuses:

- `authoritative`: routed committed summary or procedure owns the fact and required inputs are present.
- `provisional`: summary exists, but the result relies on GM/table-supplied judgment or a temporary ruling.
- `source_lookup_required`: exact private source text, table, catalog, stat block, or page inspection is required.
- `external_authority_required`: Classic BattleTech, MegaMek, MekHQ, tabletop tactical rules, or another external owner must resolve the fact.
- `cannot_adjudicate`: no current route, source, supplied value, or safe owner is available.
- `blocked_missing_route`: router/manifest/page-reference metadata cannot identify a safe authority.

## Copyright And Source Boundaries

- Do not copy protected source text, tables, stat blocks, record sheets, fiction, or long lore passages into repository docs, issues, or chat.
- Use paraphrase, page references, route guidance, and original examples.
- Keep raw PDFs and extracted text ignored and unstaged.
- Treat committed summaries as lookup and procedure aids, not as replacements for legally owned source pages when exact wording or tables matter.

## Related Files

- `indexes/task-router.md`
- `indexes/page-reference-index.md`
- `indexes/manifest.yaml`
- `gm/battletech-source-handoff.md`
- `gm/rules-adjudication-posture.md`
- `gm/switch-to-classic-battletech.md`
- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- `docs/current/MECHANIC_CONTRACT_SCHEMA.md`
