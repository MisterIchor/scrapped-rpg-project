extends Node2D



func _ready() -> void:
#	var children : Array = get_children()
	set_physics_process(false)
	yield(get_tree().create_timer(0.5), "timeout")
	$Legs/LeftLeg.tween_contraction(90)
	$Legs/LeftLeg.animate()
#	set_physics_process(true)
#	swing_fist()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		kamahamaha()
#		swing_fist()


func _draw() -> void:
	for i in $Legs/LeftLeg.get_sections():
		var e : Vector2 = i.global_position + Vector2(200, 0)
		var a : Vector2 = i.front.global_position + Vector2(200, 0)
		
		draw_line(e, a, Color.white)

#	for i in $Legs/RightLeg.get_sections():
#		var e : Vector2 = i.global_position + Vector2(200, 0)
#		var a : Vector2 = i.front.global_position + Vector2(200, 0)
#
#		draw_line(e, a, Color.white)
#
#	for i in $Arms/LeftArm.get_sections():
#		var e : Vector2 = i.global_position + Vector2(200, 0)
#		var a : Vector2 = i.front.global_position + Vector2(200, 0)
#
#		draw_line(e, a, Color.gray)
#
#	for i in $Arms/RightArm.get_sections():
#		var e : Vector2 = i.global_position + Vector2(200, 0)
#		var a : Vector2 = i.front.global_position + Vector2(200, 0)
#
#		draw_line(e, a, Color.gray)
	


func _process(delta: float) -> void:
	update()


func _physics_process(delta: float) -> void:
	walk()
#	$Legs.look_at(get_global_mouse_position())



func walk() -> void:
	var origin : Vector2 = $Legs.global_position
	var difference : float = (origin.y - get_global_mouse_position().y)
	
#	$Legs.look_at(get_global_mouse_position())
	
	
	match sign(difference):
		1.0:
			$Legs/LeftLeg.set_limb_rotation(0)
			$Legs/LeftLeg.set_limb_size(min(difference / $Legs/LeftLeg.get_limb_max_length(), 1) * 0.5, -0.66)
			$Legs/LeftLeg.set_limb_size(min(difference / $Legs/LeftLeg.get_limb_max_length(), 1) * 0.8, 0.33)
			$Legs/RightLeg.set_limb_rotation(180)
			$Legs/RightLeg.set_limb_size(min(difference / $Legs/RightLeg.get_limb_max_length(), 1) * 0.5, -0.66)
			$Legs/RightLeg.set_limb_size(min(difference / $Legs/RightLeg.get_limb_max_length(), 1) * 0.8, 0.33)
			$Arms/LeftArm.set_limb_rotation(160)
			$Arms/LeftArm.set_contraction(20)
			$Arms/LeftArm.set_limb_size(min(difference / $Arms/LeftArm.get_limb_max_length(), 1) * 0.5)
			$Arms/RightArm.set_limb_rotation(10)
			$Arms/RightArm.set_contraction(20)
			$Arms/RightArm.set_limb_size(min(difference / $Arms/RightArm.get_limb_max_length(), 1) * 0.5)
		-1.0:
			$Legs/LeftLeg.set_limb_rotation(180)
			$Legs/LeftLeg.set_limb_size(min(abs(difference) / $Legs/LeftLeg.get_limb_max_length(), 1) * 0.5, -0.66)
			$Legs/LeftLeg.set_limb_size(min(abs(difference) / $Legs/LeftLeg.get_limb_max_length(), 1) * 0.8, 0.33)
			$Legs/RightLeg.set_limb_rotation(0)
			$Legs/RightLeg.set_limb_size(min(abs(difference) / $Legs/RightLeg.get_limb_max_length(), 1) * 0.5, -0.66)
			$Legs/RightLeg.set_limb_size(min(abs(difference) / $Legs/RightLeg.get_limb_max_length(), 1) * 0.8, 0.33)
			$Arms/LeftArm.set_rotation_degrees(0)
			$Arms/LeftArm.set_limb_size(min(abs(difference) / $Arms/LeftArm.get_limb_max_length(), 1) * 0.5)
			$Arms/RightArm.set_rotation_degrees(180)
			$Arms/RightArm.set_limb_size(min(abs(difference) / $Arms/RightArm.get_limb_max_length(), 1) * 0.5)


func swing_fist():
	$Legs/LeftLeg.tween_size(1, 0.22)
	$Legs/LeftLeg.tween_contraction(120, 0.22)
	$Legs/LeftLeg.tween_rotation(160, 0.25)
	$Legs/RightLeg.tween_size(1, 0.22)
	$Legs/RightLeg.tween_contraction(180, 0.22)
	$Legs/RightLeg.tween_rotation(115, 0.22)
	$Legs/LeftLeg.animate()
	$Legs/RightLeg.animate()
	yield(get_tree().create_timer(0.6), "timeout")
	
	while true:
		if Input.is_action_pressed("select"):
			yield(get_tree(), "idle_frame")
			continue
		
		$Legs/LeftLeg.stop()
		$Legs/RightLeg.stop()
		$Legs/LeftLeg.tween_contraction(35, 0.22)
		$Legs/LeftLeg.tween_rotation(-90, 0.23)
		$Legs/RightLeg.tween_contraction(135, 0.1)
		$Legs/RightLeg.tween_rotation(135, 0.1)
		$Legs/LeftLeg.animate()
		$Legs/RightLeg.animate()
		yield($Legs/LeftLeg.tween, "tween_all_completed")
		$Legs/LeftLeg.tween_reset_to_neutral()
		$Legs/RightLeg.tween_reset_to_neutral()
		$Legs/LeftLeg.animate()
		$Legs/RightLeg.animate()
		break


func kamahamaha() -> void:
	$Legs/LeftLeg.tween_contraction(160)
	$Legs/LeftLeg.tween_rotation(-30)
	$Legs/LeftLeg.tween_size(0.9)
	$Legs/RightLeg.tween_contraction(240)
	$Legs/RightLeg.tween_rotation(180)
	$Legs/RightLeg.tween_size(0.5)
	$Legs/LeftLeg.animate()
	$Legs/RightLeg.animate()
	
	while true:
		if Input.is_action_pressed("select"):
			yield(get_tree(), "idle_frame")
			continue
		
		$Legs/LeftLeg.stop()
		$Legs/RightLeg.stop()
		$Legs/LeftLeg.tween_size(1.0, 0.1)
		$Legs/LeftLeg.tween_rotation(-5, 0.1)
		$Legs/LeftLeg.tween_contraction(0, 0.1)
		$Legs/RightLeg.tween_size(1, 0.1)
		$Legs/RightLeg.tween_contraction(0, 0.1)
		$Legs/RightLeg.tween_rotation(-5, 0.1)
		$Legs/LeftLeg.animate()
		$Legs/RightLeg.animate()
		yield($Legs/LeftLeg.tween, "tween_all_completed")
		$Legs/LeftLeg.tween_reset_to_neutral()
		$Legs/RightLeg.tween_reset_to_neutral()
		$Legs/LeftLeg.animate()
		$Legs/RightLeg.animate()
		break
