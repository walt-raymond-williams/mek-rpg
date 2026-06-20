# Documentation Workflow

This workspace depends on documentation as operational memory. Update docs when a discovery changes how future agents should run the campaign, answer rules questions, process source material, or develop the project.

## Documentation Roles

- `AGENTS.md`: mandatory agent behavior, mode routing, safety posture, and close-out rules.
- `README.md`: human orientation and quick start.
- `docs/current/`: current durable knowledge and workflows.
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`: reusable workflow pattern for this AI-ready workspace.
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`: domain profile, protected inputs, mode router, GM posture, and BattleTech integration.
- `docs/current/ROADMAP.md`: durable planning source and issue candidates.
- `docs/current/TASKS.md`: active work board.
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`: GitHub issue and handoff lifecycle.
- `docs/current/SOURCE_PROCESSING_WORKFLOW.md`: PDF extraction, section mapping, paraphrased summary, and validation workflow.
- `docs/current/KNOWN_COMMANDS.md`: repeatable commands.
- `docs/handoffs/active/`: active per-issue handoffs.
- `docs/handoffs/archive/`: completed handoffs.
- `docs/templates/`: reusable handoff and report templates.
- `indexes/`: routing, page references, subsystem indexes, glossary, and manifest.
- `rules/`: paraphrased, page-referenced rule summaries.
- `gm/`: GM procedures and table-facing play guidance.
- `campaign-state/`: campaign-specific state and session logs.
- `source/`: ignored local source inputs plus committed extraction notes.

Prefer one current owner for each fact. Link rather than duplicate when a fact belongs elsewhere.

## When To Update Docs

Update durable docs when any of these change:

- mode routing or close-out expectations
- roadmap priorities, issue candidates, or task state
- confirmed rules-summary coverage or known summary gaps
- source-processing procedure, page offset assumptions, or validation status
- campaign state that should survive future sessions
- GM procedures or tactical handoff criteria
- repeatable commands or local setup checks
- protected-input boundaries or copyright posture

Do not record every temporary observation. Record discoveries likely to matter again.

## Evidence Labels

Use explicit evidence labels where uncertainty matters:

- `Confirmed from summary`: verified in a committed paraphrased summary.
- `Confirmed from source reference`: page reference exists, but the committed summary may be incomplete.
- `Confirmed by user`: stated by the user as campaign fact or preference.
- `Inferred`: reasonable conclusion from available evidence, not yet verified.
- `Unknown`: intentionally tracked gap.
- `Needs source review`: likely answer requires checking the legally owned source.

Do not smooth over uncertainty in rules answers or durable docs.

## Update Sequence

1. Identify the durable change.
2. Choose the narrowest owning doc.
3. Add concise content with source references, evidence labels, or uncertainty markers where needed.
4. Update `TASKS.md` when work state changes.
5. Update `ROADMAP.md` when planning or issue status changes.
6. Update handoffs when execution context changes.
7. Update `AGENTS.md` if agent behavior changes.
8. Update `README.md` if human onboarding changes.
9. Run a consistency check.
10. Commit and push development-mode changes unless instructed otherwise.

## Consistency Check

Before committing documentation changes, check:

- paths match this repository
- old docs do not contradict `docs/current/`
- raw PDFs and extracted text are not staged
- summaries remain paraphrased and page-referenced
- open questions remain accurate
- task and roadmap status match the GitHub issue state

Useful command:

```powershell
git status --short --branch
```
