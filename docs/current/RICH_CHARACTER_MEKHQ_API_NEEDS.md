# Rich Character MekHQ API Needs

Status: issue `#125` MEK-RPG-side coordination memo.

Purpose: identify which MekHQ-visible personnel details can safely support rich MEK-RPG PC/NPC records, which fields remain MEK-RPG-only overlays, and what producer-side API improvements should be requested later.

This memo does not authorize edits to the MegaMek workspace. It is a project-local change request and boundary guide.

## Current Usable Inputs

For active MekHQ-linked play, start with the live API capture and compact query views:

```powershell
./scripts/fetch-mekhq-live-api.ps1 -OutputDirectory .\mekhq-live-api-capture -PersonnelDetailPersonId "<person-id>"
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view person-detail --format json
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view person-commitment --person-id "<person-id>" --format json
```

The current MEK-RPG consumer path can already use these MekHQ-owned facts when present:

- stable MekHQ person id
- display name, title, rank, callsign, and age where exposed
- primary role, personnel status, prisoner state, employment or market/applicant membership
- unit and formation assignment
- availability, fatigue, hits, injury/recovery summaries, and other ledger status summaries
- XP or skill summaries that MekHQ exposes as MekHQ career/game facts
- active options, abilities, award counts, and log-family status/counts when exposed
- pending deployment or scenario commitment from `pending-deployments` and `person-commitment` views
- source files, JSON paths, capture manifest status, API mode, and read-only proof

Medical and patient log families remain excluded by default. They should be captured only when the scene explicitly needs them, with `-IncludePersonnelMedical`, `-IncludePersonnelPatient`, and a bounded `-PersonnelDetailLogLimit`.

## Hard Fact To Rich Record Mapping

Use MekHQ facts only in the MekHQ-owned parts of `pcs.md` and `npcs.md`:

| MekHQ fact family | Rich record destination | Evidence label |
| --- | --- | --- |
| person id, display name, rank, role, status | Header And Link; MekHQ-Owned Roster Facts | `Confirmed from MekHQ import` |
| assignment, formation, commander marker, deployment commitment | MekHQ-Owned Roster Facts; Combat And Readiness | `Confirmed from MekHQ import` |
| availability, injury, fatigue, prisoner state, healing ledger | MekHQ-Owned Roster Facts; Combat And Readiness | `Confirmed from MekHQ import` |
| market/applicant membership or employment state | Header And Link; MekHQ-Owned Roster Facts | `Confirmed from MekHQ import` |
| MekHQ skill, XP, option, award, or career summaries | MekHQ-Owned Roster Facts or A Time of War Sheet Status notes, only as MekHQ career facts | `Confirmed from MekHQ import` |
| compact log-family status/counts | Update History or Import Refresh Notes | `Confirmed from MekHQ import` |

Do not convert MekHQ career facts into A Time of War attributes, traits, skills, Edge, XP, gear, personality, motives, secrets, loyalty, preferences, or portrayal notes. Those remain MEK-RPG overlays or user/table decisions.

## MEK-RPG-Only Fields

The following rich-record fields must not be inferred from MekHQ role, rank, assignment, or log presence:

- A Time of War attributes, traits, skill levels, Edge, XP, lifepath choices, and legal build status
- personal gear, armor, weapons, carried equipment, and source-table values unless separately established
- goals, motives, fears, beliefs, principles, preferences, secrets, grudges, debts, promises, and loyalties
- relationships, command tension, morale interpretation, player-facing impressions, and rumors
- speech cues, behavior cues, decision tendencies, tone constraints, portrayal notes, and example phrasing
- hidden facts or GM-only uncertainty

Use `Unknown`, `Needs user decision`, `Needs source lookup`, or `Needs GM ruling` rather than smoothing missing overlay data into canon.

## Desired Producer/API Support

The current `GET /campaign/personnel/detail?personId=<uuid>` path is useful enough for selected-person context. Future producer improvements should stay focused on stable, source-owned hard facts:

1. Keep `personId` as the primary selector, and expose duplicate-safe display-name/callsign lookup warnings rather than allowing ambiguous merges.
2. Include per-field provenance where practical: source owner, JSON path, capture timestamp, and whether a value is current, computed, unsupported, partial, or withheld.
3. Preserve explicit `unknown`, `missing`, `unsupported`, `partial`, and privacy-withheld states for every optional field family.
4. Expose personnel detail for market applicants and former roster members when MekHQ still has a stable record, with lifecycle status clearly labeled.
5. Keep assignment detail stable enough to answer current unit, formation, crew slot, commander relationship, tech/doctor responsibility, and pending deployment commitment.
6. Keep injury, fatigue, healing, prisoner, salary/pay, promotion, and personnel transaction fields source-owned and ledger-labeled.
7. Expose month-tick or day-advance personnel prompts as structured prompt/report data when they affect advancement, awards, status, salary, injury, or availability.
8. Continue suppressing raw log entry text by default; expose log family counts, dates, categories, and privacy flags first.
9. When medical or patient data is available, require explicit opt-in and bounded log limits, and label privacy-sensitive fields so MEK-RPG can avoid putting them into player-facing summaries.
10. Keep unsupported rich-character-adjacent requests structured enough for `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`.

## Suggested Change-Request Text

For a future MegaMek/MekHQ producer ticket:

> MEK-RPG can use `GET /campaign/personnel/detail?personId=<uuid>` to support rich PC/NPC records if the endpoint keeps stable person ids, explicit lifecycle/status fields, assignment and availability summaries, source-owned injury/fatigue/healing facts, bounded skill/XP/option/award summaries, privacy-aware log family metadata, and machine-readable unknown/unsupported states. The endpoint should not try to provide RPG motives, secrets, personality, preferences, or A Time of War legal-build data; MEK-RPG owns those overlays.

## Open Follow-Ups

- No MEK-RPG code change is required for issue `#125`.
- A future selected-person refresh helper can be considered after real rich records exist in a MekHQ-linked campaign.
- If live play exposes a missing field that blocks a scene, add a concrete entry to `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md` with the attempted endpoint and fallback used.
- Do not open or edit a MegaMek workspace issue from this repository unless the user explicitly asks.

## Related Files

- `docs/current/RICH_CHARACTER_RECORD_SCHEMA.md`
- `docs/current/MEKHQ_PERSONNEL_SHEET_WORKFLOW.md`
- `docs/current/MEKHQ_LIVE_API_QUERY_VIEW_CONTRACT.md`
- `docs/current/MEGAMEK_LIVE_API_CHANGE_REQUEST.md`
- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`
- `gm/character-record-capture.md`
