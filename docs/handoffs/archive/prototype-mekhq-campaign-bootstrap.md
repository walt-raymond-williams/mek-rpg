# Agent Handoff

## Issue

- GitHub issue: `#28` Prototype MekHQ campaign bootstrap into MEK-RPG save folder
- Roadmap entry: MekHQ-to-MEK-RPG campaign bridge epic
- Mode: Project development
- Priority: Completed

## Goal

Prototype generating a playable MEK-RPG `campaigns/<campaign-id>/` save folder from the JSON output of the read-only MekHQ save summary helper.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`
- GitHub issue `#28`

## Expected Output

- `scripts/bootstrap-mekhq-campaign.py` creates a new campaign folder from summary JSON.
- Generated campaign files preserve MekHQ-owned hard facts and mark RPG-only overlays as sparse or TBD.
- Generated `mekhq-bridge.md` records source save metadata, import timestamps, warnings, unsupported fields, ID cross-references, and pending MekHQ application notes.
- Command docs explain the workflow and viewpoint selection.

## Files And Areas

Files changed:

- `scripts/bootstrap-mekhq-campaign.py`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`
- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/handoffs/archive/prototype-mekhq-campaign-bootstrap.md`

## Commands

Verification commands used:

```powershell
python -m py_compile scripts/bootstrap-mekhq-campaign.py
python ./scripts/summarize-mekhq-save.py "C:\Users\waltr\Documents\megamek-workspace\analysis\tmp\issue-22\Autosave-1-The Learning Ropes-30250720.cpnx" --format json
python ./scripts/bootstrap-mekhq-campaign.py --summary $summaryPath --campaign-id tmp-mekhq-bootstrap-issue28
./scripts/validate-campaign-state.ps1 -CampaignId tmp-mekhq-bootstrap-issue28
python ./scripts/bootstrap-mekhq-campaign.py --summary $summaryPath --campaign-id tmp-mekhq-bootstrap-issue28 --embedded-pc-name "RPG Protagonist"
```

Generated throwaway campaign folders and temp summary JSON were removed before commit.

## Constraints

- Route the task into the correct mode before editing.
- Do not include unrelated user changes.
- Do not commit purchased PDFs, raw extracted text, raw MekHQ save payloads, or copyrighted rulebook passages.
- Do not write to MekHQ saves.
- Preserve MekHQ IDs exactly as imported.
- Keep MekHQ-owned hard facts separate from MEK-RPG narrative overlays.
- Commit and push completed project-development changes unless explicitly told not to.

## Acceptance Criteria

- Correct mode identified: Completed.
- Roadmap and task state updated: Completed.
- Creates or documents a `mekhq-bridge.md` convention for campaign-local bridge metadata: Completed.
- Generates playable MEK-RPG campaign stubs without overwriting existing campaign saves: Completed.
- Supports selectable viewpoint characters from MekHQ personnel or an embedded RPG PC: Completed.
- Marks generated RPG-only personality, secrets, and relationship fields as sparse or TBD: Completed.
- Keeps MekHQ-owned hard facts separate from MEK-RPG narrative overlays: Completed.
- Verification run or blocker recorded: Completed.
- No protected raw source committed: Completed.
- Changes committed and pushed: Completed after final close-out.

## Open Questions

- Whether later refresh imports should update existing MekHQ-linked campaign folders in place or always create a new folder/snapshot.
- Whether generated `mekhq-bridge.md` should later become machine-readable front matter plus prose.
