extends Label


func _enter_tree() -> void:
	text = str(round(rand_range(1,9999999)))
