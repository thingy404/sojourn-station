var/list/flooring_types

/proc/get_flooring_data(var/flooring_path)
	if(!flooring_types)
		flooring_types = list()
		for(var/path in typesof(/decl/flooring))
			flooring_types["[path]"] = new path
	return flooring_types["[flooring_path]"]

// State values:
// [icon_base]: initial base icon_state without edges or corners.
// if has_base_range is set, append 0-has_base_range ie.
//   [icon_base][has_base_range]
// [icon_base]_broken: damaged overlay.
// if has_damage_range is set, append 0-damage_range for state ie.
//   [icon_base]_broken[has_damage_range]
// [icon_base]_edges: directional over-lays for edges.
// [icon_base]_corners: directional over-lays for non-edge corners.

/decl/flooring
	var/name = "floor"
	var/desc
	var/icon
	var/icon_base

	var/footstep_sound = "floor"
	var/hit_sound = null

	var/has_base_range
	var/has_damage_range
	var/has_burn_range
	var/damage_temperature
	var/apply_thermal_conductivity
	var/apply_heat_capacity

	var/build_type      // Unbuildable if not set. Must be /obj/item/stack.
	var/build_cost = 1  // Stack units.
	var/build_time = 0  // BYOND ticks.

	var/descriptor = "tiles"
	var/flags = TURF_CAN_BURN | TURF_CAN_BREAK
	var/can_paint

	var/is_plating = FALSE

	//Plating types, can be overridden
	var/plating_type = /decl/flooring/reinforced/plating

	//Resistance is subtracted from all incoming damage
	var/resistance = RESISTANCE_FRAGILE

	//Damage the floor can take before being destroyed
	var/health = 50

	var/removal_time = WORKTIME_FAST * 0.75

	//Flooring Icon vars
	var/smooth_nothing = FALSE //True/false only, optimisation
	//If true, all smoothing logic is entirely skipped

	//The rest of these x_smooth vars use one of the following options
	//SMOOTH_NONE: Ignore all of type
	//SMOOTH_ALL: Smooth with all of type
	//SMOOTH_WHITELIST: Ignore all except types on this list
	//SMOOTH_BLACKLIST: Smooth with all except types on this list
	//SMOOTH_GREYLIST: Objects only: Use both lists

	//How we smooth with other flooring
	var/floor_smooth = SMOOTH_ALL
	var/list/flooring_whitelist = list() //Smooth with nothing except the contents of this list
	var/list/flooring_blacklist = list() //Smooth with everything except the contents of this list

	//How we smooth with walls
	var/wall_smooth = SMOOTH_NONE
	//There are no lists for walls at this time

	//How we smooth with space and openspace tiles
	var/space_smooth = SMOOTH_ALL
	//There are no lists for spaces

	/*
	How we smooth with movable atoms
	These are checked after the above turf based smoothing has been handled
	SMOOTH_ALL or SMOOTH_NONE are treated the same here. Both of those will just ignore atoms
	Using the white/blacklists will override what the turfs concluded, to force or deny smoothing

	Movable atom lists are much more complex, to account for many possibilities
	Each entry in a list, is itself a list consisting of three items:
		Type: The typepath to allow/deny. This will be checked against istype, so all subtypes are included
		Priority: Used when items in two opposite lists conflict. The one with the highest priority wins out.
		Vars: An associative list of variables (varnames in text) and desired values
			Code will look for the desired vars on the target item and only call it a match if all desired values match
			This can be used, for example, to check that objects are dense and anchored
			there are no safety checks on this, it will probably throw runtimes if you make typos

	Common example:
	Don't smooth with dense anchored objects except airlocks

	smooth_movable_atom = SMOOTH_GREYLIST
	movable_atom_blacklist = list(
		list(/obj, list("density" = TRUE, "anchored" = TRUE), 1)
		)
	movable_atom_whitelist = list(
	list(/obj/machinery/door/airlock, list(), 2)
	)

	*/
	var/smooth_movable_atom = SMOOTH_NONE
	var/list/movable_atom_whitelist = list()
	var/list/movable_atom_blacklist = list()

//Flooring Procs
/decl/flooring/proc/get_plating_type(var/turf/location)
	return plating_type

//Used to check if we can build the specified type of floor ontop of this one
/decl/flooring/proc/can_build_floor(var/decl/flooring/newfloor)
	return FALSE

//Used when someone attacks the floor
/decl/flooring/proc/attackby(var/obj/item/I, var/mob/user, var/turf/T)
	return FALSE

/decl/flooring/proc/Entered(mob/living/M as mob)
	return

/decl/flooring/asteroid
	name = "coarse sand"
	desc = "Gritty and unpleasant."
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_base = "asteroid"
	flags = TURF_REMOVE_SHOVEL | TURF_CAN_BURN | TURF_CAN_BREAK
	build_type = null
	footstep_sound = "asteroid"

//=========PLATING==========\\

/decl/flooring/reinforced/plating
	name = "plating"
	descriptor = "plating"
	icon = 'icons/turf/flooring/plating.dmi'
	icon_base = "plating"
	build_type = /obj/item/stack/material/steel
	flags = TURF_REMOVE_WELDER | TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_CAN_BURN | TURF_CAN_BREAK
	can_paint = 1
	plating_type = /decl/flooring/reinforced/plating/under
	is_plating = TRUE
	footstep_sound = "plating"
	space_smooth = FALSE
	removal_time = 150
	health = 100
	has_base_range = 18
	floor_smooth = SMOOTH_BLACKLIST
	flooring_blacklist = list(/decl/flooring/reinforced/plating/under,/decl/flooring/reinforced/plating/hull) //Smooth with everything except the contents of this list
	smooth_movable_atom = SMOOTH_GREYLIST
	movable_atom_blacklist = list(
		list(/obj, list("density" = TRUE, "anchored" = TRUE), 1)
		)
	movable_atom_whitelist = list(list(/obj/machinery/door/airlock, list(), 2))

//Normal plating allows anything, except other types of plating
/decl/flooring/reinforced/plating/can_build_floor(var/decl/flooring/newfloor)
	if (istype(newfloor, /decl/flooring/reinforced/plating))
		return FALSE
	return TRUE

/decl/flooring/reinforced/plating/get_plating_type(var/turf/location)
	if (turf_is_upper_hull(location))
		return null
	return plating_type

//==========UNDERPLATING==============\\

/decl/flooring/reinforced/plating/under
	name = "underplating"
	icon = 'icons/turf/flooring/plating.dmi'
	descriptor = "support beams"
	icon_base = "under"
	build_type = /obj/item/stack/material/steel //Same type as the normal plating, we'll use can_build_floor to control it
	flags = TURF_REMOVE_WRENCH | TURF_CAN_BURN | TURF_CAN_BREAK | TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS
	can_paint = 1
	plating_type = /decl/flooring/reinforced/plating/hull
	is_plating = TRUE
	removal_time = 250
	health = 200
	has_base_range = 0
	resistance = RESISTANCE_ARMOURED
	footstep_sound = "catwalk"
	space_smooth = SMOOTH_ALL
	floor_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE

//Underplating can only be upgraded to normal plating
/decl/flooring/reinforced/plating/under/can_build_floor(var/decl/flooring/newfloor)
	if (newfloor.type == /decl/flooring/reinforced/plating)
		return TRUE
	return FALSE

