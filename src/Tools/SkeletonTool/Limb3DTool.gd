tool
extends Limb3D



func _set(property: String, value) -> bool:
	match property:
		"attach_limb":
			if not is_inside_tree():
				yield(self, "ready")
			
			if not Engine.editor_hint:
				if (value as NodePath).get_name(1) == "EditorNode":
					var new_value : String = "/root"
					
					for i in range(2, (value as NodePath).get_name_count()):
						if not "@" in value.get_name(i):
							new_value += str("/", value.get_name(i))
					
					value = NodePath(new_value)
			
			var attached_dict : Dictionary = attached_to.duplicate()
			attached_dict.limb = get_node_or_null(value)
			set_attached_to(attached_dict)
			property_list_changed_notify()
			return true
		"attach_section_of_limb":
			if not is_inside_tree():
				yield(self, "ready")
			
			var attached_dict : Dictionary = attached_to.duplicate()
			
			if not attached_to.limb:
				attached_dict.section_of_limb = null
			else:
				attached_dict.section_of_limb = attached_to.limb.get_child(value)
			
			set_attached_to(attached_dict)
			return true
		"attach_offset":
			var attached_dict : Dictionary = attached_to.duplicate()
			attached_dict.offset = value
			set_attached_to(attached_dict)
			return true
	
	return false


func _get(property: String):
	match property:
		"attach_limb":
			return attached_to.limb.get_path() if attached_to.limb else ""
		"attach_section_of_limb":
			return attached_to.section_of_limb.get_index() if attached_to.section_of_limb else 0
		"attach_offset":
			return attached_to.offset


func _get_property_list() -> Array:
	var property_list : Array = []
	
	property_list.append({
		name = "Attachment Settings",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE,
		hint_string = "attach_"
	})
	
	property_list.append({
		name = "attach_limb",
		type = TYPE_NODE_PATH
	})
	
	var sections_in_limb : PoolStringArray = []
	
	if attached_to.limb:
		for i in attached_to.limb.get_children():
			sections_in_limb.append(i.name)
	
	property_list.append({
		name = "attach_section_of_limb",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = sections_in_limb.join(",")
	})
	
	property_list.append({
		name = "attach_offset",
		type = TYPE_VECTOR3
	})
	
	return property_list
