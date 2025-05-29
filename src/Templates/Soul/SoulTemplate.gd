extends "../BaseTemplate.gd"
class_name SoulTemplate

export (Resource) var race : Resource
export (int, 1, 20) var level : int = 1
export (int) var age : int = 18
export (String, "MALE", "FEMALE") var gender
export (Color) var eye_color : Color = Color()
export (Color) var hair_color : Color = Color()
export (Resource) var deity : Resource
export (Array) var attributes : Array = Array()
export (Array) var stats : Array = Array()
export (Array) var skills : Array = Array()
export (Array) var proficiencies : Array = Array()
