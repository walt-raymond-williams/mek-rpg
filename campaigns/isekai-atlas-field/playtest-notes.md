# Playtest Notes

## Issue 24 Live Validation

- `new-campaign-save.ps1` created `campaigns/isekai-atlas-field/` from the template and did not change the active pointer.
- `validate-campaign-state.ps1 -CampaignId isekai-atlas-field` passed before the active pointer was changed.
- Active pointer was updated only after user confirmation.
- `validate-campaign-state.ps1 -StrictActive` passed after active pointer selection.
- `roll-dice.ps1` was smoke-tested outside the fiction, then live play used player-provided rolls for in-fiction checks.
- Short live scene began and exercised the save loop with an Atlas startup complication, NPC discovery, cockpit survival kit check, recovery beacon cut, and emergency medical stabilization.
- `gm/state-save-checklist.md` was used to route updates across `current-state.md`, `pcs.md`, `npcs.md`, `assets.md`, `missions.md`, `hooks.md`, `relationships.md`, `session-log.md`, and `rules-gaps.md`.
- Validator maintenance decision: no change to `scripts/validate-campaign-state.ps1` is needed for this setup because no required campaign save files were added, removed, or renamed.

## Workflow Observations

- The template is sufficient for a first real campaign save.
- Dedicated vehicle sheets are not yet needed; the Atlas can stay in `assets.md` until play proves otherwise.
- Character-output validation remains deferred until real character-sheet sections exist.
- Potential future validator gap: once real PC sheets, vehicle sheets, or structured mission clocks exist, add companion validators rather than expanding the generic campaign-state validator immediately.
