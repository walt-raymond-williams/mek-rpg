# Agent Handoff

## Issue

- GitHub issue: `#64` Source-review GM and campaign orientation gaps
- Roadmap entry: Next rules source-review expansion wave
- Mode: Source processing / project development
- Priority: Fifth child issue in the rules expansion wave

## Goal

Create table-useful, paraphrased GM and campaign-orientation procedures from mapped-only setting and GM guidance without recreating lore sections or adventure text.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/SOURCE_PROCESSING_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#64`

Task-specific context:

- `indexes/manifest.yaml`
- `indexes/page-reference-index.md`
- `indexes/task-router.md`
- `indexes/term-glossary.md`
- `gm/session-procedure.md`
- `gm/scene-loop.md`
- `gm/roll-policy.md`
- `gm/mission-template.md`
- `gm/tactical-encounter-handoff-checklist.md`
- `campaign-state/setting-basics.md`

## Expected Output

- Source-reviewed, paraphrased procedures or routing aids for:
  - `universe.intro-to-play`
  - `universe.factions-history`
  - `gm.battletech-source-handoff`
  - `gm.rules-adjudication-posture`
  - `gamemastering.npcs-encounters`
  - `gm.tips-stories`
  - `gm.adventure-seeds-map`
  - `campaign.power-rank-title`
  - `gm.universal-aesthetics`
  - `gm.touring-stars`
  - `gm.whistle-stop-tour`
- Updated router, page-reference index, rules map, and manifest entries where appropriate.
- A validation note showing how these files should support play setup, NPC/encounter framing, faction/rank questions, and setting orientation.

## Files And Areas

Likely files to read or edit:

- `rules/universe/intro-to-play.md`
- `rules/universe/factions-and-history.md`
- `gm/battletech-source-handoff.md`
- `gm/rules-adjudication-posture.md`
- `rules/gamemastering/npcs-and-encounters.md`
- `gm/gamemastering-tips.md`
- `gm/adventure-seeds-map.md`
- `rules/campaign/power-rank-and-title.md`
- `gm/universal-aesthetics.md`
- `gm/touring-the-stars.md`
- `gm/whistle-stop-tour.md`
- `indexes/task-router.md`
- `indexes/page-reference-index.md`
- `indexes/rules-map.md`
- `indexes/manifest.yaml`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- this handoff

## Commands

Useful commands or checks:

```powershell
git status --short --branch
./scripts/validate-rules-indexes.ps1
./scripts/report-rules-coverage.ps1
./scripts/test-all.ps1
git check-ignore source/atow-pdf/example.pdf
git check-ignore source/atow-text/page-001.txt
```

## Constraints

- This issue explicitly permits source-processing work for the scoped source ranges only.
- Do not reproduce lore prose, adventure seed text, world profiles, faction essays, tables, or long setting passages.
- Prioritize play procedures, routing, uncertainty labels, page references, and brief campaign-facing orientation.
- Keep canon-heavy questions marked as lookup or table-canon decisions where the committed summaries are intentionally thin.

## Acceptance Criteria

- Correct mode identified.
- Scoped source pages reviewed.
- Outputs are paraphrased, page-referenced, and table-useful.
- Router, page-reference index, rules map, and manifest stay consistent.
- Validation or scenario checks are recorded.
- Raw source files remain ignored and unstaged.
- Roadmap, task state, and handoff are updated.
- Changes are committed and pushed.

## Open Questions

- Resolved for issue `#64`: adventure seed and world-tour material stayed as sparse routing maps. `gm/adventure-seeds-map.md` includes only an original table scaffold and source-page route; `gm/whistle-stop-tour.md` avoids summarizing individual world profiles.

## Completion Notes

- Added source-reviewed routing aids and procedures for all scoped mapped entries.
- Updated `indexes/task-router.md`, `indexes/page-reference-index.md`, `indexes/rules-map.md`, `indexes/subsystem-index.md`, and `indexes/manifest.yaml`.
- Added `docs/current/GM_CAMPAIGN_ORIENTATION_SOURCE_REVIEW_VALIDATION.md`.
- Updated GM/campaign entry points so source handoff, adjudication, NPC/encounter, rank/title, and world-orientation routes are discoverable during play.
- Preserved the copyright boundary: no lore prose, seed entries, world profiles, source tables, NPC templates, equipment kits, rank lists, or trait recommendations were copied into committed docs.
