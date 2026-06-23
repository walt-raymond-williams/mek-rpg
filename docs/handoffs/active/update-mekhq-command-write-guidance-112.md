# Agent Handoff

## Issue

- GitHub issue: `#112` Update MEK-RPG guidance for guarded MekHQ command writes
- Roadmap entry: Controlled MekHQ command API integration
- Mode: Project development
- Priority: High; this corrects live-play GM behavior after stale guidance caused a manual pending item for a supported contract command.

## Goal

Update MEK-RPG guidance and tooling so supported MekHQ hard-ledger actions use guarded MekHQ-owned command APIs instead of defaulting to manual-only pending actions. The first concrete case is contract selection through `POST /campaign/command/contracts/accept`.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/current/MEKHQ_COMMAND_API_STRATEGY.md`
- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/GM_CONTEXT_PACKET_DESIGN.md`
- `gm/session-procedure.md`
- `gm/state-save-checklist.md`
- `campaigns/the-learning-ropes/session-log.md`
- `campaigns/the-learning-ropes/pending-mekhq-actions.md`
- `campaigns/the-learning-ropes/missions.md`

Producer-side evidence to inspect:

- `../megamek-workspace/docs/current/MEK_RPG_LIVE_MEKHQ_API_PROTOTYPE.md`
- `../megamek-workspace/docs/current/MEK_RPG_LIVE_MEKHQ_CONTRACT_ACCEPT_COMMAND_DESIGN.md`
- `../megamek-workspace/docs/current/MEK_RPG_LIVE_MEKHQ_COMMAND_API_STRATEGY.md`
- `../megamek-workspace/docs/templates/mekhq-live-campaign-commands.fixture.json`
- `../megamek-workspace/external/src/mekhq/MekHQ/src/mekhq/service/LocalControlService.java`
- `../megamek-workspace/external/src/mekhq/MekHQ/src/mekhq/service/LocalCommandReadinessExporter.java`

## Expected Output

- MEK-RPG docs say supported commands should be discovered through `GET /campaign/commands` and called through guarded MekHQ command endpoints with dry-run/preflight, approval policy, execution, live reread, and verification.
- `contracts.accept` is documented as implemented locally when the readiness endpoint reports it available.
- `pending-mekhq-actions.md` guidance treats supported actions as command proposals/results/verification records, with manual UI checklists only for unsupported commands or unavailable endpoints.
- Stale "manual-only" and "contract accept unsupported" language is updated in live play guidance, context packet guidance, pending workflow docs, tests, and campaign templates.
- The `the-learning-ropes` pending contract acceptance item is reconciled or clearly marked as superseded by a command attempt path.

## Files And Areas

Likely files to edit:

- `docs/current/MEKHQ_COMMAND_API_STRATEGY.md`
- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- `docs/current/MEKHQ_LINKED_PLAY_LOOP.md`
- `docs/current/GM_CONTEXT_PACKET_DESIGN.md`
- `docs/current/MEKHQ_LIVE_API_EXPANSION_TRACKING.md`
- `docs/current/MEKHQ_LINKED_ATOW_WORKFLOW_REQUIREMENTS.md`
- `gm/session-procedure.md`
- `gm/state-save-checklist.md`
- `gm/tactical-encounter-handoff-checklist.md`
- `campaigns/_template/pending-mekhq-actions.md`
- `campaigns/_template/assets.md`
- `scripts/validate-mekhq-pending-actions.ps1`
- `scripts/test-validate-mekhq-pending-actions.ps1`
- `scripts/test-mekhq-context-packet.ps1`
- `tests/fixtures/*mekhq*commands*`
- `campaigns/the-learning-ropes/*` only for the specific playtest reconciliation.

## Commands

Useful commands or checks:

```powershell
git status --short --branch
rg -n "manual-action|manual UI|contract acceptance|contract accept|accept/decline|read-only-only|no-writeback|pending MekHQ|pending-mekhq|contracts.accept|commands/accept" docs gm campaigns scripts tests
git -C ..\megamek-workspace\external\src\mekhq log --oneline -8
rg -n "contracts/accept|contracts.accept|acceptContract" ..\megamek-workspace\external\src\mekhq\MekHQ\src ..\megamek-workspace\docs
.\scripts\test-all.ps1 -Quick
```

## Constraints

- Do not edit the MegaMek workspace from this repository task unless the user explicitly redirects into that repository.
- Do not mutate `.cpnx`, `.cpnx.gz`, raw XML, or raw MekHQ save payloads.
- Do not make hidden MekHQ command calls from docs/tests. Live command execution needs current baseline guards and explicit user approval unless an automation policy is documented.
- Preserve MekHQ as hard-ledger authority; MEK-RPG records RPG narrative context and verified command results.
- Keep unsupported actions as producer requests or blocked command proposals, not raw save edits.
- Avoid staging unrelated campaign play changes unless the issue intentionally reconciles them.

## Acceptance Criteria

- Issue `#112` body and this handoff agree on scope.
- Docs no longer imply that supported contract choices must become manual-only pending actions.
- Contract accept flow includes readiness, dry-run, execute, live reread verification, and reconciliation.
- Pending-action validation/tests use neutral command-proposal wording or distinguish manual-only unsupported items from command-supported items.
- Fixture or test coverage reflects `contracts.accept`, or a clear blocker records that the producer fixture is stale and must be refreshed.
- Verification run or blocker is recorded.
- No protected raw source is staged.
- Changes are committed and pushed.

## Open Questions

- Does the current running source-built MekHQ instance expose `contracts.accept` in `GET /campaign/commands`, or do MEK-RPG tests need to use a documented fixture until a live smoke is available?
- Should contract selection be allowed after one dry-run plus user approval in play mode, or should every live contract command require a separate explicit confirmation until the automation policy matures?
- Should `pending-mekhq-actions.md` keep the old name, or should future work introduce a more general `mekhq-command-actions.md` while keeping backward compatibility?
