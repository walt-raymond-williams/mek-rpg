# Agent Handoff

## Issue

- GitHub issue: `#26` Define MekHQ bridge data model and campaign-folder mapping
- Roadmap entry: MekHQ-to-MEK-RPG campaign bridge epic
- Mode: Project development / design
- Priority: High

## Goal

Define the first MEK-RPG bridge data model for read-only MekHQ campaign imports: which facts MekHQ owns, which facts MEK-RPG owns, how imported facts map into campaign save files, and how uncertainty and IDs should be preserved.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#26`
- `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`
- `campaigns/README.md`
- `campaigns/_template/`
- `gm/switch-to-classic-battletech.md`
- `rules/campaign/contracts.md`
- `C:\Users\waltr\Documents\megamek-workspace\docs\current\MEK_RPG_MEKHQ_COLLABORATION_BRIEF.md`
- `C:\Users\waltr\Documents\megamek-workspace\docs\current\MEK_RPG_MEKHQ_INTEGRATION_ASSESSMENT.md`

## Expected Output

- A focused design note under `docs/current/` that defines:
  - MekHQ-owned hard facts.
  - MEK-RPG-owned narrative and A Time of War facts.
  - Campaign-file mapping for date, location, funds, personnel, units, assets, contracts, scenarios, repairs, logistics alerts, and markets.
  - Overlay mapping for PCs, NPC memory, relationships, hooks, missions, session logs, rules gaps, and safety/tone.
  - MekHQ ID preservation and MEK-RPG slug strategy.
  - Unknown/unsupported field handling.
  - Read-only import boundary and explicit non-goals.
- Roadmap and task-board updates if the issue sequence changes.
- Any issue-body dependency fixes discovered while doing the mapping.

## Files And Areas

Likely files to read or edit:

- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- new design note in `docs/current/`
- `campaigns/README.md` only if the bridge convention affects campaign-folder guidance
- `scripts/README.md` only if a script convention is added
- GitHub issue `#26`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
gh issue view 26 --json number,title,state,body
gh issue view 25 --json number,title,state,body
git check-ignore source/atow-pdf/example.pdf source/atow-text/page-0001.txt
git diff --check
```

Representative disposable MekHQ saves exist under `C:\Users\waltr\Documents\megamek-workspace\`, but issue `#26` should not parse them unless field examples are useful. Save parsing belongs primarily to issue `#27`.

## Constraints

- Keep MekHQ as the hard logistics and tactical ledger.
- Keep MEK-RPG as the RPG memory, A Time of War character, scene, relationship, and safety/tone layer.
- Do not write to MekHQ saves.
- Do not promote direct MekHQ save editing, headless day advancement, or automatic purchases/contracts/repairs as current implementation tasks.
- Preserve uncertainty when a MekHQ field is not source-confirmed or not inspected.
- Do not commit purchased PDFs, raw extracted text, or raw copied rulebook passages.

## Acceptance Criteria

- Done: correct mode identified.
- Done: `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md` maps campaign date, location, funds, personnel, units, assets, contracts, scenarios, repairs, logistics alerts, and markets.
- Done: design note maps MEK-RPG overlays for PCs, NPC memory, relationships, hooks, missions, session logs, rules gaps, and safety/tone.
- Done: ID preservation and MEK-RPG slug strategy are explicit.
- Done: unknown and unsupported mappings are marked clearly.
- Done: read-only boundary and unsafe/deferred write paths are explicit non-goals.
- Done: roadmap and task state updated for issue completion.
- Done: verification run at close-out.
- Done: no protected raw source committed.
- Done: changes committed and pushed.

## Completion

- Design note: `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- Roadmap update: issue `#26` moved to Done and dependency order now points issues `#27`-`#29` at the design note.
- Task-board update: issue `#26` moved from Now to Done.

## Open Questions

- Should the bridge metadata live in `campaigns/<campaign-id>/mekhq-bridge.md`, a generated summary file, or both?
- Should issue `#27` output JSON, Markdown, or both for the first read-only helper?
- Which MekHQ hard facts matter first for live play: active contracts, unit market, personnel, repairs, finances, DropShips, or scenarios?
