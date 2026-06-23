# MekHQ Checkpoint Warning Surfacing

Status: issue `#88` GM-facing policy for MekHQ checkpoint export warnings and unsupported fields.

Purpose: define how MEK-RPG should show MekHQ checkpoint warnings and unsupported fields to the GM without treating unknown, unsafe, or unsupported data as confirmed campaign facts.

## Decision

Warnings and unsupported fields are part of the checkpoint, not noise. MEK-RPG should preserve them in bridge diagnostics and surface the ones that affect the current scene, import trust, manual MekHQ work, or tactical handoff.

Do not hide a warning by replacing the missing value with a guess. Use `Unknown`, `Unsupported`, `Needs MekHQ inspection`, or a pending manual checklist until MekHQ or the user confirms the hard ledger fact.

## Severity Categories

| Severity | Trigger | GM-facing behavior | Blocks play? |
| --- | --- | --- | --- |
| `Blocker` | `unsupported[].blocks_automation` is true, a stable selector is missing for an action, the checkpoint is not read-only, or a required hard-ledger field is absent for the requested scene. | Put in the packet `Warnings` section and the bridge diagnostics. State what manual MekHQ inspection or future issue is needed. | Blocks automation. Blocks play only when the current scene depends on the missing hard fact. |
| `Manual inspection` | Evidence is `Needs MekHQ inspection`, method backing is `Unknown`, route/cargo/transport semantics are unvalidated, or a value came from prototype output with known caveats. | Surface near the affected field in GM prep or bridge diagnostics. Use as advisory context, not final authority. | Does not block ordinary roleplay; blocks exact logistics, travel, market, or tactical claims. |
| `Caution` | Field-level `warnings` exist but the value is still useful as context, such as shallow contract terms, compact reports, or summarized unit condition. | Show a short warning next to the value when it is displayed to the GM. | Does not block play. The GM should avoid overclaiming precision. |
| `FYI` | Producer metadata warnings, sanitation notices, empty report buckets, or extension fields that do not affect the current question. | Preserve in adapter diagnostics. Surface only when reviewing import health or debugging. | No. |

## Required Placement

Use this placement order for future adapters, checkpoint review files, and context packets:

1. `mekhq-bridge.md` or equivalent bridge diagnostics should preserve import metadata, top-level warnings, unsupported entries, and source/evidence notes.
2. GM context packets should include a concise warning list for active blockers, manual-inspection items, and caution items relevant to the next scene.
3. Campaign-facing files such as `current-state.md`, `missions.md`, `assets.md`, `pcs.md`, and `npcs.md` should include only the warning needed to prevent misusing the displayed value.
4. Checkpoint review files or adapter diagnostics may preserve full warning details, local path sanitation notes, producer caveats, and ignored extension-field notes.
5. Player-facing narration should not expose raw diagnostics unless the GM intentionally turns them into in-world uncertainty.

## Unsupported Field Rules

Treat `unsupported[]` entries as structured decisions:

- If `blocks_automation` is true, never create or execute a pending MekHQ action from that field.
- If the unsupported field affects a requested hard-ledger answer, tell the GM what is unknown and where to inspect in MekHQ.
- If the unsupported field affects only a future feature, preserve it in diagnostics and continue.
- If `recommended_owner` names the MekHQ exporter or a future source change, do not solve it in MEK-RPG by inventing a local selector or rule.
- If the unsupported field is `write_commands`, keep the read-only boundary explicit: checkpoint JSON is not a command payload.

## Common Cases

| Area | Surface as | GM guidance |
| --- | --- | --- |
| Missing unit-market stable offer id | Blocker | Show market offer as an opportunity only. Purchase remains manual in MekHQ. |
| Contract-market prompt policy unsupported | Blocker | Show contract offer as context only. Accept/decline remains manual or future source-backed work. |
| Cargo or transport pressure needs inspection | Manual inspection | Use as logistics pressure, not exact capacity or assignment authority. |
| Prototype `current_location` object string | Manual inspection | Prefer current system id/name; ask for MekHQ/UI confirmation before exact location claims. |
| Shallow contract terms | Caution | Use contract identity/status confidently; treat terms as summary until `Contract` getter extraction is deeper. |
| Long maintenance report | Caution | Surface compact repair/readiness implications; keep raw verbose report out of campaign-facing docs. |
| Empty report buckets | FYI | No GM action unless a missing report category matters to the current question. |
| Producer/sanitation warning | FYI or Caution | Preserve for import health; surface only if it affects trust in the current checkpoint. |

## When Warnings Block Play

Warnings should rarely stop ordinary roleplay. They should stop or defer a scene only when the next decision depends on an unsupported hard fact.

Block or pause for manual inspection when:

- the user asks to buy, sell, hire, accept/decline, repair, assign, advance the day, or apply tactical results from checkpoint data
- the scene depends on exact funds, exact transport capacity, exact unit readiness, exact contract terms, or exact personnel availability and the checkpoint marks that area unsupported or needs inspection
- the checkpoint date, campaign identity, or read-only proof is missing or contradictory
- a pending MekHQ action would be treated as completed before saved re-import confirms it

Continue with a warning when:

- the scene only needs broad context, pressure, or hooks
- the field is clearly display-only, such as market opportunities or sanitized reports
- a method-backed summary is enough and exact tactical/logistics detail is not being adjudicated

## Packet Wording

Use concise wording in GM context packets:

```text
- BLOCKER: Unit market offers have no stable selector; purchases remain manual in MekHQ.
- INSPECT: Cargo pressure is advisory only; verify transport/bay details in MekHQ before exact logistics rulings.
- CAUTION: Contract terms are shallow prototype summaries; use active contract identity/status confidently, but verify terms before negotiation scenes.
- FYI: Prototype exporter initialized MekHQ jars without launching the GUI; read-only checkpoint output remains experimental.
```

## Adapter Guidance

Future adapters should produce a warning summary with:

- severity
- source area and field
- short message
- affected object id or display name when available
- evidence/source owner
- whether it blocks automation
- recommended owner or next manual check

Adapters should preserve the full raw warning object in diagnostics, but campaign-facing Markdown should use the short summary unless the GM explicitly asks for debug detail.

## Boundaries

This policy does not authorize write automation from checkpoint/state rows, direct save/XML mutation, market selectors, day advancement, repair execution, hiring, contract accept/decline, or tactical-result application. Supported mutation must come from explicit command readiness plus guarded MekHQ command endpoints, such as `contracts.accept` when available. This document only defines how to show checkpoint uncertainty safely.
