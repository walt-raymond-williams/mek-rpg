# Profession Action Registry Design

Status: issue `#131` design. Runtime action execution is not implemented.

Parent epic: `#127` Profession Capability System.

## Purpose

Define a deterministic registry for profession actions so action permission, input access, roll gates, reveal levels, and prompt boundaries can be checked before any hidden scenario data is loaded into player-facing context.

The registry answers one narrow question: given a requested action, actor lookup result, optional support actors, and action timing, is the action available and what metadata governs its later roll, filtering, and prompt assembly?

## Registry Format

Use Markdown action specs under `rules/actions/` with YAML front matter as the registry source of truth. This matches profession profiles, keeps action design readable, and avoids a separate generated index until runtime tooling needs one.

Each action file should use kebab-case filenames and stable snake_case `action_id` values.

Required front matter fields:

- `schema_version`: current value is `profession-action/v1`.
- `action_id`: stable snake_case action identifier.
- `display_name`: player-facing action name.
- `status`: `not_implemented`, `planned`, `implemented`, or `retired`.
- `phase`: action timing such as `pre_battle`, `downtime`, `scene`, `post_battle`, or `campaign_admin`.
- `owning_professions`: profession ids that may lead the action.
- `supporting_professions`: profession ids that may support but not lead the action.
- `input_data`: grouped data categories the action may request.
- `roll_required`: boolean.
- `roll_policy`: named policy or `TBD`.
- `reveal_levels`: ordered reveal-level keys or labels.
- `prompt_policy`: named prompt/filtering policy or `TBD`.
- `failure_modes`: action-specific failure labels.
- `test_expectations`: short machine-readable expectations for future validation.

Markdown prose should explain the same fields for human use without adding extra permissions that are absent from front matter.

## Status Semantics

- `not_implemented`: design metadata may exist, but runtime helpers must refuse execution.
- `planned`: metadata is stable enough for design references, but runtime helpers still refuse execution unless a later implementation explicitly opts in.
- `implemented`: runtime permission checks, roll/reveal behavior, hidden-data filtering, prompt assembly, and tests exist.
- `retired`: do not offer or execute the action; keep only for historical compatibility if needed.

Until tests exist for permission, roll, filtering, and prompt assembly, action execution must fail closed even when a profession profile lists the action.

## Permission Flow

Action permission must be checked before hidden data access:

1. Resolve the requested `action_id` against action metadata.
2. Reject missing, retired, malformed, or not-implemented actions for runtime execution.
3. Resolve the lead actor through profession lookup.
4. Reject lookup results with `blocked`, `unmapped`, `ambiguous`, unavailable, or public-only status.
5. Confirm the lead actor's `profession_id` is in `owning_professions`.
6. Confirm the lead profession profile includes the action as `owning`.
7. Resolve support actors, if any, and keep only profiles listed in `supporting_professions` and in profile `allowed_actions` as `supporting`.
8. Load public inputs needed for denial messages or public briefing.
9. Load hidden adjudication inputs only after permission, timing, and action status checks pass.
10. Apply roll and reveal metadata before prompt assembly receives filtered facts.

A support profession can never promote itself to owner, bypass a missing owner, or independently raise reveal level unless a later dice/reveal design explicitly defines that behavior.

## Profile Cross-Check

Action metadata and profession profile metadata must agree:

- If an action lists a profession as owner, that profession profile should list `action_id: owning`.
- If an action lists a profession as support, that profession profile should list `action_id: supporting`.
- If a profile lists an action that does not exist, runtime tooling should deny the action and emit a registry warning.
- If action metadata and profile metadata disagree, deny execution and report the mismatch.

This two-way check prevents prompts from granting permissions from prose alone.

## Input Data Categories

Use explicit categories instead of raw payload names:

- `public`: briefing facts the player could receive without a profession check.
- `mekhq_owned`: MekHQ-owned facts such as personnel, readiness, scenario, logistics, contract, or campaign fields.
- `hidden`: protected adjudication facts that must be filtered before player-facing use.
- `derived`: computed bands, estimates, or warnings created by MEK RPG from raw inputs after permission and reveal checks.

Action specs may name expected fields, but they should not require raw MekHQ internal paths unless fixture evidence proves those paths stable.

## Denial And Fail-Closed Results

Denied action requests should produce a structured denial, not a partial report:

- `unknown_action`: no matching action metadata.
- `action_not_implemented`: action exists but is not executable.
- `action_retired`: action is intentionally unavailable.
- `lookup_blocked`: actor cannot be resolved or is unavailable.
- `profession_unmapped`: actor has no deterministic profession overlay.
- `profession_ambiguous`: actor maps to multiple profiles.
- `owner_required`: no qualified owning profession.
- `support_only`: actor can support but cannot lead.
- `profile_registry_mismatch`: profile and action metadata disagree.
- `timing_blocked`: action is not available in the current phase.

All denial states must avoid loading or summarizing hidden scenario data. Public briefing text may still be shown if the calling workflow permits it.

## Prompt Assembly Boundary

Prompt assembly must consume registry output, not raw action prose. A future prompt helper should receive:

- action id and display name;
- lead profession and accepted support roles;
- resolved reveal level;
- filtered public, derived, and permitted hidden facts;
- required uncertainty/failure language;
- forbidden-output rules for unrevealed fields.

It must not receive full hidden payloads as convenience context.

## Initial Registered Action

`pre_mission_intel_check` is the first registry entry. It is defined in `rules/actions/pre-mission-intel-check.md` with `profession-action/v1` front matter.

For issue `#131`, it remains non-executable design metadata. Later issues should define dice/reveal mapping, hidden-data filtering tests, and prompt assembly before changing the action status to executable.

## Future Test Strategy

Future registry tests should use disposable profile/action fixtures and sanitized MekHQ scenario fixtures:

- valid action metadata parses and exposes expected fields;
- `pre_mission_intel_check` owners and support roles match profession profiles;
- unknown or not-implemented actions fail closed;
- support-only actors cannot load hidden data;
- profile/action mismatches deny execution;
- hidden input fixtures are not read for denied requests;
- prompt context receives filtered facts only after reveal resolution.
