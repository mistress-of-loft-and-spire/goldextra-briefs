extends Node

var screenRatio:float
var uiScaleFactor = 1.0

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().root.connect("size_changed",Callable(self,"viewportSizeChanged"))
	viewportSizeChanged()

func _input(event):
	if event is InputEventMouseMotion:
		var mouseRatio = Vector2.ZERO
		mouseRatio.x =  event.position.x / get_viewport().size.x
		mouseRatio.y =  event.position.y / get_viewport().size.y
		var mousePos:Vector2
		mousePos.x = (mouseRatio.x * screenRatio - screenRatio / 2)
		mousePos.y = (mouseRatio.y * screenRatio - screenRatio / 2)
		
		$SubViewportContainer/viewport/tableScene.mouseMovement(mousePos)

func viewportSizeChanged():
	screenRatio = 1.0 * get_viewport().size.x / get_viewport().size.y

