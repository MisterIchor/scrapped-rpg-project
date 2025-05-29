extends ItemList

var input_history : Array = [] setget , get_input_history

signal prev_input_selected(text)



func _enter_tree() -> void:
	connect("item_selected", self, "_on_item_selected")


func _ready() -> void:
	ConsoleSystem.add_to_console(self)



func _input(event: InputEvent) -> void:
	var selected_items : Array = get_selected_items()
	
	if selected_items.size():
		if event.is_action_pressed("ui_up"):
			_select_item(selected_items[0] - 1)
		
		if event.is_action_pressed("ui_down"):
			_select_item(selected_items[0] + 1)
		
		if event.is_action_pressed("ui_accept"):
			emit_signal("prev_input_selected", get_item_text(selected_items[0]))
			hide()
		
#		get_tree().set_input_as_handled()




func _format_list(list : Array, text : String) -> Array:
	var what_to_erase : Array = []
	
	for i in list:
		var text_lowercase : String = i.to_lower()
		
		if not text_lowercase.begins_with(text) and not i.begins_with(text):
			what_to_erase.append(i)
	
	for j in what_to_erase:
		list.erase(j)
	
	return list


func _select_item(index : int) -> void:
	if not get_item_count():
		return
	
	grab_focus()
	select(clamp(index, 0, get_item_count()))


func _set_item_list(list : Array) -> void:
	clear()
	
	for i in list:
		add_item(i)



func get_input_history() -> Array:
	return input_history



func _on_item_selected(index : int) -> void:
	emit_signal("prev_input_selected", get_item_text(index))
	hide()


func _on_focus_entered() -> void:
	if input_history.size():
		show()


func _on_focus_exited() -> void:
	hide()


func _on_text_changed(new_text : String) -> void:
	if not new_text.length():
		_set_item_list(get_input_history())
		return
	
	var list : Array = []
	
	match new_text.count(" "):
		0:
			list = _format_list(ConsoleSystem.get_loaded_objects(), new_text)
		1:
			var object_name : String = new_text
			var variable : String = new_text
			
			object_name.erase(object_name.find(" "), object_name.length())
			variable.erase(0, object_name.length() + 1)
			list = _format_list(ConsoleSystem.get_list_of_functions_from_object(object_name), variable)
	
	_set_item_list(list)
	show()


func _on_text_entered(new_text : String) -> void:
	input_history.push_front(new_text)
	_set_item_list(get_input_history())
	hide()
