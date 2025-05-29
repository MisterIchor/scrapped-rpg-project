extends Node
class_name Unit

enum UnitType {ALLY, ENEMY, NEUTRAL}

signal action_selected(action, first_script)
signal action_finished(action)
signal action_cancelled(action)
signal action_confirmed(action)
signal script_confirmed(confirmed_script, next_script)
signal body_selected(body)

var soul : Soul = null setget set_soul
var type : int = UnitType.ALLY
var body_info : DataContainer = null
var astar : AStar2D = null
var canvas_to_draw_on : CanvasItem = null
var _item_bodies : Dictionary = {}
var _is_idle : bool = false setget set_idle
var _action_idle : ActionTemplate = load("res://src/Resources/Actions/Alert.tres")
var _action_queue : Array = []
var _action_selected : Dictionary = {
	template = null,
	action_objects = {},
	selecting = 0,
}

onready var path_finder : Path2D = ($PathFinder as Path2D)
onready var path_follower : PathFollow2D = ($PathFinder/PathFollower as PathFollow2D)
onready var los_trackers : Node2D = ($PathFinder/LOSTrackers as Node2D)
onready var dir_tracker : RayCast2D = ($PathFinder/PathFollower/KinematicBody2D/DirTracker as RayCast2D)
onready var body : BaseBody = ($PathFinder/PathFollower/KinematicBody2D as BaseBody)



func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	body.connect("input_event", self, "_on_body_input_event")
	body.load_collision_data("unit_body")
	yield(get_tree(), "idle_frame")
	los_trackers.global_position = get_body_position()
	


func _exit_tree() -> void:
	body_info.free()


func _unhandled_input(event: InputEvent) -> void:
	if is_action_selected():
		if event.is_action_pressed("pause"):
			cancel_selected_action()
			return
		
		get_selected_object()._selected(event)
	
	clear_action_drawings()
	draw_actions()


func _process(delta: float) -> void:
	for i in get_current_action_objects().values():
		i._handle_process(delta)


func _physics_process(delta: float) -> void:
	for i in get_current_action_objects().values():
		i._handle_physics_process(delta)
	
	los_trackers.global_position = path_follower.global_position



func add_action_to_queue(new_action : Dictionary) -> void:
	for i in new_action.action_objects.values():
		i.connect("finished", self, "_on_ActionScript_finished")
	
	_action_queue.append(new_action)


func add_to_los_tracker(target) -> void:
	if target == self:
		return
	
	if not target is Node2D and not target.has_method("get_body_position"):
		return
	
	var new_tracker : RayCast2D = los_trackers.add_tracker(target)
	new_tracker.add_exception($PathFinder/PathFollower/KinematicBody2D)


func create_item_body(container : Item, position : Vector2) -> BaseBody:
	var new_body : BaseBody = container.template.create_body()
	
	new_body.position = position
	body.add_child(new_body)
	new_body.set_container(container)
	return new_body


func confirm_selected_action() -> void:
	if is_action_selected():
		var action_to_confirm : Dictionary = _action_selected.duplicate(true)
		
		for i in action_to_confirm.action_objects.values():
			i.queue_index = get_action_queue().size()
		
		action_to_confirm.erase("selecting")
		add_action_to_queue(action_to_confirm)
		_action_selected.template = null
		_action_selected.action_objects.clear()
		_action_selected.selecting = 0
		emit_signal("action_confirmed", action_to_confirm)


func clear_action_queue() -> void:
	for i in get_all_actions():
		i.free()
	
	_action_queue.clear()


func clear_action_drawings() -> void:
	for i in get_all_actions(true):
		VisualServer.canvas_item_clear(i.rid)


func cancel_selected_action() -> void:
	if is_action_selected():
		emit_signal("action_cancelled", _action_selected)
		
		for i in get_objects_from_action(-1).values():
			i.free()
		
		_action_selected.template = null
		_action_selected.action_objects.clear()
		_action_selected.selecting = 0


func draw_actions() -> void:
	for i in get_all_actions(true):
		i._handle_draw()


func end_current_action() -> void:
	emit_signal("action_finished", _action_queue.front())
	
	for i in get_current_action_objects().values():
		i._finished()
		i.call_deferred("free")
	
	_action_queue.pop_front()
	
	for i in get_action_queue_size():
		for j in get_objects_from_action(i).values():
			j.queue_index = i



func select_action(action : ActionTemplate) -> void:
	if is_action_selected():
		cancel_selected_action()
	
	_action_selected.template = action
	_action_selected.action_objects = action.create_action_script_objects()
	_action_selected.selecting = 0
	
	for i in _action_selected.action_objects.values():
		i.body = self
		i.soul = soul
		i.set_owner(self)
		i.connect("confirmed", self, "_on_ActionScript_confirmed")
	
	emit_signal("action_selected", _action_selected, get_selected_object())



func set_idle(value : bool) -> void:
	if _is_idle == value:
		return
	
	_is_idle = value
	
	if _is_idle:
		select_action(_action_idle)
		confirm_selected_action()
	else:
		end_current_action()


