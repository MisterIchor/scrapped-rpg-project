extends BaseTemplate
class_name AnimationTemplate

# ONESHOT plays the animation once, then stops.
# LOOP repeats the animation after it finishes.
# LOOP_ALTERNATE plays the animation and then plays it in reverse.
export (String, "ONESHOT", "LOOP", "LOOP_ALTERNATE") var type : String = "ONESHOT"
# animation structure:
# {
# 	target_limb = "name of limb",
# 	target_group = "name of group",
# 	tween_method = "name of method, must start with tween_*",
# 	parameters = [array of parameters]
# }
# Create animations using the animation tool.
export (Array) var animation_data : Array = []
