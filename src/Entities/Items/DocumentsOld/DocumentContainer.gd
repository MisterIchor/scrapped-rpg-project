tool
extends Container

export (String, "Page", "Tabbed") var type setget set_type
export (int, 2, 99) var number_of_pages : int = 0 setget set_number_of_pages
export (NodePath) var current_page : NodePath setget set_current_page

var container : Container = ($"." as Container)



func _ready() -> void:
	if not Engine.editor_hint:
		if type == "Tabbed":
			for child in get_node("RightTabControl").get_children():
				child.connect("tab_pressed", self, "_on_Tab_pressed")
		
		for i in range(get_start(), get_child_count()):
			get_child(i).connect("gui_input", self, "_on_Page_gui_input")



func resize_container() -> void:
	container.rect_size = get_node(current_page).rect_size
	if type == "Tabbed":
		resize_tab_containers()


func resize_tab_containers() -> void:
	container.fit_child_in_rect(get_node("LeftTabControl"), Rect2(-19,2, 20, container.rect_size.y))
	container.fit_child_in_rect(get_node("RightTabControl"), Rect2(container.rect_size.x - 3, 2, 20, container.rect_size.y))


func add_tabs() -> void:
	if type == "Tabbed":
		clear_children(get_node("RightTabControl"))
		for i in range(get_start(), get_child_count()):
			add_scene("res://Entities/Items/Documents/Tab.tscn", get_node("RightTabControl"), false)


func hide_all_but_current() -> void:
	get_node(current_page).show()
	for i in range(get_start(), get_child_count()):
			if get_child(i) != get_node(current_page):
				get_child(i).hide()


func get_start() -> int:
	return 0 if type != "Tabbed" else 2



func set_type(new_type : String) -> void:
	type = new_type
	if Engine.editor_hint:
		yield(get_tree().create_timer(0.1),"timeout")
		match type:
			"Page":
				if has_node("LeftTabControl"):
					get_node("LeftTabControl").free()
				if has_node("RightTabControl"):
					get_node("RightTabControl").free()
			"Tabbed":
				add_node(VBoxContainer.new(), "LeftTabControl")
				add_node(VBoxContainer.new(), "RightTabControl")
				move_child(get_node("LeftTabControl"), 0)
				move_child(get_node("RightTabControl"), 1)
				clear_children(get_node("LeftTabControl"))
				clear_children(get_node("RightTabControl"))
				
				resize_tab_containers()
				add_tabs()


func set_number_of_pages(new_number : int) -> void:
	number_of_pages = new_number
	if Engine.editor_hint:
		yield(get_tree().create_timer(0.1), "timeout")
		var difference : int = number_of_pages - (get_child_count() - get_start())
		if difference != 0:
			match sign(difference):
				1.0:
					for i in difference:
						add_scene("res://Entities/Items/Documents/Page.tscn", self, true)
				-1.0:
					for i in range(abs(difference), 0, -1):
						get_child(get_child_count() - i).queue_free()
			
			for child in range(get_start() + 1, get_child_count() - 1):
				get_child(child).set_type("Page")
			get_child(get_start()).set_type("Cover")
			get_child(get_child_count() - 1).set_type("Cover")
			
			hide_all_but_current()
			add_tabs()
			resize_container()


func set_current_page(page : NodePath) -> void:
	current_page = page
	if Engine.editor_hint:
		yield(get_tree().create_timer(0.1), "timeout")
	hide_all_but_current()
	resize_container()


func _on_Page_gui_input(event : InputEvent) -> void:
	if Input.is_action_pressed("left_mouse"):
		container.rect_position = get_viewport().get_mouse_position() 


func _on_Tab_pressed(node : Node) -> void:
	var parent_name : String = node.get_parent().name
	var index : int = node.get_index()
	
	node.get_parent().remove_child(node)
	set_current_page(get_child(index + 2).get_path())
	if parent_name == "LeftTabControl":
		get_node("RightTabControl").add_child(node)
	else:
		get_node("LeftTabControl").add_child(node)
