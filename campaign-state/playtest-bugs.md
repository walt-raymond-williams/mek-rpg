# Playtest Bugs

Record GM-mode workflow, routing, state-tracking, or usability problems found during playtests. Rules content gaps belong in `campaign-state/rules-gaps.md` unless the problem is specifically that routing or procedure failed.

## How To Record A Bug

- Date:
- Session or mission:
- Step being tested:
- Expected behavior:
- Actual behavior:
- Impact on play:
- Suggested fix:
- Follow-up issue:

## Known Bugs Before First Playtest

- None recorded.

## Bugs Found During Issue #12 Galatea DropShip Playtest

### Campaign Memory Is Flat Instead Of Campaign-Specific

- Date: 2026-06-20
- Session or mission: Galatea DropShip purchase playtest.
- Step being tested: saving state after a live playtest.
- Expected behavior: play mode can lock onto one campaign and maintain a campaign-specific save folder with PCs, NPCs, locations, assets, hooks, and session history for that campaign only.
- Actual behavior: current `campaign-state/` files are a single flat active state area, so separate campaigns or playtests can bleed together unless manually labeled.
- Impact on play: future sessions may confuse playtest-only facts with table canon or mix unrelated campaigns.
- Suggested fix: Issue `#13` should design campaign-specific save folders, active-campaign selection, and a state-save checklist.
- Follow-up issue: `#13`.

### No Dedicated Location Or Asset Roster

- Date: 2026-06-20
- Session or mission: Galatea DropShip purchase playtest.
- Step being tested: recording places, ships, funds, ownership stakes, liens, and pending offers.
- Expected behavior: GM can quickly find named locations, DropShips, money, contracts, permits, debts, and current asset status.
- Actual behavior: no clear owner file exists for locations or assets, so these details must be squeezed into session logs, NPCs, factions, hooks, or mission notes.
- Impact on play: resume context becomes scattered and easy to lose.
- Suggested fix: Issue `#13` should add or specify campaign-local files such as `locations.md`, `assets.md`, and possibly `relationships.md`.
- Follow-up issue: `#13`.

### Playtest Mission Diverged From Current Mission Scaffold

- Date: 2026-06-20
- Session or mission: Galatea DropShip purchase playtest.
- Step being tested: running issue `#12` manual playtest.
- Expected behavior: `current-mission.md` would match the playtest or the playtest would have a clean temporary mission slot.
- Actual behavior: the repo still pointed at `Checkpoint Ghosts`, while the live test used a Galatea DropShip purchase scene.
- Impact on play: close-out required careful labeling to avoid overwriting the original scaffold or treating the playtest as canon.
- Suggested fix: Issue `#13` should support per-campaign and per-session playtest records separate from canonical active missions.
- Follow-up issue: `#13`.
