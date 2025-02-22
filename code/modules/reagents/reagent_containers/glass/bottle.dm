//Not to be confused with /obj/item/reagent_containers/food/drinks/bottle

/obj/item/reagent_containers/glass/bottle
	name = "bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle"
	item_state = "atoxinbottle"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60)
	volume = 60
	filling_states = "20;60;100"
	label_icon_state = "label_bottle"

/obj/item/reagent_containers/glass/bottle/update_icon()
	cut_overlays()

	if(has_lid())
		var/lid_icon = lid_icon_state ? lid_icon_state : "lid_[icon_state]"
		var/mutable_appearance/lid = mutable_appearance(icon, lid_icon)
		add_overlay(lid)

	if(label_text)
		var/label_icon = label_icon_state ? label_icon_state : "label_[icon_state]"
		var/mutable_appearance/label = mutable_appearance(icon, label_icon)
		add_overlay(label)

	if(reagents.total_volume)
		if(label_text)
			var/mutable_appearance/filling = mutable_appearance('icons/obj/reagentfillings.dmi', "[icon_state]_labeled-[get_filling_state()]")
			filling.color = reagents.get_color()
			add_overlay(filling)
		else
			var/mutable_appearance/filling = mutable_appearance('icons/obj/reagentfillings.dmi', "[icon_state]-[get_filling_state()]")
			filling.color = reagents.get_color()
			add_overlay(filling)

/obj/item/reagent_containers/glass/bottle/inaprovaline
	name = "inaprovaline bottle"
	desc = "A small bottle. Contains inaprovaline - used to stabilize patients."
	icon_state = "bottle"
	preloaded_reagents = list("inaprovaline" = 60)

/obj/item/reagent_containers/glass/bottle/toxin
	name = "toxin bottle"
	desc = "A small bottle of toxins. Do not drink, it is poisonous."
	icon_state = "bottle"
	preloaded_reagents = list("toxin" = 60)

/obj/item/reagent_containers/glass/bottle/cyanide
	name = "cyanide bottle"
	desc = "A small bottle of cyanide. Bitter almonds?"
	icon_state = "bottle"
	preloaded_reagents = list("cyanide" = 30)

/obj/item/reagent_containers/glass/bottle/stoxin
	name = "soporific bottle"
	desc = "A small bottle of soporific. Just the fumes make you sleepy."
	icon_state = "bottle"
	preloaded_reagents = list("stoxin" = 60)

/obj/item/reagent_containers/glass/bottle/chloralhydrate
	name = "chloral hydrate bottle"
	desc = "A small bottle of chloral hydrate. Mickey's Favorite!"
	icon_state = "bottle"
	preloaded_reagents = list("chloralhydrate" = 30)

/obj/item/reagent_containers/glass/bottle/antitoxin
	name = "dylovene bottle"
	desc = "A small bottle of dylovene. Counters poisons, and repairs damage. A wonder drug."
	icon_state = "bottle"
	preloaded_reagents = list("anti_toxin" = 60)

/obj/item/reagent_containers/glass/bottle/mutagen
	name = "unstable mutagen bottle"
	desc = "A small bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."
	icon_state = "bottle"
	preloaded_reagents = list("mutagen" = 60)

/obj/item/reagent_containers/glass/bottle/ammonia
	name = "ammonia bottle"
	desc = "A small bottle."
	icon_state = "bottle"
	preloaded_reagents = list("ammonia" = 60)

/obj/item/reagent_containers/glass/bottle/diethylamine
	name = "diethylamine bottle"
	desc = "A small bottle."
	icon_state = "bottle"
	preloaded_reagents = list("diethylamine" = 60)

/obj/item/reagent_containers/glass/bottle/pacid
	name = "polytrinic acid bottle"
	desc = "A small bottle. Contains a small amount of polytrinic acid."
	icon_state = "bottle"
	preloaded_reagents = list("pacid" = 60)

/obj/item/reagent_containers/glass/bottle/capsaicin
	name = "capsaicin bottle"
	desc = "A small bottle. Contains hot sauce."
	icon_state = "bottle"
	preloaded_reagents = list("capsaicin" = 60)

/obj/item/reagent_containers/glass/bottle/frostoil
	name = "frost oil bottle"
	desc = "A small bottle. Contains cold sauce."
	icon_state = "bottle"
	preloaded_reagents = list("frostoil" = 60)

