extends PanelContainer

onready var line : ColorRect = ($Line as ColorRect)



func flatline() -> void:
	line.beat_height = 0
	line.line_color = Color.crimson


func restore(default_color : Color = Color.green) -> void:
	line.beat_height = 1
	line.line_color = default_color
