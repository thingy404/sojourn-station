/datum/job/smc
	title = "Militia Captain"
	flag = SMC
	head_position = 1
	department = DEPARTMENT_SECURITY
	department_flag = SECURITY | COMMAND
	faction = MAP_FACTION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Council"
	difficulty = "Very Hard."
	selection_color = "#97b0be"
	req_admin_notify = 1
	wage = WAGE_COMMAND
	ideal_character_age = 40
	minimum_character_age = 30
	department_account_access = TRUE
	playtimerequired = 1200

	outfit_type = /decl/hierarchy/outfit/job/security/smc

	access = list(
		access_security, access_eva, access_sec_doors, access_brig, access_armory, access_medspec,
		access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
		access_moebius, access_engine, access_mining, access_construction, access_mailsorting,
		access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway,
		access_external_airlocks, access_research_equipment, access_prospector, access_medical, access_kitchen, access_medical_suits
	)

	stat_modifiers = list(
		STAT_ROB = 30,
		STAT_TGH = 40,
		STAT_VIG = 40,
	)

	perks = list(/datum/perk/ass_of_concrete,
				 /datum/perk/job/blackshield_conditioning,
				 /datum/perk/job/bolt_reflect,
				 /datum/perk/codespeak,
				 /datum/perk/chem_contraband)

	software_on_spawn = list(/datum/computer_file/program/comm,
							 /datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/reports)

	description = "The Militia Captain serves as the commander of the local regiment of the Commonwealth Militia Brotherhood.<br>\
	While not officially recognised by the Amerethi Commonwealth, the CMB strives to protect the residents of the frontier.<br>\
	Your goal is to maintain some semblance of law and order, serving as part of an efficient police and military force.<br>\
	The Sergeant-At-Arms oversees day-to-day operations in the precinct and jail, and you should work closely with them."

	duties = "Coordinate militia in the field, assigning them to threats and distress calls as needed.<br>\
		Work with the Sergeant-At-Arms to allocate funds to supply your teams with whatever munitions or equipment they need.<br>\
		Plan assaults on entrenched threats, ensure your teams know their roles and carry them out precisely.<br>\
		Oversee performance of the militia under your command and punish any that are insubordinate or incompetent.<br>\
		Advise the council on threats to outpost security and advise them towards choices that will minimise exposure to threats."

/obj/landmark/join/start/smc
	name = "Militia Captain"
	icon_state = "player-blue-officer"
	join_tag = /datum/job/smc





/datum/job/swo
	title = "Sergeant-At-Arms"
	flag = SWO
	head_position = 1
	department = DEPARTMENT_SECURITY
	department_flag = SECURITY | COMMAND
	faction = MAP_FACTION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Council"
	difficulty = "Very Hard."
	selection_color = "#97b0be"
	req_admin_notify = 1
	wage = WAGE_COMMAND
	ideal_character_age = 40
	minimum_character_age = 30
	department_account_access = TRUE
	playtimerequired = 1200

	outfit_type = /decl/hierarchy/outfit/job/security/swo

	access = list(
		access_security, access_eva, access_sec_doors, access_brig, access_armory, access_medspec,
		access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
		access_moebius, access_engine, access_mining, access_construction, access_mailsorting,
		access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_sec_shop,
		access_external_airlocks, access_research_equipment, access_prospector, access_tcomsat, access_kitchen, access_medical_suits
	)

	stat_modifiers = list(
		STAT_ROB = 40,
		STAT_TGH = 40,
		STAT_VIG = 30,
	)

	perks = list(/datum/perk/ass_of_concrete,
				 /datum/perk/job/bolt_reflect,
				 /datum/perk/codespeak,
				 /datum/perk/chem_contraband)

	software_on_spawn = list(/datum/computer_file/program/comm,
							 /datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/reports)

	description = "The Sergeant-At-Arms serves as the head officer of the local regiment of the Commonwealth Militia Brotherhood.<br>\
	While not officially recognised by the Amerethi Commonwealth, the CMB strives to protect the residents of the frontier.<br>\
	Your goal is to maintain some semblance of law and order, serving as part of an efficient police and military force.<br>\
	The Militia Commander oversees the security of the colony as a whole, and you should work closely with them."

	duties = "Coordinate militia around the outpost, assigning them to tasks and distress calls as needed.<br>\
		Work with the Militia Commander to allocate funds to supply your teams with whatever armor, supplies, weapons, munitions, or tools they need.<br>\
		Keep the peace around the colony and ensure your teams know their roles and carry them out precisely.<br>\
		Oversee performance of militia under your command and punish any that are insubordinate or incompetent.<br>\
		Advise the council on threats to outpost security and advise them towards choices that will uphold the public trust."

