# Agent Handoff

## Issue

- GitHub issue: `#127` (epic).
- Roadmap entry: Profession Capability System.
- Mode: Project development.
- Priority: Next after current MekHQ API-first playtest hardening unless user reprioritizes.

## Goal

Build the Profession Capability System in small, testable slices. The system lets MEK RPG use MekHQ personnel roles/jobs as RPG-capable professions while MekHQ remains authoritative for personnel and campaign state.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/TASKS.md`
- `docs/current/PROFESSION_CAPABILITY_SYSTEM.md`
- `docs/current/PRE_MISSION_INTEL_CHECK.md`
- `docs/current/PROFESSION_LOOKUP_DESIGN.md`
- `rules/professions/README.md`
- `rules/actions/pre-mission-intel-check.md`

## Expected Output

- Keep the epic open until implementation, tests, and validation are complete.
- Schema/template work is complete in issue `#128`; initial profile content is complete in issue `#129`; start remaining work with lookup/action-registry design.
- Implement Pre-Mission Intel Check only after hidden-data filtering and tests are specified.
- Keep player-facing outputs in-universe and filtered by reveal level.
- Child issues: `#128` schema/template, `#129` initial profiles, `#130` lookup design, `#131` action registry design, `#132` dice/reveal design, `#133` Pre-Mission Intel Check design, `#134` hidden-data boundaries, `#135` gated reveal tests/spec plan, `#136` LLM prompt/context assembly, `#137` handoff documentation, and `#138` roadmap updates are complete. Epic `#127` remains open for future runtime implementation.

## Child Issue Links

- `#128`: Add Profession Profile Schema/Template. Complete.
- `#129`: Add Initial Profession Profile Documents. Complete.
- `#130`: Add Profession Lookup Design. Complete.
- `#131`: Add Profession Action Registry Design. Complete.
- `#132`: Add Dice-Roll And Reveal-Level Design. Complete.
- `#133`: Add Pre-Mission Intel Check Design. Complete.
- `#134`: Define Hidden-Data Access Boundaries. Complete.
- `#135`: Add Tests/Spec Plan For Gated Data Reveal. Complete.
- `#136`: Add LLM Prompt/Context Assembly Design. Complete.
- `#137`: Add Handoff Documentation. Complete.
- `#138`: Update Roadmap. Complete.

## Files And Areas

Likely files to read or edit:

- `docs/current/PROFESSION_CAPABILITY_SYSTEM.md`
- `docs/current/PRE_MISSION_INTEL_CHECK.md`
- `docs/current/PROFESSION_LOOKUP_DESIGN.md`
- `docs/current/PROFESSION_ACTION_REGISTRY_DESIGN.md`
- `docs/current/PROFESSION_DICE_REVEAL_DESIGN.md`
- `docs/current/PROFESSION_HIDDEN_DATA_BOUNDARIES.md`
- `docs/current/PROFESSION_GATED_REVEAL_TEST_PLAN.md`
- `docs/current/PROFESSION_PROMPT_CONTEXT_ASSEMBLY.md`
- `rules/professions/`
- `scripts/validate-profession-profiles.ps1`
- `rules/actions/`
- future script or test files only after a child issue authorizes runtime work
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- this handoff

## Implementation Order

1. Leave epic `#127` open unless the user wants to treat this scaffold/design wave as the full epic scope.
2. Do not implement runtime action execution until a new issue explicitly scopes a helper.
3. First runtime issue should start with permission and reveal-filter logic, using `docs/current/PROFESSION_GATED_REVEAL_TEST_PLAN.md`.
4. Prompt assembly runtime work should consume only filtered payloads from `docs/current/PROFESSION_PROMPT_CONTEXT_ASSEMBLY.md`.
5. Add `scripts/test-profession-gated-reveal.ps1` to `scripts/test-all.ps1 -Quick` only after a deterministic helper exists.

## Commands

Useful commands or checks:

```powershell
git status --short --branch
git diff --check
./scripts/test-all.ps1 -Quick
```

If runtime work touches rule indexes, also run:

```powershell
./scripts/validate-rules-indexes.ps1
```

## Constraints

- MekHQ remains the source of truth for personnel, campaign, logistics, and scenario state.
- Profession profiles are rules overlays, not replacement character sheets.
- Hidden scenario data must not be exposed just because an adapter can read it.
- The LLM may generate prose only after deterministic rules choose the reveal level.
- Do not copy copyrighted source text or table data.
- Do not stage protected raw source files under `source/atow-pdf/` or `source/atow-text/`.
- Preserve unrelated existing campaign/live API worktree changes.

