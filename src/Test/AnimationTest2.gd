extends Node2D

var dir : int = 0
var last_dir : int = 1
var length : float = 1.0
var pos : Dictionary = {
	seg_1 = Vector2(0, -3.981),
	seg_2 = Vector2(0, -11),
	seg_3 = Vector2(0, -13)
}
onready var tween : Tween = ($Tween as Tween)
onready var left_leg : Node2D = ($LeftLeg as Node2D)
onready var right_leg : Node2D = ($RightLeg as Node2D)
onready var mid : Vector2 = (right_leg.global_position + left_leg.global_position) / 2


func _ready() -> void:
	tween.connect("tween_all_completed", self, "_on_Tween_all_completed")
	tween.interpolate_property(left_leg.get_child(2).front, "position", Vector2(), pos.seg_3, 0.5)
	tween.interpolate_property(left_leg.get_child(1).front, "position", Vector2(), pos.seg_2, 0.5)
	tween.interpolate_property(left_leg.get_child(0).front, "position", Vector2(), pos.seg_1, 0.5)
	tween.start()


func _process(delta: float) -> void:
	length = get_length()
	tween.playback_speed = 1.0 + length



func get_length() -> float:
	var mouse_pos : Vector2 = get_global_mouse_position()
	var final_value : float = clamp(mid.distance_to(mouse_pos) / 100, 0, 1)
	
	return final_value


func get_time() -> float:
	return 0.2 + (0.3 * (1 - get_length()))



func _on_Tween_all_completed() -> void:
	match dir:
		1:
			tween.interpolate_property(left_leg.get_child(2).front, "position", Vector2(), pos.seg_3 * length, 0.5)
			tween.interpolate_property(left_leg.get_child(1).front, "position", Vector2(), pos.seg_2 * length, 0.5)
			tween.interpolate_property(left_leg.get_child(0).front, "position", Vector2(), pos.seg_1 * length, 0.5)
			dir = 0
			last_dir = 1
		0:
			tween.interpolate_property(left_leg.get_child(2).front, "position", left_leg.get_child(2).front.position, Vector2(), 0.7)
			tween.interpolate_property(left_leg.get_child(1).front, "position", left_leg.get_child(1).front.position, Vector2(), 0.7)
			tween.interpolate_property(left_leg.get_child(0).front, "position", left_leg.get_child(0).front.position, Vector2(), 0.7)
			dir = -last_dir
		-1:
			tween.interpolate_property(left_leg.get_child(2).front, "position", Vector2(), -pos.seg_3 * length, 0.5)
			tween.interpolate_property(left_leg.get_child(1).front, "position", Vector2(), -pos.seg_2 * length, 0.5)
			tween.interpolate_property(left_leg.get_child(0).front, "position", Vector2(), -pos.seg_1 * length, 0.5)
			dir = 0
			last_dir = -1

	tween.start()
