# Armor And Barriers

## Purpose

Use this summary to adjudicate personal armor, tactical armor, battle armor, barriers, armor degradation, and stacked protection in personal-scale combat.

## When to Use

- A personal-scale attack passes through armor, a shield, a wall, a window, a door, furniture, vehicle armor, battle armor, or another obstruction.
- The GM needs to know whether armor reduces attack penetration and damage.
- Personal armor, tactical armor, or a barrier may degrade after being hit.
- A character is wearing multiple armor layers or is behind cover while also wearing armor.
- Battle armor or an exoskeleton is being hit by personal-scale weapons and the wearer may take spillover harm.

## Do Not Use For

- Full BattleTech armor-location play, vehicle sheets, heat, facing, or tactical movement. Use `gm/switch-to-classic-battletech.md`.
- Copying BAR tables, barrier tables, battle armor tables, or worked examples.
- Exact personal armor item values. Use `rules/equipment/armor.md` and the cited private source pages.
- Optional hit locations unless the GM has explicitly turned on `rules/combat/optional-personal-combat.md`.

## Basic Procedure

1. Identify every protection layer between the damage source and the character: barrier, shield, worn personal armor, natural armor, battle armor, vehicle/tactical armor, or internal structure.
2. Identify the attack's armor penetration, damage type, and base damage after the attack procedure has already modified damage for margin, strength, burst fire, or other source effects.
3. For personal armor or ordinary barriers, compare the attack's armor penetration to the relevant BAR for the damage type.
4. If the attack's penetration is equal to or higher than the relevant BAR, the protection does not reduce the damage.
5. If the relevant BAR is higher than the attack's penetration, reduce both remaining penetration and remaining damage by the difference, never below zero.
6. Apply remaining damage to the next layer inward. If remaining damage reaches zero before the target, the target is not harmed by that attack.
7. For personal armor, if enough standard damage penetrates, reduce all of that armor's BAR values by the source amount. Destroyed armor offers no protection until repaired or replaced.
8. For tactical armor and barriers, convert penetrating standard damage into armor or integrity loss using the source procedure. Tactical armor normally takes the hit instead of the character inside.
9. For battle armor and exoskeletons, apply tactical armor loss first, then apply wearer spillover when the source conditions are met.
10. If multiple layers are stacked, process them in the physical order struck, carrying the reduced penetration and damage forward.

## Practical GM Guidance

- Ask "what does the attack hit first?" before doing any math. That usually determines the whole sequence.
- Keep cover and barriers physical. A flimsy obstacle might conceal a target without stopping a shot; a hard obstacle might stop damage but be destroyed.
- Use exact table values only when they matter. For quick play, the GM can decide whether a barrier is flimsy, modest, tough, or armored, then cite the source for a later audit.
- Stacked worn armor should cost something in mobility and fatigue. Do not let characters stack protection without tracking encumbrance.
- Battle armor is a scale-warning sign. If the suit's tactical armor, weapons, movement, or battlefield role becomes central, hand off to tactical BattleTech, MegaMek, or MekHQ.

## Common Edge Cases

- Personal armor has different BAR values by damage type. Use the relevant damage channel.
- Tactical armor usually has one BAR and armor points; it keeps its BAR until the location's armor or structure is gone.
- Barrier integrity represents whether an object remains useful as an obstruction, not a full engineering model of the object.
- A BAR 0 barrier is destroyed by any damaging hit, but it may still matter for concealment before being hit.
- Fatigue-only attacks normally do not damage tactical armor.
- Hit locations are normally optional for characters, but tactical units require location handling from the tactical rules.
- Stacked personal armor increases encumbrance and has a source limit on the number of layers.

## Related Files

- `rules/personal-combat/damage.md`
- `rules/personal-combat/wounds.md`
- `rules/personal-combat/ranged-attacks.md`
- `rules/personal-combat/melee-attacks.md`
- `rules/combat/optional-personal-combat.md`
- `rules/equipment/armor.md`
- `rules/vehicles-and-mechs/overview.md`
- `gm/switch-to-classic-battletech.md`

## Source References

- A Time of War PDF pages 187-190 / printed pages 185-188: armor and barrier types, AP vs. BAR, armor degradation, barrier integrity, and stacked armor.

## Status

Draft source-reviewed summary for issue `#61`. Exact BAR values, battle armor tables, barrier tables, and examples remain private source lookups.
