extends Node3D

var hover = false;
var dragging = false
var inrect = false;

var label = "This is a test label"

var onOk = ""

func _ready():
	#Grimoire.paused = true
	$Label.text = ""
	printText()

func _process(delta):
	if hover:
		$Label/Sprite3D2.modulate = Color("#fff")
	else:
		$Label/Sprite3D2.modulate = Color("#2f33a6")
		
	if dragging:
		var targetPos = Vector3(0,0,0)
		targetPos.x = get_parent().cursorPos.x
		targetPos.z = -get_parent().cursorPos.y+2
		targetPos = targetPos.clamp(Vector3(-20,-10, -8.2), Vector3(20,20,13))
		position.x = lerp(position.x, targetPos.x, 0.5)
		position.z = lerp(position.z, targetPos.z, 0.5)
		position.y = lerp(position.y, 5.0,0.5)
		if Input.is_action_just_released("Click"):
			putDown()
	else:
		position.y = lerp(position.y, 0.061,0.5)
		
func pickUp():
	dragging = true
	
func putDown():
	dragging = false

func highlight():
	$high.play()
	hover = true

func unHighlight():
	hover = false
	
var i = 0

func printText():
	if i < label.length():
		i += 3
		$Label/ProjectedDisplay/SubViewportContainer/SubViewport/Container/Label.text = label.left(i)
		$Label/ProjectedDisplay/SubViewportContainer/SubViewport/Container.scroll_vertical += 10
		await get_tree().create_timer(0.01).timeout
		if i%4 == 0 || i == 1:
			$AudioStreamPlayer3D.play()
		printText()

#BUTTON AREA
func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed && $Label.visible:
				$confirm.play();
				$Label.visible = false
				var addd = get_tree().create_tween()
				addd.tween_property($Sprite3D,"modulate",Color(1.0,1.0,1.0,0.0),1.0)
				await $confirm.finished
				if onOk != "":
					match onOk:
						"restart":
							get_tree().reload_current_scene()
						"unpause":
							get_parent().unpause()
						"quit":
							get_parent().quitgame()
				queue_free()
#BUTTON AREA
func _on_area_3d_mouse_entered():
	highlight()
func _on_area_3d_mouse_exited():
	unHighlight()

#BOX AREA
func _on_box_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				pickUp()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN || event.button_index == MOUSE_BUTTON_WHEEL_UP:
			get_parent().get_parent()._on_table_pan_input_event(null, event, null,null,null)

#TEXT AREA
func _on_area_scroll(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				pickUp()
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if event.pressed:
				$Label/ProjectedDisplay/SubViewportContainer/SubViewport/Container.scroll_vertical += 30
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if event.pressed:
				$Label/ProjectedDisplay/SubViewportContainer/SubViewport/Container.scroll_vertical -= 30


func _on_box_area_3d_mouse_entered():
	pass # Replace with function body.


func _on_box_area_3d_mouse_exited():
	pass # Replace with function body.


