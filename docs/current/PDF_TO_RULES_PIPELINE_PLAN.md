# PDF To Rules Pipeline Plan

## Purpose

This plan defines how a legally owned A Time of War PDF becomes a private source corpus and a committed rules-document system that a future GM agent can use during play.

The goal is not to produce broad notes. The goal is to make rules discoverable, procedural, and routed:

1. A GM agent recognizes the table situation.
2. The agent reads `indexes/task-router.md` first.
3. The router points to a focused paraphrased summary.
4. The summary tells the agent when to use the rule, when not to use it, how to apply it, and where to verify source pages if incomplete.
5. If tactical BattleTech detail matters, GM docs route the scene to Classic BattleTech, MegaMek, or MekHQ instead of forcing RPG summaries to do tactical work.

This is a planning document only. Do not process any PDF, extract text, inspect source text, or summarize source pages until the user explicitly requests Source processing mode and the legally owned PDF is present locally.

## Safety Boundary

Private ignored source files:

- `source/atow-pdf/`: legally owned PDF files only.
- `source/atow-text/`: page-level extracted text files only.

Committed safe outputs:

- `source/extraction-notes.md`: extraction metadata, page offset notes, OCR/layout issues, and process notes, without copied rule text.
- `rules/**.md`: concise paraphrased summaries with page references.
- `indexes/task-router.md`: situation-to-summary routing.
- `indexes/rules-map.md`: subsystem overview and relationships.
- `indexes/subsystem-index.md`: subsystem ownership and directory map.
- `indexes/page-reference-index.md`: topic and summary file to source page mapping.
- `indexes/manifest.yaml`: stable machine-readable summary IDs, files, pages, relationships, and status.
- `gm/**.md`: GM procedures that call into the rules system and tactical handoff docs.

Never commit purchased PDFs, EPUBs, raw extracted text, copied tables, or long verbatim rulebook passages.

## Pipeline Stages

### 1. Intake And Extraction

Entry condition:

- The user explicitly asks to process the legally owned source.
- The PDF is present under `source/atow-pdf/`.
- `.gitignore` still ignores `source/atow-pdf/*`, `source/atow-text/*`, `*.pdf`, and `*.epub`.

Process:

1. Record the PDF filename, date, tool versions, and extraction command in `source/extraction-notes.md`.
2. Run the extraction script only after the entry condition is met.
3. Produce one private text file per PDF page under `source/atow-text/page-0001.txt`, `page-0002.txt`, and so on.
4. Record extraction failures, blank pages, OCR problems, multi-column problems, table-heavy pages, and page-number offset observations.
5. Verify ignored-source protection before staging any committed files.

Acceptance:

- Page text exists only in ignored `source/atow-text/`.
- The extraction notes contain metadata and issues, not copied rule content.
- `git status --short` does not show raw source files.

### 2. Chapter And Section Mapping

Entry condition:

- Page-level text exists in ignored `source/atow-text/`.
- The user has explicitly asked for source mapping.

Process:

1. Build a chapter map before writing any rule summaries.
2. Assign stable section IDs using a predictable pattern such as `atow.chapter.section-topic`.
3. Record for each section:
   - chapter or major subsystem
   - section title paraphrase or topic label
   - PDF page range
   - printed source page range when known
   - extraction quality
   - candidate summary file path
   - candidate manifest ID
   - status: `mapped`, `needs source review`, or `blocked`
4. Track page offset explicitly. If PDF page 1 and printed page 1 do not match, record both values and keep all later references consistent.
5. Mark table-heavy or example-heavy sections for careful human/source review instead of trying to reproduce them.

Recommended committed output:

- `source/extraction-notes.md` for extraction and offset notes.
- `indexes/page-reference-index.md` for topic-to-page mapping once topics are stable.
- `indexes/manifest.yaml` with placeholder entries only after summary targets are chosen.

Acceptance:

- A future summarization agent can identify the exact private page text files to consult for one section without scanning the whole book.
- No summaries are written before the relevant section boundaries are mapped.

### 3. Summary Authoring

Summaries must be narrow, paraphrased, procedural, and page-referenced. Use one focused rules area at a time.

Every summary should use this shape:

