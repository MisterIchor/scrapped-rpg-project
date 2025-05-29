tool
extends BaseBody3D
class_name LimbSection3D

const DEFAULT_LENGTH : float = 20.0

#export (Vector2) var scale_limits : Vector2 = Vector2(0, 0.75)

var connected_to : LimbSection3D = null setget set_connected_to
var length : float = DEFAULT_LENGTH

onready var front : Position3D = ($Front as Position3D)
onready var giblets : Spatial = ($Giblets as Spatial)



func _ready() -> void:
	if connected_to:
		connected_to.translation = front.translation + translation
	
#	set_mesh(load("res://assets/graphics/limbs/LimbSection3D.tres"))
	property_list_changed_notify()
	update_length()


func _notification(what: int) -> void:
	if what == NOTIFICATION_CONTAINER_SET:
		name = container.get("name")
		set_mesh(container.get("mesh"))
		length = container.get("length")



func add_giblet(template, position : Vector3 = Vector3()) -> void:
	return


func update_length() -> void:
	front.translation = front.translation.limit_length(get_length_3d())
	mesh_instance.translation = front.translation / 2
	collision_body.translation = front.translation / 2
	mesh_instance.look_at(front.global_translation, Vector3.UP)
	
	if connected_to:
		connected_to.global_translation = front.global_translation


func set_connected_to(new_section : LimbSection3D) -> void:
	connected_to = new_section
	
	if connected_to:
		connected_to.global_translation = front.global_translation



func get_giblets() -> Array:
	return giblets.get_children()


func get_front_translation() -> Vector3:
	return front.translation


func get_front_translation_global() -> Vector3:
	return front.global_translation


func get_length() -> float:
	return length


func get_length_3d() -> float:
	return length * 0.01