/obj/item/reagent_containers/glass/bottle/tricord
	name = "tricordrazine bottle"
	desc = "A small bottle. Contains Tricordrazine, a mild all-around healing agent."
	icon_state = "bottle"
	preloaded_reagents = list("tricordrazine" = 60)

/obj/item/reagent_containers/glass/bottle/adminordrazine
	name = "adminordrazine bottle"
	desc = "A small bottle. Contains the liquid essence of the gods."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "holyflask"
	preloaded_reagents = list("adminordrazine" = 60)

/obj/item/reagent_containers/glass/bottle/petrel
	name = "diesel canister"
	desc = "A small canister. Contains liquid diesel, useful for powering diesel generators or making fire bombs."
	icon_state = "canister"
	possible_transfer_amounts = list(5,10,15,25,30,60,120)
	volume = 120
	matter = list(MATERIAL_PLASTIC = 1)
	preloaded_reagents = list("fuel" = 120)

/obj/item/reagent_containers/glass/bottle/tangu_extract
	name = "tangu extract bottle"
	desc = "A small bottle. Contains the extract of a tangu horn, a highly valuable universal healing chemical."
	icon_state = "bottle"
	preloaded_reagents = list("tangu_extract" = 60)

/obj/item/reagent_containers/glass/bottle/clucker_extract
	name = "clucker extract bottle"
	desc = "A small bottle. Contains the extract of a compressed clucker feather, a rather weak painkiller."
	icon_state = "bottle"
	preloaded_reagents = list("clucker_extract" = 60)

/obj/item/reagent_containers/glass/bottle/tahcacillin
	name = "tahcacillin bottle"
	desc = "A small bottle. Contains a derived extract of blood mixed with tahca horns, a powerful anti-viral for dealing with diseases and infection when injected into the bloodstream."
	icon_state = "bottle"
	preloaded_reagents = list("tahcacillin" = 60)

/obj/item/reagent_containers/glass/bottle/organic
	name = "resin bottle"
	desc = "A small bottle made of organic resin with a small bark-like lid."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle_b"
	item_state = "atoxinbottle"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60)
	volume = 60
	filling_states = "20;40;60;80;100"
	label_icon_state = "bottle_b_labeled"
	lid_icon_state = "lid_bottle_b"

/obj/item/reagent_containers/glass/bottle/organic/dexalinp
	preloaded_reagents = list("dexalinp" = 60)

/obj/item/reagent_containers/glass/bottle/organic/haloperidol
	preloaded_reagents = list("haloperidol" = 60)

/obj/item/reagent_containers/glass/bottle/organic/hyronalin
	preloaded_reagents = list("hyronalin" = 60)

/obj/item/reagent_containers/glass/bottle/organic/vermicetol
	preloaded_reagents = list("vermicetol" = 60)

/obj/item/reagent_containers/glass/bottle/organic/dermaline
	preloaded_reagents = list("dermaline" = 60)

/obj/item/reagent_containers/glass/bottle/organic/kelotane
	preloaded_reagents = list("kelotane" = 60)

/obj/item/reagent_containers/glass/bottle/organic/peridaxon
	preloaded_reagents = list("peridaxon" = 60)

/obj/item/reagent_containers/glass/bottle/organic/varceptol
	preloaded_reagents = list("varceptol" = 60)

/obj/item/reagent_containers/glass/bottle/organic/oxycodone
	preloaded_reagents = list("oxycodone" = 60)

/obj/item/reagent_containers/glass/bottle/organic/tricordrazine
	preloaded_reagents = list("tricordrazine" = 60)

/obj/item/reagent_containers/glass/bottle/organic/meralyne
	preloaded_reagents = list("meralyne" = 60)

/obj/item/reagent_containers/glass/bottle/organic/dermatane
	preloaded_reagents = list("dermaline" = 30, "kelotane" = 30)

// === Used by trade stations
/obj/item/reagent_containers/glass/bottle/carpotoxin
	name = "carpotoxin bottle"
	desc = "A small bottle. Contains carpotoxin."
	icon_state = "bottle"
	preloaded_reagents = list("carpotoxin" = 60)

