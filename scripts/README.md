# Scripts

- `extract-pdf-pages.sh`: extracts one text file per PDF page into `source/atow-text/`.
- `summarize-section-prompt.md`: reusable prompt for creating paraphrased rule summaries.
- `build-rule-manifest.md`: notes for future manifest generation.
- `new-campaign-save.ps1`: creates `campaigns/<campaign-id>/` from `campaigns/_template/` without overwriting an existing save.
- `validate-campaign-state.ps1`: checks the active campaign pointer, campaign template, and selected or explicit campaign save folder for deterministic structure problems.
- `validate-rules-indexes.ps1`: checks task-router links, rules-map links, page-reference links, manifest IDs, source-page metadata, source-offset assumptions, manifest/page-reference/source-reference consistency, related IDs, and missing summary files without reading protected source.
- `report-rules-coverage.ps1`: reports rules coverage by subsystem and status from committed manifest metadata, with text output by default and optional JSON.
- `route-rules-prompt.ps1`: scores a short rules/play prompt against committed router rows and reports candidate files, manifest statuses, page references, and warnings without answering the rule.
- `check-ruling-authority.ps1`: evaluates the primary route-helper candidate and reports whether the prompt is authoritative, provisional, source-lookup-required, external-authority-required, cannot-adjudicate, or blocked/missing-route without answering the rule.
- `resolve-basic-check.ps1`: JSON-in/JSON-out prototype for `core.basic_check` that consumes an authority envelope, explicit target number, modifiers, and a fixed or random `2d6` roll; it returns a provisional/resolved result or refuses unsafe authority without mutating state.
- `resolve-opposed-check.ps1`: JSON-in/JSON-out prototype for `core.opposed_check` that consumes actor/defender inputs, an authority envelope, and fixed or random `2d6` rolls for both sides; it reports comparative margins or refuses unsafe authority without mutating state.
- `checkpoint-personal-combat.ps1`: JSON-in/JSON-out prototype for `combat.personal_checkpoint` that tracks RPG-scale personal combat checkpoint state, emits state-change proposals through the agreed schema, and refuses scenes that require tactical handoff.
- `build-gm-context-packet.ps1`: reports the ordered GM context packet source files for the active or explicit campaign without interpreting rules, summarizing scenes, or mutating campaign files.
- `export-dashboard-data.ps1`: emits read-only `dashboard-data/v1` JSON for an explicit or active campaign, including source records, health, panels, warnings, protected-source exclusions, and optional sanitized MekHQ summary metadata.
- `archive-campaign-session.ps1`: appends an exact copy of a campaign `session-log.md` into campaign-local `previous-sessions.md`, with explicit confirmation, optional reset, and temp backups.
- `validate-mekhq-pending-actions.ps1`: validates `pending-mekhq-actions.md` item ids, allowed status/type/priority values, required fields, and unresolved pending-intent reporting.
- `roll-dice.ps1`: rolls simple expressions such as `2d6`, `2d6+2`, and `2d6-1` for live play.
- `summarize-mekhq-save.py`: reads a MekHQ `.cpnx`, `.cpnx.gz`, or plain campaign XML save and emits a read-only MEK-RPG bridge summary.
- `bootstrap-mekhq-campaign.py`: creates a MEK-RPG campaign save folder from `summarize-mekhq-save.py` JSON output.
- `test-mekhq-pending-workflow.ps1`: runs disposable regression checks for MekHQ pending-action bootstrap, validation, no-writeback boundaries, and protected-source guards.
- `test-bootstrap-mekhq-campaign.ps1`: runs fixture coverage for bootstrap campaign id validation, overwrite refusal, viewpoint selection, generated headings, ownership language, and cleanup.
- `test-summarize-mekhq-save.ps1`: runs sanitized XML and generated gzip fixture coverage for save-summary JSON/Markdown output and read-only behavior.
- `test-mekhq-checkpoint-fixture.ps1`: runs fixture coverage for the sanitized MekHQ read-only checkpoint export shape and trust-boundary metadata.
- `test-mekhq-checkpoint-prototype-fixture.ps1`: runs fixture coverage for a sanitized compact excerpt of jar-backed prototype output from a disposable MekHQ save.
- `test-mekhq-checkpoint-edge-fixtures.ps1`: runs edge-case fixture coverage for sparse, warning-heavy, unsupported, and missing optional checkpoint export data.
- `test-mekhq-live-api-fixtures.ps1`: runs fixture coverage for sanitized live MekHQ local-control API summary, state, and warning-heavy payloads without calling a running MekHQ instance.
- `test-validate-campaign-state.ps1`: runs disposable positive and negative coverage for the campaign-state validator.
- `test-validate-rules-indexes.ps1`: runs disposable positive and negative coverage for the rules index validator.
- `test-report-rules-coverage.ps1`: smoke-tests the rules coverage reporter text and JSON output.
- `test-route-rules-prompt.ps1`: tests the rules route helper text/JSON output plus golden prompt fixtures for common RPG procedures, next-wave advancement/rewards, special hazards, special equipment, missing routes, tactical handoff, and source-review gaps.
- `test-check-ruling-authority.ps1`: tests the ruling authority gate across live route prompts and disposable status fixtures for draft, next-wave provisional routes, exact table/source-lookup prompts, source-reviewed-routing-aid, mapped-only, partial-draft, source-lookup-only, needs-source-review, missing metadata, tactical handoff, and missing routes.
- `test-resolve-basic-check.ps1`: tests the basic check resolver success, source-lookup refusal, citation/warning preservation, and no-hidden-mutation behavior.
- `test-resolve-opposed-check.ps1`: tests the opposed check resolver success, tied-margin handling, source-lookup refusal, citation/warning preservation, and no-hidden-mutation behavior.
- `test-checkpoint-personal-combat.ps1`: tests the personal-combat checkpoint prototype, state proposal schema output, tactical handoff refusal, and no-hidden-mutation behavior.
- `test-export-dashboard-data.ps1`: uses a disposable campaign fixture to check `dashboard-data/v1` output, explicit and active campaign selection, protected-source/raw-save exclusion, sanitized MekHQ summary handling, missing/invalid campaign failures, and no mutation of campaign files or the active pointer.
- `test-archive-campaign-session.ps1`: runs disposable campaign-save coverage for the session archive helper's confirmation, preview, archive, reset, validation, and cleanup behavior.
- `test-validate-mekhq-pending-actions.ps1`: runs fixture coverage for the pending MekHQ action validator.
- `test-gm-context-regressions.ps1`: runs disposable context-packet regression scenarios for active campaign selection, memory layering, structured-state precedence, rules routing, missing-file warnings, protected-source boundaries, and read-only behavior.
- `test-mekhq-context-packet.ps1`: runs disposable MekHQ-linked context packet scenarios for bridge metadata, unresolved pending actions, pending-intent labeling, stale-memory avoidance, tactical handoff routing, protected-source/no-writeback boundaries, and read-only behavior.
- `test-all.ps1`: runs all deterministic local regression and unit-style checks that are safe for normal repository verification, prints per-suite timing, supports `-Quick` for routine non-rules close-out, and supports `-ListSuites`.

