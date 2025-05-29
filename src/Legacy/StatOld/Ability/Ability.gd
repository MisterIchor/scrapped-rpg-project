extends DataContainer

signal action_finished(next_action)



func _init() -> void:
	add_value("type", -1)
	add_value("action", null)
	add_value("next_action", null)
	add_value("formula_action_points", [])
	add_value("formula_stamina", [])
	add_value("special_conditions", [])
	add_value("active", false)



func _set_template(new_template) -> void:
	._set_template(new_template)



func enter() -> void:
	if not is_conditions_met():
		return
	
	get_action_script()._enter()


func handle_input(event : InputEvent) -> void:
	get_action_script()._handle_input(event)


func handle_key_input(event : InputEventKey) -> void:
	get_action_script()._handle_key_input(event)


func handle_process(delta : float) -> void:
	get_action_script()._handle_process(delta)


func handle_physics_process(delta : float) -> void:
	get_action_script()._handle_physics_process(delta)


func exit() -> void:
	get_action_script()._exit()



func add_special_condition(new_condition) -> void:
	var current_conditions : Array = get_special_conditions()
	
	if has_condition(new_condition):
		LogSystem.write_to_debug("Ability: condition " + new_condition + " already exists.", 1)
	
	current_conditions.append(new_condition)
	set_special_conditions(current_conditions)


func has_condition(condition_name : String) -> bool:
	return true # need to create condition template.


func is_conditions_met() -> bool:
	return true



func set_type(new_type : int) -> void:
	set("type", new_type)


func set_action(new_script : Action) -> void:
	var action : Action = new_script.new()
	
	action.owner = owner
	set("action", action)


func set_action_points_formula(new_formula : Array) -> void:
	set("formula_action_points", new_formula)


func set_stamina_formula(new_formula : Array) -> void:
	set("formula_stamina", new_formula)


func set_special_conditions(new_conditions : Array) -> void:
	set("special_conditions", new_conditions)


func set_active(value : bool) -> void:
	set("active", value)



func get_action_script() -> Action:
	return get("action")


func get_special_conditions() -> Array:
	return get("special_conditions")

