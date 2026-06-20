# Summarize Core Resolution Rules

## Issue

- GitHub issue: https://github.com/walt-raymond-williams/mek-rpg/issues/5
- Roadmap entry: Summarize core resolution rules
- Mode: Source processing / project development
- Priority: High
- Status: Blocked until issue `#4` maps core resolution source ranges

## Goal

Create GM-ready, paraphrased core resolution rule summaries for the first live-play layer: task checks, opposed checks, modifiers, and margin of success.

These summaries should let a GM assistant decide when to call for a roll, how to frame the procedure, what page references support the ruling, and when uncertainty requires source review.

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
- GitHub issue `#4` output and committed map
- GitHub issue `#5` body

## Blocker

Do not start summary authoring until issue `#4` is complete and has produced a chapter/section map with core resolution page ranges and candidate summary targets.

## Expected Output

- Focused paraphrased summaries for core resolution topics, likely including task checks, opposed checks, modifiers, and margin of success.
- Each summary should include:
  - `Purpose`
  - `When to Use`
  - `Do Not Use For`
  - `Basic Procedure`
  - `Practical GM Guidance`
  - `Common Edge Cases`
  - `Related Files`
  - `Source References`
  - `Status`
- Router/index updates needed for live lookup, including `indexes/task-router.md`, `indexes/page-reference-index.md`, `indexes/rules-map.md`, `indexes/subsystem-index.md`, and `indexes/manifest.yaml` as relevant.
- Any unresolved source ambiguity marked `Needs source review`, `Unknown`, or `TBD` with page references.
- Updated `docs/current/ROADMAP.md` and `docs/current/TASKS.md` with completion status and the next recommended issue.

## Files And Areas

Likely files to read:

- The chapter/section map produced by issue `#4`
- Relevant ignored `source/atow-text/page-####.txt` files identified by the map
- Existing `rules/`, `indexes/`, and `gm/` docs for local conventions

Likely files to edit:

- Focused files under `rules/`
- `indexes/task-router.md`
- `indexes/page-reference-index.md`
- `indexes/rules-map.md`
- `indexes/subsystem-index.md`
- `indexes/manifest.yaml`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- This handoff, moved to `docs/handoffs/archive/` after completion

## Commands

Useful checks:

```powershell
git status --short --branch
git check-ignore source/atow-pdf/example.pdf source/atow-text/page-0001.txt
git status --short
```

## Constraints

- Do not write summaries from memory when project source mapping exists.
- Do not copy source prose, tables, or long verbatim passages.
- Keep summaries concise, paraphrased, procedural, and page-referenced.
- Preserve uncertainty with `Needs source review`, `Unknown`, or `TBD`.
- Confirm raw source files are ignored and unstaged before committing.

## Acceptance Criteria

- Correct mode identified as Source processing / project development.
- Issue `#4` map is complete and used to choose source pages.
- Core resolution summaries exist and follow the standard schema.
- Router, page-reference index, subsystem/rules map, and manifest are updated as relevant.
- No copyrighted source text or raw extracted text is committed.
- Lookup-oriented verification is run or a blocker is recorded.
- Roadmap and task state are updated.
- Handoff is archived after completion.
- Changes are committed and pushed.

## Open Questions

- Exact summary file paths and manifest IDs should follow the issue `#4` map.
- Final status labels may be `draft`, `needs source review`, or `verified` depending on source confidence and validation.
