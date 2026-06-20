# Summarize Personal Combat And Recovery Minimum

## Issue

- GitHub issue: https://github.com/walt-raymond-williams/mek-rpg/issues/7
- Roadmap entry: Summarize personal combat and recovery minimum
- Mode: Source processing / project development
- Priority: High
- Status: Complete

## Goal

Create the first playable personal-combat rules layer: initiative, combat turn flow, movement/action basics, ranged attacks, melee attacks, damage, wounds/effects, end phase, and healing/recovery.

The summaries should be paraphrased, page-referenced, routed, and usable by a GM assistant during a small RPG-scale fight.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/SOURCE_PROCESSING_WORKFLOW.md`
- `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `source/extraction-notes.md`
- `source/atow-chapter-section-map.md`
- GitHub issue `#7`

## Source Selector

Use `source/atow-chapter-section-map.md` as the selector. Likely mapped targets:

- `atow.combat.turn-overview`: PDF page 166 / printed page 164
- `atow.combat.initiative`: PDF pages 166-168 / printed pages 164-166
- `atow.combat.action-movement`: PDF pages 168-172 / printed pages 166-170
- `atow.combat.ranged`: PDF pages 173-176 / printed pages 171-174
- `atow.combat.melee`: PDF pages 177-179 / printed pages 175-177
- `atow.combat.damage-resolution`: PDF pages 179-184 / printed pages 177-182
- `atow.combat.damage-effects`: PDF pages 184-187 / printed pages 182-185
- `atow.combat.end-phase`: PDF page 191 / printed page 189
- `atow.combat.healing-recovery`: PDF pages 194-197 / printed pages 192-195

Consult only mapped private source pages under ignored `source/atow-text/`. If a needed page range is unclear, record `Needs source review` instead of widening scope casually.

## Expected Output

- Paraphrased summaries under the existing personal-combat rules area.
- Candidate summaries should cover overview/turn flow, initiative, actions/movement, ranged attacks, melee attacks, damage, wounds/effects, end phase, and healing/recovery.
- Each summary should include `Purpose`, `When to Use`, `Do Not Use For`, `Basic Procedure`, `Practical GM Guidance`, `Common Edge Cases`, `Related Files`, `Source References`, and `Status`.
- Update `indexes/task-router.md`, `indexes/page-reference-index.md`, `indexes/rules-map.md`, `indexes/subsystem-index.md`, and `indexes/manifest.yaml`.
- Keep tactical BattleTech handoff explicit when exact facing, hex movement, heat, armor locations, unit initiative, or full tactical turns matter.
- Update `docs/current/ROADMAP.md` and `docs/current/TASKS.md`.
- Archive this handoff after completion.

## Files And Areas

Likely files to read:

- `rules/core/*.md`
- `rules/personal-combat/*.md`
- `gm/switch-to-classic-battletech.md`
- `indexes/task-router.md`
- `indexes/page-reference-index.md`
- `indexes/manifest.yaml`

Likely files to edit:

- `rules/personal-combat/*.md`
- `indexes/task-router.md`
- `indexes/page-reference-index.md`
- `indexes/rules-map.md`
- `indexes/subsystem-index.md`
- `indexes/manifest.yaml`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- this handoff, moved to `docs/handoffs/archive/`

## Commands

Useful checks:

```powershell
git status --short --branch
git check-ignore source/atow-pdf/example.pdf source/atow-text/page-0001.txt
git diff --cached --name-only | Select-String -Pattern '^(source/atow-pdf/|source/atow-text/|.*\.pdf$|.*\.epub$)'
```

## Constraints

- Do not summarize from memory.
- Do not copy source prose, tables, examples, item/stat lists, or long verbatim passages.
- Use page references for table-heavy procedures.
- Mark uncertainty as `Needs source review`, `Unknown`, or `TBD`.
- Use at least two sub-agent reviewers before commit when available, because this is source-processing plus copyright-sensitive summary work.
- Confirm protected source paths remain ignored and unstaged before commit.

## Acceptance Criteria

- Correct mode identified as Source processing / project development.
- Required project docs, issue body, section map, and this handoff read before editing.
- Only mapped private source pages are consulted.
- Personal combat/recovery summaries follow the standard schema.
- Routing indexes and manifest entries are updated.
- Tactical BattleTech handoff remains explicit.
- Table-heavy details are page-referenced, not reproduced.
- Two sub-agent reviews completed or tool unavailability recorded.
- Raw source files are ignored and not staged.
- Roadmap/task state updated and handoff archived.
- Changes committed, pushed, and issue updated/closed.

## Open Questions

- Resolved: used the existing live `rules/personal-combat/` directory rather than creating a parallel `rules/combat/` tree.

## Completion Notes

- Added draft, paraphrased summaries for personal combat overview, initiative, action and movement, ranged attacks, melee attacks, damage, wounds/effects, end phase, and healing/recovery.
- Updated live lookup files: `indexes/task-router.md`, `indexes/page-reference-index.md`, `indexes/rules-map.md`, `indexes/subsystem-index.md`, and `indexes/manifest.yaml`.
- Kept tactical BattleTech handoff explicit in summaries and routing.
- Two sub-agent reviews completed before commit:
  - Copernicus: routing/completeness review, no blocking findings.
  - Socrates: source-boundary/copyright review, no blocking findings.
