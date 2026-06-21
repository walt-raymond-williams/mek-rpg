# Agent Handoff

## Issue

- GitHub issue: `#67` Consume future MekHQ read-only checkpoint export
- Roadmap entry: MekHQ bridge primitives follow-up queue
- Mode: Project development / cross-workspace integration planning
- Priority: First child issue in the bridge primitives follow-up queue

## Goal

Define how MEK-RPG should consume a future MekHQ-owned read-only checkpoint export, and align the existing Python save-summary helper with the MegaMek workspace recommendation that read-only export comes before write automation.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/current/MEGAMEK_WORKSPACE_BRIDGE_REQUEST.md`
- `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md`
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`
- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `C:\Users\waltr\Documents\megamek-workspace\docs\current\MEK_RPG_MEKHQ_BRIDGE_PRIMITIVES.md`
- GitHub issue `#67`

## Expected Output

- A MEK-RPG-side consumer contract or adapter plan for a MekHQ-owned checkpoint export.
- A gap comparison between current `scripts/summarize-mekhq-save.py` JSON and recommended source-backed MekHQ export fields.
- Clear labels for values that should be method-backed by MekHQ rather than inferred from raw XML.
- Follow-up issues if adapter implementation or fixture updates are needed.

## Files And Areas

Likely files to read or edit:

- `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md`
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`
- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `docs/current/MEGAMEK_WORKSPACE_BRIDGE_REQUEST.md`
- `scripts/summarize-mekhq-save.py` only if implementation is intentionally changed
- `tests/fixtures/` only if fixture coverage changes
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- this handoff

## Commands

Useful commands or checks:

```powershell
git status --short --branch
./scripts/test-summarize-mekhq-save.ps1
./scripts/test-bootstrap-mekhq-campaign.ps1
./scripts/test-all.ps1
git diff --check
```

## Constraints

- Prefer planning and contract clarification before changing code.
- Do not commit raw MekHQ saves, raw XML, or protected A Time of War source material.
- Keep the current parser clearly labeled as read-only prototype/fallback if a MekHQ-owned exporter becomes preferred.

## Acceptance Criteria

- Current MEK-RPG summary JSON fields are compared against the MegaMek read-only checkpoint export recommendation.
- Derived fields that should come from MekHQ methods are marked.
- Import/bootstrap expectations are updated or future adapter work is filed.
- Verification is run or a blocker is recorded.
- Changes are committed and pushed.

## Open Questions

- Should MEK-RPG define the desired JSON schema first, or wait for the MegaMek workspace to propose the exporter contract?
