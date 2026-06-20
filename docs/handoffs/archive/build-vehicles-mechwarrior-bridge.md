# Agent Handoff

## Issue

- GitHub issue: `#23` Build vehicles and MechWarrior bridge
- Roadmap entry: Build vehicles and MechWarrior bridge
- Mode: Source processing / project development
- Priority: Medium

## Goal

Build the first reliable bridge between RPG-scale vehicle or MechWarrior rules and tactical BattleTech handoff.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/SOURCE_PROCESSING_WORKFLOW.md`
- `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md`
- `gm/switch-to-classic-battletech.md`
- `gm/session-procedure.md`
- `source/atow-chapter-section-map.md`
- `indexes/task-router.md`

## Expected Output

- Paraphrased vehicle and MechWarrior bridge summaries or GM docs.
- Tighter tactical handoff criteria where needed.
- Router, page-reference index, rules map, subsystem index, and manifest updates.
- Notes on whether future vehicle or unit asset sheets need companion validators.

## Files And Areas

Likely files to read or edit:

- `rules/vehicles/` or another appropriate rules path
- `gm/switch-to-classic-battletech.md`
- `gm/session-procedure.md`
- `indexes/`
- `campaigns/_template/assets.md` only if asset structure changes
- companion validator planning if vehicle/unit sheets are introduced

## Commands

Useful commands or checks:

```powershell
git status --short --branch
git check-ignore source/atow-pdf/example.pdf source/atow-text/page-0001.txt
./scripts/validate-campaign-state.ps1 -CampaignId playtest-galatea-dropship
```

## Constraints

- Source processing must be explicit before reading ignored extracted source text.
- Do not encode full Classic BattleTech tactical rules here.
- Route hex-scale positioning, heat, armor locations, ranges, and full unit turns to Classic BattleTech, MegaMek, or MekHQ.
- Do not commit copied tables, unit stats, PDFs, or raw source text.

## Acceptance Criteria

- Piloting, gunnery, MechWarrior skill routing, vehicle-scene cues, and tactical handoff cues are covered or explicitly marked as gaps.
- Tactical BattleTech remains outside this workspace except for handoff guidance.
- Indexes and manifest route to the new summaries.
- Scenario lookup tests cover a vehicle skill scene, MechWarrior skill prompt, and tactical combat handoff.
- Validator-maintenance decision is documented for vehicle/unit asset-sheet implications.
- No protected raw source is staged.
- Changes are committed and pushed.

## Open Questions

- Should vehicle and unit assets stay in `assets.md` until live play needs dedicated sheets?
