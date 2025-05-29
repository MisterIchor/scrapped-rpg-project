extends KinematicBody2D

var speed : float = 50
var target : Vector2 = Vector2()
var velocity : Vector2 = Vector2()
var visibility : float = 1.0 setget set_visibility

signal moving
signal notmoving



func _enter_tree() -> void:
	set_visibility(0.5)


func _input(event):
	if event.is_action_pressed("ui_select"):
		target = get_global_mouse_position()


func _physics_process(delta):
	velocity = (target - position).normalized() * speed
	
	if (target - position).length() > 5:
		emit_signal("moving")
		move_and_slide(velocity)
	else:
		emit_signal("notmoving")



func set_visibility(value : float) -> void:
	visibility = value
	$Camera2D.set_zoom(Vector2(value, value))