- `Purpose`: what the rule is for.
- `When to Use`: scene cues that route the GM to this rule.
- `Do Not Use For`: nearby cases that belong to another summary, GM procedure, or tactical BattleTech handoff.
- `Basic Procedure`: concise ordered steps that can be applied during play.
- `Practical GM Guidance`: how to keep the scene moving and what to say before rolling.
- `Common Edge Cases`: short paraphrased uncertainty and related-case notes.
- `Related Files`: summaries, GM docs, campaign-state files, and tactical handoff docs.
- `Source References`: source page references, using `TBD` only for placeholders.
- `Status`: `placeholder`, `draft`, `needs source review`, `verified`, or `superseded`.

Routing cues are required. A future GM should be able to scan `When to Use` and `Do Not Use For` and decide whether the summary applies without relying on memory.

Do not include copied rulebook prose or copied tables. For table-driven procedures, paraphrase what the table is used for and cite the page where the user can inspect the legally owned source.

### 4. Index And Manifest Updates

Every new or materially changed summary must update the routing layer in the same change set.

`indexes/task-router.md`:

- Map player-facing or GM-facing situations to the first summary to open.
- Include common natural-language triggers, such as uncertain action, opposed check, injury, recovery, buying gear, vehicle scene, or tactical fight.
- Keep the table concise enough to use live.
- Route BattleMech tactical combat to `gm/switch-to-classic-battletech.md` when hex movement, facing, heat, armor locations, weapon ranges, or full unit turns matter.

`indexes/rules-map.md`:

- Maintain subsystem-level descriptions.
- Note dependency direction, such as personal combat using core resolution or recovery linking to campaign downtime.
- Avoid source details; this file is a map, not a summary.

`indexes/subsystem-index.md`:

- Keep the directory ownership list current.
- Add new subsystem folders only when there is a real repeated body of summaries.
- Include GM procedure and campaign-state folders when they are part of lookup flow.

`indexes/page-reference-index.md`:

- Map each topic to its summary file and source page range.
- Use status labels such as `Placeholder`, `Mapped`, `Draft`, `Needs source review`, and `Verified`.
- Include page references for incomplete summaries so rules lookup can cite where to verify.

`indexes/manifest.yaml`:

- Give every summary a stable ID such as `core.task-checks`, `combat.damage`, or `vehicles.classic-conversion`.
- Record title, subsystem, summary path, source page array or range, related IDs, and status.
- Keep IDs stable after creation; rename display titles instead of changing IDs unless there is a migration note.
- Ensure related IDs match existing manifest entries.

### 5. GM-Mode Integration

GM docs should point to the rules system at the moment a scene triggers a procedure:

- `gm/scene-loop.md`: when failure matters, read `indexes/task-router.md`, then the matching core or subsystem summary before calling for a roll.
- `gm/roll-policy.md`: use summaries to choose the skill/procedure and to state success, failure, and stakes; do not ask for rolls from memory when a summary exists.
- `gm/session-procedure.md`: before a session, check whether likely mission situations have verified or draft summaries; during close-out, record unresolved rules gaps as project tasks only if the user asks for maintenance.
- `gm/mission-template.md`: link mission obstacles to likely rule summaries, such as social checks, infiltration, injuries, equipment, repair, contracts, or tactical encounter handoff.
- `gm/encounter-template.md`: for RPG-scale encounters, route to personal combat summaries; for BattleTech-scale encounters, route to `gm/switch-to-classic-battletech.md`.
- `gm/switch-to-classic-battletech.md`: remain the authority for leaving RPG mode when tactical positioning, heat, armor locations, range brackets, unit initiative, salvage, repairs, or campaign force state matter.

Scene trigger examples the router must eventually cover:

- uncertain action: core task checks and modifiers
- contest between characters: opposed checks
- social pressure or negotiation: relevant skill summary plus core resolution
- personal fight: personal combat overview, initiative, attacks, wounds, damage, recovery
- injury after a scene: wounds and campaign injury/recovery summaries
- treatment and downtime: recovery and campaign downtime summaries
- gear choice or purchase: equipment overview, weapons, armor, personal gear
- vehicle or BattleMech action: vehicle overview, piloting, gunnery, MechWarrior skills
- tactical BattleMech combat: Classic BattleTech, MegaMek, or MekHQ handoff

