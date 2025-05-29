extends Control

signal option_selected(option)

var soul : Soul = null setget set_soul

var _is_playing_backwards : bool = false
var _button_focus : Button = null

onready var nickname : Label = ($MenuBackground/MenuList/Nickname as Label)
onready var menu_list : VBoxContainer = ($MenuBackground/MenuList as VBoxContainer)
onready var quick_action : PanelContainer = ($QuickAction as PanelContainer)
onready var animation : AnimationPlayer = ($SoulMenuAnimation as AnimationPlayer)
onready var actions_button : Button = ($MenuBackground/MenuList/ActionsButton as Button)
onready var inv_button : Button = ($MenuBackground/MenuList/InvButton as Button)
onready var profile_button : Button = ($MenuBackground/MenuList/ProfileButton as Button)
onready var action_menu_button : Button = ($QuickAction/VBoxContainer/OpenActionMenuButton as Button)


func _init() -> void:
	rect_scale = Vector2()


func _enter_tree() -> void:
	rect_global_position = get_global_mouse_position()


func _ready() -> void:
	inv_button.connect("mouse_entered", self, "_on_Button_mouse_entered", [inv_button])
	profile_button.connect("mouse_entered", self, "_on_Button_mouse_entered", [profile_button])
	actions_button.connect("mouse_entered", self, "_on_Button_mouse_entered", [actions_button])
	action_menu_button.connect("mouse_entered", self, "_on_Button_mouse_entered", [action_menu_button])
	animation.connect("animation_started", self, "_on_animation_started")
	animation.connect("animation_finished", self, "_on_animation_finished")
	animation.play("menu_transition")
	show()



func _input(event: InputEvent) -> void:
	if event.is_action_released("open_quick_menu"):
		animation.play_backwards("menu_transition")
		
		if _button_focus:
			if _button_focus.is_hovered():
				emit_signal("option_selected", _button_focus.name)



func set_soul(new_soul : Soul) -> void:
	soul = new_soul
	
	if not soul:
		return
	
	nickname.text = soul.get_value_from_container("soul_name", "nickname")
	
#	for i in _action_quick_action:
#		quick_action.add_item(i)



func _on_animation_started(anim_name : String) -> void:
	_is_playing_backwards = (animation.get_playing_speed() == -1)


func _on_animation_finished(anim_name : String) -> void:
	if _is_playing_backwards:
		queue_free()


func _on_Button_mouse_entered(button : Button) -> void:
	if button == actions_button:
		quick_action.show()
	elif quick_action.visible and not button == action_menu_button:
		quick_action.hide()
	
	button.grab_focus()
	_button_focus = button
