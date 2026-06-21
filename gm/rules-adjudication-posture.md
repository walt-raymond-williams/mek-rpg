# Rules Adjudication Posture

## Purpose

Use this procedure when the GM must decide how many rules to apply, whether to make a temporary ruling, or whether fiction/source flavor should influence a scene without becoming a rule.

## When to Use

- A situation is plausible in the fiction but not directly covered by a committed summary.
- The table must choose between fast play, exact source lookup, optional detail, or external tactical resolution.
- A player points to fiction, sourcebook flavor, or an edge case as if it were a rule.
- Applying every possible rule would slow the scene more than it helps.

## Do Not Use For

- Ignoring player-facing stakes after dice have been rolled.
- Overriding committed procedures without noting why.
- Treating fiction, examples, or in-universe narration as rules text.
- Resolving exact tactical combat, equipment tables, or unit records from memory.

## Basic Procedure

1. Run `scripts/check-ruling-authority.ps1` when a prompt might become a rules answer or deterministic helper input.
2. Identify the authority already loaded:
   - committed summary
   - private source page
   - campaign canon
   - external tactical tool
   - GM judgment
3. If authorities conflict, use `indexes/source-precedence.md` to decide which one owns the specific fact.
4. Decide whether the scene needs precision or momentum.
5. If precision matters, inspect the cited source pages or hand off to the proper tactical tool.
6. If momentum matters, make a narrow temporary ruling and state what it affects.
7. Apply optional or advanced rules only when the table has opted into that detail.
8. Record unresolved or consequential rulings in the active campaign save or a rules-gap note.
9. After the scene, update routing docs or file an issue only if the gap is recurring or important.

## Practical GM Guidance

- A Time of War supports selective rule use. Do not let optional complexity become mandatory unless the group chose it.
- Be consistent about scale. Personal scenes, vehicle scenes, and full tactical combat have different rules authorities.
- Do not use source fiction as a mechanical exception. Use it for tone, NPC voice, clues, and scenario inspiration.
- When a ruling changes a PC sheet, large asset, faction standing, injury, death risk, or mission result, record the basis and follow-up.

## Related Files

- `gm/roll-policy.md`
- `gm/scene-loop.md`
- `indexes/source-precedence.md`
- `gm/battletech-source-handoff.md`
- `gm/switch-to-classic-battletech.md`
- `gm/state-save-checklist.md`
- `indexes/task-router.md`
- `docs/current/RULING_AUTHORITY_GATE.md`

## Source References

- A Time of War PDF page 35 / printed page 33: selective rule use, GM adjudication, and fiction-versus-rules guidance.

## Status

Source-reviewed GM procedure for issue `#64`. Use for authority selection and temporary-ruling discipline; exact rules still require committed summaries, private source lookup, or external tactical tools.