func set_soul(new_soul : Soul) -> void:
	if soul:
		soul.disconnect("changed_value_sent", self, "_on_Soul_changed_value_sent")
		body_info.free()
	
	soul = new_soul
	set_name(str(soul.name, "Body"))
	soul.connect("changed_value_sent", self, "_on_Soul_changed_value_sent")
	body_info = soul.get_container("BodyInfo")
	
	if not body_info:
		body_info = soul.add_data_container("BodyInfo")
		body_info.add_value("body", self)
		body_info.add_value("path_finder", path_finder)
		body_info.add_value("path_follower", path_follower)
		body_info.add_value("los_trackers", los_trackers)
		body_info.add_value("dir_tracker", dir_tracker)
		body_info.add_value("astar", astar)
		
		if canvas_to_draw_on:
			body_info.add_value("rid_parent", canvas_to_draw_on.get_canvas_item())
		else:
			body_info.add_value("rid_parent", null)


func set_body_position(new_position : Vector2) -> void:
	path_follower.set_global_position(new_position)



func is_action_selected() -> bool:
	return not _action_selected.template == null



func get_all_actions(include_selected : bool = true) -> Array:
	var actions : Array = []
	
	for i in get_action_queue_size():
		actions.append_array(get_objects_from_action(i).values())
	
	if include_selected and is_action_selected():
		actions.append_array(get_objects_from_action(-1).values())
	
	return actions


func get_action_queue_size() -> int:
	return _action_queue.size()


func get_action_queue() -> Array:
	return _action_queue


func get_body_position() -> Vector2:
	return path_follower.get_global_position()


func get_current_action_objects() -> Dictionary:
	return get_objects_from_action(0)


func get_objects_from_action(index : int) -> Dictionary:
	if index == -1:
		return _action_selected.action_objects
	elif index > get_action_queue_size() or get_action_queue_size() == 0:
		return {}
	
	return get_action_queue()[index].action_objects


func get_selected_object():
	if not is_action_selected():
		return null
	
	var objects : Array = get_objects_from_action(-1).values()
	
	if _action_selected.selecting > objects.size():
		LogSystem.write_to_debug(name + ": select counter exceeds number of objects, returning latest object...", 1)
	
	return objects[clamp(_action_selected.selecting, 0, objects.size() - 1)]



func _on_body_selected(selected_body : Unit) -> void:
	if not selected_body == self and get_selected_object():
		get_selected_object().set("target", selected_body)


func _on_ActionScript_confirmed() -> void:
	get_selected_object()._confirmed()
	_action_selected.selecting += 1
	
	if not _action_selected.selecting > get_objects_from_action(-1).size() - 1:
		emit_signal("script_confirmed", get_objects_from_action(-1).values()[_action_selected.selecting - 1], get_selected_object())
		return
	
	confirm_selected_action()
	emit_signal("action_confirmed", _action_queue.front())
	
	if _is_idle:
		set_idle(false)


func _on_ActionScript_finished() -> void:
	if _is_idle:
		return
	
	for i in get_current_action_objects().values():
		if not i.is_finished:
			return
	
	end_current_action()
	
	if _action_queue.empty():
		set_idle(true)
	else:
		for i in get_current_action_objects().values():
			i._start()


func _on_Soul_changed_value_sent(container_name : String, value_name : String, value_new, value_old) -> void:
	if container_name.matchn("inventory") and value_name.matchn("equipped_items"):
		var item : Dictionary = {
			left = value_new.hand_left,
			right = value_new.hand_right,
		}
		
		if item.left and item.right and item.left == item.right:
			if item.left.get("equip_type") == ItemTemplate.EquipType.OCCUPY_ALL:
				create_item_body(item.left, Vector2(
					body.sprite.texture.get_width(), 
					body.sprite.texture.get_height() / 2
				))
		else:
			if item.left:
				create_item_body(item.left, Vector2(body.sprite.texture.get_width(), 0))
			
			if item.right:
				create_item_body(item.right, body.sprite.texture.get_size())


func _on_new_body_added(new_body : Unit) -> void:
	if not new_body == self:
		new_body.connect("body_selected", self, "_on_body_selected")
		add_to_los_tracker(new_body)


func _on_body_input_event(_viewport : Viewport, event : InputEvent, _shape_idx : int) -> void:
	if event.is_action_pressed("select"):
		emit_signal("body_selected", self)


func _on_action_phase_started() -> void:
	cancel_selected_action()
	clear_action_drawings()
	
	for i in get_current_action_objects().values():
		i._start()
	
	if body.is_connected("input_event", self, "_on_body_input_event"):
		body.disconnect("input_event", self, "_on_body_input_event")
	
	if _action_queue.empty():
		set_idle(true)
	
	set_process(true)
	set_physics_process(true)
	set_process_unhandled_input(false)



func _on_action_phase_ended() -> void:
	for i in get_current_action_objects().values():
		i._interrupted()
	
	if not body.is_connected("input_event", self, "_on_body_input_event"):
		body.connect("input_event", self, "_on_body_input_event")
	
	draw_actions()
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(true)
