# Agent Handoff

## Issue

- GitHub issue: `#127`.
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
- `rules/professions/README.md`
- `rules/actions/pre-mission-intel-check.md`

## Expected Output

- Keep the epic open until implementation, tests, and validation are complete.
- Start with schema/template and lookup/action-registry design.
- Implement Pre-Mission Intel Check only after hidden-data filtering and tests are specified.
- Keep player-facing outputs in-universe and filtered by reveal level.
- Child issues: `#128` schema/template, `#129` initial profiles, `#130` lookup design, `#131` action registry design, `#132` dice/reveal design, `#133` Pre-Mission Intel Check design, `#134` hidden-data boundaries, `#135` gated reveal tests/spec plan, `#136` LLM prompt/context assembly, `#137` handoff documentation, and `#138` roadmap updates.

## Files And Areas

Likely files to read or edit:

- `docs/current/PROFESSION_CAPABILITY_SYSTEM.md`
- `docs/current/PRE_MISSION_INTEL_CHECK.md`
- `rules/professions/`
- `rules/actions/`
- future script or test files only after a child issue authorizes runtime work
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- this handoff

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
- Action registry design is explicit and testable.
- Pre-Mission Intel Check has fixture-backed hidden-data filtering tests before player-facing use.
- Prompt/context assembly tests prove unrevealed hidden data is absent.
- Roadmap, task state, issues, and handoffs stay synchronized.

## Open Questions

- Which MekHQ API fields will expose stable job/role aliases for lookup?
- Should profile metadata live in YAML front matter, separate YAML, or both?
- What roll system becomes canonical for non-combat profession actions?
- How should support professions contribute without bypassing reveal gates?
