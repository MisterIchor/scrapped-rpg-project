tool
extends BaseBody
#class_name LimbSection

const DEFAULT_SIZE : float = 25.0

export (Texture) onready var sprite_texture : Texture = null setget set_sprite_texture
export (Vector2) var scale_limits : Vector2 = Vector2(0, 0.75)

var connected_to : LimbSection = null setget set_connected_to
var length : Dictionary = {
	size = DEFAULT_SIZE,
	percentage = 1.0
}
var grab : Dictionary = {
	equipped_item = null,
	can_pickup_items = false,
	can_equip_items = false,
	can_use_items = false,
}

onready var front : Node2D = ($Front as Node2D)



func _physics_process(delta: float) -> void:
	update_length()


func _ready() -> void:
	if connected_to:
		connected_to.position = front.position + position
	
	sprite.connect("texture_changed", self, "_on_Sprite_texture_changed")
	
	if not sprite_texture:
		if sprite.texture:
			sprite_texture = sprite.texture
	else:
		sprite.texture = sprite_texture
	
#	z_index = -get_index()
	property_list_changed_notify()


func _get_property_list() -> Array:
	var property_list : Array = []
	
	property_list.append({
		name = "connected_to_section",
		type = TYPE_NODE_PATH
	})
	
	property_list.append({
		name = "reset_front_position",
		type = TYPE_BOOL
	})
	
	
	property_list.append({
		name = "Length Options",
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
		name = "length_percentage",
		type = TYPE_REAL,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "0.001,1,0.001,or_greater"
	})
	
	
	property_list.append({
		name = "Grab Options",
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
		length.size = max(value, 0.0001)
	
	if property == "length_percentage":
		length.percentage = value
	
	if property == "grab_can_pickup_items":
		grab.can_pickup_items = value
	
	if property == "grab_can_equip_items":
		grab.can_equip_items = value
	
	if property == "grab_can_use_items":
		grab.can_use_items = value
	
	return false


func _get(property: String):
	if property == "connected_to_section":
		if connected_to:
			return connected_to.get_path()
	
	if property == "length_size":
		return length.size
	
	if property == "length_percentage":
		return length.percentage
	
	if property == "grab_can_pickup_items":
		return grab.can_pickup_items
	
	if property == "grab_can_equip_items":
		return grab.can_equip_items
	
	if property == "grab_can_use_items":
		return grab.can_use_items



func update_length() -> void:
	var size : float = length.size * length.percentage
	
	front.position = Vector2(-size, 0).rotated(rotation)
	sprite.position = Vector2(-(size / 2), 0).rotated(rotation)
	sprite.look_at(front.global_position)
	
	if scale_limits == Vector2.ONE:
		return
	
	set_body_scale(
		Vector2(
			max(length.percentage * (length.size / sprite_texture.get_width()),
				 scale_limits.x),
			max(length.percentage, scale_limits.y)
		)
	)
	
	if connected_to:
		connected_to.global_position = front.global_position


func set_connected_to(new_section : LimbSection) -> void:
	connected_to = new_section
	
#	if connected_to:
#		connected_to.global_position = front.global_position


func set_equipped_item(item : KinematicBody2D) -> void:
	if not grab.can_equip_items:
		return
	
	grab.equipped_item = item


func set_sprite_texture(new_texture : Texture) -> void:
	if not sprite:
		yield(self, "ready")
	
	sprite_texture = new_texture
	sprite.texture = sprite_texture



func get_front_pos() -> Vector2:
	return front.position


func get_front_pos_global() -> Vector2:
	return front.global_position


func get_size() -> float:
	return length.size



#func _on_Front_position_changed(new_position : Vector2) -> void:
#	update_length()


func _on_Sprite_texture_changed() -> void:
	if sprite.texture:
		return
		update_length()
