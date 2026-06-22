# Agent Handoff

## Issue

- GitHub issue: `#90`
- Roadmap entry: Next rules source-review expansion wave
- Mode: Project development / source processing coordination
- Priority: High

## Goal

Coordinate the next small rules/source-review wave after the completed bridge, deterministic mechanics, and checkpoint adapter tracks.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md`
- `indexes/manifest.yaml`
- `indexes/page-reference-index.md`
- `source/atow-chapter-section-map.md`

## Expected Output

- Keep child issues `#91`-`#94` aligned with roadmap and task state.
- Confirm child issue order remains sensible as source review discovers gaps.
- Archive this handoff after the wave is complete and all child issues are closed.

## Files And Areas

Likely files to read or edit:

- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/handoffs/active/`
- `docs/handoffs/archive/`
- GitHub issues `#90`-`#94`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
gh issue list --state open --limit 100
./scripts/test-all.ps1
```

## Constraints

- Route the task into the correct mode before editing.
- Do not include unrelated user changes.
- Do not commit purchased PDFs, raw extracted text, copied tables, stat blocks, or copyrighted rulebook passages.
- Preserve uncertainty, manifest authority labels, and page references in rules work.
- Commit and push completed project-development changes unless explicitly told not to.

## Acceptance Criteria

- Epic `#90` clearly tracks the wave.
- Child issues `#91`-`#94` have current handoffs and dependency order.
- `ROADMAP.md` and `TASKS.md` match GitHub issue state.
- No protected raw source is staged.

## Open Questions

- If source review shows the planned scope is too broad, split follow-up issues rather than expanding a child issue indefinitely.

## Completion Notes

- Completed after child issues `#91`, `#92`, `#93`, and `#94` were committed, pushed, and closed.
- Wave outputs:
  - `rules/campaign/advancement-and-rewards.md`
  - `docs/current/ADVANCEMENT_REWARDS_SOURCE_REVIEW_VALIDATION.md`
  - `docs/current/SPECIAL_CASE_RULES_SOURCE_REVIEW_VALIDATION.md`
  - `docs/current/SPECIAL_EQUIPMENT_SOURCE_REVIEW_VALIDATION.md`
  - `docs/current/NEXT_WAVE_RULES_AUTHORITY_VALIDATION.md`
- Planning state now records the wave as done in `docs/current/ROADMAP.md` and `docs/current/TASKS.md`.
- Protected raw source paths remained ignored and unstaged throughout the wave.