## Acceptance Criteria

- Profession schema exists and distinguishes MekHQ-owned facts from MEK RPG overlays.
- Initial profiles are filled enough for deterministic lookup and action permission.
- Lookup design fails closed for missing, unknown, ambiguous, unavailable, or non-current MekHQ personnel role data.
- Action registry design is explicit and testable. Complete in issue `#131`.
- Dice and reveal-level design is deterministic and keeps the LLM out of reveal selection. Complete in issue `#132`.
- Pre-Mission Intel Check design is complete with input categories, reveal filtering, examples, and future test scenarios. Complete in issue `#133`.
- Hidden-data boundary separates raw adapter payloads, adjudication context, filtered prompt payloads, player-facing reports, and debug traces. Complete in issue `#134`.
- Gated reveal test/spec plan defines fixture shape, permission cases, reveal-level cases, prompt leak checks, missing-field cases, and quick-suite gating. Complete in issue `#135`.
- Prompt/context assembly design defines prompt layers, safe payload shape, in-universe report rules, confidence labels, denied/failure prompts, and prompt payload tests. Complete in issue `#136`.
- Pre-Mission Intel Check has fixture-backed hidden-data filtering tests before player-facing use.
- Prompt/context assembly tests prove unrevealed hidden data is absent.
- Roadmap, task state, issues, and handoffs stay synchronized.
- This handoff remains active until epic `#127` closes; archive only when the epic closes.

## Open Questions

- Resolved for issue `#130`: use fixture-backed `personnel[].primary_role.raw_code` and `personnel[].primary_role.label` as the first lookup candidates; rank, assignment, leadership, fatigue, hits, and injury fields provide context/warnings only.
- Resolved for issue `#131`: use Markdown action specs with `profession-action/v1` YAML front matter under `rules/actions/`; cross-check action owners/support roles against profession profile `allowed_actions`; deny planned/not-implemented or mismatched actions before loading hidden data.
- Resolved for issue `#132`: use provisional roll policy `margin_2d6_target_number_v1` and reveal map `pre_mission_intel_margin_v1`; target numbers and modifiers must be explicit inputs; support actors add no modifier by default; reveal level is derived from margin before prompt assembly.
- Resolved for issue `#133`: the Pre-Mission Intel Check design uses the existing `docs/current/PRE_MISSION_INTEL_CHECK.md` as the action design doc, requires permission before hidden-data access, defines public/MekHQ-owned/hidden/derived input categories, and includes future tests for denial, reveal levels, missing fields, and prompt-filter regressions.
- Resolved for issue `#134`: use `docs/current/PROFESSION_HIDDEN_DATA_BOUNDARIES.md` to enforce layer separation, forbidden prompt fields by reveal level, debug/log redaction, fail-closed behavior, sanitized fixture strategy, and allowed/forbidden test matrix.
- Resolved for issue `#135`: use `docs/current/PROFESSION_GATED_REVEAL_TEST_PLAN.md`; first automated test should be PowerShell unless the runtime helper is Python, should use sanitized sentinel fixtures, and should join `scripts/test-all.ps1 -Quick` only after deterministic runtime filtering or prompt assembly exists.
- Resolved for issue `#136`: use `docs/current/PROFESSION_PROMPT_CONTEXT_ASSEMBLY.md`; prompt assembly is a pure transformation from filtered reveal result to safe prompt payload and must not read raw hidden data, roll dice, resolve permissions, or call live MekHQ.
- Resolved for issue `#137`: this handoff is the single active starting point for the profession epic; child handoffs are unnecessary until a future runtime issue needs narrower execution context.
- Resolved for issue `#138`: roadmap and task board mark child issues `#128`-`#138` complete, keep epic `#127` open for future runtime implementation, and point current local next work back to MekHQ query/context issue `#142`.
- Remaining API review: complete MekHQ role vocabulary, secondary/staff assignments, and scenario commitment fields need fixture evidence before runtime lookup.
- Resolved for issue `#128`: profile metadata lives in YAML front matter inside Markdown for now.
- What roll system becomes canonical for non-combat profession actions?
- How should support professions contribute without bypassing reveal gates?
