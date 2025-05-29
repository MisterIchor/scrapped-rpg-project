extends HBoxContainer



func _on_BoxInches_value_changed(value):
	if $BoxInches.value >= 12:
		$BoxFeet.value = $BoxFeet.value + 1
		$BoxInches.value = 0
	elif $BoxInches.value <= -1:
		$BoxFeet.value = $BoxFeet.value - 1
		$BoxInches.value = 11
