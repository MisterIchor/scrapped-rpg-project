extends Node2D

var limbs : Dictionary = {}



func _add_limb(new_limb : Node2D, addition_data : Dictionary = {}) -> void:
	if limbs.get(new_limb):
		return
	
	var limb_dict : Dictionary = {}
	
	limb_dict.sections = new_limb.get_children()
	limb_dict.tween = limb_dict.sections.pop_front()
	limb_dict.rest_pos = {}
	
	for i in limb_dict.sections:
		limb_dict.rest_pos[i] = {
			front = i.get_front_pos(),
			back = i.position
		}
	
	for i in addition_data:
		limb_dict[i] = addition_data[i]
	
	limbs[new_limb] = limb_dict
	print(limb_dict)
