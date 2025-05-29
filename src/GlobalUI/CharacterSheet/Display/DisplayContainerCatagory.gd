extends PanelContainer

onready var catagory_label : Label = ($VBoxContainer/Header/CatagoryLabel as Label)
onready var toggle_button : Button = ($VBoxContainer/Header/ToggleButton as Button)
onready var feature : PanelContainer = ($VBoxContainer/Features as PanelContainer)
onready var feature_container : VBoxContainer = ($VBoxContainer/Features/FeatureContainer as VBoxContainer)
onready var seperator : HSeparator = ($VBoxContainer/HSeparator as HSeparator)




func _ready() -> void:
	toggle_button.connect("toggled", self, "_on_ToggleButton_toggled")



func add_container(container : DataContainer, value_to_show : String, display : PackedScene = load("res://src/GlobalUI/CharacterSheet/Display/DisplayContainerValue.tscn") as PackedScene) -> void:
	if feature_container.get_node_or_null(container.name):
		return
	
	var new_display : Control = display.instance()
	feature_container.add_child(new_display, true)
	new_display.set_container(container)
	new_display.set_value_to_show(value_to_show)
#	new_display.connect("show_details", owner, "_on_show_details")


func expand() -> void:
	toggle_button.pressed = !toggle_button.pressed



func set_name(new_name : String) -> void:
	.set_name(new_name)
	catagory_label.text = new_name.capitalize()



func _on_ToggleButton_toggled(pressed : bool) -> void:
	toggle_button.rect_rotation = 0 if not pressed else 90
	feature.set_visible(pressed)
	seperator.set_visible(pressed)
