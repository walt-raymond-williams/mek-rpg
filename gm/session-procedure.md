# Session Procedure

Use this procedure when the user asks to start, resume, or play a campaign scene.

## Before Play

1. Review `campaign-state/active-campaign.md`.
2. If no active campaign is selected, ask which campaign save folder to load or whether to create one from `campaigns/_template/`.
3. For MekHQ-linked campaigns, follow `docs/current/MEKHQ_OPEN_CONNECTION_STARTUP_DECISION_TREE.md` before treating imported bridge files, saved checkpoints, or save-derived summaries as current.
4. When MekHQ is open, query `GET /status`, `GET /campaign/summary`, `GET /campaign/state` with `bridge_metadata`, and `GET /campaign/commands` for read-only command readiness before play.
5. When the scene depends on current operations, deployment assignment, or a viewpoint person's commitment, query `GET /campaign/pending-deployments` with `personId` or `personName` if needed.
6. If the API is available and sufficient, use the live API snapshot as current MekHQ-owned context and label it as live context until saved/imported confirmation, explicit user approval, or a future controlled promotion flow makes it durable.
7. If the API is available but lacks a needed read, returns a partial response for a requested section, or exposes unsupported fields that matter, update `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md` immediately and keep the missing fact labeled as `Unknown`, user-confirmed, or stale imported context until the API or user verifies it.
8. If the API is unavailable, ask whether to pause, proceed from the last campaign-local snapshot with stale-context labels, or explicitly run offline/debug save inspection. Record the chosen fallback.
9. Do not parse the active `.cpnx`, `.cpnx.gz`, XML, or raw MekHQ save as the routine context source during live play.
10. Review `campaign-state/setting-basics.md` for table canon, open user choices, and the canon policy.
11. Assemble a GM context packet using `docs/current/GM_CONTEXT_PACKET_DESIGN.md`: load the active campaign's structured state, recent session log, relevant durable memory, rules gaps, and safety/tone notes without blending authority layers.
12. For MekHQ-linked campaigns, include live API snapshot context when available, `mekhq-bridge.md`, `mekhq-api-gaps.md` when present, and unresolved `pending-mekhq-actions.md` items as command proposals, command results awaiting verification, or manual fallback intents, not confirmed hard ledger facts.
13. Check campaign-local rules gaps and playtest notes so known rough edges do not surprise the table.
14. Ask for only the open choice needed to run the next scene. If the answer can be deferred, start play.

## During Play

1. Use `gm/scene-loop.md` to frame the scene, present pressure, and ask what the player does.
2. Use `gm/roll-policy.md` before calling for a roll. Roll only when failure matters.
3. When a rule is needed, start at `indexes/task-router.md`, then read the routed summary before answering or calling for the roll.
4. Use these common live-play routes:
   - Uncertain actions, skills, pressure, opposed rolls, margins, or Edge: `rules/core/`.
   - Character-scale firefights, brawls, injury, bleeding, stun, recovery, or combat turns: `rules/personal-combat/`.
   - Personal weapons, armor, electronics, medical gear, or mission gear: `rules/equipment/`.
   - Mission aftermath, XP, contracts, contacts, reputation, injury downtime, and readiness: `rules/campaign/`.
   - Faction, era, rank/title, NPC, encounter, source authority, adjudication, and world-orientation questions: `rules/universe/`, `rules/gamemastering/`, `rules/campaign/power-rank-and-title.md`, and the relevant `gm/` orientation file.
   - RPG-scale vehicle scenes, piloting, gunnery, MechWarrior notes, crew roles, vehicle assets, or conversion notes: `rules/vehicles-and-mechs/`.
   - BattleMechs, vehicles, facing, heat, armor locations, hex movement, weapon ranges, ammunition, or detailed unit state: `gm/switch-to-classic-battletech.md`.
5. If the committed summaries are insufficient, use `gm/rules-adjudication-posture.md`; make a provisional ruling only when needed to keep play moving, then record the gap in the active campaign folder's `rules-gaps.md`.
6. Track important choices, injuries, equipment losses, faction reactions, relationship changes, location changes, asset changes, promises, rewards, costs, and new table canon.
7. Keep playtest-only facts separate from table canon unless the user explicitly promotes them.
8. For MekHQ-linked campaigns, use live API reads for MekHQ-owned context during the scene. If a needed read is absent or insufficient, record it in `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md` instead of routing around the API with active-save parsing.
9. For MekHQ-linked campaigns, check `GET /campaign/commands` before routing a committed hard ledger action to a manual fallback. If a supported guarded command is available, request `selectorDetail=full` only when the workflow needs deferred selectors, use readiness selectors and guard facts, run dry-run/preflight for high-value actions, require approval or documented automation policy, execute with prompt policy and idempotency safeguards, live reread, and reconcile. If no supported command is available or it refuses, write the intent to `pending-mekhq-actions.md` as a manual fallback or blocked producer request instead of treating it as final funds, roster, contract, repair, scenario, or date fact.

## After Play

1. Use `gm/state-save-checklist.md`.
2. Update the active campaign folder with the scene summary, rolls, state changes, rewards, costs, hooks, rules gaps, playtest notes, and next resume prompt.
3. Update persistent facts in the active campaign folder: current state, mission status, PCs, NPCs, factions, locations, assets, relationships, hooks, and safety/tone notes.
4. Add missing-rule or procedure problems to the active campaign folder's `rules-gaps.md` or `playtest-notes.md`.
5. For MekHQ-linked play, confirm any live API read gaps discovered during play were added to `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`.
6. For project-maintenance work, file follow-up GitHub issues only when the user asks or when running an explicit playtest close-out such as issue `#12`.
