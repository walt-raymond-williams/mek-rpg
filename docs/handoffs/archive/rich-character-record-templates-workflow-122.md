# Rich Character Templates And Workflow Handoff

## Issue

- GitHub issue: `#122`
- Roadmap entry: Rich PC/NPC character records for play
- Mode: Project development
- Priority: After issue `#121`

## Goal

Update campaign templates and GM workflow docs so rich PC/NPC records are created and maintained naturally during play.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- The schema doc produced by issue `#121`
- `campaigns/_template/pcs.md`
- `campaigns/_template/npcs.md`
- `campaigns/README.md`
- `gm/state-save-checklist.md`
- `docs/current/GM_CONTEXT_PACKET_DESIGN.md`

## Expected Output

- Updated PC and NPC templates with rich memory and portrayal fields.
- GM save/checkpoint guidance for when to create or update character records.
- Context-packet or campaign documentation links to the schema where useful.

## Files And Areas

Likely files to read or edit:

- `campaigns/_template/pcs.md`
- `campaigns/_template/npcs.md`
- `campaigns/README.md`
- `gm/state-save-checklist.md`
- `docs/current/GM_CONTEXT_PACKET_DESIGN.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
./scripts/validate-campaign-state.ps1 -CampaignId _template
git diff --check
```

## Constraints

- Do not rewrite existing live campaign records unless the issue explicitly scopes a migration.
- Keep templates readable in Markdown.
- Do not add deterministic validator logic here unless explicitly needed; issue `#124` owns that.

## Acceptance Criteria

- Templates reflect the schema from issue `#121`.
- GM save/context guidance tells future agents when character records should change.
- Verification is run or a blocker is recorded.

## Open Questions

- Should existing campaign folders be migrated immediately, or should the new template apply only to future and explicitly touched campaigns?
