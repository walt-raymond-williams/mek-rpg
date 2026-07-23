# MekHQ Character Rewrite Plan: The Jade Passage

Purpose: guide manual MekHQ edits so the transport staff created for Chapter One match the `Jade Passage` story.

Status: manual MekHQ edit guide. Do not edit raw `.cpnx`, `.cpnx.gz`, extracted XML, or save payloads directly.

Live baseline used: MekHQ live API snapshot for Sharpe's Strikers on 3032-12-04 at Capella.

## Before Editing

1. Save or checkpoint the campaign in MekHQ if you want a clean rollback point.
2. Keep this file open beside MekHQ.
3. In MekHQ, use personnel search or the Personnel tab to find each current generated character by name or UUID.
4. Rename the unit records first, then rename personnel, then paste biographies.
5. Keep the existing MekHQ UUIDs and assignments. The goal is to rewrite identity and history, not create duplicate people.

## Unit Renames

### Merchant JumpShip

- Current MekHQ unit: `Merchant JumpShip (2503)`
- MekHQ unit id: `36bf856a-40c3-45a4-9670-6d1c1619aeab`
- Rename to: `Jade Passage`
- Story role: Merchant-class JumpShip, last JumpShip of the Long Transit Association.
- Notes: This ship is the strategic spine of the Strikers' new transport arrangement. It has two docking collars in the story: one for the Strikers' Union and one for `Celestial Garden`.

### Monarch DropShip

- Current MekHQ unit: `Monarch (2759)`
- MekHQ unit id: `89b412ba-38fe-40ee-98d7-a4abdf7a7241`
- Rename to: `Celestial Garden`
- Story role: Monarch-class passenger DropShip, mobile headquarters, family housing, and civilian community.
- Notes: Keep its civilian/passenger character in the biography and RPG notes. It is not just a barracks.

### Union DropShip

- Current MekHQ unit: `Union (2708)`
- MekHQ unit id: `458ccd4f-0469-4518-86c0-287829670585`
- Recommended action: leave as-is for now unless you want to give the Strikers' military DropShip a proper name later.
- Story role: Strikers military transport carried by `Jade Passage`.

## Primary NPC Rewrites

### Captain Mei Ren

- Current MekHQ person: `Damiane Meyer`
- MekHQ person id: `5385cc1a-6f59-46e0-bcd2-f7f16e4b71d0`
- Current assignment: `Merchant JumpShip (2503)` / driver_or_pilot
- Current MekHQ role: Vessel Pilot
- Current hard facts: female, age 42, active, Piloting/Spacecraft 4, Language/Any 2, Small Arms 3, Interrogation 1, blank biography.
- Rename to: `Mei Ren`
- Optional title/rank display: `Captain` if MekHQ supports a civilian ship-rank note; otherwise leave rank alone and put captaincy in the biography.
- Final story assignment: Captain of `Jade Passage`.

Biography to paste or adapt:

```text
Mei Ren is a third-generation JumpShip officer of the Long Transit Association and the current captain of Jade Passage. She grew up around cooperative ships, dock ledgers, maintenance prayers, and quiet family arguments over which vessel had to be sold next. By the time she inherited command, the cooperative had already lost most of its old route network to piracy, debt, confiscation, and Succession Wars attrition.

She treats Jade Passage as a home and a trust, not as cargo or prize money. Many aboard were born into the cooperative or have nowhere better to go. Mei is disciplined, restrained, and hard to impress. She does not hate mercenaries, but she has seen enough hired guns call themselves protectors right up until a better offer came along.

Her agreement with Sharpe's Strikers begins as necessity. She will honor a charter, but she will not surrender shipboard authority. Docking, jump decisions, safety limits, and crew discipline remain under her command. She may refuse jumps into systems with active naval combat, broken recharge support, bad fuel prospects, or unacceptable capture risk.

Mei understands navigation, trade routes, port politics, cooperative law, and the ugly realities of staying independent without state backing. If Sharpe proves he respects the charter, she can become one of his most valuable advisers. If he treats Jade Passage as a free ride, she will close ranks around her crew and look for a way out.
```

GM use:

- Voice: quiet, exact, controlled.
- Pressure line: "Captain, a JumpShip does not get brave. It gets dead, and everyone docked to it dies with it."
- Trust starts low. Increase it when Sharpe respects shipboard authority and pays maintenance without whining.

### Captain Tomas Vale

Preferred story match:

- Current MekHQ person: `Liang-hsi Tomaszowicz`
- MekHQ person id: `d2da3d72-7059-4950-b1c5-2a8f7a261cf5`
- Current assignment: `Monarch (2759)` / driver_or_pilot
- Current MekHQ role: Vessel Pilot
- Current hard facts: male, age 29, active, Piloting/Spacecraft 3, Computers 0, Small Arms 3, blank biography.
- Rename to: `Tomas Vale`
- Final story assignment: Captain of `Celestial Garden`.

