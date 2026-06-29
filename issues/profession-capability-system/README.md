# Profession Capability System Issue Plan

Status: created in GitHub as issues `#127`-`#138`.

Labels to use where available:

- `agent-task`
- `epic`
- `profession-system`
- `rules`
- `docs`
- `tests`
- `good first issue`

## Issue 1: Epic: Profession Capability System

GitHub: `#127`

Labels: `agent-task`, `epic`, `profession-system`, `rules`, `docs`, `tests`

### Problem

MEK RPG can read MekHQ personnel and scenario data, but it lacks a durable rules layer that says what each MekHQ job/role can plausibly do in RPG play and what hidden data that role can access.

### Goal

Create a profession capability system that maps MekHQ personnel roles/jobs to MEK RPG profession profiles, allowed actions, roll gates, and hidden-data reveal limits.

### Scope

- Define profession profiles as rules overlays, not character sheets.
- Define action registry and reveal-gate concepts.
- Implement the first action, Pre-Mission Intel Check, in later child issues.
- Add tests proving hidden data is not exposed above permitted reveal level.
- Keep MekHQ authoritative for personnel and campaign state.

### Out of Scope

- Replacing MekHQ personnel sheets.
- Broad runtime engine work in the planning scaffold.
- Tactical BattleTech resolution.
- Raw copyrighted rulebook text.

### Acceptance Criteria

- [ ] Profession profile schema/template exists.
- [ ] Initial profession profiles exist.
- [ ] Profession lookup design exists.
- [ ] Action registry design exists.
- [ ] Dice/reveal-level design exists.
- [ ] Pre-Mission Intel Check design and implementation are complete.
- [ ] Hidden-data boundary tests pass.
- [ ] LLM prompt/context assembly cannot bypass reveal gates.
- [ ] Roadmap and handoff docs stay current.

### Testing Notes

Use sanitized fixtures. Tests must assert absent hidden facts, not only expected visible facts.

### Dependencies

- Current MekHQ live API field availability for personnel roles/jobs and scenario metadata.
- Existing dice helper or future dice policy.

### Implementation Notes

Start from `docs/current/PROFESSION_CAPABILITY_SYSTEM.md`, `docs/current/PRE_MISSION_INTEL_CHECK.md`, and `docs/handoffs/active/profession-capability-system-epic.md`.

## Issue 2: Add Profession Profile Schema/Template

GitHub: `#128`

Labels: `agent-task`, `profession-system`, `rules`, `docs`, `good first issue`

### Problem

Profession profiles need a consistent shape before future agents add implementation logic or additional professions.

### Goal

Define a reusable profile schema/template for `rules/professions/`.

### Scope

- Decide Markdown plus YAML front matter versus separate YAML manifest.
- Define required fields: id, aliases, purpose, capabilities, MekHQ fields, RPG skills, actions, roll rules, data access limits, failure modes, status, examples, and tests.
- Add a template file or README section.
- Update existing stub profiles to match the schema.

### Out of Scope

- Runtime lookup implementation.
- Finalizing every profession profile in full detail.

### Acceptance Criteria

- [ ] Schema/template is documented.
- [ ] Stub profiles use the same required headings or metadata fields.
- [ ] MekHQ-owned facts are clearly separated from MEK RPG overlays.
- [ ] `not implemented` status is explicit where needed.

### Testing Notes

If a validator is premature, add a manual checklist. If a simple schema check is trivial, add a focused test.

### Dependencies

- Epic design doc.

### Implementation Notes

Preserve source-boundary rules. Profiles are original project rules overlays.

## Issue 3: Add Initial Profession Profile Documents

GitHub: `#129`

Labels: `agent-task`, `profession-system`, `rules`, `docs`

### Problem

The initial profile stubs exist but need enough detail for future lookup and action work.

### Goal

Fill the first ten profession profiles to the agreed schema.

### Scope

- Intelligence Officer.
- Scout / Recon Specialist.
- MechWarrior.
- Tech Chief / Mechanic.
- Doctor.
- Administrator / Liaison.
- Quartermaster.
- Security Officer.
- Aerospace Pilot.
- DropShip / Transport Crew.
- Add aliases for likely MekHQ job/role names where known, marking unknowns clearly.

### Out of Scope

- Runtime lookup implementation.
- Inventing exact MekHQ field names without evidence.

### Acceptance Criteria

- [ ] Each profile has purpose, capabilities, MekHQ fields, RPG skills, allowed actions, limits, failures, examples, and tests.
- [ ] Unknown MekHQ mappings are marked `Unknown` or `Needs API review`.
- [ ] Profiles do not duplicate MekHQ character-sheet authority.

### Testing Notes

Run markdown/link checks if available. Validator work may wait for the schema issue.

### Dependencies

- Profession profile schema/template.

### Implementation Notes

Start with the existing stubs and keep the files concise.

