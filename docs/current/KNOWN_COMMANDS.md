# Known Commands

Run commands from the repository root unless noted otherwise.

## Git And GitHub

```powershell
git status --short --branch
git remote -v
gh auth status
gh issue view 1
git add <paths>
git commit -m "Harden AI workflow for MEK RPG"
git push
```

## Inspect Project Files

```powershell
Get-ChildItem -Recurse -File docs,indexes,issues,gm,source,scripts | ForEach-Object { $_.FullName.Substring((Get-Location).Path.Length + 1) }
Get-ChildItem -Recurse -File docs/current,docs/templates,.github/ISSUE_TEMPLATE
```

## Campaign And Play Helpers

```powershell
./scripts/new-campaign-save.ps1 my-campaign
./scripts/validate-campaign-state.ps1
./scripts/validate-campaign-state.ps1 -CampaignId playtest-galatea-dropship
./scripts/validate-campaign-state.ps1 -StrictActive
./scripts/build-gm-context-packet.ps1
./scripts/build-gm-context-packet.ps1 isekai-atlas-field -RunValidators
./scripts/archive-campaign-session.ps1 my-campaign -ConfirmArchive -ArchiveTitle "Session 3 - Depot Escape"
./scripts/archive-campaign-session.ps1 my-campaign -ConfirmArchive -ResetSessionLog -ArchiveTitle "Session 3 - Depot Escape"
./scripts/archive-campaign-session.ps1 -UseActive -ConfirmArchive -WhatIf
./scripts/test-build-gm-context-packet.ps1
./scripts/test-archive-campaign-session.ps1
./scripts/test-gm-context-regressions.ps1
./scripts/test-mekhq-context-packet.ps1
./scripts/test-validate-campaign-state.ps1
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
./scripts/validate-mekhq-pending-actions.ps1 campaigns/_template/pending-mekhq-actions.md
./scripts/validate-mekhq-pending-actions.ps1 campaigns/isekai-atlas-field/pending-mekhq-actions.md -ReportUnresolved
./scripts/test-validate-mekhq-pending-actions.ps1
./scripts/roll-dice.ps1 2d6
./scripts/roll-dice.ps1 2d6+2 "Technician check"
python ./scripts/summarize-mekhq-save.py "C:\path\to\campaign.cpnx" --format json
python ./scripts/summarize-mekhq-save.py "C:\path\to\campaign.cpnx.gz" --format markdown
./scripts/test-summarize-mekhq-save.ps1
./scripts/test-mekhq-checkpoint-fixture.ps1
./scripts/test-mekhq-checkpoint-prototype-fixture.ps1
./scripts/test-mekhq-checkpoint-edge-fixtures.ps1
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign
python ./scripts/bootstrap-mekhq-campaign.py --summary .\mekhq-summary.json --campaign-id my-linked-campaign --viewpoint-person-id 12345
./scripts/test-bootstrap-mekhq-campaign.ps1
$summary = ".\mekhq-summary.json"; $json = & python ./scripts/summarize-mekhq-save.py "C:\path\to\campaign.cpnx" --format json; [System.IO.File]::WriteAllText([System.IO.Path]::GetFullPath($summary), ($json -join [Environment]::NewLine), [System.Text.UTF8Encoding]::new($false))
./scripts/test-mekhq-pending-workflow.ps1
./scripts/test-all.ps1
```

