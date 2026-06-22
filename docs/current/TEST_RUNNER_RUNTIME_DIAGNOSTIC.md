# Test Runner Runtime Diagnostic

## Scope

- Issue: `#100`
- Diagnoses `./scripts/test-all.ps1` routine close-out runtime.
- No protected source files, raw MekHQ saves, network services, or user interaction are required by the runner.

## Baseline Measurement

Measured on June 22, 2026 from the repository root:

```text
Measure-Command { ./scripts/test-all.ps1 }
TOTAL_SECONDS=253.60
```

The full runner passed. The 120-second timeout was caused by total suite runtime, not a failing or hanging test.

## Per-Suite Measurement

| Suite | Seconds |
| --- | ---: |
| Rules route helper golden fixture tests | 53.56 |
| Ruling authority gate fixture tests | 49.77 |
| Campaign-state validator coverage | 14.27 |
| MekHQ-linked context packet scenarios | 10.28 |
| Pending MekHQ action validator coverage | 9.29 |
| MekHQ pending workflow regression | 8.84 |
| Rules index validator coverage | 8.63 |
| Campaign session archive helper coverage | 7.27 |
| MekHQ bootstrap fixture coverage | 4.74 |
| GM context regression scenarios | 4.71 |
| Opposed check resolver fixture tests | 4.58 |
| GM context packet helper coverage | 4.47 |
| Rules coverage reporter smoke tests | 3.76 |
| Personal combat checkpoint fixture tests | 3.66 |
| Basic check resolver fixture tests | 3.33 |
| MekHQ save summary fixture coverage | 3.19 |
| MekHQ checkpoint prototype-output fixture coverage | 2.27 |
| MekHQ checkpoint export fixture coverage | 1.62 |
| MekHQ checkpoint edge-case fixture coverage | 1.54 |

The two slowest suites are the route helper and ruling authority gate. They repeatedly invoke PowerShell subprocesses and parse committed routing/manifest metadata across many golden prompts. That coverage is meaningful for rules and authority changes, so it should stay in the full suite.

## Runner Changes

- `./scripts/test-all.ps1` now reports per-suite timing and a total timing summary.
- `./scripts/test-all.ps1 -Quick` runs the deterministic suites suitable for routine non-rules close-out and omits the two long rules-route/authority suites.
- `./scripts/test-all.ps1 -ListSuites` lists which suites run in quick versus full mode.

## Verification Guidance

Use the full runner when changing:

- `indexes/task-router.md`
- `indexes/manifest.yaml`
- `indexes/page-reference-index.md`
- `scripts/route-rules-prompt.ps1`
- `scripts/check-ruling-authority.ps1`
- rules summaries, source authority behavior, or golden routing fixtures

Use the quick runner for routine documentation, campaign-template, MekHQ fixture, context packet, campaign validator, pending-action, and mechanic-helper changes when the rules route and authority layers are not touched.

The quick runner is not a replacement for full verification before a broad release-style validation pass.

