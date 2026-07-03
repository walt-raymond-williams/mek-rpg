# Agent Handoff

## Issue

- GitHub issue: `#147`
- Roadmap entry: `docs/current/ROADMAP.md` > `Sarna-backed immersion research workflow`
- Mode: Project development
- Priority: Ready when lore/immersion workflow work is next; start with audit issue `#151`

## Goal

Make Sarna.net/BattleTechWiki the first-class external BattleTech lore and setting research source for MEK-RPG gameplay immersion, while keeping MEK-RPG campaign files authoritative for table canon and MekHQ/MegaMek authoritative for current campaign state, logistics, mechanics, and tactical combat.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/TASKS.md`
- `docs/current/ROADMAP.md`
- Parent issue `#147`

Then read the relevant child issue:

- `#151`: audit MEK-RPG docs for Sarna research workflow insertion points
- `#150`: design the Sarna-backed BattleTech lore research workflow
- `#149`: update MEK-RPG docs and templates for Sarna research workflow
- `#148`: validate Sarna workflow with campaign and narration examples

## Practical Workflow Seed

Use Sarna/BattleTechWiki proactively when MEK-RPG needs BattleTech setting context it does not already have, especially for:

- factions, states, houses, clans, mercenary commands, and political relationships
- planets, regions, invasion corridors, borderlands, and local color
- BattleMechs, vehicles, DropShips, WarShips, aerospace craft, variants, manufacturers, and notable production history
- technology, weapons, equipment, institutions, historical events, wars, eras, and character-origin context
- narration, scenario prep, NPC background, player-facing briefings, mission color, and continuity-friendly improvisation

Do not use Sarna as the authority for current campaign facts, MekHQ state, rules procedures, live logistics, unit readiness, personnel status, or tactical mechanics. Authority order for play-facing facts should be:

1. Active MEK-RPG campaign save and table-canon notes.
2. MekHQ/MegaMek live API or accepted bridge records for MekHQ-owned state and tactical/logistics facts.
3. MEK-RPG rule summaries and indexes for A Time of War procedures.
4. Sarna/BattleTechWiki for external BattleTech lore/context.
5. GM improvisation, clearly framed as table color or provisional.

Live-play answers should stay concise:

- one or two sentences of lore color when the player needs quick context
- two to four bullets for a briefing, mission hook, or NPC-facing explanation
- defer deeper lore dives to prep notes unless the player asks for more
- blend Sarna context into the immediate scene rather than reciting article-style background

When Sarna context and campaign facts differ, preserve the campaign fact and treat Sarna as background canon that may be table-adjusted. Use labels such as `Confirmed from campaign`, `MekHQ-owned`, `Sarna context`, `Inferred`, or `Unknown` where uncertainty matters.

## Expected Output

- A concise audit of insertion points for Sarna guidance.
- A durable workflow doc under `docs/current/`.
- Links or short guidance in GM docs, prompts, and campaign templates.
- Validation examples showing concise lore-enhanced play, prep, narration, and player-facing context.

## Files And Areas

Likely files to read or edit:

- `AGENTS.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/GM_CONTEXT_PACKET_DESIGN.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `gm/`
- `campaigns/README.md`
- `campaigns/_template/`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
git diff --check
```

When issue work edits docs only, focused grep checks for stale wording are usually enough. Use the full quick suite only if scripts, validators, or routing helpers change.

## Constraints

- Keep the work in the MEK-RPG repo.
- Do not edit the MegaMek workspace for this epic.
- Do not make the work mostly about copyright or legal policy.
- Keep Sarna as external lore/context, not as a replacement for MEK-RPG campaign memory, MekHQ/MegaMek state, or A Time of War rules summaries.
- Keep live-play output short enough to preserve table momentum.

## Acceptance Criteria

- Child issues `#151`, `#150`, `#149`, and `#148` complete.
- The workflow states when to look things up, what answer categories should use Sarna, how to blend Sarna context with campaign facts, and how to stay concise during live play.
- Roadmap and task docs stay synchronized.
- Final validation examples are recorded before closing epic `#147`.

## Open Questions

- Should the workflow prefer direct Sarna article links in campaign notes, a short `Sarna context` field in templates, or both?
- Should future tooling add a small lore-research note helper, or is agent/browser workflow enough for now?
