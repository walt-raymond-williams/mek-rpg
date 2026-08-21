# Agent Handoff

## Issue

- GitHub issue: not created in MEK-RPG for this handoff.
- Roadmap entry: MekHQ live API gap follow-up from MEK-RPG play.
- Mode: cross-repository producer coordination.
- Priority: P1 / user-blocking.

## Goal

Give the MegaMek/MekHQ workspace agent enough context to investigate and implement, design, or ticket the missing school/education API surface needed by MEK-RPG.

The immediate user need is to manage Sharpe's Strikers personnel who were put on payroll and sent to school. MEK-RPG can identify people currently marked `Student`, people still ranked `Recruit`, dependents, and background characters, but the live API does not expose what school they are enrolled in, what they are studying, what skills/traits/options they have, how long remains before graduation, or what graduation should unlock for job assignment.

## Required Context

Read these first in this MEK-RPG repository:

- `docs/current/MEKHQ_PLAYTEST_API_GAP_REPORT.md`
  - Start with the top open finding: `2026-08-20 - Priority 1 education enrollment and graduation fields unavailable`.
- `campaigns/sharpes-strikers/education-tracker.md`
- `campaigns/sharpes-strikers/education-tracker-candidates.csv`
- `scripts/report-mekhq-education-tracker.py`
- `docs/current/MEKHQ_OPEN_CONNECTION_STARTUP_DECISION_TREE.md`
- `docs/current/MEKHQ_LIVE_API_QUERY_VIEW_CONTRACT.md`
- `docs/current/RICH_CHARACTER_MEKHQ_API_NEEDS.md`

Useful current evidence from the MEK-RPG live capture:

- Campaign: `Sharpe's Strikers`
- Campaign date/location: `3044-01-16`, `Daneshmand`
- Current live personnel records: `1493`
- Current MekHQ `Student` status personnel: `53`
- Current high-priority likely missed graduate/job-assignment candidate: `Hirokumi Takahashi`, `Active`, `Recruit`, `MekWarrior`
- Education tracker rows generated from available fields: `388`
- MEK-RPG education tracker commit: `d6c6f50`
- P1 gap-report commit: `b16edb0`

## Producer-Side Investigation Questions

Answer these in the MegaMek/MekHQ workspace:

- Where does MekHQ store education/school/training state for personnel?
- Does MekHQ distinguish school enrollment, training, academy, education, XP/skill advancement, and manual personnel status changes internally?
- Does the current local control API have any hidden or partial source object that already knows:
  - school or academy name
  - program/track/course name
  - enrollment date
  - expected graduation date
  - remaining time to graduation
  - graduation date/history
  - qualification, credential, or role unlocked by graduation
  - current student progress
  - education-related XP, skill, trait, option, award, or log entries
  - post-graduation assignment/status/rank action needed
- Are skills, traits, options, advantages/disadvantages, special abilities, awards, and XP available in a whole-roster read, a person-detail read, or only through heavier per-person detail?
- Can education records be exposed without leaking private logs, hidden GM fields, or excessive UI-only text?
- Should this be a whole-roster endpoint, a person-detail expansion, or both?

## Expected API Shape

Preferred minimum viable read support:

```json
{
  "person_id": "uuid",
  "display_name": "Name",
  "status": "Student",
  "rank": "Recruit",
  "primary_role": "Dependent",
  "education_records": [
    {
      "education_record_id": "stable-id-or-null",
      "school_id": "stable-id-or-null",
      "school_name": "Capella War College",
      "program_id": "stable-id-or-null",
      "program_name": "MekWarrior Training",
      "education_status": "enrolled|graduated|dropped|paused|unknown",
      "enrolled_on": "3040-07-16",
      "expected_graduation_on": "3044-07-16",
      "days_remaining": 182,
      "graduated_on": null,
      "credential_or_qualification": "MekWarrior",
      "target_role": "MekWarrior",
      "requires_assignment_review": true,
      "source_owner": "MekHQ class/method",
      "warnings": []
    }
  ],
  "skill_summary": [
    {
      "skill_name": "Piloting/Mek",
      "rating_or_level": "value exposed by MekHQ",
      "source_owner": "MekHQ class/method"
    }
  ],
  "traits_or_options": [
    {
      "name": "Trait/option/ability name",
      "kind": "trait|option|award|edge|other",
      "source_owner": "MekHQ class/method"
    }
  ]
}
```

