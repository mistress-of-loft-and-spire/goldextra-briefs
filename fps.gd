extends Label

var restarttimer = 0.0
var restarting = false
var fpsvisible = false

func _process(delta):
	text = " "
	
	if fpsvisible: text += str(Engine.get_frames_per_second()) + " FPS - "
	
	if Input.is_action_just_pressed("f"):
		fpsvisible = !fpsvisible
	
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
	if get_tree().paused:
		text += "Paused (Space to Unpause)"
		
	if Input.is_action_just_pressed("restart"):
		restarting = true
		restarttimer = 0.0
	elif Input.is_action_just_released("restart"):
		restarting = false
		restarttimer = 0.0
		
	if restarting:
		restarttimer += delta
		text += "Hold to restart game..."
		
	if Input.is_action_just_pressed("esc"):
		get_tree().quit(0)
		
	if restarttimer > 3:
		get_tree().reload_current_scene()
