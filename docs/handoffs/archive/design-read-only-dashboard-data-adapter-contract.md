# Agent Handoff

## Issue

- GitHub issue: `#57` Design read-only dashboard data adapter contract
- Roadmap entry: Read-only MEK-RPG dashboard future feature
- Mode: Project development / architecture
- Priority: Depends on issue `#56`

## Goal

Design a read-only data adapter/API contract for a future MEK-RPG dashboard, using committed campaign files and optional sanitized MekHQ summary outputs.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issues `#56` and `#57`

Task-specific context:

- Issue `#56` output
- `campaign-state/active-campaign.md`
- `campaigns/README.md`
- `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md`
- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`

## Expected Output

- Contract/design doc under `docs/current/`.
- Sample JSON shape if useful.
- Roadmap and task updates.

## Files And Areas

Likely files to read or edit:

- `docs/current/READ_ONLY_DASHBOARD_DATA_CONTRACT.md` or similar
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
rg -n "active-campaign|campaigns/|MekHQ|summary|dashboard|read-only" docs campaigns scripts
git diff --check
git status --short --branch
```

## Constraints

- Stay read-only.
- Do not read raw MekHQ saves in the dashboard layer.
- Do not include ignored raw source text or purchased PDFs.
- Do not implement the frontend in this issue.

## Acceptance Criteria

- Defines inputs from active campaign pointer and campaign save folder.
- Defines optional MekHQ summary inputs without raw-save reads.
- Defines error and warning cases for missing or stale files.
- Preserves protected source boundaries.
- Records implementation follow-up issues only after the contract is clear.

## Open Questions

- Should the contract be file-based JSON, local HTTP, or intentionally undecided until implementation?
