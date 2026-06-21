# Agent Handoff

## Issue

- GitHub issue: `#53` Summarize transport acquisition and large-asset procedures
- Roadmap entry: DropShip and large-asset rules gap
- Mode: Source processing / rules summary
- Priority: Depends on issue `#52`

## Goal

Create paraphrased, page-referenced summaries for transport acquisition and large-asset procedures if issue `#52` confirms useful source coverage.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/SOURCE_PROCESSING_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issues `#52` and `#53`

Task-specific context:

- Issue `#52` output
- `indexes/task-router.md`
- `indexes/page-reference-index.md`
- `indexes/manifest.yaml`
- Existing campaign, equipment, and vehicle summaries

## Expected Output

- New or updated paraphrased summaries under `rules/`.
- Router, page-reference, manifest, and roadmap/task updates.

## Files And Areas

Likely files to read or edit:

- `rules/equipment/`
- `rules/campaign/`
- `rules/vehicles-and-mechs/`
- `indexes/task-router.md`
- `indexes/page-reference-index.md`
- `indexes/manifest.yaml`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
rg -n "DropShip|transport|large asset|ownership|maintenance|crew|fuel|wealth|property" rules indexes docs/current
git diff --check
git check-ignore source/atow-pdf/example.pdf
git check-ignore source/atow-text/page-001.txt
```

## Constraints

- Do not proceed if issue `#52` shows insufficient source coverage; record the blocker.
- Do not copy exact prices, tables, catalogs, stat blocks, or raw source text.
- Mark unsupported areas as table ruling, external BattleTech/MekHQ, or needs source review.

## Acceptance Criteria

- Summaries are paraphrased and page-referenced.
- Router and manifest updates point to the new coverage where appropriate.
- Unsupported areas remain clearly marked.
- No protected raw source is committed.
- Changes are committed and pushed.

## Open Questions

- Should the summary live under equipment, campaign, vehicles, or a cross-linked combination?
