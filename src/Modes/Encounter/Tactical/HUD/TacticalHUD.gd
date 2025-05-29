extends Control

const CharacterInfo : PackedScene = preload("res://src/Modes/Encounter/Tactical/HUD/CharacterInfo.tscn")
const QuickMenu : PackedScene = preload("res://src/Modes/Encounter/Tactical/HUD/QuickMenu/QuickMenu.tscn")
const RevealCircle : GDScript = preload("res://src/Modes/Encounter/Tactical/HUD/RevealCircle.gd")

var selected_soul : Soul = null setget set_selected_soul

onready var phase_bar : ProgressBar = ($PhaseBar as ProgressBar)
onready var instruction_label : ScrollingText = ($ActionInstructions/Label as ScrollingText)
onready var drawing_board : Node2D = owner.get_node("DrawingBoard") if owner else null
onready var animation : AnimationPlayer = ($AnimationPlayer as AnimationPlayer)



func _ready() -> void:
	var portraits : Array = get_portraits()
	var party_members : Array = PartySystem.get_party_members()
	
	for i in clamp(portraits.size(), 0, party_members.size()):
		portraits[i].set_soul(party_members[i])
		portraits[i].portrait.connect("gui_input", self, "_on_Portrait_gui_input", [portraits[i].soul])


func _unhandled_input(event: InputEvent) -> void:
	if selected_soul:
		if selected_soul.get_value_from_container("bodyinfo", "body").is_action_selected():
			return
		elif event.is_action_pressed("pause"):
			set_selected_soul(null)
	
	var portraits : Array = get_portraits()
	var party_inputs : Array = []
	
	for i in clamp(portraits.size(), 0, PartySystem.get_party_size()):
		party_inputs.append(event.is_action_pressed(str("p_member_", i + 1)))
	
	for i in party_inputs.size():
		if party_inputs[i]:
			set_selected_soul(get_portraits()[i].soul)
			break
	
	if event.is_action_pressed("open_quick_menu") and selected_soul:
		var quick_menu : Control = QuickMenu.instance()
		
		add_child(quick_menu)
		quick_menu.set_soul(selected_soul)
		quick_menu.connect("option_selected", self, "_on_QuickMenu_option_selected")
	
	if event.is_action_pressed("next_turn"):
		phase_bar.set("fill_enabled", true)
	elif event.is_action_released("next_turn"):
		phase_bar.set("fill_enabled", false)



func set_selected_soul(new_soul : Soul) -> void:
	if new_soul and new_soul == selected_soul:
		if not drawing_board:
			return
		
		var current_body : Unit = selected_soul.get_value_from_container("BodyInfo", "body")
		var body_position : Vector2 = current_body.get_body_position()
		var reveal_circle : Node2D = RevealCircle.new()
		
		reveal_circle.global_position = body_position
		drawing_board.add_child(reveal_circle)
		
		while true:
			var camera : Camera2D = owner.encounter_camera
			var movement : Array = [
				Input.is_action_pressed("cam_up"),
				Input.is_action_pressed("cam_down"),
				Input.is_action_pressed("cam_left"),
				Input.is_action_pressed("cam_right"),
			]
			
			if true in movement or camera.global_position.is_equal_approx(body_position):
				break
			
			camera.global_position = camera.global_position.linear_interpolate(body_position, 0.3)
			yield(get_tree().create_timer(0.01), "timeout")
		
		return
	
	if selected_soul:
		var current_body : Unit = selected_soul.get_value_from_container("BodyInfo", "body")
		
		get_assigned_portrait(selected_soul).set_is_selected(false)
		current_body.disconnect("script_confirmed", self, "_on_UnitBody_script_confirmed")
		current_body.disconnect("action_cancelled", self, "_on_UnitBody_action_cancelled")
		current_body.disconnect("action_confirmed", self, "_on_UnitBody_action_confirmed")
		current_body.disconnect("action_selected", self, "_on_UnitBody_action_selected")
	
	selected_soul = new_soul
	
	if selected_soul:
		var new_body : Unit = selected_soul.get_value_from_container("BodyInfo", "body")
		
		get_assigned_portrait(selected_soul).set_is_selected(true)
		new_body.connect("script_confirmed", self, "_on_UnitBody_script_confirmed")
		new_body.connect("action_cancelled", self, "_on_UnitBody_action_cancelled")
		new_body.connect("action_confirmed", self, "_on_UnitBody_action_confirmed")
		new_body.connect("action_selected", self, "_on_UnitBody_action_selected")



#func get_body_from_soul(soul : Soul) -> Unit:
#	if not soul:
#		return null
#
#	var body_info : DataContainer = soul.get_container("BodyInfo")
#
#	if not body_info:
#		LogSystem.write_to_debug("Could not get body info from soul.", 0)
#		return null
#
#	return body_info.get("body")


func get_assigned_portrait(soul : Soul) -> AspectRatioContainer:
	for i in get_portraits():
		if i.soul == soul:
			return i
	
	return null


func get_portraits() -> Array:
	return $HBoxContainer/Party/ScrollContainer/CharacterStatus.get_children()



func _on_Portrait_gui_input(event : InputEvent, soul : Soul) -> void:
	if owner:
		if owner.is_in_action_phase():
			return
	
	if event.is_action_pressed("select"):
		set_selected_soul(soul)


func _on_QuickMenu_option_selected(option : String) -> void:
	if option == "OpenActionMenuButton":
		var action_menu : Control = load("res://src/Modes/Encounter/Tactical/HUD/ActionMenu/ActionMenu.tscn").instance()
		
		add_child(action_menu)
		action_menu.set_soul(selected_soul)


func _on_UnitBody_selected(body : Unit) -> void:
	set_selected_soul(body.soul)


func _on_UnitBody_action_selected(action : ActionTemplate, action_object : ActionScript) -> void:
	instruction_label.text = action_object.selected_instructions
	instruction_label.reset_scroll()
	instruction_label.set_process(true)
	animation.play("move_instructions")


func _on_UnitBody_script_confirmed(action_script : ActionScript, next_script : ActionScript) -> void:
	animation.play_backwards("move_instructions")
	yield(animation, "animation_finished")
	instruction_label.text = next_script.selected_instructions
	instruction_label.reset_scroll()
	animation.play("move_instructions")


func _on_UnitBody_action_cancelled(action : ActionTemplate) -> void:
	animation.play_backwards("move_instructions")
	instruction_label.set_process(false)


func _on_UnitBody_action_confirmed(action : ActionTemplate) -> void:
	animation.play_backwards("move_instructions")
	instruction_label.set_process(false)



func _on_action_phase_started() -> void:
	set_selected_soul(null)
	set_process_unhandled_input(false)
	phase_bar.set("fill_drain_if_disabled", true)
	phase_bar.set("fill_enabled", false)
	phase_bar.set("flash_enabled", true)


func _on_action_phase_ended() -> void:
	set_process_unhandled_input(true)
	phase_bar.set("fill_drain_if_disabled", false)
	phase_bar.set("flash_enabled", false)
	phase_bar.max_value = 100


func _on_new_body_added(body : Unit) -> void:
	if body.soul in PartySystem.get_party_members():
		body.connect("body_selected", self, "_on_UnitBody_selected")


func _on_time_passed(action_phase_time_left : float, action_phase_time : float, _time_in_battle : float) -> void:
	phase_bar.max_value = action_phase_time
	phase_bar.value = action_phase_time_left
