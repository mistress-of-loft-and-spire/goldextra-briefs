extends Node3D

@onready var camPose:Node3D = get_node("CamPos1");

var timer = 0.0
var timer2 = 0.0
@export var screenshake = 0.0002
var shakeamnt = 0.0

var camZoom = 20
var camPan = Vector3(0,0,0)

var viewingMonitor = false

var panning = false

func _process(delta):
	$ViewFrame.position = lerp($ViewFrame.position,camPose.position,0.15)
	$ViewFrame.rotation = lerp($ViewFrame.rotation,camPose.rotation,0.15)
		
	timer += delta * randf()
	timer2 += delta * randf()
	$ViewFrame/Pivot/Camera3D.rotation.x = 	sin(timer*30)*shakeamnt*0.001
	$ViewFrame/Pivot/Camera3D.rotation.y = 	cos(timer2*30)*shakeamnt*0.001
	
	if Input.is_action_just_pressed("Click"):
		$ViewFrame/Pivot/Cursor/hand2.set_blend_shape_value(0,1.0)
	if Input.is_action_just_released("Click"):
		panning = false
		$ViewFrame/Pivot/Cursor/hand2.set_blend_shape_value(0,0.0)
	
	if viewingMonitor:
		camZoom = lerp(camZoom,20.0,0.2)
	else:
		pass
		#if Input.is_action_just_pressed("scrolldown"):
		#	camZoom += 2
		#elif Input.is_action_just_pressed("scrollup"):
		#	camZoom -= 2
		
	camZoom = clampf(camZoom,10.0,30.0)
	var fov = lerp($ViewFrame/Pivot/Camera3D.fov,camZoom,0.1)
	$ViewFrame/Pivot/Camera3D.fov = fov
	scaleFactor = fov * 1.16
	fov /= 10
	$ViewFrame/Pivot/Cursor.scale = Vector3(fov,fov,fov)
	if viewingMonitor:
		$ViewFrame/Pivot.position = lerp($ViewFrame/Pivot.position,Vector3(0,0,0),0.2)
	else:
		$ViewFrame/Pivot.position = lerp($ViewFrame/Pivot.position,camPan,0.2)
			
var scaleFactor = 1.0

var lastMousePos = Vector2()

func mouseMovement(mousePos:Vector2):
	
	mousePos.x *= scaleFactor
	mousePos.y *= -scaleFactor * 0.565
	
	if panning:
		camPan.x -= mousePos.x - lastMousePos.x
		camPan.y -= mousePos.y - lastMousePos.y
		camPan = camPan.clamp(Vector3(-20,-14,0),Vector3(20,6,0))
	
	lastMousePos = mousePos
	
	$ViewFrame/Pivot/Cursor.position.x = mousePos.x
	$ViewFrame/Pivot/Cursor.position.y = mousePos.y
	
	$Cards.cursorPos.x = mousePos.x + camPan.x
	$Cards.cursorPos.y = mousePos.y + camPan.y
	
	#$ViewFrame/Pivot/RayCast3D.target_position.x = mousePos
	
	var collider = $ViewFrame/Pivot/RayCast3D.get_collider()
	
	if collider:
		#print(collider)
		pass
		
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
		
