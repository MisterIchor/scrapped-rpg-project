tool
extends Container
class_name DocumentTabsContainer

signal tab_changed(new_tab)

export (int) var _selected_tab : int = 0 setget set_selected_tab
# If true and _selected_tab is set to its current tab, then _selected_tab will 
# set to -1.
export (bool) var hide_on_same_tab_selected : bool = false
# If hide_on_same_tab_selected is true, this affects whether the last tab should
# set _selected_tab to -1 or tab_count + 1.
# Has no effect is hide_on_same_tab_selected is false.
export (bool) var tab_count_plus_one_if_last : bool = false

var _tab_node : Node = Node.new()
var _rearranging : bool = false



func _ready() -> void:
	_tab_node.name = "TabNode"
	add_child(_tab_node, true)


func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		_arrange_tabs()
		
		for i in range(0, get_child_count() - 1):
			var child : Node = get_child(i)
			
			if not child.is_connected("tree_exiting", self, "_on_Control_tree_exiting"):
				child.connect("tree_exiting", self, "_on_Control_tree_exiting", [child.name])
			
			if not get_tab(child.name):
				create_tab(child.name)
			
			child.visible = (i == _selected_tab)
			get_tab(child.name).pressed = (i == _selected_tab)
			fit_child_in_rect(child, Rect2(Vector2(), rect_size))


func _set(property: String, value) -> bool:
	if property == "rect_position":
		rect_position = value
		_arrange_tabs()
		return true
	
	return false



func _arrange_tabs() -> void:
	if _rearranging:
		return
	
	var previous_tab : Control = null
	var selected_tab_reached : bool = false
	var overall_size : float = 0.0
	
	_rearranging = true
	yield(get_tree(), "idle_frame")
	
	for i in _tab_node.get_children():
		if selected_tab_reached or _selected_tab == -1:
			i.rect_position.x = rect_size.x + i.rect_size.y + rect_position.x
		else:
			if i == get_selected_tab():
				selected_tab_reached = true
			
			i.rect_position.x = rect_position.x
		
		if previous_tab:
			i.rect_position.y = previous_tab.rect_position.y + previous_tab.rect_size.x
			i.rect_position.y += 1
		else:
			i.rect_position.y = rect_position.y + 8
		
		overall_size += i.rect_size.x
		previous_tab = i
	
	emit_signal("tab_changed", _selected_tab)
	_tab_node.raise()
	_rearranging = false



func create_tab(tab_name : String) -> void:
	if get_tab(tab_name):
		return
	
	var new_tab : Button = Button.new()
	
	new_tab.rect_size = Vector2(88, 20)
	new_tab.name = str(tab_name, "Tab")
	new_tab.text = tab_name
	new_tab.toggle_mode = true
	new_tab.action_mode = BaseButton.ACTION_MODE_BUTTON_RELEASE
	new_tab.rect_rotation = 90
	_tab_node.add_child(new_tab)
	new_tab.connect("button_up", self, "_on_TabButton_up", [new_tab])
	notification(NOTIFICATION_SORT_CHILDREN)


func delete_tab(tab_name : String) -> void:
	var tab : Button = get_tab(tab_name)
	
	if tab:
		tab.queue_free()
		notification(NOTIFICATION_SORT_CHILDREN)



func set_selected_tab(new_tab : int) -> void:
	_selected_tab = clamp(new_tab, -1, get_tab_count())
	
	if not is_inside_tree():
		yield(self, "ready")
	
	notification(NOTIFICATION_SORT_CHILDREN)



func get_selected_tab() -> Button:
	if _selected_tab == -1 or _selected_tab >= _tab_node.get_child_count():
		return null
	
	return _tab_node.get_child(_selected_tab) as Button


func get_tab(tab_name : String) -> Button:
	return _tab_node.get_node_or_null(tab_name + "Tab") as Button


func get_tab_count() -> int:
	return _tab_node.get_child_count()



func _on_Control_tree_exiting(control_name : String) -> void:
	delete_tab(control_name)


func _on_TabButton_up(tab : Button) -> void:
	if tab.is_hovered():
		if tab == get_selected_tab() and hide_on_same_tab_selected:
			if get_selected_tab().get_index() == get_tab_count() - 1 and tab_count_plus_one_if_last:
				set_selected_tab(get_tab_count())
			else:
				set_selected_tab(-1)
		else:
			set_selected_tab(tab.get_index())
