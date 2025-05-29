extends Spatial

const Tile : PackedScene = preload("res://src/Test/3d test/generation/Tile.tscn")

signal tile_hovered(tile)

export (Vector2) var map_size : Vector2 = Vector2() setget set_map_size
export (Vector2) var chunk_size : Vector2 = Vector2(4, 4)

var noise : OpenSimplexNoise = OpenSimplexNoise.new()
var height_points : Dictionary = {}
var _instance_vectors : Dictionary = {}

onready var bobby : Spatial = $Spatial
onready var camera : Camera = $Camera
onready var ground : StaticBody = $Ground
onready var multimesh : MultiMesh = $MultiMeshInstance.multimesh



func _ready() -> void:
	yield(get_tree(), "idle_frame")
#	ground.connect("input_event", self, "_on_Ground_input_event")
	randomize()
#	connect("tile_hovered", camera, "_on_tile_hovered")
#	camera.translation.x = map_size.x * 0.75
#	camera.translation.z = map_size.y * 1.5
	print(OS.get_ticks_msec())
	generate_noise()
	generate_terrain()
#	smooth_terrain()
#	bobby.translate(Vector3(map_size.x / 2, 0, map_size.y / 2).round())
	print(OS.get_ticks_msec())



func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_SPACE):
		generate_noise()
		generate_terrain()
		smooth_terrain()


func generate_noise() -> void:
	noise.period = 8
	noise.persistence = rand_range(0.1, 1)
	noise.lacunarity = rand_range(0.1, 2)
	noise.octaves = randi() % 9
	
	for y in map_size.y:
		for x in map_size.x:
			height_points[Vector2(x, y)] = noise.get_noise_2d(x, y)
	
	height_points[Vector2()] = height_points[map_size - Vector2.ONE]

func generate_section(rect : Rect2) -> void:
	for y in range(rect.position.y, rect.end.y):
		for x in range(rect.position.x, rect.end.x):
			var mesh_instance : StaticBody = get_node_or_null(vec2str(Vector2(x, y)))

			if not mesh_instance:
				var new_tile : StaticBody = Tile.instance()

				new_tile.name = vec2str(Vector2(x, y))
				add_child(new_tile)
#				new_tile.connect("mouse_entered", camera, "_on_Tile_mouse_entered", [new_tile])
				mesh_instance = new_tile

			mesh_instance.translation = Vector3()
			mesh_instance.global_translate(Vector3(x, 0, y))


func generate_terrain() -> void:
	multimesh.instance_count = map_size.x * map_size.y
	var trans : Transform = transform
	var current : Vector2 = Vector2()
	
	for i in multimesh.instance_count:
#		var collision : CollisionShape = CollisionShape.new()
		
#		collision.shape = ConvexPolygonShape.new()
#		collision.shape.points = [
#			Vector3(),
#			Vector3(1, 0, 0),
#			Vector3(1, 0, 1),
#			Vector3(0, 0, 1)
#		]
		trans.origin.x = current.x
		trans.origin.y = height_points.get(current)
		trans.origin.z = current.y
		multimesh.set_instance_transform(i, trans)
#		collision.transform.origin = trans.origin
#		collision.transform.origin -= Vector3(0.5, 0, 0.5)
#		ground.add_child(collision)
		current.x += 1
		
		if current.x == map_size.x:
			current.y += 1
			current.x = 0



func smooth_terrain() -> void:
	var corner_checks : Dictionary = {
		top_left = Vector2(),
		top_right = Vector2(1, 0),
		bottom_right = Vector2(1, 1),
		bottom_left = Vector2(0, 1)
	}
	
	for y in map_size.y:
		for x in map_size.x:
			var tile : StaticBody = get_node(vec2str(Vector2(x, y)))
			
			for i in corner_checks:
				var point : float = height_points.get(Vector2(x, y) + corner_checks[i], -INF)
				
				if not point == -INF:
					tile.corner[i].y = point
			
			tile._update_tile()


func vec2str(vector : Vector2) -> String:
	return String(vector)



func set_map_size(new_size: Vector2) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	
	map_size = new_size
	_instance_vectors.clear()
	multimesh.instance_count = map_size.x * map_size.y
	
	for y in map_size.y:
		for x in map_size.x:
			_instance_vectors[Vector2(x, y)] = x + y



func get_instance_at_position(pos : Vector2) -> int:
	return _instance_vectors.get(pos, -1)


func _on_Ground_input_event(camera : Node, event : InputEvent, position : Vector3, normal : Vector3, shape_idx : int) -> void:
	if event is InputEventMouseMotion:
		emit_signal("tile_hovered", ground.get_child(shape_idx))
