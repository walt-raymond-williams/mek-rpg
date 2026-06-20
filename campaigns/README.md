# Campaign Saves

Each folder under `campaigns/` is a campaign or playtest save. Treat it like a tabletop GM binder: load one save before play, update it after meaningful state changes, and keep unrelated campaigns separate.

Use `campaigns/_template/` when creating a new campaign, or run:

```powershell
./scripts/new-campaign-save.ps1 my-campaign
```

The helper creates the folder only when it does not already exist and does not change `campaign-state/active-campaign.md`.

## Folder Rules

- One campaign or playtest per folder.
- Keep playtest-only saves clearly labeled.
- Record uncertainty with `Confirmed by user`, `Inferred`, `Unknown`, `Needs lookup`, or `Needs user confirmation`.
- Do not store raw rulebook text, purchased source material, secrets, or copied tables.
- Use Git for project versioning, not as the only campaign-memory mechanism.

## Standard Files

- `overview.md`: campaign premise, status, canon policy, and table-level assumptions.
- `current-state.md`: where play resumes, current date, active scene, and immediate next prompt.
- `pcs.md`: player characters, conditions, gear, goals, and sheet gaps.
- `npcs.md`: named NPCs, locations, affiliations, attitudes, goals, secrets, and status.
- `factions.md`: organizations, agendas, posture, assets, and important NPCs.
- `locations.md`: places introduced during play and what matters there.
- `assets.md`: money, ships, vehicles, contracts, permits, repairs, debts, and cargo.
- `relationships.md`: trust, leverage, promises, grudges, loyalty, and obligations.
- `missions.md`: active, paused, and completed missions.
- `hooks.md`: unresolved questions, threats, opportunities, and next-session prompts.
- `session-log.md`: active or most recent session notes and close-out summary.
- `previous-sessions.md`: completed-session archive used to preserve durable outcomes after `session-log.md` rolls forward.
- `rules-gaps.md`: missing or uncertain rules found during this campaign.
- `playtest-notes.md`: workflow bugs, procedure gaps, and test observations.
- `safety-and-tone.md`: player preferences, child/co-player guidance, and table boundaries.
