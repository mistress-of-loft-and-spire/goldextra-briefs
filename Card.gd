extends Node3D

@onready var cardConsumed = preload("res://ConsumedCard.tscn")
@onready var cardEffect = preload("res://CardEffect.tscn")

var dragging = false;
var hover = false;
@onready var timer:Timer = Timer.new();
@onready var progressTimer:Timer = Timer.new();
var targetAngle = 0.0

var root = null
var child = null

var pickable = true

var countdown = -1.0

var type:String = "notype"
var types = []

var label = "This is a test label"

var recipe = []

var issignal = false
var isgoal = false

var turninto = null

func _ready():
	add_child(timer)
	add_child(progressTimer)
	progressTimer.process_mode = PROCESS_MODE_PAUSABLE
	timer.process_mode = PROCESS_MODE_ALWAYS
	timer.one_shot = true
	progressTimer.one_shot = true
	timer.connect("timeout", self.showLabel)
	$Visual/highlight.visible = false

func _process(delta):
	$Visual/Countdown.visible = false
	if !progressTimer.is_stopped():
		$Visual/Progress.scale.x = (1 - (progressTimer.time_left / progressTimer.wait_time)) * 4
	
	if dragging:
		var targetPos = Vector3(0,0,0)
		targetPos.x = root.cursorPos.x
		targetPos.z = -root.cursorPos.y
		targetPos = targetPos.clamp(Vector3(-20,-10, -8.2), Vector3(20,20,13))
		targetAngle += (position.x - targetPos.x) * 0.002
		rotation.y = lerp_angle(rotation.y,targetAngle,0.3)
		rotation.x = lerp_angle(rotation.x,0.15,0.3)
		position.x = lerp(position.x, targetPos.x, 0.5)
		position.z = lerp(position.z, targetPos.z, 0.5)
		position.y = lerp(position.y, 2.0,0.5)
		
		$Visual/highlight.visible = true
		$Label.visible = false
		
		if Input.is_action_just_released("Click"):
			putDown()
	else:
		rotation.y = 0
		rotation.x = 0
		
		if hover:
			$Visual/highlight.visible = true
			if pickable:
				position.y = lerp(position.y, 0.2,0.5)
					
		else:
			timer.stop()
			$Visual/highlight.visible = false
			$Label.visible = false
			position.y = lerp(position.y, 0.061,0.5)
	
	if root.pause:
		progressTimer.paused = true
	else:
		progressTimer.paused = false
		
	if get_tree().paused:
		if countdown > 0:
			if countdown < 30 || $Visual/highlight.visible || type.contains("signal"):
				$Visual/Countdown.visible = true
		return
	
	if countdown > 0 && !root.pause: 
		
		if progressTimer.time_left != 0 && progressTimer.time_left < 3:
			countdown -= delta * 0.8
		elif progressTimer.time_left != 0 && progressTimer.time_left < 5:
			countdown -= delta * 0.9
		else:
			countdown -= delta
		
		if countdown <= 0:
			countdownDone()
		if countdown < 30 || $Visual/highlight.visible || type.contains("signal"):
			$Visual/Countdown.visible = true
		if countdown < 10:
			var count = floor(countdown*10)/10
			$Visual/Countdown.text = "%.1f" % count
			$Visual/Countdown.modulate = Color("ffffff")
			$Visual/Countdown.scale = Vector3(1.15,1.15,1.15)
			$Visual/Countdown/ProgressCircle.scale = Vector3(2.6,2.6,2.6)
			$Visual/highlight.visible = true
		else:
			$Visual/Countdown.text = str(floor(countdown))
			$Visual/Countdown.modulate = Color("4164b4")
			$Visual/Countdown.scale = Vector3(1,1,1)
	
func pickUp():
	if root.pause || !pickable || child != null:
		return
	if get_parent() != root:
		global_position.y = 0 
		get_parent().child = null
		reparent(root,true)
	$pick.play()
	if type == "pig":
		$oink.play()
	timer.stop()
	cancelEffectTimer()
	dragging = true
	turnCol(false)
	if root.hoveredCard == self:
		root.hoveredCard = null
	