/obj/landmark/join/start/swo
	name = "Sergeant-At-Arms"
	icon_state = "player-blue-officer"
	join_tag = /datum/job/swo





/datum/job/supsec
	title = "Armorer"
	flag = SUPSEC
	department = DEPARTMENT_SECURITY
	department_flag = SECURITY
	faction = MAP_FACTION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Warrant Officer"
	difficulty = "Hard."
	selection_color = "#a7bbc6"
	department_account_access = TRUE
	wage = WAGE_LABOUR_HAZARD
	minimum_character_age = 25

	outfit_type = /decl/hierarchy/outfit/job/security/gunserg

	access = list(
		access_security, access_moebius, access_medspec, access_engine, access_mailsorting,
		access_eva, access_sec_doors, access_brig, access_armory, access_maint_tunnels, access_morgue,
		access_external_airlocks, access_research_equipment, access_prospector, access_kitchen, access_medical_suits, access_sec_shop, access_forensics_lockers
	)

	stat_modifiers = list(
		STAT_ROB = 25,
		STAT_TGH = 25,
		STAT_VIG = 25,
	)

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)

	perks = list(/datum/perk/market_prof,
				 /datum/perk/codespeak,
				 /datum/perk/chem_contraband)

	description = "The Armorer is the right hand of the Sergeant-At-Arms, and the defacto controller of the armory.<br>\
	While not officially recognised by the Amerethi Commonwealth, the CMB strives to protect the residents of the frontier.<br>\
	Your goal is to maintain some semblance of law and order, serving as part of an efficient police and military force.<br>\
	This role is mainly a desk job, managing incoming and outgoing armory equipment with an iron grip."

	duties = "Manage a good balance of armory stock, and dispense responsibly with a paper trail and fair price.<br>\
	Serve as an on-site weapon instructor in quieter moments, performing training drills and other exercises.<br>\
	Adapt to any other internal duties delegated to you by the Sergeant-At-Arms."

/obj/landmark/join/start/supsec
	name = "Armorer"
	icon_state = "player-blue"
	join_tag = /datum/job/supsec





/datum/job/inspector
	title = "Ranger"
	flag = INSPECTOR
	department = DEPARTMENT_SECURITY
	department_flag = SECURITY
	faction = MAP_FACTION
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Warrant Officer"
	difficulty = "Hard."
	selection_color = "#a7bbc6"
	wage = WAGE_PROFESSIONAL

	outfit_type = /decl/hierarchy/outfit/job/security/inspector

	access = list(
		access_security, access_moebius, access_medspec, access_engine, access_mailsorting,
		access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels,
		access_external_airlocks, access_prospector, access_brig, access_kitchen, access_medical_suits
	)

	perks = list(/datum/perk/ear_of_quicksilver,
				 /datum/perk/codespeak,
				 /datum/perk/chem_contraband)

	stat_modifiers = list(
		STAT_BIO = 15,
		STAT_ROB = 15,
		STAT_TGH = 15,
		STAT_VIG = 25,
	)

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/audio,
							 /datum/computer_file/program/camera_monitor)

	description = "The Ranger is the colony detective and field agent, taking on cases and suspects that aren't always what they seem.<br>\
	Your job is to interrogate suspects, gather witness statements,  harvest evidence and reach a conclusion about the nature and culprit of a crime.<br>\
	You are a higher ranking position than officers and operatives and can determine if charges are valid and may release individuals for lack of evidence. <br>\
	However, you cannot give orders outside those pertaining to charges and arrests. The warrant officer still outranks you - bring all conflicts to them.<br>\
	When there are no outstanding cases, look for them. Mingle with civilians, interact and converse, sniff out leads about potential criminal activity."

	duties = "Interview suspects and witnesses after a crime. Record important details of their statements, and look for inconsistencies.<br>\
		Gather evidence and bring it back for processing.<br>\
		Send out officers to bring suspects in for questioning.<br>\
		Interact with civilians and be on the lookout for criminal activity."

