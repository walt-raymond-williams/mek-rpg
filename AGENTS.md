# Agent Instructions

## Project Mission
MEK RPG is a private personal-use rules-assistant and GM-assistant workspace for running a BattleTech RPG campaign using A Time of War style rules. Classic BattleTech, MegaMek, or MekHQ should be used when tactical BattleMech combat needs the full tactical rules.

## Copyright Boundaries
- Do not redistribute copyrighted rulebook text.
- Do not copy large verbatim passages from legally owned source material into summaries.
- Use paraphrase, procedure summaries, examples, and page references.
- Keep raw PDFs and extracted text private under ignored paths.
- Preserve uncertainty when a summary is incomplete or unverified.

## Rules-Answering Workflow
1. First read `indexes/task-router.md`.
2. Read the relevant summary files listed by the router.
3. Answer from project summaries first.
4. Do not answer A Time of War rules questions from memory if project summaries exist.
5. If summaries are insufficient, use `indexes/page-reference-index.md` or source references in summaries to tell the user where to inspect the legally owned source.
6. Do not invent rules. Say what is known, what is uncertain, and where to verify.

## GM-Mode Workflow
- Keep play moving with concise scene framing.
- Present NPCs, choices, consequences, and roll prompts.
- Ask for rolls only when failure matters.
- Give 2-4 concrete options when the player seems unsure.
- Track campaign state in `campaign-state/`.
- Do not kill a child player character without explicit adult approval.
- Switch to Classic BattleTech, MegaMek, or MekHQ when tactical combat matters.

## PDF-Processing Workflow
1. Place the legally owned PDF in `source/atow-pdf/`.
2. Extract page-level text into `source/atow-text/`.
3. Build a chapter and section map before summarizing.
4. Create paraphrased Markdown summaries using the standard schema.
5. Preserve page references.
6. Update routing indexes and `indexes/manifest.yaml`.

## File Update Policy
- Keep rule summaries concise and procedural.
- Update related files when a rule summary changes.
- Keep campaign state current after each session or scene.
- Do not store secrets, purchased PDFs, or raw extracted book text in committed files.

## Git/GitHub Issue Policy
- Use `gh` CLI when available and authenticated.
- Track major work as GitHub issues.
- Keep commits small and logical.
- Reference issue numbers in commit messages when practical.
- Do not fail local setup if GitHub is not connected.

## Definition of Done
- New or changed files are committed.
- Raw source files remain ignored.
- Relevant indexes point to the right summaries.
- Summaries include source page references or `TBD`.
- Unverified rules are marked as placeholders or needing source review.
- The next concrete task is documented in issues or project notes.
