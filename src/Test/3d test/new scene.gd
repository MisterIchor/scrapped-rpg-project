extends Spatial


func _process(delta: float) -> void:
	for i in get_children():
		if not i is Camera:
			i.look_at($Camera.translation, Vector3(0, 0, 0))
