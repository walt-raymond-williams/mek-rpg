# Agent Handoff

## Issue

- GitHub issue: `#52` Map transport acquisition and large-asset ownership source coverage
- Roadmap entry: DropShip and large-asset rules gap
- Mode: Source processing / planning
- Priority: Before writing transport or asset summaries

## Goal

Map whether A Time of War source coverage can support DropShip, transport, large-asset acquisition, ownership, crew, maintenance, permits, liens, and operating-cost summaries.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/SOURCE_PROCESSING_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issue `#52`

Task-specific context:

- `source/atow-chapter-section-map.md`
- `campaigns/playtest-galatea-dropship/rules-gaps.md`
- `rules/equipment/overview.md`
- `rules/campaign/contracts.md`
- `rules/vehicles-and-mechs/overview.md`

## Expected Output

- Completed: added `docs/current/TRANSPORT_LARGE_ASSET_SOURCE_COVERAGE.md`.
- Completed: recommended issue `#53` proceed with narrowed scope as a safe GM procedure, not a definitive DropShip ownership economy.
- Completed: updated roadmap and task tracking.

## Files And Areas

Likely files to read or edit:

- `docs/current/TRANSPORT_LARGE_ASSET_SOURCE_COVERAGE.md` or similar
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
rg -n "DropShip|transport|vehicle|ownership|maintenance|crew|fuel|property|wealth|contract|repair" source/atow-chapter-section-map.md rules docs/current campaigns
git check-ignore source/atow-pdf/example.pdf
git check-ignore source/atow-text/page-001.txt
git status --short --branch
```

## Constraints

- Mapping only; do not write GM-ready rules summaries in this issue.
- Use paraphrase and page references.
- Do not copy tables, price lists, item catalogs, or raw source text.

## Acceptance Criteria

- Relevant source sections and page ranges are identified or gaps are recorded.
- Rules coverage is separated from table-ruling, setting, MekHQ, or Classic BattleTech gaps.
- Table-heavy and unsupported areas are flagged.
- Follow-up summary issue readiness is recorded.
- Changes are committed and pushed.

## Open Questions

- Resolved for now: A Time of War supports acquisition scene framing, vehicle/fuel/trait/skill hooks, and campaign-state pressure, but most detailed DropShip ownership logistics should remain MekHQ/table-canon or external-source territory.