/decl/flooring/reinforced/plating/under/attackby(var/obj/item/I, var/mob/user, var/turf/T)
	if (istype(I, /obj/item/stack/rods))
		.=TRUE
		var/obj/item/stack/rods/R = I
		if(R.amount <= 3)
			return
		else
			R.use(3)
			to_chat(user, SPAN_NOTICE("You start connecting [R.name]s to [src.name], creating catwalk ..."))
			if(do_after(user,60))
				T.alpha = 0
				var/obj/structure/catwalk/CT = new /obj/structure/catwalk(T)
				T.contents += CT

/decl/flooring/reinforced/plating/under/get_plating_type(var/turf/location)
	if (turf_is_lower_hull(location)) //Hull plating is only on the lowest level of the ship
		return plating_type
	else if (turf_is_upper_hull(location))
		return /decl/flooring/reinforced/plating
	else return null

/decl/flooring/reinforced/plating/under/get_plating_type(var/turf/location)
	if (turf_is_lower_hull(location)) //Hull plating is only on the lowest level of the ship
		return plating_type
	else if (turf_is_upper_hull(location))
		return /decl/flooring/reinforced/plating
	else return null

/decl/flooring/reinforced/plating/under/Entered(mob/living/M as mob)
	for(var/obj/structure/catwalk/C in get_turf(M))
		return

	//BSTs need this or they generate tons of soundspam while flying through the ship
	if(!ishuman(M)|| M.incorporeal_move || !has_gravity(get_turf(M)))
		return
	var/mob/living/carbon/human/our_trippah = M
	if(MOVING_QUICKLY(M))
		if(M.stats.getPerk(PERK_SURE_STEP))
			return
 // The art of calculating the vectors required to avoid tripping on the metal beams requires big quantities of brain power
		if(prob(50 - our_trippah.stats.getStat(STAT_COG))) //50 cog makes you unable to trip
			our_trippah.adjustBruteLoss(5)
			our_trippah.trip(src, 6)
			return

//============HULL PLATING=========\\

/decl/flooring/reinforced/plating/hull
	name = "hull"
	descriptor = "outer hull"
	icon = 'icons/turf/flooring/hull.dmi'
	icon_base = "hullcenter"
	flags = TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_REMOVE_WELDER | TURF_CAN_BURN | TURF_CAN_BREAK
	build_type = /obj/item/stack/material/plasteel
	has_base_range = 35
	//try_update_icon = 0
	plating_type = null
	is_plating = TRUE
	health = 350
	resistance = RESISTANCE_HEAVILY_ARMOURED
	removal_time = 1 MINUTES //Cutting through the hull is very slow work
	footstep_sound = "hull"
	wall_smooth = SMOOTH_ALL
	space_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE

//Hull can upgrade to underplating
/decl/flooring/reinforced/plating/hull/can_build_floor(var/decl/flooring/newfloor)
	return FALSE //Not allowed to build directly on hull, you must first remove it and then build on the underplating

/decl/flooring/reinforced/plating/hull/get_plating_type(var/turf/location)
	if (turf_is_lower_hull(location)) //Hull plating is only on the lowest level of the ship
		return null
	else if (turf_is_upper_hull(location))
		return /decl/flooring/reinforced/plating/under
	else
		return null //This should never happen, hull plating should only be on the exterior

//==========CARPET==============\\

/decl/flooring/carpet
	name = "red carpet"
	desc = "Imported and comfy."
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_base = "carpet"
	footstep_sound = "carpet"
	build_type = /obj/item/stack/tile/carpet
	damage_temperature = T0C+200
	flags = TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_REMOVE_CROWBAR | TURF_CAN_BURN | TURF_HIDES_THINGS
	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE
	smooth_movable_atom = SMOOTH_NONE

/decl/flooring/carpet/bcarpet
	name = "black carpet"
	icon_base = "bcarpet"
	build_type = /obj/item/stack/tile/carpet/bcarpet

/decl/flooring/carpet/blucarpet
	name = "blue carpet"
	icon_base = "blucarpet"
	build_type = /obj/item/stack/tile/carpet/blucarpet

/decl/flooring/carpet/turcarpet
	name = "turquoise carpet"
	icon_base = "turcarpet"
	build_type = /obj/item/stack/tile/carpet/turcarpet

/decl/flooring/carpet/sblucarpet
	name = "silver blue carpet"
	icon_base = "sblucarpet"
	build_type = /obj/item/stack/tile/carpet/sblucarpet

/decl/flooring/carpet/gaycarpet
	name = "pink carpet"
	icon_base = "gaycarpet"
	build_type = /obj/item/stack/tile/carpet/gaycarpet

/decl/flooring/carpet/purcarpet
	name = "purple carpet"
	icon_base = "purcarpet"
	build_type = /obj/item/stack/tile/carpet/purcarpet

/decl/flooring/carpet/oracarpet
	name = "orange carpet"
	icon_base = "oracarpet"
	build_type = /obj/item/stack/tile/carpet/oracarpet

//==========TILING==============\\

/decl/flooring/tiling
	name = "floor"
	desc = "Scuffed from the passage of countless greyshirts."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "tiles"
	has_damage_range = 2 //RECHECK THIS. MAYBE MISTAKE
	damage_temperature = T0C+1400
	flags = TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN | TURF_HIDES_THINGS
	build_type = /obj/item/stack/tile/floor
	can_paint = 1
	resistance = RESISTANCE_FRAGILE

	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE

/decl/flooring/tiling/steel
	name = "floor"
	icon_base = "tiles"
	icon = 'icons/turf/flooring/tiles_steel.dmi'
	build_type = /obj/item/stack/tile/floor/steel
	footstep_sound = "floor"

/decl/flooring/tiling/steel/panels
	icon_base = "panels"
	build_type = /obj/item/stack/tile/floor/steel/panels

/decl/flooring/tiling/steel/techfloor
	icon_base = "techfloor"
	build_type = /obj/item/stack/tile/floor/steel/techfloor

/decl/flooring/tiling/steel/techfloor_grid
	icon_base = "techfloor_grid"
	build_type = /obj/item/stack/tile/floor/steel/techfloor_grid

/decl/flooring/tiling/steel/brown_perforated
	icon_base = "brown_perforated"
	build_type = /obj/item/stack/tile/floor/steel/brown_perforated

/decl/flooring/tiling/steel/gray_perforated
	icon_base = "gray_perforated"
	build_type = /obj/item/stack/tile/floor/steel/gray_perforated

/decl/flooring/tiling/steel/cargo
	icon_base = "cargo"
	build_type = /obj/item/stack/tile/floor/steel/cargo

/decl/flooring/tiling/steel/brown_platform
	icon_base = "brown_platform"
	build_type = /obj/item/stack/tile/floor/steel/brown_platform

/decl/flooring/tiling/steel/gray_platform
	icon_base = "gray_platform"
	build_type = /obj/item/stack/tile/floor/steel/gray_platform

/decl/flooring/tiling/steel/danger
	icon_base = "danger"
	build_type = /obj/item/stack/tile/floor/steel/danger

/decl/flooring/tiling/steel/golden
	icon_base = "golden"
	build_type = /obj/item/stack/tile/floor/steel/golden

/decl/flooring/tiling/steel/bluecorner
	icon_base = "bluecorner"
	build_type = /obj/item/stack/tile/floor/steel/bluecorner

/decl/flooring/tiling/steel/orangecorner
	icon_base = "orangecorner"
	build_type = /obj/item/stack/tile/floor/steel/orangecorner

/decl/flooring/tiling/steel/cyancorner
	icon_base = "cyancorner"
	build_type = /obj/item/stack/tile/floor/steel/cyancorner

