# Script Mechanic Contract Audit

Status: issue `#73` audit. This document classifies current scripts against `docs/current/MECHANIC_CONTRACT_SCHEMA.md`, `docs/current/RULING_AUTHORITY_GATE.md`, and the deterministic mechanics roadmap.

## Audit Result

No existing script should be retired or converted into a service now. The current PowerShell/Python split is appropriate for a Windows-first private workspace while contracts and fixtures stabilize.

Near-term direction:

- Keep validation, routing, context, MekHQ bridge, archive, and test scripts as infrastructure.
- Treat `check-ruling-authority.ps1` as safety/authority infrastructure, not a mechanic resolver.
- Treat `route-rules-prompt.ps1` as routing metadata infrastructure, not rules authority.
- Treat `roll-dice.ps1` as a live-play utility only; it may later be wrapped by resolver prototypes, but it should not become an A Time of War resolver by itself.
- Add JSON contracts only where downstream automation needs structured output. Avoid broad rewrites just to normalize old helper output.

## Classification Vocabulary

| Classification | Meaning |
| --- | --- |
| `mechanic-adjacent utility` | Supports play or future mechanics but does not apply A Time of War procedure authority. |
| `mechanic prototype candidate` | May later implement part of `MECHANIC_CONTRACT_SCHEMA.md` after authority gating and fixtures exist. |
| `safety / authority infrastructure` | Prevents overclaiming authority, checks citations/routes/statuses, or blocks unsafe resolution. |
| `routing / metadata infrastructure` | Builds or reports lookup metadata without answering rules. |
| `campaign infrastructure` | Creates, validates, packages, or archives campaign files without resolving mechanics. |
| `MekHQ bridge infrastructure` | Reads or creates MEK-RPG bridge artifacts while preserving MekHQ hard-ledger ownership. |
| `source-processing support` | Used only during explicit source-processing work. |
| `test infrastructure` | Verifies deterministic behavior and boundaries. |

## Script Audit

