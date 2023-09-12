extends Node3D

@onready var camPose:Node3D = get_node("CamPos1");
@onready var camera:Camera3D = get_node("ViewFrame/Pivot/Camera3D")

var timer = 0.0
var timer2 = 0.0
@export var screenshake = 0.0002
var shakeamnt = 0.0

var camZoom = 12
var camPan = Vector3(3.406219,-5.133698,0)

var viewingMonitor = false

var panning = false

func _ready():
	if !OS.is_debug_build():
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _process(delta):
	$ViewFrame.position = lerp($ViewFrame.position,camPose.position,0.15)
	$ViewFrame.rotation = lerp($ViewFrame.rotation,camPose.rotation,0.15)
		
	timer += delta * randf()
	timer2 += delta * randf()
	$ViewFrame/Pivot/Camera3D.rotation.x = 	sin(timer*30)*shakeamnt*0.001
	$ViewFrame/Pivot/Camera3D.rotation.y = 	cos(timer2*30)*shakeamnt*0.001
	
	#print(str(camZoom) + "  " + str(camPan))
	if viewingMonitor:
		camZoom = lerp(camZoom,20.0,0.2)
		
	camZoom = clampf(camZoom,10.0,30.0)
	var fov = lerp($ViewFrame/Pivot/Camera3D.fov,camZoom,0.05)
	$ViewFrame/Pivot/Camera3D.fov = fov
	
	if viewingMonitor:
		$ViewFrame/Pivot.position = lerp($ViewFrame/Pivot.position,Vector3(0,0,0),0.2)
	else:
		$ViewFrame/Pivot.position = lerp($ViewFrame/Pivot.position,camPan,0.1)
		
	if Input.is_action_just_pressed("fullscreen"):
		if DisplayServer.window_get_mode(0) == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	updateMouse()
		
var lastMousePos = Vector3()

func _input(event):
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("Click"):
			$ViewFrame/Pivot/Cursor/hand2.set_blend_shape_value(0,1.0)
		if Input.is_action_just_released("Click"):
			panning = false
			$ViewFrame/Pivot/Cursor/hand2.set_blend_shape_value(0,0.0)
	elif event is InputEventMouseMotion:
		updateMouse()
	
func updateMouse():
	var mousepos = get_viewport().get_mouse_position()
	var viewsize = Vector2(get_viewport().size.x,get_viewport().size.y)
	var curpos = mousepos - (viewsize / 2)
	
	var scaleFactor = ($ViewFrame/Pivot/Camera3D.fov / 1000) * 1.67
	var yfactor = 720/viewsize.y
	if yfactor > 1: yfactor = 1
	
	var fov = $ViewFrame/Pivot/Camera3D.fov * yfactor
	$ViewFrame/Pivot/Cursor.scale = Vector3(fov,fov,fov)
	
	$ViewFrame/Pivot/Cursor.position.x = curpos.x * scaleFactor * yfactor
	$ViewFrame/Pivot/Cursor.position.y = -curpos.y * scaleFactor * yfactor
	
	if panning:
		camPan.x -= $ViewFrame/Pivot/Cursor.position.x - lastMousePos.x
		camPan.y -= $ViewFrame/Pivot/Cursor.position.y - lastMousePos.y
		#print(camPan.x)
		camPan = camPan.clamp(Vector3(-20,-14,0),Vector3(20,6,0))
	
	lastMousePos = $ViewFrame/Pivot/Cursor.position
		
	$Cards.cursorPos.x = $ViewFrame/Pivot/Cursor.position.x + camPan.x
	$Cards.cursorPos.y = $ViewFrame/Pivot/Cursor.position.y + camPan.y
	
func switchView():
	viewingMonitor = !viewingMonitor
	if viewingMonitor:
		camPose = get_node("CamPos2")
		shakeamnt = screenshake
	else:
		camPose = get_node("CamPos1")
		
		shakeamnt = 0.0


func _on_monitor_area_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed && event.is_action("Click"):
			switchView()

func _on_table_pan_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed && event.is_action("Click"):
			panning = true
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if event.pressed:
				camZoom += 2
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if event.pressed:
				camZoom -= 2
		
