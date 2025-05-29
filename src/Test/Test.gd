extends HScrollBar

var floating_point = 3.14 setget set_floating_point
var integer = 10
var array = ["Whoa", 12, 2.0, Node.new()]
var dictionary = {
	its = "A",
	bloody = "Dictionary",
}
var e = "good shit"


func _init() -> void:
	dictionary[9] = 10
	dictionary[Node.new()] = "ayy lmao"


func _ready() -> void:
	var file : File = File.new()
	file.open("res://src/Editor/Testing.txt", File.WRITE)

	for i in ConsoleSystem.get_valid_properties(get_property_list()):
		file.store_var(get(i))
#		print(get(i))
	
	file.close()
	file.open("res://src/Editor/Testing.txt", File.READ)
	
	for i in ConsoleSystem.get_valid_properties(get_property_list()):
		set(i, file.get_var())
#		print(get(i))



func set_floating_point(new_value : float) -> void:
	floating_point = new_value
	print("whoa dude")


func _on_Timer_timeout() -> void:
	print("STOP")
