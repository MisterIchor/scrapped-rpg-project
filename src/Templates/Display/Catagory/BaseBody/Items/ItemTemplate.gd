tool
extends BaseBodyTemplate
class_name ItemTemplate

enum EquipType {OCCUPY_ALL, INTERCHANGEABLE}

export (PoolStringArray) var display_exceptions : PoolStringArray = [
	"sound_bank",
	"slots_occupied",
	"icon",
	"description",
	"catagory",
	"collision_data",
	"height",
	"sprite",
	"price_mod",
	"display_exceptions",
	"_body",
	"name",
]
export (int) var base_price : int = -1
export (float) var weight : float = -1
export (Dictionary) var slots_occupied : Dictionary = {
	face = false,
	head_top = false,
	eyes = false,
	snout = false,
	neck = false,
	shoulder_left = false,
	shoulder_right = false,
	chest = false,
	torso = false,
	bicep_left = false,
	bicep_right = false,
	elbow_left = false,
	elbow_right = false,
	forearm_left = false,
	forearm_right = false,
	wrist_left = false,
	wrist_right = false,
	hand_left = false,
	hand_right = false,
	thigh_left = false,
	thigh_right = false,
	calf_left = false,
	calf_right = false,
	tail_base = false,
	tail_tip = false,
	leg_left = false,
	leg_right = false,
	foot_left = false,
	foot_right = false
}
export (EquipType) var equip_type : int = EquipType.OCCUPY_ALL
export (bool) var reparable : bool = true
export (Array) var repair_formula : Array = []




func _init() -> void:
	add_bank("pickup")
	add_bank("drop")
	add_bank("equip")
	add_bank("break")
	add_bank("impact")



func get_template_properties() -> Dictionary:
	var properties : Dictionary = .get_template_properties()
	properties["equip_type"] = EquipType.keys()[equip_type]
	return properties
