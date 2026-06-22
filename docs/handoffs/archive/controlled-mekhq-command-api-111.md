# Agent Handoff

## Issue

- GitHub issue: `#111`
- Roadmap entry: Controlled MekHQ command API integration
- Mode: Project development / cross-workspace coordination
- Priority: Completed and archived

## Goal

Turn MEK-RPG's mature MekHQ integration posture into an executable command-side plan: explicit MekHQ-owned commands, stable selectors, guard fields, approval where needed, live reread verification, and no raw save/XML mutation.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- `docs/current/MEKHQ_COMMAND_API_STRATEGY.md`
- `docs/current/MEKHQ_LIVE_API_EXPANSION_TRACKING.md`
- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- `docs/current/STATE_CHANGE_PROPOSAL_SCHEMA.md`
- `docs/current/MEKHQ_CONTRACT_MARKET_PROBE_PLAN.md`
- `../megamek-workspace/docs/current/MEK_RPG_LIVE_MEKHQ_API_PROTOTYPE.md`

## Expected Output

- Choose the first command candidate to request or prototype from MEK-RPG's side. Current selected candidate is day advancement because the local producer side exposes `GET /campaign/commands` and the legacy guarded `POST /advance-day` prototype.
- Define the command request/response and verification contract for that first candidate.
- Identify the live API fields issue `#110` must expose or preserve for preflight and post-command verification.
- Update any remaining docs that imply read-only/manual-only operation is the permanent end state.
- Create or update producer-facing request notes for missing MegaMek/MekHQ command endpoints if needed.

## Files And Areas

Likely files to read or edit:

- `docs/current/MEKHQ_COMMAND_API_STRATEGY.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/current/MEKHQ_PENDING_APPLICATION_WORKFLOW.md`
- `docs/current/STATE_CHANGE_PROPOSAL_SCHEMA.md`
- `docs/current/MEKHQ_CONTRACT_MARKET_PROBE_PLAN.md`
- `docs/current/MEGAMEK_LIVE_API_CHANGE_REQUEST.md`
- `docs/current/MEK_RPG_LIVE_MEKHQ_API_RESPONSE_MEMO.md`
- `scripts/README.md`
- Future command adapter or test files once an endpoint exists

## Commands

Useful commands or checks:

```powershell
git status --short --branch
rg -n "read-only|writeback|command|advance day|pending MekHQ|manual UI" docs/current scripts gm
gh issue view 111 --comments
./scripts/test-all.ps1 -Quick
```

## Constraints

- Do not edit the MegaMek workspace from this repository unless the user explicitly asks for cross-repository changes.
- Do not implement raw `.cpnx`, `.cpnx.gz`, XML, or save-payload mutation.
- Do not implement a broad "apply any pending action" command.
- Do not execute commands against a real campaign from stale baseline state or ambiguous selectors.
- Keep read-only live state as the context and verification layer.
- Record command-side gaps as producer requests rather than inventing MEK-RPG-side save edits.

## Acceptance Criteria

- First command candidate is selected and justified: `advanceDayOnce` / `POST /advance-day`.
- Command envelope includes baseline guard fields, target selectors/readiness, dry-run/preflight behavior, approval behavior, execution result, and live reread verification.
- No new producer request is needed for the first command because local producer work already exposes `GET /campaign/commands` and `POST /advance-day`.
- Relevant docs no longer imply read-only/manual UI is the permanent endpoint.
- Verification is run or blockers are recorded.

## Completion Notes

- Updated `docs/current/MEKHQ_COMMAND_API_STRATEGY.md` with producer evidence, current `POST /advance-day` request/response behavior, current limitations, and the MEK-RPG-side reread verification contract.
- Updated live API tracking and producer request/response memos to distinguish read-only state payloads from command readiness and explicit command endpoints.
- Updated command docs in `docs/current/KNOWN_COMMANDS.md` and `scripts/README.md`.
- Updated roadmap and task state for issue `#111`.
- No raw source files, MekHQ saves, protected A Time of War text, or cross-repository files were edited.

## Open Questions

- The already-exposed day-advance API is available in the local MegaMek/MekHQ source branch as `POST /advance-day` with command `advanceDayOnce`, expected date, expected campaign id/name, optional daily nag suppression, and opt-in save-after-success. MEK-RPG still needs a consumer-side command adapter or manual smoke-test workflow before routine use.
- Should issue `#111` split into child issues for `advance_day`, `market_purchase`, and `contract_accept_decline`, or keep the first pass focused only on day advancement?
