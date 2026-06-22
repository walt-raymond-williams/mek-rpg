# MekHQ Checkpoint Cross-Board Tracking Proposal

Date: 2026-06-21

Status: adopted tracking policy for completed MEK-RPG issues `#84` through `#89`; use the boundary and feedback sections for future MegaMek-side exporter coordination.

Purpose: define how MEK-RPG should track its checkpoint-adapter work while giving the MegaMek workspace clear dependency points for exporter hardening, schema decisions, and "waiting on RPG team" tickets.

## Recommendation

Use both boards, but keep ownership explicit:

- MEK-RPG issues track consumer-side work: adapter tests, consumed-field decisions, GM-facing surfacing, fixture edge cases, and campaign-context integration.
- MegaMek issues track producer-side work: exporter schema hardening, repeatable exporter smoke tests, deeper MekHQ method extraction, stable market identifiers, and possible movement into MekHQ source.
- Cross-board dependencies should be comments and linked issue references, not duplicated work descriptions that drift apart.

For live API work, use the same ownership pattern. MEK-RPG issues track consumer adapters, fixture validation, workflow docs, and gap surfacing. MegaMek/MekHQ issues track producer-side endpoint fields, source-backed extraction, schema hardening, and live API fixtures. MEK-RPG should create project-local memos and handoffs when it wants producer work; it should not edit the MegaMek workspace directly.

MEK-RPG does not need MegaMek confirmation before creating its own consumer-side issues. MegaMek confirmation is needed before assigning work to them, declaring their schema frozen, requesting field removals/renames as accepted requirements, or creating issues in their repo that imply producer-side commitment.

## MEK-RPG Issue Queue

- Issue `#84`: checkpoint export adapter experiments epic.
- Issue `#85`: add adapter tests using the sanitized MekHQ fixture.
- Issue `#86`: add adapter tests using disposable-save prototype output.
- Issue `#87`: define the MEK-RPG consumed-field mapping.
- Issue `#88`: define GM-facing surfacing for warnings and unsupported fields.
- Issue `#89`: add checkpoint fixture edge cases for adapter robustness.

## Proposed MegaMek-Side Tracking

The MegaMek board can create or update producer-side tickets with explicit dependency notes such as:

- "Waiting on MEK-RPG issue `#87` for consumed-field mapping before schema rename/removal decisions."
- "Waiting on MEK-RPG issue `#85` and `#86` for adapter test feedback before hardening exporter output against the schema."
- "Blocked on source-confirmed stable market offer identifiers before any market offer can be treated as an automation selector."

Suggested MegaMek-side tickets from the review memo:

- Harden the jar-backed checkpoint exporter output against the schema.
- Add a repeatable smoke test for sanitized fixture JSON and prototype JSON.
- Deepen read-only contract-term extraction.
- Deepen read-only logistics and transport/cargo warnings.
- Investigate whether a production exporter should move into MekHQ source.
- Investigate stable read-only market identifiers without implementing purchase automation.

Those tickets should live on the MegaMek board because the work depends on MekHQ source, jars, exporter packaging, or producer-side test infrastructure.

## Linkage Pattern

When MEK-RPG creates or updates an issue:

1. Link the relevant MegaMek artifact or memo path when available.
2. State whether the issue is `consumer-side`, `producer-side`, or `cross-board dependency`.
3. Keep the acceptance criteria scoped to this repo unless the issue is explicitly a coordination note.
4. Post a comment on the MegaMek ticket only when the MEK-RPG issue produces an actionable answer or blocks/unblocks exporter work.

When MegaMek creates or updates an issue:

1. Link the relevant MEK-RPG issue number.
2. State what answer or artifact is needed from MEK-RPG.
3. Avoid treating experimental MEK-RPG adapter tests as a frozen production schema.
4. Keep write-side workflows separate from read-only checkpoint export work.

## Status Vocabulary

Use these phrases in cross-board comments:

- `Ready for MEK-RPG adapter experiment`: a producer artifact is good enough for local consumer tests.
- `Waiting on MEK-RPG consumer decision`: exporter hardening should pause until MEK-RPG decides consumed fields or surfacing behavior.
- `Waiting on MegaMek exporter hardening`: MEK-RPG can test fixtures but should not promote the path to production.
- `Blocked on stable selector`: no automation can target the object safely yet.
- `Read-only only`: the issue must not include day advancement, market purchases, hiring, repairs, contract accept/decline, tactical result application, or direct save/XML mutation.

## Feedback To Send Back

Live API producer requests now live in `docs/current/MEGAMEK_LIVE_API_CHANGE_REQUEST.md`. The short version:

- Active loaded campaign setup should use `GET /campaign/summary` and `GET /campaign/state`, not save parsing.
- If data exists in the save or live MekHQ memory and MEK-RPG needs it for active campaign context, expose it through the read-only live API with provenance.
- Prioritize human-readable current system/location, method-backed finances, personnel availability/injury/fatigue, unit condition/repair/cargo context, active contract/scenario fixtures, repair/logistics pressure, categorized reports, and structured unsupported entries.
- Keep markets display-only unless stable selectors, guard fields, prompt policy, and command semantics are intentionally designed later.
- Keep write/action APIs out of the read-only live-state request.

Detailed consumed-field decisions now live in `docs/current/MEKHQ_CHECKPOINT_CONSUMED_FIELD_MAPPING.md`. Send this summary back to the MegaMek workspace:

- The current top-level shape is acceptable for MEK-RPG adapter experiments.
- Keep `evidence`, `source_owner`, `method_backed`, `warnings`, and `unsupported`; MEK-RPG wants these trust-boundary fields preserved.
- MEK-RPG near-term priorities are method-backed campaign/date/location, finance balance, personnel role/status/condition, unit status/condition/repair summary, active contract terms, scenario status, and sanitized reports.
- Replace object-string prototype values, such as `current_location`, with stable display/id fields before hardening the schema.
- Deepen active contract-term extraction through `Contract` getters before treating contract fields as schema-stable.
- Market offers should remain display/opportunity data only until stable source-confirmed identifiers exist.
- MEK-RPG will validate the shape through issues `#85` through `#89`; issue `#87` is the main dependency for field naming/grouping feedback.
- Recommended sequence: MEK-RPG adapter tests first, MegaMek exporter hardening second, and only then consider moving the exporter into MekHQ source.

## Boundary

This proposal does not authorize write-side automation. Future day advancement, contract accept/decline, hiring, repair, purchase, sale, assignment, or tactical result application must be separate issues with stable selectors, preconditions, prompt policy, disposable-save validation, and saved re-import confirmation.
