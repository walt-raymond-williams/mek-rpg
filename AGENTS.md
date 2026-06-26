# Agent Instructions

## Project Mission

MEK RPG is a private personal-use rules-assistant and GM-assistant workspace for running a BattleTech RPG campaign using A Time of War style rules. Classic BattleTech, MegaMek, or MekHQ should be used when tactical BattleMech combat needs the full tactical rules.

## Start Here

For project development work, read these docs before editing:

1. `docs/current/AI_READY_PROJECT_WORKFLOW.md`
2. `docs/current/MEK_RPG_PROJECT_PROFILE.md`
3. `docs/current/DOCUMENTATION_WORKFLOW.md`
4. `docs/current/GITHUB_ISSUE_WORKFLOW.md`
5. `docs/current/TASKS.md`
6. Any task-specific GitHub issue body or handoff under `docs/handoffs/active/`

For play or rules lookup, start with the mode router below and only read the docs needed for that mode.

## Mode Router

Route every request into one primary mode before acting:

- `Play mode`: the user asks to play, run or continue a scene, talk to an NPC, make a mission choice, resolve an in-world situation, or update campaign events.
- `Rules lookup mode`: the user asks how a rule works, asks for a ruling, asks what page to check, or needs a procedure from the rules summaries.
- `Project development mode`: the user asks to scaffold, refactor, create issues, improve docs, write scripts, update indexes, summarize rules, or otherwise change repository files.
- `Source processing mode`: the user explicitly asks to extract, parse, map, or summarize a PDF or source text.

If the mode is ambiguous and file edits could result, ask a short clarifying question before editing.

## Sub-Agent Use

Use sub-agents when they materially improve speed, review quality, or parallel investigation.

Good uses:

- Independent review of substantial edits before commit.
- Parallel exploration of separate files, subsystems, issues, or rules areas.
- Splitting implementation across disjoint file sets.
- Source-processing checks where a second agent can independently verify page ranges, routing, acceptance criteria, or lookup usability.
- Play support where one agent checks rules or campaign state while the main agent keeps GM flow moving.

Default review expectation:

- For substantial project-development or source-processing changes, use one sub-agent review before commit when it materially improves quality and the tool is available.
- Do not use a dedicated copyright reviewer by default. The main agent is responsible for the source-boundary checklist: paraphrase summaries, cite pages, and confirm raw source files are ignored and unstaged.
- Use two independent reviewers only for broad workflow changes, complex implementation, large continuity-sensitive edits, or cases where the user explicitly requests extra review.
- For small, obvious edits, a main-agent self-review is enough.

Coordination rules:

- Give each sub-agent a narrow task and clear file scope.
- Do not assign overlapping write scopes unless necessary.
- Sub-agents may advise, or edit only when the current mode permits edits, within their assigned scope.
- The main agent remains responsible for final integration, verification, staging, commit, push, and issue close-out.
- Do not let sub-agent use block progress when the tool is unavailable.

## Copyright Boundaries

- Do not redistribute copyrighted rulebook text.
- Do not copy large verbatim passages from legally owned source material into summaries, issues, handoffs, or chat responses.
- Use paraphrase, procedure summaries, original examples, and page references.
- Keep raw PDFs and extracted text private under ignored paths.
- Preserve uncertainty when a summary is incomplete or unverified.
- Do not commit purchased PDFs, EPUBs, raw extracted text, copied tables, or secrets.

Protected local source paths:

- `source/atow-pdf/`
- `source/atow-text/`

## Play Mode

- Use `gm/scene-loop.md`, `gm/roll-policy.md`, and related `gm/` docs.
- Start with `campaign-state/active-campaign.md`; load exactly one selected `campaigns/<campaign-id>/` save folder for persistent PCs, NPCs, missions, assets, relationships, hooks, and session notes.
- For MekHQ-linked play, treat the open MekHQ local API connection as the normal source of MekHQ-owned live context. Use `scripts/fetch-mekhq-live-api.ps1` as the standard read boundary when MekHQ is open; it captures `GET /status`, `GET /campaign/summary`, `GET /campaign/state` with `bridge_metadata`, `GET /campaign/pending-deployments` when current scenario/personnel commitment matters, and `GET /campaign/commands` into known JSON files for downstream scripts.
- Follow `docs/current/MEKHQ_OPEN_CONNECTION_STARTUP_DECISION_TREE.md` before treating imported bridge notes, generated campaign-local files, saved checkpoints, or save-derived summaries as current MekHQ-owned context.
- Do not parse the active `.cpnx`, `.cpnx.gz`, XML, or raw MekHQ save as the routine live-play context path. Use save parsing only when the user explicitly asks for offline, legacy, fixture, or debugging inspection, or when the live API is unavailable and that fallback is clearly recorded.
- If a needed MekHQ read is missing, stale, ambiguous, or unsupported in the live API during play, immediately add an entry to `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md` with the needed data, attempted API read, blocker, fallback used, and suggested API/read shape. Missing API data is a producer gap, not permission to silently read the active save.
- Keep play moving with concise scene framing.
- Present NPCs, choices, consequences, and roll prompts.
- Ask for rolls only when failure matters.
- Give 2-4 concrete options when the player seems unsure.
- Track meaningful state changes in the active campaign save folder. Use `campaign-state/` for the active-campaign pointer, global setting seed, and legacy prototype notes.
- Do not create GitHub issues or perform project-development work unless asked.
- Do not kill a child player character without explicit adult approval.
- Switch to Classic BattleTech, MegaMek, or MekHQ when tactical combat matters.

