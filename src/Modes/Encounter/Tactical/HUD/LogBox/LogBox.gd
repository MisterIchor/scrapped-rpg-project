extends TabContainer

const LogTab : PackedScene = preload("res://src/Modes/Encounter/Tactical/HUD/LogBox/LogTab.tscn")



func _ready() -> void:
	var log_catagories : Array = LogSystem.catagory.keys()
	log_catagories.invert()
	
	for i in log_catagories:
		if not i == "debug":
			var new_catagory : ScrollContainer = LogTab.instance()
			
			new_catagory.name = i.capitalize()
			new_catagory.size_flags_horizontal = SIZE_EXPAND_FILL
			add_child_below_node(get_node("All"), new_catagory, true)