/obj/landmark/join/start/inspector
	name = "Ranger"
	icon_state = "player-blue"
	join_tag = /datum/job/inspector





/datum/job/templar
	title = "Templar"
	flag = TROOPER
	department = DEPARTMENT_SECURITY
	department_flag = SECURITY
	faction = MAP_FACTION
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Blackshield Commander"
	difficulty = "Hard."
	selection_color = "#a7bbc6"
	wage = WAGE_LABOUR_HAZARD

	outfit_type = /decl/hierarchy/outfit/job/security/troop

	perks = list(/datum/perk/job/bolt_reflect, /datum/perk/job/blackshield_conditioning, /datum/perk/chem_contraband)

	access = list(
		access_security, access_eva,
		access_sec_doors, access_brig, access_maint_tunnels, access_external_airlocks
	)

	stat_modifiers = list(
		STAT_ROB = 25,
		STAT_TGH = 20,
		STAT_VIG = 25,
	)

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)

	description = "The Trooper forms the base of the Blackshield, the front line against pirates, terrorists, and xenos.<br>\
	You are the closest thing to a professional soldier the colony has. Employ your talents to bring an end to threats and conflict situations.<br>\
	Tactics and teamwork are vital. You are paid to follow orders, not to think. Remember your focus on external threats - leave otherwise to Marshals.<br>\
	When there are no standing orders, your ongoing task is to patrol and be on the lookout for threats or problems. Help the Marshals if explicitly asked. <br>\
	Watch the main gate and perimeter. You have access to most places to help with your duties - do not abuse this."

	duties = "Patrol the colony, provide a security presence, and look for trouble.<br>\
		Deal with external threats to the colony such as pirates, hostile xenos, and anything that endangers colonists.<br>\
		Exterminate monsters, giant vermin and hostile machines.<br>\
		Follow orders from the chain of command.<br>\
		Obey the law. You are not above it."

/obj/landmark/join/start/templar
	name = "Templar"
	icon_state = "player-blue"
	join_tag = /datum/job/trooper





/datum/job/medspec
	title = "Corpsman"
	flag = MEDSPEC
	department = DEPARTMENT_SECURITY
	department_flag = SECURITY
	faction = MAP_FACTION
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Blackshield Commander"
	difficulty = "Hard."
	selection_color = "#a7bbc6"
	wage = WAGE_PROFESSIONAL

	outfit_type = /decl/hierarchy/outfit/job/security/medspec

	access = list(
		access_security, access_sec_doors, access_medspec, access_morgue, access_maint_tunnels,
		access_medical_equip, access_eva, access_brig, access_external_airlocks, access_surgery, access_medical_suits
	)

	stat_modifiers = list(
		STAT_BIO = 30,
		STAT_TGH = 10,
		STAT_VIG = 15,
		STAT_ROB = 10,
	)

	perks = list(/datum/perk/medicalexpertise)
				// /datum/perk/chemist -Thanos Voice: "I'm sorry little one..."

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/chem_catalog,
							 /datum/computer_file/program/camera_monitor)

	description = "The Corpsman is a highly trained medical specialist within the Blackshield - a mixture of combatant and doctor.<br>\
	Your first duty is that of a field medic. Serve on the back line of any combat situations, treating the wounded and evacuating the critical.<br>\
	Your second duty is to treat any prisoners and suspects in custody. Wounds from escape and suicide attempts will test your surgical skills.<br>\
	Your third duty, when faced with strange crimes, is to serve as a scientific analyst - scanning traces and conducting autopsies.<br>\
	Remember that although you can be armed, the combat is better left to your colleagues. Focus on the tasks only you can do."

	duties = "Minimize casualties in combat situations and treat all related wounds.<br>\
	Treat any prisoners and suspects, and thoroughly monitor their health.<br>\
	Work with the Ranger to solve crimes through collecting forensic evidence and conducting autopsies.<br>\
	<b>While you are sufficiently medically trained, you are not a replacement doctor for Soteria Medical. You are a more personal combat medic under Blackshield and Marshals jurisdiction.</b>"

