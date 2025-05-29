extends Spatial



func _ready() -> void:
	$VisibilityNotifier.connect("camera_entered", self, "_on_Camera_entered")



func _on_Camera_entered(camera : Camera) -> void:
	print(camera.name)
