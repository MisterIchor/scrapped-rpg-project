tool
extends Skeleton3D

var limb_group_settings : Dictionary = {
	group_name = "",
	group_side = "",
}



func _ready() -> void:
	if not Engine.editor_hint:
		yield(get_tree().create_timer(0.5), "timeout")
#		$Body.tween_flex("all", 90)
#		$Body.animate()
#		_walk()
#		($ArmsLeft as LimbGroup3D).side = LimbGroup3D.Side.LEFT
#		($ArmsRight as LimbGroup3D).side = LimbGroup3D.Side.RIGHT_OR_NOT_APPLICABLE


func _set(property: String, value) -> bool:
	match property:
		"skeleton":
			return true
		"save_skeleton":
			return true
		"lgs_group_name":
			limb_group_settings.group_name = value
			return true
		"lgs_group_side":
			limb_group_settings.group_side = value
			return true
		"lgs_add_group":
			if value:
				var new_group : LimbGroup3D = create_limb_group(limb_group_settings.group_name)
				
				if new_group:
					new_group.set_script(load("res://src/Tools/SkeletonTool/LimbGroup3DTool.gd"))
					new_group.set_side(LimbGroup3D.Side.get(limb_group_settings.group_side))
					new_group.owner = self
	
	return false


func _get(property: String):
	match property:
		"lgs_group_name":
			return limb_group_settings.group_name
		"lgs_group_side":
			return limb_group_settings.group_side


func _get_property_list() -> Array:
	var property_list : Array = []
	
	property_list.append({
		name = "skeleton",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "SkeletonTemplate"
	})
	
	property_list.append({
		name = "save_skeleton",
		type = TYPE_BOOL
	})
	
	property_list.append({
		name = "Limb Group Settings",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE,
		hint_string = "lgs_"
	})
	
	property_list.append({
		name = "lgs_group_name",
		type = TYPE_STRING
	})
	
	property_list.append({
		name = "lgs_group_side",
		type = TYPE_STRING,
		hint = PROPERTY_HINT_ENUM,
		hint_string = PoolStringArray(LimbGroup3D.Side.keys()).join(",")
	})
	
	property_list.append({
		name = "lgs_add_group",
		type = TYPE_BOOL
	})
	
	return property_list



func _walk() -> void:
	while true:
		$ArmsLeft.tween_lift("all", -65)
		$ArmsRight.tween_lift("all", -65)
		$ArmsLeft.tween_swing("all", 135)
		$ArmsRight.tween_swing("all", 45)
		$ArmsLeft.tween_curl("all", 5)
		$ArmsRight.tween_curl("all", 15)
		$LegsLeft.tween_flex("all", 20)
		$LegsLeft.tween_lift("all", -55)
		$LegsRight.tween_flex("all", 5)
		$LegsRight.tween_lift("all", -115)
		$Body.tween_twist("all", 10)
		$ArmsLeft.animate()
		$ArmsRight.animate()
		$LegsLeft.animate()
		$LegsRight.animate()
		$Body.animate()
		yield(get_tree().create_timer(0.51), "timeout")
		$ArmsLeft.tween_swing("all", 45)
		$ArmsRight.tween_swing("all", 135)
		$ArmsLeft.tween_curl("all", 15)
		$ArmsRight.tween_curl("all", 5)
		$LegsLeft.tween_flex("all", 5)
		$LegsLeft.tween_lift("all", -115)
		$LegsRight.tween_flex("all", 20)
		$LegsRight.tween_lift("all", -65)
		$Body.tween_twist("all", -10)
		$ArmsLeft.animate()
		$ArmsRight.animate()
		$LegsLeft.animate()
		$LegsRight.animate()
		$Body.animate()
		yield(get_tree().create_timer(0.51), "timeout")


func _kung_fu() -> void:
	($ArmsLeft as LimbGroup3D).tween_curl("all", 45)
	($ArmsRight as LimbGroup3D).tween_curl("all", 45)
	$LegsLeft.tween_flex("all", 90, 0.5, 0.65)
	$LegsLeft.tween_lift("all", 22.5)
	$Body.tween_flex("all", 45)
	($ArmsLeft as LimbGroup3D).animate()
	($ArmsRight as LimbGroup3D).animate()
	$LegsLeft.animate()
	$Body.animate()



func set_default_pose(value : bool) -> void:
	if value:
		return


func set_save_skeleton(value : bool) -> void:
	if value:
		var new_template : SkeletonTemplate = SkeletonTemplate.new()
		
		for group in get_limbs_grouped():
			new_template.add_limb_group(group.name, group.side)
			
			for limb in group:
				var struct : Dictionary = new_template.init_new_limb()
				
				struct.name = limb.name
				struct.group = group.name
				struct.offset = limb.offset
				struct.connected_to = []
				struct.sections = []




