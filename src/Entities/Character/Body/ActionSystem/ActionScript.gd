tool
extends EnhancedObject
class_name ActionScript

const NOTIFICATION_START : int = 5
const NOTIFICATION_FINISHED : int = 6
const NOTIFICATION_INTERRUPTED : int = 7
const NOTIFICATION_CANCELLED : int = 8
const NOTIFICATION_SELECTED : int = 9
const NOTIFICATION_CONFIRMED : int = 10
const NOTIFICATION_PROCESS : int = 11
const NOTIFICATION_PHYSICS_PROCESS : int = 12
const NOTIFICATION_DRAW : int = 13

signal confirmed()
signal finished()

var selected_instructions : String = "Whoever made script this doesn't want you to know what it does =P."
var soul : Soul = null
var body : Unit = null
var rid : RID = VisualServer.canvas_item_create()
var configurable_values : Array = []
var requirements : Array = []
var is_finished : bool = false
var queue_index : int = -1



func _init() -> void:
	messages.no_body_info_found = ["No body info found.", 0]
	messages.no_soul_found = ["No soul found? Uh oh.", 0]
	messages.no_path_finder_found = ["No pathfinder found.", 0]
	messages.no_path_follower_found = ["No pathfollower found.", 0]
	messages.no_personal_space_found = ["No personal space? Wierdo.", 0]
	messages.container_used_null = ["Null value found in place of %s.", 0]
	messages.no_rid_parent = ["No parent for RID found, drawing will be disabled for this action.",0]


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			VisualServer.canvas_item_clear(rid)
			VisualServer.free_rid(rid)
		NOTIFICATION_OWNER_SET:
			if owner is Unit:
				if owner.canvas_to_draw_on:
					VisualServer.canvas_item_set_parent(rid, owner.canvas_to_draw_on.get_canvas_item())
		NOTIFICATION_START:
			_start()

# Executed when action is removed from the action queue and set as current.
func _start() -> void:
	return

# Like above, but when the action is readied.
func _start_readied() -> void:
	return

# Executed when action is completed and ready to be freed.
func _finished() -> void:
	return

# Executed when action is yielded i.e. when the action phase ends before it could finish.
func _interrupted() -> void:
	return

# Executed when action is freed prematurely i.e. ended before it could finish.
func _canceled() -> void:
	return

# Executed when action has been chosen but not yet added to the action queue.
func _selected(event : InputEvent) -> void:
	return

# Executed when action is added to action queue.
func _confirmed() -> void:
	return

# Executed when action menu is opened. Determines whether this action is 
# selectable. Must return a bool value.
func _condition_check() -> bool:
	return true

# Executed when previewing the action via the ActionMenu or CreateAction.
func _preview() -> void:
	return

# Executed while the action is set as current and the action phase is running.
func _handle_process(delta : float) -> void:
	return

# Like _handle_process, but for physics processing.
func _handle_physics_process(delta : float) -> void:
	return

# Executed when in planning phase. Use VisualServer to draw.
# i.e. VisualServer.add_circle(get("rid"), Vector2(15, 15), 5, Color.white)
func _handle_draw() -> void:
	return



func mark_as_finished() -> void:
	if not is_finished:
		is_finished = true
		emit_signal("finished")


func add_configurable_value(value_name : String) -> void:
	if not value_name in configurable_values:
		if get(value_name):
			configurable_values.append(value_name)


func increment_value_in_container(container_name : String, value_name : String, by : float) -> void:
	soul.increment_value_in_container(container_name, value_name, by)


func turn_body_to_dir(dir : float) -> void:
	get_path_follower().rotation = lerp_angle(get_path_follower().rotation, dir, 0.07)



func set_value_in_container(container_name : String, value_name : String, value) -> void:
	soul.set_value_in_container(container_name, value_name, value)



func get_angle_to_point(point : Vector2) -> float:
	return point.angle_to_point(get_body_position())


func get_facing_to_point_ratio(point : Vector2) -> float:
	var dir_tracker_dir : Vector2 = get_dir_tracker().get_cast_to_dir()
	var dir : Vector2 = get_body_position().direction_to(point)
	var dot : float = dir_tracker_dir.dot(dir)
	
	if is_equal_approx(dot, 1):
		dot = 1
	
	return max(dot, 0)


func get_body_position() -> Vector2:
	return get_path_follower().global_position


func get_container(container_name : String) -> DataContainer:
	return soul.get_container(container_name)


func get_configurable_values() -> Array:
	return configurable_values


func get_dir_tracker() -> RayCast2D:
	return body.dir_tracker


func get_los_trackers() -> Node2D:
	return body.los_trackers


func get_path_finder() -> Path2D:
	return body.path_finder


func get_path_follower() -> PathFollow2D:
	return body.path_follower


func get_mouse_position() -> Vector2:
	return get_path_follower().get_global_mouse_position()


func get_navigation() -> AStar2D:
	return body.astar


func get_script_from_action(index : int, script_name : String) -> ActionScript:
	if index > body.get_action_queue_size() - 1:
		return null
	
	var objects_from_script : Dictionary = body.get_objects_from_action(index)
	return objects_from_script.get(script_name)


func get_script_from_current_action(script_name : String) -> ActionScript:
	return get_script_from_action(queue_index, script_name)


func get_script_from_previous_action(script_name : String) -> ActionScript:
	return get_script_from_action(queue_index + 1, script_name)


func get_script_from_last_action(script_name : String) -> ActionScript:
	var queue_size : int = body.get_action_queue_size()
	var script : ActionScript = get_script_from_action(queue_size - 1, script_name)
	
	return script if not script == self else null


func get_value_from_container(container_name : String, value_name : String):
	return soul.get_value_from_container(container_name, value_name)
