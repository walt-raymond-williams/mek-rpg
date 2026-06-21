# Agent Handoff

## Issue

- GitHub issue: `#27` Prototype read-only MekHQ save summary helper
- Roadmap entry: MekHQ-to-MEK-RPG campaign bridge epic
- Mode: Project development / prototype helper
- Priority: High

## Goal

Build the first read-only MekHQ save summary helper for MEK-RPG. The helper should inspect `.cpnx`, `.cpnx.gz`, or plain MekHQ campaign XML and emit MEK-RPG-readable hard campaign facts without modifying the save.

The output should support the issue `#29` one-day play loop: MEK-RPG can load a pre-session checkpoint from MekHQ-owned facts, run RPG scenes inside the day, and leave hard ledger changes to MekHQ.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#27`
- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `C:\Users\waltr\Documents\megamek-workspace\docs\current\MEK_RPG_MEKHQ_COLLABORATION_BRIEF.md`
- `C:\Users\waltr\Documents\megamek-workspace\docs\current\MEK_RPG_MEKHQ_INTEGRATION_ASSESSMENT.md`

Useful sister-workspace source notes and docs to inspect if field mapping is unclear:

- `C:\Users\waltr\Documents\megamek-workspace\docs\current\SAVE_FORMAT_NOTES.md`
- `C:\Users\waltr\Documents\megamek-workspace\docs\current\TABLETOP_RESULT_MUL_WORKFLOW.md`
- `C:\Users\waltr\Documents\megamek-workspace\docs\current\MECH_ROSTER_CONTROL_WORKFLOWS.md`
- `C:\Users\waltr\Documents\megamek-workspace\external\src\mekhq\MekHQ\src\mekhq\campaign\CampaignFactory.java`
- `C:\Users\waltr\Documents\megamek-workspace\external\src\mekhq\MekHQ\src\mekhq\campaign\Campaign.java`
- MekHQ XML parser and market/contract classes as needed, located under `C:\Users\waltr\Documents\megamek-workspace\external\src\mekhq\MekHQ\src\`.

## Expected Output

- A prototype helper script, probably under `scripts/`, that:
  - accepts an explicit MekHQ save path
  - detects gzip-compressed saves by magic bytes or extension
  - reads plain `.cpnx`, gzip `.cpnx.gz`, and plain XML safely
  - emits structured JSON, Markdown, or both
  - never writes to the MekHQ save
- Documentation for usage and limitations, likely in:
  - `scripts/README.md`
  - `docs/current/KNOWN_COMMANDS.md`
  - a focused current note if field mapping details are substantial
- Documented confirmed and unsupported field mappings.
- Roadmap and task-board updates when the issue is completed.
- GitHub issue `#27` close-out comment with commit hash and verification result.

## Field Priorities

Start from `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`.

Minimum useful output:

1. `bridge_metadata`: input path, save timestamp, import timestamp, helper version, warnings, unsupported sections.
2. `campaign`: name, date, faction if available, location if available, funds if available.
3. `personnel`: MekHQ ID if available, display name, role/rank/primary role if available, assignment, availability, injury/fatigue flags.
4. `units`: MekHQ ID if available, display name, chassis/model/type if available, condition/status, location/assignment, crew, damage/repair summary when easily available.
5. `contracts` and `scenarios`: ID if available, name, employer/status/deadline/objective summary when present.
6. `repairs_and_logistics`: obvious alerts, repair queues, acquisition/shopping list, unavailable staff, transport/cargo pressure when present.
7. `markets`: unit market offers, personnel market applicants, and contract market offers where present, with prices/terms only when source-confirmed and easy to extract.
8. `unsupported`: fields the helper looked for but could not map reliably.

Use evidence labels from the bridge data model:

- `Confirmed from MekHQ import`
- `Confirmed by user`
- `Inferred`
- `Unknown`
- `Unsupported`
- `Needs MekHQ inspection`

## Sample Inputs

Representative disposable saves exist in the sister workspace. Do not commit them or raw extracted payloads.

Good first pair for compressed/plain parity:

- `C:\Users\waltr\Documents\megamek-workspace\analysis\tmp\issue-22\Autosave-1-The Learning Ropes-30250720.cpnx`
- `C:\Users\waltr\Documents\megamek-workspace\analysis\tmp\issue-22\Autosave-1-The Learning Ropes-30250720.cpnx.gz`

Other candidate saves exist under:

