extends BaseBody
class_name TileWallBody

onready var projectile_detection : Area2D = ($ProjectileDetection as Area2D)




#func _ready() -> void:
#	projectile_detection.connect("body_entered", self, "_on_ProjectileDetection_body_entered")
#	projectile_detection.connect("body_exited", self, "_on_ProjectileDetection_body_exited")



func _notification(what: int) -> void:
	if what == NOTIFICATION_CONTAINER_SET:
		var health_max : int = container.get("health_max")
		container.add_value("health_current", health_max if health_max else 0)
#
#		if not is_inside_tree():
#			yield(self, "ready")
#
#		if height == -1:
#			height = owner.height


func get_rect() -> Rect2:
	var sprite_size : Vector2 = sprite.texture.get_size() * body_scale
	return Rect2(global_position + (sprite_size / 2), sprite.texture.get_size())


func get_class() -> String:
	return "TileWallBody"



func _on_Container_value_changed(container : String, value_name : String, value_new, value_old) -> void:
	if container == "health_current":
		if value_new < value_old:
			play_sound("damage")


func _on_ProjectileDetection_body_entered(body : Node) -> void:
	if body is Projectile:
		if not is_height_intersecting(body):
			body.body_overlap.append(self)
			add_collision_exception_with(body)


func _on_ProjectileDetection_body_exited(body : Node) -> void:
	if body is Projectile:
		body.body_overlap.erase(self)
		remove_collision_exception_with(body)