Important MekHQ note: MekHQ currently marks `Nadezda Dunajski` (`5a4fa278-7b44-48eb-bb11-069190f5f3f4`) as the Monarch commander. If MekHQ lets you change commander or crew order, make `Tomas Vale` the commander. If not, keep Nadezda as first officer or operations officer in the story until the hard assignment can be corrected.

Biography to paste or adapt:

```text
Tomas Vale is the captain of Celestial Garden, a Monarch-class passenger DropShip that once carried diplomats, pilgrims, merchant families, and anyone else with enough money to buy peace between worlds. He came up through passenger lines, not military transport, and he still judges a ship by whether children can sleep, meals arrive hot, and frightened passengers believe tomorrow will look like today.

Vale is sociable, practiced, and better at hiding fear than most soldiers give him credit for. He knows how to smile through bad news, settle cabin disputes before they become fights, and keep civilians moving during inspections. He also knows the ship is tired. The lounges are worn, the carpets patched, and the old luxury is now mostly memory and discipline.

The charter with Sharpe's Strikers could save Celestial Garden, but Vale fears the cure almost as much as the disease. A mercenary command needs offices, bunks, weapons lockers, classrooms, stores, medical rooms, and security checkpoints. A passenger ship can survive that. A community might not.

Vale wants the Strikers to understand that Celestial Garden is not a troop box. It is a civilian ship full of families, paying passengers, crew traditions, and fragile normal life. He will cooperate with military necessity, but he will fight quietly and stubbornly against anything that turns his ship into a barracks with windows.
```

GM use:

- Voice: warm, polished, tired underneath.
- Pressure line: "Colonel, soldiers can sleep beside ammunition. Children should not have to."
- Use him when the cost of militarizing the Monarch needs a human face.

### Chief Engineer Aron Vesk

- Current MekHQ person: `Damon Dimas`
- MekHQ person id: `992b1f0f-41db-40e4-8564-23dc269fa3eb`
- Current assignment: `Merchant JumpShip (2503)` / vessel_crew
- Current MekHQ role: Vessel Crewmember
- Current hard facts: male, age 33, active, Tech/Vessel 4, Administration 3, Physics 2, Perception 2, Appraisal 1, blank biography.
- Rename to: `Aron Vesk`
- Final story assignment: Chief engineer of `Jade Passage`.

Biography to paste or adapt:

```text
Aron Vesk is chief engineer of Jade Passage and the man most likely to ruin a commander's day with arithmetic. He has spent years keeping an old Merchant-class JumpShip alive through shortages, cannibalized parts, patched systems, and cooperative accounting that always had one more crisis than the repair fund could cover.

Vesk is blunt because the ship does not care about optimism. A worn seal fails whether morale is good or bad. A deferred overhaul stays deferred until someone pays for it. He does not hide problems to make captains feel better, and he has no patience for officers who think a JumpShip is free because the purchase price was someone else's headache.

He knows Jade Passage is operational. He also knows exactly which repairs should have been done years ago. He keeps lists: heat exchangers, sail rigging stress, docking collar tolerances, coolant runs, crew-space systems, obsolete control boards, and every invoice the cooperative postponed to survive one more jump.

Vesk can respect Sharpe if Sharpe listens to bad news and pays for work before the ship becomes a coffin. Until then, he treats the Strikers as another armed outfit standing too close to equipment they do not understand.
```

GM use:

- Voice: blunt, practical, irritated by wishful thinking.
- Pressure line: "You did not get free transport. You got an invoice with a jump sail wrapped around it."
- Use him to turn the charter into maintenance pressure, not free loot.

### Lian Zhou

Recommended record:

- Current MekHQ person: `Tora Wichers`
- MekHQ person id: `08a787d8-c60c-4965-a92a-87344e108cca`
- Current assignment: none
- Current MekHQ role: Admin/Transport
- Current hard facts: female, age 42, active, Administration 5, Negotiation 2, Investigation 1, long service since 3025-01-01, blank biography.
- Rename to: `Lian Zhou`
- Final story assignment: Long Transit Association representative, financial officer, negotiator, and surviving shareholder.

Why this record: `Tora Wichers` is the strongest fit for Lian because she is active, female, transport-admin focused, experienced, and already has the right Administration/Negotiation/Investigation shape.

Alternate record if you want Lian to be younger/lower-profile:

- Current MekHQ person: `Su-Ning Petritiovsky`
- MekHQ person id: `827f9e9b-6ddd-4bc2-9995-0a55af483f2f`
- Current role: Admin/Logistical
- Hard facts: female, age 31, Administration 2, Negotiation 0, active since 3030-09-06.

Biography to paste or adapt for the recommended record:

