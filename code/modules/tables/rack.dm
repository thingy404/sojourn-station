/obj/structure/table/rack
	name = "rack"
	desc = "Different from the medieval version."
	icon = 'icons/obj/objects.dmi'
	icon_state = "rack"
	can_plate = 0
	can_reinforce = 0
	flipped = -1

/obj/structure/table/rack/New()
	..()
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put

/obj/structure/table/rack/update_connections()
	return

/obj/structure/table/rack/update_desc()
	return

/obj/structure/table/rack/update_icon()
	return

/obj/structure/table/rack/shelf
	name = "shelf"
	desc = "For showing off your collections of dust, electronics, the heads of your enemies and tools."
	icon_state = "shelf"

/obj/structure/table/rack/diesel/wood
	name = "table"
	desc = "A rugged table constructed from solid wood."
	icon_state = "diesel1"

/obj/structure/table/rack/diesel/ornate
	name = "table"
	desc = "An ornate side table of fine craftsmanship."
	icon_state = "diesel2"

/obj/structure/table/rack/diesel/shelf
	name = "shelf"
	desc = "A wooden shelving unit. Looks sturdy enough."
	icon_state = "diesel3"

/obj/structure/table/rack/diesel/counter
	name = "counter"
	desc = "A relatively slim wooden counter."
	icon_state = "diesel4"

/obj/structure/table/rack/diesel/counterend
	name = "counter"
	desc = "A relatively slim wooden counter."
	icon_state = "diesel5"

/obj/structure/table/rack/diesel/wood2
	name = "table"
	desc = "A rugged table constructed from solid wood."
	icon_state = "diesel6"

/obj/structure/table/rack/diesel/wood3
	name = "table"
	desc = "A rugged table constructed from solid wood."
	icon_state = "diesel7"

/obj/structure/table/rack/diesel/wood4
	name = "table"
	desc = "A rugged table constructed from solid wood."
	icon_state = "diesel8"

