# Add Equipment Minimum Summaries

## Issue

- GitHub issue: https://github.com/walt-raymond-williams/mek-rpg/issues/9
- Roadmap entry: Add equipment minimum summaries
- Mode: Source processing / project development
- Priority: Medium
- Status: Ready after personal combat minimum, or earlier if gear lookup blocks play

## Goal

Create the minimum equipment lookup layer needed for early play: acquiring/using gear, weapons, armor/protection, medical gear, electronics, and personal gear needed for common missions.

The output should help a GM answer gear-selection and gear-use questions without reproducing equipment tables.

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
- GitHub issue `#9`

## Source Selector

Use `source/atow-chapter-section-map.md` as the selector. Relevant mapped ranges include:

- `atow.equipment.overview-acquisition`: PDF pages 256-261 / printed pages 254-259
- `atow.equipment.weapons`: PDF pages 262-288 / printed pages 260-286
- `atow.equipment.armor-protection`: PDF pages 289-300 / printed pages 287-298
- `atow.equipment.electronics`: PDF pages 302-307 / printed pages 300-305
- `atow.equipment.power-misc-health`: PDF pages 308-315 / printed pages 306-313

Treat catalog/table-heavy material as page-referenced lookup guidance, not copied item lists.

## Expected Output

- Paraphrased equipment summaries under `rules/equipment/`.
- Router/index/page-reference/manifest updates.
- Clear guidance for when exact item stats require inspecting the legally owned source.
- Links from combat summaries where weapons, armor, or medical gear matter.
- Updated roadmap/tasks and archived handoff.

## Files And Areas

Likely files to read:

- `rules/equipment/*.md`
- `rules/personal-combat/*.md`
- `indexes/task-router.md`
- `indexes/page-reference-index.md`
- `indexes/manifest.yaml`

Likely files to edit:

- `rules/equipment/*.md`
- `indexes/task-router.md`
- `indexes/page-reference-index.md`
- `indexes/rules-map.md`
- `indexes/subsystem-index.md`
- `indexes/manifest.yaml`
- related combat summaries, if cross-links are needed
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

```powershell
git status --short --branch
git check-ignore source/atow-pdf/example.pdf source/atow-text/page-0001.txt
```

## Constraints

- Do not summarize from memory.
- Do not copy source prose, equipment tables, item lists, or stat blocks.
- Use page references for exact gear stats and table lookups.
- Use at least two sub-agent reviewers before commit when available.
- Confirm protected source paths remain ignored and unstaged.

## Acceptance Criteria

- Correct mode identified as Source processing / project development.
- Required docs, issue body, section map, and handoff read before editing.
- Equipment summaries follow the standard schema.
- Table-heavy item details are page-referenced, not reproduced.
- Routing indexes and manifest updated.
- Raw source files remain ignored and unstaged.
- Roadmap/task state updated and handoff archived.
- Changes committed, pushed, and issue updated/closed.

## Open Questions

- Whether medical gear should be summarized here or deferred until recovery/campaign consequences expose the exact live-play need.
