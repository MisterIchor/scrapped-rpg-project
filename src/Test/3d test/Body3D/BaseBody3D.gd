tool
extends RigidBody
class_name BaseBody3D

signal collision_update
signal hit(with, from)

const NOTIFICATION_CONTAINER_SET : int = 34

export (Mesh) onready var mesh : Mesh = preload("res://assets/graphics/limbs/default_limb_section_mesh.tres") setget set_mesh

var container : TemplateContainer = null setget set_container
var file_manager : FileManager = FileManager.new()
#var collision_data : PoolVector3Array = [] setget set_collision_data
var body_scale : Vector3 = Vector3.ONE setget set_body_scale

onready var collision_body : CollisionShape = ($CollisionShape as CollisionShape)
onready var mesh_instance : MeshInstance = ($MeshInstance as MeshInstance)



func _init() -> void:
	file_manager.file_type = ".coldata"
	file_manager.folder_path = "res://assets/saved/collision_data"
	file_manager.object_to_manage = self
	file_manager.set_owner(self)
#	file_manager.add_value_to_manage("collision_data", "set_collision_data", "_get_collision_polygon")


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")


func _notification(what: int) -> void:
	if what == NOTIFICATION_CONTAINER_SET:
		container.set_owner(self)
		load_collision_data(container.get("collision_data"))
		set_name(container.name + "Body")
		
		if not is_inside_tree():
			yield(self, "ready")
		
		set_mesh(container.get("mesh"))



func _get_collision_polygon() -> PoolVector2Array:
	return collision_body.polygon



func load_collision_data(file_name : String) -> void:
#	file_manager.load_file(file_name.get_basename().get_file())
	emit_signal("collision_update")



func play_sound(from_bank : String, random_pitch : bool = true, pitch_range : float = 1.5) -> void:
	var sound_bank : Dictionary = container.template.get("sound_bank")
	
	if sound_bank.empty():
		return
	
	var bank_to_play : Array = sound_bank.get(from_bank)
	
	if not bank_to_play:
		LogSystem.write_to_debug(name + ":sound bank " + from_bank + "does not exist.", 0)
		return
	
	var player : AudioStreamPlayer3D = AudioStreamPlayer3D.new()
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



func set_body_scale(new_scale : Vector3) -> void:
	if not collision_body:
		yield(self, "ready")
	
	body_scale = new_scale
#	collision_body.set_deferred("polygon", get_scaled_collision())
	mesh_instance.scale = body_scale


#func set_collision_data(new_data : PoolVector3Array) -> void:
#	if not collision_body:
#		yield(self, "ready")
#
#	collision_data = new_data
#	collision_body.polygon = get_scaled_collision()


func set_container(new_container : TemplateContainer) -> void:
	container = new_container
	
	if container:
		if not container.template:
			yield(container, "template_set")
		
		notification(NOTIFICATION_CONTAINER_SET, true)
#		call_deferred("notification", NOTIFICATION_CONTAINER_SET)


func set_mesh(new_mesh : Mesh) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	
	mesh = new_mesh
	
	if has_node("MeshInstance"):
		mesh_instance.mesh = mesh
#		collision_body.shape = mesh.create_convex_shape()



func get_body_midpoint(point_one : Vector2, point_two : Vector2) -> Vector2:
	return (point_two - point_one) * 0.5 + point_one


#func get_scaled_collision() -> PoolVector3Array:
#	if body_scale.is_equal_approx(Vector3.ONE):
#		return collision_data
#
#	var scaled_collision : PoolVector3Array = collision_data
#
#	for i in scaled_collision.size():
#		scaled_collision.set(i, scaled_collision[i] * body_scale)
#
#	return scaled_collision



func _on_body_entered(body : Node) -> void:
	emit_signal("hit", body, body.get("from"))


func _on_Player_finished(player : AudioStreamPlayer3D) -> void:
	player.queue_free()
