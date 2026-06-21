# Mechanic Contract Schema

Status: issue `#72` schema definition. This document defines the JSON shape for future deterministic helper prototypes; it does not implement a resolver.

Purpose: give every mechanic helper the same inspectable input, authority envelope, output, warning, failure, citation, proposed-state-change, and no-hidden-mutation fields.

## Contract Rules

- Helpers must accept explicit inputs. They must not infer character stats, equipment stats, tactical state, campaign facts, or MekHQ ledger facts from memory.
- Helpers must report authority before or with any result. A result without an authority envelope is not usable in play.
- Helpers must not read protected raw source text, copied tables, real MekHQ saves, or ignored source paths.
- Helpers must not mutate campaign files. They may return `proposed_state_changes` for a later review/apply step.
- Helpers must fail closed when a route is missing, source status is insufficient, exact private source lookup is required, or external tactical/MekHQ authority owns the procedure.

## Top-Level Input

Required fields for all helpers:

| Field | Type | Purpose |
| --- | --- | --- |
| `schema_version` | string | Contract version, starting at `0.1`. |
| `request_id` | string | Caller-supplied id for tracing one helper request. |
| `mechanic_id` | string | Stable id such as `core.basic_check`, `core.opposed_check`, or `combat.personal_checkpoint`. |
| `campaign_id` | string or null | Active campaign id when the result may affect play state. |
| `state_snapshot_ref` | object | File paths, section names, hashes, timestamps, or explicit statement that no campaign state was read. |
| `declared_action` | object | Player/GM-declared action, intent, stakes, and requested resolution scope. |
| `participants` | object | Actor, target, defender, assisting characters, or scene objects, using ids and supplied values. |
| `mechanic_inputs` | object | Skills, attributes, resources, target numbers, modifiers, equipment profiles, and other procedure-specific values. |
| `roll` | object | Roll expression, fixed roll values, RNG policy, or statement that no roll is requested. |
| `source_refs` | array | Candidate rules routes, manifest ids, summary paths, page references, or external authority references supplied to the helper. |
| `authority` | object | Precomputed or requested authority envelope. If omitted, the helper must produce or request an authority-gate result before resolving. |
| `options` | object | Optional-rule flags, table preferences, output format, and strictness settings. |

### `state_snapshot_ref`

Use this object to prove what state the helper did or did not inspect.

```json
{
  "read_files": [
    {
      "path": "campaigns/example/current-state.md",
      "section": "Current Scene",
      "sha256": "example-hash-or-null",
      "required": true
    }
  ],
  "unread_state_reason": null,
  "forbidden_paths_checked": [
    "source/atow-pdf/",
    "source/atow-text/"
  ]
}
```

### `declared_action`

```json
{
  "label": "Force a stuck maintenance hatch",
  "intent": "Open the hatch before the patrol arrives",
  "stakes": "On failure, lose time and make noise",
  "scope": "rpg-scale",
  "requested_resolution": "basic-check"
}
```

### `participants`

```json
{
  "actor": {
    "id": "pc-ada",
    "display_name": "Ada",
    "source": "campaigns/example/pcs.md"
  },
  "target": {
    "id": "scene-hatch",
    "display_name": "Maintenance hatch",
    "source": "GM scene state"
  },
  "defender": null
}
```

### `mechanic_inputs`

Values must be supplied by the caller, campaign files, or a previous safe helper. The helper should not guess missing values.

```json
{
  "skill": {
    "name": "Technician",
    "value": 4,
    "source": "caller-supplied"
  },
  "attribute": {
    "name": "Intelligence",
    "value": 5,
    "source": "caller-supplied"
  },
  "resources": [
    {
      "name": "Edge",
      "declared_use": false,
      "current_value": 2,
      "source": "caller-supplied"
    }
  ],
  "modifiers": [
    {
      "label": "Time pressure",
      "value": 1,
      "source": "GM ruling",
      "authority": "table-supplied"
    }
  ]
}
```

