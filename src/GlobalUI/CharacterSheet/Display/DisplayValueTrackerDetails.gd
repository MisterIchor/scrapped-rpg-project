extends Popup

const DisplayContainerValue : PackedScene = preload("res://src/GlobalUI/CharacterSheet/Display/DisplayContainerValue.tscn")

var value_tracker = null setget set_value_tracker

onready var description : Label = ($PanelContainer/VBoxContainer/Details/VBoxContainer/TabContainer/Description as Label)
onready var breakdown : VBoxContainer = ($PanelContainer/VBoxContainer/Details/VBoxContainer/TabContainer/Breakdown/VBoxContainer as VBoxContainer)
onready var icon : TextureRect = ($PanelContainer/VBoxContainer/Details/VBoxContainer/Icon as TextureRect)
onready var tracker_name_label : Label = ($PanelContainer/VBoxContainer/TrackerNameLabel as Label)
onready var background : ColorRect = ($Background as ColorRect)



func _ready() -> void:
	connect("popup_hide", self, "_on_popup_hide")
	background.connect("gui_input", self, "_on_Background_gui_input")



func set_value_tracker(new_tracker : ValueTracker) -> void:
	value_tracker = new_tracker
	
	if not is_inside_tree():
		yield(self, "ready")
	
	tracker_name_label.text = value_tracker.name
	icon.texture = value_tracker.get("icon")
	description.text = value_tracker.get("description")
	value_tracker.connect("value_changed", self, "_on_ValueTracker_value_changed")
	
	var data : Dictionary = value_tracker.get_data()
	
	for i in data:
		var node : Node = breakdown.get_node_or_null(i)
		var data_in_key = data.get(i)
		
		if not node:
			var accepted_types : PoolIntArray = [
				TYPE_INT,
				TYPE_REAL,
				TYPE_STRING,
				TYPE_STRING_ARRAY
			]
			
			if not typeof(data_in_key) in accepted_types:
				continue 
			
			node = DisplayContainerValue.instance()
			node.name = i
		
		node.set_value_name(i)
		node.set_value(data_in_key)
		breakdown.add_child(node)



func _on_Background_gui_input(event : InputEvent) -> void:
	if event.is_action_pressed("select"):
		hide()


func _on_popup_hide() -> void:
	queue_free()
