extends BaseBody
class_name Projectile

signal hit
signal about_to_hit
signal height_intercept
signal global_height

var _active_changed : bool = false

var is_active : bool = false setget set_active
var template : ProjectileTemplate = null setget set_template
var from : Unit = null
var start_height : float = 0
var start_position : Vector2 = Vector2()
var start_rotation : float = 0.0
var hit_position : Vector2 = Vector2()
var speed : float = 0
var drop_speed : float = 0
var damage : int = 0
var body_overlap : Array = []

onready var body_ghost : Area2D = ($BodyGhost as Area2D)
onready var body_ghost_collision : CollisionPolygon2D = ($BodyGhost/CollisionPolygon2D as CollisionPolygon2D)
onready var collision_tracker_front : Tracker = ($CollisionTrackerFront as Tracker)
onready var collision_tracker_back : Tracker = ($CollisionTrackerBack as Tracker)



func _init() -> void:
#	connect("body_entered", self, "_on_body_entered")
#	connect("body_exited", self, "_on_body_exited")
	connect("collision_update", self, "_on_collision_update")
	set_name("Projectile")
	input_pickable = false
	connect("hit", self, "_on_hit")


func _ready() -> void:
#	collision_tracker_front.connect("body_entered", self, "_on_CollisionTrackerFront_body_entered")
#	collision_tracker_back.connect("body_entered", self, "_on_CollisionTrackerBack_body_entered")
	set_physics_process(false)


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if _active_changed:
		if is_active:
			global_height = start_height
			# Need to set start position here or else the projectile will start
			# where it ended when deactivated.
			state.transform = Transform2D(start_rotation, start_position)
			state.linear_velocity = speed * Vector2(cos(rotation), sin(rotation))
			set_body_scale(Vector2.ONE)
		else:
			state.linear_velocity = Vector2()
			body_overlap.clear()
		
		set_physics_process(is_active)
		set_visible(is_active)
		_active_changed = false
	
	print($BodyGhost.get_overlapping_bodies())
	if not is_active:
		return
	
	if hit_position:
		global_position = hit_position
	
	var checks : Array = [
		global_height <= 0,
		false,
		state.get_contact_count() > 0,
	]
	for i in body_overlap:
		if is_height_intersecting(i) and not $BodyGhost.overlaps_body(i):
			checks[1] = true
			break
	
	if checks[0]:
		emit_signal("global_height")
	
	if checks[1]:
		emit_signal("height_intercept")
	
	if true in checks:
		state.linear_velocity = Vector2()
		emit_signal("hit")
		set_active(false)


func _physics_process(delta: float) -> void:
	var height_ratio : float = start_height / global_height
	
	if global_height > 0:
		linear_damp = max(height_ratio, 0)
		drop_speed *= linear_damp
		global_height -= drop_speed
#		prints(linear_damp, drop_speed, global_height)
	
	var scale : float = clamp(global_height / start_height, 0.001, 1)
	set_body_scale(Vector2(scale, scale))



func add_collision_exception_with(body : Node) -> void:
	.add_collision_exception_with(body)
#	collision_tracker_front.add_exception(body)
#	collision_tracker_back.add_exception(body)


func remove_collision_exception_with(body : Node) -> void:
	.remove_collision_exception_with(body)
	collision_tracker_front.remove_exception(body)
#	collision_tracker_back.remove_exception(body)


func load_collision_data(file_name : String) -> void:
	.load_collision_data(file_name)
	
	for i in collision_data:
		collision_tracker_front.position.x = max(i.x, collision_tracker_front.position.x)
		collision_tracker_back.position.x = min(i.x, collision_tracker_back.position.x)



func set_active(value : bool) -> void:
	is_active = value
	set_deferred("contact_monitor", is_active)
	collision_tracker_front.enabled = is_active
	collision_tracker_back.enabled = is_active
	collision_body.set_deferred("disabled", !is_active)
	
	if is_active:
		# Will be set to Vector2() for the first frame if not set here.
		transform = Transform2D(start_rotation, start_position)
		hit_position = Vector2()
	elif hit_position:
		global_position = hit_position
	
	_active_changed = true



func set_template(new_template : ProjectileTemplate) -> void:
	if new_template == template:
		return
	
	template = new_template
	
	if not sprite:
		yield(self, "ready")
	
	speed = template.start_speed
	drop_speed = template.drop_speed
	damage = template.damage
	load_collision_data(template.collision_data)
	sprite.texture = template.sprite
 


func get_class() -> String:
	return "Projectile"



func _on_CollisionTrackerFront_body_entered(body : Node) -> void:
	if not is_height_intersecting(body):
		body_overlap.append(body)
		add_collision_exception_with(body)
		print("front entered")


func _on_CollisionTrackerBack_body_entered(body : Node) -> void:
	if not collision_tracker_front.is_colliding():
		if body in body_overlap:
			body_overlap.erase(body)
			remove_collision_exception_with(body)
			print("back_exited")


func _on_body_entered(body : Node) -> void:
	if body.get_class() == "TileWallBody":
		emit_signal("hit")
		set_active(false)


func _on_new_projectile_added(projectile : Projectile) -> void:
	add_collision_exception_with(projectile)
	projectile.add_collision_exception_with(self)


func _on_hit() -> void:
	hit_position = global_position


func _on_collision_update() -> void:
	body_ghost_collision.polygon = collision_body.polygon