## Issue 4: Add Profession Lookup Design

GitHub: `#130`

Labels: `agent-task`, `profession-system`, `docs`

### Problem

MEK RPG needs deterministic mapping from MekHQ personnel job/role fields to profession profiles.

### Goal

Design lookup rules, fallback behavior, alias handling, and missing-field reporting.

### Scope

- Define input fields from MekHQ live API or fixture JSON.
- Define profession alias matching.
- Define fallback behavior for unmapped jobs.
- Define warnings for missing or stale personnel role data.
- Define how lookup should avoid creating authoritative character data.

### Out of Scope

- Implementing the lookup engine unless trivial and separately accepted.
- Editing MekHQ producer code.

### Acceptance Criteria

- [ ] Lookup design names required MekHQ fields or marks them unknown.
- [ ] Unmapped professions fail closed to public/common actions.
- [ ] Design includes fixture strategy.
- [ ] Design names any producer/API gaps as MEK-RPG local docs or issues.

### Testing Notes

Future tests should cover exact match, alias match, unknown job, missing job, and unavailable personnel.

### Dependencies

- Profile schema.
- Current MekHQ live API field review.

### Implementation Notes

If producer changes are needed, create a local change-request memo instead of editing another repository.

## Issue 5: Add Profession Action Registry Design

GitHub: `#131`

Labels: `agent-task`, `profession-system`, `rules`, `docs`

### Problem

Allowed actions need a deterministic registry so prompts cannot improvise permissions.

### Goal

Define an action registry design that maps actions to timing, owning professions, supporting professions, inputs, roll gates, reveal levels, and tests.

### Scope

- Define action metadata fields.
- Decide whether registry is Markdown front matter, YAML, or generated index.
- Document support-role behavior.
- Document unavailable/not-implemented actions.

### Out of Scope

- Broad runtime engine.
- Implementing all actions for every profession.

### Acceptance Criteria

- [ ] Registry design is documented.
- [ ] `pre_mission_intel_check` conforms to the design.
- [ ] Not-implemented capabilities fail closed.
- [ ] Prompt assembly must read action permissions before hidden data.

### Testing Notes

Future tests should confirm denied action requests do not load hidden data.

### Dependencies

- Profile schema.

### Implementation Notes

Keep action identifiers stable and machine-friendly.

## Issue 6: Add Dice-Roll And Reveal-Level Design

GitHub: `#132`

Labels: `agent-task`, `profession-system`, `rules`, `docs`

### Problem

Hidden data reveal must be determined by rules, not pure LLM judgment.

### Goal

Choose a provisional roll model and define how margin/result maps to reveal levels.

### Scope

- Compare BattleTech-style target number and additive skill check.
- Recommend a provisional model.
- Define reveal-level mapping for the first action.
- Document configuration points for later dice mechanic changes.

### Out of Scope

- Rewriting all dice mechanics.
- Source-processing new A Time of War text.

### Acceptance Criteria

- [ ] Roll design is documented.
- [ ] Reveal levels are deterministic.
- [ ] Failure modes are explicit.
- [ ] The LLM is not responsible for choosing reveal level.

### Testing Notes

Future tests should cover failure, marginal success, high success, and extreme success.

### Dependencies

- Existing dice helper review.
- Pre-Mission Intel Check design.

### Implementation Notes

Use original procedures and existing project summaries only. Preserve uncertainty where exact skill mapping is not finalized.

## Issue 7: Add Pre-Mission Intel Check Design

GitHub: `#133`

Labels: `agent-task`, `profession-system`, `rules`, `docs`

### Problem

MEK RPG needs a first concrete profession action that prevents raw scenario data from leaking while still giving useful in-universe warnings.

### Goal

Finalize the Pre-Mission Intel Check design and prepare it for implementation.

### Scope

- Public and hidden input data categories.
- Owning/supporting professions.
- Reveal levels 0-7.
- Failure modes.
- Example in-universe output.
- Test scenarios.

### Out of Scope

- Runtime implementation.
- Full support for every reveal level if implementation is not yet scoped.

### Acceptance Criteria

- [ ] Design document is complete and linked from the epic.
- [ ] Action spec exists under `rules/actions/`.
- [ ] Test expectations cover hidden-data non-exposure.
- [ ] Exact units/pilot skills require high reveal level.

### Testing Notes

No runtime tests required for design-only issue, but test cases must be specific enough for future implementation.

### Dependencies

- Dice/reveal-level design.
- Action registry design.

### Implementation Notes

The player-facing report should be in-universe, not raw debug/scenario JSON.

## Issue 8: Define Hidden-Data Access Boundaries

GitHub: `#134`

Labels: `agent-task`, `profession-system`, `docs`, `tests`

### Problem

MekHQ adapters may know exact hidden scenario data before the player should know it.

### Goal

Define and test the hidden-data boundary for profession actions.

### Scope

