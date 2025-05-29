tool
extends VBoxContainer

export (String) var catagory_name : String = String() setget set_catagory_name



func _ready() -> void:
	connect("mouse_entered", self, "_on_Catagory_mouse_entered")

func set_catagory_name(new_name : String) -> void:
	catagory_name = new_name
	$Title/Name.text = new_name

func add_scene(scene : String, parent : Node = self) -> void:
	var new_scene : Node = load(scene).instance()

	parent.add_child(new_scene)
	new_scene.owner = self

func _on_Catagory_mouse_entered() -> void:
	print("help")
	$Skills.visible = true
