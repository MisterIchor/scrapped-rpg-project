tool
extends Node2D

enum HeightPreset {FLOOR, MID = 75, EYE_LEVEL = 150}

export (String, DIR) var body_data : String = String() setget set_body_data
export (String, DIR) var current_animation : String = String() setget set_current_animation
export (bool) var add_limb : bool = false
var height_modifier : float = 1.0
var file_manager : FileManager = FileManager.new()



func compile_body_data() -> Dictionary:
	var compiled_body_data : Dictionary = {}
	
#	for limb_group in get_children():
#		compiled_body_data[limb_group.name] = {}
#
#		for limb in limb_group.get_children():
#
	
	return compiled_body_data



func set_body_data(new_data : String) -> void:
	body_data = new_data


func set_current_animation(new_animation : String) -> void:
	current_animation = new_animation






func get_limbs_from_group(from_group : String) -> Array:
	var limb_group : Node2D = get_node_or_null(from_group)
	return limb_group.get_children() if limb_group else []
