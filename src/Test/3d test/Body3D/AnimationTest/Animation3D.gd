extends Spatial


#func _ready() -> void:
##	$Limb3D.set_limb_rotation("x", 45)
#	$Limb3D.set_contraction("y", -90)
#	$Limb3D.animate()


func _physics_process(delta: float) -> void:
	return
#	walk()



func walk() -> void:
	var origin : Vector2 = $Camera.unproject_position($Limb3D.translation)
	var difference : float = (origin.y - $Node2D.get_global_mouse_position().y)
	
#	$Legs.look_at(get_global_mouse_position())
	
	$Limb3D.set_lift(clamp(difference, -90, 90) - 90)
#	match sign(difference):
#		1.0:
#			$Limb3D.set_swing(0)
#			$Limb3D.set_lift(min(difference / $Limb3D.get_limb_max_length(), 1) * 0.5, -0.66)
#			$Limb3D.set_lift(min(difference / $Limb3D.get_limb_max_length(), 1) * 0.8, 0.33)
#			$Legs/RightLeg.set_swing(180)
#			$Legs/RightLeg.set_lift(min(difference / $Legs/RightLeg.get_limb_max_length(), 1) * 0.5, -0.66)
#			$Legs/RightLeg.set_lift(min(difference / $Legs/RightLeg.get_limb_max_length(), 1) * 0.8, 0.33)
#			$Arms/LeftArm.set_swing(160)
#			$Arms/LeftArm.set_contraction(20)
#			$Arms/LeftArm.set_lift(min(difference / $Arms/LeftArm.get_limb_max_length(), 1) * 0.5)
#			$Arms/RightArm.set_swing(10)
#			$Arms/RightArm.set_contraction(20)
#			$Arms/RightArm.set_lift(min(difference / $Arms/RightArm.get_limb_max_length(), 1) * 0.5)
#		-1.0:
#			$Limb3D.set_swing(180)
#			$Limb3D.set_lift(min(abs(difference) / $Limb3D.get_limb_max_length(), 1) * 0.5, -0.66)
#			$Limb3D.set_lift(min(abs(difference) / $Limb3D.get_limb_max_length(), 1) * 0.8, 0.33)
#			$Legs/RightLeg.set_swing(0)
#			$Legs/RightLeg.set_lift(min(abs(difference) / $Legs/RightLeg.get_limb_max_length(), 1) * 0.5, -0.66)
#			$Legs/RightLeg.set_lift(min(abs(difference) / $Legs/RightLeg.get_limb_max_length(), 1) * 0.8, 0.33)
#			$Arms/LeftArm.set_rotation_degrees(0)
#			$Arms/LeftArm.set_lift(min(abs(difference) / $Arms/LeftArm.get_limb_max_length(), 1) * 0.5)
#			$Arms/RightArm.set_rotation_degrees(180)
#			$Arms/RightArm.set_lift(min(abs(difference) / $Arms/RightArm.get_limb_max_length(), 1) * 0.5)
