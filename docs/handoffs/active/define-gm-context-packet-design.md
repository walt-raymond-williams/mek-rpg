# Agent Handoff

## Issue

- GitHub issue: `#31` Define GM context packet design
- Roadmap entry: GM context architecture epic
- Mode: Project development
- Priority: Next after issue `#35`

## Goal

Define the canonical GM context packet: the ordered, inspectable bundle of instructions, campaign state, rules routes, recent events, summaries, retrieved memories, and optional MekHQ bridge facts used before or during play.

The output should be a durable design document that a later helper script can implement without inventing authority rules.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#31`

Task-specific context:

- `gm/session-procedure.md`
- `gm/scene-loop.md`
- `gm/state-save-checklist.md`
- `indexes/task-router.md`
- `campaign-state/active-campaign.md`
- `campaigns/README.md`
- `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`
- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`

Issue `#26`, `#27`, `#28`, and `#29` are complete. MekHQ ownership terms can be treated as established for this design, but direct MekHQ save writes remain out of scope.

Issue `#35` should run first. The context packet design should consume the pending MekHQ application workflow from issue `#35` rather than inventing its own pending-action layer.

## Expected Output

- A new durable design document, recommended path: `docs/current/GM_CONTEXT_PACKET_DESIGN.md`.
- The document should define:
  - context packet layers
  - authority order between layers
  - file or index inputs for each layer
  - freshness expectations and stale-context failure modes
  - differences between play mode, rules lookup mode, and MekHQ-linked play
  - how pending MekHQ application items enter MekHQ-linked play context, after issue `#35`
  - source and copyright boundaries
  - what later issue `#33` should implement in a deterministic helper
- Update related docs only if the design changes the live play start procedure or issue sequencing.
- Update `docs/current/TASKS.md` and `docs/current/ROADMAP.md` as needed for accurate work state.
- Archive this handoff after issue completion.

## Files And Areas

Likely files to read or edit:

- `docs/current/GM_CONTEXT_PACKET_DESIGN.md` (new)
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `gm/session-procedure.md` if the play start procedure changes
- `gm/state-save-checklist.md` if save/checkpoint expectations change
- `docs/handoffs/active/define-gm-context-packet-design.md`

Avoid editing rules summaries unless the task unexpectedly exposes a routing documentation issue. This task is design and workflow architecture, not source processing.

## Commands

Useful commands or checks:

```powershell
git status --short --branch
gh issue view 31
rg -n "context packet|active-campaign|state-save|MekHQ|memory|summary" docs gm campaign-state campaigns indexes
git diff --check
git check-ignore source/atow-pdf/example.pdf
git check-ignore source/atow-text/page-001.txt
```

If docs are edited, run a consistency check:

```powershell
git status --short --branch
```

## Constraints

- Route the task into project development mode before editing.
- No source processing is required or requested.
- Do not commit purchased PDFs, raw extracted text, raw MekHQ save payloads, copied rulebook text, or secrets.
- Preserve the source boundary: rules references should point to committed paraphrased summaries and indexes, not raw A Time of War text.
- Keep structured campaign files authoritative over narrative summaries when facts conflict.
- Keep MekHQ-owned hard facts distinct from MEK-RPG narrative memory.
- Do not imply direct MekHQ save writes, headless MekHQ day advancement, or automatic writeback.
- Keep the design inspectable and implementable by a later deterministic helper; avoid model-specific magic.
- Commit and push completed project-development changes unless explicitly told not to.

## Acceptance Criteria

- Defines context packet layers and their authority order.
- States which files or indexes feed each layer.
- Explains how the packet differs between play mode, rules lookup mode, and MekHQ-linked play.
- Preserves protected source boundaries and does not include raw rulebook text.
- Updates relevant workflow docs if the play start procedure changes.
- Records follow-up implementation tasks if a helper script is needed.
- Verification run or blocker recorded.
- No protected raw source committed.
- Changes committed and pushed.

## Open Questions

- Should issue `#31` only define the packet shape, leaving all checkpoint and memory-strata details to issue `#32`, or should it define minimal checkpoint expectations now?
- Should the design include a sample packet skeleton in the doc, or leave examples to issue `#33` when the helper is prototyped?
- Should optional retrieved memories be file-based only for now, or should the design name future semantic retrieval as a placeholder without implementing it?
