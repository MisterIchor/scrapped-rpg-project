extends Node2D

signal action_phase_started
signal action_phase_ended
signal battle_started
signal battle_ended
signal time_passed(action_phase_time_left, action_phase_time, time_in_battle)
signal new_body_added(new_body)

const Body : PackedScene = preload("res://src/Entities/Character/Body/Unit.tscn")

var _idle_time : float = 0

var in_battle : bool = false setget set_in_battle
var time_between_phases : float = 6.0
var time_passed : float = 0.0

onready var bodies : Node2D = ($Bodies as Node)
onready var tactical_map : TileMap = ($TacticalMap as Node)
onready var tactical_hud : Control = ($EncounterCamera/CanvasLayer2/TacticalHUD as Control)
onready var encounter_camera : Camera2D = ($EncounterCamera as Camera2D)
onready var drawing_board : Node2D = ($DrawingBoard as Node2D)
onready var action_timer : Timer = ($ActionTimer as Timer)



func _physics_process(delta: float) -> void:
	if not is_in_action_phase():
		if not _idle_time > 100 and not is_equal_approx(_idle_time, -1):
			_idle_time += delta
		elif not is_equal_approx(_idle_time, -1):
			MusicSystem.play_song("res://assets/music/battle/dynamic_test/Control.ogg")
			_idle_time = -1


func _ready() -> void:
	MusicSystem.play_song("res://assets/music/battle/dynamic_test/Assault.ogg")
	tactical_map.connect("map_loaded", self, "_on_TacticalMap_loaded")
	tactical_hud.phase_bar.connect("bar_filled", self, "_on_bar_filled")
	connect("action_phase_started", tactical_hud, "_on_action_phase_started")
	connect("action_phase_ended", tactical_hud, "_on_action_phase_ended")
	connect("time_passed", tactical_hud, "_on_time_passed")
	connect("new_body_added", tactical_hud, "_on_new_body_added")
	
	var party_members : Array = PartySystem.get_party_members()
	var spawn_list : Array = tactical_map.get_spawn_points()
	
	for i in party_members.size():
		if i > spawn_list.size() - 1:
			break
		
		var new_body : Unit = add_body(party_members[i])
		
		if i == 1:
			new_body.type = Unit.UnitType.ENEMY
		
		if new_body:
			new_body.set_body_position(spawn_list[i])
	
	encounter_camera.restraints = tactical_map.get_map_size_world()
	set_process(false)
	Gambler.set_seed(Gambler.DefaultSeeds[randi() % Gambler.DefaultSeeds.size()])


func _process(delta: float) -> void:
	time_passed += delta
	emit_signal("time_passed", action_timer.time_left, time_between_phases, time_passed)



func add_body(soul : Soul, type : int = Unit.UnitType.ALLY) -> Unit:
	if has_node(str(soul.name, "Body")):
		return null
	
	var new_body : Unit = Body.instance()
	
	connect("new_body_added", new_body, "_on_new_body_added")
	connect("action_phase_started", new_body, "_on_action_phase_started")
	connect("action_phase_ended", new_body, "_on_action_phase_ended")
	bodies.add_child(new_body)
	
	for i in bodies.get_children():
		new_body.add_to_los_tracker(i)
	
	new_body.canvas_to_draw_on = drawing_board
	new_body.astar = tactical_map.astar
	new_body.type = type
	new_body.set_soul(soul)
	emit_signal("new_body_added", new_body)
	return new_body



func execute_action_phase() -> void:
	emit_signal("action_phase_started")
	set_process(true)
	MusicSystem.play_song("res://assets/music/battle/dynamic_test/Assault.ogg")
	tactical_map.astar.reset_weight_scales()
	action_timer.start(time_between_phases)
	yield(action_timer, "timeout")
	_idle_time = 0
	emit_signal("action_phase_ended")
	set_process(false)



func set_in_battle(value : bool) -> void:
	in_battle = value
	emit_signal("battle_started" if in_battle else "battle_ended")



func is_in_action_phase() -> bool:
	return !action_timer.is_stopped()



func _on_TacticalMap_loaded() -> void:
	encounter_camera.restraints = tactical_map.get_map_size_world()


func _on_bar_filled() -> void:
	if not is_in_action_phase():
		execute_action_phase()
