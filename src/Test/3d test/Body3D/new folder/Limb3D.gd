tool
extends Spatial
class_name Limb3D

signal section_added(new_section)
signal tween_step

const DEFAULT_SECTION_COUNT : int = 3
const LimbSection : PackedScene = preload("res://src/Test/3d test/Body3D/new folder/LimbSection3D.tscn")

var attached_to : Dictionary = {
	offset = Vector3(),
	limb = null,
	section_of_limb = null
} setget set_attached_to
export (Dictionary) var axises_affected_by_side : Dictionary = {
	x = true,
	y = true,
	z = false
}

var limb_collision_expections : Array = []
var _contraction : Vector3 = Vector3()
var _rotation : Vector3 = Vector3()

onready var tween : SceneTreeTween = null



func _ready() -> void:
	set_physics_process(false)
	connect_sections()
	
	if not Engine.editor_hint:
		_refresh_tween()
		add_limb_collision_exception(self)
		_rotation.x = rotation_degrees.x * _get_side("x")
		_rotation.y = rotation_degrees.y * _get_side("y")
		_rotation.z = rotation_degrees.z * _get_side("z")


# Only active when tween is playing.
func _physics_process(delta: float) -> void:
	for i in get_sections():
		i.update_length()
	
	emit_signal("tween_step")



# I refuse to swap axis and degrees just to make the tween work.
func _anim_contraction(degrees : float, axis : String, section_percentage : float = 1.0) -> void:
	set_contraction(axis, degrees, section_percentage)

# Ditto.
func _anim_limb_rotation(degrees : float, axis : String) -> void:
	set_limb_rotation(axis, degrees)


func _apply_rotation() -> void:
	transform.basis = Basis()
	rotate_object_local(Vector3(1, 0, 0), deg2rad(_rotation.x * _get_side("x")))
	rotate_object_local(Vector3(0, 1, 0), deg2rad(_rotation.y * _get_side("y")))
	rotate_object_local(Vector3(0, 0, 1), deg2rad(_rotation.z * _get_side("z")))
	orthonormalize()


func _apply_offset() -> void:
	var offset_adjusted : Vector3 = attached_to.offset
	
	offset_adjusted.x *= _get_side("x")
#	offset_adjusted.y *= _get_side("y")
#	offset_adjusted.z *= _get_side("z")
	offset_adjusted = offset_adjusted.rotated(Vector3(1, 0, 0), attached_to.section_of_limb.rotation.x)
	offset_adjusted = offset_adjusted.rotated(Vector3(0, 1, 0), attached_to.section_of_limb.rotation.y)
	offset_adjusted = offset_adjusted.rotated(Vector3(0, 0, 1), attached_to.section_of_limb.rotation.z)
	global_translation = attached_to.section_of_limb.global_translation + offset_adjusted


func _refresh_tween() -> void:
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.stop()
	tween.connect("finished", self, "stop")
	tween.set_parallel()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)


func _get_side(axis : String) -> int:
	if axises_affected_by_side.get(axis, true):
		if get_parent() and get_parent().get_class() == "LimbGroup3D":
			return get_parent().side
	
	return 1



func add_limb_collision_exception(limb) -> void:
	if limb in limb_collision_expections:
		return
	
	for i in get_sections():
		for j in limb.get_sections():
			i.add_collision_exception_with(j)
	
	connect("section_added", limb, "_on_Limb_section_added")
	limb_collision_expections.append(limb)


func create_section(section_container : LimbSectionContainer) -> LimbSection3D:
	var new_section : LimbSection3D = LimbSection.instance(PackedScene.GEN_EDIT_STATE_MAIN)
	
	add_child(new_section, true)
	new_section.set_container(section_container)
	emit_signal("section_added", new_section)
	
#	if not is_inside_tree():
#		return
	
	connect_sections()
	
	for i in get_sections():
		i.update_length()
	
	return new_section


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
	set_physics_process(true)
	tween.play()


func freeze() -> void:
	set_physics_process(false)
	tween.pause()


func stop() -> void:
	set_physics_process(false)
	_refresh_tween()
#	orthonormalize()



