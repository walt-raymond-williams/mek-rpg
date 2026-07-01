# MekHQ Personnel Sheet Workflow

Status: issue `#65` workflow.

Purpose: define how parsed MekHQ personnel become useful campaign-local `pcs.md` and `npcs.md` entries without inventing A Time of War stats or blurring MekHQ-owned roster facts with MEK-RPG-owned RPG memory.

## Current Live API And Parsing Coverage

For active MekHQ-linked play, prefer the live API capture and compact query views over save-derived summaries. `scripts/fetch-mekhq-live-api.ps1` can capture an explicit single-person detail read, and `scripts/query-mekhq-live-api.py --view person-detail` emits compact selected-person facts for rich PC/NPC records without dumping raw logs. Use `docs/current/RICH_CHARACTER_MEKHQ_API_NEEDS.md` for the issue `#125` field map and producer-request boundary.

`scripts/summarize-mekhq-save.py` currently emits these personnel fields from the read-only MekHQ summary:

- MekHQ person id
- display name
- role
- rank
- faction
- assignment unit id
- availability/status
- injury and fatigue flags
- commander and second-in-command flags
- evidence label
- personnel market applicants, using the same person summary shape

`scripts/bootstrap-mekhq-campaign.py` currently uses that summary to:

- select one viewpoint by MekHQ person id, exact display name, commander fallback, first-person fallback, or embedded unlinked PC name.
- write a sparse `pcs.md` viewpoint entry.
- write sampled `npcs.md` imported personnel entries, capped by `MAX_LIST_ITEMS`.
- write `mekhq-bridge.md` cross-reference rows for imported personnel.
- keep broader hard roster authority in MekHQ and the bridge metadata.

## Ownership Boundary

MekHQ owns hard roster facts for linked personnel:

- person id
- display name as imported
- role, rank, faction, assignment, and commander flags
- employment/market membership
- availability, fatigue, injury/healing ledger state
- salary, personnel transaction, hiring/firing, promotion, assignment, and day-advance effects when available from MekHQ

MEK-RPG owns RPG overlays and table memory:

- A Time of War attributes, traits, skills, Edge, XP, gear, personal goals, and open sheet questions
- motives, fears, secrets, beliefs, quirks, speech style, relationships, promises, favors, grudges, and loyalty
- scene memory, last-seen context, player-facing impressions, rumors, and hidden uncertainty
- temporary personal-scale condition notes until they become MekHQ personnel ledger changes

Do not infer A Time of War attributes, skill levels, traits, Edge, XP, lifepath results, armor, weapons, gear, command authority, salary, or social standing from MekHQ role/rank alone.

## Who Gets Expanded

Expand a MekHQ person into `pcs.md` when one of these is true:

- the user selects the person as a player character or recurring viewpoint.
- the person will make A Time of War rolls as a PC-scale actor.
- the person needs goals, sheet gaps, Edge/XP tracking, injury overlays, or player-facing agency.
- the person is an embedded PC with no MekHQ link yet; use `mekhq_person_id: None`.

Expand a MekHQ person into `npcs.md` when one of these is true:

- the person has spoken on screen or is expected to recur.
- the person has a motive, secret, relationship, favor, threat, command tension, or personal stake.
- the person is a patron, rival, subordinate, prisoner, recruit, patient, witness, or antagonist.
- the person's MekHQ status creates a roleplaying scene: injury, fatigue, hire/fire, assignment, promotion, transfer, market interview, or morale issue.

Leave a person only in `mekhq-bridge.md` cross-references when:

- they are a background roster member with no table-facing role yet.
- only their existence, name, id, role, or assignment matters.
- adding them would make `pcs.md` or `npcs.md` harder to scan.

For large rosters, keep `npcs.md` focused on important people and leave the complete roster in MekHQ plus `mekhq-bridge.md` cross-references. Add expanded entries on demand.

## Linked PC Entry Shape

Use this shape for MekHQ-linked PCs in `pcs.md`.

```markdown
### Display Name

#### Link And Evidence

- MEK-RPG slug:
- MekHQ person id:
- Link status: linked | unlinked embedded PC | needs confirmation | retired
- Last imported:
- Import evidence: Confirmed from MekHQ import | Confirmed by user | Unknown
- Source summary or checkpoint:

#### MekHQ-Owned Roster Facts

- Display name:
- Role/rank:
- Faction:
- Assignment:
- Availability:
- Injury/fatigue ledger flags:
- Commander or command flag:
- Hard-ledger notes:

#### MEK-RPG A Time of War Overlay

- Player:
- Concept:
- Attributes:
- Traits:
- Skills:
- Edge:
- XP:
- Armor and important gear:
- Personal condition overlay:
- Open sheet questions:

#### RPG Memory

- Goals:
- Motives:
- Relationships:
- Secrets or uncertainty:
- Promises, debts, or threats:
- Last seen:
- Scene notes:

#### Import Refresh Notes

- Refresh policy:
- Discrepancies:
- Pending MekHQ actions:
```

