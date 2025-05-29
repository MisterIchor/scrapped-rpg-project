extends Node2D

var leg_states : Dictionary = {}
var position_hold : Dictionary = {}
var is_moving : bool = false setget set_is_moving

onready var dir_tracker : Node2D = ($DirTracker as Node2D)



func _ready() -> void:
	leg_states[$Legs/LeftLeg] = 0
	leg_states[$Legs/RightLeg] = 0


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
			match leg_states[i]:
				1:
					var current_size : float = 0
					
					for j in i.get_sections():
						var section_size : Vector2 = i.get_section_size_as_vector(j, 0.75)
						j.front.position = lerp(j.front.position, section_size, 0.05)
						current_size += -j.front.position.y
					
					prints(current_size, i.get_limb_max_length() * 0.5)
					
					if current_size >= i.get_limb_max_length() * 0.5:
						set_leg_state(i, -leg_states[i])
					
				0:
					for j in i.get_sections():
						j.front.position = lerp(j.front.position, Vector2(), 0.05)
				-1:
					var length : float = (position_hold[i] - i.global_position).length()
					var limb_length : float = i.get_limb_max_length()
					var angle : float = i.global_position.angle_to_point(position_hold[i])
					
					i.set_limb_size(clamp(abs(length / limb_length), 0.0, 1.0))
					i.rotation = angle - (PI / 2)
					update()



func set_is_moving(value : bool) -> void:
	is_moving = value
	
	if is_moving:
		set_leg_state($Legs/LeftLeg, 1)
		set_leg_state($Legs/RightLeg, -1)
	else:
		set_leg_state($Legs/LeftLeg, 0)
		set_leg_state($Legs/RightLeg, 0)


func set_leg_state(leg : Node2D, state_num : int) -> void:
	match state_num:
		-1:
			position_hold[leg] = leg.global_position
	
	leg_states[leg] = state_num
