# Task Router

Use this file first. Match the user's request to the most relevant files, then read those files before answering.

| User question or task | Read first | Also read |
| --- | --- | --- |
| resolving an uncertain action | `rules/core/action-checks.md` | `rules/core/basic-action-resolution.md`, `rules/core/edge.md` |
| bypassing a lock, disabling a device, or handling a technical task under pressure | `rules/core/skill-checks.md` | `rules/core/action-checks.md`, `rules/core/basic-action-resolution.md` |
| raw attribute check or untrained skill attempt | `rules/core/attribute-checks.md` | `rules/core/action-checks.md`, `rules/core/basic-action-resolution.md` |
| trained skill check | `rules/core/skill-checks.md` | `rules/core/action-checks.md`, `rules/core/basic-action-resolution.md` |
| opposed checks or direct contests | `rules/core/opposed-actions.md` | `rules/core/basic-action-resolution.md`, `rules/core/edge.md` |
| two characters racing, grabbing, resisting, sneaking past, or spotting each other | `rules/core/opposed-actions.md` | `rules/core/basic-action-resolution.md`, `rules/core/edge.md` |
| difficult circumstances, time pressure, injury, fatigue, visibility, or environmental pressure on a roll | `rules/core/basic-action-resolution.md` | `rules/core/action-checks.md`, `rules/core/skill-checks.md` |
| modifiers, fumbles, high rolls, or margin of success | `rules/core/basic-action-resolution.md` | `rules/core/action-checks.md`, `rules/core/opposed-actions.md` |
| interpreting how well or poorly a roll succeeded or failed | `rules/core/basic-action-resolution.md` | `rules/core/action-checks.md`, `rules/core/opposed-actions.md` |
| spending or recovering Edge | `rules/core/edge.md` | `rules/core/basic-action-resolution.md`, `rules/campaign/advancement.md` |
| character creation | `rules/character-creation/overview.md` | `rules/character-creation/lifepaths.md`, `rules/character-creation/attributes.md`, `rules/character-creation/traits.md`, `rules/character-creation/skills.md` |
| lifepaths | `rules/character-creation/lifepaths.md` | `rules/character-creation/overview.md` |
| skills | `rules/character-creation/skills.md` | `rules/character-creation/attributes.md`, `rules/vehicles-and-mechs/mechwarrior-skills.md` |
| personal combat, firefight, brawl, ambush, or character-scale fight | `rules/personal-combat/overview.md` | `rules/personal-combat/initiative.md`, `rules/personal-combat/action-and-movement.md`, `rules/personal-combat/damage.md` |
| initiative, held action, squad initiative, or who acts first in personal combat | `rules/personal-combat/initiative.md` | `rules/personal-combat/overview.md`, `rules/personal-combat/action-and-movement.md` |
| moving, sprinting, crawling, climbing, swimming, taking cover, or using actions during personal combat | `rules/personal-combat/action-and-movement.md` | `rules/personal-combat/overview.md`, `rules/core/basic-action-resolution.md` |
| ranged attacks, shooting, thrown weapons, grenades, cover, line of sight, burst fire, suppression fire, blind fire, or indirect fire | `rules/personal-combat/ranged-attacks.md` | `rules/core/skill-checks.md`, `rules/core/basic-action-resolution.md`, `rules/personal-combat/damage.md` |
| melee attacks, brawling, knives, martial arts, grappling, or close combat | `rules/personal-combat/melee-attacks.md` | `rules/core/opposed-actions.md`, `rules/personal-combat/damage.md`, `rules/personal-combat/wounds.md` |
| damage from an attack, fall, fire, poison, suffocation, bleeding source, armor interaction, or fatigue damage | `rules/personal-combat/damage.md` | `rules/personal-combat/wounds.md`, `rules/personal-combat/end-phase.md`, `rules/equipment/armor.md` |
| injury penalties, stun, unconsciousness, bleeding, death, tactical kill, or wound effects | `rules/personal-combat/wounds.md` | `rules/personal-combat/damage.md`, `rules/personal-combat/end-phase.md`, `rules/personal-combat/recovery.md` |
| end of combat turn, continuous damage, fatigue accumulation, recovering fatigue in combat, or extended action progress | `rules/personal-combat/end-phase.md` | `rules/personal-combat/damage.md`, `rules/personal-combat/wounds.md` |
| recovery, stabilization, medical care, surgery, healing, downtime after injury, or recovering fatigue after combat | `rules/personal-combat/recovery.md` | `rules/equipment/medical-gear.md`, `rules/personal-combat/wounds.md`, `rules/personal-combat/end-phase.md`, `rules/campaign/injuries-recovery.md` |
| buying, requisitioning, black-market acquisition, legality, availability, used gear, or repairing personal equipment | `rules/equipment/overview.md` | `rules/core/skill-checks.md`, `rules/core/basic-action-resolution.md` |
| weapons, ammunition, weapon accessories, grenades, mines, explosives, support weapons, ordnance, or weapon stats | `rules/equipment/weapons.md` | `rules/personal-combat/ranged-attacks.md`, `rules/personal-combat/melee-attacks.md`, `rules/personal-combat/damage.md` |
| armor, shields, helmets, hostile-environment gear, stealth gear, armor repair, battle armor boundary, or personal protection | `rules/equipment/armor.md` | `rules/personal-combat/damage.md`, `rules/personal-combat/wounds.md`, `gm/switch-to-classic-battletech.md` |
| communications, computers, diagnostics, surveillance, optics, remote sensors, jamming, or electronics | `rules/equipment/electronics.md` | `rules/core/skill-checks.md`, `rules/core/opposed-actions.md`, `rules/personal-combat/initiative.md` |
| medical equipment, first aid supplies, surgery tools, stimulants, preservation gear, or life-support devices | `rules/equipment/medical-gear.md` | `rules/personal-combat/recovery.md`, `rules/personal-combat/wounds.md`, `rules/core/skill-checks.md` |
| power packs, chargers, tool kits, repair gear, salvage gear, survival gear, mobility gear, locks, disguise, forgery, forensics, or espionage gear | `rules/equipment/personal-gear.md` | `rules/equipment/electronics.md`, `rules/core/skill-checks.md`, `rules/core/basic-action-resolution.md` |
| MechWarrior skills | `rules/vehicles-and-mechs/mechwarrior-skills.md` | `rules/vehicles-and-mechs/piloting.md`, `rules/vehicles-and-mechs/gunnery.md` |
| converting RPG characters to Classic BattleTech pilots | `rules/vehicles-and-mechs/converting-to-classic-battletech.md` | `gm/switch-to-classic-battletech.md` |
| switching from RPG mode to BattleTech tactical combat | `gm/switch-to-classic-battletech.md` | `rules/vehicles-and-mechs/overview.md` |
| campaign advancement | `rules/campaign/advancement.md` | `rules/character-creation/xp-advancement.md` |
| NPCs and contacts | `rules/campaign/contacts.md` | `campaign-state/active-campaign.md`, active `campaigns/<campaign-id>/npcs.md`, active `campaigns/<campaign-id>/factions.md`, active `campaigns/<campaign-id>/relationships.md` |
| running a scene | `gm/scene-loop.md` | `gm/roll-policy.md`, `campaign-state/active-campaign.md`, active `campaigns/<campaign-id>/current-state.md`, active `campaigns/<campaign-id>/missions.md`, active `campaigns/<campaign-id>/hooks.md` |
| running a kid-friendly session | `gm/kid-friendly-mode.md` | `gm/scene-loop.md`, `gm/roll-policy.md` |
| creating a mission | `gm/mission-template.md` | `rules/campaign/contracts.md`, `campaign-state/active-campaign.md`, active `campaigns/<campaign-id>/missions.md`, active `campaigns/<campaign-id>/factions.md`, active `campaigns/<campaign-id>/assets.md`, active `campaigns/<campaign-id>/hooks.md` |
| creating a tactical encounter | `gm/encounter-template.md` | `gm/switch-to-classic-battletech.md` |
