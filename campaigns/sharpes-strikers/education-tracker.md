# Education Tracker Snapshot

Schema: `mek-rpg-mekhq-education-tracker/v1`
Generated: 2026-08-20T19:11:21+00:00

## Source

- Campaign: Sharpe's Strikers
- Campaign date: 3044-01-16
- Location: Daneshmand
- Snapshot id: `live-7fbbb5da-0bcd-46f1-8f61-846848c2f148-3044-01-16-2026-08-20T19:07:45.026825300Z`
- State revision: `live-7fbbb5da-0bcd-46f1-8f61-846848c2f148-3044-01-16-2026-08-20T19:07:45.026825300Z`
- Evidence: Confirmed from MekHQ live API for roster fields; school overlays below are MEK-RPG review fields until user-confirmed.
- Full candidate CSV: `campaigns/sharpes-strikers/education-tracker-candidates.csv`

## Current Counts

- Total MekHQ personnel records: 1493
- Tracked education/scholarship candidates: 388
- Current MekHQ students: 53
- Likely missed-graduation/job candidates: 1
- Background role review candidates: 47
- Dependent payroll/scholarship review candidates: 228
- Departed dependents kept for history: 59
- High priority rows: 54
- Medium priority rows: 275
- Low priority rows: 59

## Review Rules

- MekHQ-owned fields: name, id, status, rank, primary role, salary, assignment, employment, deployment, joined campaign, and recruitment date.
- MEK-RPG-owned overlay fields: school program, enrolled date, expected graduation date, actual graduation date, target job, and assignment action.
- Treat `Student` as currently enrolled.
- Treat `Recruit` rank without `Student` status as a high-priority missed-graduation/job-assignment review.
- Treat non-dependent `Background Character` records as possible civilians or specialists who need a deliberate job decision.
- Do not apply final job, payroll, rank, or assignment changes in MEK-RPG; queue them for MekHQ UI or guarded command support.

## High Priority Snapshot

| Priority | Tracker status | Name | MekHQ status | Rank | Primary role | Joined | Unit | Review note |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| high | enrolled_current | Rickhart Fairlie | Student | Recruit | Professional | 3025-01-01 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Tho Kieu | Student | Recruit | Professional | 3025-01-01 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Dennis Louca | Student | Recruit | Combat Prosthetics Fitter | 3025-04-04 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Chim Nguyen-Tan | Student | Recruit | Professional | 3027-08-13 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Maurice Ts'ai | Student | Recruit | Systems Consultant | 3028-11-01 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Iyanna Stoltz | Student | Recruit | Dependent | 3029-08-31 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Guedado Rang | Student | Recruit | Dependent | 3030-12-13 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Assunção Holle | Student | Recruit | Artist | 3032-06-01 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Estefany Castillo | Student | Recruit | Dependent | 3032-07-01 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Dawn Fumu | Student | Recruit | Dependent | 3033-04-23 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Durgadasa Szczepanski-Nitesha | Student | Recruit | Militia Leader | 3033-07-22 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Silvie Sakala | Student | Recruit | Dependent | 3034-05-05 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Marquart Beiro | Student | Recruit | Dependent | 3034-06-30 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Chui-Wai Wickenden | Student | Recruit | Dependent | 3034-09-10 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Donald Cardoza | Student | Recruit | Professional | 3034-12-27 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Oliver Haward | Student | Recruit | Astrographer | 3034-12-27 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Zakayo Catanzara | Student | Recruit | Cultist | 3034-12-27 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Dejan Harlos | Student | Recruit | Professional | 3035-03-01 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Fia Ortíz | Student | Recruit | Scandal Fixer | 3035-03-01 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Mary bin Fahd | Student | Recruit | Professional | 3035-03-01 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Robert Qu | Student | Recruit | Dependent | 3035-03-01 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Sudevi Ceralde | Student | Recruit | Lawyer | 3035-04-08 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Michael King-Stasinopoulos | Student | Recruit | Professional | 3035-09-14 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Achaius Beiro | Student | Recruit | Dependent | 3035-11-23 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Jacob Ru | Student | Recruit | Dependent | 3036-05-23 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Hideki Chabert | Student | Recruit | Dependent | 3036-07-01 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Owen Butler | Student | Recruit | Paramedic | 3036-10-16 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Geneva Hellevik | Student | Recruit | Dependent | 3037-03-27 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Sagramor Peres | Student | Recruit | Repair Bay Supervisor | 3037-05-29 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Manon Oberle | Student | Recruit | Tailor | 3037-07-03 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Aleixos Ciocchi | Student | Recruit | Miner | 3037-11-20 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Nichelle Polychronopoulos | Student | Recruit | Livestock Farmer | 3038-01-01 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Akustiy bin Harun | Student | Recruit | Astech Trainer | 3038-03-01 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Jeremy Rotheberg | Student | Recruit | Dependent | 3038-03-01 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Tayla De Jesús | Student | Recruit | Dependent | 3038-05-07 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Aongus Herrera | Student | Recruit | Dependent | 3038-05-18 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Mike Takahashi | Student | Recruit | Dependent | 3038-05-18 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Misano Takahashi | Student | Recruit | Tech/Communications | 3038-05-18 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Susana Mona | Student | Recruit | Media Manipulator | 3038-05-18 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Nereida Suzuki | Student | Recruit | Comms Operator | 3038-10-15 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Jahia Bettini | Student | Recruit | Dependent | 3039-01-03 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Sasa Panagiatopoulos | Student | Recruit | Subversive Poet | 3039-01-14 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Marie Locke | Student | Recruit | Professional | 3039-03-18 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Dwight Nienaber | Student | Recruit | Dependent | 3039-05-19 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Tekla Tawfiki | Student | Recruit | Penniless Noble | 3039-07-01 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Hu-lan King-Stasinopoulos | Student | Recruit | Dependent | 3039-08-12 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Chris Kawilarang | Student | Recruit | Dependent | 3039-10-28 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Alexander Gilzean | Student | Recruit | Noble Page | 3039-12-09 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Waldemar Vozick | Student | Recruit | Professional | 3039-12-30 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Keri Arikan | Student | Recruit | Dependent | 3040-04-27 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Huang-di Wang | Student | Recruit | Merchant | 3040-05-28 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Itzel Zelenohorskyj | Student | Recruit | Military Theorist | 3040-05-28 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | enrolled_current | Men Manzi | Student | Recruit | Mess Hall Manager | 3040-07-06 | Unknown | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | graduation_candidate | Hirokumi Takahashi | Active | Recruit | MekWarrior | 3026-08-21 | Unknown | Rank remains Recruit but status is no longer Student; review as a likely missed graduate or job-assignment candidate. |

## Next Review Pass

1. Filter the CSV to `tracking_status=enrolled_current`; confirm program, expected graduation, and whether the person is still in school.
2. Filter to `tracking_status=graduation_candidate`; assign each person a target job or mark them as intentionally unassigned.
3. Filter to `tracking_status=background_role_review`; decide whether each specialist should stay background, become active staff, or leave payroll.
4. Filter to `tracking_status=dependent_on_payroll_review`; mark scholarship status, school level, and whether the dependent should remain non-working.
5. Record confirmed MekHQ ledger changes in `pending-mekhq-actions.md` before applying them in MekHQ.
