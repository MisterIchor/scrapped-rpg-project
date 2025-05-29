tool
extends Sprite3D



func _process(delta: float) -> void:
	look_at(get_node("../Camera").global_transform.origin, Vector3(0, 0, 1))
