extends Node

var map_size : Vector2 = Vector2()
var current_floor : int = 0
var number_of_floors : int = 0
var draw : MeshInstance = MeshInstance.new()

onready var camera: Camera = $"3DSpace/Camera"
onready var ui: Control = $UI



func _process(delta: float) -> void:
	var rect : PoolVector3Array = [
		Vector3(0, 0, 0),
		Vector3(1, 0, 0),
		Vector3(1, 0, 1),
		Vector3(0, 0, 1),
		Vector3(0, 0, 0),
	]
	var mouse_pos : Vector2 = camera.get_viewport().get_mouse_position()
	var spatial_mouse_pos : Vector3 = camera.project_ray_normal(mouse_pos)
	var projected_mouse_pos : Vector3 = camera.project_position(camera.get_viewport().get_mouse_position(), 40)
	var ui_rid : RID = ui.get_canvas_item()
	
	for i in rect.size():
		rect[i].x += projected_mouse_pos.x - 0.5
		rect[i].z += projected_mouse_pos.z - 0.5
		rect[i] = rect[i].snapped(Vector3(1, 0, 1))
	
	var unprojected_rect : PoolVector2Array = [
		camera.unproject_position(rect[0]),
		camera.unproject_position(rect[1]),
		camera.unproject_position(rect[2]),
		camera.unproject_position(rect[3]),
		camera.unproject_position(rect[4]),
	]
	VisualServer.canvas_item_clear(ui_rid)
	VisualServer.canvas_item_add_polyline(ui_rid, unprojected_rect, [Color.white])

