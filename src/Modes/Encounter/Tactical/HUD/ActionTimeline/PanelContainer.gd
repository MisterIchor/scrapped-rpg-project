extends PanelContainer

onready var timeline : ColorRect = ($ViewportContainer/Viewport/Timeline as ColorRect)



func _ready() -> void:
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")



func _on_mouse_entered() -> void:
	timeline.set_mouse_filter(Control.MOUSE_FILTER_STOP)


func _on_mouse_exited() -> void:
	timeline.set_mouse_filter(Control.MOUSE_FILTER_IGNORE)