`new-campaign-save.ps1` copies `campaigns/_template/` to a new campaign folder and leaves `campaign-state/active-campaign.md` unchanged. `validate-campaign-state.ps1` checks the active campaign pointer, template files, and the active or explicitly supplied save folder; `-StrictActive` fails when no active campaign is selected. `build-gm-context-packet.ps1` reports the ordered context packet sources for the active or explicit campaign without interpreting rules, summarizing scenes, advancing time, applying MekHQ changes, reading ignored raw source text, or mutating campaign files. `archive-campaign-session.ps1` appends the exact current campaign `session-log.md` text into `previous-sessions.md`, requires explicit campaign selection and `-ConfirmArchive` for mutation, supports `-WhatIf`, creates temp backups, and only resets the session log when `-ResetSessionLog` is supplied. `roll-dice.ps1` reports dice, modifier, and total only; use the rules summaries to interpret outcomes. `summarize-mekhq-save.py` reads MekHQ saves without writing to them and emits JSON or Markdown bridge facts; see `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md` for mappings and limitations. `bootstrap-mekhq-campaign.py` creates a new MEK-RPG campaign save from summary JSON, refuses overwrites, leaves the active-campaign pointer unchanged, and writes campaign-local MekHQ bridge metadata; see `docs/current/MEKHQ_CAMPAIGN_BOOTSTRAP.md`.

`test-mekhq-pending-workflow.ps1` uses a sanitized fixture and disposable campaign folders to regression-check pending-action ownership, bootstrap output, validator coverage, no-writeback boundaries, and protected-source ignore rules.

`test-bootstrap-mekhq-campaign.ps1` uses the sanitized minimal MekHQ summary fixture and disposable campaign folders to check bootstrap campaign id validation, overwrite refusal, viewpoint selection, generated headings, ownership/no-writeback language, active pointer preservation, and cleanup.

`test-summarize-mekhq-save.ps1` uses committed sanitized XML and a temp-generated gzip copy to check `summarize-mekhq-save.py` JSON/Markdown output shape, warnings, unsupported fields, missing-section behavior, and read-only fixture handling.

`test-mekhq-checkpoint-fixture.ps1` uses the committed sanitized `mekhq-read-only-checkpoint` fixture to check the draft checkpoint top-level shape, value/evidence/method-backed/source-owner envelopes, representative hard-ledger sections, report buckets, market warnings, unsupported fields, and the no-stable-market-selector automation boundary.

`test-mekhq-checkpoint-prototype-fixture.ps1` uses a committed sanitized compact excerpt of MegaMek workspace jar-backed prototype output from a copied disposable MekHQ save. It checks prototype metadata, observed counts, method-backed sample values, warning/unsupported preservation, sanitized local paths, and the experimental/non-production boundary.

`test-mekhq-checkpoint-edge-fixtures.ps1` uses a fake sparse checkpoint fixture to check empty personnel/unit/scenario arrays, shallow contract terms, unknown finance/location values, warning-heavy logistics/report sections, a unit-market offer with no stable selector and no final price, and unsupported entries that distinguish automation blockers from FYI gaps.

`test-validate-campaign-state.ps1` uses a disposable temp repository fixture to check `validate-campaign-state.ps1` positive and negative behavior without mutating the live active campaign pointer.

`validate-rules-indexes.ps1` checks task-router links, rules-map paths, page-reference links, manifest IDs, allowed statuses, related IDs, source-page metadata, the committed `PDF page = printed page + 2` offset assumption, manifest/page-reference page coverage, summary `Source References`, and missing summary files. Mapped-only future summary targets are warnings, not failures. `test-validate-rules-indexes.ps1` uses a disposable fixture to check valid metadata, missing router targets, missing manifest summaries, offset metadata failures, manifest/page-reference mismatches, and missing summary source references.

`report-rules-coverage.ps1` summarizes manifest coverage by subsystem and status using committed metadata only. Default text output is for planning; `-Format json` emits machine-readable output. `test-report-rules-coverage.ps1` smoke-tests both formats.

`route-rules-prompt.ps1` scores a short rules or play prompt against `indexes/task-router.md` and reports candidate route rows, files to read, manifest status, page references, and warnings. It does not answer the rule; read the routed summaries before ruling. `test-route-rules-prompt.ps1` checks text/JSON output and `tests/fixtures/rules-route-golden-prompts.fixture.json` coverage for common RPG procedures, tactical handoff, ambiguous rulings, missing routes, and source-review gaps.

