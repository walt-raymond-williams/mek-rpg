# Scripts

- `extract-pdf-pages.sh`: extracts one text file per PDF page into `source/atow-text/`.
- `summarize-section-prompt.md`: reusable prompt for creating paraphrased rule summaries.
- `build-rule-manifest.md`: notes for future manifest generation.
- `new-campaign-save.ps1`: creates `campaigns/<campaign-id>/` from `campaigns/_template/` without overwriting an existing save.
- `validate-campaign-state.ps1`: checks the active campaign pointer, campaign template, and selected or explicit campaign save folder for deterministic structure problems.
- `validate-rules-indexes.ps1`: checks task-router links, rules-map links, page-reference links, manifest IDs, source-page metadata, related IDs, and missing summary files without reading protected source.
- `build-gm-context-packet.ps1`: reports the ordered GM context packet source files for the active or explicit campaign without interpreting rules, summarizing scenes, or mutating campaign files.
- `validate-mekhq-pending-actions.ps1`: validates `pending-mekhq-actions.md` item ids, allowed status/type/priority values, required fields, and unresolved pending-intent reporting.
- `roll-dice.ps1`: rolls simple expressions such as `2d6`, `2d6+2`, and `2d6-1` for live play.
- `summarize-mekhq-save.py`: reads a MekHQ `.cpnx`, `.cpnx.gz`, or plain campaign XML save and emits a read-only MEK-RPG bridge summary.
- `bootstrap-mekhq-campaign.py`: creates a MEK-RPG campaign save folder from `summarize-mekhq-save.py` JSON output.
- `test-mekhq-pending-workflow.ps1`: runs disposable regression checks for MekHQ pending-action bootstrap, validation, no-writeback boundaries, and protected-source guards.
- `test-bootstrap-mekhq-campaign.ps1`: runs fixture coverage for bootstrap campaign id validation, overwrite refusal, viewpoint selection, generated headings, ownership language, and cleanup.
- `test-summarize-mekhq-save.ps1`: runs sanitized XML and generated gzip fixture coverage for save-summary JSON/Markdown output and read-only behavior.
- `test-validate-campaign-state.ps1`: runs disposable positive and negative coverage for the campaign-state validator.
- `test-validate-rules-indexes.ps1`: runs disposable positive and negative coverage for the rules index validator.
- `test-validate-mekhq-pending-actions.ps1`: runs fixture coverage for the pending MekHQ action validator.
- `test-gm-context-regressions.ps1`: runs disposable context-packet regression scenarios for active campaign selection, memory layering, structured-state precedence, rules routing, missing-file warnings, protected-source boundaries, and read-only behavior.
- `test-mekhq-context-packet.ps1`: runs disposable MekHQ-linked context packet scenarios for bridge metadata, unresolved pending actions, pending-intent labeling, stale-memory avoidance, tactical handoff routing, protected-source/no-writeback boundaries, and read-only behavior.
- `test-all.ps1`: runs all deterministic local regression and unit-style checks that are safe for normal repository verification.

## Campaign Saves

```powershell
./scripts/new-campaign-save.ps1 my-campaign
./scripts/validate-campaign-state.ps1
./scripts/validate-campaign-state.ps1 -CampaignId playtest-galatea-dropship
./scripts/validate-campaign-state.ps1 -StrictActive
./scripts/build-gm-context-packet.ps1
./scripts/build-gm-context-packet.ps1 isekai-atlas-field -RunValidators
./scripts/test-build-gm-context-packet.ps1
./scripts/test-gm-context-regressions.ps1
./scripts/test-mekhq-context-packet.ps1
./scripts/test-validate-campaign-state.ps1
```

Campaign ids must use lowercase letters, numbers, and hyphens. The script refuses existing folders, rejects path traversal by construction, and does not edit `campaign-state/active-campaign.md`.

