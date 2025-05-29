extends "../WeaponBody.gd"

signal projectile_fired(ammo_left)

onready var projectile_pool : Node = ($ProjectilePool as Node)
onready var timer : Timer = ($Timer as Timer)

var accuracy : float = 100
var _current_accuracy : float = accuracy
#var _projectile_max_travel_distance : float = 0.0



func _ready() -> void:
	projectile_pool.connect("new_projectile_added", self, "_on_ProjectilePool_new_projectile_added")


func _notification(what: int) -> void:
	if what == NOTIFICATION_CONTAINER_SET:
		var ammo_template : ProjectileTemplate = get_projectile_data()
		var projectiles_per_shot : int = ammo_template.get("number_of_projectiles")
		var max_ammo : int = container.get("ammo_capacity")
		
		timer.wait_time = container.get("speed")
		projectile_pool.template = ammo_template
		projectile_pool.max_projectiles = projectiles_per_shot * max_ammo
		yield(get_tree(), "idle_frame")
		
		if sprite.texture:
			var offset : float = sprite.texture.get_width() / 2
			sprite.offset.x = offset
			collision_body.position.x = offset


func _physics_process(delta: float) -> void:
	if _current_accuracy < accuracy:
		_current_accuracy += delta * 5



func fire_projectile(at_target : Vector2 = Vector2(INF, INF)) -> void:
	if container.get("ammo_loaded") <= 0:
		return
	
	if not timer.is_stopped():
		return
	
	play_sound("fire")
	
	var projectile_data : ProjectileTemplate = get_projectile_data()
	
	for i in projectile_data.get("number_of_projectiles"):
		var projectile : Projectile = projectile_pool.get_next_available_projectile()
		var accuracy_percentage : float = _current_accuracy / accuracy
		
#		if not at_target == Vector2(INF, INF):
#			projectile.start_height = get_adjusted_height_to_target(at_target)
#		else:
		projectile.start_height = global_height + (height / 2)
		projectile.start_position = weapon_length.get_cast_to_global()
		projectile.start_rotation = rotation
		projectile.start_rotation += rand_spread(1.0 - accuracy_percentage)
		projectile.drop_speed = projectile_data.drop_speed
		projectile.drop_speed += (10 - weapon_length.cast_to.x) * 0.1
		projectile.drop_speed = max(rand_drop(1 - accuracy_percentage) + projectile.drop_speed, 0.1)
		projectile.add_collision_exception_with(self)
		projectile.set_active(true)
#		projectile.connect("hit", self, "_on_hit", [projectile])
	
	_current_accuracy = clamp(_current_accuracy - 1, 0, accuracy)
	container.set_clamped("ammo_loaded", container.get("ammo_loaded"), 0, container.get("ammo_capacity"))
	timer.start()
	emit_signal("projectile_fired", container.get("ammo_loaded"))



func get_adjusted_height_to_target(target : Vector2) -> float:
	var distance_to_target : float = weapon_length.get_cast_to_global().distance_to(target)
	var adjusted_height : float = distance_to_target
	print(distance_to_target)
	
	if distance_to_target < 150:
		adjusted_height *= distance_to_target / 150
#		adjusted_height *= 1.2
	
	print(adjusted_height)
	return clamp(adjusted_height, 7, distance_to_target)


func get_projectile_data() -> ProjectileTemplate:
	return container.get("ammo_type").get("projectile")



func rand_spread(spread_range : float) -> float:
	return rand_range(-spread_range, spread_range)


func rand_drop(drop_range : float) -> float:
	return rand_range(-drop_range, drop_range) * 2


func _on_ProjectilePool_new_projectile_added(new_projectile : Projectile) -> void:
	add_collision_exception_with(new_projectile)
	new_projectile.add_collision_exception_with(self)


func _on_hit(projectile : Projectile) -> void:
	print(weapon_length.get_cast_to_global().distance_to(projectile.global_position))
