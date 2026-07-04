# Player Characters

## Major Sharpe "Shooter" Williams

### Link And Evidence

- MEK-RPG slug: sharpe-shooter-williams
- MekHQ person id: `c9548e24-d495-444d-aaa7-467449fdc290`
- Link status: Confirmed from MekHQ live personnel detail endpoint and current live state endpoint.
- Last imported: 2026-07-02 from `mekhq-live-api-capture/mekhq-personnel-detail.json`.
- Import evidence: `GET /campaign/personnel/detail?personId=c9548e24-d495-444d-aaa7-467449fdc290` for skills/background; `GET /campaign/state` for current roster status.
- Source summary or checkpoint: Sharpe's Strikers, 3027-11-22, Wallacia.

### MekHQ-Owned Roster Facts

- Display name: Sharpe "Shooter" Williams.
- Full title: Major Sharpe "Shooter" Williams.
- Callsign: Shooter.
- Gender: Male.
- Age: 26.
- Birthday source value: `3027-01-03`; treat as MekHQ birthday/date display, not a confirmed birth year, because age is separately reported as 26.
- Recruitment date: 3025-01-01.
- Role/rank: Major, MekWarrior, no secondary role.
- Status: Active, Free.
- Assignment: Catapult CPLT-C1, Alpha Company, Alpha Battalion.
- Deployment state: not deployed in the 3027-11-22 live state.
- Condition: fatigue 1, hits 0, no injuries in the non-medical injury summary.
- XP: 13 current, 66 total earned.
- Salary: 11,184 C-bills.
- Total earnings: 141,873 C-bills.
- Awards: 8 total; MekHQ reports medals, ribbons, and no miscellaneous awards. Individual award details are not exposed by the V1 personnel detail summary.
- Hard-ledger notes: the detail endpoint is read-only and does not expose a campaign-wide dirty/unsaved flag.

### MekHQ Skills

MekHQ skill values below are live roster facts, not yet converted into an A Time of War character sheet.

| Skill | Subtype | Level | Final value | XP progress | Notes |
| --- | --- | ---: | ---: | ---: | --- |
| Gunnery/Mek | COMBAT_GUNNERY | 5 | 3 | 0 | Tactical Mek skill. |
| Piloting/Mek | COMBAT_PILOTING | 5 | 3 | 0 | Tactical Mek skill. |
| Leadership | UTILITY_COMMAND | 1 | 6 | 0 | Command utility skill. |
| Strategy | UTILITY_COMMAND | 2 | 7 | 0 | Command utility skill. |
| Tactics/Any | UTILITY_COMMAND | 1 | 8 | 0 | Command utility skill. |
| Science/Military | ROLEPLAY_SCIENCE | 0 | 9 | 0 | MekHQ marks roleplay-only; command-school-related knowledge skill. |
| Small Arms | COMBAT_GUNNERY | 2 | 6 | 0 | Personal combat-adjacent MekHQ skill. |
| Acrobatics | ROLEPLAY_GENERAL | 2 | 5 | 0 | MekHQ marks roleplay-only. |
| Art/Sculpture | ROLEPLAY_ART | 1 | 8 | 0 | MekHQ marks roleplay-only. |
| Cryptography | ROLEPLAY_GENERAL | 1 | 8 | 0 | MekHQ marks roleplay-only. |

### MekHQ Options And Edge Automation

- Active options: 23, all exposed as Edge-related automation toggles.
- Performance log confirms Edge point gains:
  - 3025-03-11: gained Edge point, total 1.
  - 3025-06-09: gained Edge point, total 2.
  - 3026-02-01: gained Edge point, total 3.
- Common enabled categories include Edge use for Mek head hits, pilot KOs, explosions, TACs, commander contract negotiation failure, escape failure, refit failure, salvage accidents, training failure, acquisition failure, and several aero-specific checks.
- MEK-RPG handling note: treat these as MekHQ automation preferences unless an A Time of War overlay explicitly maps them to table-facing Edge.

### Service And Background From MekHQ Logs

- 3025-01-01: joined Sharpe's Strikers.
- 3025-01-01: assigned to Catapult CPLT-C1 and added to Able Lance.
- 3025-02-01: removed from Catapult CPLT-C1 and Able Lance.
- 3025-02-11: service log contains both `Promoted to Star Lord` and `Demoted to Captain`; preserve this as MekHQ log oddity or prior-record artifact until clarified.
- 3025-03-09: assigned to Catapult CPLT-C1 and added to Able Lance.
- 3025-12-26: removed from Alpha Lance.
- 3026-01-01: added to Alpha Lance.
- 3027-03-13: promoted to Major.
- 3027-03-13: enrolled at Sharpe's Strikers studying an in-house Command Officer Graduate course.
- 3027-05-22: graduated from the in-house Command Officer Graduate course.
- 3027-05-22: improved Leadership to 1, Strategy to 2, and Science/Military to 0.
- 3027-05-23: returned from education or training.
- 3027-08-07: assigned to Catapult CPLT-C1 and added to Reserve.
- 3027-08-08: reassigned from Reserve to Alpha Lance.
- Biography field: blank in MekHQ.

### Scenario Participation

- 3025-03-11: Picket Line Breakthrough, Talitha Recon Raid.
- 3025-04-12: Decoy Engagement, Talitha Recon Raid.
- 3025-04-19: Official Challenge, Talitha Recon Raid.
- 3025-05-13: Facility Assault, Talitha Recon Raid.
- 3025-05-20: Frontline Disruption, Talitha Recon Raid.
- 3026-03-20: DropShip Raid, Altorra Garrison Duty.
- 3026-03-25: Critical Convoy Escort, Altorra Garrison Duty.
- 3027-08-08: MekBase - Allied - Evacuate, Butzfleth Pirate Hunting.
- Current assignment: Catapult CPLT-C1, Alpha Company, Alpha Battalion, Wallacia, 3027-11-22. Not currently deployed.