The validator reports `OK`, `WARN`, and `FAIL` lines. It checks `campaign-state/active-campaign.md`, required files in `campaigns/_template/`, and either the active campaign folder or the folder supplied with `-CampaignId`. By default, `Active campaign: None selected` is valid and does not fail; if no `-CampaignId` is supplied, the script warns that no save folder was checked. Use `-StrictActive` before play when an unselected active campaign should fail the check.

`test-validate-campaign-state.ps1` uses a disposable temp repository fixture through the validator's `-RepoRoot` test hook. It checks valid explicit campaign validation, missing standard file failure, missing top-level heading warnings, `-StrictActive` with no active campaign, legacy flat `campaign-state/` active pointer rejection, unsafe campaign id rejection, and one live explicit campaign validation.

When required campaign save files or persistent campaign-state structures change, update `validate-campaign-state.ps1` or add a narrower companion validator as part of the same task. Keep this validator focused on shared save-folder structure and active-campaign safety; deeper checks for character sheets, vehicles, contracts, or other specialized records can live in separate scripts when that keeps the boundary clearer.

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
```

The rules index validator checks deterministic lookup metadata only. It verifies that committed router, rules-map, page-reference, and manifest paths resolve where they should; manifest IDs are unique; allowed statuses are used; source page arrays exist where expected; related IDs resolve; and committed rule/index entries appear in the page-reference index. Mapped-only candidate paths are warnings rather than failures because they are future summary targets, not current rules authority.

## MekHQ Save Summaries

```powershell
python ./scripts/summarize-mekhq-save.py "C:\path\to\campaign.cpnx" --format json
python ./scripts/summarize-mekhq-save.py "C:\path\to\campaign.cpnx.gz" --format markdown
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign --viewpoint-person-id 12345
./scripts/test-summarize-mekhq-save.ps1
```

The helper detects gzip compression by magic bytes, parses the save XML with structured XML APIs, and writes JSON or Markdown to stdout. It does not write to the MekHQ save. JSON is the primary output for later bridge automation; Markdown is a quick human checkpoint. Field mappings and unsupported areas are documented in `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md`.

The save-summary fixture test uses committed sanitized XML plus a temp-generated gzip copy. It checks JSON top-level keys, representative campaign, finance, personnel, unit, contract, scenario, market, warning, and unsupported-field values; runs a Markdown smoke test; verifies sparse missing-section XML does not crash; and confirms the committed fixture is not mutated.

## MekHQ Campaign Bootstrap

```powershell
python ./scripts/summarize-mekhq-save.py "C:\path\to\campaign.cpnx" --format json > .\mekhq-summary.json
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign --viewpoint-person-id 12345
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign --embedded-pc-name "RPG Protagonist"
./scripts/test-bootstrap-mekhq-campaign.ps1
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
```

The pending-action validator checks item headings, required checklist fields, allowed lifecycle statuses, allowed action types, allowed priorities, date shapes, duplicate ids, and unresolved pending intents. `-ReportUnresolved` lists unresolved manual-action checklists for day-advance review and explicitly labels them as pending intents, not confirmed hard ledger facts.

The regression script uses `tests/fixtures/mekhq-summary-minimal.json` to bootstrap disposable `campaigns/mekhq-pending-regression-*` folders, checks that `pending-mekhq-actions.md` remains the pending queue owner, verifies `mekhq-bridge.md` points pending work to that file, confirms the campaign validator catches a missing pending-actions file, checks no direct MekHQ save/XML writeback is implied by the workflow docs, verifies protected source ignore rules, and removes disposable output before exit.

`test-all.ps1` is the top-level deterministic runner. It currently wraps the MekHQ pending workflow regression, bootstrap fixture coverage, save-summary fixture coverage, campaign-state validator coverage, pending-action validator coverage, rules index validator coverage, GM context packet helper coverage, GM context regression scenarios, and MekHQ-linked context packet scenarios. It does not require real MekHQ saves, protected source files, network access, or user interaction.