| Script | Current classification | Mechanics relation | Disposition | Notes |
| --- | --- | --- | --- | --- |
| `scripts/roll-dice.ps1` | `mechanic-adjacent utility` | Supplies random dice totals only; no A Time of War interpretation, authority, citations, or state proposals. | Remain as-is for live play; future basic/opposed resolvers may call or duplicate its dice parsing under the mechanic contract. | Do not add rules outcomes here. |
| `scripts/route-rules-prompt.ps1` | `routing / metadata infrastructure` | Provides candidate files, manifest statuses, page references, and route warnings. | Remain as route helper with JSON output. | It must not answer rules; authority decisions belong to `check-ruling-authority.ps1`. |
| `scripts/check-ruling-authority.ps1` | `safety / authority infrastructure` | Produces the authority envelope needed before future resolvers. | Keep as authority gate; refine only as issue `#81` and `#83` add integrity/golden scenario coverage. | It is not a resolver. |
| `scripts/validate-rules-indexes.ps1` | `safety / authority infrastructure`, `routing / metadata infrastructure` | Verifies route/index/manifest/page-reference consistency. | Stay infrastructure-only. | Future issue `#81` should extend this area for source-offset/page-reference integrity rather than creating a separate service. |
| `scripts/report-rules-coverage.ps1` | `routing / metadata infrastructure` | Reports manifest coverage and status distribution. | Stay infrastructure-only with JSON output. | Useful for planning; not part of live adjudication. |
| `scripts/build-gm-context-packet.ps1` | `campaign infrastructure`, `safety / authority infrastructure` | Packages source paths and warnings for play context; does not interpret rules. | Stay infrastructure-only. | Do not add resolver logic; it may include authority-gate output later if a packet workflow needs it. |
| `scripts/validate-campaign-state.ps1` | `campaign infrastructure` | Validates active campaign pointer and save-folder structure. | Stay infrastructure-only. | Add focused companion validators later for PC sheets, vehicles, assets, or contracts instead of expanding this generically. |
| `scripts/new-campaign-save.ps1` | `campaign infrastructure` | Creates campaign folders from template. | Stay as-is. | No mechanic contract needed. |
| `scripts/archive-campaign-session.ps1` | `campaign infrastructure` | Archives exact session text with explicit confirmation. | Stay infrastructure-only. | It mutates campaign files by explicit command, not as a hidden mechanic side effect. |
| `scripts/validate-mekhq-pending-actions.ps1` | `MekHQ bridge infrastructure`, `safety / authority infrastructure` | Validates pending manual MekHQ application intents. | Stay infrastructure-only. | Keep hard-ledger ownership explicit; do not turn into MekHQ write automation. |
| `scripts/summarize-mekhq-save.py` | `MekHQ bridge infrastructure` | Reads MekHQ saves into read-only summary facts. | Keep as read-only bridge helper. | It can keep JSON/Markdown outputs; no mechanic contract unless a later adapter consumes summaries as explicit inputs. |
| `scripts/bootstrap-mekhq-campaign.py` | `MekHQ bridge infrastructure`, `campaign infrastructure` | Creates MEK-RPG campaign folders from summary JSON. | Stay infrastructure-only. | No direct MekHQ writeback and no inferred A Time of War stats. |
| `scripts/extract-pdf-pages.sh` | `source-processing support` | Extracts private PDF text into ignored paths for explicit source-processing tasks. | Stay explicit-request-only. | Never part of live adjudication or normal verification. |
| `scripts/build-rule-manifest.md` | `source-processing support`, `routing / metadata infrastructure` | Notes for future manifest generation. | Keep as notes until a real generator is justified. | No service conversion. |
| `scripts/summarize-section-prompt.md` | `source-processing support` | Prompt artifact for paraphrased summaries. | Keep as source-processing support. | Must preserve copyright boundaries. |
| `scripts/test-all.ps1` | `test infrastructure` | Runs deterministic local suites. | Stay top-level deterministic runner. | No mechanic behavior. |
| `scripts/test-route-rules-prompt.ps1` | `test infrastructure` | Verifies route helper and golden route fixtures. | Stay test-only. | Supports issue `#74` coverage. |
| `scripts/test-check-ruling-authority.ps1` | `test infrastructure` | Verifies authority gate status behavior. | Stay test-only. | Supports issue `#80` coverage. |
| `scripts/test-validate-rules-indexes.ps1` | `test infrastructure` | Verifies rules index validator. | Stay test-only. | May expand with issue `#81`. |
| `scripts/test-report-rules-coverage.ps1` | `test infrastructure` | Verifies coverage reporter. | Stay test-only. | No mechanic contract needed. |
| `scripts/test-build-gm-context-packet.ps1` | `test infrastructure` | Verifies context packet boundaries. | Stay test-only. | No mechanic contract needed. |
| `scripts/test-gm-context-regressions.ps1` | `test infrastructure` | Verifies context scenarios. | Stay test-only. | No mechanic contract needed. |
| `scripts/test-mekhq-context-packet.ps1` | `test infrastructure` | Verifies MekHQ-linked context scenarios. | Stay test-only. | No mechanic contract needed. |
| `scripts/test-validate-campaign-state.ps1` | `test infrastructure` | Verifies campaign-state validator. | Stay test-only. | No mechanic contract needed. |
| `scripts/test-validate-mekhq-pending-actions.ps1` | `test infrastructure` | Verifies pending action validator. | Stay test-only. | No mechanic contract needed. |
| `scripts/test-archive-campaign-session.ps1` | `test infrastructure` | Verifies archive helper. | Stay test-only. | No mechanic contract needed. |
| `scripts/test-summarize-mekhq-save.ps1` | `test infrastructure` | Verifies read-only save summary helper. | Stay test-only. | No mechanic contract needed. |
| `scripts/test-bootstrap-mekhq-campaign.ps1` | `test infrastructure` | Verifies campaign bootstrap helper. | Stay test-only. | No mechanic contract needed. |
| `scripts/test-mekhq-pending-workflow.ps1` | `test infrastructure` | Verifies pending workflow boundaries. | Stay test-only. | No mechanic contract needed. |
| `scripts/test-mekhq-checkpoint-fixture.ps1` | `test infrastructure` | Verifies checkpoint consumer fixture. | Stay test-only. | No mechanic contract needed. |
| `scripts/test-mekhq-checkpoint-prototype-fixture.ps1` | `test infrastructure` | Verifies prototype-output checkpoint fixture. | Stay test-only. | No mechanic contract needed. |
| `scripts/test-mekhq-checkpoint-edge-fixtures.ps1` | `test infrastructure` | Verifies checkpoint edge cases. | Stay test-only. | No mechanic contract needed. |

## JSON Output Recommendations

Already structured enough:

- `route-rules-prompt.ps1`
- `check-ruling-authority.ps1`
- `report-rules-coverage.ps1`
- `summarize-mekhq-save.py`

Could gain JSON only if a concrete consumer appears:

- `validate-rules-indexes.ps1`
- `validate-campaign-state.ps1`
- `validate-mekhq-pending-actions.ps1`
- `build-gm-context-packet.ps1`

Should remain human/command oriented for now:

- `roll-dice.ps1`
- `new-campaign-save.ps1`
- `archive-campaign-session.ps1`
- `bootstrap-mekhq-campaign.py`
- all test scripts

## Mechanic Prototype Boundaries

The next mechanic prototypes should be new scripts or narrowly scoped modules, not rewrites of existing infrastructure:

1. `#75` basic check resolver: consume explicit input values, authority-gate output, roll data, citations, warnings, and no-hidden-mutation proof.
2. `#76` opposed check resolver: extend the same contract with actor/defender inputs and comparative roll breakdowns.
3. `#78` state-change proposal schema: define proposal output before combat or campaign helpers suggest durable updates.
4. `#77` personal-combat checkpoint contract: wait until authority and state proposals are explicit.

Do not promote any script into a local service, shared library, dashboard adapter, or long-running process until repeated fixture-backed use shows stable contracts and a real integration need.

## Retirements

No script should be retired now. The repo still benefits from small, inspectable helpers with focused tests.