- Separate internal raw data, adjudication data, filtered prompt data, and player-facing output.
- Define forbidden prompt fields for each reveal level.
- Define logging/debug boundaries.
- Define fixture strategy for hidden scenario data.

### Out of Scope

- Implementing full scenario adapter if not already present.
- Exposing raw unit sheets to the player.

### Acceptance Criteria

- [ ] Boundary document or section is explicit.
- [ ] Future implementation has a test matrix for allowed/forbidden fields.
- [ ] Debug output cannot accidentally become player-facing output.
- [ ] Failure behavior is fail-closed.

### Testing Notes

Tests should assert that hidden strings and exact values are absent from filtered prompt payloads and final reports.

### Dependencies

- Action registry design.
- Pre-Mission Intel Check design.

### Implementation Notes

Use sanitized fixtures only.

## Issue 9: Add Tests/Spec Plan For Gated Data Reveal

GitHub: `#135`

Labels: `agent-task`, `profession-system`, `tests`, `docs`

### Problem

Reveal gating needs regression tests before it is trusted in play.

### Goal

Create a test/spec plan, then implement the smallest useful tests when runtime code exists.

### Scope

- Define fixture shape.
- Define reveal-level test cases.
- Define profession permission tests.
- Define LLM prompt payload leak tests.
- Decide whether tests are PowerShell, Python, or another existing test style.

### Out of Scope

- Broad integration with live MekHQ.
- Real copyrighted source material or live private campaign payloads.

### Acceptance Criteria

- [ ] Test plan exists.
- [ ] At least one focused automated test is added when implementation exists.
- [ ] Tests prove absent hidden data below permitted levels.
- [ ] Tests run through `scripts/test-all.ps1 -Quick` when appropriate.

### Testing Notes

Prefer deterministic fixture tests over live MekHQ reads.

### Dependencies

- Hidden-data boundary design.
- First runtime slice.

### Implementation Notes

Match existing script/test conventions in `scripts/`.

## Issue 10: Add LLM Prompt/Context Assembly Design

GitHub: `#136`

Labels: `agent-task`, `profession-system`, `docs`, `tests`

### Problem

Even with deterministic reveal levels, prompt assembly could leak raw hidden data if it passes too much context to the LLM.

### Goal

Define how profession/action/reveal outputs become safe LLM prompt context.

### Scope

- Define prompt input layers.
- Define forbidden data above reveal level.
- Define in-universe report instructions.
- Define confidence/uncertainty language.
- Define tests for prompt payload filtering.

### Out of Scope

- Full LLM integration engine.
- Long narrative style guide.

### Acceptance Criteria

- [ ] Prompt assembly design exists.
- [ ] Raw data and character knowledge are explicitly separate.
- [ ] Hidden fields are filtered before prompt construction.
- [ ] Test expectations include prompt payload inspection.

### Testing Notes

Use structured payload tests before testing generated prose.

### Dependencies

- Hidden-data boundary design.
- Action registry design.

### Implementation Notes

The LLM can write voice and presentation, not decide reveal level.

## Issue 11: Add Handoff Documentation

GitHub: `#137`

Labels: `agent-task`, `profession-system`, `docs`, `good first issue`

### Problem

Future agents need a single starting point for the epic.

### Goal

Keep `docs/handoffs/active/profession-capability-system-epic.md` current and add child handoffs only when child issues need extra context.

### Scope

- Link final issue numbers.
- Link design docs, action specs, and profiles.
- Record implementation order.
- Record risks/open questions.

### Out of Scope

- Implementing runtime code.

### Acceptance Criteria

- [ ] Handoff has issue links.
- [ ] Handoff names start docs and likely files.
- [ ] Handoff records constraints and acceptance criteria.
- [ ] Handoff reflects any issue number changes.

### Testing Notes

Manual doc review is enough.

### Dependencies

- Epic issue creation.

### Implementation Notes

Archive this handoff only when the epic closes.

## Issue 12: Update Roadmap

GitHub: `#138`

Labels: `agent-task`, `profession-system`, `docs`, `good first issue`

### Problem

The Profession Capability System needs to appear in the durable project roadmap and task board.

### Goal

Keep `docs/current/ROADMAP.md` and `docs/current/TASKS.md` synchronized with epic and child issue state.

### Scope

- Add roadmap track.
- Add issue numbers after creation.
- Add current/next/backlog status.
- Update after each child issue completes.

### Out of Scope

- Runtime implementation.

### Acceptance Criteria

- [ ] Roadmap lists the epic, child issues, design docs, handoff, and boundaries.
- [ ] Task board points future agents to the next actionable slice.
- [ ] Completed planning scaffold is recorded in `Done`.

### Testing Notes

Manual consistency check with GitHub issue list.

### Dependencies

- GitHub issue creation.

### Implementation Notes

Do not mark the epic complete during the scaffold session.
