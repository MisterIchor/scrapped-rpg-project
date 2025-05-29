extends KinematicBody2D

const LOSTracker : Script = preload("res://src/Test/AI/LOSTracker.gd")

var cone_scale : float = 1
var weapon_data : TemplateContainer = load("res://src/Entities/Physical/Items/Weapons/Ranged/RangedWeapon.gd").new()
var last_pos : Vector2 = Vector2(21015, -21015)
var los_trackers : Dictionary = {}

onready var facing : Position2D = ($Sprite/Facing as Position2D)
onready var dir_tracker : Node2D = ($DirTracker as Node2D)
onready var weapon : KinematicBody2D = ($Sprite/RangedWeaponBody as KinematicBody2D)
onready var sprite : Sprite = ($Sprite as Sprite)



func _init() -> void:
	BattleSystem.connect("soul_added", self, "update_los_trackers")
	weapon_data.set_template(load("res://src/Resources/Items/Weapons/Ranged/Peestol.tres"))


func _ready() -> void:
	weapon.set_data(weapon_data)


func _draw() -> void:
	draw_circle_arc_poly(Vector2(), 80, 0 + sprite.rotation_degrees, 180 + sprite.rotation_degrees, Color.white)



func add_tracker(target : Node2D) -> void:
	var new_tracker : RayCast2D = LOSTracker.new(target)
	
	new_tracker.add_exception(weapon)
	los_trackers[target] = new_tracker
	add_child(new_tracker)


func draw_circle_arc_poly(center : Vector2, radius : float, angle_from : float, angle_to : float, color : Color) -> void:
	var nb_points = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])
	
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)


func update_los_trackers() -> void:
	var souls : Array = BattleSystem.get_list_of_souls()
	
	for i in souls:
		if i == self:
			continue
		
		if not i in los_trackers:
			add_tracker(i)



func _physics_process(delta: float) -> void:
	update()
	if not dir_tracker:
		return
	
	var units_in_sight : Array = []
	var unit_to_target : Node2D = null
	
	for i in los_trackers:
		var tracker : RayCast2D = los_trackers[i]
		var dir : Vector2 = global_position.direction_to(to_global(tracker.cast_to))
		var facing_dir : Vector2 = global_position.direction_to(facing.global_position)
		
		if tracker.is_colliding():
			if not tracker.get_collider() is KinematicBody2D:
				continue
		
		if dir.dot(facing_dir) > 0:
			units_in_sight.append(i)
	
	for unit in units_in_sight:
		if not unit_to_target:
			unit_to_target = unit
			
			if units_in_sight.size() == 1:
				break
			
			continue
		
		var distance_to_target : float = global_position.distance_squared_to(unit_to_target.global_position)
		var distance_to_unit : float = global_position.distance_squared_to(unit.global_position)
		
		if distance_to_target > distance_to_unit:
			unit_to_target = unit
	
	if unit_to_target:
		last_pos = unit_to_target.global_position
		weapon.fire_projectile()
	
	if not last_pos == Vector2(21015, -21015):
		dir_tracker.look_at(last_pos)
		sprite.rotation = lerp(sprite.rotation, dir_tracker.rotation, 0.1)
