extends PanelContainer

const ItemDisplay : PackedScene = preload("res://src/GlobalUI/CharacterSheet/Inventory/ItemDisplay.tscn")

var catagory : String = ""
var items_in_list : Array = []
var _parser : Parser = Parser.new(self, {})

onready var list : HBoxContainer = ($ScrollContainer/List as HBoxContainer)
onready var item_names : VBoxContainer = ($ScrollContainer/List/Name as VBoxContainer)



func _ready() -> void:
	var item : Item = Item.new()
	item.set_template(load("res://src/Resources/Items/Weapons/Ranged/Peestol.tres"))
	add_item(item)



func add_stat_section(section_name : String) -> void:
	if has_stat_section(section_name):
		return
	
	var new_section : VBoxContainer = VBoxContainer.new()
	var v_seperator : VSeparator = VSeparator.new()
	var section_label : Label = Label.new()
	var h_seperator : HSeparator = HSeparator.new()
	
	new_section.name = section_name
	v_seperator.name = section_name + "Seperator"
	section_label.text = section_name
	list.add_child(v_seperator)
	list.add_child(new_section)
	new_section.add_child(section_label)
	new_section.add_child(h_seperator)


func add_item(new_item : Item) -> void:
	if new_item in items_in_list:
		return
	
	var display_values : Dictionary = new_item.get_valid_display_values()
	var new_display : HBoxContainer = ItemDisplay.instance()
	
	item_names.add_child(new_display)
	new_display.set_item(new_item)
	
	for i in display_values:
		if not has_stat_section(i):
			add_stat_section(i)
		
		var new_label : Label = Label.new()
		
		new_label.name = new_item.name
		new_label.text = str(display_values[i])
		new_label.align = Label.ALIGN_CENTER
		get_stat_section(i).add_child(new_label)



func get_stat_section(section_name : String) -> VBoxContainer:
	return list.get_node_or_null(section_name) as VBoxContainer


func has_stat_section(section_name : String) -> bool:
	return list.has_node(section_name)
