/datum/job/assistant
	title = "Resident"
	flag = ASSISTANT
	department = DEPARTMENT_CIVILIAN
	department_flag = CIVILIAN
	faction = MAP_FACTION
	total_positions = -1
	spawn_positions = -1
	supervisors = "anyone who pays you"
	difficulty = "Very Easy."
	selection_color = "#dddddd"
	initial_balance = 800
	wage = WAGE_NONE //Get a job ya lazy bum
	//alt_titles = list("Visitor", "Refugee","Guild Novice","Soteria Intern","Lonestar Intern")
	ideal_character_age = null

	outfit_type = /decl/hierarchy/outfit/job/assistant

	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

	description = "The ideal newcomer role. You have no official position within the outpost, or are off-duty. You will not be paid a wage.<br>\
Where did you come from? Why are you here? These things are up to you.<br>\
<br>\
Perhaps you're a traveller driven by wanderlust, eager to experience life on the edge. Will it prove a warm thrill or harsh awakening?<br>\
Perhaps you're a pioneer on a mission to find something of value. Will this elevate you to greatness, or prove your downfall?<br>\
Perhaps you're a apprentice or intern. What exciting career are you pursuing, and will you realise your aspirations?<br>\
Perhaps you're a friend or relative of an existing character of the frontier. How can you best support them?<br>\
Perhaps you're a fugitive looking for respite far from the all-seeing eye of the Capital. What did you do to warrant such trouble?<br>\
Perhaps you don't even know who you are, your memories lost to the void. Will your identity be reclaimed, or a new one forged?<br>\
<br>\
Your story is yours to write. What matters is that you're here now - find some purpose.<br>\
To form connections, strive to help out anyone you can. Or at least, anyone who offers you a paying job.<br>\
Find a way to make money, stay out of trouble, and survive."

/obj/landmark/join/start/assistant
	name = "Resident"
	icon_state = "player-grey"
	join_tag = /datum/job/assistant
