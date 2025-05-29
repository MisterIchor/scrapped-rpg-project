extends DataContainer
class_name EquipmentSystem

enum EquipStatus {EQUIPPED, UNEQUIPPED, 
		ALREADY_EQUIPPED, ALREADY_UNEQUIPPED, 
		NO_SLOTS_AVAILABLE, SLOT_NOT_FOUND}



func _init() -> void:
#	set_process_changed_values(true)
	add_value("weight", 0)
	add_value("inventory", {})
	add_value("equipped_items", [])
	add_value("equipment_slots", {})



func _calculate_weight() -> void:
	var inventory : Dictionary = get("inventory")
	
	for i in inventory:
		for j in inventory[i]:
			increment_value("weight", i.get("weight"))



func add_to_inventory(new_item : Item) -> void:
	if is_item_in_inventory(new_item):
		return
	
	var inventory : Dictionary = get("inventory")
	var item_catagory : String = new_item.get("catagory")
	
	if not inventory.has(item_catagory):
		set_key_in_dictionary("inventory", item_catagory, {})
	
	var inventory_catagory : Array = get_catagory(item_catagory)
	inventory_catagory.append(new_item)
	_calculate_weight()


func remove_from_inventory(item_to_remove : Item) -> void:
	if not is_item_in_inventory(item_to_remove):
		return
	
	var inventory_catagory : Array = get_catagory(item_to_remove.get("catagory"))
	inventory_catagory.erase(item_to_remove)
	
	if inventory_catagory.empty():
		get("inventory").erase(item_to_remove.get("catagory"))
	
	_calculate_weight()



func equip(item : Item) -> int:
	if item in get("equipped_items"):
		return EquipStatus.ALREADY_EQUIPPED
	
	var equipment_slots : Dictionary = get("equipment_slots")
	var slots_to_occupy : Dictionary = item.get("slots_to_occupy")
	
	for i in slots_to_occupy:
		if not equipment_slots.has(i):
			return EquipStatus.SLOT_NOT_FOUND
		
		if equipment_slots.get(i):
			return EquipStatus.NO_SLOTS_AVAILABLE
	
	for i in slots_to_occupy:
		equipment_slots[i] = true
	
	append_to_array("equipped_items", item)
	return EquipStatus.EQUIPPED


func unequip(item : Item) -> int:
	if not item in get("equipped_items"):
		return EquipStatus.ALREADY_UNEQUIPPED
	
	var equipment_slots : Dictionary = get("equipment_slots")
	var slots_to_occupy : Dictionary = item.get("slots_to_occupy")
	
	for i in slots_to_occupy:
		equipment_slots[i] = false
	
	get("equipped_items").erase(item)
	return EquipStatus.UNEQUIPPED



func get_catagory(catagory : String) -> Array:
	return get("inventory").get(catagory, [])


func is_item_in_inventory(item : Item) -> bool:
	var inventory : Dictionary = get("inventory").duplicate()
	var item_catagory : String = item.get("catagory")
	
	if inventory.has(item_catagory):
		if item in inventory.get(item_catagory):
			return true
	
	inventory.erase(item_catagory)
	
	for i in inventory.values():
		if item in i:
			return true
	
	return false


func is_item_equipped(item : Item) -> bool:
	return get("equipped_items").has(item)
