extends Control

var sentence : String = "I WAS ALREADY SO FAR PASSED THE POINT OF NO RETURN I COULDNT EVEN REMEMBER WHAT IT LOOKED LIKE WHEN I PASS THE POINT OF NO RETURN LIKE PASS THE POINT OF NO RETURN I PASS THE TURN LIKE POINT NO RETURN"
var maxletters : int = sentence.length()
var currentletter : int = 0

onready var samples : Array = ($Samples as Node).get_children()



func isSamplePlaying() -> bool:
	for sample in samples:
		if sample.is_playing():
			return true
	return false

func playSample():
	if isSamplePlaying() == false:
		get_node(samples[randi() % samples.size()].get_path()).play()


func _ready():
	randomize()
	print(maxletters)


func _on_DialogueSpeed_timeout():
	if currentletter != maxletters:
		$ColorRect/Label.text += sentence[currentletter]
		playSample()
		currentletter += 1
