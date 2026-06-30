# Profession Lookup Design

Status: issue `#130` design. Runtime lookup is not implemented.

Parent epic: `#127` Profession Capability System.

## Purpose

Define how a future deterministic helper should map MekHQ personnel records to MEK RPG profession profiles without creating authoritative character data outside MekHQ.

Profession lookup answers one narrow question: which MEK RPG profession overlay, if any, may be used for action permission and reveal-gated play support. It does not decide a character's true job, update campaign state, infer skills, or expose hidden scenario data.

## Authority Boundary

MekHQ remains authoritative for personnel identity, role, rank, assignment, status, fatigue, injury, availability, unit links, leadership flags, and campaign state.

MEK RPG owns only the lookup rules, profile aliases, action permission labels, warnings, and fail-closed behavior. A lookup result may say `matched_profile: mechwarrior`; it must not rewrite the MekHQ personnel record or claim the character has a full A Time of War sheet.

## Input Records

The preferred input is captured live API state from `GET /campaign/state`, usually through `scripts/fetch-mekhq-live-api.ps1` and later compact query views. State inputs must prove:

- `bridge_metadata.api_mode: local-read-only-live-context`
- `bridge_metadata.read_only: true`
- source file is captured JSON, not `.cpnx`, `.cpnx.gz`, XML, PDF, EPUB, or protected source text

Current fixture-backed personnel fields available for lookup:

| Input | Source path | Lookup use |
| --- | --- | --- |
| Personnel id | `$.personnel[].id` | Stable subject id in result records. |
| Display name | `$.personnel[].display_name` | Human-readable diagnostics only. |
| Primary role raw code | `$.personnel[].primary_role.raw_code` | First candidate for exact and alias matching. |
| Primary role label | `$.personnel[].primary_role.label` | Second candidate for exact and alias matching. |
| Rank label/raw code | `$.personnel[].rank` | Context and future tie-breaker only; never enough by itself to grant a profession. |
| Status | `$.personnel[].status` | Availability warning and fail-closed constraint. |
| Unit id | `$.personnel[].unit_id` | Assignment context; may support role confidence. |
| Assignments | `$.personnel[].assignments` | Availability and scenario/unit context. |
| Fatigue, hits, injury summary | `$.personnel[].fatigue`, `$.personnel[].hits`, `$.personnel[].injury_summary` | Readiness warnings; do not infer profession. |
| Leadership flags | `$.personnel[].leadership` | Command context only; do not infer administrator or officer profession by itself. |
| Market membership | `$.personnel[].market_membership` | Reject applicant records for active campaign action lookup unless a future action explicitly supports hiring interviews. |

Missing or unknown fields must be preserved as missing/unknown in result warnings. Do not silently treat missing role data as a generic profession match.

## Profile Alias Source

The lookup table should be generated from `rules/professions/*.md` YAML front matter:

- `profession_id`
- `display_name`
- `status`
- `aliases`
- `allowed_actions`

Profile aliases are deterministic match candidates, not proof that MekHQ uses those strings. Any alias beginning with `Needs API review:` is a note and must not be used as a match pattern.

Profiles with `status: not_implemented` may be returned for design/testing, but runtime action execution must still refuse to execute unsupported behavior until action permission, roll, reveal, and prompt tests exist.

## Normalization

Normalize both MekHQ input strings and profile aliases before matching:

1. Trim leading/trailing whitespace.
2. Convert to lowercase using invariant culture behavior.
3. Replace `_`, `-`, `/`, and repeated spaces with a single space.
4. Remove punctuation that is not semantically meaningful.
5. Preserve letters and numbers.
6. Keep the original raw string in diagnostics.

Examples:

| Raw value | Normalized value |
| --- | --- |
| `MechWarrior` | `mechwarrior` |
| `BattleMech Pilot` | `battlemech pilot` |
| `Scout/Recon` | `scout recon` |
| `S2` | `s2` |

Do not use fuzzy matching, semantic similarity, or LLM judgment for profession lookup. If a future alias is needed, add it to the relevant profile and cover it with a fixture.

## Match Order

For each current personnel record:

1. Validate live API read-only proof if a full state payload is supplied.
2. Reject unavailable subjects for action lookup when status, market membership, or assignment data shows the person is not current active personnel. Return `available_for_actions: false` with warnings.
3. Build candidate strings from `primary_role.raw_code`, then `primary_role.label`.
4. Add optional future candidate strings only after API evidence exists for stable job/title fields.
5. Exact-match normalized candidate strings against normalized `display_name` and non-review aliases.
6. If exactly one profile matches, return `match_type: exact_or_alias`.
7. If multiple profiles match the same candidate, return `match_type: ambiguous`, no active profession, and a warning naming the conflicting profile ids.
8. If no profile matches, return `match_type: unmapped`, no active profession, and only public/common action access.

