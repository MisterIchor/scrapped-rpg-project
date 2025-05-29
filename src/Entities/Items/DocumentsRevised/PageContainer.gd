extends Movable



func set_mouse_focus_required(value : bool) -> void:
	.set_mouse_focus_required(value)
	yield(self, "ready")
	yield(get_tree(), "idle_frame")
	if mouse_focus_required:
		for i in get_children():
			i.connect("gui_input", self, "_input")
	
