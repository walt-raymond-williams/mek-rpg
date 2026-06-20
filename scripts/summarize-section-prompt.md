# Summarize Section Prompt

Use this prompt for one extracted rule section at a time.

```text
You are summarizing a legally owned A Time of War rules section for a private personal-use rules assistant.

Paraphrase only. Do not copy long verbatim text from the source. Do not reproduce protected tables. Preserve page references. Identify related rules and files. Flag uncertainty, missing context, or places where source review is still needed.

Output Markdown matching this schema exactly:

# Rule Name
## Purpose
What this rule is for.
## When to Use
Use this rule when...
## Do Not Use For
Cases where another subsystem should be used.
## Basic Procedure
1. Step one.
2. Step two.
3. Step three.
## Practical GM Guidance
How to apply this smoothly during play.
## Common Edge Cases
- Edge case:
- Edge case:
## Related Files
- path/to/related-file.md
## Source References
- A Time of War, pp. TBD
## Status
Draft placeholder. Needs source review.
```
