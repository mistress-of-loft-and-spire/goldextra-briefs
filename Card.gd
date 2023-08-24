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

var label = "This is a test label"

func _ready():
	add_child(timer)
	add_child(progressTimer)
	timer.one_shot = true
	progressTimer.one_shot = true
	timer.connect("timeout", self.showLabel)
	$Visual/highlight.visible = false

func _process(delta):
	if !progressTimer.is_stopped():
		$Visual/Progress.scale.x = (1 - (progressTimer.time_left / progressTimer.wait_time)) * 4
	
	if dragging:
		var targetPos = Vector3(0,0,0)
		targetPos.x = root.cursorPos.x
		targetPos.z = -root.cursorPos.y-2
		targetPos = targetPos.clamp(Vector3(-20,-10, -8.2), Vector3(20,20,13))
		targetAngle += (position.x - targetPos.x) * 0.002
		rotation.y = lerp_angle(rotation.y,targetAngle,0.3)
		rotation.x = lerp_angle(rotation.x,0.15,0.3)
		position.x = lerp(position.x, targetPos.x, 0.5)
		position.z = lerp(position.z, targetPos.z, 0.5)
		position.y = lerp(position.y, 5.0,0.5)
		
		$Visual/highlight.visible = true
		$Label.visible = false
		
		if Input.is_action_just_released("Click"):
			putDown()
		if Grimoire.paused:
			putDown()
			unHighlight()
	else:
		rotation.y = 0
		rotation.x = 0
		
		if hover:
			$Visual/highlight.visible = true
			if child != null:
				position.y = lerp(position.y, 0.061,0.5)
			elif pickable:
				position.y = lerp(position.y, 0.2,0.5)
					
		else:
			timer.stop()
			$Visual/highlight.visible = false
			$Label.visible = false
			position.y = lerp(position.y, 0.061,0.5)
	
	if countdown > 0 && !Grimoire.paused:
		countdown -= delta
		if countdown <= 0:
			countdownDone()
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
	if Grimoire.paused || !pickable:
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
	elif root.hoveredCard != null:
		var childcard = root.hoveredCard.returnChild()
		placeCardOnTop(self, childcard)
		checkEffect()
		
		root.hoveredCard = null
	turnCol(true)
	if get_parent() == root && position.x >= -7 && position.x <= -4:
		if position.z >= -2 && position.z <= 1:
			position.x += 2;
			position.z += 2;
		

func placeCardOnTop(top, bottom):
	top.reparent(bottom,false)
	if bottom != root:
		bottom.child = top
		top.global_position = bottom.global_position
		top.position.y += 0.4
		top.position.z += 1
	
func highlight():
	if Grimoire.paused:
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
	consume()

func turnCol(onoff, skiprootcheck = false):
	if !skiprootcheck && get_parent() != root:
		get_parent().turnCol(onoff)
	else:
		get_node("Area3D").visible = onoff
		if child != null:
			child.turnCol(onoff, true)

func returnChild():
	if child != null:
		return child.returnChild()
	else:
		return self
	
func checkEffect(timerDone = false):
	if !timerDone && get_parent() != root:
		print(self.type + " " + str(get_parent()) + " " + str(root))
		get_parent().checkEffect()
		return
		
	if child == null:
		return
	
	match type:
		"ship":
			if child.type == "fuel":
				if !timerDone:
					child.setEffectTimer(3, self)
				else:
					child.consume()
					var card = root.addCard(Vector2(position.x,position.z), "wayfinding", "wayfinding", "Wayfinding")
					placeCardOnTop(card,self)
					effect()
		"signal":
			if child.type == "wayfinding":
				if !timerDone:
					child.setEffectTimer(1, self)
				else:
					child.consume()
					countdown += 60
					effect()

func setEffectTimer(time, callback):
	progressTimer.connect("timeout", callback.checkEffect.bind(true))
	progressTimer.start(time)
	$Visual/Progress.visible = true
	
func cancelEffectTimer():
	progressTimer.stop()
	$Visual/Progress.visible = false

func effect():
	var eff = cardEffect.instantiate()
	eff.position = position
	get_parent().add_child(eff)
	
func consume():
	if get_parent() == root:
		turnCol(true)
	if child != null:
		placeCardOnTop(child,get_parent())
		child.checkEffect()
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
