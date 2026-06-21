# Agent Handoff

## Issue

- GitHub issue: `#29` Define MekHQ-linked one-day play loop and writeback boundaries
- Roadmap entry: MekHQ-to-MEK-RPG campaign bridge epic
- Mode: Project development / play workflow design
- Priority: High

## Goal

Define the safe one-day RPG play loop for MekHQ-linked MEK-RPG campaigns and document clear writeback boundaries before any bootstrap helper implies that MEK-RPG can directly modify MekHQ campaign saves.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#29`
- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`
- `campaigns/README.md`
- `campaigns/_template/`
- `gm/session-procedure.md`
- `gm/state-save-checklist.md`
- `gm/switch-to-classic-battletech.md`
- `rules/campaign/contracts.md`
- `rules/campaign/downtime-and-readiness.md`
- `rules/campaign/injuries-recovery.md`
- `C:\Users\waltr\Documents\megamek-workspace\docs\current\MEK_RPG_MEKHQ_COLLABORATION_BRIEF.md`
- `C:\Users\waltr\Documents\megamek-workspace\docs\current\MEK_RPG_MEKHQ_INTEGRATION_ASSESSMENT.md`

## Expected Output

- A focused design note under `docs/current/` that defines:
  - the one-day MekHQ-linked play loop
  - day ownership between MekHQ and MEK-RPG
  - pre-session import/checkpoint expectations
  - in-day scene handling
  - post-scene and end-of-day save/update expectations
  - how conversations, promises, relationships, hidden motives, hooks, and session logs are saved in MEK-RPG
  - how purchases, injuries, contract decisions, repairs, personnel changes, and battle outcomes are queued or applied through MekHQ
  - a writeback boundary matrix with these categories:
    - safe as MEK-RPG-only memory
    - user applies manually in MekHQ UI
    - artifact-based handoff such as a report, checklist, or MUL-style export
    - future source-backed automation
    - out of scope / unsafe direct XML edits
- Updates to `docs/current/ROADMAP.md` and `docs/current/TASKS.md` when the issue is completed.
- Any follow-up issue notes discovered while defining the boundary.

## Files And Areas

Likely files to read or edit:

- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- new design note in `docs/current/`
- `gm/session-procedure.md` only if the normal play-start flow changes
- `gm/state-save-checklist.md` only if the save/checkpoint procedure changes
- `campaigns/README.md` only if MekHQ-linked campaign folders need new standing guidance
- GitHub issue `#29`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
gh issue view 29 --json number,title,state,body
git diff --check
git check-ignore source/atow-pdf/example.pdf source/atow-text/page-0001.txt
```

## Constraints

- Keep MekHQ authoritative for day advancement, hard logistics, finances, repairs, personnel ledger state, contracts, scenarios, markets, and tactical battle outcomes.
- Keep MEK-RPG authoritative for scenes inside a MekHQ day, A Time of War overlays, conversations, promises, relationships, hidden motives, hooks, session logs, rules gaps, and safety/tone.
- Do not write to MekHQ saves.
- Do not promote direct `.cpnx`, `.cpnx.gz`, or XML edits as safe current behavior.
- Do not claim MekHQ automation is supported unless it is explicitly deferred to future source-backed work.
- Preserve uncertainty when MekHQ internals or save fields have not been inspected.
- Do not process A Time of War PDFs or extracted source text for this issue.
- Do not commit purchased PDFs, raw extracted text, copied rulebook passages, secrets, or raw MekHQ save payloads.

## Acceptance Criteria

- Correct mode identified.
- Design note defines day ownership: MekHQ is authoritative for day advancement and hard ledger changes; MEK-RPG is authoritative for scenes within the day.
- Design note defines how conversations, promises, relationships, hidden motives, hooks, and session logs are saved in MEK-RPG.
- Design note defines how purchases, injuries, contract decisions, repairs, personnel changes, and battle outcomes should be applied, queued, or handed off to MekHQ.
- Writeback boundary matrix distinguishes MEK-RPG-only memory, manual MekHQ UI application, artifact-based handoff, future source-backed automation, and unsafe direct XML edits.
- Direct MekHQ save writes remain out of scope.
- Roadmap and task state match GitHub issue state at close-out.
- Verification run or blocker recorded.
- No protected raw source committed.
- Changes committed and pushed.

## Open Questions

- Should the issue output be named `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`, or should it be folded into a broader bridge workflow document?
- Should manual MekHQ UI updates be tracked as a campaign-local checklist file, a section in `session-log.md`, or future generated bridge output?
- Should `#27` emit a pre-session packet, post-session comparison report, or both?
