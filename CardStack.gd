extends "res://Card.gd"

func pickUp():
	if Grimoire.paused:
		return
	timer.stop()
	
	get_parent().drawCard(position)
