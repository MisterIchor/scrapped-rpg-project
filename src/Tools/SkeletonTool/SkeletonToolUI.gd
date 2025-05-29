extends Control

onready var add_part_button: Button = $PanelContainer/VBoxContainer/AddPartContainer/AddPartButton
onready var options_container: ScrollContainer = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/OptionsContainer
onready var no_selection_container: PanelContainer = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/NoSelectionContainer
onready var exit_button: Button = $PanelContainer/VBoxContainer/SkeletonOptions/ExitButton
onready var save_skeleton_button: Button = $PanelContainer/VBoxContainer/SkeletonOptions/SaveSkeletonButton
onready var load_skeleton_button: Button = $PanelContainer/VBoxContainer/SkeletonOptions/LoadSkeletonButton
onready var skeleton_tree: Tree = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/SkeletonTree
onready var skeleton_3d: Spatial = $PanelContainer/VBoxContainer/HBoxContainer/SkeletonView/Viewport/Skeleton3D
onready var show_wireframe_button: Button = $PanelContainer/VBoxContainer/AddPartContainer/ShowWireframeButton
onready var skeleton_camera: Camera = $PanelContainer/VBoxContainer/HBoxContainer/SkeletonView/Viewport/SkeletonCamera
onready var skeleton_view: ViewportContainer = $PanelContainer/VBoxContainer/HBoxContainer/SkeletonView
onready var name_popup: ColorRect = $NamePopup



func _ready() -> void:
	skeleton_tree.connect("item_selected", self, "_on_SkeletonTree_item_selected")
	skeleton_tree.connect("nothing_selected", self, "_on_SkeletonTree_nothing_selected")
	add_part_button.connect("button_up", self, '_on_AddPartButton_up')
	show_wireframe_button.connect("toggled", self, "_on_ShowWireframeButton_toggled")
	
	var root : TreeItem = skeleton_tree.create_item()
	root.set_text(0, "skeleton")
	root.set_metadata(0, skeleton_3d)
	
	for i in skeleton_3d.get_limb_groups():
		var group_tree_item : TreeItem = skeleton_tree.create_item(root)
		group_tree_item.set_text(0, i.name)
		group_tree_item.set_metadata(0, i)
	
	set_physics_process(false)



func _physics_process(delta: float) -> void:
	if skeleton_3d.get_limbs().empty():
		return
	
	VisualServer.canvas_item_clear(get_canvas_item())
	
	for limb in skeleton_3d.get_limbs():
		var line_to_draw : Array = []
		
		for section in limb.get_sections():
			line_to_draw.append(skeleton_camera.unproject_position(section.global_translation))
			line_to_draw.append(skeleton_camera.unproject_position(section.get_front_translation_global()))
		
		VisualServer.canvas_item_add_polyline(skeleton_view.get_canvas_item(), line_to_draw, [Color.white])


func _on_ShowWireframeButton_toggled(toggled : bool) -> void:
	set_physics_process(toggled)
	
	if not toggled:
		VisualServer.canvas_item_clear(skeleton_view.get_canvas_item())
		skeleton_view.update()

func _on_AddPartButton_up() -> void:
	var treeitem : TreeItem = skeleton_tree.create_item()
	name_popup.show()
	name_popup.treeitem = treeitem
	
	var status : int = yield(name_popup, "done")
	
	if not status:
		treeitem.free()
		return
	
	var part_name : String = treeitem.get_text(0)
	var selected_item = get_node_from_selected_tree_item()
	var part_to_parent : Node
	
	if selected_item is Skeleton3D:
		if not selected_item.get_node_or_null(part_name):
			part_to_parent = selected_item.create_limb_group(part_name)
	elif selected_item is LimbGroup3D:
		if not selected_item.get_node_or_null(part_name):
			part_to_parent = selected_item.create_limb(part_name)
	elif selected_item is Limb3D:
		if not selected_item.get_node_or_null(part_name):
			var container : LimbSectionContainer = LimbSectionContainer.new()
			part_to_parent = selected_item.create_section(container)
			container.set_template(load("res://src/Resources/Skeleton/DefaultLimbSections/DefaultLimbSection.tres"))
	
	if part_to_parent:
		treeitem.set_metadata(0, part_to_parent)
		treeitem.set_text(0, part_to_parent.name)
		part_to_parent.connect("tree_exiting", treeitem, "free")



func get_selected_tree_item() -> TreeItem:
	return skeleton_tree.get_selected()


func get_node_from_selected_tree_item():
	var selected_tree_item : TreeItem = skeleton_tree.get_selected()
	
	if not selected_tree_item:
		return null
	
	return selected_tree_item.get_metadata(0)


func _on_SkeletonTree_nothing_selected() -> void:
	options_container.hide()
	no_selection_container.show()
	
	if skeleton_tree.get_selected():
		skeleton_tree.get_selected().deselect(0)
	
	add_part_button.text = "Add..."
	add_part_button.disabled = true


func _on_SkeletonTree_item_selected() -> void:
	var node_selected = get_node_from_selected_tree_item()
	
	if node_selected is Skeleton3D:
		add_part_button.text = "Add Limb Group"
		add_part_button.disabled = false
	elif node_selected is LimbGroup3D:
		add_part_button.text = "Add Limb"
		add_part_button.disabled = false
	elif node_selected is Limb3D:
		add_part_button.text = "Add Limb Section"
		add_part_button.disabled = false
	elif node_selected is LimbSection3D:
		add_part_button.text = "Add..."
		add_part_button.disabled = true
	
	options_container.show()
	no_selection_container.hide()
	
	if node_selected.get("container"):
		options_container.initialize_template_values(node_selected.container.template)
	
	print(node_selected)
