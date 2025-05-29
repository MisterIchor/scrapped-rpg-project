extends RichTextEffect

var bbcode : String = "test"
var char_max : int = 0



func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	if char_fx.absolute_index > char_max:
		char_max = char_fx.absolute_index
	else:
		
	
	return true