## Campaign Saves

```powershell
./scripts/new-campaign-save.ps1 my-campaign
./scripts/validate-campaign-state.ps1
./scripts/validate-campaign-state.ps1 -CampaignId playtest-galatea-dropship
./scripts/validate-campaign-state.ps1 -StrictActive
./scripts/build-gm-context-packet.ps1
./scripts/build-gm-context-packet.ps1 isekai-atlas-field -RunValidators
./scripts/export-dashboard-data.ps1 -CampaignId isekai-atlas-field
./scripts/export-dashboard-data.ps1 -CampaignId isekai-atlas-field -IncludeExcerpts
./scripts/export-dashboard-data.ps1 -CampaignId mekhq-pending-playtest -MekHqSummaryJson tests/fixtures/mekhq-summary-minimal.json
./scripts/export-dashboard-data.ps1 -CampaignId mekhq-pending-playtest -MekHqLiveApiJson tests/fixtures/mekhq-live-campaign-state.fixture.json
./scripts/archive-campaign-session.ps1 my-campaign -ConfirmArchive -ArchiveTitle "Session 3 - Depot Escape"
./scripts/archive-campaign-session.ps1 my-campaign -ConfirmArchive -ResetSessionLog -ArchiveTitle "Session 3 - Depot Escape"
./scripts/archive-campaign-session.ps1 -UseActive -ConfirmArchive -WhatIf
./scripts/test-build-gm-context-packet.ps1
./scripts/test-export-dashboard-data.ps1
./scripts/test-archive-campaign-session.ps1
./scripts/test-gm-context-regressions.ps1
./scripts/test-mekhq-context-packet.ps1
./scripts/test-validate-campaign-state.ps1
```

