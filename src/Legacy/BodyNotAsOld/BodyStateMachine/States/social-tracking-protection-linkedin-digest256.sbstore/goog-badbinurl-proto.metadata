tool
extends Node2D

const LimbSection : PackedScene = preload("res://src/Entities/Physical/Character/Tactical/Body/Limbs/Old/LimbSectionOld.tscn")
#export (float, 0, 1) var depth : float = 1
export (String, "ARM", "LEG") var type : String
var sections : int = 0



func _manage_sections() -> void:
	if sections > get_child_count():
		add_section()
	elif sections < get_child_count():
		get_child(get_child_count() - 1).queue_free()
	
	connect_sections()



func _get_property_list() -> Array:
	var property_list : Array = []
	
	property_list.append({
		name = "number_of_sections",
		type = TYPE_INT,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "0,999"
	})
	
	return property_list


func _set(property: String, value) -> bool:
	if property == "number_of_sections":
		sections = value
	
	return false


func _get(property: String):
	if property == "number_of_sections":
		return sections



func connect_sections() -> void:
	for i in range(1, get_child_count()):
		var first_section : Node = get_child(i - 1)
		var second_section : Node = get_child(i)
		
#		if i == 1:
#			first_section.start = get_path()
		
		if first_section:
			second_section.start = first_section.get_path()
		
		if second_section:
			first_section.end = second_section.get_path()


func add_section() -> void:
	var new_section : Node = LimbSection.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
	
	add_child(new_section, true)
	new_section.set_owner(self)



func get_front_section() -> KinematicBody2D:
	return (get_child(0) as KinematicBody2D)


func get_back_section() -> KinematicBody2D:
	return (get_child(get_child_count() - 1) as KinematicBody2D)



func _process(delta: float) -> void:
	_manage_sections()