### `roll`

```json
{
  "mode": "fixed",
  "expression": "2d6",
  "values": [4, 5],
  "rng_seed": null,
  "reason": "Fixture-controlled result"
}
```

Allowed modes:

- `fixed`: caller supplies roll values.
- `random`: helper rolls using the declared expression and reports generated values.
- `none`: helper only reports authority, route, or cannot-adjudicate status.

## Authority Envelope

The authority envelope may be produced by a future issue `#80` authority gate or embedded by an early prototype if it follows the same fields.

| Field | Type | Purpose |
| --- | --- | --- |
| `status` | string | One of `authoritative`, `provisional`, `source_lookup_required`, `external_authority_required`, `cannot_adjudicate`, `blocked_missing_route`. |
| `confidence` | string | `high`, `medium`, `low`, or `none`. |
| `routed_files` | array | Files consulted or required before adjudication. |
| `manifest_entries` | array | Manifest ids, statuses, and summaries used for the authority decision. |
| `source_pages` | array | Page references already committed in summaries or indexes. |
| `source_boundary` | object | Proof that protected source text was not read or reproduced. |
| `external_authority` | object or null | Classic BattleTech, MegaMek, MekHQ, tabletop, private source, or other owner when applicable. |
| `warnings` | array | Non-fatal limitations, missing fields, optional-rule flags, or provisional notes. |
| `failure_mode` | string or null | Required next action when no result should be produced. |
| `required_next_action` | string | What the caller should do before using or applying a result. |

Example:

```json
{
  "status": "provisional",
  "confidence": "medium",
  "routed_files": [
    "rules/core/skill-checks.md",
    "rules/core/basic-action-resolution.md"
  ],
  "manifest_entries": [
    {
      "id": "core.skill-checks",
      "status": "draft"
    },
    {
      "id": "core.basic-action-resolution",
      "status": "draft"
    }
  ],
  "source_pages": [
    {
      "system": "A Time of War",
      "pdf": [41],
      "printed": [39],
      "source": "indexes/manifest.yaml"
    }
  ],
  "source_boundary": {
    "protected_source_read": false,
    "copied_table_or_stat_block": false,
    "notes": "Uses committed paraphrased summaries and page references only."
  },
  "external_authority": null,
  "warnings": [
    {
      "code": "draft-summary",
      "severity": "caution",
      "message": "Committed summary is draft status; preserve uncertainty."
    }
  ],
  "failure_mode": null,
  "required_next_action": "GM may use result as a provisional source-aware ruling."
}
```

## Top-Level Output

Required fields for all helper outputs:

| Field | Type | Purpose |
| --- | --- | --- |
| `schema_version` | string | Output contract version. |
| `request_id` | string | Mirrors input request id. |
| `mechanic_id` | string | Mirrors input mechanic id. |
| `status` | string | `resolved`, `provisional`, `source_lookup_required`, `external_authority_required`, `cannot_adjudicate`, `invalid_input`, or `error`. |
| `authority` | object | Authority envelope used for the result. |
| `result` | object or null | Mechanic-specific outcome if resolution is allowed. |
| `roll_breakdown` | object or null | Dice, modifiers, totals, target numbers, margins, and degree labels if applicable. |
| `citations` | array | Summary paths and page references used for the result. |
| `warnings` | array | All warnings, including authority warnings and helper-specific limitations. |
| `proposed_state_changes` | array | State proposals for later review; empty when no changes are proposed. |
| `unresolved_questions` | array | Missing inputs, uncertain authority, or follow-up questions. |
| `no_hidden_mutation` | object | Proof that the helper did not edit files or apply MekHQ changes. |
| `debug` | object | Optional deterministic trace safe for committed fixtures. |

### Status Values