```text
Lian Zhou is the financial officer and cooperative representative of the Long Transit Association. She is not just an accountant. She is one of the people left holding the cooperative together after generations of losses, lawsuits, dead routes, seized accounts, bad credit, and families who could not afford to leave.

Lian knows every port fee the association missed, every debt it paid twice, every license that went cold after the wrong noble made a call, and every creditor who suddenly became interested in two aging but priceless ships. She has enough evidence to know the current seizure is dirty, but not enough to safely accuse the regional noble behind it.

She approaches Sharpe's Strikers because the unit is useful in the exact way the cooperative needs: independent, Capellan-recognized, heavily armed, and not so large that the cooperative would disappear inside it. Her offer is practical, but not submissive. The ships will charter themselves to the Strikers. They will not become disposable property.

Lian is calm because panic wastes time. Under that calm is exhaustion, anger, and the knowledge that one wrong signature could end the last surviving piece of her community. She will bargain hard, show only the evidence she must, and test whether Sharpe is protector, predator, or merely another temporary employer.
```

GM use:

- Voice: precise, legal, controlled, with anger under the paper.
- Pressure line: "The order is clean. The debt behind it is not. That is how they steal ships without firing on them."
- Use her as the face of the legal arc and the keeper of incomplete evidence.

## Supporting Ship Staff To Keep

These do not need immediate rewrites, but they are useful anchors.

### Nadezda Dunajski

- Current MekHQ person id: `5a4fa278-7b44-48eb-bb11-069190f5f3f4`
- Current assignment: `Monarch (2759)` / driver_or_pilot
- Current MekHQ role: Vessel Pilot
- Current command issue: current Monarch commander in the live API.
- Recommended story role: first officer or operations officer of `Celestial Garden`.
- Use: stricter than Tomas Vale, handles watch bills, docking discipline, and emergency movement when Vale is protecting passengers.

### Jennifer Cristea

- Current MekHQ person id: `2cda6b41-e49a-458d-b710-e4f2bfffcb6b`
- Current assignment: `Monarch (2759)` / vessel_crew
- Current MekHQ role: Vessel Crewmember
- Current hard facts: female, age 23, Tech/Vessel 4, Administration 2, Cryptography 2, Security Systems/Electronic 1.
- Recommended story role: Celestial Garden engineer or systems officer.
- Use: security systems, passenger-deck access, old luxury systems, surveillance, and maintenance compromises aboard the Monarch.

### Hortenspa Sawatsky

- Current assignment: `Merchant JumpShip (2503)` / navigator
- Current MekHQ role: Hyperspace Navigator
- Recommended story role: Jade Passage navigator.
- Use: jump windows, recharge station risk, route politics, and warnings when Mei Ren refuses unsafe movement.

## Suggested MekHQ Edit Order

1. Rename `Merchant JumpShip (2503)` to `Jade Passage`.
2. Rename `Monarch (2759)` to `Celestial Garden`.
3. Open `Damiane Meyer`, rename to `Mei Ren`, paste the Mei biography, and confirm she remains assigned to `Jade Passage`.
4. Open `Liang-hsi Tomaszowicz`, rename to `Tomas Vale`, paste the Tomas biography, and confirm he remains assigned to `Celestial Garden`.
5. If MekHQ supports changing the vessel commander slot, make `Tomas Vale` commander of `Celestial Garden`. If not, leave the assignment alone and treat Nadezda as first officer in MEK-RPG until it can be corrected.
6. Open `Damon Dimas`, rename to `Aron Vesk`, paste the Aron biography, and confirm he remains engineer/tech for `Jade Passage`.
7. Open `Tora Wichers`, rename to `Lian Zhou`, paste the Lian biography, and leave her unassigned unless MekHQ has an appropriate transport administration billet.
8. Optional: add short bios or notes for Nadezda Dunajski, Jennifer Cristea, and Hortenspa Sawatsky.
9. Save the MekHQ campaign.
10. Return to MEK-RPG and run the verification commands below.

## Verification After Manual Edits

Run from this repository:

```powershell
./scripts/fetch-mekhq-live-api.ps1 -OutputDirectory .\mekhq-live-api-capture
python ./scripts/query-mekhq-live-api.py --capture-dir .\mekhq-live-api-capture --view play-context --format text
python ./scripts/sync-mekhq-live-campaign.py --live-state .\mekhq-live-api-capture\mekhq-state.json --campaign-id sharpes-strikers --refresh-existing
./scripts/validate-campaign-state.ps1 -StrictActive
```

Then verify the important names appear:

```powershell
Select-String -Path .\mekhq-live-api-capture\mekhq-state.json -Pattern "Jade Passage","Celestial Garden","Mei Ren","Tomas Vale","Aron Vesk","Lian Zhou"
```

If a name does not appear, check whether MekHQ saved the change or whether the live API exposes that field.

## MEK-RPG Follow-Up

After verification, update these files if needed:

- `campaigns/sharpes-strikers/assets.md`: vessel names, ownership notes, maintenance pressure.
- `campaigns/sharpes-strikers/npcs.md`: replace temporary MEK-RPG-only NPCs with MekHQ-linked ids.
- `campaigns/sharpes-strikers/relationships.md`: update Long Transit Association trust and obligations.
- `campaigns/sharpes-strikers/session-log.md`: record that the MekHQ roster was manually aligned with the Jade Passage cast.

Do not mark any hard MekHQ value final in MEK-RPG until the live reread confirms it.
