extends Control

var soul : Soul = null setget set_soul
var _double_click_timer : SceneTreeTimer = null

onready var signature : VBoxContainer = ($PanelContainer/VBoxContainer/CardBackground/Front/CharacterInfoPortrait/VBoxContainer2/Signature as VBoxContainer)
onready var portrait: TextureRect = $PanelContainer/VBoxContainer/CardBackground/Front/CharacterInfoPortrait/VBoxContainer/Portrait
onready var watermark: TextureRect = $PanelContainer/VBoxContainer/CardBackground/Back/Watermark
onready var front: VBoxContainer = $PanelContainer/VBoxContainer/CardBackground/Front
onready var back: Control = $PanelContainer/VBoxContainer/CardBackground/Back
onready var card_background: PanelContainer = $PanelContainer/VBoxContainer/CardBackground
onready var id_label: Label = $PanelContainer/VBoxContainer/IDLabel
onready var card_label: Label = $PanelContainer/VBoxContainer/CardLabel




func _ready() -> void:
	card_background.connect("gui_input", self, "_on_CardBackground_gui_input")
	portrait.connect("new_photo_set", self, "_on_Portrait_new_photo_set")
	set_soul(PartySystem.get_leader())



func set_owner_name(new_name : String) -> void:
	signature.set_text(soul.get_value_from_container("soul_name", "full_name"))


func set_soul(new_soul : Soul) -> void:
	if soul:
		soul.disconnect("changed_value_sent", self, "_on_Soul_changed_value_sent")
	
	soul = new_soul
	
	if soul:
		watermark.texture = soul.get_value_from_container("appearance", "custom_portrait")
		portrait.set_photo(soul.get_value_from_container("appearance", "custom_portrait"))
		soul.connect("changed_value_sent", self, "_on_Soul_changed_value_sent")
		set_owner_name(soul.get_value_from_container("soul_name", "full_name"))



func _on_CardBackground_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		if not _double_click_timer:
			_double_click_timer = get_tree().create_timer(0.25)
			_double_click_timer.connect("timeout", self, "_on_DoubleClickTimer_timeout")
		elif _double_click_timer.time_left:
			front.visible = !front.visible
			back.visible = !back.visible
			card_label.visible = !card_label.visible
			id_label.visible = !id_label.visible
			_double_click_timer = null


func _on_DoubleClickTimer_timeout() -> void:
	_double_click_timer = null


func _on_Portrait_new_photo_set(new_photo : Texture) -> void:
	watermark.texture = new_photo


func _on_Soul_changed_value_sent(container_name : String, value_name : String, value_new, value_old) -> void:
	if container_name == "soul_name" and value_name == "full_name":
		set_owner_name(value_new)
