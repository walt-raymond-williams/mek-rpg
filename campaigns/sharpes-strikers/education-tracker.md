# Education Tracker Snapshot

Schema: `mek-rpg-mekhq-education-tracker/v2`
Generated: 2026-08-21T03:00:41+00:00

## Source

- Campaign: Sharpe's Strikers
- Campaign date: 3044-01-19
- Location: Daneshmand
- Snapshot id: `live-7fbbb5da-0bcd-46f1-8f61-846848c2f148-3044-01-19-2026-08-21T02:58:52.356221700Z`
- State revision: `live-7fbbb5da-0bcd-46f1-8f61-846848c2f148-3044-01-19-2026-08-21T02:58:52.356221700Z`
- Evidence: Confirmed from MekHQ live API for roster, compact education, compact skills, and compact traits/options.
- Full candidate CSV: `campaigns/sharpes-strikers/education-tracker-candidates.csv`

## Current Counts

- Total MekHQ personnel records: 1493
- Tracked education/scholarship candidates: 389
- Current MekHQ students: 53
- Likely missed-graduation/job candidates: 2
- Background role review candidates: 47
- Dependent payroll/scholarship review candidates: 228
- Departed dependents kept for history: 59
- High priority rows: 83
- Medium priority rows: 254
- Low priority rows: 52
- High-priority warrior scout rows: 63
- Rows requiring MekHQ assignment review: 2

## Current Schools

- Institute of Remshield: 6
- Preparatory School of Remshield: 3
- Combined Arms College of Remshield: 2
- Remshield Institute of Advanced Studies: 2
- Combat College of Remshield: 1
- Combined Arms University of Remshield: 1
- Remshield Combat Polytechnic of Advanced Technology: 1
- Combat Academy of Remshield: 1
- Remshield Academy of Science: 1
- Remshield Institute of Technology: 1
- Remshield Military Polytechnic of Advanced Technology: 1

## Current Programs

- Flight Academy: 11
- MekWarrior Academy: 9
- Advanced War Fighting Academy: 8
- Private Education: 8
- High School Education: 4
- General Education: 4
- Daycare: 3
- Advanced AeroSpace Technologies: 2
- MekTech Apprenticeship: 1
- Black Naval Academy: 1
- Advanced BattleMek Technologies: 1

## Review Rules

- MekHQ-owned fields: name, id, status, rank, role, salary, assignment, education status, school, program, expected graduation, days remaining, compact skills, and compact traits/options.
- MEK-RPG-owned overlay fields: target job and assignment action.
- Treat `Student` as currently enrolled.
- Treat `requires_assignment_review=true` as a high-priority job-assignment review.
- Treat `Recruit` rank without `Student` status as a high-priority missed-graduation/job-assignment review.
- Treat non-dependent `Background Character` records as possible civilians or specialists who need a deliberate job decision.
- Do not apply final job, payroll, rank, or assignment changes in MEK-RPG; queue them for MekHQ UI or guarded command support.

## High Priority Snapshot

