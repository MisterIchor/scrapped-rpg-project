extends ColorRect

func _ready() -> void:
	$Popup.call_deferred("popup")
