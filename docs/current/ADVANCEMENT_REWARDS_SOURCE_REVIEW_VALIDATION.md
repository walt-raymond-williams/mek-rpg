# Advancement And Rewards Source Review Validation

## Scope

- Issue: `#91`
- Source range reviewed: A Time of War PDF pages 332-338 / printed pages 330-336, with related lookup pages 87-92 / 85-90 and 351-360 / 349-358.
- Output summary: `rules/campaign/advancement-and-rewards.md`

## Source Boundary

The committed summary paraphrases procedure and routing only. It does not copy XP award tables, aging tables, skill-cost tables, salary tables, bonus tables, expense tables, examples, title/rank lists, or source prose.

Exact reward, salary, expense, aging, rank, and table values remain private source lookup.

## Validation Scenarios

| Prompt | Expected route | Result |
| --- | --- | --- |
| How much XP should I award after the session feedback? | `rules/campaign/advancement-and-rewards.md` | Pass: routes to the reward feedback workflow and preserves table-value lookup. |
| A character wants to train an Advanced Skill during downtime. | `rules/campaign/advancement-and-rewards.md` | Pass: routes to training requirements, trainer/facility/time checks, and downtime ownership. |
| A PC has a birthday during a long campaign gap. | `rules/campaign/advancement-and-rewards.md` plus source lookup | Pass with source lookup caveat: the route identifies aging as table-driven. |
| The crew earned a promotion, salary change, and mission bonus. | `rules/campaign/advancement-and-rewards.md`, then `rules/campaign/power-rank-and-title.md` if authority matters | Pass with source lookup caveat: salary/bonus/rank values remain table lookups and campaign obligations must be recorded. |
| A player takes a new negative trait during play. | `rules/campaign/advancement-and-rewards.md` and `rules/character-creation/traits.md` | Pass: the summary warns that play-inflicted or elected negative traits do not automatically grant creation-style XP. |

## Verification

Run these checks after the issue `#91` changes:

```powershell
./scripts/validate-rules-indexes.ps1
./scripts/test-route-rules-prompt.ps1
./scripts/test-all.ps1
```

## Status

Validated for routing and source-boundary behavior in issue `#91`. The summary remains `draft` because exact table values require private source lookup.
