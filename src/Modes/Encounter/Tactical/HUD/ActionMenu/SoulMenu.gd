extends PopupPanel

var soul : Soul = null setget set_soul
var _action_list : Dictionary = {}

onready var soul_name_label : Label = ($VBoxContainer/SoulName as Label)
onready var list : ItemList = ($VBoxContainer/List as ItemList)

signal item_selected(item_idx)
signal menu_opened
signal menu_closed



func _ready() -> void:
	set_soul(PartySystem.get_leader())
	call_deferred("popup")


func _input(event: InputEvent) -> void:
	if not Input.is_mouse_button_pressed(BUTTON_RIGHT):
		if visible:
			var selected_item : PoolIntArray = list.get_selected_items()
	#		var state_machine : Node = soul.get_container("BodyInfo").get("state_machine")
			
			if not selected_item.empty():
				var item : String = list.get_item_text(selected_item[0])
	#			state_machine.prepare_action(_action_list.get(item))
			
			hide()
	elif not visible:
		rect_global_position = get_global_mouse_position()
		show()



func set_soul(new_soul : Soul) -> void:
	soul = new_soul
	
	if not soul:
		return
	
	soul_name_label.text = soul.name
	_action_list = soul.get_container("actions").get_data()
	
	for i in _action_list:
		list.add_item(i)
