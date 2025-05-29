extends Label

func _ready():
	text = str(OS.get_date().month,"/",OS.get_date().day,"/",OS.get_date().year)