Campaign ids must use lowercase letters, numbers, and hyphens. The script refuses existing folders, rejects path traversal by construction, and does not edit `campaign-state/active-campaign.md`.

The validator reports `OK`, `WARN`, and `FAIL` lines. It checks `campaign-state/active-campaign.md`, required files in `campaigns/_template/`, and either the active campaign folder or the folder supplied with `-CampaignId`. By default, `Active campaign: None selected` is valid and does not fail; if no `-CampaignId` is supplied, the script warns that no save folder was checked. Use `-StrictActive` before play when an unselected active campaign should fail the check.

`test-validate-campaign-state.ps1` uses a disposable temp repository fixture through the validator's `-RepoRoot` test hook. It checks valid explicit campaign validation, missing standard file failure, missing top-level heading warnings, `-StrictActive` with no active campaign, legacy flat `campaign-state/` active pointer rejection, unsafe campaign id rejection, and one live explicit campaign validation.

When required campaign save files or persistent campaign-state structures change, update `validate-campaign-state.ps1` or add a narrower companion validator as part of the same task. Keep this validator focused on shared save-folder structure and active-campaign safety; deeper checks for character sheets, vehicles, contracts, or other specialized records can live in separate scripts when that keeps the boundary clearer.

## Session Archive Helper

```powershell
./scripts/archive-campaign-session.ps1 my-campaign -ConfirmArchive -ArchiveTitle "Session 3 - Depot Escape"
./scripts/archive-campaign-session.ps1 my-campaign -ConfirmArchive -ResetSessionLog -ArchiveTitle "Session 3 - Depot Escape"
./scripts/archive-campaign-session.ps1 -UseActive -ConfirmArchive -WhatIf
./scripts/test-archive-campaign-session.ps1
```

The archive helper requires either an explicit campaign id or `-UseActive`, and it refuses to mutate files unless `-ConfirmArchive` is supplied. Use `-WhatIf` to preview the selected campaign, target files, title, reset choice, and backup directory without changing anything.

The helper appends the exact current `session-log.md` text to `previous-sessions.md` with a timestamped wrapper. It does not summarize, rewrite, or invent completed-session text. Before changing files, it copies `session-log.md` and `previous-sessions.md` to a temp backup folder. Add `-ResetSessionLog` only when the current session log should be replaced with a fresh template containing an archive note.

## GM Context Packet

```powershell
./scripts/build-gm-context-packet.ps1
./scripts/build-gm-context-packet.ps1 isekai-atlas-field
./scripts/build-gm-context-packet.ps1 -RunValidators
./scripts/test-build-gm-context-packet.ps1
```

The context packet helper reads `campaign-state/active-campaign.md` unless a campaign id is supplied, checks the selected `campaigns/<campaign-id>/` folder, and prints the packet sections from `docs/current/GM_CONTEXT_PACKET_DESIGN.md`: request/mode inputs, active campaign, authority notes, current scene state, MekHQ bridge and pending intents, rules routes, recent events, durable memory, and warnings. It packages source paths only; it does not read ignored raw source text, interpret A Time of War rules, summarize play, advance time, apply pending MekHQ actions, or rewrite campaign files.

Use `-RunValidators` to append output from `validate-campaign-state.ps1` and `validate-mekhq-pending-actions.ps1 -ReportUnresolved`. Validator failures are reported as warnings inside the packet report so the user can inspect the source problem directly.

`docs/current/GM_CONTEXT_REGRESSION_SCENARIOS.md` records the manual and scripted scenario set for continuity, rules routing, state ownership, tactical handoff, and MekHQ boundary checks. `test-gm-context-regressions.ps1` covers the deterministic scenarios that can be verified without live play judgment. `test-mekhq-context-packet.ps1` adds MekHQ-linked packet coverage using fixture bridge metadata and unresolved pending actions.

## Dashboard Data Adapter

```powershell
./scripts/export-dashboard-data.ps1
./scripts/export-dashboard-data.ps1 -CampaignId isekai-atlas-field
./scripts/export-dashboard-data.ps1 -CampaignId isekai-atlas-field -IncludeExcerpts
./scripts/export-dashboard-data.ps1 -CampaignId mekhq-pending-playtest -MekHqSummaryJson tests/fixtures/mekhq-summary-minimal.json
./scripts/test-export-dashboard-data.ps1
```

