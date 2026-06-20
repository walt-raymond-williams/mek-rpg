# Draft Coverage And Helper Validation

## Purpose

This report records issue `#20` validation for the current draft rules coverage and helper workflow. The goal was to confirm that a future GM assistant can start at `indexes/task-router.md`, follow committed repository links, use helper scripts as documented, and avoid relying on model memory or ignored source text.

## Scope

- Mode: Project development / review.
- Source boundary: validation used committed summaries, indexes, GM docs, campaign-save files, and scripts only. Raw source text under `source/atow-text/` and PDFs under `source/atow-pdf/` were not inspected.
- Draft coverage checked: core resolution, personal combat, equipment, GM flow, tactical handoff, and campaign-save routing.
- Placeholder coverage checked for warning behavior: character creation, campaign systems, and vehicles/Mechs.
- Helper scripts checked: `scripts/new-campaign-save.ps1`, `scripts/validate-campaign-state.ps1`, and `scripts/roll-dice.ps1`.

## Coverage Summary

| Area | Status | Validation result |
| --- | --- | --- |
| Core resolution | Draft, routed, page-referenced | Pass; existing issue `#6` tests remain valid. |
| Personal combat | Draft, routed, page-referenced | Pass with table/equipment caveats; existing issue `#8` tests remain valid. |
| Equipment | Draft, routed, page-referenced | Pass with table-heavy caveats; new scenario checks below confirm router usability. |
| Tactical handoff | Draft GM procedure | Pass; tactical cases route out of RPG mode. |
| Campaign-save routing | Implemented save-folder workflow | Pass; active pointer, template, explicit save validation, and GM save docs align. |
| Character creation | Placeholder | Gap; route exists but summaries are not rules authority. Follow issue `#21`. |
| Campaign systems | Placeholder | Gap; route exists but summaries are not rules authority. Follow issue `#22`. |
| Vehicles and MechWarrior bridge | Placeholder | Gap except tactical handoff; follow issue `#23`. |
| Helper scripts | Implemented | Pass; valid and invalid inputs behaved as documented. |

## Scenario Results

| Scenario prompt | Router match | Followed files | Result | Notes |
| --- | --- | --- | --- | --- |
| A character tries to bypass a security lock under time pressure. | `bypassing a lock, disabling a device, or handling a technical task under pressure` | `rules/core/skill-checks.md`, `rules/core/action-checks.md`, `rules/core/basic-action-resolution.md` | Pass | The path reaches Skill Checks and modifier/time-pressure guidance. Exact modifier values remain source lookup. |
| Two characters both try to grab the same object first. | `two characters racing, grabbing, resisting, sneaking past, or spotting each other` | `rules/core/opposed-actions.md`, `rules/core/basic-action-resolution.md`, `rules/core/edge.md` | Pass | The path reaches opposed margin comparison and related Edge guidance. |
| A character is hit in a personal-scale firefight and needs treatment after the fight. | `damage from an attack...` and `recovery, stabilization, medical care...` | `rules/personal-combat/damage.md`, `rules/personal-combat/wounds.md`, `rules/personal-combat/recovery.md`, `rules/equipment/medical-gear.md`, `rules/campaign/injuries-recovery.md` | Pass with caveat | Immediate damage, wounds, stabilization, and gear support are routed. Long-term campaign injury recovery remains placeholder-level. |
| The crew wants to buy armor and compare protection before a mission. | `armor, shields, helmets...` plus acquisition row if purchase matters | `rules/equipment/armor.md`, `rules/equipment/overview.md`, `rules/personal-combat/damage.md`, `rules/personal-combat/wounds.md`, `gm/switch-to-classic-battletech.md` | Pass with caveat | The path supports category choice, legality/social risk, repair, hostile-environment gear, and damage interaction. Exact armor values and kit contents remain private source lookups. |
| The crew buys rifles, ammo, grenades, and a field medical kit. | `weapons...` and `medical equipment...` | `rules/equipment/weapons.md`, `rules/equipment/medical-gear.md`, `rules/equipment/overview.md`, personal combat files | Pass with caveat | The router distinguishes weapons and medical gear, then sends exact stats/effects to cited private source pages. |
| A technician uses sensors and a diagnostic kit to find a hidden fault. | `communications, computers, diagnostics...` and possibly technical-task row | `rules/equipment/electronics.md`, `rules/core/skill-checks.md`, `rules/core/opposed-actions.md` | Pass with caveat | The route supports broad equipment role and skill/opposed-check selection. Exact device modifiers remain source lookup. |
| A MechWarrior needs pilot/gunnery notes for a tactical encounter. | `MechWarrior skills` | `rules/vehicles-and-mechs/mechwarrior-skills.md`, `rules/vehicles-and-mechs/piloting.md`, `rules/vehicles-and-mechs/gunnery.md` | Gap, correctly marked | The files exist but are draft placeholders with `TBD` pages and `Needs source review`. They can identify the gap but cannot provide a verified procedure. |
| A lance-scale fight begins and exact facing, heat, armor locations, weapon ranges, and full unit turns matter. | `switching from RPG mode to BattleTech tactical combat` | `gm/switch-to-classic-battletech.md`, `rules/vehicles-and-mechs/overview.md` | Pass | The path correctly stops RPG resolution and calls for Classic BattleTech, MegaMek, or MekHQ setup. |
| The GM asks how to load campaign state before a scene. | `running a scene` plus GM session procedure | `gm/scene-loop.md`, `gm/roll-policy.md`, `campaign-state/active-campaign.md`, active campaign save files, `gm/session-procedure.md` | Pass | Live play starts from the active pointer and exactly one `campaigns/<campaign-id>/` folder. No active campaign is currently selected. |
| A player asks to create a new character. | `character creation` | `rules/character-creation/overview.md`, lifepath/attribute/trait/skill placeholders | Gap, correctly marked | The files follow schema but are placeholders. Use them to record that issue `#21` is needed, not to run full character creation from rules. |

