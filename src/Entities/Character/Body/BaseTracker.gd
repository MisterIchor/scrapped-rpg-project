tool
extends RayCast2D
class_name Tracker

signal body_entered(body)

var track_filter : Dictionary = {
	units = true,
	walls = true,
}



func _physics_process(delta: float) -> void:
	if not enabled:
		return
	
	var collision = get_collider()
	
	if collision:
		var checks : Array = [
			collision.owner is Unit and track_filter.units,
			collision.get_class() == "TileWallBody" and track_filter.walls
		]
		
		if true in checks:
			emit_signal("body_entered", collision)



func _get_property_list() -> Array:
	var properties : Array = []
	
	properties.append({
		name = "Track Filter",
		type = TYPE_NIL,
		hint_string = "track_",
		usage = PROPERTY_USAGE_CATEGORY | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	
	properties.append({
		name = "track_units",
		type = TYPE_BOOL
	})
	
	properties.append({
		name = "track_walls",
		type = TYPE_BOOL
	})
	
	return properties


func _set(property: String, value) -> bool:
	match property:
		"track_units":
			track_filter.units = value
		"track_walls":
			track_filter.walls = value
		"enabled":
			set_physics_process(value)
		
	return false


func _get(property: String):
	match property:
		"track_units":
			return track_filter.units
		"track_walls":
			return track_filter.walls



func get_cast_to_rotated() -> Vector2:
	return cast_to.rotated(global_rotation)


func get_cast_to_global() -> Vector2:
	return global_position + get_cast_to_rotated()


func get_cast_to_dir() -> Vector2:
	return global_position.direction_to(get_cast_to_global())


func get_cast_to_angle() -> float:
	return get_cast_to_global().angle_to_point(global_position)
