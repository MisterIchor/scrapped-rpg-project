extends ValueTracker
class_name Attribute



func _calculate_values() -> void:
	set("current", 0)
	increment_value("current", get("base"))
	set_clamped("current", get("current"), 0, get("max"))
