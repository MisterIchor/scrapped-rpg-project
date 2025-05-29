extends Node2D

var leg_states : Dictionary = {}
var position_hold : Dictionary = {}
var is_moving : bool = false setget set_is_moving

onready var dir_tracker : Node2D = ($DirTracker as Node2D)



func _ready() -> void:
	leg_states.pair_one = {}
	leg_states.pair_one[$Legs/LeftLeg] = [0.0, 0]
	leg_states.pair_one[$Legs/RightLeg] = [0.0, 0]


func _input(event: InputEvent) -> void:
	var movement : Vector2 = Vector2(
		Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_S),
		Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_D)
	)
	
	set_is_moving(true if movement else false)


func _draw() -> void:
	for i in position_hold:
		draw_circle(position_hold[i], 2, Color.white)


func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_W):
		$Legs.position += Vector2(0, -1)
	elif Input.is_key_pressed(KEY_S):
		$Legs.position += Vector2(0, 1)
	
	if Input.is_key_pressed(KEY_A):
		$Legs.position += Vector2(-1, 0)
	elif Input.is_key_pressed(KEY_D):
		$Legs.position += Vector2(1, 0)
	
	for i in leg_states:
		var leg_one : Node2D = i[0]
		var leg_two : Node2D = i[1]
		
		match leg_states[i]:
			1:
				leg_one.set_limb_size(lerp(0.0, 1.0, 0.5))
			0:
				continue
#				leg_one.set_limb_size(lerp())
			-1:
				continue



func set_is_moving(value : bool) -> void:
	is_moving = value
	
	if is_moving:
		for i in leg_states:
			leg_states[i] = 1
	else:
		for i in leg_states:
			leg_states[i] = 0