The dashboard adapter emits UTF-8 JSON with `schema_version: dashboard-data/v1`. It resolves the active campaign pointer or an explicit campaign id, inventories standard campaign files as source records, reports health and protected-source exclusions, includes read-only validator/context-helper output as labeled tool output, summarizes optional sanitized MekHQ summary JSON without following raw save paths, and summarizes optional sanitized MekHQ live API JSON as live context rather than durable checkpoint/import fact. It does not write files, select campaigns, run git actions, read protected source paths, read raw MekHQ saves, call a live MekHQ API, interpret rules, or apply pending MekHQ actions.

`test-export-dashboard-data.ps1` uses a disposable campaign folder to check explicit and active campaign selection, required panels, sanitized MekHQ summary metadata, sanitized live API summary/state/warning-heavy metadata, live-context-not-durable labeling, missing/invalid campaign failures, raw save rejection, protected-source exclusion labels, and no mutation of campaign files, pending actions, or the active pointer.

## Dice Rolls

```powershell
./scripts/roll-dice.ps1 2d6
./scripts/roll-dice.ps1 2d6+2 "Technician check"
```

The roller reports the expression, individual dice, modifier, and total. It does not apply A Time of War outcomes or rule logic.

## Rules Index Validation

```powershell
./scripts/validate-rules-indexes.ps1
./scripts/test-validate-rules-indexes.ps1
./scripts/report-rules-coverage.ps1
./scripts/report-rules-coverage.ps1 -Format json
./scripts/test-report-rules-coverage.ps1
./scripts/route-rules-prompt.ps1 "Can I shoot from cover?"
./scripts/route-rules-prompt.ps1 "BattleMech heat and tactical movement" -Format json
./scripts/test-route-rules-prompt.ps1
./scripts/check-ruling-authority.ps1 "Can I shoot from cover?"
./scripts/check-ruling-authority.ps1 "BattleMech heat and tactical movement" -Format json
./scripts/test-check-ruling-authority.ps1
./scripts/resolve-basic-check.ps1 -InputFile tests/fixtures/basic-check-success.fixture.json
./scripts/test-resolve-basic-check.ps1
./scripts/resolve-opposed-check.ps1 -InputFile tests/fixtures/opposed-check-success.fixture.json
./scripts/test-resolve-opposed-check.ps1
./scripts/checkpoint-personal-combat.ps1 -InputFile tests/fixtures/personal-combat-checkpoint-success.fixture.json
./scripts/test-checkpoint-personal-combat.ps1
```

The rules index validator checks deterministic lookup metadata only. It verifies that committed router, rules-map, page-reference, and manifest paths resolve where they should; manifest IDs are unique; allowed statuses are used; source page arrays exist where expected; PDF/printed page offsets match the committed `PDF page = printed page + 2` assumption; related IDs resolve; committed rule/index entries appear in the page-reference index; manifest source pages are covered by page-reference rows; and committed summaries with manifest coverage include matching `Source References`. Mapped-only candidate paths are warnings rather than failures because they are future summary targets, not current rules authority.

The rules coverage reporter groups manifest entries by subsystem and status. Text output is for human planning; JSON output is for future tooling. It distinguishes drafted/routed entries, validation-report-backed draft areas, mapped-only placeholders, partial drafts that still need source review for mapped targets, source-reviewed routing aids, and source-lookup-only back matter. It reads committed metadata only and does not inspect protected source files.

The route helper uses deterministic keyword scoring against `indexes/task-router.md`, then annotates routed files with manifest statuses and page-reference warnings. It is not rules authority and says so in the output; read the routed summaries or GM procedures before making a ruling.

`test-route-rules-prompt.ps1` uses `tests/fixtures/rules-route-golden-prompts.fixture.json` to check common route behavior for simple checks, opposed checks, Edge use, initiative, ranged and melee attacks, damage/wounds, recovery, equipment use, campaign consequences, advancement/rewards, special hazards, special equipment, vehicle piloting, tactical handoff, ambiguous rulings, missing rules, and source-review gaps.

The ruling authority gate consumes route-helper output and evaluates the primary candidate. It returns an authority envelope for later helpers: `authoritative`, `provisional`, `source_lookup_required`, `external_authority_required`, `cannot_adjudicate`, or `blocked_missing_route`. It reports routed files, manifest ids/statuses, page-reference text, warnings, required next action, and source-boundary proof; it never answers the rule.

