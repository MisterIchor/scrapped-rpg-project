extends Tracker

var target = null setget set_target



func _init(new_target) -> void:
	collide_with_bodies = true
	set_target(new_target)


func _ready() -> void:
	enabled = true



func _process(delta: float) -> void:
	var target_pos : Vector2 = target.global_position if not target is Unit else target.get_body_position()
	cast_to = target_pos - global_position



func set_target(new_target) -> void:
	target = new_target
	target.connect("tree_exiting", self, "_on_Target_tree_exiting")
	name = str(target.name, "Tracker") if target else "NullTracker"






func _on_Target_tree_exiting() -> void:
	queue_free()
