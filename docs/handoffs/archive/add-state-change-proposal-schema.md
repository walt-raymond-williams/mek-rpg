# Agent Handoff

## Issue

- GitHub issue: `#78`
- Roadmap entry: `docs/current/ROADMAP.md` > Ruling safety and deterministic mechanics maturation
- Mode: Project development
- Priority: P1
- Status: archived after implementation

## Outcome

Issue `#78` added `docs/current/STATE_CHANGE_PROPOSAL_SCHEMA.md`.

The schema defines approval-gated `proposed_state_changes` objects for deterministic helpers and distinguishes:

- MEK-RPG-owned RPG memory proposals
- workflow notes such as rules gaps or playtest friction
- MekHQ pending intents that are not hard-ledger facts until manual application, save, and import confirmation

It includes proposal status, target file/section, evidence labels, authority source, approval/application step, MekHQ boundary fields, no-hidden-mutation proof, and examples for skill-check consequence, opposed-check consequence, injury/damage consequence, equipment loss, and pending MekHQ ledger intent.

## Verification

Run during close-out:

```powershell
./scripts/test-all.ps1
git diff --check
git status --short --ignored source\atow-pdf source\atow-text
```
