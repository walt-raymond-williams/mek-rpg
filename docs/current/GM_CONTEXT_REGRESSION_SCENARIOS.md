# GM Context Regression Scenarios

Status: issue `#34` validation baseline.

Purpose: preserve repeatable checks for GM context loading, continuity, rules routing, state ownership, and tool boundaries. These scenarios validate whether a future helper or GM assistant uses the context packet correctly without relying on chat memory, raw source text, or stale summaries.

## How To Use

Run scripted coverage:

```powershell
./scripts/test-gm-context-regressions.ps1
```

Use the manual checks before changing play procedures, context-packet assembly, campaign save ownership, or rules-routing behavior. A manual scenario passes when the GM response follows the expected behavior and names uncertainty instead of smoothing it over.

## Scripted Scenarios

The scripted suite uses a disposable repository fixture and `scripts/build-gm-context-packet.ps1`. It does not process source PDFs, read ignored raw text, use real MekHQ saves, or mutate live campaign files.

| Scenario | Coverage | Expected Result |
| --- | --- | --- |
| `CTX-001` active campaign source selection | Active campaign load selects exactly one campaign save. | Packet resolves the active pointer to one `campaigns/<campaign-id>` folder and reports that selected id. |
| `CTX-002` recent plus durable memory inputs | Recent scene detail remains available without making old summaries authoritative. | Packet lists `current-state.md`, `session-log.md`, and `previous-sessions.md` in their separate sections. |
| `CTX-003` structured state precedence | Structured state overrides older narrative summary. | Packet authority notes state that structured campaign files override stale narrative summaries. |
| `CTX-004` rules routing boundary | Rules lookup starts from repository indexes and summaries. | Packet lists `indexes/task-router.md` and `indexes/page-reference-index.md`, and states that rules answers do not come from model memory or raw source text. |
| `CTX-005` missing or stale source warning | Missing standard campaign files are not silently ignored. | Packet reports a warning when a standard campaign file is missing. |
| `CTX-006` protected source boundary | Raw source paths stay out of packet inputs. | Packet names protected source boundaries and does not read ignored source material. |
| `CTX-007` no mutation behavior | Packet assembly is read-only. | Fixture file hashes are unchanged after packet generation. |

## Manual Scenarios

### `CTX-MAN-001`: Corrected Fact Beats Stale Memory

Setup:

- `previous-sessions.md` says an NPC promised payment.
- `relationships.md` or `npcs.md` later marks the promise as corrected, superseded, or false.

Prompt:

- "Resume the scene with that NPC. What does the GM know about the promise?"

Expected GM behavior:

- Use the structured owner file as the current fact.
- Mention the stale summary only as archived context if useful.
- Do not treat the old promise as active unless the user reasserts it.
- If uncertain, ask a narrow confirmation question before making the promise matter.

### `CTX-MAN-002`: Recent Scene Detail Without Summary Duplication

Setup:

- `session-log.md` contains a fresh conversation detail.
- `previous-sessions.md` contains older campaign history.

Prompt:

- "Continue from the last conversation."

Expected GM behavior:

- Start from `current-state.md` and `session-log.md`.
- Use `previous-sessions.md` only for relevant older context.
- Do not duplicate the recent scene into the completed-session archive until a session close checkpoint.

### `CTX-MAN-003`: Rules Lookup Starts At Router

Setup:

- The user asks for a rule procedure that should route through `indexes/task-router.md`.

Prompt:

- "How do we handle this roll or consequence?"

Expected GM behavior:

- Read `indexes/task-router.md` first.
- Use the routed committed summary before answering.
- If the summary is insufficient, cite where to inspect the owned source by page reference.
- Do not answer A Time of War rules from memory when a project summary exists.

### `CTX-MAN-004`: Tactical Handoff Trigger

Setup:

- A scene escalates into full tactical BattleMech combat.

Prompt:

- "Resolve the BattleMech fight."

Expected GM behavior:

- Identify that full tactical BattleMech combat should use Classic BattleTech, MegaMek, or MekHQ.
- Prepare or request the needed handoff details instead of inventing tactical results.
- Save the returned tactical outcome into the campaign files after the external resolution.

### `CTX-MAN-005`: MekHQ Hard Facts Stay Separate

Setup:

- RPG narration proposes a purchase, repair, injury, contract change, day advancement, or tactical outcome in a MekHQ-linked campaign.

Prompt:

- "Apply that to the campaign."

Expected GM behavior:

- Save RPG-side scene memory in normal campaign files.
- Create or update a pending item in `pending-mekhq-actions.md` for hard ledger changes.
- Do not treat the change as final funds, roster, repair, contract, scenario, damage, or date state until the user applies it in MekHQ and a saved import confirms it.

## MekHQ-Linked Scripted Scenarios

Run scripted MekHQ-linked coverage:

```powershell
./scripts/test-mekhq-context-packet.ps1
```

The scripted suite uses a disposable MekHQ-linked campaign folder with fixture `mekhq-bridge.md` metadata and a valid unresolved `pending-mekhq-actions.md` item. It does not use a real MekHQ save, raw MekHQ XML, protected A Time of War source text, or direct writeback.

| Scenario | Coverage | Expected Result |
| --- | --- | --- |
| `MEKHQ-CTX-001` bridge and pending inputs | Context includes latest bridge metadata and unresolved pending actions. | Packet reports `mekhq-bridge.md`, `pending-mekhq-actions.md`, and the unresolved pending item id. |
| `MEKHQ-CTX-002` pending intent labeling | Pending MekHQ actions are not confirmed facts. | Validator output labels unresolved items as manual-action checklists, and packet authority notes label pending items as intents. |
| `MEKHQ-CTX-003` stale memory avoidance | Structured campaign state takes precedence over stale narrative summaries. | Packet lists current state and older archives separately, with structured-state precedence visible. |
| `MEKHQ-CTX-004` rules and tactical route references | Rules routes are referenced without inventing rules, and tactical handoff sources are available. | Packet lists `indexes/task-router.md`, `gm/switch-to-classic-battletech.md`, and vehicle/tactical bridge overview. |
| `MEKHQ-CTX-005` protected source and no-writeback boundary | Context assembly avoids raw source, raw saves, direct MekHQ writeback, and invented rules. | Packet names protected-source/raw-save boundaries and states it does not interpret rules or apply MekHQ changes. |
| `MEKHQ-CTX-006` read-only behavior | Context assembly does not mutate campaign files. | Pending action fixture hash remains unchanged after packet generation. |

## Pass/Fail Recording

Record failures in one of these places:

- A focused GitHub issue when the scenario reveals a new tool or workflow bug.
- `docs/current/TASKS.md` when the next fix is small and already actionable.
- The active campaign's `playtest-notes.md` when the issue is campaign-local play friction.

Do not copy raw rulebook text, raw extracted text, purchased PDFs, or raw MekHQ save payloads into scenario records.
