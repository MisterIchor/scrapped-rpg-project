extends ColorRect

signal action_selected(action)

var soul : Soul = null setget set_soul
var list_of_actions : Array = []

onready var popup : PopupPanel = ($PopupPanel as PopupPanel)
onready var action_list : ItemList = ($PopupPanel/ColorRect/HBoxContainer/Actions/ActionList as ItemList)
onready var description : RichTextLabel = ($PopupPanel/ColorRect/HBoxContainer/Description/ActionDescriptionLabel as RichTextLabel)
onready var action_preview : ViewportContainer = ($PopupPanel/ColorRect/HBoxContainer/Description/ActionPreview as ViewportContainer)



func _ready() -> void:
	connect("action_selected", action_preview, "_on_action_selected")
	popup.connect("popup_hide", self, "_on_popup_hide")
	action_list.connect("item_activated", self, "_on_ActionList_item_activated")
	action_list.connect("gui_input", self, "_on_ActionList_gui_input")
	popup.call_deferred("popup")



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
		queue_free()



func _make_description(action : ActionTemplate) -> void:
#	var stats : Dictionary = action.get_action_stats()
	
	description.clear()
	description.append_bbcode(str("[center]", action.name, "[/center]\n\n"))
	description.append_bbcode("\n\n")
	
#	for i in stats:
#		var stat_name : String = i
#
#		stat_name = stat_name.replacen("_", " ")
#		stat_name = stat_name.to_upper()
#		stat_name += str(": ", stats.get(i), "\n")
#		description.append_bbcode(stat_name)
	
	description.append_bbcode("[center]Description[/center]\n\n")
	description.append_bbcode(action.description)



func set_soul(new_soul : Soul) -> void:
	soul = new_soul
	var actions : DataContainer = soul.get_container("actions")
	var statistics : DataContainer = soul.get_container("statistics")
	
	if actions:
		list_of_actions = actions.get_data().values()
		
		for i in list_of_actions:
			action_list.add_item(i.name)
	
	if statistics:
		var recent_actions = statistics.get("recent_actions")
		
		if recent_actions:
			for i in recent_actions:
				return



func _on_popup_hide() -> void:
	queue_free()


func _on_ActionList_item_activated(idx : int) -> void:
	var body_info : DataContainer = soul.get_container("bodyinfo")
	var actions : DataContainer = soul.get_container("actions")
	
	if body_info and actions:
		var body : Unit = body_info.get("body")
		body.select_action(list_of_actions[idx])
	
	queue_free()


func _on_ActionList_gui_input(_event : InputEvent) -> void:
	var position : Vector2 = get_global_mouse_position() - action_list.rect_global_position
	var item : int = action_list.get_item_at_position(position, true)
	
	if not item == -1:
		action_list.select(item)
		_make_description(list_of_actions[item])
	else:
		action_list.unselect_all()
		description.clear()
	
	emit_signal("action_selected", list_of_actions[item] if not item == -1 else null)
