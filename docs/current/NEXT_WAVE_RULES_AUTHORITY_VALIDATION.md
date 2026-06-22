# Next Wave Rules Authority Validation

## Scope

- Issue: `#94`
- Validates source-review wave issues `#91`, `#92`, and `#93`.
- Uses committed metadata and fixtures only. Normal validation does not read protected raw source text or PDFs.

## Scripted Coverage

The existing route and authority suites now cover the next-wave areas:

- `tests/fixtures/rules-route-golden-prompts.fixture.json` includes route assertions for advancement/rewards, training downtime, salary/rank rewards, planetary hazards, creature venom, disease quarantine, battle armor readiness, prosthetic readiness, poison treatment, and vehicle/fuel logistics.
- `scripts/test-check-ruling-authority.ps1` includes authority assertions for advancement/reward prompts, special-hazard prompts, battle-armor readiness prompts, and poison-treatment prompts as `provisional`.
- The same authority test asserts exact equipment stat/table prompts as `source_lookup_required`.
- Tactical BattleTech and battle-armor precision prompts remain `external_authority_required`.

## Authority Findings

| Prompt class | Expected authority | Reason |
| --- | --- | --- |
| End-of-session XP, training, salary, rank, and rewards | `provisional` | Draft summaries support live play, but exact award and table values stay source-bound. |
| Planetary hazards, creatures, disease, venom, and quarantine | `provisional` | Draft summaries provide procedures and clocks; exact tables, stat blocks, and values remain private lookup. |
| Battle armor readiness, prosthetic recovery, poison treatment, and vehicle/fuel logistics | `provisional` | Draft summaries cover table flow and consequences; exact catalogs, values, and stats remain private lookup. |
| Exact battle armor stats, item values, drug/poison table values, fuel values, or vehicle entries | `source_lookup_required` | Exact table/catalog data is not committed and must not be invented. |
| Hex movement, heat, mounted tactical weapons, full tactical unit combat, or MekHQ hard-ledger outcomes | `external_authority_required` | Classic BattleTech, MegaMek, MekHQ, or the selected tactical source owns the resolution. |

## Gate Fixes

- `scripts/check-ruling-authority.ps1` now treats campaign context paths such as `campaign-state/active-campaign.md` and `campaigns/<campaign-id>/...` as context files, not missing rules metadata. They still appear in route output, but they do not block a provisional ruling when draft summaries are present.
- The gate no longer treats every related tactical handoff file as an automatic external-authority blocker. Tactical handoff is still required when the prompt itself asks for tactical precision, hard-ledger authority, BattleMech-scale play, or hex-scale handling.

## Verification

Run:

```powershell
./scripts/test-route-rules-prompt.ps1
./scripts/test-check-ruling-authority.ps1
./scripts/test-all.ps1
```

The route and authority tests preserve the copyright boundary by checking metadata, file paths, statuses, warnings, and source-page references without embedding protected source text.
