# GitHub Issue Workflow

Use GitHub Issues for executable project development work, source-processing milestones, and agent handoffs. Use `docs/current/ROADMAP.md` for durable planning and `docs/current/TASKS.md` for current work state.

## Operating Model

- `ROADMAP.md` is the durable planning source.
- GitHub Issues are execution units.
- `TASKS.md` shows what is now, next, blocked, backlog, and recently done.
- Handoff documents give agents enough context to work a specific issue.
- Active handoffs live in `docs/handoffs/active/`.
- Completed handoffs move to `docs/handoffs/archive/` after issue close-out.
- Durable decisions belong in `docs/current/`, not only in an issue or handoff.

For this private repo, direct commits to `master` are acceptable for small coherent tasks unless the user requests a feature branch. Use a feature branch for broad, risky, or multi-issue work that should be reviewed as a unit.

## Before Creating Issues

Run:

```powershell
git status --short --branch
git remote -v
gh auth status
```

Then choose a roadmap entry that is ready for execution. Do not create every future issue at once when later source review may change the work.

## Creating An Issue

Use `.github/ISSUE_TEMPLATE/agent-task.md` for agent-executed work. Recommended body:

```markdown
## Goal

## Context

## Expected Output

## Handoff

## Dependencies / Blockers

## Acceptance Criteria
```

After creating an issue:

1. Update the roadmap entry with status and issue number.
2. Create or update an active handoff if an agent needs more context than the issue body.
3. Move immediate work into `TASKS.md`.
4. Commit and push the tracking changes.

Use the `user-task` label if the task can only be completed by the user, such as placing a legally owned PDF locally or approving a campaign-sensitive decision.

## Handoff Lifecycle

Use one handoff per agent-executed issue:

1. Create it from `docs/templates/AGENT_HANDOFF.md`.
2. Save it under `docs/handoffs/active/`.
3. Link it from the GitHub issue.
4. Keep it current while the issue is active.
5. Move durable findings into `docs/current/`, `gm/`, `indexes/`, or `rules/`.
6. Move the handoff to `docs/handoffs/archive/` after the issue is complete, committed, pushed, and documented.

## Completion

For project development issues:

1. Update changed docs, indexes, task state, and handoff status.
2. Run relevant verification or record a blocker.
3. Use sub-agent review before commit only when it materially improves substantial or high-risk work. Do not use a dedicated copyright reviewer by default; the main agent handles the source-boundary checklist by confirming summaries are paraphrased, page-referenced, and free of staged raw source files. Use two reviewers only for broad workflow changes, complex implementation, large continuity-sensitive edits, or explicit user requests. Do not let unavailable sub-agent tooling block close-out.
4. Confirm no protected raw source is staged.
5. Commit a coherent change, referencing the issue when practical.
6. Push to the tracked branch.
7. Confirm the branch is not ahead of upstream.
8. Comment on or close the GitHub issue with the commit hash and verification result.

Do not close an issue based only on an unpushed local commit.

## Current Local State

- `Confirmed locally`: `origin` points to this repository on GitHub.
- `Confirmed locally`: `master` tracks `origin/master`.
- `Confirmed locally`: GitHub labels `agent-task` and `user-task` exist.
- `Confirmed locally`: GitHub issue `#1` completed the workflow-hardening pass from MegaMek workspace patterns.
- `Confirmed locally`: No PDF processing was performed during issue `#1`.
