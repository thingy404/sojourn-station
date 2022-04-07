/obj/structure/lamp_post
	name = "lamp post"
	desc = "A sturdy street light illuminating the darkness."
	icon = 'icons/obj/lamp_post.dmi'
	icon_state = "nvlamp-singles"

	light_color = "#a8a582"
	light_power = 0
	light_range = 0
	var/on_power = 0.8
	var/on_range = 4.5

	layer = GASFIRE_LAYER
	anchored = TRUE
	opacity = 0
	density = TRUE

	pixel_x = -32

/obj/structure/lamp_post/doubles
	icon_state = "nvlamp-straight-doubles"

/obj/structure/lamp_post/doubles/bent
	icon_state = "nvlamp-corner-doubles"

/obj/structure/lamp_post/triples
	icon_state = "nvlamp-tripples"

/obj/structure/lamp_post/quadra
	icon_state = "nvlamp-quadra"