The basic check resolver is the first narrow mechanic prototype. It requires JSON input with `mechanic_id: core.basic_check`, an authority envelope, explicit `mechanic_inputs.target_number`, optional explicit modifiers, and a fixed or random `2d6` roll. It reports roll breakdown, success/failure, margin, degree, citations, warnings, empty proposed state changes, and no-hidden-mutation proof. It refuses source-lookup, external-authority, cannot-adjudicate, and missing-route authority statuses instead of inventing mechanics.

The opposed check resolver follows the same contract for `mechanic_id: core.opposed_check`. It requires `participants.actor`, `participants.defender`, `mechanic_inputs.actor`, `mechanic_inputs.defender`, and `rolls.actor` / `rolls.defender`. It resolves each side against its explicit target number, compares margins, reports actor/defender roll breakdowns, winner or no-clean-winner outcomes, net margin, degree, citations, warnings, empty proposed state changes, unresolved GM follow-up for ties or mutual failures, and no-hidden-mutation proof.

The personal-combat checkpoint prototype follows the same top-level helper contract for `mechanic_id: combat.personal_checkpoint`. It accepts explicit personal-scale checkpoint state for setup, initiative, action, end, or closeout phases, reports turn/phase/active actor/initiative/effects/action tracking, emits only schema-shaped state-change proposals, and returns `external_authority_required` when BattleTech/MegaMek/MekHQ tactical detail is needed.

## MekHQ Save Summaries

```powershell
python ./scripts/summarize-mekhq-save.py "C:\path\to\campaign.cpnx" --format json
python ./scripts/summarize-mekhq-save.py "C:\path\to\campaign.cpnx.gz" --format markdown
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign --viewpoint-person-id 12345
./scripts/test-summarize-mekhq-save.ps1
./scripts/test-mekhq-checkpoint-fixture.ps1
./scripts/test-mekhq-checkpoint-prototype-fixture.ps1
./scripts/test-mekhq-checkpoint-edge-fixtures.ps1
./scripts/test-mekhq-live-api-fixtures.ps1
```

The helper detects gzip compression by magic bytes, parses the save XML with structured XML APIs, and writes JSON or Markdown to stdout. It does not write to the MekHQ save. JSON is the primary output for later bridge automation; Markdown is a quick human checkpoint. Field mappings and unsupported areas are documented in `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md`.

The save-summary fixture test uses committed sanitized XML plus a temp-generated gzip copy. It checks JSON top-level keys, representative campaign, finance, personnel, unit, contract, scenario, market, warning, and unsupported-field values; runs a Markdown smoke test; verifies sparse missing-section XML does not crash; and confirms the committed fixture is not mutated.

The checkpoint fixture test uses `tests/fixtures/mekhq-read-only-checkpoint.fixture.json`, copied from the MegaMek workspace sanitized checkpoint fixture. It checks the draft `mekhq-read-only-checkpoint` top-level shape, value/evidence/method-backed/source-owner envelopes, representative campaign, finance, personnel, unit, contract, scenario, report, market, warning, unsupported-field, and no-stable-market-selector boundaries.

The prototype-output fixture test uses `tests/fixtures/mekhq-read-only-checkpoint.prototype-output.fixture.json`, a sanitized compact excerpt from the MegaMek workspace jar-backed prototype exporter run against a copied disposable `The Learning Ropes` save. It preserves observed counts and representative method-backed values while sanitizing the input path, person names, long maintenance/report text, and local scratch paths. This fixture is experimental adapter coverage, not a production MekHQ exporter contract.

The edge-case fixture test uses `tests/fixtures/mekhq-read-only-checkpoint.edge-cases.fixture.json`, a fake sparse checkpoint with empty personnel/unit/scenario arrays, shallow contract terms, unknown finance/location values, warning-heavy logistics/report sections, a unit-market offer with no stable selector and no final price, and unsupported entries that distinguish automation blockers from FYI gaps. It is a committed sanitized fixture only, not production exporter output.

The live API fixture test uses `tests/fixtures/mekhq-live-campaign-summary.fixture.json`, `tests/fixtures/mekhq-live-campaign-state.fixture.json`, and `tests/fixtures/mekhq-live-campaign-warning-heavy.fixture.json` copied from the MegaMek workspace live local-control API prototype. It checks summary/state/warning-heavy shapes, live-context metadata, method-backed trust envelopes, dirty-state unknown handling, read-only proof, unsupported/blocking entries, sanitation boundaries, and fixture no-mutation behavior. These fixtures are fake sanitized live-context examples, not durable checkpoint imports and not real campaign facts.