- `resolved`: helper produced a usable deterministic result under the authority envelope.
- `provisional`: helper produced a cautious result that still requires GM judgment.
- `source_lookup_required`: helper cannot resolve without private source inspection.
- `external_authority_required`: helper must hand off to Classic BattleTech, MegaMek, MekHQ, tabletop, or another owner.
- `cannot_adjudicate`: current repository knowledge and supplied inputs are insufficient.
- `invalid_input`: required fields are missing or inconsistent.
- `error`: helper failed unexpectedly and should not be used for play.

### `result`

Common result fields:

```json
{
  "summary": "Success",
  "success": true,
  "margin": 3,
  "degree": "standard",
  "narrative_permission": "GM frames the hatch opening before patrol arrival.",
  "limits": [
    "Does not apply campaign state changes automatically."
  ]
}
```

### `roll_breakdown`

```json
{
  "expression": "2d6",
  "dice": [4, 5],
  "base_total": 9,
  "modifiers": [
    {
      "label": "Time pressure",
      "value": 1
    }
  ],
  "final_total": 10,
  "target_number": 7,
  "margin": 3
}
```

### `citations`

```json
[
  {
    "kind": "summary",
    "path": "rules/core/skill-checks.md",
    "manifest_id": "core.skill-checks",
    "manifest_status": "draft",
    "source_pages": {
      "pdf": [41],
      "printed": [39]
    }
  }
]
```

### `proposed_state_changes`

This field follows `docs/current/STATE_CHANGE_PROPOSAL_SCHEMA.md`; it is intentionally a proposal list, not an edit script.

```json
[
  {
    "proposal_id": "proposal-001",
    "type": "session-log",
    "target": {
      "file": "campaigns/example/session-log.md",
      "section": "Current Session"
    },
    "summary": "Record that Ada opened the maintenance hatch before the patrol arrived.",
    "evidence": "mechanic result and GM-approved stakes",
    "authority": "provisional",
    "requires_approval": true,
    "application_step": "Agent or user edits the campaign file after review.",
    "mekhq_ledger_effect": false
  }
]
```

### `no_hidden_mutation`

```json
{
  "files_read": [
    "rules/core/skill-checks.md",
    "rules/core/basic-action-resolution.md"
  ],
  "files_written": [],
  "mekhq_write_attempted": false,
  "campaign_write_attempted": false,
  "protected_source_read": false,
  "notes": "Helper returned proposals only."
}
```

## Example: Basic Check Resolved

```json
{
  "schema_version": "0.1",
  "request_id": "example-basic-001",
  "mechanic_id": "core.basic_check",
  "status": "provisional",
  "authority": {
    "status": "provisional",
    "confidence": "medium",
    "routed_files": [
      "rules/core/skill-checks.md",
      "rules/core/basic-action-resolution.md"
    ],
    "manifest_entries": [
      {"id": "core.skill-checks", "status": "draft"},
      {"id": "core.basic-action-resolution", "status": "draft"}
    ],
    "source_pages": [
      {"system": "A Time of War", "pdf": [41, 42, 43, 44], "printed": [39, 40, 41, 42]}
    ],
    "source_boundary": {
      "protected_source_read": false,
      "copied_table_or_stat_block": false,
      "notes": "Committed summaries only."
    },
    "external_authority": null,
    "warnings": [
      {"code": "draft-summary", "severity": "caution", "message": "Use as a provisional ruling."}
    ],
    "failure_mode": null,
    "required_next_action": "GM reviews result and proposed state changes."
  },
  "result": {
    "summary": "Success",
    "success": true,
    "margin": 3,
    "degree": "standard",
    "narrative_permission": "The declared action succeeds within the stated stakes.",
    "limits": ["No campaign file was edited."]
  },
  "roll_breakdown": {
    "expression": "2d6",
    "dice": [4, 5],
    "base_total": 9,
    "modifiers": [{"label": "Time pressure", "value": 1}],
    "final_total": 10,
    "target_number": 7,
    "margin": 3
  },
  "citations": [
    {
      "kind": "summary",
      "path": "rules/core/skill-checks.md",
      "manifest_id": "core.skill-checks",
      "manifest_status": "draft",
      "source_pages": {"pdf": [41], "printed": [39]}
    }
  ],
  "warnings": [
    {"code": "draft-summary", "severity": "caution", "message": "Preserve uncertainty if exact source wording matters."}
  ],
  "proposed_state_changes": [],
  "unresolved_questions": [],
  "no_hidden_mutation": {
    "files_read": ["rules/core/skill-checks.md", "rules/core/basic-action-resolution.md"],
    "files_written": [],
    "mekhq_write_attempted": false,
    "campaign_write_attempted": false,
    "protected_source_read": false,
    "notes": "No state was changed."
  },
  "debug": {
    "fixture_safe": true
  }
}
```

