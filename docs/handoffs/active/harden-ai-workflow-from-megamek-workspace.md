# Harden AI Workflow From MegaMek Workspace

## Issue

- GitHub issue: https://github.com/walt-raymond-williams/mek-rpg/issues/1
- Priority: High
- Type: Agent task

## Goal

Improve this repository's agentic workflow by comparing `mek-rpg` against the sibling `megamek-workspace` repository, then restructuring and rewriting the local workflow docs where appropriate.

The target outcome is not to copy the MegaMek workspace blindly. The target outcome is to adapt its durable-memory, issue-handoff, and close-out patterns to a private A Time of War rules-assistant and GM-assistant project.

## Required Context

Read these first:

- `AGENTS.md`
- `README.md`
- `docs/github-issues.md`
- `issues/initial-issues.md`
- `C:\Users\waltr\Documents\megamek-workspace\AGENTS.md`
- `C:\Users\waltr\Documents\megamek-workspace\docs\current\AI_READY_PROJECT_WORKFLOW.md`
- `C:\Users\waltr\Documents\megamek-workspace\docs\current\DOCUMENTATION_WORKFLOW.md`
- `C:\Users\waltr\Documents\megamek-workspace\docs\current\GITHUB_ISSUE_WORKFLOW.md`
- `C:\Users\waltr\Documents\megamek-workspace\docs\templates\AGENT_HANDOFF.md`
- `C:\Users\waltr\Documents\megamek-workspace\.github\ISSUE_TEMPLATE\agent-task.md`

Also inspect the current `mek-rpg` tree before editing:

```powershell
git status --short --branch
Get-ChildItem -Recurse -File docs,indexes,issues,gm,source,scripts | ForEach-Object { $_.FullName.Substring((Get-Location).Path.Length + 1) }
```

## Initial Analysis To Verify

The first-pass comparison found:

- `megamek-workspace` has a stronger separation between agent instructions, current durable knowledge, execution state, and domain profile.
- `megamek-workspace` uses `docs/current/` as the durable memory layer.
- `megamek-workspace` tracks work through `ROADMAP.md`, `TASKS.md`, GitHub issues, and per-issue handoff docs.
- `megamek-workspace` has reusable templates under `docs/templates/` and an issue template under `.github/ISSUE_TEMPLATE/`.
- `mek-rpg` currently has the right domain scaffold but lacks the mature workflow layer.
- `mek-rpg` should adapt the pattern for private rules summarization and GM assistance, not copy source-inspection-heavy MegaMek guidance verbatim.

The next agent should do its own quick analysis and adjust the plan if the repository state has changed.

## Important Design Question: Dual-Use Workspace

This repository has to do double duty:

1. Run the actual RPG campaign with Codex as a GM/rules assistant.
2. Develop and improve the rules-assistant project itself.

This can work, but only if the workflow explicitly routes agent behavior by mode. The next agent should design this as a first-class part of the workflow instead of treating it as an incidental detail.

Recommended mode split:

- `Play mode`: run scenes, answer in-character/out-of-character table needs, update only campaign state or session logs when appropriate, and avoid project-development work unless the user asks.
- `Rules lookup mode`: answer rules questions from `indexes/task-router.md` and verified/paraphrased summaries first; if incomplete, cite page references or mark a summary gap.
- `Project development mode`: work GitHub issues, edit docs/scripts/indexes/rule summaries, use handoffs, commit and push completed changes.
- `Source processing mode`: extract/map/summarize the legally owned PDF under strict copyright boundaries; this mode should only start on explicit user request.

The next agent should encode this split in `AGENTS.md` and the new `docs/current/MEK_RPG_PROJECT_PROFILE.md`. A future Codex session should be able to infer the right mode from the user request. If ambiguous, it should ask a short clarifying question before editing project files.

Suggested routing language:

- If the user asks to play, run a scene, continue the campaign, talk to an NPC, make a mission choice, or resolve an in-world situation, use Play mode.
- If the user asks "how does this rule work" or asks for a ruling, use Rules lookup mode.
- If the user asks to scaffold, refactor, create issues, improve docs, write scripts, summarize rules, or change repository files, use Project development mode.
- If the user asks to extract, parse, map, or summarize the PDF/source text, use Source processing mode.

Suggested write policy:

