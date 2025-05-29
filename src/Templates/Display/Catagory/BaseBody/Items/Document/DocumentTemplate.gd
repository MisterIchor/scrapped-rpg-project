extends ItemTemplate
class_name DocumentTemplate

export (Resource) var text : Resource = null
export (float) var weight_per_page : float = 0.01
export (String) var structure_type : String = String()
export (Dictionary) var scroll : Dictionary = {
	horizontal = false,
	vertical = true
}
#export var transition = null
var last_page : int = 0


func _init() -> void:
	if not Engine.editor_hint:
		if text:
			weight += (text.pages.size() * weight_per_page)
