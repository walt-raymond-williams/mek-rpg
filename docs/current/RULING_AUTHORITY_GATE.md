# Ruling Authority Gate

Status: issue `#80` prototype. This document defines the deterministic pre-ruling gate used before mechanic helpers or agent rulings rely on routed rules metadata.

## Purpose

The gate answers one question: what authority posture applies to a prompt before a rule is answered?

It does not answer the rule, roll dice, inspect private source text, mutate campaign files, or apply MekHQ changes. It reads committed route-helper output, manifest metadata, and page-reference metadata.

## Authority Statuses

| Status | Meaning | Required next action |
| --- | --- | --- |
| `authoritative` | The primary route is an authority-selection or GM procedure route that can be used to decide source ownership or ruling posture. | Use the routed procedure, then read any rule summaries needed for the actual ruling. |
| `provisional` | The route reaches committed draft summaries. They can support table momentum, but the ruling should preserve uncertainty and citations. | Read the summaries and make a cautious GM ruling. |
| `source_lookup_required` | The route points at table-heavy, mapped-only, partial, source-lookup-only, or source-review material. | Inspect the cited private source pages, supply exact table/stat data, or create source-review follow-up. |
| `external_authority_required` | The route belongs to full tactical combat, MekHQ hard-ledger facts, MegaMek, Classic BattleTech, or another table-selected authority. | Prepare a handoff instead of resolving inside MEK-RPG. |
| `cannot_adjudicate` | The primary route has missing metadata or cannot prove authority from committed files. | Repair route, manifest, or page-reference metadata before using the route. |
| `blocked_missing_route` | No router candidate matched. | Start manually with `indexes/task-router.md` or add routing metadata. |

JSON output uses contract-style names: `authoritative`, `provisional`, `source_lookup_required`, `external_authority_required`, `cannot_adjudicate`, and `blocked_missing_route`.

## Helper

```powershell
./scripts/check-ruling-authority.ps1 "Can I shoot from cover?"
./scripts/check-ruling-authority.ps1 "BattleMech heat and hex movement" -Format json
```

The helper calls `scripts/route-rules-prompt.ps1`, evaluates the primary route candidate, and returns:

- `mode`: `rules_lookup_authority_gate`
- `status` and human-readable `status_label`
- routed files with manifest ids, statuses, source pages, page-reference status, and route warnings
- source-boundary proof that protected source text and PDFs were not read
- external-authority details when tactical or hard-ledger ownership applies
- failure mode and required next action

## Decision Rules

The gate evaluates the primary route candidate only. Lower-ranked route alternatives remain visible in the route helper, but they do not block a normal provisional ruling by themselves.

Decision order:

1. No candidates become `blocked_missing_route`.
2. Table-heavy or source-review cues, plus statuses such as `mapped-only`, `partial-draft`, `source-lookup-only`, `needs-source-review`, or `TBD`, become `source_lookup_required`.
3. Tactical handoff paths and hard-ledger cues become `external_authority_required`.
4. Missing primary-route metadata becomes `cannot_adjudicate`.
5. Source precedence, source conflict, and GM adjudication posture routes become `authoritative` for authority-selection only.
6. Draft summary routes become `provisional`.

## Boundaries

- Draft summaries are useful for source-aware play, not silent automation.
- Source-reviewed routing aids locate or frame authority; they are not complete rules engines.
- Exact item stats, tables, record sheets, full tactical combat, MekHQ ledger changes, and MegaMek operations must not be invented by the gate.
- Resolver prototypes must consume or reproduce the same authority envelope before returning a result.
