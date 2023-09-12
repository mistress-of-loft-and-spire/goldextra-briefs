extends "res://Card.gd"

var maxCards = 25
var cardsLeft;

var canDraw = false

func _ready():
	cardsLeft = maxCards
	add_child(timer)
	add_child(progressTimer)
	timer.one_shot = true
	progressTimer.one_shot = true
	timer.connect("timeout", self.showLabel)
	$Visual/highlight.visible = false
	progressTimer.process_mode = PROCESS_MODE_PAUSABLE
	timer.process_mode = PROCESS_MODE_ALWAYS
	
	setDrawTimer()
	progressTimer.start(3.0)

func pickUp():
	if root.pause || !canDraw || cardsLeft == 0 || get_tree().paused:
		return
	timer.stop()
	
	if cardsLeft == maxCards-2:
		get_parent().drawCard(position,"signal")
	elif cardsLeft == maxCards:
		get_parent().drawCard(position,"origin")
	elif cardsLeft == 5:
		get_parent().drawCard(position,"goal")
	elif cardsLeft == 1:
		get_parent().drawCard(position,"")
		consume()
	else:
		get_parent().drawCard(position,"")
	
	cardsLeft -= 1
	setDrawTimer()

func highlight():
	if root.pause:
		return
	if !dragging:
		$high.play()
		timer.start(0.5)
	hover = true
	
	
func setDrawTimer():
	progressTimer.connect("timeout", canDrawCard)
	progressTimer.start(8.0)
	$Visual/Progress.visible = true
	canDraw = false
	$Visual/Illu.modulate = Color("7c7c7c")
	$Visual/candrawhighlight.visible = false
	$Visual/cardcount.text = str(cardsLeft) 
	$Visual/cardcount.visible = true
	#catbug pls fix!!pls!:3

func canDrawCard():
	canDraw = true
	$Visual/Progress.visible = false
	$Visual/Illu.modulate = Color("ffffff")
	hover = true
	$Visual/candrawhighlight.visible = true
	
