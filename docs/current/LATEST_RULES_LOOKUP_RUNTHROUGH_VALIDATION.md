# Latest Rules Lookup Run-Through Validation

## Scope

- Issue: `#96`
- Validates the issue `#91`-`#94` rules expansion in scenario form.
- Uses committed summaries, indexes, manifest metadata, page references, and authority-gate output only.
- Protected source PDFs and extracted source text were not read.

## Scenario Findings

| Scenario prompt | Primary route after fixes | Authority result | Finding |
| --- | --- | --- | --- |
| After a mission, how should I award XP, salary, and rank benefits? | `rules/campaign/advancement-and-rewards.md` | `provisional` | Correctly routes to advancement/rewards, XP advancement, campaign advancement, and active PC context. |
| Can a PC train during two weeks of downtime to improve a skill? | `rules/campaign/advancement-and-rewards.md` | `provisional` | Initial wording tied with injury downtime. Router wording now includes train/improve-skill downtime cues. |
| How do I handle a patrol crossing toxic atmosphere and extreme cold? | `rules/special/planetary-conditions.md` | `provisional` | Correctly routes to planetary conditions with protection, personal gear, damage, and vehicle-action support. |
| How should I run a quarantine clock for a disease outbreak? | `rules/special/diseases.md` | `provisional` | Correctly routes to disease, medical gear, attribute checks, drugs/poisons, and injury recovery. |
| An alien creature bites a PC with venom; what procedure should I use? | `rules/special/creatures.md` | `provisional` | Correctly routes to creature procedure with venom, damage, melee, and skill-check support. |
| Can a trooper don battle armor quickly and fight as infantry? | `rules/equipment/battle-armor-and-exoskeletons.md` | `provisional` | Correctly routes to battle armor readiness and preserves tactical handoff support without forcing full tactical resolution. |
| How do prosthetic limb replacement and implant recovery affect mission readiness? | `rules/equipment/prosthetics-and-implants.md` | `provisional` | Correctly routes to prosthetics/implants, medical gear, injury recovery, traits, and relevant tactical implant boundary. |
| How should I treat a poisoned PC and check antidote availability? | `rules/equipment/drugs-and-poisons.md` | `provisional` | Correctly routes to drugs/poisons, medical gear, recovery, creatures, and disease support. |
| How do I plan fuel logistics for a personal vehicle convoy? | `rules/equipment/personal-vehicles.md` | `provisional` | Correctly routes to personal vehicles, transport/large assets, vehicle overview, and tactical vehicle-action support. |
| What is the exact stat block and cost for a specific battle armor suit? | `rules/equipment/battle-armor-and-exoskeletons.md` | `source_lookup_required` | Router wording now catches battle armor suit stat/cost prompts; authority gate correctly refuses exact table/stat data from committed summaries. |
| Resolve a full BattleMech fight with hex movement and heat. | `gm/switch-to-classic-battletech.md` | `external_authority_required` | Correctly routes full tactical resolution to Classic BattleTech, MegaMek, MekHQ, or table-selected tactical authority. |

## Fixes Made

- Added explicit `train or improve a skill during downtime` wording to the advancement/rewards router rows so skill-improvement downtime prompts do not get pulled toward injury downtime.
- Added `battle armor suit stats or cost` wording to the battle armor route so exact suit-stat prompts find the most relevant equipment boundary before the authority gate marks them source-lookup-only.

## Result

The latest rules expansion is usable for cautious play-facing lookup. Draft summaries support provisional rulings for advancement/rewards, special hazards, creatures, disease, special equipment, and vehicle/fuel logistics. Exact table values, item stat blocks, battle armor suit data, and full tactical BattleTech resolution remain outside committed-summary authority.

No new follow-up issue is needed from this run-through; the two discovered gaps were narrow router wording fixes handled in this issue.

