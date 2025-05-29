tool
extends Bone2D

export (NodePath) var start : NodePath
export (NodePath) var end : NodePath

var grab : Dictionary = {
	equipped_item = null,
	can_pickup_items = false,
	can_equip_items = false,
	can_use_items = false,
}

onready var front : Node2D = (get_node_or_null("Front") as Node2D)



func _get_property_list() -> Array:
	var property_list : Array = []
	
	property_list.append({
		name = "GrabOptions",
		type = TYPE_NIL,
		hint_string = "grab_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE,
	})
	
	property_list.append({
		name = "grab_can_pickup_items",
		type = TYPE_BOOL,
	})
	
	property_list.append({
		name = "grab_can_equip_items",
		type = TYPE_BOOL,
	})
	
	property_list.append({
		name = "grab_can_use_items",
		type = TYPE_BOOL,
	})
	
	return property_list


func _set(property: String, value) -> bool:
	if property == "grab_can_pickup_items":
		grab.can_pickup_items = value
	
	if property == "grab_can_equip_items":
		grab.can_equip_items = value
	
	if property == "grab_can_use_items":
		grab.can_use_items = value
	
	return false


func _get(property: String):
	if property == "grab_can_pickup_items":
		return grab.can_pickup_items
	
	if property == "grab_can_equip_items":
		return grab.can_equip_items
	
	if property == "grab_can_use_items":
		return grab.can_use_items



func set_equipped_item(item : KinematicBody2D) -> void:
	if not grab.can_equip_items:
		return
	
	grab.equipped_item = item


func set_default_length(new_length : float) -> void:
	default_length = new_length
	
	if not front:
		return
	
	if front.global_position.is_equal_approx(global_position):
		front.global_position.y = -default_length
	else:
		front.global_position = default_length * global_position.direction_to(front.global_position)


func set_front_direction(face_towards : Vector2) -> void:
	var offset : Vector2 = face_towards - global_position
	front.global_position = global_position + (offset.normalized() * default_length)



func get_front_pos() -> Vector2:
	return front.global_position



func _physics_process(delta: float) -> void:
	if not front:
		return
	
	var start_section : Node = get_node_or_null(start)
	var end_section : Node = get_node_or_null(end)
	
	if start_section:
		front.global_position = start_section.global_position
	
	if end_section:
		global_position = end_section.get_front_pos()
	
	set_front_direction(front.global_position)
#	sprite.global_position = get_midpoint(get_front_pos(), global_position)
#	sprite.look_at(get_front_pos())
#	collision_body.global_position = sprite.global_position
#	collision_body.global_rotation = sprite.global_rotation
	
#	if grab.equipped_item:
#		grab.equipped_item.global_position = get_midpoint(global_position, front.global_position)