/obj/landmark/join/start/medspec
	name = "Corpsman"
	icon_state = "player-blue"
	join_tag = /datum/job/medspec





/datum/job/trooper
	title = "Trooper"
	flag = TROOPER
	department = DEPARTMENT_SECURITY
	department_flag = SECURITY
	faction = MAP_FACTION
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Blackshield Commander"
	difficulty = "Hard."
	selection_color = "#a7bbc6"
	wage = WAGE_LABOUR_HAZARD

	outfit_type = /decl/hierarchy/outfit/job/security/troop

	perks = list(/datum/perk/job/bolt_reflect, /datum/perk/job/blackshield_conditioning, /datum/perk/chem_contraband)

	access = list(
		access_security, access_eva,
		access_sec_doors, access_brig, access_maint_tunnels, access_external_airlocks
	)

	stat_modifiers = list(
		STAT_ROB = 25,
		STAT_TGH = 20,
		STAT_VIG = 25,
	)

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)

	description = "The Trooper forms the base of the Blackshield, the front line against pirates, terrorists, and xenos.<br>\
	You are the closest thing to a professional soldier the colony has. Employ your talents to bring an end to threats and conflict situations.<br>\
	Tactics and teamwork are vital. You are paid to follow orders, not to think. Remember your focus on external threats - leave otherwise to Marshals.<br>\
	When there are no standing orders, your ongoing task is to patrol and be on the lookout for threats or problems. Help the Marshals if explicitly asked. <br>\
	Watch the main gate and perimeter. You have access to most places to help with your duties - do not abuse this."

	duties = "Patrol the colony, provide a security presence, and look for trouble.<br>\
		Deal with external threats to the colony such as pirates, hostile xenos, and anything that endangers colonists.<br>\
		Exterminate monsters, giant vermin and hostile machines.<br>\
		Follow orders from the chain of command.<br>\
		Obey the law. You are not above it."

/obj/landmark/join/start/trooper
	name = "Trooper"
	icon_state = "player-blue"
	join_tag = /datum/job/trooper





/datum/job/officer
	title = "Rifleman"
	flag = OFFICER
	department = DEPARTMENT_SECURITY
	department_flag = SECURITY
	faction = MAP_FACTION
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Warrant Officer"
	difficulty = "Hard."
	selection_color = "#a7bbc6"
	wage = WAGE_LABOUR_HAZARD
	alt_titles = list("Volunteer")

	outfit_type = /decl/hierarchy/outfit/job/security/ihoper

	access = list(
		access_security, access_moebius, access_engine, access_mailsorting, access_eva, access_forensics_lockers, access_medspec,
		access_sec_doors, access_brig, access_maint_tunnels, access_morgue, access_external_airlocks, access_prospector, access_kitchen, access_medical_suits
	)

	stat_modifiers = list(
		STAT_ROB = 25,
		STAT_TGH = 25,
		STAT_VIG = 20,
	)

	perks = list(/datum/perk/codespeak, /datum/perk/chem_contraband)

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)

	description = "The Marshal Officer forms the brunt of the Marshals, internally enforcing law and keeping the peace.<br>\
	You are expected to be a problem solver who can descalate situations, reach peaceful agreements, and maintain public trust.<br>\
	Keep your weapons holstered unless the situation demands otherwise - exercise good judgment and follow Blackshield orders.<br>\
	When there are no standing orders, your ongoing task is to patrol the colony and be on the lookout for threats or problems. <br>\
	Check in at departments and watch the main gate. You have access to most places to help with your duties  - do not abuse this."

	duties = "Patrol the colony, provide a security presence, and look for trouble.<br>\
		Deal with internal threats to the colony such as criminals, saboteurs, and anything that endangers colonists.<br>\
		Ensure that people follow the law and SoP to maintain order.<br>\
		Follow orders from the chain of command.<br>\
		Obey the law. You are not above it."

/obj/landmark/join/start/officer
	name = "Rifleman"
	icon_state = "player-blue"
	join_tag = /datum/job/officer