## Linked NPC Entry Shape

Use this shape for MekHQ-linked NPCs in `npcs.md`.

```markdown
### Display Name

#### Link And Evidence

- MEK-RPG slug:
- MekHQ person id:
- Link status: linked | market applicant | former roster member | narrative-only | needs confirmation
- Last imported:
- Import evidence:
- Source summary or checkpoint:

#### MekHQ-Owned Roster Facts

- Display name:
- Role/rank:
- Faction:
- Assignment:
- Availability:
- Injury/fatigue ledger flags:
- Market or employment status:

#### MEK-RPG NPC Overlay

- Role in campaign:
- Current location:
- Current attitude toward PCs:
- Wants:
- Knows:
- Secrets or uncertainty:
- Promises, debts, or threats:
- Current status:
- Last seen:

#### Sheet And Rules Gaps

- A Time of War stats needed:
- Relevant skills or approaches:
- Gear or assets in scene:
- Source/rules route:

#### Import Refresh Notes

- Refresh policy:
- Discrepancies:
- Pending MekHQ actions:
```

## Import Refresh Behavior

Refreshes must preserve MEK-RPG memory while updating MekHQ-owned facts from the latest saved import.

1. Read the current `mekhq-bridge.md` import timestamp and cross-reference entries.
2. Compare the latest live query view, read-only summary, or checkpoint export by MekHQ person id.
3. Update only the `MekHQ-Owned Roster Facts` fields from imported hard facts.
4. Preserve `MEK-RPG A Time of War Overlay`, `MEK-RPG NPC Overlay`, `RPG Memory`, and `Sheet And Rules Gaps` unless the user explicitly edits or retcons them.
5. If a linked person is missing from the latest import, mark `Link status: needs confirmation` or `former roster member`; do not delete the entry if it has scene memory.
6. If a display name changes but the person id is stable, update the display name and keep the MEK-RPG slug stable.
7. If the same display name appears with a different MekHQ id, do not merge automatically. Record a discrepancy.
8. If a scene creates a hiring, firing, assignment, rank, injury, availability, or salary change, add a `pending-mekhq-actions.md` item until the saved MekHQ import confirms it.

## Discrepancy Handling

Use `mekhq-bridge.md` for technical discrepancies and the relevant PC/NPC entry for person-local notes.

| Case | Handling |
| --- | --- |
| MekHQ import changes role, rank, assignment, availability, or injury/fatigue | Update the MekHQ-owned fact and add a dated refresh note. |
| MekHQ import conflicts with MEK-RPG scene memory | MekHQ wins for hard ledger facts; MEK-RPG memory remains unless the table retcons it. |
| MekHQ person id disappears | Mark as needs confirmation or former roster member; preserve RPG memory. |
| New important person appears | Add to `npcs.md` only if scene relevance exists; otherwise leave in bridge cross-references. |
| Market applicant is hired | After MekHQ confirms the hire, update link status from market applicant to linked roster person if the id remains stable. |
| Pending RPG scene result is not applied in MekHQ | Keep it pending and do not treat the hard roster fact as final. |

## Code Decision

This first pass is documentation-only. Do not update `bootstrap-mekhq-campaign.py` yet.

Reason: bootstrap currently creates sparse starter stubs from one summary snapshot. A richer refresh/merge tool would need stable person ids, live `person-detail` input, merge behavior, deletion rules, discrepancy reporting, and fixture coverage. The workflow should be used manually first, then converted into a focused helper after real MekHQ-linked play proves the fields and merge behavior.

When code changes become justified, prefer a companion helper over expanding bootstrap:

- `bootstrap-mekhq-campaign.py`: one-time campaign creation from a summary.
- future personnel helper: refresh or expand selected people in an existing campaign folder without overwriting RPG memory.

## Validation Expectations

For documentation-only use:

- `./scripts/validate-rules-indexes.ps1`
- `./scripts/test-all.ps1`
- `git diff --check`
- protected-source ignore checks

For a future script:

- use `tests/fixtures/mekhq-summary-minimal.json`.
- cover selected PC expansion, selected NPC expansion, missing person id, duplicate display name, missing latest import, refresh preserving RPG overlay, and discrepancy output.
- verify no raw MekHQ save, raw XML, protected source text, copied tables, purchased PDFs, or secrets are committed.