| Priority | Scout | Tracker status | Name | Role | School/program | ETA | Candidate signals | Review note |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| high | high | enrolled_current | Rickhart Fairlie | Professional | Combat College of Remshield / Advanced War Fighting Academy | 600 days | martial education program: Advanced War Fighting Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Tho Kieu | Professional | Combined Arms University of Remshield / Advanced War Fighting Academy | 600 days | martial education program: Advanced War Fighting Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Dennis Louca | Combat Prosthetics Fitter | Remshield Combat Polytechnic of Advanced Technology / Flight Academy | 600 days | martial education program: Flight Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Chim Nguyen-Tan | Professional | Institute of Remshield / Advanced AeroSpace Technologies | 600 days | martial education program: Advanced AeroSpace Technologies | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Maurice Ts'ai | Systems Consultant | Combined Arms College of Remshield / Advanced War Fighting Academy | 600 days | martial education program: Advanced War Fighting Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | low | enrolled_current | Iyanna Stoltz | Dependent | Preparatory School of Remshield / High School Education | 11 days | no warrior-candidate signal in compact summaries | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | low | enrolled_current | Guedado Rang | Dependent | Institute of Remshield / Private Education | 10 days | no warrior-candidate signal in compact summaries | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Assunção Holle | Artist | Combat Academy of Remshield / Flight Academy | 600 days | martial education program: Flight Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | low | enrolled_current | Estefany Castillo | Dependent | Remshield Academy of Science / High School Education | 11 days | no warrior-candidate signal in compact summaries | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | low | enrolled_current | Dawn Fumu | Dependent | Remshield Institute of Technology / High School Education | 11 days | no warrior-candidate signal in compact summaries | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Durgadasa Szczepanski-Nitesha | Militia Leader | Remshield Military Polytechnic of Advanced Technology / MekWarrior Academy | 600 days | combat/aerospace skills: Leadership L1/FV7; martial education program: MekWarrior Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Silvie Sakala | Dependent | Military University of Remshield / Flight Academy | 600 days | martial education program: Flight Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | low | enrolled_current | Marquart Beiro | Dependent | Remshield Academy of Advanced Studies / Private Education | 10 days | no warrior-candidate signal in compact summaries | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | low | enrolled_current | Chui-Wai Wickenden | Dependent | Institute of Remshield / MekTech Apprenticeship | 11 days | no warrior-candidate signal in compact summaries | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | low | enrolled_current | Donald Cardoza | Professional | Remshield Institute of Advanced Studies / General Education | 150 days | no warrior-candidate signal in compact summaries | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Oliver Haward | Astrographer | Advanced Warfighting Polytechnic of Remshield / Black Naval Academy | 600 days | combat/aerospace skills: Strategy L0/FV9; martial education program: Black Naval Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Zakayo Catanzara | Cultist | Remshield War Polytechnic of Technology / MekWarrior Academy | 600 days | martial education program: MekWarrior Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Dejan Harlos | Professional | Remshield Combined Forces School of Technology / Flight Academy | 600 days | martial education program: Flight Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Fia Ortíz | Scandal Fixer | War School of Remshield / Advanced War Fighting Academy | 600 days | martial education program: Advanced War Fighting Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Mary bin Fahd | Professional | Remshield Combined Arms Polytechnic of Advanced Technology / Flight Academy | 600 days | combat/aerospace skills: Strategy L1/FV8; Tactics/Any L1/FV8; martial education program: Flight Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Robert Qu | Dependent | College of Remshield / General Education | 150 days | combat/aerospace skills: Gunnery/Mek L2/FV5; Piloting/Mek L2/FV5 | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Sudevi Ceralde | Lawyer | Remshield Advanced Warfighting Academy of Higher Learning / Flight Academy | 600 days | martial education program: Flight Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Michael King-Stasinopoulos | Professional | Remshield War University of Advanced Science / MekWarrior Academy | 600 days | martial education program: MekWarrior Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | low | enrolled_current | Achaius Beiro | Dependent | Preparatory School of Remshield / Private Education | 10 days | no warrior-candidate signal in compact summaries | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | low | enrolled_current | Jacob Ru | Dependent | Preparatory School of Remshield / Private Education | 10 days | no warrior-candidate signal in compact summaries | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | low | enrolled_current | Hideki Chabert | Dependent | Academy of Remshield / High School Education | 11 days | no warrior-candidate signal in compact summaries | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Owen Butler | Paramedic | Remshield Combined Arms School of Technology / MekWarrior Academy | 600 days | combat/aerospace skills: Piloting/Ground Vehicle L3/FV4; martial education program: MekWarrior Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Geneva Hellevik | Dependent | Combined Arms School of Remshield / Advanced War Fighting Academy | 600 days | combat/aerospace skills: Tactics/Any L0/FV8; martial education program: Advanced War Fighting Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Sagramor Peres | Repair Bay Supervisor | Remshield Advanced Warfighting Institute of Higher Learning / Flight Academy | 600 days | combat/aerospace skills: Leadership L1/FV6; martial education program: Flight Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Manon Oberle | Tailor | School of Remshield / Advanced AeroSpace Technologies | 600 days | martial education program: Advanced AeroSpace Technologies | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Aleixos Ciocchi | Miner | Combined Arms College of Remshield / MekWarrior Academy | 600 days | martial education program: MekWarrior Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | low | enrolled_current | Nichelle Polychronopoulos | Livestock Farmer | Remshield College of Higher Learning / General Education | 150 days | no warrior-candidate signal in compact summaries | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Akustiy bin Harun | Astech Trainer | Remshield Institute of Advanced Studies / Advanced BattleMek Technologies | 600 days | combat/aerospace skills: Strategy L0/FV9; Tech/Mek L3/FV6 | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | low | enrolled_current | Jeremy Rotheberg | Dependent | Capricorn III Institute of Advanced Science / Private Education | 10 days | no warrior-candidate signal in compact summaries | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | low | enrolled_current | Tayla De Jesús | Dependent | Remshield Institute of Science / Daycare | 10 days | no warrior-candidate signal in compact summaries | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Aongus Herrera | Dependent | Remshield Advanced Warfighting College of Advanced Science / Flight Academy | 600 days | notable traits/options: Toughness (ATOW); martial education program: Flight Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | low | enrolled_current | Mike Takahashi | Dependent | Institute of Remshield / Private Education | 10 days | no warrior-candidate signal in compact summaries | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Misano Takahashi | Tech/Communications | War Institute of Remshield / Flight Academy | 600 days | martial education program: Flight Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Susana Mona | Media Manipulator | Remshield War College of Advanced Science / Flight Academy | 600 days | martial education program: Flight Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Nereida Suzuki | Comms Operator | Military Polytechnic of Remshield / MekWarrior Academy | 600 days | martial education program: MekWarrior Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | low | enrolled_current | Jahia Bettini | Dependent | Remshield Institute of Higher Learning / Private Education | 10 days | no warrior-candidate signal in compact summaries | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Sasa Panagiatopoulos | Subversive Poet | Advanced Warfighting Institute of Remshield / Advanced War Fighting Academy | 600 days | martial education program: Advanced War Fighting Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | low | enrolled_current | Marie Locke | Professional | Remshield College of Advanced Science / General Education | 150 days | no warrior-candidate signal in compact summaries | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | low | enrolled_current | Dwight Nienaber | Dependent | Institute of Remshield / Private Education | 10 days | no warrior-candidate signal in compact summaries | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Tekla Tawfiki | Penniless Noble | Advanced Warfighting Academy of Remshield / Advanced War Fighting Academy | 600 days | combat/aerospace skills: Leadership L3/FV3; martial education program: Advanced War Fighting Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | low | enrolled_current | Hu-lan King-Stasinopoulos | Dependent | Institute of Remshield / Daycare | 10 days | no warrior-candidate signal in compact summaries | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Chris Kawilarang | Dependent | Military Academy of Remshield / Advanced War Fighting Academy | 600 days | martial education program: Advanced War Fighting Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Alexander Gilzean | Noble Page | Combat University of Remshield / MekWarrior Academy | 600 days | martial education program: MekWarrior Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Waldemar Vozick | Professional | Combined Forces University of Remshield / MekWarrior Academy | 600 days | martial education program: MekWarrior Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | low | enrolled_current | Keri Arikan | Dependent | Remshield School of Higher Learning / Daycare | 10 days | no warrior-candidate signal in compact summaries | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | low | enrolled_current | Huang-di Wang | Merchant | Remshield School of Advanced Science / Advanced Medicine | 600 days | no warrior-candidate signal in compact summaries | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Itzel Zelenohorskyj | Military Theorist | Advanced Warfighting Institute of Sarna / Flight Academy | 600 days | combat/aerospace skills: Leadership L1/FV7; Tactics/Any L4/FV5; martial education program: Flight Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | enrolled_current | Men Manzi | Mess Hall Manager | Remshield Combined Arms School of Advanced Technology / MekWarrior Academy | 600 days | martial education program: MekWarrior Academy | MekHQ currently marks this person as Student; keep on the school roster until status changes. |
| high | high | graduation_candidate | Hirokumi Takahashi | MekWarrior | Unknown / Unknown | Unknown days | combat/aerospace skills: Gunnery/Mek L2/FV4; Piloting/Mek L2/FV4; current role: MekWarrior; MekHQ marks education as requiring assignment review | MekHQ education summary marks this person for assignment review after training. |
| high | high | graduation_candidate | Gulzar Tapanelli | Aerospace Pilot | Unknown / Unknown | Unknown days | combat/aerospace skills: Gunnery/Aerospace L2/FV5; Piloting/Aerospace L2/FV5; current role: Aerospace Pilot; MekHQ marks education as requiring assignment review | MekHQ education summary marks this person for assignment review after training. |
| high | high | background_role_review | Badr Mika'il | Professional | Unknown / Unknown | Unknown days | combat/aerospace skills: Leadership L2/FV6 | Background character has a non-dependent role; review for whether this should become an assigned job. |
| high | high | background_role_review | Balbina Giacomelli | Personal Valet | Unknown / Unknown | Unknown days | combat/aerospace skills: Piloting/Ground Vehicle L3/FV5 | Background character has a non-dependent role; review for whether this should become an assigned job. |
| high | high | background_role_review | Vera Tung | Duelist | Unknown / Unknown | Unknown days | combat/aerospace skills: Leadership L3/FV5; Strategy L1/FV8 | Background character has a non-dependent role; review for whether this should become an assigned job. |
| high | high | background_role_review | Yoonus bin Bashshar | Morale Officer | Unknown / Unknown | Unknown days | combat/aerospace skills: Leadership L3/FV5 | Background character has a non-dependent role; review for whether this should become an assigned job. |
| high | high | background_role_review | Martín Tae-Miranda | Professional | Unknown / Unknown | Unknown days | combat/aerospace skills: Piloting/Naval L2/FV6 | Background character has a non-dependent role; review for whether this should become an assigned job. |
| high | high | background_role_review | Melodi Inonu | Astech Trainer | Unknown / Unknown | Unknown days | combat/aerospace skills: Tech/Mek L3/FV6 | Background character has a non-dependent role; review for whether this should become an assigned job. |
| high | high | background_role_review | Akbar Mehri | Civilian AeroTek | Unknown / Unknown | Unknown days | combat/aerospace skills: Tech/Aero L1/FV9 | Background character has a non-dependent role; review for whether this should become an assigned job. |
| high | high | background_role_review | Kuisma Demai | Professional | Unknown / Unknown | Unknown days | combat/aerospace skills: Leadership L0/FV8; Tactics/Any L0/FV9 | Background character has a non-dependent role; review for whether this should become an assigned job. |
| high | high | background_role_review | Sadao Ageda | Morale Officer | Unknown / Unknown | Unknown days | combat/aerospace skills: Leadership L3/FV5; Strategy L2/FV8 | Background character has a non-dependent role; review for whether this should become an assigned job. |
| high | high | background_role_review | Oleg Truong | Professional | Unknown / Unknown | Unknown days | notable traits/options: Ambidextrous (ATOW) | Background character has a non-dependent role; review for whether this should become an assigned job. |
| high | high | background_role_review | Madiecke Dekkers | Tactical Analyst | Unknown / Unknown | Unknown days | combat/aerospace skills: Tactics/Any L4/FV5 | Background character has a non-dependent role; review for whether this should become an assigned job. |
| high | high | background_role_review | Keith Shaffer | Painter | Unknown / Unknown | Unknown days | combat/aerospace skills: Gunnery/BattleArmor L4/FV4; Leadership L2/FV5 | Background character has a non-dependent role; review for whether this should become an assigned job. |
| high | high | background_role_review | Cincinel Bonelli | Security Advisor | Unknown / Unknown | Unknown days | combat/aerospace skills: Tactics/Any L3/FV6 | Background character has a non-dependent role; review for whether this should become an assigned job. |
| high | high | dependent_on_payroll_review | Karl Phan | Dependent | Unknown / Unknown | Unknown days | combat/aerospace skills: Gunnery/Spacecraft L1/FV7; dependent/background scout candidate | Dependent remains in the live personnel export; review scholarship/enrollment status manually. |
| high | high | dependent_on_payroll_review | Clarissa Jacopino | Dependent | Unknown / Unknown | Unknown days | notable traits/options: Melee Master (CamOps); dependent/background scout candidate | Dependent remains in the live personnel export; review scholarship/enrollment status manually. |
| high | high | dependent_on_payroll_review | Waseme Jabiri | Dependent | Unknown / Unknown | Unknown days | combat/aerospace skills: Tactics/Any L1/FV8; dependent/background scout candidate | Dependent remains in the live personnel export; review scholarship/enrollment status manually. |
| high | high | dependent_on_payroll_review | Josh Sree | Dependent | Unknown / Unknown | Unknown days | combat/aerospace skills: Gunnery/Aircraft L4/FV4; dependent/background scout candidate | Dependent remains in the live personnel export; review scholarship/enrollment status manually. |
| high | high | dependent_on_payroll_review | Chang-hyeok Christie | Dependent | Unknown / Unknown | Unknown days | combat/aerospace skills: Leadership L1/FV5; dependent/background scout candidate | Dependent remains in the live personnel export; review scholarship/enrollment status manually. |
| high | high | dependent_on_payroll_review | Tonito Padua | Dependent | Unknown / Unknown | Unknown days | combat/aerospace skills: Strategy L0/FV8; dependent/background scout candidate | Dependent remains in the live personnel export; review scholarship/enrollment status manually. |
| high | high | dependent_on_payroll_review | Heike Ettenhoffer | Dependent | Unknown / Unknown | Unknown days | combat/aerospace skills: Strategy L0/FV9; Tactics/Any L1/FV8; dependent/background scout candidate | Dependent remains in the live personnel export; review scholarship/enrollment status manually. |
| high | high | dependent_on_payroll_review | Dania Pervishina | Dependent | Unknown / Unknown | Unknown days | combat/aerospace skills: Piloting/Aircraft L3/FV5; dependent/background scout candidate | Dependent remains in the live personnel export; review scholarship/enrollment status manually. |
| high | high | departed_dependent | Bich Ballard | Dependent | Unknown / Unknown | Unknown days | notable traits/options: Natural Aptitude, Piloting (aToW) | Dependent is no longer with the command; keep historical only unless the table says they returned. |
| high | high | departed_dependent | Syung-Soon Jonkieson | Dependent | Unknown / Unknown | Unknown days | notable traits/options: Pain Resistance (MaxTech) | Dependent is no longer with the command; keep historical only unless the table says they returned. |
| high | high | departed_dependent | Gutka Phan | Dependent | Unknown / Unknown | Unknown days | notable traits/options: Natural Aptitude, Piloting (aToW) | Dependent is no longer with the command; keep historical only unless the table says they returned. |
| high | high | departed_dependent | Gemma Ruíz | Dependent | Unknown / Unknown | Unknown days | notable traits/options: Multi-Tasker (CamOps) | Dependent is no longer with the command; keep historical only unless the table says they returned. |

Showing 80 of 83 high-priority rows. Use the CSV for the full list.

## Next Review Pass

1. Filter the CSV to `tracking_status=enrolled_current`; review school, program, expected graduation, and days remaining.
2. Filter to `tracking_status=graduation_candidate`; assign each person a target job or mark them as intentionally unassigned.
3. Filter to `scout_priority=high`; review warrior skills, notable traits/options, and martial education programs.
4. Filter to `tracking_status=background_role_review` or `dependent_on_payroll_review`; decide whether each person should stay background, become active staff, or leave payroll.
5. Record confirmed MekHQ ledger changes in `pending-mekhq-actions.md` before applying them in MekHQ.