Rank, leadership flags, assigned unit type, or skills may add explanation in future versions, but they must not override an absent or ambiguous primary-role match.

## Fail-Closed Behavior

Lookup must fail closed whenever role authority is missing or unclear:

| Condition | Result |
| --- | --- |
| No personnel record found | `blocked`; no profession overlay. |
| Missing `primary_role` | `unmapped`; public/common actions only. |
| Blank role strings | `unmapped`; public/common actions only. |
| Unknown role string | `unmapped`; public/common actions only; emit alias-review warning. |
| Multiple profile matches | `ambiguous`; public/common actions only. |
| Person is not current personnel | `blocked`; no campaign action ownership. |
| Person is inactive, KIA, missing, or otherwise unavailable | `blocked` or `unavailable`; no action ownership until a future action explicitly supports that state. |
| Profile is matched but action is not in `allowed_actions` | Profession may be reported, but action permission is denied. |

Public/common actions are limited to non-hidden, non-authoritative play support such as reading public briefing text, asking the GM for clarification, or contributing narrative color. They must not reveal hidden scenario fields, grant action ownership, or mutate MekHQ state.

## Output Contract Sketch

A future helper should emit JSON-first results shaped like this:

```json
{
  "schema_version": "mek-rpg-profession-lookup/v1",
  "status": "ok",
  "source": {
    "state_file": "mekhq-state.json",
    "profile_directory": "rules/professions"
  },
  "results": [
    {
      "person_id": "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee",
      "display_name": "Example Pilot",
      "available_for_actions": true,
      "candidate_strings": [
        {
          "source_path": "$.personnel[0].primary_role.raw_code",
          "raw": "MechWarrior",
          "normalized": "mechwarrior"
        }
      ],
      "match_type": "exact_or_alias",
      "profession_id": "mechwarrior",
      "allowed_actions": [
        "pre_mission_intel_check: supporting"
      ],
      "warnings": []
    }
  ],
  "warnings": [],
  "gaps": []
}
```

Use `status: partial` when some personnel can be classified but non-blocking fields are missing. Use `status: blocked` when read-only proof, profile metadata, or requested personnel identity is unavailable.

## API Gaps And Review Notes

Current MEK RPG fixtures support `primary_role.raw_code` and `primary_role.label`, but issue `#130` does not prove the complete MekHQ role vocabulary. The next implementation issue should treat these as API review items:

- Need a stable list or representative fixture coverage for MekHQ personnel role labels, including technicians, astechs, doctors, administrators, security, aerospace, DropShip crew, scouts, and intelligence/staff roles.
- Need clarity on whether MekHQ exposes secondary roles, staff assignments, command billets, or custom job titles separately from `primary_role`.
- Need scenario/personnel commitment fields in compact views before lookup is used for pre-battle action eligibility.
- Need applicant versus current-personnel handling documented for personnel market records.

If a producer change is needed, create a MEK RPG local change-request memo or issue. Do not edit the MegaMek/MekHQ producer repository from this project.

## Fixture Strategy

Future tests should use sanitized committed fixtures under `tests/fixtures/` or disposable fixture directories:

- Exact match: `primary_role.raw_code: "MechWarrior"` maps to `mechwarrior`.
- Alias match: `primary_role.label: "BattleMech Pilot"` maps to `mechwarrior`.
- Case/punctuation normalization: `Scout/Recon` maps only if a matching reviewed alias exists.
- Unknown job: `primary_role.label: "Canteen Poet"` returns `unmapped`.
- Missing job: no `primary_role` returns `unmapped`.
- Ambiguous alias: a disposable profile fixture duplicates an alias and returns `ambiguous`.
- Unavailable personnel: inactive/KIA/non-current records cannot own actions.
- Applicant record: personnel-market applicant cannot own campaign actions unless a future action explicitly allows applicant interviews.
- Review-note alias: `Needs API review: ...` is ignored as a match pattern.
- Raw input rejection: `.cpnx`, `.cpnx.gz`, XML, PDF, EPUB, `source/atow-pdf/`, and `source/atow-text/` paths are rejected.

Use the existing sanitized live API personnel shape from `tests/fixtures/mekhq-live-campaign-state.fixture.json` as the first positive source fixture.

## Relationship To Later Issues

- Issue `#131` should decide how action metadata consumes `profession_id`, `allowed_actions`, owning/supporting roles, and fail-closed lookup status.
- Issue `#132` should define how matched professions affect dice or reveal levels.
- Issue `#133` should apply this lookup to `pre_mission_intel_check`.
- Issue `#134` and `#135` must prove hidden data remains absent when lookup fails, is ambiguous, or grants only support permissions.
- Issue `#136` should ensure prompt assembly receives only lookup results and filtered facts, not raw hidden personnel or scenario payloads.
