# Personal Combat Lookup Validation

## Purpose

This report records issue `#8` validation for the personal-combat lookup layer. The goal was to confirm that a GM assistant can start at `indexes/task-router.md`, follow committed links, and answer common personal-combat situations from paraphrased summaries rather than model memory or raw source text.

## Scope

- Mode: Project development / manual validation using Play mode and Rules lookup mode behavior.
- Source boundary: validation used committed summaries and indexes only. Raw source text under `source/atow-text/` and PDFs under `source/atow-pdf/` were not inspected.
- Personal-combat summaries checked: `rules/personal-combat/overview.md`, `rules/personal-combat/initiative.md`, `rules/personal-combat/action-and-movement.md`, `rules/personal-combat/ranged-attacks.md`, `rules/personal-combat/melee-attacks.md`, `rules/personal-combat/damage.md`, `rules/personal-combat/wounds.md`, `rules/personal-combat/end-phase.md`, and `rules/personal-combat/recovery.md`.
- Supporting lookup files checked: `indexes/task-router.md`, `indexes/page-reference-index.md`, `indexes/manifest.yaml`, `gm/scene-loop.md`, `gm/roll-policy.md`, and `gm/switch-to-classic-battletech.md`.

## Scenario Results

| Scenario prompt | Router match | Followed files | Result | Notes |
| --- | --- | --- | --- | --- |
| A fight starts in a warehouse corridor. Two PCs and three guards are surprised but not yet shooting. Walk me through how you determine who acts first. | `initiative, held action, squad initiative, or who acts first in personal combat` | `rules/personal-combat/initiative.md`, `rules/personal-combat/overview.md`, `rules/personal-combat/action-and-movement.md` | Pass | The path supports choosing individual, squad, or team initiative; rolling for actors or leaders; sorting highest to lowest; breaking ties; and handling held actions. Surprise is not separately summarized as a named procedure, but the prompt remains usable because acting order is fully routed. |
| My character ducks behind a cargo loader and fires a pistol at a guard across the corridor. What rules do you check, and what do you need from me before the roll? | `ranged attacks, shooting, thrown weapons, grenades, cover, line of sight, burst fire, suppression fire, blind fire, or indirect fire` | `rules/personal-combat/ranged-attacks.md`, `rules/core/skill-checks.md`, `rules/core/basic-action-resolution.md`, `rules/personal-combat/damage.md`, plus related `rules/personal-combat/action-and-movement.md` for taking cover and movement | Pass with caveat | The path identifies line of sight, range, cover, movement, weapon skill or untrained Attribute Check, ammunition, special attack mode, and damage routing. It is usable for GM flow, but exact pistol stats, cover modifiers, armor values, and weapon details require cited source/equipment lookup. Issue `#9` already tracks equipment minimum summaries. |
| A guard rushes me and I try to punch him, then I want to grapple him if I can. How do you resolve that? | `melee attacks, brawling, knives, martial arts, grappling, or close combat` | `rules/personal-combat/melee-attacks.md`, `rules/core/opposed-actions.md`, `rules/personal-combat/damage.md`, `rules/personal-combat/wounds.md`, plus related `rules/personal-combat/action-and-movement.md` for rush/movement | Pass with caveat | The path supports close range confirmation, opposed melee Skill Checks, margin comparison, counterstrike outcomes, damage routing, and grapple-as-restraint when declared. Exact melee modifiers and detailed grapple maintenance/break procedure remain source-cited rather than reproduced. |
| The guard hits my character with a rifle shot. Walk through damage, stun, consciousness, bleeding, and what gets tracked. | `damage from an attack, fall, fire, poison, suffocation, bleeding source, armor interaction, or fatigue damage` and `injury penalties, stun, unconsciousness, bleeding, death, tactical kill, or wound effects` | `rules/personal-combat/damage.md`, `rules/personal-combat/wounds.md`, `rules/personal-combat/end-phase.md`, `rules/personal-combat/recovery.md`, `rules/equipment/armor.md` | Pass with caveat | The path gives the correct sequence: identify damage source, account for attack margin/type, apply armor/barrier effects, mark standard and fatigue damage, apply stun, check consciousness and bleeding when required, track continuous damage in End Phase, and record condition state. Exact rifle damage, armor/barrier values, thresholds, and table results are intentionally not in committed summaries. |
| After the fight, our medic tries to stabilize and treat the wounded scout before the next mission. What rules do you use? | `recovery, stabilization, medical care, surgery, healing, downtime after injury, or recovering fatigue after combat` | `rules/personal-combat/recovery.md`, `rules/personal-combat/wounds.md`, `rules/personal-combat/end-phase.md`, `rules/campaign/injuries-recovery.md`, plus related `rules/equipment/personal-gear.md` for medical gear | Pass with caveat | The path supports stabilization, medical check procedure, normal versus assisted healing, surgery routing, fatigue recovery, and campaign-state tracking. The campaign injuries/recovery and personal-gear files are placeholders, so long-term mission readiness, gear effects, exact surgery outcomes, and downtime specifics remain follow-up/source-review areas. |
| The fight spills outside and turns into a vehicle and BattleMech engagement where facing, heat, armor locations, and exact weapon ranges matter. What should you do? | `switching from RPG mode to BattleTech tactical combat` | `gm/switch-to-classic-battletech.md`, `rules/vehicles-and-mechs/overview.md` | Pass | The path clearly says to stop RPG combat and generate a Classic BattleTech, MegaMek, or MekHQ encounter setup when BattleMechs, combat vehicles, facing, heat, armor locations, weapon range brackets, multiple units, or campaign force consequences matter. |

## Usability Summary

| Area | Status |
| --- | --- |
| Initiative lookup | Pass |
| Ranged attack lookup | Pass with equipment/table caveat |
| Melee and grapple lookup | Pass with detailed grapple/table caveat |
| Damage, wounds, stun, consciousness, and bleeding lookup | Pass with weapon/armor/table caveat |
| Stabilization, treatment, healing, and fatigue recovery lookup | Pass with campaign/equipment placeholder caveat |
| Tactical BattleTech handoff | Pass |

## Gaps And Follow-Up Candidates

- Exact personal weapon statistics, ammunition, armor/barrier values, medical gear effects, and equipment-facing modifiers are not yet covered by committed equipment summaries. Existing issue `#9` already tracks equipment minimum summaries.
- Long-term campaign injury and recovery consequences are only placeholder-level in `rules/campaign/injuries-recovery.md`. A future campaign-consequence summary issue should expand downtime, mission readiness, lasting injury, costs, and medical access after the equipment minimum and first playable GM mode are in place.
- Grapple maintenance, breaking grapples, exact melee/ranged modifier values, thresholds, surgery table outcomes, and other table-heavy combat details remain source-cited rather than reproduced. This is acceptable for the current copyright-safe summary layer, but live play should cite the relevant source pages when exact values matter.
- No router bug was found. Each test prompt had a clear row in `indexes/task-router.md`; the tactical handoff prompt routed correctly to `gm/switch-to-classic-battletech.md`.

## Source And Copyright Check

- Validation did not inspect or quote raw source text.
- Personal-combat summaries remain paraphrased and page-referenced.
- Protected source paths remain expected to be ignored: `source/atow-pdf/` and `source/atow-text/`.

## Status

Passed for issue `#8` with caveats. Personal-combat lookup is usable for common initiative, attack, damage, wound, recovery, and tactical handoff prompts without model memory, provided exact table values and unresolved equipment/campaign details are handled by cited source references or follow-up summary work.
