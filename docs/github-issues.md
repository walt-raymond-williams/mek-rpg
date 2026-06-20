# GitHub Issue Workflow

Use GitHub issues to track project milestones and source-processing work.

Recommended flow:

1. Create an issue for each major task in `issues/initial-issues.md`.
2. Work one issue at a time.
3. Commit small logical changes.
4. Reference issue numbers in commits when useful.
5. Close issues only after files are updated, reviewed, and committed.

If `gh` is available and authenticated, create issues with:

```sh
gh issue create --title "Create project scaffolding" --body "Create the initial MEK RPG project structure, docs, indexes, and agent instructions."
```

If the repo is not connected to GitHub, keep using `issues/initial-issues.md` as the local backlog until a remote is configured.
