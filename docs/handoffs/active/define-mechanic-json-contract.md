# Agent Handoff

## Issue

- GitHub issue: `#72`
- Roadmap entry: `docs/current/ROADMAP.md` > Ruling safety and deterministic mechanics maturation
- Mode: Project development
- Priority: P0

## Goal

Define the standard JSON input/output contract for deterministic mechanic helpers, including the authority envelope needed for safe rulings.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/current/DETERMINISTIC_MECHANICS_CATALOG.md` if issue `#71` is complete
- `indexes/manifest.yaml`
- `indexes/page-reference-index.md`
- `scripts/README.md`
- GitHub issues `#72`, `#80`, and `#78`

## Expected Output

- New durable schema doc, likely `docs/current/MECHANIC_CONTRACT_SCHEMA.md`.
- Examples for basic check, opposed check, source-lookup-required, and cannot-adjudicate outputs.
- Roadmap and task state updated.

## Files And Areas

Likely files to read or edit:

- `docs/current/MECHANIC_CONTRACT_SCHEMA.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `scripts/README.md` only if command or contract references are added

## Commands

Useful commands or checks:

```powershell
./scripts/test-all.ps1
git status --short --branch
```

## Constraints

- Do not implement broad mechanic resolvers in this issue.
- Contract examples must be original and paraphrased; no copied source rules or tables.
- Include no-hidden-mutation proof fields so helpers cannot silently edit campaign files.

## Acceptance Criteria

- Contract defines input fields, output fields, authority envelope, warnings, citations, failure modes, proposed state changes, and unresolved questions.
- Contract aligns with issue `#80` authority gate and issue `#78` state-change proposal needs.
- Verification is run or blocker recorded.

## Open Questions

- Whether contract examples should be strict JSON snippets or schema-like field lists with JSON examples.
