# Agent Handoff

## Issue

- GitHub issue: `#35` Define pending MekHQ application checklist workflow
- Roadmap entry: MekHQ-to-MEK-RPG campaign bridge epic / precondition for GM context packet design
- Mode: Project development
- Priority: Current

## Goal

Define a campaign-local workflow for pending MekHQ application items: RPG-side outcomes that may need to be applied manually in MekHQ before they become hard ledger facts.

This should make the read-only bridge practical during play. MEK-RPG can record proposed hard ledger changes, but MekHQ remains authoritative until the user applies the change in MekHQ, saves the campaign, and MEK-RPG re-imports the resulting state.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#35`

Task-specific context:

- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md`
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`
- `scripts/bootstrap-mekhq-campaign.py`
- `campaigns/_template/`
- `campaigns/README.md`
- `gm/session-procedure.md`
- `gm/state-save-checklist.md`
- `docs/handoffs/active/define-gm-context-packet-design.md`

Issues `#26`, `#27`, `#28`, and `#29` are complete. Issue `#31` has an active handoff, but this issue should run first so the GM context packet design can include a concrete pending-action layer.

## Expected Output

- A durable workflow note, recommended path: `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`.
- A campaign-local convention for pending MekHQ application items. Options to evaluate:
  - a new campaign-local file such as `pending-mekhq-actions.md`
  - a standard section in generated `mekhq-bridge.md`
  - sections in existing files such as `session-log.md`, `assets.md`, `missions.md`, `pcs.md`, and `hooks.md`
- A clear item schema/checklist for each pending action.
- Lifecycle states for pending items, such as proposed, queued, user-applied-in-MekHQ, imported, resolved, blocked, or abandoned.
- Guidance for reviewing pending items before day advancement and after re-import.
- Updates to `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`, `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`, `campaigns/README.md`, and/or `campaigns/_template/` if the chosen convention changes live campaign file expectations.
- Update `docs/handoffs/active/define-gm-context-packet-design.md` so issue `#31` knows how to include pending MekHQ actions in the context packet.
- Update `docs/current/TASKS.md` and `docs/current/ROADMAP.md` for task ordering and completion.
- If the workflow exposes MekHQ-side requirements, create a clear request/memo ticket for the MegaMek workspace group. That ticket can ask the sister workspace to investigate or implement MekHQ-side support, such as safe APIs, UI-assisted import/export, supported artifact formats, writeback commands, or source-backed advice on what MEK-RPG should not attempt.

## Files And Areas

Likely files to read or edit:

- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md` (new)
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/handoffs/active/define-gm-context-packet-design.md`
- `docs/handoffs/active/define-pending-mekhq-application-checklist.md`
- `campaigns/README.md`
- `campaigns/_template/` if a new standard campaign-local file is chosen
- `scripts/bootstrap-mekhq-campaign.py` only if generated MekHQ-linked campaigns should include the chosen file or section
- `scripts/validate-campaign-state.ps1` only if a new required campaign template file is added
- A GitHub issue or memo for the MegaMek workspace group if MekHQ-side work is needed or would materially reduce manual steps

Avoid implementing direct MekHQ writeback. This task is a workflow/checklist design, not MekHQ automation.

## Commands

Useful commands or checks:

```powershell
git status --short --branch
gh issue view 35
rg -n "Pending MekHQ|pending.*MekHQ|MekHQ application|writeback|manual MekHQ|mekhq-bridge" docs gm campaigns scripts
git diff --check
git check-ignore source/atow-pdf/example.pdf
git check-ignore source/atow-text/page-001.txt
```

If a campaign template file is added:

```powershell
./scripts/validate-campaign-state.ps1 -CampaignId isekai-atlas-field
```

If `bootstrap-mekhq-campaign.py` changes:

```powershell
python -m py_compile scripts/bootstrap-mekhq-campaign.py
```

## Constraints

- Route the task into project development mode before editing.
- No source processing is required or requested.
- Do not commit purchased PDFs, raw extracted text, raw MekHQ save payloads, copied rulebook text, or secrets.
- Keep direct `.cpnx`, `.cpnx.gz`, MekHQ XML edits, headless day advancement, automatic purchases, contract acceptance, repair changes, personnel changes, battle-result writes, and broad MekHQ source changes out of scope.
- Keep MekHQ authoritative for hard ledger facts until a saved MekHQ import confirms them.
- Keep MEK-RPG authoritative for RPG memory: scenes, conversations, relationships, promises, secrets, hooks, A Time of War overlays, session logs, and safety/tone.
- Prefer an inspectable Markdown workflow before adding helper scripts.
- Commit and push completed project-development changes unless explicitly told not to.

## Acceptance Criteria

- Correct mode identified.
- Roadmap and task state updated.
- Defines a pending MekHQ application item schema or checklist fields.
- Defines lifecycle states for proposed, queued, user-applied, imported, resolved, blocked, and abandoned items.
- Identifies which campaign files or new campaign-local file own pending items.
- Explains how the GM should review pending items before advancing a MekHQ day.
- Keeps direct MekHQ save/XML writes out of scope.
- Decides whether to create a MegaMek workspace request/memo for MekHQ-side support, and creates it when useful.
- Updates issue `#31` handoff or task ordering so context packet design consumes this workflow.
- Verification run or blocker recorded.
- No protected raw source committed.
- Changes committed and pushed.

## Open Questions

- Should pending actions live in `mekhq-bridge.md`, a dedicated `pending-mekhq-actions.md`, or both?
- Should `pending-mekhq-actions.md` become a required template file for every campaign, or only for MekHQ-linked campaigns?
- Should the first workflow include examples for purchases, contract decisions, repairs, injuries, personnel changes, tactical outcomes, and day advancement?
- Should issue `#33` later include pending actions in a deterministic GM context packet helper?
- Which MekHQ-side questions should be handed to the MegaMek workspace group instead of solved inside MEK-RPG?
