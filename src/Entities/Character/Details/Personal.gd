extends DataContainer



func _init() -> void:
	add_value("weight", 135)
	add_value("height", 5.11)
	add_value("age", 18)
	add_value("race", RaceTemplate.new())
	add_value("custom_portrait", "")
	add_value("appearance", {
		eye = "",
		head = "",
		hair = "",
		nose = "",
		mouth = "",
	})
	add_value("color", {
		eye = Color(),
		skin = Color(),
		nose = Color(),
		mouth = Color(),
	})
	add_value("name", {
		first = "John",
		last = "Everyman"
	})
	add_value("nickname", "Normal")



func get_full_name() -> String:
	var name : String = ""
	
	for i in get("name").values():
		name += i
		name += " "
	
	return name
