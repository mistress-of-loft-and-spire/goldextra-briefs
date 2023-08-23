extends "res://Card.gd"

func pickUp():
	if Grimoire.paused:
		return
	timer.stop()
	
	get_parent().drawCard(position)

func highlight():
	if Grimoire.paused:
		return
	if !dragging:
		$high.play()
		timer.start(0.5)
	hover = true