### 6. Validation

Validation must prove a future GM agent can find and apply rules from repository files, not model memory.

Use scenario-based lookup tests:

1. Write a short scene trigger without naming the rule.
2. Start at `indexes/task-router.md`.
3. Follow only listed links to one or more summaries.
4. Confirm the summary has `When to Use`, `Do Not Use For`, procedure, related files, source references, and status.
5. Confirm the answer can be given as a paraphrased procedure or, if incomplete, as a page-reference pointer with uncertainty.
6. Confirm no copied source text is required to answer.
7. Confirm tactical cases route to Classic BattleTech, MegaMek, or MekHQ when appropriate.

Recommended validation prompts:

- "A character tries to bypass a security lock under time pressure."
- "Two characters both try to grab the same object first."
- "A character is hit in a personal-scale firefight and needs treatment."
- "The crew wants to buy armor and compare protection."
- "A MechWarrior needs pilot/gunnery notes for a tactical encounter."
- "A lance-scale fight begins and exact facing, heat, and armor locations matter."

Record validation gaps as follow-up issues or `docs/current/TASKS.md` entries. A summary is not `verified` until its page references have been checked against the legally owned source and its router path has passed a scenario lookup.

## Recommended Summary Order

Build toward playable GM mode in layers:

1. Core resolution: task checks, opposed checks, modifiers, margin of success.
2. GM routing bridge: roll policy, scene loop references, and task-router coverage for common scene triggers.
3. Personal combat minimum: initiative, attacks, damage, wounds, and recovery.
4. Equipment minimum: weapons, armor, and personal gear needed for early sessions.
5. Campaign consequences: injuries, treatment, downtime, contracts, advancement, contacts, and reputation.
6. Vehicle and MechWarrior bridge: piloting, gunnery, MechWarrior skills, and tactical conversion notes.
7. Character creation: lifepaths, attributes, traits, skills, and advancement after the table needs durable PC creation support.

Core resolution comes first because almost every live scene depends on it. Tactical BattleTech handoff criteria should be usable early, but detailed tactical rules should remain outside this rules-assistant workspace.

## Follow-Up Issue Plan

Create these issues gradually. Do not open all of them at once if source review changes scope.

| Order | Issue | Mode | Blocker | Expected output |
| --- | --- | --- | --- | --- |
| 1 | User task: place legally owned A Time of War PDF locally | User task | User must provide the file | PDF under `source/atow-pdf/`, still ignored |
| 2 | Extract A Time of War PDF into ignored page text | Source processing | Explicit user request and local PDF | `source/atow-text/page-####.txt`, extraction notes, raw source unstaged |
| 3 | Build chapter and section map | Source processing | Extracted page text | section map, page offset notes, candidate summary targets |
| 4 | Summarize core resolution rules | Source processing / project development | mapped core sections | verified or draft summaries plus router, page index, manifest updates |
| 5 | Validate core lookup flow | Project development | core summaries and router entries | scenario lookup report and fixes to routing gaps |
| 6 | Summarize personal combat and recovery minimum | Source processing / project development | mapped combat sections | paraphrased summaries for initiative, attacks, damage, wounds, recovery |
| 7 | Add equipment minimum summaries | Source processing / project development | mapped equipment sections | weapons, armor, and personal gear summaries with source references |
| 8 | Add vehicles and tactical BattleTech handoff bridge | Project development / source processing | mapped vehicle sections | MechWarrior skill summaries and stronger handoff procedure |
| 9 | Build first playable GM mode | Project development | core routing and minimum play summaries | session procedure, campaign-state structure, and validated live-play router path |

Next recommended issue:

- Create the extraction issue only after the user explicitly asks for source processing and confirms the legally owned PDF is present under `source/atow-pdf/`.

Until then, source processing remains blocked.

## Acceptance Criteria For This Plan

- The protected source boundary is explicit.
- Extraction, mapping, summarization, indexing, GM integration, and validation are separate stages.
- Each summary requires `When to Use` and `Do Not Use For` routing cues.
- The required indexes and manifest have defined responsibilities.
- GM-mode docs have clear rule lookup and tactical handoff integration points.
- Future work is broken into issue-sized tasks.
- Source processing remains blocked until explicit user request and local PDF presence.
