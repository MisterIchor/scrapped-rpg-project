extends Node

var time_between_turns : float = 6.0
var time_passed : float = 0.0
var in_battle : bool = false setget set_in_battle
var teams : Dictionary = {
	ally = [],
	enemy = [],
	neutral = [],
}
var turn_timer : Timer = Timer.new()

signal turn_started
signal turn_ended
signal battle_started
signal battle_finished
signal souls_added(list_of_souls)



func _ready() -> void:
	ConsoleSystem.add_to_console(self)
	turn_timer.set_one_shot(true)
	turn_timer.connect("timeout", self, "next_turn")
	add_child(turn_timer)
	set_process(false)


func _process(delta: float) -> void:
	time_passed += delta



func add_soul_to_team(soul : Node, team : String = "enemy") -> void:
	if not team in teams:
		return
	
	teams[team].append(soul)
	emit_signal("souls_added")


func execute_turn() -> void:
	if is_turn_processing():
		return
	
	turn_timer.start(time_between_turns)
	set_process(true)
	emit_signal("turn_started")


func next_turn() -> void:
	print(time_passed)
	set_process(false)
	emit_signal("turn_ended")



func set_in_battle(value : bool) -> void:
	in_battle = value
	emit_signal("battle_started" if in_battle else "battle_finished")



func get_list_of_souls() -> Array:
	var list_of_souls : Array = []
	
	for i in teams:
		for j in teams[i]:
			list_of_souls.append(j)
	
	return list_of_souls


func get_team_of_soul(soul : Node) -> String:
	for i in teams:
		if soul in teams[i]:
			return i
	
	return "nil"


func get_turn_time_left() -> float:
	if not is_turn_processing():
		return -1.0
	
	return turn_timer.time_left



func is_turn_processing() -> bool:
	return !turn_timer.is_stopped()



func _on_Soul_killed(_killer : Soul, victim : Soul) -> void:
	for i in teams:
		if victim in teams[i]:
			teams[i].erase(victim)
