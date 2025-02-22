/mob/living/simple_animal/hostile/dino
	name = "primal render yearling"
	desc = "A younger primal render, one that has yet to harden its scales, shed the baby fat, \
	and grow its usual horns and claws. Unlike older ones it has yet to become as fantastically violent to everything, \
	a trait that often gets it hunted by older renders to kill potential developing rivals."
	icon = 'icons/mob/64x64.dmi'
	icon_state = "biglizard"
	icon_dead = "biglizard_dead"
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	speed = 4
	faction = "pond"
	health = 400
	maxHealth = 400
	melee_damage_lower = 20
	melee_damage_upper = 25
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'
	minbodytemp = 200
	maxbodytemp = 370
	heat_damage_per_tick = 15
	cold_damage_per_tick = 10
	unsuitable_atoms_damage = 10
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	leather_amount = 6 //The amount of leather sheets dropped.
	bones_amount = 6 //The amount of bone sheets dropped.
	mob_size = MOB_LARGE

/mob/living/simple_animal/hostile/dino/tagilla
	faction = "neutral"
	name = "Tagilla"
	desc = "A younger primal render, one that has yet to harden its scales, \
	shed the baby fat, and grow its usual horns and claws. Unlike older ones it has yet to become as fantastically violent to everything, \
	a trait that often gets it hunted by older renders to kill potential developing rivals. His older brother, Killa, is said to be a legendary render."
	colony_friend = TRUE
	friendly_to_colony = TRUE