## Index And Schema Checks

- Router-linked committed files exist. Placeholder active-campaign paths using `campaigns/<campaign-id>/...` were treated as documented templates rather than literal files.
- All `rules/**/*.md` files include the standard summary headings: `Purpose`, `When to Use`, `Do Not Use For`, `Basic Procedure`, `Practical GM Guidance`, `Common Edge Cases`, `Related Files`, `Source References`, and `Status`.
- Manifest related IDs resolve to existing manifest IDs.
- `indexes/page-reference-index.md` covers draft core, personal-combat, and equipment summaries with page references. Placeholder character, campaign, and vehicle areas are intentionally not page-indexed yet.
- `indexes/task-router.md` now includes a coverage note warning that placeholder-targeted rows are not rules authority.

## Helper Script Checks

| Command | Result | Notes |
| --- | --- | --- |
| `./scripts/validate-campaign-state.ps1` | Pass with expected warning | Template and active pointer validated; warning reported because no active campaign is selected and no explicit campaign id was supplied. |
| `./scripts/validate-campaign-state.ps1 -CampaignId playtest-galatea-dropship` | Pass | Template, active pointer, and playtest save folder all passed. |
| `./scripts/validate-campaign-state.ps1 -StrictActive` | Expected failure | Fails because `campaign-state/active-campaign.md` says `None selected`; this is correct pre-play strict behavior. |
| `./scripts/roll-dice.ps1 2d6` | Pass | Reported expression, individual dice, modifier, and total. |
| `./scripts/roll-dice.ps1 2d6+2 "Validation check"` | Pass | Reported label plus expression, dice, modifier, and total. |
| `./scripts/roll-dice.ps1 2x6` | Expected failure | Rejected invalid syntax with documented expression guidance. |
| `./scripts/new-campaign-save.ps1 _template` | Expected failure | Rejected invalid/reserved id shape before creation. |
| `./scripts/new-campaign-save.ps1 Bad_ID` | Expected failure | Rejected uppercase/underscore id. |
| `./scripts/new-campaign-save.ps1 playtest-galatea-dropship` | Expected failure | Refused to overwrite an existing campaign save. |
| `git check-ignore source/atow-pdf/example.pdf source/atow-text/page-0001.txt source/atow-text/page-001.txt example.pdf example.epub` | Pass | Protected source patterns and general PDF/EPUB patterns are ignored. |

No successful campaign creation command was run because issue `#20` must not create the first real campaign save, and the existing playtest save already covers overwrite refusal. Issue `#24` should perform the next live creation check with user-confirmed campaign setup.

## Findings

- The current live-play draft layer is usable for common core checks, personal combat, immediate recovery, equipment category lookups, and tactical handoff.
- Equipment lookup is intentionally not a stat catalog. It routes to exact private source pages for item values, tables, kit contents, and device effects.
- Campaign-save workflow is coherent: active play starts from `campaign-state/active-campaign.md`, loads one selected `campaigns/<campaign-id>/` folder, and uses `scripts/validate-campaign-state.ps1` for deterministic structure checks.
- Placeholder summaries are discoverable but not authoritative. The router now says this explicitly.
- No issue `#20` finding requires immediate script changes. The larger gaps already map to issues `#21`, `#22`, and `#23`.

## Follow-Up Recommendations

- Issue `#21`: source-review and validate character creation foundation before using the router to build real PCs from A Time of War rules.
- Issue `#22`: source-review campaign consequence systems before using advancement, contacts, contracts, reputation, downtime, or long-term injury rules as authority.
- Issue `#23`: source-review vehicles and MechWarrior bridge before deriving pilot/gunnery notes or conversion values beyond the tactical handoff.
- Issue `#24`: during first real campaign setup, run `scripts/new-campaign-save.ps1 <confirmed-id>`, set the active campaign only after user confirmation, run `scripts/validate-campaign-state.ps1 -StrictActive`, and record any live-play helper friction.

## Source And Copyright Check

- No source processing was performed.
- Ignored raw source files were not inspected or quoted.
- No copied source tables or stat blocks were added.
- Protected paths remain ignored: `source/atow-pdf/*`, `source/atow-text/*`, `*.pdf`, and `*.epub`.

## Status

Passed for issue `#20` with documented gaps. The existing draft coverage and helper workflow are suitable for controlled live play in the drafted areas, while character creation, campaign consequences, and vehicle/MechWarrior details remain follow-up work.