- `C:\Users\waltr\Documents\megamek-workspace\campaigns\demo\`
- `C:\Users\waltr\Documents\megamek-workspace\external\installs\MekHQ-0.51.00\campaigns\`
- `C:\Users\waltr\Documents\megamek-workspace\external\src\mekhq\MekHQ\campaigns\`

Use explicit paths in verification. Keep generated test output under ignored temporary paths or use command output; do not add raw MekHQ XML or save payloads to the repository.

## Files And Areas

Likely files to read or edit:

- `scripts/`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- optional focused mapping/validation note under `docs/current/`
- GitHub issue `#27`

Likely files to read only:

- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- sister workspace MekHQ docs/source listed above
- representative disposable MekHQ saves in `C:\Users\waltr\Documents\megamek-workspace\`

## Implementation Guidance

- Prefer a small deterministic CLI over an integrated campaign-folder writer.
- JSON is the safer first output because it is testable and preserves structured unknown/unsupported fields. Markdown can be added if it helps live GM context.
- It is acceptable to implement in PowerShell if the XML/gzip handling stays readable. Python is acceptable if it materially simplifies gzip/XML parsing; document the command and any assumptions.
- Parse with structured XML APIs. Avoid ad hoc text parsing except for preliminary discovery.
- Treat missing or confusing fields as `Unknown`, `Unsupported`, or `Needs MekHQ inspection`; do not infer hard ledger values.
- Preserve MekHQ IDs exactly as read. If an ID is absent or not yet located, output `Unknown`.
- Do not normalize, rewrite, or re-save the input file.
- If the first pass cannot confidently extract every requested category, ship a useful partial helper with explicit unsupported-field reporting rather than pretending full coverage exists.
- Keep issue `#28` in mind: its bootstrap helper should later consume this summary output, so avoid output that is only human prose.

## Commands

Useful commands or checks:

```powershell
git status --short --branch
gh issue view 27 --json number,title,state,body
Get-ChildItem -Path C:\Users\waltr\Documents\megamek-workspace -Recurse -Include *.cpnx,*.cpnx.gz -File
git diff --check
git check-ignore source/atow-pdf/example.pdf source/atow-text/page-0001.txt
```

Add issue-specific helper verification after implementation. Expected checks should include:

```powershell
# Example shape only; adjust to the actual helper name and flags.
./scripts/<helper-name>.ps1 -Path "C:\Users\waltr\Documents\megamek-workspace\analysis\tmp\issue-22\Autosave-1-The Learning Ropes-30250720.cpnx" -Format json
./scripts/<helper-name>.ps1 -Path "C:\Users\waltr\Documents\megamek-workspace\analysis\tmp\issue-22\Autosave-1-The Learning Ropes-30250720.cpnx.gz" -Format json
```

## Constraints

- Do not write to MekHQ saves.
- Do not promote direct `.cpnx`, `.cpnx.gz`, or XML edits as safe current behavior.
- Do not add headless day advancement, automatic purchase/contract/repair writeback, or personnel writeback.
- Do not commit MekHQ save files, raw extracted MekHQ XML, protected A Time of War PDFs, extracted A Time of War source text, copied rulebook passages, secrets, or large raw payloads.
- Do not process A Time of War PDFs or extracted source text for this issue.
- Preserve uncertainty when MekHQ internals or XML fields are not yet confirmed.
- Keep MEK-RPG-owned narrative memory separate from MekHQ-owned ledger facts.

## Acceptance Criteria

- Correct mode identified.
- Active handoff read and followed.
- Helper reads gzip-compressed and plain MekHQ save XML safely.
- Helper emits campaign name, date, location, funds, units, personnel, contracts/scenarios, repairs/logistics alerts, and market offers where present.
- Helper preserves MekHQ IDs where available.
- Helper never writes to the MekHQ save.
- Unsupported or unmapped fields are reported explicitly.
- Usage and limitations are documented.
- Roadmap and task state updated.
- Verification run or blocker recorded.
- Protected raw source and raw MekHQ save payloads are not staged.
- Changes committed and pushed.
- GitHub issue `#27` commented on or closed with commit hash and verification result.

## Open Questions

- Should the helper emit JSON only first, or JSON plus Markdown in the same issue?
- Should the helper live as PowerShell for local consistency or Python for simpler gzip/XML parsing?
- Which sample save should be treated as the canonical verification fixture without committing it?
- Should field mapping documentation live in a new `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md` note or remain in script README/usage output until the parser stabilizes?
- Should issue `#28` require a dedicated `campaigns/<campaign-id>/mekhq-bridge.md` file, or consume the helper output directly during bootstrap?
