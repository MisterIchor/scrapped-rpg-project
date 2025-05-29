tool
extends StaticBody

var corner : Dictionary = {
	top_left = Vector3(),
	top_right = Vector3(1, 0, 0),
	bottom_right = Vector3(1, 0, 1),
	bottom_left = Vector3(0, 0, 1)
}

onready var mesh_instance : MeshInstance = $MeshInstance
onready var collision : CollisionShape = $CollisionShape



func _get_property_list() -> Array:
	var properties : Array = []
	
	properties.append({
		name = "CornerOffsets",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_CATEGORY
	})
	
	properties.append({
		name = "top_left",
		type = TYPE_VECTOR3
	})
	
	properties.append({
		name = "top_right",
		type = TYPE_VECTOR3
	})
	
	properties.append({
		name = "bottom_left",
		type = TYPE_VECTOR3
	})
	
	properties.append({
		name = "bottom_right",
		type = TYPE_VECTOR3
	})
	
	return properties


func _set(property: String, value) -> bool:
	match property:
		"top_left":
			corner.top_left = value
			_update_tile()
		"top_right":
			corner.top_right = value
			_update_tile()
		"bottom_left":
			corner.bottom_left = value
			_update_tile()
		"bottom_right":
			corner.bottom_right = value
			_update_tile()
	
	return false


func _get(property: String):
	match property:
		"top_left":
			return corner.top_left
		"top_right":
			return corner.top_right
		"bottom_left":
			return corner.bottom_left
		"bottom_right":
			return corner.bottom_right



func _update_tile() -> void:
	if not is_inside_tree():
		yield(self, "ready")
	
	var arr_mesh : ArrayMesh = ArrayMesh.new()
	var center : Vector3 = Vector3(0.5, 0, 0.5)
	var verts_array : PoolVector3Array = []
	var uv_array : PoolVector3Array = []
	var array : Array = []
	var triangle : Dictionary = {}
	
	for i in corner.values():
		center.y += i.y
	
	center.y /= 4
	
	triangle.top = [
		corner.top_right,
		center,
		corner.top_left
	]
	triangle.right = [
		corner.bottom_right,
		center,
		corner.top_right
	]
	triangle.bottom = [
		corner.bottom_left,
		center,
		corner.bottom_right
	]
	triangle.left = [
		corner.top_left,
		center,
		corner.bottom_left
	]
	
	for i in triangle.values():
		verts_array.append_array(i)
		uv_array.append_array(i)
	
	collision.shape.points[0] = corner.top_left
	collision.shape.points[1] = corner.top_right
	collision.shape.points[2] = corner.bottom_right
	collision.shape.points[3] = corner.bottom_left
	collision.shape.points[4] = center
	array.resize(arr_mesh.ARRAY_MAX)
	array[arr_mesh.ARRAY_VERTEX] = verts_array
	array[arr_mesh.ARRAY_TEX_UV] = uv_array
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh_instance.mesh = arr_mesh



func set_corner_height(corner_name : String, y : float) -> void:
	var vector : Vector3 = corner.get(corner_name)
	
	if vector == null:
		return
	
	vector.y = y
	set(corner_name, vector)


func get_corner_height(corner_name : String) -> float:
	return corner.get(corner_name, Vector3()).y