## Example: Opposed Check Resolved

```json
{
  "schema_version": "0.1",
  "request_id": "example-opposed-001",
  "mechanic_id": "core.opposed_check",
  "status": "provisional",
  "authority": {
    "status": "provisional",
    "confidence": "medium",
    "routed_files": [
      "rules/core/opposed-actions.md",
      "rules/core/basic-action-resolution.md"
    ],
    "manifest_entries": [
      {"id": "core.opposed-actions", "status": "draft"},
      {"id": "core.basic-action-resolution", "status": "draft"}
    ],
    "source_pages": [
      {"system": "A Time of War", "pdf": [41, 42, 43, 44], "printed": [39, 40, 41, 42]}
    ],
    "source_boundary": {
      "protected_source_read": false,
      "copied_table_or_stat_block": false,
      "notes": "Committed summaries only."
    },
    "external_authority": null,
    "warnings": [],
    "failure_mode": null,
    "required_next_action": "GM reviews opposed outcome before narration."
  },
  "result": {
    "summary": "Actor wins the contest",
    "winner_id": "pc-ada",
    "loser_id": "npc-guard",
    "margin": 2,
    "degree": "narrow",
    "limits": ["Does not decide follow-up damage or campaign consequences."]
  },
  "roll_breakdown": {
    "actor": {
      "expression": "2d6",
      "dice": [5, 3],
      "modifiers": [{"label": "Good tools", "value": 1}],
      "final_total": 9
    },
    "defender": {
      "expression": "2d6",
      "dice": [4, 3],
      "modifiers": [],
      "final_total": 7
    },
    "margin": 2
  },
  "citations": [
    {
      "kind": "summary",
      "path": "rules/core/opposed-actions.md",
      "manifest_id": "core.opposed-actions",
      "manifest_status": "draft",
      "source_pages": {"pdf": [41, 42], "printed": [39, 40]}
    }
  ],
  "warnings": [],
  "proposed_state_changes": [],
  "unresolved_questions": [],
  "no_hidden_mutation": {
    "files_read": ["rules/core/opposed-actions.md", "rules/core/basic-action-resolution.md"],
    "files_written": [],
    "mekhq_write_attempted": false,
    "campaign_write_attempted": false,
    "protected_source_read": false,
    "notes": "No state was changed."
  },
  "debug": {"fixture_safe": true}
}
```

## Example: Source Lookup Required

