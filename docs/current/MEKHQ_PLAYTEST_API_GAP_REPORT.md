# MekHQ Playtest API Gap Report

Status: created for epic issue `#113`.

Purpose: capture every place where MekHQ-linked RPG play needs live MekHQ data that is missing, stale, ambiguous, or unsupported in the open MekHQ local API. During play, agents should update this file immediately instead of parsing the active `.cpnx`, `.cpnx.gz`, XML, or raw save payload as a silent workaround.

## Operating Rule

When MekHQ is open, MEK-RPG play should use `scripts/fetch-mekhq-live-api.ps1` first. The helper captures the live local API into known JSON files:

1. `GET /campaign/summary` for loaded campaign identity and compact status.
2. `GET /campaign/state` with `bridge_metadata` for live read context.
3. `GET /campaign/commands` for read-only command readiness and safe selector discovery.
4. `GET /campaign/pending-deployments` for current scenario/deployment and viewpoint-person commitment lookup.

If a needed read is not available through those API surfaces or the capture manifest records a required-read failure, record the gap here. Raw save parsing remains an explicit offline, legacy, fixture, or debugging fallback only. A user-supplied save path may identify the campaign for the human, but it should not become the normal active-play data source while the live API is available.

## Entry Schema

Use this shape for new findings:

```markdown
### YYYY-MM-DD - short gap title

- Play context:
- Needed data:
- Attempted API read:
- Missing, stale, ambiguous, or unsupported field:
- Why it mattered for play:
- Fallback used:
- Expected read shape:
- Suggested producer/API change:
- Related issue or handoff:
- Status:
```

Field guidance:

- `Play context`: campaign, scene, issue, or rehearsal where the gap appeared.
- `Needed data`: the concrete read the GM needed, such as current location label, personnel injury detail, unit repair status, market selector, contract term, scenario objective, finance warning, or report bucket.
- `Attempted API read`: endpoint and section if known.
- `Fallback used`: should normally be `None`, `asked user`, `kept as Unknown`, `used stale imported campaign-local note with warning`, or `explicit user-approved offline save inspection`.
- `Expected read shape`: describe the field, id, label, list, count, status, warning, or method-backed value that would have avoided the gap.
- `Suggested producer/API change`: phrase as a request for the MekHQ API producer, not as a MEK-RPG save-parser workaround.

## Open Findings

### 2026-06-26 - Play-mode startup can still invite save-first behavior

- Play context: user-reported Mech RPG play sessions before epic issue `#113`.
- Needed data: all MekHQ-owned live campaign context for an open MekHQ session.
- Attempted API read: expected `GET /campaign/summary`, `GET /campaign/state` with `bridge_metadata`, and `GET /campaign/commands`.
- Missing, stale, ambiguous, or unsupported field: not a single field; the startup SOP was not strong enough in top-level play instructions.
- Why it mattered for play: agents could reach for save-derived context even though the intended loaded-campaign source is the open MekHQ API connection.
- Fallback used: planning correction; no raw save inspection was performed for this report entry.
- Expected read shape: a required play startup checklist that reaches the live API first and treats missing reads as API gaps.
- Suggested producer/API change: none yet; this is a MEK-RPG workflow hardening gap.
- Related issue or handoff: epic issue `#113`, story issues `#114`, `#115`, `#116`, and `#117`.
- Status: open until the child issues audit and validate the fixed workflow.

## Closed Findings

No closed findings yet.
