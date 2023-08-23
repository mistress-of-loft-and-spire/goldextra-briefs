extends MeshInstance3D

var highlight = false;

var lightengergy = 0.0

func _on_monitor_area_mouse_entered():
	highlight = true
func _on_monitor_area_mouse_exited():
	highlight = false
	
func _process(delta):
	timer += delta * 0.0003171
	if highlight && !get_parent().get_parent().viewingMonitor:
		lightengergy = 1.0
	else:
		lightengergy = 0.0
		
	$Sprite3D.modulate.a = lerp($Sprite3D.modulate.a, lightengergy, 0.3)

var timer = 0.64582751