/obj/item/reagent_containers/glass/bottle/pararein
	name = "pararein bottle"
	desc = "A small bottle. Contains pararein."
	icon_state = "bottle"
	preloaded_reagents = list("pararein" = 60)

/obj/item/reagent_containers/glass/bottle/aranecolmin
	name = "aranecolmin bottle"
	desc = "A small bottle. Contains aranecolmin."
	icon_state = "bottle"
	preloaded_reagents = list("aranecolmin" = 60)

/obj/item/reagent_containers/glass/bottle/blattedin
	name = "blattedin bottle"
	desc = "A small bottle. Contains blattedin."
	icon_state = "bottle"
	preloaded_reagents = list("blattedin" = 60)

/obj/item/reagent_containers/glass/bottle/diplopterum
	name = "diplopterum bottle"
	desc = "A small bottle. Contains diplopterum."
	icon_state = "bottle"
	preloaded_reagents = list("diplopterum" = 60)

/obj/item/reagent_containers/glass/bottle/seligitillin
	name = "seligitillin bottle"
	desc = "A small bottle. Contains seligitillin."
	icon_state = "bottle"
	preloaded_reagents = list("seligitillin" = 60)

/obj/item/reagent_containers/glass/bottle/starkellin
	name = "starkellin bottle"
	desc = "A small bottle. Contains starkellin."
	icon_state = "bottle"
	preloaded_reagents = list("starkellin" = 60)

/obj/item/reagent_containers/glass/bottle/gewaltine
	name = "gewaltine bottle"
	desc = "A small bottle. Contains gewaltine."
	icon_state = "bottle"
	preloaded_reagents = list("gewaltine" = 60)

/obj/item/reagent_containers/glass/bottle/fuhrerole
	name = "fuhrerole bottle"
	desc = "A small bottle. Contains fuhrerole."
	icon_state = "bottle"
	preloaded_reagents = list("fuhrerole" = 60)

// ===

/obj/item/reagent_containers/glass/bottle/trade

/obj/item/reagent_containers/glass/bottle/trade/New()
	for(var/reagent_id in preloaded_reagents)
		var/reagent_name = lowertext(get_reagent_name_by_id(reagent_id))
		name = "[reagent_name] bottle"
		desc = "A small bottle. Contains [reagent_name]."
	..()

// === Used by trade stations
/obj/item/reagent_containers/glass/bottle/trade/clonexadone
	preloaded_reagents = list("clonexadone" = 60)

/obj/item/reagent_containers/glass/bottle/trade/imidazoline
	preloaded_reagents = list("imidazoline" = 60)

/obj/item/reagent_containers/glass/bottle/trade/alkysine
	preloaded_reagents = list("alkysine" = 60)

/obj/item/reagent_containers/glass/bottle/trade/bicaridine
	preloaded_reagents = list("bicaridine" = 60)

/obj/item/reagent_containers/glass/bottle/trade/kelotane
	preloaded_reagents = list("kelotane" = 60)

/obj/item/reagent_containers/glass/bottle/trade/carpotoxin
	preloaded_reagents = list("carpotoxin" = 60)

/obj/item/reagent_containers/glass/bottle/trade/pararein
	preloaded_reagents = list("pararein" = 60)

/obj/item/reagent_containers/glass/bottle/trade/aranecolmin
	preloaded_reagents = list("aranecolmin" = 60)

/obj/item/reagent_containers/glass/bottle/trade/blattedin
	preloaded_reagents = list("blattedin" = 60)

/obj/item/reagent_containers/glass/bottle/trade/diplopterum
	preloaded_reagents = list("diplopterum" = 60)

/obj/item/reagent_containers/glass/bottle/trade/seligitillin
	preloaded_reagents = list("seligitillin" = 60)

/obj/item/reagent_containers/glass/bottle/trade/starkellin
	preloaded_reagents = list("starkellin" = 60)

/obj/item/reagent_containers/glass/bottle/trade/gewaltine
	preloaded_reagents = list("gewaltine" = 60)

/obj/item/reagent_containers/glass/bottle/trade/fuhrerole
	preloaded_reagents = list("fuhrerole" = 60)

/obj/item/reagent_containers/glass/bottle/trade/kaiseraurum
	preloaded_reagents = list("kaiseraurum" = 60)
// ===