/decl/flooring/tiling/steel/violetcorener
	icon_base = "violetcorener"
	build_type = /obj/item/stack/tile/floor/steel/violetcorener

/decl/flooring/tiling/steel/monofloor
	icon_base = "monofloor"
	build_type = /obj/item/stack/tile/floor/steel/monofloor
	has_base_range = 15

/decl/flooring/tiling/steel/bar_flat
	icon_base = "bar_flat"
	build_type = /obj/item/stack/tile/floor/steel/bar_flat

/decl/flooring/tiling/steel/bar_dance
	icon_base = "bar_dance"
	build_type = /obj/item/stack/tile/floor/steel/bar_dance

/decl/flooring/tiling/steel/bar_light
	icon_base = "bar_light"
	build_type = /obj/item/stack/tile/floor/steel/bar_light

/decl/flooring/tiling/white
	name = "floor"
	icon_base = "tiles"
	icon = 'icons/turf/flooring/tiles_white.dmi'
	build_type = /obj/item/stack/tile/floor/white
	footstep_sound = "tile" //those are made from plastic, so they sound different

/decl/flooring/tiling/white/panels
	icon_base = "panels"
	build_type = /obj/item/stack/tile/floor/white/panels

/decl/flooring/tiling/white/techfloor
	icon_base = "techfloor"
	build_type = /obj/item/stack/tile/floor/white/techfloor

/decl/flooring/tiling/white/techfloor_grid
	icon_base = "techfloor_grid"
	build_type = /obj/item/stack/tile/floor/white/techfloor_grid

/decl/flooring/tiling/white/brown_perforated
	icon_base = "brown_perforated"
	build_type = /obj/item/stack/tile/floor/white/brown_perforated

/decl/flooring/tiling/white/gray_perforated
	icon_base = "gray_perforated"
	build_type = /obj/item/stack/tile/floor/white/gray_perforated

/decl/flooring/tiling/white/cargo
	icon_base = "cargo"
	build_type = /obj/item/stack/tile/floor/white/cargo

/decl/flooring/tiling/white/brown_platform
	icon_base = "brown_platform"
	build_type = /obj/item/stack/tile/floor/white/brown_platform

/decl/flooring/tiling/white/gray_platform
	icon_base = "gray_platform"
	build_type = /obj/item/stack/tile/floor/white/gray_platform

/decl/flooring/tiling/white/danger
	icon_base = "danger"
	build_type = /obj/item/stack/tile/floor/white/danger

/decl/flooring/tiling/white/golden
	icon_base = "golden"
	build_type = /obj/item/stack/tile/floor/white/golden

/decl/flooring/tiling/white/bluecorner
	icon_base = "bluecorner"
	build_type = /obj/item/stack/tile/floor/white/bluecorner

/decl/flooring/tiling/white/orangecorner
	icon_base = "orangecorner"
	build_type = /obj/item/stack/tile/floor/white/orangecorner

/decl/flooring/tiling/white/cyancorner
	icon_base = "cyancorner"
	build_type = /obj/item/stack/tile/floor/white/cyancorner

/decl/flooring/tiling/white/violetcorener
	icon_base = "violetcorener"
	build_type = /obj/item/stack/tile/floor/white/violetcorener

/decl/flooring/tiling/white/monofloor
	icon_base = "monofloor"
	build_type = /obj/item/stack/tile/floor/white/monofloor
	has_base_range = 15

/decl/flooring/tiling/dark
	name = "floor"
	icon_base = "tiles"
	icon = 'icons/turf/flooring/tiles_dark.dmi'
	build_type = /obj/item/stack/tile/floor/dark
	footstep_sound = "floor"

/decl/flooring/tiling/dark/panels
	icon_base = "panels"
	build_type = /obj/item/stack/tile/floor/dark/panels

/decl/flooring/tiling/dark/techfloor
	icon_base = "techfloor"
	build_type = /obj/item/stack/tile/floor/dark/techfloor

/decl/flooring/tiling/dark/techfloor_grid
	icon_base = "techfloor_grid"
	build_type = /obj/item/stack/tile/floor/dark/techfloor_grid

/decl/flooring/tiling/dark/brown_perforated
	icon_base = "brown_perforated"
	build_type = /obj/item/stack/tile/floor/dark/brown_perforated

/decl/flooring/tiling/dark/gray_perforated
	icon_base = "gray_perforated"
	build_type = /obj/item/stack/tile/floor/dark/gray_perforated

/decl/flooring/tiling/dark/cargo
	icon_base = "cargo"
	build_type = /obj/item/stack/tile/floor/dark/cargo

/decl/flooring/tiling/dark/brown_platform
	icon_base = "brown_platform"
	build_type = /obj/item/stack/tile/floor/dark/brown_platform

/decl/flooring/tiling/dark/gray_platform
	icon_base = "gray_platform"
	build_type = /obj/item/stack/tile/floor/dark/gray_platform

/decl/flooring/tiling/dark/danger
	icon_base = "danger"
	build_type = /obj/item/stack/tile/floor/dark/danger

/decl/flooring/tiling/dark/golden
	icon_base = "golden"
	build_type = /obj/item/stack/tile/floor/dark/golden

/decl/flooring/tiling/dark/bluecorner
	icon_base = "bluecorner"
	build_type = /obj/item/stack/tile/floor/dark/bluecorner

/decl/flooring/tiling/dark/orangecorner
	icon_base = "orangecorner"
	build_type = /obj/item/stack/tile/floor/dark/orangecorner

/decl/flooring/tiling/dark/cyancorner
	icon_base = "cyancorner"
	build_type = /obj/item/stack/tile/floor/dark/cyancorner

/decl/flooring/tiling/dark/violetcorener
	icon_base = "violetcorener"
	build_type = /obj/item/stack/tile/floor/dark/violetcorener

/decl/flooring/tiling/dark/monofloor
	icon_base = "monofloor"
	build_type = /obj/item/stack/tile/floor/dark/monofloor
	has_base_range = 15

/decl/flooring/tiling/cafe
	name = "floor"
	icon_base = "cafe"
	icon = 'icons/turf/flooring/tiles.dmi'
	build_type = /obj/item/stack/tile/floor/cafe
	footstep_sound = "floor"

/decl/flooring/tiling/techmaint
	name = "floor"
	icon_base = "techmaint"
	icon = 'icons/turf/flooring/tiles_maint.dmi'
	build_type = /obj/item/stack/tile/floor/techmaint
	footstep_sound = "floor"

	floor_smooth = SMOOTH_WHITELIST
	flooring_whitelist = list(/decl/flooring/tiling/techmaint_perforated, /decl/flooring/tiling/techmaint_panels)

/decl/flooring/tiling/techmaint_perforated
	name = "floor"
	icon_base = "techmaint_perforated"
	icon = 'icons/turf/flooring/tiles_maint.dmi'
	build_type = /obj/item/stack/tile/floor/techmaint/perforated
	footstep_sound = "floor"

	floor_smooth = SMOOTH_WHITELIST
	flooring_whitelist = list(/decl/flooring/tiling/techmaint, /decl/flooring/tiling/techmaint_panels)

/decl/flooring/tiling/techmaint_panels
	name = "floor"
	icon_base = "techmaint_panels"
	icon = 'icons/turf/flooring/tiles_maint.dmi'
	build_type = /obj/item/stack/tile/floor/techmaint/panels
	footstep_sound = "floor"

	floor_smooth = SMOOTH_WHITELIST
	flooring_whitelist = list(/decl/flooring/tiling/techmaint_perforated, /decl/flooring/tiling/techmaint)

