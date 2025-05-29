extends Control

var name_generator : NameGenerator = NameGenerator.new("res://assets/namelists/human/male/male.txt")
var test : SoulTemplate = load("res://src/Resources/PremadeSouls/PlayerDefault.tres")


func _on_Button_pressed() -> void:
	$Button.set_text(name_generator.generate_name())
