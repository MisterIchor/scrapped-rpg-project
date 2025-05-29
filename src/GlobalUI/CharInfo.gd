extends ColorRect

const AttributeInfo : PackedScene = preload("res://src/GlobalUI/AttributeInfo.tscn")

var soul : Soul = null setget set_soul
onready var attributes : GridContainer = ($Information/MainStatistics/Attributes as GridContainer)



func _ready() -> void:
	set_soul(PartySystem.get_leader())



func set_soul(new_soul : Soul) -> void:
	if not attributes:
		yield(self, "ready")
	
	if soul:
		for i in attributes.get_children():
			i.queue_free()
	
	soul = new_soul
	
	if soul:
		for i in soul.get_containers():
			var container : DataContainer = soul.get_container(i)
			
			if not container == Attribute:
				continue
			
			if container.get("hide"):
				continue
			
			var new_info : Button = AttributeInfo.instance()
			
			attributes.add_child(new_info)
			new_info.set_owner(self)
			new_info.set_attribute_container(container)
