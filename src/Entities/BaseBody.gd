extends RigidBody2D
class_name BaseBody

signal collision_update
signal height_updated(new_height)

const NOTIFICATION_CONTAINER_SET : int = 34

var container : TemplateContainer = null setget set_container
var file_manager : FileManager = FileManager.new()
var collision_data : PoolVector2Array = [] setget set_collision_data
var body_scale : Vector2 = Vector2.ONE setget set_body_scale
# Height of the body itself i.e. how tall it is. Remains static unless changed 
# manually. Represents the top of the body.
var height : float = 5 setget set_height
# How high or low the body is.  Used for collision checks (i.e. to see if a 
# projectile should pass over/under a body. Represents the bottom of the body and will
# be updated automatically.
var global_height : float = 0

onready var collision_body : CollisionPolygon2D = ($CollisionPolygon2D as CollisionPolygon2D)
onready var sprite : Sprite = ($Sprite as Sprite)



func _init() -> void:
	file_manager.file_type = ".coldata"
	file_manager.folder_path = "res://assets/saved/collision_data"
	file_manager.object_to_manage = self
	file_manager.set_owner(self)
	file_manager.add_value_to_manage("collision_data", "set_collision_data", "_get_collision_polygon")
	
	if not is_connected("height_updated", self, "_on_height_updated"):
		connect("height_updated", self, "_on_height_updated")


func _notification(what: int) -> void:
	if what == NOTIFICATION_CONTAINER_SET:
		container.set_owner(self)
		load_collision_data(container.get("collision_data"))
		set_height(container.get("height"))
		set_name(container.name + "Body")
		
		if not is_inside_tree():
			yield(self, "ready")
		
		sprite.texture = container.get("sprite")



func _get_collision_polygon() -> PoolVector2Array:
	return collision_body.polygon



func load_collision_data(file_name : String) -> void:
	file_manager.load_file(file_name.get_basename().get_file())
	emit_signal("collision_update")



func play_sound(from_bank : String, random_pitch : bool = true, pitch_range : float = 1.5) -> void:
	var sound_bank : Dictionary = container.template.get("sound_bank")
	
	if sound_bank.empty():
		return
	
	var bank_to_play : Array = sound_bank.get(from_bank)
	
	if not bank_to_play:
		LogSystem.write_to_debug(name + ":sound bank " + from_bank + "does not exist.", 0)
		return
	
	var player : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
	var sound : AudioStream = bank_to_play[randi() % bank_to_play.size()]
	
	if random_pitch:
		var pitched_sound : AudioStreamRandomPitch = AudioStreamRandomPitch.new()
		
		pitched_sound.audio_stream = sound
		pitched_sound.random_pitch = pitch_range
		sound = pitched_sound
	
	player.connect("finished", self, "_on_Player_finished", [player], CONNECT_DEFERRED)
	player.stream = sound
	add_child(player)
	player.play()



func set_body_scale(new_scale : Vector2) -> void:
	if not collision_body:
		yield(self, "ready")
	
	body_scale = new_scale
	collision_body.set_deferred("polygon", get_scaled_collision())
	sprite.scale = body_scale


func set_collision_data(new_data : PoolVector2Array) -> void:
	if not collision_body:
		yield(self, "ready")
	
	collision_data = new_data
	collision_body.polygon = get_scaled_collision()


func set_container(new_container : TemplateContainer) -> void:
	container = new_container
	
	if container:
		notification(NOTIFICATION_CONTAINER_SET, true)
#		call_deferred("notification", NOTIFICATION_CONTAINER_SET)


func set_height(new_height : float) -> void:
	height = new_height
#	emit_signal("height_updated", height)



func is_height_intersecting(body : BaseBody) -> bool:
	var boundaries : Dictionary = get_global_height_boundaries()
	var body_boundaries : Dictionary = body.get_global_height_boundaries()
	# Check boundaries to see if they are overlapping.
	var collision_checks : Array = [
		(
			boundaries.bottom >= body_boundaries.bottom 
			and not boundaries.bottom > body_boundaries.top
		),
		(
			boundaries.top <= body_boundaries.top 
			and not boundaries.top < body_boundaries.bottom
		)
	]
	
	return true in collision_checks



func get_body_midpoint(point_one : Vector2, point_two : Vector2) -> Vector2:
	return (point_two - point_one) * 0.5 + point_one


func get_global_height_boundaries() -> Dictionary:
	return {
		top = global_height + get_height_scaled(),
		mid = global_height + (get_height_scaled() / 2),
		bottom = global_height
	}


func get_height_scaled() -> float:
	return height * ((body_scale.x + body_scale.y) / 2)


func get_scaled_collision() -> PoolVector2Array:
	if body_scale.is_equal_approx(Vector2.ONE):
		return collision_data
	
	var scaled_collision : PoolVector2Array = collision_data
	
	for i in scaled_collision.size():
		scaled_collision.set(i, scaled_collision[i] * body_scale)
	
	return scaled_collision



func _on_Player_finished(player : AudioStreamPlayer2D) -> void:
	player.queue_free()
