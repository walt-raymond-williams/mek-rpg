# Validate Personal Combat Lookup Flow By Hand

## Issue

- GitHub issue: https://github.com/walt-raymond-williams/mek-rpg/issues/8
- Roadmap entry: Validate personal combat lookup flow by hand
- Mode: Project development / manual validation
- Priority: High
- Status: Blocked until issue `#7` completes

## Goal

Run scenario-based lookup tests against the personal-combat summaries after they exist, starting from `indexes/task-router.md` and following only committed links.

This is a deliberate hand-test checkpoint: prove the GM assistant can find and apply personal combat procedures without raw source text or model memory.

## Required Context

Read these first:

- `AGENTS.md`
- `docs/current/AI_READY_PROJECT_WORKFLOW.md`
- `docs/current/MEK_RPG_PROJECT_PROFILE.md`
- `docs/current/PDF_TO_RULES_PIPELINE_PLAN.md`
- `docs/current/GITHUB_ISSUE_WORKFLOW.md`
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- `docs/current/CORE_LOOKUP_VALIDATION.md`
- GitHub issue `#7` output
- GitHub issue `#8`

## Expected Output

- A committed validation report or durable doc update with scenario prompts, lookup paths, pass/fail status, and gaps.
- Narrow routing/index/GM bridge fixes when safe.
- Follow-up GitHub issues for bugs, missing summaries, or ambiguous procedures found during hand testing.
- Updated `docs/current/ROADMAP.md` and `docs/current/TASKS.md`.
- This handoff archived after completion.

## Validation Prompts

Use scenario-based lookup tests such as:

- A fight starts in a corridor and the GM needs initiative.
- A character fires a pistol at a guard in personal-scale combat.
- A character punches or grapples an opponent in a bar fight.
- A character is hit and the GM needs to apply damage or wound effects.
- A wounded character needs treatment after the scene.
- The fight becomes tactical enough that exact range bands, facing, heat, armor locations, or full BattleTech unit turns matter.

Start each test at `indexes/task-router.md` and follow only committed links.

## Files And Areas

Likely files to read:

- `indexes/task-router.md`
- `rules/personal-combat/*.md`
- `rules/core/*.md`
- `gm/scene-loop.md`
- `gm/roll-policy.md`
- `gm/switch-to-classic-battletech.md`
- `indexes/page-reference-index.md`
- `indexes/manifest.yaml`

Likely files to edit:

- A validation report under `docs/current/` or another focused current doc.
- `indexes/task-router.md` for narrow routing fixes.
- GM bridge docs if a live-play lookup path is unclear.
- `docs/current/ROADMAP.md`
- `docs/current/TASKS.md`
- this handoff, moved to archive.

## Commands

```powershell
git status --short --branch
git check-ignore source/atow-pdf/example.pdf source/atow-text/page-0001.txt
```

## Constraints

- Validate committed summaries and indexes, not model memory.
- Do not inspect raw source text for this validation unless a narrow follow-up source-review issue is created.
- Do not invent missing rules; record gaps.
- Confirm protected source files remain ignored and unstaged before commit.

## Acceptance Criteria

- Correct mode identified as Project development / manual validation.
- Scenario lookup tests start at `indexes/task-router.md`.
- Test prompts cover initiative, ranged attack, melee attack, damage/wounds, treatment/recovery, and tactical handoff.
- Each test reaches appropriate summaries or records a clear gap.
- Narrow routing fixes are made or follow-up issues are created.
- Roadmap/task state updated and handoff archived.
- Changes committed, pushed, and issue updated/closed.

## Open Questions

- Final report location should be chosen after issue `#7` establishes the exact personal-combat summary layout.
