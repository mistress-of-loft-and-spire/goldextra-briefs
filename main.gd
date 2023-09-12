extends Node

var screenRatio:float
var uiScaleFactor = 1.0

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	#get_tree().root.connect("size_changed",Callable(self,"viewportSizeChanged"))
	viewportSizeChanged()

#		var mouseRatio = Vector2.ZERO
#		mouseRatio.x =  event.position.x / get_viewport().size.x
#		mouseRatio.y =  event.position.y / get_viewport().size.y
#		print(screenRatio)
#		var mousePos:Vector2
#		var screenRatio2 = 1.0 * get_viewport().size.y / get_viewport().size.x
#		mousePos.x = mouseRatio.x
#		mousePos.y = (mouseRatio.y * screenRatio2 - screenRatio2 / 2)
		#pass
		#$SubViewportContainer/viewport/tableScene.mouseMovement(get_viewport().get_mouse_position())
		
#	if Input.is_action_just_pressed("fullscreen"):
#		if DisplayServer.window_get_mode(0) == DisplayServer.WINDOW_MODE_WINDOWED:
#			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
#		else:
#			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func viewportSizeChanged():
	screenRatio = 1.0 * get_viewport().size.x / get_viewport().size.y

