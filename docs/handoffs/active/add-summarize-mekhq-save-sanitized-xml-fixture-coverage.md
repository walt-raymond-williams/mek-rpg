# Agent Handoff

## Issue

- GitHub issue: `#42` Add summarize-mekhq-save sanitized XML fixture coverage
- Parent epic: `#38`
- Roadmap entry: Automated regression coverage for MekHQ-linked A Time of War workflow
- Mode: Project development / testing
- Priority: After issue `#39`; can proceed independently of bootstrap tests.

## Goal

Add automated fixture coverage for `scripts/summarize-mekhq-save.py` using tiny sanitized XML and gzip fixtures instead of real MekHQ saves.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- GitHub issues `#38`, `#39`, and `#42`
- `docs/current/MEKHQ_SAVE_SUMMARY_HELPER.md`
- `docs/current/MEKHQ_BRIDGE_DATA_MODEL.md`
- `scripts/summarize-mekhq-save.py`

## Expected Output

- Sanitized XML fixture(s), with optional generated gzip fixture if deterministic and safe.
- New deterministic test script for JSON and Markdown output shape.
- Documentation updates and test runner integration if `scripts/test-all.ps1` exists.

## Files And Areas

Likely files to read or edit:

- `tests/fixtures/`
- `scripts/test-summarize-mekhq-save.ps1` or equivalent
- `scripts/test-all.ps1` if present
- `scripts/README.md`
- `docs/current/KNOWN_COMMANDS.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`

## Commands

Useful commands or checks:

```powershell
python -m py_compile scripts/summarize-mekhq-save.py
python ./scripts/summarize-mekhq-save.py <fixture> --format json
python ./scripts/summarize-mekhq-save.py <fixture> --format markdown
git diff --check
git check-ignore source/atow-pdf/example.pdf
git check-ignore source/atow-text/page-001.txt
```

## Constraints

- Do not commit real MekHQ save payloads.
- Do not process or commit protected A Time of War source material.
- Do not add save mutation or output-file behavior to the summary helper.

## Acceptance Criteria

- Plain XML fixture parses.
- Gzip XML fixture parses, if practical without binary churn concerns.
- JSON output includes expected top-level keys and representative values.
- Markdown output smoke test passes.
- Missing or unknown sections produce warnings or unsupported fields instead of crashes.
- Verification is run or blocker recorded.
- Changes are committed and pushed.

## Open Questions

- Should gzip fixture be committed as a binary file, generated during the test from XML, or skipped in favor of a temp-generated gzip?
