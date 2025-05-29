extends Spatial
class_name Skeleton3D

signal wounded(projectile, limb)

const LimbGroup : GDScript = preload("res://src/Test/3d test/Body3D/new folder/LimbGroup3D.gd")

var soul : Soul = null setget set_soul
var _current_animation : Resource = null setget set_current_animation, get_current_animation



func add_limb_to_group(group_name : String, limb_name : String, limb_template : BaseTemplate) -> void:
	if not has_node(group_name):
		return
	
	get_node(group_name).add_limb(limb_name)


func create_limb_group(group_name : String) -> LimbGroup3D:
	if has_node(group_name):
		return get_node(group_name) as LimbGroup3D
	
	var new_group : LimbGroup3D = LimbGroup.new()
	
	new_group.name = group_name
	add_child(new_group)
	return new_group


func play_animation(template : AnimationTemplate) -> void:
	for i in template.animation_data:
		match i.target_type:
			"LimbGroup3D":
				get_node(i.target_name)
			"Limb3D":
				pass



func set_current_animation(file : Resource) -> void:
	_current_animation = file
	# Do some set up here.


func set_soul(new_soul : Soul) -> void:
	soul = new_soul



func get_current_animation() -> Resource:
	return _current_animation


func get_limbs_grouped() -> Dictionary:
	var limbs_grouped : Dictionary = {}
	
	for i in get_children():
		limbs_grouped[i] = i.get_children()
	
	return limbs_grouped


func get_limb_groups() -> Array:
	return get_children()


func get_limbs() -> Array:
	var limbs : Array = []
	
	for i in get_children():
		limbs.append_array(i.get_children())
	
	return limbs


func get_limb_from_group(group_name : String, limb_name : String) -> Limb3D:
	return null