`check-ruling-authority.ps1` consumes route-helper output and reports whether the primary route is `authoritative`, `provisional`, `source_lookup_required`, `external_authority_required`, `cannot_adjudicate`, or `blocked_missing_route`. It reports routed files, manifest ids/statuses, source-page references, route warnings, external authority details when applicable, and required next action without answering rules or reading protected source. `test-check-ruling-authority.ps1` covers live prompts and disposable status fixtures.

`resolve-basic-check.ps1` is a JSON-in/JSON-out prototype for `core.basic_check`. It consumes an authority envelope, explicit target number, modifiers, and a fixed or random `2d6` roll, then reports result status, roll breakdown, success/failure, margin, degree, citations, warnings, empty proposed state changes, and no-hidden-mutation proof. It refuses unsafe authority statuses instead of inventing rules. `test-resolve-basic-check.ps1` covers success, source-lookup refusal, invalid input, and no-mutation behavior.

`validate-mekhq-pending-actions.ps1` validates pending item ids, required fields, allowed status/type/priority values, date shapes, duplicate ids, and unresolved pending-intent reporting. `-ReportUnresolved` lists manual-action checklists for day-advance review without treating them as confirmed hard ledger facts.

`test-validate-mekhq-pending-actions.ps1` uses temp fixture files to check empty/default files, all lifecycle statuses, invalid values, missing fields, and unresolved reporting.

`test-build-gm-context-packet.ps1` uses a disposable temp repository fixture to check active and explicit campaign resolution, packet section output, protected-source/no-interpretation boundaries, missing-file warnings, legacy active pointer failure, and read-only behavior.

`test-archive-campaign-session.ps1` uses a disposable campaign copy to check confirmation refusal, preview no-op behavior, exact session text preservation, optional reset, validator compatibility, temp backups, and cleanup.

`test-gm-context-regressions.ps1` uses a disposable temp repository fixture to check deterministic context regression scenarios from `docs/current/GM_CONTEXT_REGRESSION_SCENARIOS.md`: active campaign selection, recent and durable memory separation, structured-state precedence, rules routing boundaries, missing-file warnings, protected-source boundaries, and read-only packet assembly.

`test-mekhq-context-packet.ps1` uses a disposable MekHQ-linked campaign fixture to check context packet bridge metadata, unresolved pending actions, manual-intent labeling, stale-memory avoidance, rules/tactical handoff source references, protected-source/no-writeback boundaries, and read-only behavior.

`test-all.ps1` runs all deterministic local regression and unit-style checks that are safe for normal repository verification. It currently wraps `test-mekhq-pending-workflow.ps1`, `test-bootstrap-mekhq-campaign.ps1`, `test-summarize-mekhq-save.ps1`, `test-mekhq-checkpoint-fixture.ps1`, `test-mekhq-checkpoint-prototype-fixture.ps1`, `test-mekhq-checkpoint-edge-fixtures.ps1`, `test-validate-campaign-state.ps1`, `test-validate-mekhq-pending-actions.ps1`, `test-validate-rules-indexes.ps1`, `test-report-rules-coverage.ps1`, `test-route-rules-prompt.ps1`, `test-check-ruling-authority.ps1`, `test-resolve-basic-check.ps1`, `test-build-gm-context-packet.ps1`, `test-archive-campaign-session.ps1`, `test-gm-context-regressions.ps1`, and `test-mekhq-context-packet.ps1`; the route helper suite includes golden fixture coverage for common RPG procedures and route failure paths.

## Verify Protected Source Is Not Staged

```powershell
git status --short
git check-ignore source/atow-pdf/example.pdf
git check-ignore source/atow-text/page-001.txt
```

Expected ignored paths include `source/atow-pdf/*`, `source/atow-text/*`, `*.pdf`, and `*.epub`.

## Source Extraction

Only run after an explicit source-processing request:

```powershell
bash ./scripts/extract-pdf-pages.sh "source/atow-pdf/A Time of War.pdf"
```

This command requires `pdftotext` and writes ignored page text into `source/atow-text/`.

## Useful Search

```powershell
rg "Needs source review|TBD|Unknown" docs indexes rules gm
rg "source/atow" .
```