/decl/flooring/tiling/techmaint_cargo
	name = "floor"
	icon_base = "techmaint_cargo"
	icon = 'icons/turf/flooring/tiles_maint.dmi'
	build_type = /obj/item/stack/tile/floor/techmaint/cargo
	footstep_sound = "floor"

/decl/flooring/tiling/lino
	name = "floor"
	icon_base = "lino"
	icon = 'icons/turf/flooring/tiles_maint.dmi'
	build_type = /obj/item/stack/material/steel
	footstep_sound = "floor"

/decl/flooring/tiling/lino/grey
	icon_base = "lino2"

/decl/flooring/tiling/rustic
	name = "floor"
	icon_base = "tile_neutral"
	icon = 'icons/turf/flooring/tiles_rustic.dmi'
	build_type = /obj/item/stack/material/steel
	footstep_sound = "floor"

/decl/flooring/tiling/rustic/red
	icon_base = "tile_red"

/decl/flooring/tiling/rustic/yellow
	icon_base = "tile_yellow"

/decl/flooring/tiling/rustic/green
	icon_base = "tile_green"

/decl/flooring/tiling/rustic/blue
	icon_base = "tile_blue"

/decl/flooring/tiling/rustic/brown
	icon_base = "tile_brown"

/decl/flooring/tiling/rustic/purple
	icon_base = "tile_purple"

/decl/flooring/tiling/rustic/metallic/bolts
	icon_base = "bolts"

/decl/flooring/tiling/rustic/metallic/grille
	icon_base = "grille"

/decl/flooring/tiling/rustic/metallic/grooves
	icon_base = "grooves"

/decl/flooring/tiling/rustic/metallic/grid
	icon_base = "grid"

/decl/flooring/tiling/rustic/metallic/vents
	icon_base = "vents"

/decl/flooring/tiling/rustic/metallic/plates
	icon_base = "plates"

/decl/flooring/tiling/rustic/metallic/duct
	icon_base = "duct"

/*Old Tile*/

/decl/flooring/tiling/oldtile
	name = "floor"
	icon = 'icons/turf/flooring/oldtile.dmi'
	build_type = /obj/item/stack/material/steel
	footstep_sound = "floor"

/decl/flooring/tiling/oldtile/plain
	icon_base = "floor"

/decl/flooring/tiling/oldtile/dirtyplain
	icon_base = "floordirty"

/decl/flooring/tiling/oldtile/rustyplain
	icon_base = "floorrusty"

/decl/flooring/tiling/oldtile/plainsolid
	icon_base = "floorsolid"

/decl/flooring/tiling/oldtile/dirtyplainsolid
	icon_base = "floordirtysolid"

/decl/flooring/tiling/oldtile/rustyplainsolid
	icon_base = "floorrustysolid"

/decl/flooring/tiling/oldtile/white
	icon_base = "white"

/decl/flooring/tiling/oldtile/whitedirtyplain
	icon_base = "whitedirty"

/decl/flooring/tiling/oldtile/whiterustyplain
	icon_base = "whiterusty"

/decl/flooring/tiling/oldtile/whiteplainsolid
	icon_base = "whitesolid"

/decl/flooring/tiling/oldtile/whitedirtyplainsolid
	icon_base = "whitedirtysolid"

/decl/flooring/tiling/oldtile/whiterustyplainsolid
	icon_base = "whiterustysolid"

/decl/flooring/tiling/oldtile/dark
	icon_base = "dark"

/decl/flooring/tiling/oldtile/darkdirtyplain
	icon_base = "darkdirty"

/decl/flooring/tiling/oldtile/darkrustyplain
	icon_base = "darkrusty"

/decl/flooring/tiling/oldtile/darkplainsolid
	icon_base = "darksolid"

/decl/flooring/tiling/oldtile/whitedirtyplainsolid
	icon_base = "darkdirtysolid"

/decl/flooring/tiling/oldtile/whiterustyplainsolid
	icon_base = "darkrustysolid"

/decl/flooring/tiling/oldtile/verydark
	icon_base = "verydark"


/decl/flooring/tiling/oldtile/redfull
	icon_base = "redfull"

/decl/flooring/tiling/oldtile/redfull/dirty
	icon_base = "reddirtyfull"

/decl/flooring/tiling/oldtile/redfull/rusty
	icon_base = "redrustyfull"

/decl/flooring/tiling/oldtile/redsolid
	icon_base = "redsolid"

/decl/flooring/tiling/oldtile/redsolid/dirty
	icon_base = "reddirtysolid"

/decl/flooring/tiling/oldtile/redsolid/rusty
	icon_base = "reddirtyfull"

/decl/flooring/tiling/oldtile/red
	icon_base = "red"

/decl/flooring/tiling/oldtile/red/dirty
	icon_base = "reddirty"

/decl/flooring/tiling/oldtile/red/rusty
	icon_base = "redrusty"

/decl/flooring/tiling/oldtile/redcorner
	icon_base = "redcorner"

/decl/flooring/tiling/oldtile/redcorner/dirty
	icon_base = "reddirtycorner"

/decl/flooring/tiling/oldtile/redcorner/rusty
	icon_base = "redrustycorner"

/decl/flooring/tiling/oldtile/redchess
	icon_base = "redchess"

/decl/flooring/tiling/oldtile/redchess/dirty
	icon_base = "reddirtychess"

/decl/flooring/tiling/oldtile/redchess/rusty
	icon_base = "redrustychess"

/decl/flooring/tiling/oldtile/redchess2
	icon_base = "redchess2"

/decl/flooring/tiling/oldtile/redchess2/dirty
	icon_base = "reddirtychess2"

/decl/flooring/tiling/oldtile/redchess2/rusty
	icon_base = "redrustychess2"

/decl/flooring/tiling/oldtile/greenfull
	icon_base = "greenfull"

/decl/flooring/tiling/oldtile/greenfull/dirty
	icon_base = "greendirtyfull"

/decl/flooring/tiling/oldtile/greenfull/rusty
	icon_base = "greenrustyfull"

/decl/flooring/tiling/oldtile/greensolid
	icon_base = "greensolid"

/decl/flooring/tiling/oldtile/greensolid/dirty
	icon_base = "greendirtysolid"

/decl/flooring/tiling/oldtile/greensolid/rusty
	icon_base = "greendirtyfull"

/decl/flooring/tiling/oldtile/green
	icon_base = "green"

/decl/flooring/tiling/oldtile/green/dirty
	icon_base = "greendirty"

/decl/flooring/tiling/oldtile/green/rusty
	icon_base = "greenrusty"

/decl/flooring/tiling/oldtile/greencorner
	icon_base = "greencorner"

/decl/flooring/tiling/oldtile/greencorner/dirty
	icon_base = "greendirtycorner"

/decl/flooring/tiling/oldtile/greencorner/rusty
	icon_base = "greenrustycorner"

/decl/flooring/tiling/oldtile/greenchess
	icon_base = "greenchess"

/decl/flooring/tiling/oldtile/greenchess/dirty
	icon_base = "greendirtychess"

/decl/flooring/tiling/oldtile/greenchess/rusty
	icon_base = "greenrustychess"

/decl/flooring/tiling/oldtile/greenchess2
	icon_base = "greenchess2"

/decl/flooring/tiling/oldtile/greenchess2/dirty
	icon_base = "greendirtychess2"

/decl/flooring/tiling/oldtile/greenchess2/rusty
	icon_base = "greenrustychess2"

