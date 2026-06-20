# Agent Handoff

## Issue

- GitHub issue: `#21` Summarize character creation foundation
- Roadmap entry: Summarize character creation foundation
- Mode: Source processing / project development
- Priority: High

## Goal

Create source-reviewed, paraphrased character creation foundation summaries for lifepaths, attributes, traits, skills, XP, and advancement routing.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/SOURCE_PROCESSING_WORKFLOW.md`
- `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md`
- `docs/current/TASKS.md`
- `source/atow-chapter-section-map.md`
- `indexes/task-router.md`
- `indexes/page-reference-index.md`
- `indexes/manifest.yaml`

## Expected Output

- Paraphrased summaries under a suitable character-creation rules path.
- Router, rules map, subsystem index, page-reference index, and manifest updates.
- Scenario lookup checks for starting a PC, choosing lifepath/attributes, and identifying sheet gaps.
- A validator-maintenance decision: update `scripts/validate-campaign-state.ps1`, create a future character-output validator, or document why deterministic validation is deferred.

## Files And Areas

Likely files to read or edit:

- `rules/character-creation/`
- `indexes/task-router.md`
- `indexes/rules-map.md`
- `indexes/subsystem-index.md`
- `indexes/page-reference-index.md`
- `indexes/manifest.yaml`
- `campaigns/_template/` only if character-save structure changes
- `scripts/validate-campaign-state.ps1` only if shared campaign save structure changes

## Commands

Useful commands or checks:

```powershell
git status --short --branch
git check-ignore source/atow-pdf/example.pdf source/atow-text/page-0001.txt
./scripts/validate-campaign-state.ps1 -CampaignId playtest-galatea-dropship
```

## Constraints

- Source processing must be explicit before reading ignored extracted source text.
- Do not commit PDFs, extracted raw text, copied tables, or large verbatim source passages.
- Use paraphrase, procedure summaries, original examples, and page references.
- Keep exact table-heavy character creation details page-referenced when needed.

## Acceptance Criteria

- Character creation foundation summaries use the standard summary schema.
- Lifepaths, attributes, traits, skills, XP, and advancement routing are covered or explicitly marked as gaps.
- Indexes and manifest route to the new summaries.
- Character-sheet implications and validator-maintenance decision are documented.
- Scenario lookup checks are recorded.
- No protected raw source is staged.
- Changes are committed and pushed.

## Open Questions

- Should character sheets live as sections inside `pcs.md` initially, or as separate files once a real campaign needs them?
