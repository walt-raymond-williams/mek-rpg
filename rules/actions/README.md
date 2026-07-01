# Profession Actions

Profession action specs define what a resolved profession may attempt, when it may attempt it, what data it may use, and how hidden facts must be filtered before player-facing output.

The registry design lives in `docs/current/PROFESSION_ACTION_REGISTRY_DESIGN.md`.

## Action Format

Actions use Markdown with YAML front matter. Required fields for the current design:

- `schema_version`: current value is `profession-action/v1`.
- `action_id`: stable snake_case identifier.
- `display_name`: player-facing action name.
- `status`: `not_implemented`, `planned`, `implemented`, or `retired`.
- `phase`: action timing.
- `owning_professions`: profession ids that may lead the action.
- `supporting_professions`: profession ids that may support the action.
- `input_data`: public, MekHQ-owned, hidden, and derived data categories.
- `roll_required`: boolean.
- `roll_policy`: named policy or `TBD`.
- `reveal_map_id`: named reveal map when the action maps roll margin or result quality to reveal permissions.
- `reveal_levels`: ordered reveal labels.
- `prompt_policy`: named prompt/filtering policy or `TBD`.
- `failure_modes`: action-specific failure labels.
- `test_expectations`: future validation expectations.

## Safety Rule

Runtime helpers must check action metadata and profession lookup before loading hidden scenario data. `not_implemented` and `planned` actions are design records only unless a later implementation issue adds permission, roll, filtering, prompt assembly, and tests.
