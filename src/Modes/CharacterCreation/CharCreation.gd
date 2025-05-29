extends DocumentTabsContainer

var current_page : NodePath = "FrontCover" setget set_current_page
var character : Node
var gen_points : int = 50
var name_generator : NameGenerator = NameGenerator.new()
var soul : Soul = Soul.new()



func _ready() -> void:
	MusicSystem.play_song("res://assets/music/character_creation/theme.ogg")
#	call_deferred("add_tabs")
#	resize_tab_containers()



func add_scene(scene : String, child : Node = self, allow_duplicates : bool = false) -> void:
	if Engine.editor_hint:
		var new_scene : Node = load(scene).instance()
		
		if not allow_duplicates and has_node(new_scene.name):
			return
		
		child.add_child(new_scene, true)
		new_scene.set_owner(self)


func resize_container() -> void:
	rect_size = get_node(current_page).rect_size
#	resize_tab_containers()


#func resize_tab_containers() -> void:
#	fit_child_in_rect(get_node("LeftTabControl"), Rect2(-19,2, 20, rect_size.y))
#	fit_child_in_rect(get_node("RightTabControl"), Rect2(rect_size.x - 3, 2, 20, rect_size.y))


func hide_all_but_current() -> void:
	get_node(current_page).show()
	
	for i in range(2, get_child_count()):
			if get_child(i) != get_node(current_page):
				get_child(i).hide()


func add_tabs() -> void:
	for child in get_node("RightTabControl").get_children():
#		print("Child Free")
		child.queue_free()
	
	for i in range(2, get_child_count()):
#		print("Child added")
		add_scene("res://Entities/Items/Documents/Tab.tscn", get_node("RightTabControl"), true)
	
	for child in $RightTabControl.get_children():
#		print("Child connected")
		child.connect("tab_pressed", self, "_on_Tab_pressed")



func set_current_page(page : NodePath) -> void:
	current_page = page
	
	if Engine.editor_hint:
		yield(get_tree().create_timer(0.1), "timeout")
	
	hide_all_but_current()
	resize_container()



func _on_Tab_pressed(node : Node) -> void:
	var parent_name : String = node.get_parent().name
	var index : int = node.get_index()
	
	node.get_parent().remove_child(node)
	set_current_page(get_child(index + 2).get_path())
	
	if parent_name == "LeftTabControl":
		get_node("RightTabControl").add_child(node)
	else:
		get_node("LeftTabControl").add_child(node)