```json
{
  "schema_version": "0.1",
  "request_id": "example-source-lookup-001",
  "mechanic_id": "equipment.weapon_lookup",
  "status": "source_lookup_required",
  "authority": {
    "status": "source_lookup_required",
    "confidence": "none",
    "routed_files": [
      "rules/equipment/weapons.md"
    ],
    "manifest_entries": [
      {"id": "equipment.weapons-map", "status": "draft"}
    ],
    "source_pages": [
      {"system": "A Time of War", "pdf": [262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288], "printed": [260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286]}
    ],
    "source_boundary": {
      "protected_source_read": false,
      "copied_table_or_stat_block": false,
      "notes": "Exact item stats are not committed."
    },
    "external_authority": {
      "kind": "private_source_lookup",
      "owner": "User with legally owned source"
    },
    "warnings": [
      {"code": "exact-table-needed", "severity": "blocker", "message": "User must inspect the private source or supply the stat profile."}
    ],
    "failure_mode": "source_lookup_required",
    "required_next_action": "Ask the user to inspect the cited private source pages or provide the needed item profile."
  },
  "result": null,
  "roll_breakdown": null,
  "citations": [
    {
      "kind": "summary",
      "path": "rules/equipment/weapons.md",
      "manifest_id": "equipment.weapons-map",
      "manifest_status": "draft",
      "source_pages": {"pdf": [262, 288], "printed": [260, 286]}
    }
  ],
  "warnings": [
    {"code": "no-invented-stats", "severity": "blocker", "message": "Helper did not invent weapon stats."}
  ],
  "proposed_state_changes": [],
  "unresolved_questions": [
    "What exact weapon profile should be used?"
  ],
  "no_hidden_mutation": {
    "files_read": ["rules/equipment/weapons.md"],
    "files_written": [],
    "mekhq_write_attempted": false,
    "campaign_write_attempted": false,
    "protected_source_read": false,
    "notes": "No state was changed and no protected source was read."
  },
  "debug": {"fixture_safe": true}
}
```

## Example: Cannot Adjudicate

```json
{
  "schema_version": "0.1",
  "request_id": "example-cannot-001",
  "mechanic_id": "tactical.full_battlemech_combat",
  "status": "external_authority_required",
  "authority": {
    "status": "external_authority_required",
    "confidence": "high",
    "routed_files": [
      "gm/switch-to-classic-battletech.md",
      "rules/tactical/tactical-combat-overview.md"
    ],
    "manifest_entries": [
      {"id": "tactical.overview", "status": "source-reviewed-routing-aid"}
    ],
    "source_pages": [
      {"system": "A Time of War", "pdf": [202, 203], "printed": [200, 201]}
    ],
    "source_boundary": {
      "protected_source_read": false,
      "copied_table_or_stat_block": false,
      "notes": "Tactical summaries route handoff only."
    },
    "external_authority": {
      "kind": "tactical_engine",
      "owner": "Classic BattleTech, MegaMek, MekHQ, or table-selected tactical rules"
    },
    "warnings": [
      {"code": "tactical-handoff", "severity": "blocker", "message": "Exact BattleMech combat is outside MEK-RPG deterministic helper scope."}
    ],
    "failure_mode": "external_authority_required",
    "required_next_action": "Prepare a tactical encounter handoff instead of resolving this helper."
  },
  "result": null,
  "roll_breakdown": null,
  "citations": [
    {
      "kind": "gm-procedure",
      "path": "gm/switch-to-classic-battletech.md",
      "manifest_id": null,
      "manifest_status": "draft",
      "source_pages": null
    }
  ],
  "warnings": [
    {"code": "no-tactical-resolution", "severity": "blocker", "message": "No hex movement, heat, armor location, range, ammo, or critical-hit result was produced."}
  ],
  "proposed_state_changes": [],
  "unresolved_questions": [
    "Which tactical authority will the table use?"
  ],
  "no_hidden_mutation": {
    "files_read": ["gm/switch-to-classic-battletech.md", "rules/tactical/tactical-combat-overview.md"],
    "files_written": [],
    "mekhq_write_attempted": false,
    "campaign_write_attempted": false,
    "protected_source_read": false,
    "notes": "No state was changed; helper returns handoff requirement only."
  },
  "debug": {"fixture_safe": true}
}
```

## Validation Expectations For Future Helpers

Future helper tests should verify:

- missing required input fields return `invalid_input`;
- mapped-only or source-lookup-only routes return `source_lookup_required` or `cannot_adjudicate`;
- tactical/MekHQ hard-ledger cases return `external_authority_required`;
- every resolved or provisional result includes citations, warnings, and no-hidden-mutation proof;
- `proposed_state_changes` are suggestions only and contain approval/application fields;
- fixture runs do not read protected source paths or write campaign/MekHQ files.