func putDown():
	$place.play()
	dragging = false
	if root.hoveredCard == self:
		root.hoveredCard = null
	
	if root.hoveredCard != null:
		placeCardOnTop(self, root.hoveredCard)
		root.hoveredCard = null
		
	turnCol(true)
	#card stack offset area
	if get_parent() == root && position.x >= -13 && position.x <= -7:
		if position.z >= -5 && position.z <= 5:
			position.x = -7;
	
	if issignal:
		root.dopause()
		root.addMessage("As we push on through the VOID one of our CREW notices an unusual signature in the radio spectrum. It appears to be a transmission but it is not encoded as a message or anything else recognizable. Also it seems to originate from the solar system we just left. What kind of data could they be trying to send after us?\n\nAfter some further analysis we have determined that this SIGNAL is indeed not a message, but rather an encoded algorithm. More worrying though: This code has been finely tuned to the genetic makeup of our CREW...\n\nRead the SIGNAL card text to find out more...","unpause")
		issignal = false
	elif isgoal:
		root.dopause()
		root.addMessage("After an arduous trip through the cosmos our sensors have finally picked up a HOSPITABLE PLANET. Preliminary readings seem promising...\n\nOnce we are ready we can make landfall on this PLANET with the use of MOMENTUM. However: We have to make sure to eliminate the threat of the encroaching SIGNAL first, otherwise staying here would bring certain doom...\n\nPlacing a MOMENTUM card on the HOSPITABLE PLANET will end the game. Make sure the CREW is safe from THE SIGNAL before doing so, but do not take too long or this chance will pass...","unpause")
		isgoal = false

func placeCardOnTop(top, bottom):
	var origparent = top.get_parent()
	if origparent != null:
		if origparent != root:
			top.get_parent().child = null
	top.reparent(bottom,false)
	if bottom != root:
		bottom.child = top
		top.global_position = bottom.global_position
		top.position.y += 0.4
		top.position.z += 1
		top.cancelEffectTimer()
		bottom.checkEffect()
	else:
		top.global_position = origparent.global_position
	
func highlight():
	if child != null:
		return
	if !dragging:
		root.hoveredCard = self
		$high.play()
		timer.start(0.5)
	hover = true

func unHighlight():
	hover = false
	if root.hoveredCard == self:
		root.hoveredCard = null
	
func showLabel() -> void:
	$Label.visible = true
	i = 0
	printText()
	
func countdownDone():
	cancelEffectTimer()
	if turninto != null:
		var ecard = root.addCard(Vector2(position.x,position.z), turninto)
		if child != null:
			placeCardOnTop(child,ecard)
		placeCardOnTop(ecard,self)
	if types.has("signal"):
		root.lost("signal")
	consume()

func turnCol(onoff, skiprootcheck = false):
	get_node("Area3D").visible = onoff

func returnChild():
	if child != null:
		return child.returnChild()
	else:
		return self
	
func checkEffect():
	if child == null:
		return
		
	for r in recipe:
		for t in child.types:
			if r[0] == t:
				child.setEffectTimer(r[1], self, t)
				return
		
