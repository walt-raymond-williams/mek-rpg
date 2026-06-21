# Agent Handoff

## Issue

- GitHub issue: `#65` Create MekHQ personnel-to-PC/NPC sheet workflow
- Roadmap entry: MekHQ personnel-to-PC/NPC sheet workflow
- Mode: Project development
- Priority: Backlog / ready after current rules source-review wave unless the user wants MekHQ-linked play next

## Goal

Create a repeatable workflow for turning parsed MekHQ personnel into useful MEK-RPG `pcs.md` and `npcs.md` entries while preserving MekHQ as the authority for hard roster facts and MEK-RPG as the authority for RPG memory.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#65`

Task-specific docs:

- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md`
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/MEKHQ_PENDING_WORKFLOW_PLAYTEST_VALIDATION.md`
- `campaigns/mekhq-pending-playtest/pcs.md`
- `campaigns/mekhq-pending-playtest/npcs.md`
- `campaigns/mekhq-pending-playtest/mekhq-bridge.md`
- `scripts/summarize-mekhq-save.py`
- `scripts/bootstrap-mekhq-campaign.py`
- `tests/fixtures/mekhq-summary-minimal.json`

## Expected Output

- A documented workflow or schema under `docs/current/` for MekHQ-linked PC/NPC sheet entries.
- Guidance for which imported MekHQ personnel become expanded `pcs.md` or `npcs.md` entries, and which remain bridge cross-references.
- A clear split between MekHQ-owned roster facts and MEK-RPG-owned A Time of War overlays, motives, relationships, secrets, goals, scene memory, and sheet gaps.
- Import refresh and discrepancy behavior for linked people.
- A decision on whether to update `bootstrap-mekhq-campaign.py`, add a companion helper, or keep the first pass documentation-only.
- Focused tests if script output changes.

## Files And Areas

Likely files to read or edit:

- `docs/current/MEKHQ_PERSONNEL_SHEET_WORKFLOW.md` or similarly named new doc
- `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`
- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `campaigns/README.md`
- `campaigns/_template/pcs.md`
- `campaigns/_template/npcs.md`
- `scripts/bootstrap-mekhq-campaign.py`
- `scripts/test-bootstrap-mekhq-campaign.ps1`
- `tests/fixtures/mekhq-summary-minimal.json`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
python ./scripts/bootstrap-mekhq-campaign.py --summary tests/fixtures/mekhq-summary-minimal.json --campaign-id mekhq-personnel-sheet-test
./scripts/test-bootstrap-mekhq-campaign.ps1
./scripts/test-all.ps1
git diff --check
git check-ignore source/atow-pdf/example.pdf
git check-ignore source/atow-text/page-001.txt
```

## Constraints

- Do not invent full A Time of War attributes, skills, traits, Edge, XP, or gear from MekHQ role/rank fields.
- Do not write to `.cpnx`, `.cpnx.gz`, MekHQ XML, or raw MekHQ save payloads.
- Do not commit raw MekHQ saves, protected A Time of War source text, purchased PDFs, extracted source text, copied tables, or secrets.
- Preserve MekHQ IDs for linked personnel.
- Label imported fields with evidence/authority language.
- Keep RPG-only memory in campaign files, not in MekHQ.

## Acceptance Criteria

- Current personnel parsing coverage is summarized from existing helper output and docs.
- PC/NPC sheet ownership boundary is documented for MekHQ-linked campaigns.
- A reusable sheet entry shape is documented for imported MekHQ personnel.
- Import refresh and discrepancy behavior is defined.
- Roadmap and task board remain current.
- Any code changes have focused fixture coverage; if no code changes are made, the no-code decision is explicit.
- No raw MekHQ save, raw XML, protected source text, copied tables, purchased PDFs, or secrets are committed.

## Open Questions

- Resolved for issue `#65`: first implementation is documentation-only. Bootstrap stays sparse because refresh/merge behavior needs real play pressure and focused fixture coverage.
- Resolved for issue `#65`: expanded NPC generation remains selective; large rosters stay in MekHQ and `mekhq-bridge.md` cross-references until a person becomes scene-relevant.
- Resolved for issue `#65`: linked PCs and NPCs share the same boundary pattern but use PC/NPC-specific entry variants.
- Deferred: stricter A Time of War sheet-gap validation can be added later after real linked PC/NPC entries exist.

## Completion Notes

- Added `docs/current/MEKHQ_PERSONNEL_SHEET_WORKFLOW.md`.
- Documented current parsed personnel coverage, linked-person expansion rules, PC/NPC entry shapes, import refresh behavior, discrepancy handling, and the no-code decision.
- Updated MekHQ bootstrap and bridge data model docs to route richer linked-person entries through the new workflow.
- Updated campaign README and template `pcs.md`/`npcs.md` with MekHQ-linked entry templates.
- Preserved boundaries: no raw MekHQ saves/XML, no direct MekHQ writeback, no invented A Time of War stats from MekHQ role/rank fields.
