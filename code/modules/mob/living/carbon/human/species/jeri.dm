/datum/species/synthetic/jeri
	name = SPECIES_SYNTHETIC_JERI

	slowdown = -1.0

	icobase = 'icons/mob/humans/species/jeri.dmi'
	deform = 'icons/mob/humans/species/jeri.dmi'
	eyes = "blank_eyes_s"
	unarmed_type = /datum/unarmed_attack/claws/synthetic
	secondary_unarmed_type = /datum/unarmed_attack
	death_message = "lets out a faint screech as it collapses and stops moving..."
	flags = IS_WHITELISTED|NO_BREATHE|NO_CLONE_LOSS|NO_BLOOD|NO_POISON|IS_SYNTHETIC|NO_CHEM_METABOLIZATION|NO_NEURO|NO_OVERLAYS

	mob_inherent_traits = list(TRAIT_SUPER_STRONG, TRAIT_IRON_TEETH, TRAIT_EMOTE_CD_EXEMPT)

	fire_sprite_prefix = "k9"
	fire_sprite_sheet = 'icons/mob/humans/onmob/OnFire.dmi'

	inherent_verbs = list(
		/mob/living/carbon/human/synthetic/proc/toggle_HUD,
		/mob/living/carbon/human/proc/toggle_inherent_nightvison,
	)
