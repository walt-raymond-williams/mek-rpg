# Agent Handoff

## Issue

- GitHub issue: `#80`
- Roadmap entry: `docs/current/ROADMAP.md` > Ruling safety and deterministic mechanics maturation
- Mode: Project development
- Priority: P0
- Status: Done

## Completion

Issue `#80` added a deterministic pre-ruling authority gate.

Implemented outputs:

- `docs/current/RULING_AUTHORITY_GATE.md`
- `scripts/check-ruling-authority.ps1`
- `scripts/test-check-ruling-authority.ps1`
- `scripts/test-all.ps1` integration
- command documentation updates
- `gm/rules-adjudication-posture.md` link and procedure update

The gate consumes `scripts/route-rules-prompt.ps1` JSON output and evaluates the primary route candidate. It reports `authoritative`, `provisional`, `source_lookup_required`, `external_authority_required`, `cannot_adjudicate`, or `blocked_missing_route`, plus routed files, manifest ids/statuses, page-reference text, warnings, external authority details, source-boundary proof, failure mode, and required next action.

Verification run:

```powershell
./scripts/test-check-ruling-authority.ps1
```

Full close-out verification was run as part of the issue commit.

## Constraints Preserved

- The helper does not answer rules.
- The helper reads committed routing and metadata only.
- Protected raw source text and PDFs are not read or staged.
- The helper does not mutate campaign files or MekHQ saves.
- Tactical and hard-ledger cases return external-authority handoff instead of resolution.
