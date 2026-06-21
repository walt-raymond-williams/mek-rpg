# GM Campaign Orientation Source Review Validation

## Scope

Issue `#64` source-reviewed the mapped GM and campaign orientation ranges and produced routing aids rather than lore summaries. The outputs are designed for table use, source routing, campaign-canon triage, and GM procedure.

## Scenario Checks

| Scenario | Expected route | Result |
| --- | --- | --- |
| New player asks what this game is and what the GM does | `rules/universe/intro-to-play.md`, then `gm/session-procedure.md` and `gm/scene-loop.md` | Pass: route explains roles, materials, rules routing, and tactical handoff without reproducing introductory prose. |
| Player asks for faction or era orientation | `rules/universe/factions-and-history.md`, `indexes/term-glossary.md`, `campaign-state/setting-basics.md` | Pass: route supports scene-level orientation and marks canon-heavy details as lookup-needed. |
| GM needs to know which BattleTech source or tool owns a question | `gm/battletech-source-handoff.md`, `gm/switch-to-classic-battletech.md`, `gm/tactical-encounter-handoff-checklist.md` | Pass: procedure separates RPG rules, tactical tools, records, sourcebook canon, and fiction. |
| GM must make a temporary ruling | `gm/rules-adjudication-posture.md`, `gm/roll-policy.md`, `indexes/task-router.md` | Pass: route requires authority selection, scale check, and follow-up recording for consequential gaps. |
| GM needs a quick NPC or encounter pressure | `rules/gamemastering/npcs-and-encounters.md`, `gm/mission-template.md` | Pass: route supports NPC importance, relative competence, attitude, equipment function, and campaign-save updates while leaving templates/tables private. |
| GM wants campaign and story technique guidance | `gm/gamemastering-tips.md`, `gm/session-procedure.md`, `gm/state-save-checklist.md` | Pass: procedure supports player agency, preparation, flexibility, and aftermath tracking. |
| GM wants an adventure seed | `gm/adventure-seeds-map.md`, `gm/mission-template.md` | Pass: file routes to source pages for private inspection and provides only an original scaffold, not source seed text. |
| Rank, title, office, or Clan social status affects play | `rules/campaign/power-rank-and-title.md`, `rules/campaign/reputation.md`, `rules/campaign/contacts.md` | Pass: route handles authority, jurisdiction, obligation, and source lookup for exact tables/lists. |
| PCs arrive on a new world | `gm/universal-aesthetics.md`, `gm/touring-the-stars.md`, `gm/whistle-stop-tour.md`, active `campaigns/<campaign-id>/locations.md` | Pass: route supports table-useful world texture, socio-industrial lookup, and campaign-local profile creation without copying world profiles. |

## Copyright And Source Boundary

- No faction essays, adventure seed entries, world profiles, title/rank tables, NPC templates, encounter tables, equipment kits, trait recommendations, or source prose were copied into committed files.
- New files use paraphrased procedures, original scaffolds, and source page references.
- Raw PDFs and extracted page text remain under ignored protected paths and must not be staged.

## Verification Plan

- `./scripts/validate-rules-indexes.ps1`
- `./scripts/report-rules-coverage.ps1`
- `git diff --check`
- `git check-ignore source/atow-pdf/example.pdf`
- `git check-ignore source/atow-text/page-001.txt`
- `./scripts/test-all.ps1`

## Status

Validation note for issue `#64`. Script results should be recorded in the issue close-out after index updates are complete.
