# Agent Handoff

## Issue

- GitHub issue: `#74`
- Roadmap entry: `docs/current/ROADMAP.md` > Ruling safety and deterministic mechanics maturation
- Mode: Project development
- Priority: P0
- Status: Done

## Completion

Issue `#74` added fixture-driven route tests for common RPG procedures.

Implemented outputs:

- `tests/fixtures/rules-route-golden-prompts.fixture.json`
- expanded `scripts/test-route-rules-prompt.ps1`
- explicit `rules_lookup` mode in `scripts/route-rules-prompt.ps1` JSON/text output
- `scripts/test-all.ps1` suite label update
- command and planning documentation updates

Coverage now checks simple checks, opposed checks, Edge use, initiative, ranged attacks, melee attacks, damage/wounds, healing/recovery, equipment use, campaign consequences, vehicle/piloting, tactical handoff, ambiguous rulings, missing routes, and a source-review gap. Assertions inspect candidate files, manifest statuses, page-reference status/source-page text, warnings, missing-candidate behavior, and protected-source boundary text.

Verification run:

```powershell
./scripts/test-route-rules-prompt.ps1
```

Full close-out verification was run as part of the issue commit.

## Original Goal

Add fixture-driven route tests for common RPG procedures so routing, manifest statuses, page references, and warnings are covered before resolver work starts.

## Constraints Preserved

- The route helper remains non-authoritative and does not answer rules.
- Tests use committed metadata only.
- Protected raw source text and PDFs are not read or staged.
