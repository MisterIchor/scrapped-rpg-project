extends Instruction

func _init() -> void:
	set_name("SkillCheckInstructions")
	messages.no_stat_found = ["could not find skill of name %s on soul %s.", 0]



func _roll(soul : Soul, instruction : Dictionary) -> bool:
	emit_signal("request_memory_sent", str(soul.name, "_", instruction.stat_name))
	
	if value_requested:
		return value_requested >= instruction.difficulty_check
	
	var stat : Stat = soul.get_container(instruction.stat_name)
	
	if not stat:
		log_debug(messages.no_stat_found, [instruction.stat_name, soul.name])
		return false
	
	var rolled_value : int = Gambler.roll(stat.get_current_value())
	emit_signal("sent_to_memory", str(soul.name, "_", instruction.stat_name), rolled_value, false)
	return rolled_value >= instruction.difficulty_check


func _static_check(soul : Soul, instruction : Dictionary) -> bool:
	var stat : Stat = soul.get_container(instruction.stat_name)
	
	if not stat:
		log_debug(messages.no_stat_found, [instruction.stat_name, soul.name])
		return false
	
	return stat.get_current_value() >= instruction.difficulty_check


func _make_check(soul : Soul, instruction : Dictionary) -> bool:
	match instruction.check_type:
		"ROLL":
			return _roll(soul, instruction)
		"STATIC":
			return _static_check(soul, instruction)
		_:
			return Gambler.roll() >= instruction.difficulty_check



func leader(instruction : Dictionary, _output) -> bool:
	return _make_check(PartySystem.get_leader(), instruction)


func party(instruction : Dictionary, _output) -> Array:
	var results : Array = []
	
	for i in PartySystem.get_party_members():
		results.append(_make_check(i, instruction))
	
	return results


func highest_value(instruction : Dictionary, _output) -> bool:
	var chosen_one : Soul = PartySystem.get_leader()
	var chosen_value : DataContainer = chosen_one.get_container(instruction.stat_name)
	
	for i in PartySystem.get_party_members():
		if i == chosen_one:
			continue
		
		var member_value : DataContainer = i.get_container(instruction.stat_name)
		
		if not chosen_value:
			log_debug(messages.no_stat_found, [instruction.stat_name, chosen_one.get_soul_name()])
			chosen_one = i
			chosen_value = chosen_one.get_container(instruction.stat_name)
			continue
		
		if not member_value:
			log_debug(messages.no_stat_found, [instruction.stat_name, i.get_soul_name()])
			continue
		
		if member_value.get_current_value() > chosen_value.get_current_value():
			chosen_one = i
			chosen_value = chosen_one.get_container(instruction.stat_name)
	
	return _make_check(chosen_one, instruction)


func random(instruction : Dictionary, _output) -> bool:
	var party_members : Array = PartySystem.get_party_members().duplicate()
	var chosen_one : Soul = party_members[randi() % party_members.size()]
	var has_stat : bool = not chosen_one.get_container(instruction.stat_name) == null
	
	while not has_stat:
		if party_members.empty():
			return false
		
		party_members.erase(chosen_one)
		chosen_one = party_members[randi() % party_members.size()]
		has_stat = not chosen_one.get_container(instruction.stat_name) == null
	
	return _make_check(chosen_one, instruction)