func tween_limb_rotation(axis : String, degrees : float, duration : float = 0.5) -> void:
	tween.tween_method(self, "_anim_limb_rotation", get_indexed("_rotation:" + axis), degrees, duration, [axis])


func tween_contraction(axis : String, degrees : float, duration : float = 0.5, section_percentage : float = 1.0) -> void:
	tween.tween_method(self, "_anim_contraction", get_indexed("_contraction:" + axis), degrees, duration, [axis, section_percentage])


func tween_size(percentage : float, duration : float = 0.5, section_percentage : float = 1.0) -> void:
	for i in get_sections(section_percentage):
		tween.interpolate_property(i, "length_percentage", i.length.percentage, percentage, duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)


func tween_pause(duration : float) -> void:
	tween.tween_interval(duration)


func tween_reset_to_neutral() -> void:
	tween_size(0.0, 0.2)
#	tween_rotation(0, 0.2)
#	tween_contraction(0, 0.2)



func set_attached_to(new_dict : Dictionary) -> void:
	if attached_to.limb:
		if attached_to.limb.is_connected("tween_step", self, "_on_AttachedTo_tween_step"):
			attached_to.limb.disconnect("tween_step", self, "_on_AttachedTo_tween_step")
	
	attached_to = new_dict
	
	if attached_to.limb:
		if not attached_to.limb.is_connected("tween_step", self, "_on_AttachedTo_tween_step"):
			attached_to.limb.connect("tween_step", self, "_on_AttachedTo_tween_step")
		
		if attached_to.section_of_limb:
			_apply_offset()


func set_limb_rotation(axis : String, degrees : float) -> void:
	set_indexed("_rotation:" + axis, degrees)
	_apply_rotation()



func set_contraction(axis : String, degrees : float, section_percentage : float = 1.0) -> void:
	var sections : Array = get_sections(section_percentage)
	set_indexed("_contraction:" + axis, degrees)
	
	for i in sections:
		var section_adj : float = (
				float(DEFAULT_SECTION_COUNT) / float(get_section_count())
		)
		var degrees_final : Vector3 = Vector3()
		
		degrees_final.x = (-_contraction.x * section_adj) * i.get_index()
		degrees_final.y = (-_contraction.y * section_adj) * i.get_index()
		degrees_final.z = (-_contraction.z * section_adj) * i.get_index()
		
		i.transform.basis = Basis()
		i.global_rotate(Vector3(1, 0, 0), deg2rad(degrees_final.x * _get_side("x")))
		i.global_rotate(Vector3(0, 1, 0), deg2rad(degrees_final.y * _get_side("y")))
		i.global_rotate(Vector3(0, 0, 1), deg2rad(degrees_final.z * _get_side("z")))
		i.orthonormalize()



#func set_limb_size(percentage : float, section_percentage : float = 1.0) -> void:
#	for i in get_sections(section_percentage):
#		i.set("length_percentage", percentage)



func get_section_count() -> int:
	return get_sections().size()


func get_sections(percentage : float = 1.0) -> Array:
	var sections : Array = get_children()
	
	match sign(percentage):
		1.0:
			sections.resize(ceil(sections.size() * clamp(percentage, 0.0, 1.0)))
		-1.0:
			sections.invert()
			sections.resize(ceil(sections.size() * clamp(abs(percentage), 0.0, 1.0)))
			sections.invert()
	
	return sections


func get_front_section() -> RigidBody:
	return get_sections().back()


func get_back_section() -> RigidBody:
	return get_sections().front()


func get_limb_max_length() -> float:
	var length : float = 0
	
	for i in get_sections():
		length += i.get_size()
	
	return length


func get_section_size_as_vector(section : RigidBody, percentage : float = 1.0) -> Vector2:
	var size_adjusted : float = section.get_size() * percentage
	return (size_adjusted * Vector2(0, -1)).clamped(section.get_size())



func _on_Limb_section_added(new_section : LimbSection3D) -> void:
	for i in get_sections():
		i.add_collision_exception_with(new_section)


func _on_AttachedTo_tween_step() -> void:
	_apply_offset()
