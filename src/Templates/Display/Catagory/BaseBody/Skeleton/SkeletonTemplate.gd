tool
extends BaseTemplate
class_name SkeletonTemplate

const _LimbStruct : Dictionary = {
	name = "uninitialized",
	offset = Vector3(420, 69, 13),
	side = 0,
	connected_to = [],
	sections = []
}

# Use the skeleton tool to create this template.
# Structure of a limb:
#{
#	name = "arm",
#	group = "RightArm",
#	offset = Vector3(420, 69, 0),
#	connected_to = [
# 		name_of_limb,
# 		name_of_section,
# 	],
#	sections = [-array_of_LimbSectionTemplates-],
#}
# Structure of a limb_group:
# name_of_group = side_as_int

# Exported only so you can verify changes. Don't modify it directly.
# Use the skeleton tool to add/remove/modify the limbs.
export (Array) var limbs : Array = []
export (Dictionary) var limb_groups : Dictionary = {}



func init_new_limb() -> Dictionary:
	var new_struct : Dictionary = _LimbStruct.duplicate(true)
	limbs.append(new_struct)
	return new_struct


func add_limb_group(group_name : String, side : int) -> void:
	limb_groups.group_name = side
