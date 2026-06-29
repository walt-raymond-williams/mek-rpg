# Profession Profiles

Profession profiles are MEK RPG rules overlays for MekHQ personnel roles and jobs. MekHQ remains authoritative for personnel facts, including job, assignment, injuries, fatigue, history, relationships, spouse, education, generated background, and campaign state.

## Profile Format

Profiles use Markdown with YAML front matter. This keeps profiles readable in play while giving future lookup and action-registry work stable metadata.

Use `rules/professions/profile-template.md` when adding a profile. Profile files should use kebab-case filenames and snake_case `profession_id` values.

Required front matter fields:

- `schema_version`: current value is `profession-profile/v1`.
- `profession_id`: stable snake_case identifier.
- `display_name`: player-facing profession name.
- `status`: use `not_implemented` until runtime lookup, action permission, roll, and prompt behavior are implemented and tested.
- `aliases`: deterministic MekHQ job, role, title, or assignment strings that may map to this profile. Empty is allowed only when unknown, but the key must exist.
- `mekhq_owned_fields`: MekHQ-owned personnel, campaign, logistics, scenario, or readiness fields this profile may need as input.
- `mek_rpg_overlay_fields`: MEK RPG overlay fields this profile owns, such as capabilities, action permissions, data-access limits, examples, and tests.
- `allowed_actions`: action ids this profession can own or support.

Required Markdown headings:

- Purpose.
- Typical capabilities.
- Relevant MekHQ fields.
- Relevant RPG skills.
- Allowed actions.
- Roll rules.
- Data access limits.
- Failure modes.
- Not-yet-implemented items.
- Example prompts/interactions.
- Test expectations.

## Ownership Boundary

Profile metadata and prose must distinguish MekHQ-owned facts from MEK RPG overlays:

- MekHQ-owned facts include personnel identity, job, assignment, rank/title, injury, fatigue, readiness, campaign state, unit assignment, logistics, finance, contract state, scenario state, and generated history.
- MEK RPG overlay fields include profession capability, action permission, roll-gate guidance, reveal/data-access limits, prompt examples, and test expectations.
- A profile may name MekHQ fields it needs, but it must not become a replacement character sheet or hard campaign ledger.
- Player-facing output may use only facts allowed by an action spec and reveal gate.

## Manual Checklist

Before committing a profile:

- Front matter has all required fields.
- `status` is `not_implemented` unless the runtime behavior and tests exist.
- `profession_id` matches the file's intended stable id.
- MekHQ-owned facts are listed under `mekhq_owned_fields`, not treated as profile-owned state.
- MEK RPG overlays are limited to permissions, capabilities, roll/reveal guidance, examples, and tests.
- Required headings are present.
- Hidden data access is routed through an action spec and reveal gate.
