# Core Interface Migration Evaluation

Status: issue `#79` evaluation.

Purpose: decide when MEK-RPG's mature deterministic prototypes should move from small PowerShell scripts to a shared library, CLI, local service, or dashboard adapter.

## Recommendation

Do not migrate to a service, dashboard adapter, or shared core library yet.

Keep the current Windows-first PowerShell prototype pattern for deterministic mechanics while contracts and play usage stabilize. Continue using Python only where it is already justified for structured parsing, such as read-only MekHQ save summaries.

The project now has enough experience to define promotion criteria:

- `docs/current/MECHANIC_CONTRACT_SCHEMA.md` defines the shared helper output shape.
- `docs/current/RULING_AUTHORITY_GATE.md` defines pre-ruling authority statuses.
- `docs/current/STATE_CHANGE_PROPOSAL_SCHEMA.md` defines proposal boundaries.
- `scripts/resolve-basic-check.ps1`, `scripts/resolve-opposed-check.ps1`, and `scripts/checkpoint-personal-combat.ps1` provide fixture-tested mechanic prototypes.
- `scripts/test-all.ps1` gives a deterministic regression path.

That is a good prototype baseline, not yet a reason to add runtime complexity.

## Current Prototype Baseline

Current mechanic-facing prototypes:

| Prototype | Mechanic id | Interface | Test |
| --- | --- | --- | --- |
| `scripts/resolve-basic-check.ps1` | `core.basic_check` | JSON file in, JSON stdout out | `scripts/test-resolve-basic-check.ps1` |
| `scripts/resolve-opposed-check.ps1` | `core.opposed_check` | JSON file in, JSON stdout out | `scripts/test-resolve-opposed-check.ps1` |
| `scripts/checkpoint-personal-combat.ps1` | `combat.personal_checkpoint` | JSON file in, JSON stdout out | `scripts/test-checkpoint-personal-combat.ps1` |

Supporting safety infrastructure:

| Helper | Role |
| --- | --- |
| `scripts/route-rules-prompt.ps1` | route metadata and page-reference reporting |
| `scripts/check-ruling-authority.ps1` | authority gate before rulings/resolvers |
| `scripts/validate-rules-indexes.ps1` | route, manifest, page-reference, and summary integrity |
| `scripts/test-all.ps1` | deterministic local verification |

The current shape is intentionally inspectable: a fixture is a normal JSON file, the output is normal JSON, and git diff shows every contract change.

## Options Compared

### Continue PowerShell Scripts

Use for the next phase.

Strengths:

- Lowest friction on the current Windows workspace.
- Easy for agents to inspect, patch, and run.
- Works well with JSON file fixtures and `test-all.ps1`.
- Keeps helper boundaries obvious: no hidden long-running state, no server lifecycle, no dashboard write path.
- Fits current scope where helpers are narrow and still changing.

Costs:

- Duplication grows as more helpers copy authority, citation, and no-mutation utilities.
- PowerShell object/JSON edge cases require discipline.
- Cross-platform reuse is weaker than TypeScript, Python, or Go.

Best use:

- Continue until at least several more real play sessions and fixture iterations prove stable input/output contracts.

### TypeScript Library Or CLI

Do not start yet.

Strengths:

- Strong fit for a later dashboard or browser-facing read-only adapter.
- Good JSON schema tooling and test ecosystem.
- Easier to share types between CLI, UI, and local adapters.

Costs:

- Adds Node dependency and package management.
- Premature if no UI or dashboard consumer needs shared types yet.
- Existing repository helpers are PowerShell/Python, so TypeScript would introduce a third main implementation environment.

Best trigger:

- A real read-only dashboard or structured local UI needs reusable contract types and pure functions.

### Python Library Or CLI

Do not move mechanic prototypes yet; continue Python for MekHQ parsing.

Strengths:

- Already used for `summarize-mekhq-save.py` and `bootstrap-mekhq-campaign.py`.
- Strong parsing, file handling, and test support.
- Cross-platform and easier to package than loose PowerShell for some users.

Costs:

