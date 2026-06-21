# Agent Handoff

## Issue

- GitHub issue: `#37` Run manual MekHQ pending workflow playtest
- Roadmap entry: MekHQ bridge verification / manual pending workflow playtest
- Mode: Play workflow validation / user-assisted project development
- Priority: Backlog until the user has a disposable or intentionally selected MekHQ save ready

## Goal

Run a human-in-the-loop validation of the pending MekHQ application workflow using a real MekHQ UI step: create one pending hard ledger item in MEK-RPG, apply the corresponding action manually in MekHQ, save MekHQ, re-import, and reconcile the pending item.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#37`

Task-specific context:

- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`
- `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md`
- `scripts/summarize-mekhq-save.py`
- `scripts/bootstrap-mekhq-campaign.py`
- active or disposable MekHQ-linked campaign folder chosen by the user

## Expected Output

- A short validation report under `docs/current/` or archived handoff notes that records:
  - MekHQ save/campaign used, without committing raw save payloads.
  - Read-only import/bootstrap step.
  - Pending item created in `pending-mekhq-actions.md`.
  - Manual MekHQ UI action performed by the user.
  - Saved re-import result.
  - Final item state: `imported`, `resolved`, `blocked`, or `abandoned`.
  - Awkward steps, missing fields, and follow-up issues.
- Optional follow-up GitHub issues for helper automation, clearer docs, or a focused MegaMek workspace request if the test exposes a concrete MekHQ-side need.
- `TASKS.md` and `ROADMAP.md` updates on completion.

## Files And Areas

Likely files to read or edit:

- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md`
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`
- selected `campaigns/<campaign-id>/pending-mekhq-actions.md`
- selected `campaigns/<campaign-id>/mekhq-bridge.md`
- selected campaign files linked by the pending item
- a new validation report if useful
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/handoffs/active/run-manual-mekhq-pending-workflow-playtest.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
python ./scripts/summarize-mekhq-save.py "C:\path\to\campaign.cpnx" --format json
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id disposable-linked-campaign
./scripts/validate-campaign-state.ps1 -CampaignId disposable-linked-campaign
git diff --check
git check-ignore source/atow-pdf/example.pdf
git check-ignore source/atow-text/page-001.txt
```

The user must perform the MekHQ UI action and save the MekHQ campaign. MEK-RPG should only read or summarize the saved result.

## Constraints

- Route the task into play workflow validation / project development before editing.
- Requires explicit user confirmation of which MekHQ save/campaign is safe to use.
- Do not use a real campaign save unless the user intentionally selects it.
- Do not commit raw MekHQ saves, raw MekHQ XML, purchased PDFs, extracted A Time of War source text, copied tables, copied rulebook passages, or secrets.
- Do not implement direct MekHQ save/XML writeback.
- Keep MekHQ authoritative for hard ledger facts until saved re-import confirms them.
- Keep MEK-RPG authoritative for RPG memory and narrative overlays.
- Commit and push completed project-development changes unless explicitly told not to.

## Acceptance Criteria

- Correct mode identified.
- User selects or confirms the disposable/real MekHQ campaign save used for the test.
- MEK-RPG creates or uses a MekHQ-linked campaign folder from a read-only import.
- One pending action is created in `pending-mekhq-actions.md`.
- User applies the corresponding action manually in MekHQ UI and saves MekHQ.
- MEK-RPG re-imports or summarizes the saved MekHQ state.
- Pending item is marked `imported`, `resolved`, `blocked`, or `abandoned` with evidence notes.
- Validation report records results, awkward steps, and follow-up needs.
- Roadmap and task state updated.
- No protected raw source or raw MekHQ save payload committed.
- Changes committed and pushed, unless this remains a user-only note without repo changes.

## Open Questions

- Which MekHQ action is the best first live test: purchase, hiring, contract decision, repair/logistics change, or day advancement?
- Should this run against a disposable sister-workspace save first, then a table-canon-linked save later?
- If a concrete MekHQ-side support need appears, should the follow-up be created in this repo first or directly in the MegaMek workspace group?
