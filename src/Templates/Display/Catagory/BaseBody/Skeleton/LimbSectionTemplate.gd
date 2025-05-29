tool
extends BaseBodyTemplate
class_name LimbSectionTemplate

# This template should not be saved separately and instead as part of a 
# SkeletonTemplate.
# Catagory is important as it will be used to determine equip slots and modifiers.

export (float) var length : float = LimbSection3D.DEFAULT_LENGTH
# This percentage will be added on top of health_base.
export (float) var percentage_of_health : float = 1.0
# This is the percentage of damage that will be transfered to the soul's health.
# If the limb has no HP, then double of this percentage will be dealt instead.
export (float) var damage_to_soul_percentage : float = 1.0
# If vital, unit will die if this section reaches 0 HP or less.
export (bool) var vital : bool = false
export (PoolStringArray) var additional_equipment_slots : PoolStringArray = []
# If can_hold_items is true, this section gets a dedicated slot for holding an item.
# If can_use_items is true, this section can use any item within its slot. Does nothing if
# can_hold_items is false.
export (Dictionary) var grab : Dictionary = {
	can_hold_items = false,
	can_use_items = false,
}
# Penalty structure:
#{
#	target_attribute = AttributeTemplate,
#	max_penalty = 25,
#	percent_threshold = 0.5,
#}
# Where:
#	target_attribute is the template of the attribute you want to target.
#	max_penalty is the max points deducted from target attribute.
#	percent_threshold is the health percentage that the penalty will apply and 
#	and scale linearly to the max_penalty.
export (Array) var penalty_modifiers : Array = []
export (bool) var add_penalty : bool = false setget set_add_penalty



func _init() -> void:
	health_base = 0
	catagory = "limb_section"
	_body = preload("res://src/Test/3d test/Body3D/new folder/LimbSection3D.tscn")
	mesh = preload("res://assets/graphics/limbs/default_limb_section_mesh.tres")



func set_add_penalty(value : bool) -> void:
	if value:
		penalty_modifiers.append({
			percentage_threshold = 0.5,
			modifier = Resource.new()
		})
		
		property_list_changed_notify()