/decl/flooring/tiling/oldtile/yellowfull
	icon_base = "yellowfull"

/decl/flooring/tiling/oldtile/yellowfull/dirty
	icon_base = "yellowdirtyfull"

/decl/flooring/tiling/oldtile/yellowfull/rusty
	icon_base = "yellowrustyfull"

/decl/flooring/tiling/oldtile/yellowsolid
	icon_base = "yellowsolid"

/decl/flooring/tiling/oldtile/yellowsolid/dirty
	icon_base = "yellowdirtysolid"

/decl/flooring/tiling/oldtile/yellowsolid/rusty
	icon_base = "yellowrustysolid"

/decl/flooring/tiling/oldtile/yellow
	icon_base = "yellow"

/decl/flooring/tiling/oldtile/yellow/dirty
	icon_base = "yellowdirty"

/decl/flooring/tiling/oldtile/yellow/rusty
	icon_base = "yellowrusty"

/decl/flooring/tiling/oldtile/yellowcorner
	icon_base = "yellowcorner"

/decl/flooring/tiling/oldtile/yellowcorner/dirty
	icon_base = "yellowdirtycorner"

/decl/flooring/tiling/oldtile/yellowcorner/rusty
	icon_base = "yellowrustycorner"

/decl/flooring/tiling/oldtile/yellowchess
	icon_base = "yellowchess"

/decl/flooring/tiling/oldtile/yellowchess/dirty
	icon_base = "yellowdirtychess"

/decl/flooring/tiling/oldtile/yellowchess/rusty
	icon_base = "yellowrustychess"

/decl/flooring/tiling/oldtile/yellowchess2
	icon_base = "yellowchess2"

/decl/flooring/tiling/oldtile/yellowchess2/dirty
	icon_base = "yellowdirtychess2"

/decl/flooring/tiling/oldtile/yellowchess2/rusty
	icon_base = "yellowrustychess2"

/decl/flooring/tiling/oldtile/bluefull
	icon_base = "bluefull"

/decl/flooring/tiling/oldtile/bluefull/dirty
	icon_base = "bluedirtyfull"

/decl/flooring/tiling/oldtile/bluefull/rusty
	icon_base = "bluerustyfull"

/decl/flooring/tiling/oldtile/bluesolid
	icon_base = "bluesolid"

/decl/flooring/tiling/oldtile/bluesolid/dirty
	icon_base = "bluedirtysolid"

/decl/flooring/tiling/oldtile/bluesolid/rusty
	icon_base = "bluedirtyfull"

/decl/flooring/tiling/oldtile/blue
	icon_base = "blue"

/decl/flooring/tiling/oldtile/blue/dirty
	icon_base = "bluedirty"

/decl/flooring/tiling/oldtile/blue/rusty
	icon_base = "bluerusty"

/decl/flooring/tiling/oldtile/bluecorner
	icon_base = "bluecorner"

/decl/flooring/tiling/oldtile/bluecorner/dirty
	icon_base = "bluedirtycorner"

/decl/flooring/tiling/oldtile/bluecorner/rusty
	icon_base = "bluerustycorner"

/decl/flooring/tiling/oldtile/bluechess
	icon_base = "bluechess"

/decl/flooring/tiling/oldtile/bluechess/dirty
	icon_base = "bluedirtychess"

/decl/flooring/tiling/oldtile/bluechess/rusty
	icon_base = "bluerustychess"

/decl/flooring/tiling/oldtile/bluechess2
	icon_base = "bluechess2"

/decl/flooring/tiling/oldtile/bluechess2/dirty
	icon_base = "bluedirtychess2"

/decl/flooring/tiling/oldtile/bluechess2/rusty
	icon_base = "bluerustychess2"

/decl/flooring/tiling/oldtile/purplefull
	icon_base = "purplefull"

/decl/flooring/tiling/oldtile/purplefull/dirty
	icon_base = "purpledirtyfull"

/decl/flooring/tiling/oldtile/purplefull/rusty
	icon_base = "purplerustyfull"

/decl/flooring/tiling/oldtile/purplesolid
	icon_base = "purplesolid"

/decl/flooring/tiling/oldtile/purplesolid/dirty
	icon_base = "purpledirtysolid"

/decl/flooring/tiling/oldtile/purplesolid/rusty
	icon_base = "purpledirtyfull"

/decl/flooring/tiling/oldtile/purple
	icon_base = "purple"

/decl/flooring/tiling/oldtile/purple/dirty
	icon_base = "purpledirty"

/decl/flooring/tiling/oldtile/purple/rusty
	icon_base = "purplerusty"

/decl/flooring/tiling/oldtile/purplecorner
	icon_base = "purplecorner"

/decl/flooring/tiling/oldtile/purplecorner/dirty
	icon_base = "purpledirtycorner"

/decl/flooring/tiling/oldtile/purplecorner/rusty
	icon_base = "purplerustycorner"

/decl/flooring/tiling/oldtile/purplechess
	icon_base = "purplechess"

/decl/flooring/tiling/oldtile/purplechess/dirty
	icon_base = "purpledirtychess"

/decl/flooring/tiling/oldtile/purplechess/rusty
	icon_base = "purplerustychess"

/decl/flooring/tiling/oldtile/purplechess2
	icon_base = "purplechess2"

/decl/flooring/tiling/oldtile/purplechess2/dirty
	icon_base = "purpledirtychess2"

/decl/flooring/tiling/oldtile/purplechess2/rusty
	icon_base = "purplerustychess2"

/decl/flooring/tiling/oldtile/neutralfull
	icon_base = "neutralfull"

/decl/flooring/tiling/oldtile/neutralfull/dirty
	icon_base = "neutraldirtyfull"

/decl/flooring/tiling/oldtile/neutralfull/rusty
	icon_base = "neutralrustyfull"

/decl/flooring/tiling/oldtile/neutralsolid
	icon_base = "neutralsolid"

/decl/flooring/tiling/oldtile/neutralsolid/dirty
	icon_base = "neutraldirtysolid"

/decl/flooring/tiling/oldtile/neutralsolid/rusty
	icon_base = "neutraldirtyfull"

/decl/flooring/tiling/oldtile/neutral
	icon_base = "neutral"

/decl/flooring/tiling/oldtile/neutral/dirty
	icon_base = "neutraldirty"

/decl/flooring/tiling/oldtile/neutral/rusty
	icon_base = "neutralrusty"

/decl/flooring/tiling/oldtile/neutralcorner
	icon_base = "neutralcorner"

/decl/flooring/tiling/oldtile/neutralcorner/dirty
	icon_base = "neutraldirtycorner"

/decl/flooring/tiling/oldtile/neutralcorner/rusty
	icon_base = "neutralrustycorner"

/decl/flooring/tiling/oldtile/neutralchess
	icon_base = "neutralchess"

/decl/flooring/tiling/oldtile/neutralchess/dirty
	icon_base = "neutraldirtychess"

/decl/flooring/tiling/oldtile/neutralchess/rusty
	icon_base = "neutralrustychess"

/decl/flooring/tiling/oldtile/neutralchess2
	icon_base = "neutralchess2"

/decl/flooring/tiling/oldtile/neutralchess2/dirty
	icon_base = "neutraldirtychess2"

/decl/flooring/tiling/oldtile/neutralchess2/rusty
	icon_base = "neutralrustychess2"

/decl/flooring/tiling/oldtile/whitered
	icon_base = "whitered"