The exact field names can follow MegaMek/MekHQ conventions. The important requirement is that MEK-RPG can distinguish:

- currently enrolled students
- students by school/program
- students near graduation
- graduates who need job assignment review
- historical graduates that no longer have `Student` status
- skills/traits/options relevant to assigning a useful job

## Suggested Endpoint Options

Good first option:

- Extend `GET /campaign/state?sections=personnel` with bounded education summary fields for every person.
- Extend `GET /campaign/personnel/detail?personId=<uuid>` with richer education records, skills, traits/options, awards, and XP/advancement details.

Alternative:

- Add `GET /campaign/personnel/education` as a focused whole-roster education tracker endpoint.
- Keep sensitive logs out by default, consistent with the existing `personnel/detail` medical/patient log opt-in pattern.

## Expected Output

The MegaMek/MekHQ agent should produce one or more of:

- Implementation that exposes education/school fields through the local control API.
- A design document or producer ticket if implementation is not yet safe.
- Fixture updates showing representative students, graduates, dependents, background characters, and personnel with skills/traits/options.
- Tests for:
  - current students expose school/program/time remaining
  - historical graduates remain discoverable after `Student` status clears
  - skill/trait/option summaries are exposed without sensitive logs by default
  - absent education data is explicit `Unknown`/empty, not silently omitted
  - whole-roster reads stay bounded enough for large campaigns

## Constraints

- Do not parse or edit active MekHQ saves as the API solution.
- Do not make MEK-RPG infer education facts from status/rank alone when MekHQ has source data.
- Preserve privacy boundaries for logs, medical details, patient information, hidden GM data, and long raw personnel history.
- Prefer method-backed/source-owner fields when possible, following the current live API export style.
- Keep whole-roster reads usable for campaigns with 1000+ personnel.
- If full skills/traits are too heavy for whole-roster state, expose a compact summary there and a richer bounded detail view per person.

## Acceptance Criteria

- MEK-RPG can ask "who is in school, where, studying what, and how long until graduation?" from the live API.
- MEK-RPG can ask "who graduated and now needs assignment review?" without relying on stale chat memory or active-save parsing.
- MEK-RPG can see enough skills/traits/options to choose plausible jobs or know that a person needs manual review.
- The API explicitly represents unknown/not-applicable education state.
- The new fields are covered by producer-side tests and sanitized fixtures.

## Open Questions

- Is `Student` status always tied to a school/training record, or can it be manually assigned without structured education state?
- Does MekHQ have multiple concurrent or historical education records per person?
- Does graduation automatically change status/rank/role, or does it only create a prompt/report/manual action?
- What object owns "time remaining" and "expected graduation" in MekHQ?
- Are traits/options stored in MekHQ for every person, or only in detailed personnel records?

## Copy/Paste Prompt For MegaMek Workspace Agent

```text
Please work in the MegaMek/MekHQ workspace on the P1 education/school API gap discovered by MEK-RPG.

Start by reading this MEK-RPG handoff document:
C:\Users\waltr\Documents\mek-rpg\docs\handoffs\active\megamek-education-api-gap-handoff.md

Then read the top open finding in:
C:\Users\waltr\Documents\mek-rpg\docs\current\MEKHQ_PLAYTEST_API_GAP_REPORT.md

Focus on the new entry titled:
2026-08-20 - Priority 1 education enrollment and graduation fields unavailable

The user need is immediate roster management for Sharpe's Strikers. MEK-RPG can identify personnel marked Student/Recruit/Dependent/Background Character, but the live API does not expose what school they are enrolled in, what they are studying, how much time remains, whether they graduated, or enough skills/traits/options to assign them to useful jobs.

Please investigate MekHQ's internal education/school/training/personnel data model and either implement or design the local-control API support needed for:
- current school/enrollment status
- school name
- program/course/track
- enrolled date
- expected graduation date
- days/time remaining
- actual graduation date/history
- credential or target role from graduation
- whether the person needs assignment review
- relevant skills
- traits/options/abilities/awards/XP summary useful for job assignment

Prefer extending whole-roster personnel state with compact education summaries and extending person-detail with richer education plus skills/traits/options. Keep sensitive logs and medical/patient details out by default. Use explicit Unknown/not-applicable fields rather than silent omission.

Deliver implementation, tests, and fixture updates if feasible. If implementation is not safe yet, produce a producer-side design/ticket with exact classes/methods found, blockers, and the recommended endpoint shape.
```
