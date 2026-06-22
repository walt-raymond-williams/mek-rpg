# Agent Handoff

## Issue

- GitHub issue: `#91`
- Roadmap entry: Next rules source-review expansion wave
- Mode: Source processing / project development
- Priority: High; first executable child issue in the wave

## Goal

Review the GM advancement/rewards source range and strengthen committed campaign advancement coverage without copying tables or treating unsupported details as rules authority.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md`
- `indexes/task-router.md`
- `indexes/page-reference-index.md`
- `indexes/manifest.yaml`
- `source/atow-chapter-section-map.md`
- `rules/campaign/advancement.md`
- `rules/character-creation/xp-advancement.md`
- `rules/campaign/power-rank-and-title.md`

## Expected Output

- Add a focused `rules/campaign/advancement-and-rewards.md` summary or document why existing files should remain the owning summaries.
- Update `indexes/task-router.md`, `indexes/rules-map.md`, `indexes/subsystem-index.md`, `indexes/page-reference-index.md`, and `indexes/manifest.yaml` as needed.
- Preserve exact reward, wealth, rank, and table values as private source lookup only.

## Files And Areas

Likely files to read or edit:

- `rules/campaign/advancement-and-rewards.md`
- `rules/campaign/advancement.md`
- `rules/character-creation/xp-advancement.md`
- `rules/campaign/power-rank-and-title.md`
- `indexes/task-router.md`
- `indexes/rules-map.md`
- `indexes/subsystem-index.md`
- `indexes/page-reference-index.md`
- `indexes/manifest.yaml`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
./scripts/validate-rules-indexes.ps1
./scripts/test-route-rules-prompt.ps1
./scripts/test-all.ps1
```

## Constraints

- This issue may use private ignored source text only for the scoped source-review work.
- Do not commit raw source, copied tables, copied examples, stat blocks, or long source passages.
- Summaries must be paraphrased, procedural, page-referenced, and honest about unsupported details.
- Do not make table values look deterministic if they remain private lookup.

## Acceptance Criteria

- The remaining `campaign.advancement-rewards` partial-draft gap is resolved or explicitly reclassified.
- Router and manifest authority labels match the resulting coverage.
- Validation records common prompts for rewards, training, aging, salary/wealth/property, and rank/power.
- No protected raw source is staged.

## Open Questions

- Should advancement/rewards become a new standalone summary or be folded into the existing advancement, XP, and power/rank summaries?