/decl/flooring/tiling/oldtile/whitered/dirty
	icon_base = "whitereddirty"

/decl/flooring/tiling/oldtile/whitered/rusty
	icon_base = "whiteredrusty"

/decl/flooring/tiling/oldtile/whiteredcorner
	icon_base = "whiteredcorner"

/decl/flooring/tiling/oldtile/whiteredcorner/dirty
	icon_base = "whitereddirtycorner"

/decl/flooring/tiling/oldtile/whiteredcorner/rusty
	icon_base = "whiteredrustycorner"

/decl/flooring/tiling/oldtile/whiteredchess
	icon_base = "whiteredchess"

/decl/flooring/tiling/oldtile/whiteredchess/dirty
	icon_base = "whitereddirtychess"

/decl/flooring/tiling/oldtile/whiteredchess/rusty
	icon_base = "whiteredrustychess"

/decl/flooring/tiling/oldtile/whiteredchess2
	icon_base = "whiteredchess2"

/decl/flooring/tiling/oldtile/whiteredchess2/dirty
	icon_base = "whitereddirtychess2"

/decl/flooring/tiling/oldtile/whiteredchess2/rusty
	icon_base = "whiteredrustychess2"

/decl/flooring/tiling/oldtile/whitegreen/dirty
	icon_base = "whitegreen"

/decl/flooring/tiling/oldtile/whitegreen/dirty
	icon_base = "whitegreendirty"

/decl/flooring/tiling/oldtile/whitegreen/rusty
	icon_base = "whitegreenrusty"

/decl/flooring/tiling/oldtile/whitegreencorner
	icon_base = "whitegreencorner"

/decl/flooring/tiling/oldtile/whitegreencorner/dirty
	icon_base = "whitegreendirtycorner"

/decl/flooring/tiling/oldtile/whitegreencorner/rusty
	icon_base = "whitegreenrustycorner"

/decl/flooring/tiling/oldtile/whitegreenchess
	icon_base = "whitegreenchess"

/decl/flooring/tiling/oldtile/whitegreenchess/dirty
	icon_base = "whitegreendirtychess"

/decl/flooring/tiling/oldtile/whitegreenchess/rusty
	icon_base = "whitegreenrustychess"

/decl/flooring/tiling/oldtile/whitegreenchess2
	icon_base = "whitegreenchess2"

/decl/flooring/tiling/oldtile/whitegreenchess2/dirty
	icon_base = "whitegreendirtychess2"

/decl/flooring/tiling/oldtile/whitegreenchess2/rusty
	icon_base = "whitegreenrustychess2"

/decl/flooring/tiling/oldtile/whiteyellow
	icon_base = "whiteyellow"

/decl/flooring/tiling/oldtile/whiteyellow/dirty
	icon_base = "whiteyellowdirty"

/decl/flooring/tiling/oldtile/whiteyellow/rusty
	icon_base = "whiteyellowrusty"

/decl/flooring/tiling/oldtile/whiteyellowcorner
	icon_base = "whiteyellowcorner"

/decl/flooring/tiling/oldtile/whiteyellowcorner/dirty
	icon_base = "whiteyellowdirtycorner"

/decl/flooring/tiling/oldtile/whiteyellowcorner/rusty
	icon_base = "whiteyellowrustycorner"

/decl/flooring/tiling/oldtile/whiteyellowchess
	icon_base = "whiteyellowchess"

/decl/flooring/tiling/oldtile/whiteyellowchess/dirty
	icon_base = "whiteyellowdirtychess"

/decl/flooring/tiling/oldtile/whiteyellowchess/rusty
	icon_base = "whiteyellowrustychess"

/decl/flooring/tiling/oldtile/whiteyellowchess2
	icon_base = "whiteyellowchess2"

/decl/flooring/tiling/oldtile/whiteyellowchess2/dirty
	icon_base = "whiteyellowdirtychess2"

/decl/flooring/tiling/oldtile/whiteyellowchess2/rusty
	icon_base = "whiteyellowrustychess2"

/decl/flooring/tiling/oldtile/whiteblue
	icon_base = "whiteblue"

/decl/flooring/tiling/oldtile/whiteblue/dirty
	icon_base = "whitebluedirty"

/decl/flooring/tiling/oldtile/whiteblue/rusty
	icon_base = "whitebluerusty"

/decl/flooring/tiling/oldtile/whitebluecorner
	icon_base = "whitebluecorner"

/decl/flooring/tiling/oldtile/whitebluecorner/dirty
	icon_base = "whitebluedirtycorner"

/decl/flooring/tiling/oldtile/whitebluecorner/rusty
	icon_base = "whitebluerustycorner"

/decl/flooring/tiling/oldtile/whitebluechess
	icon_base = "whitebluechess"

/decl/flooring/tiling/oldtile/whitebluechess/dirty
	icon_base = "whitebluedirtychess"

/decl/flooring/tiling/oldtile/whitebluechess/rusty
	icon_base = "whitebluerustychess"

/decl/flooring/tiling/oldtile/whitebluechess2
	icon_base = "whitebluechess2"

/decl/flooring/tiling/oldtile/whitebluechess2/dirty
	icon_base = "whitebluedirtychess2"

/decl/flooring/tiling/oldtile/whitebluechess2/rusty
	icon_base = "whitebluerustychess2"

/decl/flooring/tiling/oldtile/whitepurple
	icon_base = "whitepurple"

/decl/flooring/tiling/oldtile/whitepurple/dirty
	icon_base = "whitepurpledirty"

/decl/flooring/tiling/oldtile/whitepurple/rusty
	icon_base = "whitepurplerusty"

/decl/flooring/tiling/oldtile/whitepurplecorner
	icon_base = "whitepurplecorner"

/decl/flooring/tiling/oldtile/whitepurplecorner/dirty
	icon_base = "whitepurpledirtycorner"

/decl/flooring/tiling/oldtile/whitepurplecorner/rusty
	icon_base = "whitepurplerustycorner"

/decl/flooring/tiling/oldtile/whitepurplechess
	icon_base = "whitepurplechess"

/decl/flooring/tiling/oldtile/whitepurplechess/dirty
	icon_base = "whitepurpledirtychess"

/decl/flooring/tiling/oldtile/whitepurplechess/rusty
	icon_base = "whitepurplerustychess"

/decl/flooring/tiling/oldtile/whitepurplechess2
	icon_base = "whitepurplechess2"

/decl/flooring/tiling/oldtile/whitepurplechess2/dirty
	icon_base = "whitepurpledirtychess2"

/decl/flooring/tiling/oldtile/whitepurplechess2/rusty
	icon_base = "whitepurplerustychess2"

/decl/flooring/tiling/oldtile/whiteneutral
	icon_base = "whiteneutral"

/decl/flooring/tiling/oldtile/whiteneutral/dirty
	icon_base = "whiteneutraldirty"

/decl/flooring/tiling/oldtile/whiteneutral/rusty
	icon_base = "whiteneutralrusty"

/decl/flooring/tiling/oldtile/whiteneutralcorner
	icon_base = "whiteneutralcorner"

/decl/flooring/tiling/oldtile/whiteneutralcorner/dirty
	icon_base = "whiteneutraldirtycorner"

/decl/flooring/tiling/oldtile/whiteneutralcorner/rusty
	icon_base = "whiteneutralrustycorner"

/decl/flooring/tiling/oldtile/whiteneutralchess
	icon_base = "whiteneutralchess"

/decl/flooring/tiling/oldtile/whiteneutralchess/dirty
	icon_base = "whiteneutraldirtychess"

