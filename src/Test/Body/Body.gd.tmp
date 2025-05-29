extends Node2D

var _is_moving : bool = false setget _set_is_moving

onready var _prev_pos : Vector2 = global_position
onready var arms : Node2D = ($Arms as Node2D)
onready var legs : Node2D = ($Legs as Node2D)

signal movement_started
signal movement_finished



func _ready() -> void:
	connect("movement_started", legs, "_on_movement_started")
	connect("movement_finished", legs, "_on_movement_finished")


func _process(delta: float) -> void:
	_set_is_moving(_prev_pos == global_position)
	_prev_pos = global_position



func _set_is_moving(value : bool) -> void:
	_is_moving = value
#	emit_signal("movement_started" if _is_moving else "movement_finished")
