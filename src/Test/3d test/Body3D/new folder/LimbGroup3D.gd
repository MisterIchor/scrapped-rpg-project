tool
extends Node
class_name LimbGroup3D

signal limb_added(limb)

const Limb : GDScript = preload("res://src/Test/3d test/Body3D/new folder/Limb3D.gd")
enum Side {RIGHT_OR_NOT_APPLICABLE = 1, LEFT = -1}

var side : int = Side.RIGHT_OR_NOT_APPLICABLE setget set_side



func _ready() -> void:
	if side == 0:
		side = 1


func _tween_rotation(limb_name : String, axis : String, degrees : float, duration : float) -> void:
	if limb_name.matchn("all"):
		for i in get_children():
			i.tween_limb_rotation(axis, degrees, duration)
	else:
		var limb : Limb3D = get_node_or_null(limb_name)
		
		if limb:
			limb.tween_limb_rotation(axis, degrees, duration)


func _tween_contraction(limb_name : String, axis : String, degrees : float, duration : float, 
			section_percentage : float) -> void:
	if limb_name.matchn("all"):
		for i in get_children():
			i.tween_contraction(axis, degrees, duration, section_percentage)
	else:
		var limb : Limb3D = get_node_or_null(limb_name)
		
		if limb:
			limb.tween_contraction(axis, degrees, duration, section_percentage)


func _set_rotation(limb_name : String, axis : String, degrees : float) -> void:
	if limb_name.matchn("all"):
		for i in get_children():
			i.set_limb_rotation(axis, degrees)
	else:
		var limb : Limb3D = get_node_or_null(limb_name)
		
		if limb:
			limb.set_limb_rotation(axis, degrees)


func _set_contraction(limb_name : String, axis : String, degrees : float, section_percentage : float) -> void:
	if limb_name.matchn("all"):
		for i in get_children():
			i.set_contraction(axis, degrees, section_percentage)
	else:
		var limb : Limb3D = get_node_or_null(limb_name)
		
		if limb:
			limb.set_contraction(axis, degrees, section_percentage)



func create_limb(limb_name : String, section_containers : Array = [], initial_position : Vector3 = Vector3()) -> Limb3D:
	if has_node(limb_name):
		return get_node(limb_name) as Limb3D
	
	var new_limb : Limb3D = Limb.new()
	new_limb.name = limb_name
	
	for i in section_containers:
		new_limb.add_section(i)
		new_limb.get_front_section()
	
	new_limb.translation = initial_position
	add_child(new_limb)
	return new_limb


func animate(rand_delay : float = 0.0) -> void:
	for i in get_children():
		i.animate()
		
		if rand_delay:
			yield(get_tree().create_timer(rand_range(0, rand_delay), false), "timeout")


func freeze() -> void:
	for i in get_children():
		i.freeze()


func stop() -> void:
	for i in get_children():
		i.stop()


func tween_pause(limb_name : String, duration : float = 0.5) -> void:
	if limb_name.matchn("all"):
		for i in get_children():
			i.tween_pause(duration)
	else:
		var limb : Limb3D = get_node_or_null(limb_name)
		
		if limb:
			limb.tween_pause(duration)


func tween_tilt(limb_name : String, degrees : float, duration : float = 0.5) -> void:
	_tween_rotation(limb_name, "x", degrees, duration)


func tween_swing(limb_name : String, degrees : float, duration : float = 0.5) -> void:
	_tween_rotation(limb_name, "y", degrees, duration)


func tween_lift(limb_name : String, degrees : float, duration : float = 0.5) -> void:
	_tween_rotation(limb_name, "z", degrees, duration)


func tween_twist(limb_name : String, degrees : float, duration : float = 0.5, section_percentage : float = 1.0) -> void:
	_tween_contraction(limb_name, "y", degrees, duration, section_percentage)


func tween_curl(limb_name : String, degrees : float, duration : float = 0.5, section_percentage : float = 1.0) -> void:
	_tween_contraction(limb_name, "x", degrees, duration, section_percentage)


func tween_flex(limb_name : String, degrees : float, duration : float = 0.5, section_percentage : float = 1.0) -> void:
	_tween_contraction(limb_name, "z", degrees, duration, section_percentage)



func set_tilt(limb_name : String, degrees : float) -> void:
	_set_rotation(limb_name, "x", degrees)
#	rotation_degrees.x = degrees * side


func set_swing(limb_name : String, degrees : float) -> void:
	_set_rotation(limb_name, "y", degrees)
#	rotation_degrees.y = degrees * side


func set_lift(limb_name : String, degrees : float) -> void:
	_set_rotation(limb_name, "z", degrees)
#	rotation_degrees.z = degrees


func set_twist(limb_name : String, degrees : float, section_percentage : float = 1.0) -> void:
	_set_contraction(limb_name, "x", degrees, section_percentage)


func set_curl(limb_name : String, degrees : float, section_percentage : float = 1.0) -> void:
	_set_contraction(limb_name, "y", degrees, section_percentage)


func set_flex(limb_name : String, degrees : float, section_percentage : float = 1.0) -> void:
	_set_contraction(limb_name, "z", degrees, section_percentage)


func set_side(value : int) -> void:
	side = value



func get_class() -> String:
	return "LimbGroup3D"
