# Agent Handoff

## Issue

- GitHub issue: `#19` Build campaign-state validator
- Roadmap entry: Campaign-state automation / validator
- Mode: Project development
- Priority: High

## Goal

Build a deterministic campaign-state validator that can be run before play, after campaign setup, and during project maintenance to confirm the active campaign pointer and selected campaign save folder are coherent.

The validator should reduce token use and setup drift by checking saved files directly. It should not invent campaign facts, rewrite narrative state, or encode A Time of War rules logic.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`
- `campaigns/README.md`
- `campaign-state/active-campaign.md`
- `gm/session-procedure.md`
- `gm/state-save-checklist.md`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`

## Expected Output

- A validator script, likely `scripts/validate-campaign-state.ps1`.
- Plain text output suitable for human review and agent use.
- Optional JSON output only if it remains simple and documented.
- Documentation updates in `scripts/README.md` and `docs/current/KNOWN_COMMANDS.md`.
- Task/roadmap updates and handoff close-out when complete.

## Files And Areas

Likely files to read or edit:

- `scripts/validate-campaign-state.ps1`
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/handoffs/active/build-campaign-state-validator.md`
- `campaign-state/active-campaign.md`
- `campaigns/README.md`
- `campaigns/_template/`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
./scripts/validate-campaign-state.ps1
./scripts/validate-campaign-state.ps1 -CampaignId playtest-galatea-dropship
git check-ignore source/atow-pdf/example.pdf source/atow-text/page-0001.txt
```

## Constraints

- Route the task into Project development mode before editing.
- Do not perform source processing.
- Do not include unrelated user changes.
- Do not commit purchased PDFs, raw extracted text, or copyrighted rulebook passages.
- Do not hard-code incomplete A Time of War rules logic.
- Do not silently edit `campaign-state/active-campaign.md` or campaign save files.
- Prefer PowerShell for this Windows-first helper unless a stronger reason appears.
- Commit and push completed project-development changes unless explicitly told not to.

## Validation Scope

The first version should check deterministic structure:

- `campaign-state/active-campaign.md` exists.
- Active campaign selection is either clearly `None selected` or resolves to a valid campaign folder.
- Campaign IDs use the same safe pattern as `scripts/new-campaign-save.ps1`.
- `campaigns/_template/` exists.
- Standard campaign files exist in `campaigns/_template/`.
- Selected or explicitly supplied campaign save folder exists.
- Standard campaign files exist in that campaign save folder.
- Legacy flat `campaign-state/` files are not treated as the live campaign save.
- Missing files or invalid pointers produce clear nonzero failure behavior where appropriate.

Standard campaign files should match `campaigns/README.md` unless the implementation deliberately narrows scope and documents why.

## Acceptance Criteria

- Validator confirms whether the active campaign pointer is selected, missing, or invalid.
- Validator confirms expected standard files exist in a campaign save folder.
- Validator checks required template files exist under `campaigns/_template/`.
- Validator flags missing files, unexpected missing folders, invalid campaign IDs, and legacy flat-state misuse where deterministic.
- Validator does not silently edit campaign state.
- Usage is documented in `scripts/README.md` and `docs/current/KNOWN_COMMANDS.md`.
- Reasonable manual verification is run and recorded.
- No protected raw source is staged.
- Changes are committed and pushed.

## Open Questions

- Should the script offer a strict mode that fails when no active campaign is selected, while default mode reports that state without failure?
- Should JSON output be added now, or deferred until another tool needs it?