func doEffect(childType):
	print("doingeffect")
	if child == null:
		return
	print(recipe)
	for r in recipe:
		if r[0] == childType:
			#recipe types:
			#addtime -> increase expire timer and consume child card
			#fuse -> create new card and consume both child and parent card
			#transform -> create new card and consume child card
			#mine -> create new card and consume parent card
			print(r[2])
			if r[2] == "addtime":
				countdown += int(r[4][randi() % r[4].size()])
				child.consume()
				effectVis()
				return
			elif r[2] == "endplanet":
				root.lost("goal")
				child.consume()
				effectVis()
				return
			elif r[2] == "signalsolved":
				root.signalsolved = true
				child.consume()
				consume()
				effectVis()
				return
				
			var topcard = self
			
			if r[2] != "mine":
				child.consume()
			else:
				checkExhaust(child)
				
			if child.types.has("pigdead"):
				root.deadcrew += 1
				if root.deadcrew >= 2:
					root.lost("dead")
				
			if r[2] == "transform":
				var replacecard = checkExhaust(self)
				if replacecard != null:
					topcard = replacecard
			
			var amount = int(r[3][randi() % r[3].size()])
			var lasttype = ""
			while amount > 0:
				var pickedCardtype = r[4][randi() % r[4].size()]
				if lasttype != "" && lasttype == pickedCardtype:
					pickedCardtype = r[4][randi() % r[4].size()]
				lasttype = pickedCardtype
				var card = root.addCard(Vector2(position.x,position.z), pickedCardtype)
				if topcard != root:
					if topcard.child != null:
						placeCardOnTop(topcard.child,card)
					placeCardOnTop(card,topcard)
					topcard.effectVis()
				topcard = card
				amount -= 1
			if r[2] == "fuse" || r[2] == "mine":
				consume()
				
			return
			
#	child.consume()
#	var card = root.addCard(Vector2(position.x,position.z), "wayfinding", "wayfinding", "Wayfinding")
#	placeCardOnTop(card,self)
func checkExhaust(nodey):
	var ecard = null
	if nodey.types.has("pig"):
		if nodey.types.has("exhaust"):
			ecard = root.addCard(Vector2(position.x,position.z), "pigbroken")
		elif nodey.types.has("hurt"):
			ecard = root.addCard(Vector2(position.x,position.z), "pigdead")
		elif nodey.types.has("strangepig"):
			return null
		else:
			ecard = root.addCard(Vector2(position.x,position.z), "pigexhaust")
	elif nodey.types.has("ship"):
		if nodey.types.has("exhaust"):
			ecard = root.addCard(Vector2(position.x,position.z), "shipbroken")
		elif nodey.types.has("shipbroken"):
			ecard = root.addCard(Vector2(position.x,position.z), "acbroken")
		else:
			ecard = root.addCard(Vector2(position.x,position.z), "shipexhaust")
	else:
		return null
		
	if ecard != null:
		if nodey.child != null:
			placeCardOnTop(nodey.child,ecard)
		placeCardOnTop(ecard,nodey.get_parent())
		nodey.child = null;
		nodey.consume()
		return ecard
	
func setEffectTimer(time, caller, type):
	progressTimer.connect("timeout", caller.doEffect.bind(type))
	progressTimer.start(time)
	$Visual/Progress.visible = true
	
func cancelEffectTimer():
	progressTimer.stop()
	$Visual/Progress.visible = false

func effectVis():
	$Visual/Progress.visible = false
	var eff = cardEffect.instantiate()
	add_child(eff)
	
func consume():
	for t in types:
		if t == "goal":
			root.lost("goaltimeout")
		elif t == "acbroken":
			root.lost("shipdead")
		elif t == "acdead":
			root.deadcrew += 1
			if root.deadcrew >= 2:
				root.lost("dead")
	if child != null:
		child.cancelEffectTimer()
		placeCardOnTop(child,get_parent())
	var cons = cardConsumed.instantiate()
	cons.position = position
	get_parent().add_child(cons)
	if root.hoveredCard == self:
		root.hoveredCard = null
	queue_free()
	
var i = 0

func printText():
	if hover && !dragging && i < label.length():
		i += 3
		$Label.text = label.left(i)
		await get_tree().create_timer(0.01).timeout
		if i%4 == 0 || i == 1:
			$AudioStreamPlayer3D.play()
		printText()
		
func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				pickUp()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN || event.button_index == MOUSE_BUTTON_WHEEL_UP:
			root.get_parent()._on_table_pan_input_event(null, event, null,null,null)

func _on_area_3d_mouse_entered():
	highlight()
func _on_area_3d_mouse_exited():
	unHighlight()
