extends Node3D

var hover = false;
var inrect = false;

var label = "This is a test label"

func _ready():
	Grimoire.paused = true
	$Label.text = ""
	printText()

func _process(delta):
	if hover:
		$Label/Sprite3D2.modulate = Color("#fff")
	else:
		$Label/Sprite3D2.modulate = Color("#2f33a6")

func highlight():
	$high.play()
	hover = true

func unHighlight():
	hover = false
	
var i = 0

func printText():
	if i < label.length():
		i += 3
		$Label/ProjectedDisplay/SubViewport/Container/Label.text = label.left(i)
		$Label/ProjectedDisplay/SubViewport/Container.scroll_vertical += 10
		await get_tree().create_timer(0.01).timeout
		if i%4 == 0 || i == 1:
			$AudioStreamPlayer3D.play()
		printText()

func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed && $Label.visible:
				$confirm.play();
				$Label.visible = false
				var addd = get_tree().create_tween()
				addd.tween_property($Sprite3D,"modulate",Color(1.0,1.0,1.0,0.0),1.0)
				await $confirm.finished
				Grimoire.paused = false
				queue_free()

func _on_area_3d_mouse_entered():
	highlight()
func _on_area_3d_mouse_exited():
	unHighlight()



func _on_area_scroll(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if event.pressed:
				$Label/ProjectedDisplay/SubViewport/Container.scroll_vertical += 30
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if event.pressed:
				$Label/ProjectedDisplay/SubViewport/Container.scroll_vertical -= 30