### Awards From Recent Log Entries

- 3025-03-11: Combat Action.
- 3025-04-01: Marksmanship.
- 3025-06-09: Covert Ops.
- 3025-06-09: Galactic Service Deployment.
- 3025-06-09: Expeditionary.
- 3025-06-09: Third Succession War Campaign.
- 3026-02-01: Drill Instructor.

### MEK-RPG A Time of War Overlay

- Player: Walter.
- Concept: mercenary commander and MekWarrior, rough company-captain voice.
- Attributes: not yet converted from source-reviewed A Time of War creation rules.
- Traits: not yet converted.
- Skills: use MekHQ skills above as live roster facts until an A Time of War overlay is built.
- Edge: MekHQ performance logs indicate Edge total reached 3 by 3026-02-01; table-facing A Time of War Edge remains an overlay question.
- XP: MekHQ reports 13 current / 66 earned.
- Armor and important gear: not recorded.
- Personal condition overlay: current MekHQ state shows fatigue 0, hits 0, Active, assigned to Catapult CPLT-C1, and deployed.
- Open sheet questions:
  - Confirm whether Sharpe's A Time of War sheet should be converted directly from MekHQ skills or built as a separate RPG overlay.
  - Confirm how to handle the `Promoted to Star Lord` / `Demoted to Captain` log oddity in table canon.
  - Confirm whether the blank MekHQ biography should be filled with table canon or left as a MekHQ-only blank.

### RPG Memory

- Goals: keep Sharpe's Strikers alive, build reputation, grow the company, and eventually stop depending on contracted transport by buying a company DropShip.
- Motives: contract pay, unit survival, reputation, salvage, and command responsibility.
- Relationships: commander of Alpha Lance and Sharpe's Strikers; specific interpersonal bonds need table development.
- Secrets or uncertainty: exact pre-campaign background remains open; MekHQ biography is blank.
- Promises, debts, or threats: House command rights under the Capellan garrison contract can force hard operational choices.
- Last seen: at Wallacia on 3027-11-22, assigned to the Catapult after the first Wallacia Objective Raid victory and before the next pending alert.
- Scene notes: after-command-school party held in company space. Sharpe named the tech line, recovery crews, pilots, and the former Mule crew as people who carried the company while command learned hard lessons. Floyd toasted him as "slightly educated, still dangerous," and Tarasios planned to hang the crooked certificate somewhere embarrassing.

### Import Refresh Notes

- Refresh policy: refresh with `scripts/fetch-mekhq-live-api.ps1 -PersonnelDetailPersonId "c9548e24-d495-444d-aaa7-467449fdc290"` before mechanical use or after MekHQ advancement.
- Discrepancies: stale endpoint error files may remain in the capture directory from older runs; trust the current manifest for current endpoint success.
- Sensitive data: medical and patient logs were not included. The endpoint reports 8 available medical log entries and 0 patient log entries, but those require explicit opt-in and should only be fetched when a scene needs them.
- Pending MekHQ actions: none created by this import.

## Character Template

### TBD

#### Identity And Concept

- Player:
- Concept:
- Campaign role:
- Affiliation or home:
- Creation method:
- Creation status:

#### Attributes

- Strength:
- Body:
- Reflexes:
- Dexterity:
- Intelligence:
- Willpower:
- Charisma:
- Edge:
- XP stored toward attributes:

#### Traits

- Active traits:
- Incomplete or stored-XP traits:
- Trait descriptors:
- Trait page references:
- Opposed-trait or cleanup notes:

#### Skills

- Active skills and subskills:
- Specialties:
- Linked attributes / TN / complexity notes:
- XP stored toward skills:
- Skill page references:

#### Combat And Readiness

- Current location:
- Current condition:
- Fatigue / stun / bleeding / unconscious:
- Movement or combat data:
- Armor and important gear:
- Ready weapons:

#### Inventory And Assets

- Important carried gear:
- Assets controlled:
- Vehicle or unit links:

#### Biography And Campaign Hooks

- Goals:
- Relationships:
- Debts, promises, enemies, or obligations:
- Background hooks:

#### Open Questions

- Open sheet questions:

## MekHQ-Linked PC Template

Use this only for MekHQ-linked campaigns. Follow `docs/current/MEKHQ_PERSONNEL_SHEET_WORKFLOW.md`.

### TBD

#### Link And Evidence

- MEK-RPG slug:
- MekHQ person id:
- Link status:
- Last imported:
- Import evidence:
- Source summary or checkpoint:

#### MekHQ-Owned Roster Facts

- Display name:
- Role/rank:
- Faction:
- Assignment:
- Availability:
- Injury/fatigue ledger flags:
- Commander or command flag:
- Hard-ledger notes:

#### MEK-RPG A Time of War Overlay

- Player:
- Concept:
- Attributes:
- Traits:
- Skills:
- Edge:
- XP:
- Armor and important gear:
- Personal condition overlay:
- Open sheet questions:

#### RPG Memory

- Goals:
- Motives:
- Relationships:
- Secrets or uncertainty:
- Promises, debts, or threats:
- Last seen:
- Scene notes:

#### Import Refresh Notes

- Refresh policy:
- Discrepancies:
- Pending MekHQ actions:
