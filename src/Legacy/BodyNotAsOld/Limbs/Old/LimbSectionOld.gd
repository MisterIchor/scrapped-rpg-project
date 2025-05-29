tool
extends BaseBody

export (NodePath) var start : NodePath
export (NodePath) var end : NodePath
export (Vector2) var scale_limits : Vector2 = Vector2(0, 0.75)

var length : Dictionary = {
	size = 25,
	percentage_max = 1,
	percentage_min = 0,
}
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
		name = "reset_front_position",
		type = TYPE_BOOL
	})
	
	
	property_list.append({
		name = "LengthOptions",
		type = TYPE_NIL,
		hint_string = "length_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE,
	})
	
	property_list.append({
		name = "length_size",
		type = TYPE_REAL,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "1,100,0.001,or_greater",
	})
	
	property_list.append({
		name = "length_percentage_max",
		type = TYPE_REAL,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "0.001,1,0.001,or_greater"
	})

	property_list.append({
		name = "length_percentage_min",
		type = TYPE_REAL,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "0,1,0.001,or_greater"
	})
	
	
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
	if property == "reset_front_position":
		if value == true:
			front.position = Vector2(0, -length.size)
	
	
	if property == "length_size":
		length.size = value
	
	if property == "length_percentage_max":
		length.percentage_max = value
	
	if property == "length_percentage_min":
		length.percentage_min = value
	
	
	if property == "grab_can_pickup_items":
		grab.can_pickup_items = value
	
	if property == "grab_can_equip_items":
		grab.can_equip_items = value
	
	if property == "grab_can_use_items":
		grab.can_use_items = value
	
	return false


func _get(property: String):
	if property == "length_size":
		return length.size
	
	if property == "length_percentage_max":
		return length.percentage_max
	
	if property == "length_percentage_min":
		return length.percentage_min
	
	
	if property == "grab_can_pickup_items":
		return grab.can_pickup_items
	
	if property == "grab_can_equip_items":
		return grab.can_equip_items
	
	if property == "grab_can_use_items":
		return grab.can_use_items



func update_length() -> void:
	var length_percentage : float = clamp(front.position.length() / length.size, length.percentage_min, length.percentage_max)
	var current_scale : Vector2 = Vector2.ONE
	
	front.position = front.position.clamped(length.size * length.percentage_max)
	
	if scale_limits == Vector2.ONE:
		return
	
	current_scale.x *= clamp(length_percentage, 
			1 - scale_limits.x, 1)
	current_scale.y *= clamp(length_percentage, 
			1 - scale_limits.y, 1)
	set_sprite_scale(current_scale)



func set_equipped_item(item : KinematicBody2D) -> void:
	if not grab.can_equip_items:
		return
	
	grab.equipped_item = item



func get_front_pos() -> Vector2:
	return front.global_position



func _physics_process(delta: float) -> void:
	if not front or not sprite:
		return
	
	var start_section : Node = get_node_or_null(start)
	var end_section : Node = get_node_or_null(end)
	
#	if start_section:
#		front.global_position = start_section.global_position
	
	if end_section:
		global_position = end_section.get_front_pos()
	
	sprite.global_position = get_midpoint(get_front_pos(), global_position)
	sprite.look_at(get_front_pos())
	collision_body.global_position = sprite.global_position
	collision_body.global_rotation = sprite.global_rotation
	
	if grab.equipped_item:
		grab.equipped_item.global_position = get_midpoint(global_position, front.global_position)
	
	update_length()
