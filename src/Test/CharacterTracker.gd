extends Node

var characters = {}

var character : Dictionary = {
	charinfo = {
		race = 0, 
		name = "", 
		gen = 0, 
		age = 0, 
		eyes = 0, 
		hair = 0, 
		ht = {ft = 0, inch = 0},
		wt = 0, 
		hometown = 0, 
		residence = 0, 
		deity = 0, 
		background = 0
	},

	attrib = {
		stren = 40, 
		dex = 40, 
		end = 40,
		agl = 40, 
		intel = 40, 
		cha = 40, 
		wis = 40, 
		per = 40, 
		lck = 40
	},

	basestats = {
		hp = {max = 0, current = 0}, 
		sta = {max = 0, current = 0}, 
		ap = {max = 0, current = 0}, 
		wt = {max = 0, current = 0},
		mor = {max = 100, current = 50},
		init = 0, 
		arm = 0, 
		dodge = 0, 
		dam = 0, 
		acc = 0, 
		crit = 0
	},

	skills = {
		comskills = {
			handgun = 0, 
			rifle = 0, 
			snirifle = 0, 
			shotgun = 0,
			smg = 0, 
			mg = 0, 
			hevgun = 0, 
			explosive = 0, 
			lblade = 0, 
			sblade = 0,
			blunt = 0, 
			unarmed = 0
		},

		knowskills = {
			splcrft = 0,
			divine = 0,
			outdoor = 0, 
			engi = 0, 
			history = 0,
			lin = 0, 
			med = 0
		},

		stlthskills = {
			snk = 0, 
			locpic = 0, 
			picpoc = 0, 
			disguise = 0,
			traps = 0
		},

		socialskills = {
			persuade = 0, 
			leader = 0,
			merc = 0, 
			sensemov = 0, 
			entertain = 0,
			music = 0
		},

		otherskills = {
			detect = 0
		}
	}
}



