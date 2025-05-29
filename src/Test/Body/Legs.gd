extends "LimbGroup.gd"

enum LegState {IDLE, HOLD, MOVING}

var legs : Dictionary = {}



func _ready() -> void:
	for i in get_children():
		_add_limb(i, {
			state = LegState.IDLE
		})