- Mechanic prototypes are not data-heavy enough to justify conversion.
- Mixing rule adjudication with MekHQ parsing could blur ownership boundaries.
- Would still need a CLI wrapper for agents and users.

Best trigger:

- Shared logic between MekHQ checkpoint adapters, campaign validators, and mechanic helpers becomes repetitive enough to justify a Python package.

### Go CLI Or Service

Do not start now.

Strengths:

- Produces a single native binary.
- Good for fast validation, stable schemas, and robust CLI distribution.
- Strong fit if helpers become performance-sensitive or need strict typed contracts.

Costs:

- Higher implementation friction for a private rules-assistant workspace.
- Current helpers do not need binary distribution or long-running performance.
- Service mode would introduce lifecycle, port, and state concerns before they are needed.

Best trigger:

- Contracts are stable, helper count is high, and distribution as a single executable becomes more valuable than script inspectability.

### Local HTTP Service

Explicitly defer.

Strengths:

- Useful if a dashboard, browser extension, or multiple clients need to call the same resolver API.
- Can centralize schema validation, routing, authority gates, and proposal formatting.

Costs:

- Adds server lifecycle, authentication/boundary concerns, port conflicts, logging, and potential hidden state.
- Makes accidental write paths easier to create.
- Raises risk around protected source, MekHQ hard-ledger boundaries, and campaign mutation if not designed carefully.
- Current use is agent-driven CLI execution, not multi-client runtime access.

Best trigger:

- A read-only dashboard or tool integration exists and repeatedly needs live structured calls that cannot be satisfied by CLI JSON.

## Promotion Criteria

Do not promote a prototype to a shared library, CLI package, service, or dashboard adapter until all of these are true:

1. Stable JSON contract: input and output fields have survived multiple fixture and real-play iterations with only additive changes.
2. Authority gate behavior: helpers consume or reproduce `RULING_AUTHORITY_GATE.md` statuses and fail closed.
3. Fixture coverage: each mechanic has success, refusal, invalid input, citation/warning, no-hidden-mutation, and state-proposal fixtures where applicable.
4. Repeated real play use: at least several sessions use the helper shape without major contract churn.
5. Clear source/rule authority: helpers cite summaries/page references and do not read protected source or invent table values.
6. No hidden state mutation: helpers remain read-only unless a separate, explicit apply command is approved.
7. Clean agent/tool integration: agents can run the helper, parse JSON, inspect warnings, and report proposed changes without extra server state.
8. Shared logic pressure: at least three helpers duplicate the same nontrivial validation/formatting logic enough that a common module would reduce risk.
9. Consumer pressure: a real UI, dashboard, or external tool needs a stable interface beyond direct script execution.

## Migration Path

Recommended sequence:

1. Keep current PowerShell JSON-in/JSON-out scripts.
2. Factor only tiny shared patterns if duplication becomes error-prone, and prefer tests over abstraction.
3. Add JSON schema fixture validation before any language migration.
4. If a dashboard appears, create a read-only adapter that shells out to CLI helpers first.
5. If shell-out becomes brittle, promote pure contract logic into a TypeScript or Python library.
6. Only after that, consider a local HTTP service, and keep it read-only by default.

## What Not To Do

- Do not build a local HTTP service just because multiple scripts exist.
- Do not combine MekHQ hard-ledger application with mechanic resolution.
- Do not create write-enabled dashboard controls before read-only packets and proposal review are stable.
- Do not migrate source-processing helpers into live adjudication paths.
- Do not hide protected source, raw MekHQ saves, or campaign file mutation behind a server.

## Next Review Trigger

Revisit this evaluation after one of these happens:

- five or more mechanic helpers share duplicated validation and proposal-formatting logic
- a read-only dashboard is actively being implemented
- real play produces repeated friction with PowerShell JSON handling
- helper output needs to be consumed by a non-agent tool
- `STATE_CHANGE_PROPOSAL_SCHEMA.md` and mechanic contracts stabilize after multiple sessions

Until then, PowerShell prototypes with JSON fixtures remain the right level of machinery.
