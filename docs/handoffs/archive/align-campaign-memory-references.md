# Align Campaign Memory References

## Issue

- GitHub issue: https://github.com/walt-raymond-williams/mek-rpg/issues/14
- Roadmap entry: Align campaign-memory references after issue `#13` review
- Mode: Project development
- Priority: High
- Status: Complete; archive after commit and push.

## Goal

Patch the weaknesses found in the issue `#13` review so future play and rules-routing consistently use the active campaign save folder instead of the legacy flat `campaign-state/` files.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/DOCUMENTATION_WORKFLOW.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`
- `campaign-state/active-campaign.md`
- `campaign-state/README.md`
- `gm/session-procedure.md`
- `gm/state-save-checklist.md`
- GitHub issue `#14`

## Review Findings To Address

- `indexes/task-router.md` still routes NPCs, running scenes, and mission creation to legacy flat files such as `campaign-state/npc-roster.md`, `campaign-state/faction-roster.md`, and `campaign-state/current-mission.md`.
- `campaign-state/setting-basics.md` still tells the GM to write factions to `campaign-state/faction-roster.md` and to read `campaign-state/current-campaign.md` / `campaign-state/current-mission.md`.
- `AGENTS.md`, `docs/current/MEK_RPG_PROJECT_PROFILE.md`, and `README.md` still describe persistent play-state updates as `campaign-state/` updates without clarifying that the active campaign pointer selects a durable save under `campaigns/`.
- `gm/state-save-checklist.md` updates `session-log.md`, but there is no explicit campaign-local previous-session or archive convention yet.

## Expected Output

- Update routing and GM-facing docs so play mode starts at `campaign-state/active-campaign.md` and writes persistent play state into the selected `campaigns/<campaign-id>/` folder.
- Keep legacy flat files clearly labeled as prototype/history rather than the default write target.
- Add a lightweight session-history convention, such as campaign-local `previous-sessions.md` or `sessions/`, and update templates/checklists accordingly.
- Update roadmap/tasks and archive this handoff at close-out.

## Files And Areas

Likely files to read or edit:

- `AGENTS.md`
- `README.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/CAMPAIGN_MEMORY_STRATEGY.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `indexes/task-router.md`
- `campaign-state/setting-basics.md`
- `campaign-state/README.md`
- `campaigns/README.md`
- `campaigns/_template/`
- `campaigns/playtest-galatea-dropship/`
- `gm/session-procedure.md`
- `gm/state-save-checklist.md`

## Commands

Useful commands or checks:

```powershell
git status --short --branch
rg "campaign-state/(current|player|npc|faction|unresolved|session-log|rules-gaps|playtest-bugs)|active-campaign|campaigns/_template" AGENTS.md README.md docs gm campaign-state campaigns indexes rules
git diff --check
git diff --cached --check
git diff --cached --name-only | Select-String -Pattern '^(source/atow-pdf/|source/atow-text/)'
```

## Constraints

- Route the task into Project development mode before editing.
- Do not process raw source PDFs or extracted text.
- Do not commit purchased PDFs, raw extracted text, copied tables, or secrets.
- Keep this as a lightweight documentation/workflow alignment task.
- Do not build a database or app.
- Preserve issue `#13` design intent: repo-native Markdown save folders.

## Acceptance Criteria

- Correct mode identified as Project development.
- `indexes/task-router.md` no longer points normal scene/NPC/mission work only at legacy flat files.
- `campaign-state/setting-basics.md` reflects the active-campaign save model.
- `AGENTS.md`, `docs/current/MEK_RPG_PROJECT_PROFILE.md`, and `README.md` clarify that `campaign-state/active-campaign.md` points to the durable save folder under `campaigns/`.
- Session history/archive convention is documented and reflected in `campaigns/_template/` and `gm/state-save-checklist.md`.
- Roadmap/tasks updated and handoff archived after completion.
- Verification run or blocker recorded.
- No protected raw source committed.
- Changes committed and pushed.

## Open Questions

- Should the session-history convention be a single `previous-sessions.md` file, a `sessions/` folder with dated files, or both?
- Should the Galatea playtest save adopt the new history convention immediately, or only the template?
