# Validate Personal Combat Lookup Flow By Hand

## Issue

- GitHub issue: https://github.com/walt-raymond-williams/mek-rpg/issues/8
- Roadmap entry: Validate personal combat lookup flow by hand
- Mode: Project development / manual validation
- Priority: High
- Status: Done

## Goal

Run scenario-based lookup tests against the personal-combat summaries after they exist, starting from `indexes/task-router.md` and following only committed links.

This was a deliberate hand-test checkpoint: prove the GM assistant can find and apply personal combat procedures without raw source text or model memory.

## Output

- Validation report: `docs/current/PERSONAL_COMBAT_LOOKUP_VALIDATION.md`

## Result

Passed with caveats.

The validation prompts all reached committed summaries or the tactical handoff doc from `indexes/task-router.md`. No router bug was found.

Recorded caveats:

- Equipment minimum summaries are still needed for exact personal weapon, armor, ammunition, and medical gear details. Existing issue `#9` already tracks this.
- Long-term campaign injury and recovery details remain placeholder-level in `rules/campaign/injuries-recovery.md`.
- Table-heavy details remain source-cited rather than reproduced, including exact modifiers, thresholds, grapple detail, weapon/armor values, and surgery outcomes.

## Validation Prompts

Used these prompts:

1. "A fight starts in a warehouse corridor. Two PCs and three guards are surprised but not yet shooting. Walk me through how you determine who acts first."
2. "My character ducks behind a cargo loader and fires a pistol at a guard across the corridor. What rules do you check, and what do you need from me before the roll?"
3. "A guard rushes me and I try to punch him, then I want to grapple him if I can. How do you resolve that?"
4. "The guard hits my character with a rifle shot. Walk through damage, stun, consciousness, bleeding, and what gets tracked."
5. "After the fight, our medic tries to stabilize and treat the wounded scout before the next mission. What rules do you use?"
6. "The fight spills outside and turns into a vehicle and BattleMech engagement where facing, heat, armor locations, and exact weapon ranges matter. What should you do?"

## Source Boundary

- Raw source text was not inspected.
- Protected local source paths remained unstaged.

## Close-Out Notes

- `docs/current/ROADMAP.md` updated.
- `docs/current/TASKS.md` updated.
- This handoff was archived after the validation report was created.
