extends Camera



func _process(delta: float) -> void:
	var movement : Vector3 = Vector3()
	var speed : float = 5 * delta
	
	if Input.is_key_pressed(KEY_W):
		movement.y += speed
	elif Input.is_key_pressed(KEY_S):
		movement.y -= speed
	
	if Input.is_key_pressed(KEY_A):
		movement.x -= speed
	elif Input.is_key_pressed(KEY_D):
		movement.x += speed
	
	if Input.is_key_pressed(KEY_Q):
		rotation_degrees.y -= speed * 10
	elif Input.is_key_pressed(KEY_E):
		rotation_degrees.y += speed * 10
	
#	movement = movement.rotated(Vector3(0, 1, 0), rotation.y)
#	movement = movement.rotated(Vector3(1, 0, 0), rotation.y)
	translate(movement)



func _on_tile_hovered(tile : CollisionShape) -> void:
	var draw : Array = [
		unproject_position(tile.global_transform.origin + Vector3(0, 0, 0)),
		unproject_position(tile.global_transform.origin + Vector3(1, 0, 0)),
		unproject_position(tile.global_transform.origin + Vector3(1, 0, 1)),
		unproject_position(tile.global_transform.origin + Vector3(0, 0, 1)),
		unproject_position(tile.global_transform.origin + Vector3(0, 0, 0)),
	]
	print(tile)
	VisualServer.canvas_item_clear($Node2D.get_canvas_item())
	VisualServer.canvas_item_add_polyline($Node2D.get_canvas_item(), draw, [Color.white])