## MekHQ Campaign Bootstrap

```powershell
python ./scripts/summarize-mekhq-save.py "C:\path\to\campaign.cpnx" --format json > .\mekhq-summary.json
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign --viewpoint-person-id 12345
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign --embedded-pc-name "RPG Protagonist"
./scripts/test-bootstrap-mekhq-campaign.ps1
```

When creating a JSON summary file in Windows PowerShell, prefer an explicit UTF-8 write instead of `>` redirection if `bootstrap-mekhq-campaign.py` will read the file:

```powershell
$summary = ".\mekhq-summary.json"
$json = & python ./scripts/summarize-mekhq-save.py "C:\path\to\campaign.cpnx" --format json
[System.IO.File]::WriteAllText([System.IO.Path]::GetFullPath($summary), ($json -join [Environment]::NewLine), [System.Text.UTF8Encoding]::new($false))
python ./scripts/bootstrap-mekhq-campaign.py --summary $summary --campaign-id my-linked-campaign
```

The bootstrap helper consumes only summary JSON, copies `campaigns/_template/`, refuses existing campaign folders, does not edit `campaign-state/active-campaign.md`, and writes a campaign-local `mekhq-bridge.md` with source metadata, warnings, cross-references, and pending MekHQ application notes. See `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md` for the generated file convention and ownership boundary.

The bootstrap fixture test uses `tests/fixtures/mekhq-summary-minimal.json` and disposable `campaigns/mekhq-bootstrap-test-*` folders. It checks valid bootstrap output, invalid campaign id rejection, existing-folder refusal, viewpoint selection by id and exact name, commander fallback, embedded PC generation, required headings, ownership/no-writeback language, active pointer preservation, and cleanup.

## MekHQ Pending Workflow Regression

```powershell
./scripts/validate-mekhq-pending-actions.ps1 campaigns/_template/pending-mekhq-actions.md
./scripts/validate-mekhq-pending-actions.ps1 campaigns/isekai-atlas-field/pending-mekhq-actions.md -ReportUnresolved
./scripts/test-validate-mekhq-pending-actions.ps1
./scripts/test-mekhq-pending-workflow.ps1
./scripts/test-all.ps1
./scripts/test-all.ps1 -Quick
./scripts/test-all.ps1 -ListSuites
```

The pending-action validator checks item headings, required checklist fields, allowed lifecycle statuses, allowed action types, allowed priorities, date shapes, duplicate ids, and unresolved pending intents. `-ReportUnresolved` lists unresolved manual-action checklists for day-advance review and explicitly labels them as pending intents, not confirmed hard ledger facts.

The regression script uses `tests/fixtures/mekhq-summary-minimal.json` to bootstrap disposable `campaigns/mekhq-pending-regression-*` folders, checks that `pending-mekhq-actions.md` remains the pending queue owner, verifies `mekhq-bridge.md` points pending work to that file, confirms the campaign validator catches a missing pending-actions file, checks no direct MekHQ save/XML writeback is implied by the workflow docs, verifies protected source ignore rules, and removes disposable output before exit.

`test-all.ps1` is the top-level deterministic runner. It currently wraps the MekHQ pending workflow regression, bootstrap fixture coverage, save-summary fixture coverage, checkpoint export fixture coverage, checkpoint prototype-output fixture coverage, checkpoint edge-case fixture coverage, live API fixture coverage, campaign-state validator coverage, pending-action validator coverage, rules index validator coverage, rules coverage reporter smoke tests, rules route helper golden fixture tests, ruling authority gate fixture tests, basic check resolver fixture tests, opposed check resolver fixture tests, personal-combat checkpoint fixture tests, GM context packet helper coverage, read-only dashboard data adapter coverage, campaign session archive helper coverage, GM context regression scenarios, and MekHQ-linked context packet scenarios. It does not require real MekHQ saves, protected source files, network access, or user interaction. It prints per-suite timing so slow checks are visible. The full runner can take several minutes because route-helper, authority-gate, and dashboard adapter fixture suites invoke several helper scripts. Use `-Quick` for routine non-rules/non-dashboard close-out and full `test-all.ps1` when routing, manifest, page-reference, rules-summary, route-helper, authority-gate, or dashboard adapter behavior changes.
