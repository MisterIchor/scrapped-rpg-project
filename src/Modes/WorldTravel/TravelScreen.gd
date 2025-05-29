extends Node

var encounterchance = 0.1
var encounters = 0
var encounterroll = null

onready var encountertimer = $EncounterTimer



func _on_TravelArrow_moving():
	if encountertimer.is_stopped():
		encountertimer.start()
	elif encountertimer.paused == true:
		encountertimer.paused = false


func _on_TravelArrow_notmoving():
	if encountertimer.paused == false:
		encountertimer.paused = true


func _on_EncounterTimer_timeout():
	encounterroll = randi() % 100
	print(encounterroll)
	
	if encounterroll <= encounterchance:
		print("Encounter!")
		encounterchance = 0.1
		encounters = encounters + 1
	else:
		encounterchance += 0.5
		
	prints(encounterchance, encounters)