Play mode has a lighter close-out path: update the active campaign save files or session logs when useful, but do not make development commits unless files were intentionally changed for the task.

## Rules Lookup Mode

1. First read `indexes/task-router.md`.
2. Read the relevant summary files listed by the router.
3. Answer from project summaries first.
4. Do not answer A Time of War rules questions from memory if project summaries exist.
5. If summaries are insufficient, use `indexes/page-reference-index.md` or source references in summaries to tell the user where to inspect the legally owned source.
6. Do not invent rules. Say what is known, what is uncertain, and where to verify.

Rules lookup mode should usually not edit files during play. If a gap is found, suggest or create a follow-up issue only when the user asks for project maintenance.

## Project Development Mode

- Use GitHub Issues for major work when available.
- Use handoffs under `docs/handoffs/active/` for agent-executed issues.
- Keep durable workflow and planning knowledge in `docs/current/`.
- Keep rule summaries concise, paraphrased, procedural, and page-referenced.
- Update related files when a rule summary, index, or workflow changes.
- Use `gh` CLI when available and authenticated.
- Track major work as GitHub Issues.
- Keep commits small and logical.
- Reference issue numbers in commit messages when practical.
- Do not fail local setup if GitHub is not connected; record the blocker.
- Only make repository changes inside this project unless the user explicitly asks you to modify another repository. If work here reveals needed changes in another repository or workspace, create a memo, change-request document, GitHub issue, or handoff in this project instead of editing that other repository directly.
- Cross-repository coordination should describe the observed evidence, requested change, suggested owner, affected files or commands, and any verification already performed. The other repository's own agents or maintainers should decide whether and how to apply it.
- If the user asks to use `$resolve-github-issues`, run the autonomous issue-resolution loop from the named skill and continue across context compactions by recovering state from GitHub Issues, active handoffs, `docs/current/ROADMAP.md`, `docs/current/TASKS.md`, git status, and pushed commits rather than chat memory alone.

Project-development close-out:

1. Run reasonable verification or record the blocker.
2. Check `git status --short`.
3. Stage only files that belong to the completed work.
4. Commit completed repository changes unless the user explicitly says not to commit.
5. Push to the tracked branch unless the user explicitly says not to push.
6. Confirm `git status --short --branch` is clean or clearly report why it is not.
7. Update or close the GitHub issue when appropriate.

## Source Processing Mode

Source processing is explicit-request-only. Do not process any PDF as incidental setup for another task.

1. Place the legally owned PDF in `source/atow-pdf/`.
2. Extract page-level text into ignored `source/atow-text/`.
3. Build a chapter and section map before summarizing.
4. Create paraphrased Markdown summaries using the standard schema.
5. Preserve page references.
6. Update routing indexes and `indexes/manifest.yaml`.
7. Verify raw source files are not staged before committing.

Follow `docs/current/SOURCE_PROCESSING_WORKFLOW.md` for the full workflow.

## File Update Policy

- Keep rule summaries concise and procedural.
- Update related files when a rule summary changes.
- Keep the active campaign save folder current after each session or scene when persistent tracking is useful.
- Do not store secrets, purchased PDFs, or raw extracted book text in committed files.
- When docs disagree, prefer `docs/current/` unless the user gives newer instructions.

## Definition Of Done

For project development work:

- New or changed files are committed and pushed unless blocked or explicitly disabled by the user.
- Raw source files remain ignored and unstaged.
- Relevant indexes point to the right summaries.
- Summaries include source page references or `TBD`.
- Unverified rules are marked as placeholders, `Unknown`, or `Needs source review`.
- The next concrete task is documented in GitHub Issues, `docs/current/TASKS.md`, or project notes.
- The final response reports verification, commit hash, push status, and blockers or open questions.