/decl/flooring/tiling/oldtile/whiteneutralchess/rusty
	icon_base = "whiteneutralrustychess"

/decl/flooring/tiling/oldtile/whiteneutralchess2
	icon_base = "whiteneutralchess2"

/decl/flooring/tiling/oldtile/whiteneutralchess2/dirty
	icon_base = "whiteneutraldirtychess2"

/decl/flooring/tiling/oldtile/whiteneutralchess2/rusty
	icon_base = "whiteneutralrustychess2"

/decl/flooring/tiling/oldtile/dark/darkred
	icon_base = "darkred"

/decl/flooring/tiling/oldtile/dark/darkredcorner
	icon_base = "darkredcorner"

/decl/flooring/tiling/oldtile/dark/darkgreen
	icon_base = "darkgreen"

/decl/flooring/tiling/oldtile/dark/darkgreencorner
	icon_base = "darkgreencorner"

/decl/flooring/tiling/oldtile/dark/darkyellow
	icon_base = "darkyellow"

/decl/flooring/tiling/oldtile/dark/darkyellowcorner
	icon_base = "darkyellowcorner"

/decl/flooring/tiling/oldtile/dark/darkblue
	icon_base = "darkblue"

/decl/flooring/tiling/oldtile/dark/darkbluecorner
	icon_base = "darkbluecorner"

/decl/flooring/tiling/oldtile/dark/darkpurple
	icon_base = "darkpurple"

/decl/flooring/tiling/oldtile/dark/darkpurplecorner
	icon_base = "darkpurplecorner"

/decl/flooring/tiling/oldtile/dark/darkneutral
	icon_base = "darkneutral"

/decl/flooring/tiling/oldtile/dark/darkneutralcorner
	icon_base = "darkneutralcorner"

/decl/flooring/tiling/oldtile/unique/checker/redyellow
	icon_base = "redyellow"

/decl/flooring/tiling/oldtile/unique/checker/redyellowfull
	icon_base = "redyellowfull"

/decl/flooring/tiling/oldtile/unique/checker/redblue
	icon_base = "redblue"

/decl/flooring/tiling/oldtile/unique/checker/redbluefull
	icon_base = "redbluefull"

/decl/flooring/tiling/oldtile/unique/checker/redgreen
	icon_base = "redgreen"

/decl/flooring/tiling/oldtile/unique/checker/redgreenfull
	icon_base = "redgreenfull"

/decl/flooring/tiling/oldtile/unique/checker/greenyellow
	icon_base = "greenyellow"

/decl/flooring/tiling/oldtile/unique/checker/greenyellowfull
	icon_base = "greenyellowfull"

/decl/flooring/tiling/oldtile/unique/checker/greenblue
	icon_base = "greenblue"

/decl/flooring/tiling/oldtile/unique/checker/greenbluefull
	icon_base = "greenbluefull"

/decl/flooring/tiling/oldtile/unique/checker/blueyellow
	icon_base = "blueyellow"

/decl/flooring/tiling/oldtile/unique/checker/blueyellowfull
	icon_base = "blueyellowfull"




























/*unique*/

/decl/flooring/tiling/oldtile/unique/bar
	icon_base = "bar"

/decl/flooring/tiling/oldtile/unique/cafeteria
	icon_base = "cafeteria"

/decl/flooring/tiling/oldtile/unique/freezer
	icon_base = "freezer"

/decl/flooring/tiling/oldtile/unique/showroom
	icon_base = "showroom"

/decl/flooring/tiling/oldtile/unique/hydro
	icon_base = "hydro"

/decl/flooring/tiling/oldtile/unique/vault
	icon_base = "vault"











//==========MISC==============//

/decl/flooring/wood
	name = "wooden floor"
	desc = "Polished redwood planks."
	footstep_sound = "wood"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_base = "wood"
	has_damage_range = 6
	damage_temperature = T0C+200
	descriptor = "planks"
	build_type = /obj/item/stack/tile/wood
	smooth_nothing = TRUE
	flags = TURF_CAN_BREAK | TURF_CAN_BURN | TURF_IS_FRAGILE | TURF_REMOVE_SCREWDRIVER | TURF_HIDES_THINGS

/decl/flooring/wood/wild1
	icon_base = "wooden_floor_s1"
	build_type = /obj/item/stack/tile/wood/ashen/red

/decl/flooring/wood/wild2
	icon_base = "wooden_floor_s2"
	build_type = /obj/item/stack/tile/wood/ashen/dull

/decl/flooring/wood/wild3
	icon_base = "wooden_floor_s3"
	build_type = /obj/item/stack/tile/wood/ashen

/decl/flooring/wood/wild4
	icon_base = "wooden_floor_s4"
	build_type = /obj/item/stack/tile/wood/old

/decl/flooring/wood/wild5
	icon_base = "wooden_floor_s5"
	build_type = /obj/item/stack/tile/wood/old/veridical

/decl/flooring/wood/wood_old
	icon = 'icons/turf/flooring/wood_old.dmi'
	icon_base = "wood"
	build_type = /obj/item/stack/tile/wood/wood_old

/decl/flooring/reinforced
	name = "reinforced floor"
	desc = "Heavily reinforced with steel rods."
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_base = "reinforced"
	flags = TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS | TURF_REMOVE_WRENCH | TURF_ACID_IMMUNE | TURF_CAN_BURN | TURF_CAN_BREAK | TURF_HIDES_THINGS |TURF_HIDES_THINGS
	build_type = /obj/item/stack/rods
	build_cost = 2
	build_time = 30
	apply_thermal_conductivity = 0.025
	apply_heat_capacity = 325000
	can_paint = 1
	resistance = RESISTANCE_TOUGH
	footstep_sound = "plating"

/decl/flooring/reinforced/circuit
	name = "processing strata"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_base = "bcircuit"
	build_type = null
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS |TURF_HIDES_THINGS
	can_paint = 1

	floor_smooth = SMOOTH_NONE
	wall_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE

/decl/flooring/reinforced/circuit/green
	name = "processing strata"
	icon_base = "gcircuit"

/decl/flooring/reinforced/cult
	name = "engraved floor"
	desc = "Unsettling whispers waver from the surface..."
	icon = 'icons/turf/flooring/cult.dmi'
	icon_base = "cult"
	build_type = null
	has_damage_range = 6
	flags = TURF_ACID_IMMUNE | TURF_CAN_BREAK | TURF_HIDES_THINGS
	can_paint = null

//==========Derelict==============//

/decl/flooring/tiling/derelict
	name = "floor"
	icon_base = "derelict1"
	icon = 'icons/turf/flooring/derelict.dmi'
	footstep_sound = "floor"

/decl/flooring/tiling/derelict/white_red_edges
	name = "floor"
	icon_base = "derelict1"
	build_type = /obj/item/stack/tile/derelict/white_red_edges

/decl/flooring/tiling/derelict/white_small_edges
	name = "floor"
	icon_base = "derelict2"
	build_type = /obj/item/stack/tile/derelict/white_small_edges

/decl/flooring/tiling/derelict/red_white_edges
	name = "floor"
	icon_base = "derelict3"
	build_type = /obj/item/stack/tile/derelict/red_white_edges

/decl/flooring/tiling/derelict/white_big_edges
	name = "floor"
	icon_base = "derelict4"
	build_type = /obj/item/stack/tile/derelict/white_big_edges

/*Beach/Water*/

