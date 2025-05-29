extends CatagoryTemplate
class_name RaceTemplate

export (String, DIR) var name_list_male : String = String()
export (String, DIR) var name_list_female : String = String()
export (GDScript) var name_script : GDScript
export (Dictionary) var attribute_modifiers : Dictionary = {}
export (Dictionary) var skill_modifiers : Dictionary = {}
export (float) var height_modifier : float = 1.0
export (float) var weight_modifier : float = 1.0
export (Array) var racial_traits : Array = []
export (Dictionary) var racial_resistances : Dictionary = {}
#export (String, DIR) var body : String = String()
export (PoolStringArray) var equipment_slots : PoolStringArray = [
	"head",
	"neck",
	"eye_left_0",
	"eye_right_0",
	"back",
	"chest",
	"torso",
	"waist",
	"shoulder_left_0",
	"shoulder_right_0",
	"hand_left_0",
	"hand_right_0",
	"bicep_left_0",
	"forearm_left_0",
	"forearm_right_0",
	"thigh_left_0",
	"thigh_right_0",
	"calf_left_0",
	"calf_right_0",
	"foot_left_0",
	"foot_right_0",
]



func load_trait(trait_path : String) -> Resource:
	return load(str("res://Resources/Traits/", trait_path))
