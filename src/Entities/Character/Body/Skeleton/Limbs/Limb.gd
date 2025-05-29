tool
extends Node2D
#class_name Limb

signal section_added(new_section)

enum Side {RIGHT_OR_NOT_APPLICABLE = 1, LEFT = -1}

#export (float, 0, 1) var depth : float = 1
export (Side) var side : int
var limb_collision_expections : Array = []

onready var tween : Tween = ($Tween as Tween)



func _ready() -> void:
	connect_sections()
	
	if not Engine.editor_hint:
		add_limb_collision_exception(self)



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
		var difference : int = get_section_count() - value
		
		for i in abs(difference):
			match sign(difference):
				-1.0:
					add_section()
				1.0:
					remove_section(i)
		
		property_list_changed_notify()
	
	return false


func _get(property: String):
	if property == "number_of_sections":
		return get_section_count()



func add_limb_collision_exception(limb : Limb) -> void:
	if limb in limb_collision_expections:
		return
	
	for i in get_sections():
		for j in limb.get_sections():
			i.add_collision_exception_with(j)
	
	connect("section_added", limb, "_on_Limb_section_added")
	limb_collision_expections.append(limb)


func add_section() -> void:
	var new_section : LimbSection = preload("res://src/Entities/Character/Body/Skeleton/Limbs/LimbSection.tscn").instance(PackedScene.GEN_EDIT_STATE_MAIN)
	
	add_child(new_section, true)
	new_section.set_owner(self)
	emit_signal("section_added", new_section)
	
	if not is_inside_tree():
		return
	
	connect_sections()


func connect_sections() -> void:
	var sections : Array = get_sections()
	
	for i in range(1, sections.size()):
		sections[i - 1].set_connected_to(sections[i])


func remove_section(section_idx : int = -1) -> void:
	var sections : Array = get_sections()
	
	if sections.empty():
		return
	
	if section_idx < sections.size():
		sections[section_idx].queue_free()


func sever_limb(section_percentage : float) -> void:
	pass



func animate() -> void:
	tween.start()


func freeze() -> void:
	tween.stop_all()


func stop() -> void:
	tween.remove_all()


func tween_rotation(degrees : float, duration : float = 0.5) -> void:
	tween.interpolate_property(self, "rotation_degrees", rotation_degrees, degrees * side, duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)


func tween_contraction(degrees : float, duration : float = 0.5, section_percentage : float = 1.0) -> void:
	var sections : Array = get_sections(section_percentage)
#	sections.invert()
	
	for i in range(1, sections.size()):
		var section_to_rotate : LimbSection = sections[i]
		var rotation_div : float = ((-degrees / sections.size()) * side) * i
		var size_adj : float = section_to_rotate.length.size / LimbSection.DEFAULT_SIZE
		var size_rotation_calc : float = size_adj * rotation_div
		
		rotation_div = size_rotation_calc
		tween.interpolate_property(sections[i], "rotation_degrees", sections[i].rotation_degrees, rotation_div, duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)


func tween_reset_to_neutral() -> void:
	tween_size(0.0, 0.2)
	tween_rotation(0, 0.2)
	tween_contraction(0, 0.2)


func tween_size(percentage : float, duration : float = 0.5, section_percentage : float = 1.0) -> void:
	for i in get_sections(section_percentage):
		tween.interpolate_property(i, "length_percentage", i.length.percentage, percentage, duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)



func set_limb_rotation(degrees : float) -> void:
	rotation_degrees = degrees * side


func set_limb_size(percentage : float, section_percentage : float = 1.0) -> void:
	for i in get_sections(section_percentage):
		i.set("length_percentage", percentage)


func set_contraction(degrees : float, section_percentage : float = 1.0) -> void:
	var sections : Array = get_sections(section_percentage)
	
	for i in range(1, sections.size()):
		var section_to_rotate : LimbSection = sections[i]
		var rotation_div : float = ((-degrees / sections.size()) * side) * i
		var size_adj : float = section_to_rotate.length.size / LimbSection.DEFAULT_SIZE
		var size_rotation_calc : float = size_adj * rotation_div
		
		rotation_div = size_rotation_calc
		sections[i].rotation_degrees = rotation_div



func get_section_count() -> int:
	return get_sections().size()


func get_sections(percentage : float = 1.0) -> Array:
	var sections : Array = get_children()
	sections.pop_front()
	
	match sign(percentage):
		1.0:
			sections.resize(ceil(sections.size() * clamp(percentage, 0.0, 1.0)))
		-1.0:
			sections.invert()
			sections.resize(ceil(sections.size() * clamp(abs(percentage), 0.0, 1.0)))
			sections.invert()
	
	return sections


func get_front_section() -> RigidBody2D:
	return get_sections().back()


func get_back_section() -> RigidBody2D:
	return get_sections().front()


func get_limb_max_length() -> float:
	var length : float = 0
	
	for i in get_sections():
		length += i.get_size()
	
	return length


func get_section_size_as_vector(section : RigidBody2D, percentage : float = 1.0) -> Vector2:
	var size_adjusted : float = section.get_size() * percentage
	return (size_adjusted * Vector2(0, -1)).clamped(section.get_size())



func _on_Limb_section_added(new_section : LimbSection) -> void:
	for i in get_sections():
		i.add_collision_exception_with(new_section)