/decl/flooring/beach/sand
	name = "sand"
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "sand"
	flags = TURF_REMOVE_SHOVEL | TURF_CAN_BURN
	build_type = null
	footstep_sound = "asteroid"
	plating_type = /decl/flooring/dirt

/decl/flooring/beach/desert
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "desert"

/decl/flooring/beach/drywater
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "sand1"

/decl/flooring/beach/coastline
	icon = 'icons/turf/flooring/beach2.dmi'
	icon_base = "sandwater"

/decl/flooring/beach/water
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "water"
	resistance = RESISTANCE_TOUGH
	health = 9999999

/decl/flooring/beach/water/coastwater
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "beach"

/decl/flooring/beach/water/coastwatercorner
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "beachcorner"

/decl/flooring/beach/water/swamp
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "seashallow_swamp"
	footstep_sound = "water"

/decl/flooring/beach/water/jungle
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "seashallow_jungle1"
	footstep_sound = "water"

/decl/flooring/beach/water/flooded
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "seashallow_jungle2"
	footstep_sound = "water"

/decl/flooring/beach/water/ice
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "seashallow_frozen"
	footstep_sound = "water"

/decl/flooring/beach/water/ocean
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "seadeep"
	footstep_sound = "water"

/decl/flooring/beach/water/jungledeep
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "seashallow_jungle3"
	footstep_sound = "water"

/decl/flooring/beach/water/shallow
	icon = 'icons/turf/flooring/beach.dmi'
	icon_base = "seashallow"
	footstep_sound = "water"

/*Grass*/
/decl/flooring/grass
	name = "grass"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_base = "grass1"
	has_base_range = 3
	damage_temperature = T0C+80
	flags = TURF_REMOVE_SHOVEL | TURF_EDGES_EXTERNAL | TURF_HAS_CORNERS
	build_type = /obj/item/stack/tile/grass
	plating_type = /decl/flooring/dirt
	footstep_sound = "grass"
	floor_smooth = SMOOTH_NONE
	space_smooth = SMOOTH_NONE

/decl/flooring/grass2
	name = "grass"
	icon = 'icons/turf/flooring/grass.dmi'
	build_type = null
	footstep_sound = "grass"
	resistance = RESISTANCE_TOUGH
	plating_type = /decl/flooring/dirt

/decl/flooring/grass2/virgoforest
	icon_base = "grass-light"

/decl/flooring/grass2/virgoforestdark
	icon_base = "grass-dark"

/decl/flooring/grass/swampy
	icon_base = "swampy1"

/decl/flooring/grass2/sif
	icon_base = "grass_sif"

/decl/flooring/grass2/sifdark
	icon_base = "grass_sif_dark"

/decl/flooring/grass2/jungle
	icon_base = "grass_jungle"

/decl/flooring/grass2/snow_grass
	icon_base = "snowgrass_nes"

/decl/flooring/grass2/snowjungle
	icon_base = "snowjungle"

/decl/flooring/grass2/plowed_snow
	icon_base = "plowed_snow"

/decl/flooring/grass2/dry
	icon_base = "grass_dry"

/decl/flooring/grass2/colonial1
	icon_base = "cmgrass1"

/decl/flooring/grass2/colonial2
	icon_base = "cmgrass2"

/decl/flooring/grass2/colonial3
	icon_base = "cmgrass3"

/decl/flooring/grass2/colonialjungle1
	icon_base = "junglegrass1"

/decl/flooring/grass2/colonialjungle2
	icon_base = "junglegrass2"

/decl/flooring/grass2/colonialjungle3
	icon_base = "junglegrass3"

/decl/flooring/grass2/colonialjungle4
	icon_base = "junglegrass4"

/decl/flooring/grass2/colonialbeach
	icon_base = "grassbeach"

/decl/flooring/grass2/colonialbeach/corner
	icon_base = "gbcorner"

/*Dirt*/
/decl/flooring/dirt
	name = "dirt"
	icon = 'icons/turf/flooring/dirt.dmi'
	icon_base = "dirt1"
	build_type = null
	footstep_sound = "gravel"
	resistance = RESISTANCE_TOUGH
	health = 9999999

/decl/flooring/dirt/dark
	icon_base = "dirtnewdark"

/decl/flooring/dirt/rocky
	icon_base = "rocky1"

/decl/flooring/dirt/dark/plough
	icon_base = "dirt_ploughed"

/decl/flooring/dirt/flood
	icon_base = "flood_dirt"

/decl/flooring/dirt/flood/plough
	icon_base = "flood_dirt_ploughed"

/decl/flooring/dirt/dust
	icon_base = "dust"

/decl/flooring/dirt/ground
	icon_base = "desert"

/decl/flooring/dirt/coast
	icon_base = "dirtbeach"

/decl/flooring/dirt/coast/corner
	icon_base = "dirtbeachcorner1"

/decl/flooring/dirt/coast/corner2
	icon_base = "dirtbeachcorner2"

/decl/flooring/dirt/burned
	icon_base = "burned_dirt"

/decl/flooring/dirt/mud
	icon_base = "mud_dark"

/decl/flooring/dirt/mud/light
	icon_base = "mud_light"

/*Rock*/
/decl/flooring/rock
	name = "rock"
	icon = 'icons/turf/flooring/dirt.dmi'
	icon_base = "rock"
	build_type = null
	footstep_sound = "gravel"
	resistance = RESISTANCE_TOUGH
	health = 9999999

/decl/flooring/rock/alt
	icon_base = "rock_alt"

/decl/flooring/rock/grey
	icon_base = "rock_grey"

/decl/flooring/rock/dark
	icon_base = "rock_dark"

/decl/flooring/rock/old
	icon_base = "rock_old"

/decl/flooring/rock/manmade/ruin1
	icon_base = "stone_old"

/decl/flooring/rock/manmade/ruin2
	icon_base = "stone_old1"

/decl/flooring/rock/manmade/ruin3
	icon_base = "stone_old2"

/decl/flooring/rock/seafloor
	icon_base = "seafloor"

/decl/flooring/rock/manmade/concrete
	icon_base = "concrete6"

/decl/flooring/rock/manmade/concrete/pavement
	icon_base = "pavement"

/decl/flooring/rock/manmade/concrete/pavement/edge
	icon_base = "pavement_edge"

/decl/flooring/rock/manmade/concrete/pavement/corner
	icon_base = "pavement_corner"

/decl/flooring/rock/manmade/concrete/pavement/brick
	icon_base = "pavement_brick"

/decl/flooring/rock/manmade/concrete/pavement/tile
	icon_base = "pavement_tile"

/decl/flooring/rock/manmade/concrete/pavement/stairs
	icon_base = "pavement_stairs"

/decl/flooring/rock/manmade/concrete/pavement/dirt
	icon_base = "pavement_dirt"

/decl/flooring/rock/manmade/concrete/tile
	icon_base = "contile"

/decl/flooring/rock/manmade/concrete/tile/edge
	icon_base = "contileedge"

/decl/flooring/rock/manmade/concrete/tile/corner
	icon_base = "contilecorner"

/decl/flooring/rock/manmade/asphalt
	icon_base = "asphalt"

/decl/flooring/rock/manmade/gravel
	icon_base = "gravel"

/decl/flooring/rock/manmade/road
	icon_base = "road_1"

/*POOL - basic pool tile details*/
/decl/flooring/pool
	name = "poolwater"
	icon = 'icons/turf/flooring/tiles_white.dmi'
	icon_base = "tiles"
	build_type = null
	footstep_sound = "water"
	resistance = RESISTANCE_TOUGH
	health = 9999999