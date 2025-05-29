extends ScrollContainer

onready var values_container: VBoxContainer = $ValuesContainer



func initialize_template_values(template : BaseTemplate) -> void:
	for i in values_container.get_children():
		i.queue_free()
	
	var template_properties : Dictionary = template.get_template_properties()
	
	for i in template_properties:
		var value = template.get(i)
		var value_hint : int = template_properties[i].get("hint")
		var value_type : int = typeof(value)
		var valid_types : PoolIntArray = [
			TYPE_INT,
			TYPE_REAL,
			TYPE_STRING,
		]
		
		if value_type in valid_types:
			var hbox : HBoxContainer = HBoxContainer.new()
			var label : Label = Label.new()
			hbox.add_child(label)
			label.size_flags_vertical = SIZE_FILL
			label.text = i.capitalize() + ": "
			
			match value_type:
				TYPE_INT, TYPE_REAL:
					hbox.add_child(SpinBox.new())
				TYPE_STRING:
					match value_hint:
						PROPERTY_HINT_MULTILINE_TEXT:
							var text_edit : TextEdit = TextEdit.new()
							hbox.add_child(text_edit)
							text_edit.size_flags_horizontal = SIZE_EXPAND_FILL
							text_edit.rect_min_size = Vector2(0, 128)
						_:
							hbox.add_child(LineEdit.new())
			
			values_container.add_child(hbox)
