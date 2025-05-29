tool
extends BaseBodyTemplate
class_name LimbGibletTemplate

# See LimbSectionTemplate for information about penalties.
# The only difference here is that penalties don't have a health threshold as 
# they are applied when the LimbGiblet is injured.
# Penalty structure:
# {
# 	target_attribute = AttributeTemplate,
# 	penalty = 25,
# }
# Also, giblets don't use meshes, so don't assign a mesh to them. That's bad >:(

# health_base is used for the amount of damage at once required to injure this giblet.

export (Array) var penalties : Array = []
export (bool) var add_penalty : bool = false setget set_add_penalty



func _init() -> void:
	_body = preload("res://src/Test/3d test/Body3D/new folder/LimbGiblet3D.tscn")



func set_add_penalty(value : bool) -> void:
	if value:
		penalties.append({
			target_attribute = Resource.new(),
			penalty = 25,
		})
		
		property_list_changed_notify()
