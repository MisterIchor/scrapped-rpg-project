extends TemplateContainer
class_name Item

signal destroyed(item)



func _init() -> void:
	add_value("price_mod", 1.0)
	add_value("durability_current", -1.0)


func _notification(what: int) -> void:
	if what == NOTIFICATION_TEMPLATE_SET:
		if get("durability_current") == -1.0:
			set("durability_current", get("durability_max"))



func _calculate_price_mod() -> void:
	set("price_mod", get("durability_current") / get("durability_max"))



func _set(property: String, value) -> bool:
	if property == "durability_current" or property == "durability_max":
		_calculate_price_mod()
	
	return ._set(property, value)


func _get(property: String):
	if property == "durability_max":
		return template.health_base



func repair_damage(damage_to_repair : int) -> void:
	if get("durability_current") >= get("durability_max"):
		return
	
	if sign(damage_to_repair) == -1:
		damage_to_repair = -damage_to_repair
	
	set_clamped("durability_current", get("durability_current") + damage_to_repair, 0, get("durability_max"))


func take_damage(total_damage : int) -> void:
	if sign(total_damage) == 1:
		total_damage = -total_damage
	
	set_clamped("durability_current", get("durability_current") - total_damage, 0, get("durability_max"))
	
	if get("durability_current") <= 0:
		emit_signal("destroyed", self)
	
	_calculate_price_mod()



func get_valid_display_values() -> Dictionary:
	var values : Dictionary = get_data()
	var template_properties : Dictionary = template.get_template_properties()
	
	for i in template.get_template_properties():
		values[i] = template_properties[i]
	
	for i in template.display_exceptions:
		values.erase(i)
	
	return values


func get_group_from_sound_bank(group_name : String) -> Array:
	return get("sound_bank").get(group_name, [])


func get_price() -> int:
	return int(get("base_price") * get("price_mod"))