- Play mode may update `campaign-state/` and session logs when the user wants persistent campaign tracking, but should not create GitHub issues or edit workflow docs unless asked.
- Rules lookup mode should usually not edit files during play; it may suggest a follow-up issue if a rule gap is discovered.
- Project development mode should use issues/handoffs and commit/push completed repository changes.
- Source processing mode may write ignored extracted text and committed paraphrased summaries/indexes, but must never commit raw PDF/text.

## Recommended Changes

Add or adapt this structure:

```text
docs/
  current/
    AI_READY_PROJECT_WORKFLOW.md
    DOCUMENTATION_WORKFLOW.md
    GITHUB_ISSUE_WORKFLOW.md
    ROADMAP.md
    TASKS.md
    MEK_RPG_PROJECT_PROFILE.md
    KNOWN_COMMANDS.md
    SOURCE_PROCESSING_WORKFLOW.md
  handoffs/
    active/
    archive/
  templates/
    AGENT_HANDOFF.md
.github/
  ISSUE_TEMPLATE/
    agent-task.md
```

Update existing docs so the project has one clear workflow:

- `AGENTS.md`: point agents to `docs/current/` docs, define the mode router, strengthen commit/push close-out policy for development work, keep copyright and rules-answering constraints prominent.
- `README.md`: add a concise orientation to the new workflow docs.
- `docs/github-issues.md`: either migrate into `docs/current/GITHUB_ISSUE_WORKFLOW.md` or leave a short pointer to the new current doc.
- `issues/initial-issues.md`: keep as initial backlog if useful, but make `docs/current/ROADMAP.md` the durable planning source.

## Domain-Specific Requirements

Preserve these `mek-rpg` constraints:

- The GitHub repository is private, but it still must not contain purchased PDFs, EPUBs, or raw extracted rulebook text.
- Do not process the PDF as part of this issue.
- Do not add copyrighted rule text to issues, handoffs, or docs.
- Rule summaries must remain paraphrased, procedural, and page-referenced.
- Raw local source belongs under ignored paths:
  - `source/atow-pdf/`
  - `source/atow-text/`
- Rules answering should still route through `indexes/task-router.md` before summary files.
- GM mode should keep concise scene flow, meaningful rolls only, kid-friendly protection, and handoff to Classic BattleTech / MegaMek / MekHQ when tactical combat matters.

## Expected Output

- A workflow-hardening commit that adds the missing current-doc, handoff, template, and issue-template structure.
- Updated agent instructions and human README pointers.
- A task/roadmap model that makes the next steps clear before PDF extraction begins.
- No PDF parsing or source summarization.

## Suggested Acceptance Criteria

- `docs/current/MEK_RPG_PROJECT_PROFILE.md` clearly describes the private rules-assistant domain, protected inputs, source-processing boundaries, GM mode, and BattleTech integration posture.
- `docs/current/ROADMAP.md` converts the initial issue list into durable roadmap entries.
- `docs/current/TASKS.md` identifies current, next, backlog, blocked, and done work.
- `docs/current/GITHUB_ISSUE_WORKFLOW.md` explains issue creation, handoff lifecycle, labels, commits, pushes, and close-out.
- `docs/current/DOCUMENTATION_WORKFLOW.md` explains where future durable knowledge belongs.
- `docs/current/SOURCE_PROCESSING_WORKFLOW.md` explains the PDF extraction, section mapping, paraphrased summarization, validation, and page-reference workflow without processing the PDF.
- `docs/current/KNOWN_COMMANDS.md` includes repeatable local commands.
- `docs/templates/AGENT_HANDOFF.md` exists.
- `.github/ISSUE_TEMPLATE/agent-task.md` exists.
- `AGENTS.md` tells agents how to route requests into Play mode, Rules lookup mode, Project development mode, or Source processing mode.
- `AGENTS.md` tells agents to read the new current docs before project development work and to commit/push completed repo changes unless told otherwise.
- Play mode has a lighter close-out path than development mode: update campaign state/session logs when useful, but do not create development commits unless files were intentionally changed.
- `git status --short --branch` is clean after commit and push.

## Open Questions

- Should broad future work use feature branches, or is direct-to-`master` acceptable for this private repo until the project grows?
- Should `issues/initial-issues.md` remain as a historical seed list after `ROADMAP.md` exists?
- Should there be a `user-task` label for work only the user can do, such as placing the PDF locally?
