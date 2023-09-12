extends AudioStreamPlayer

var pitchtarget = 1.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pitchy = pitchtarget
	if get_tree().paused:
		pitchy = 0.3
		$pausevignette.visible = true
	else:
		$pausevignette.visible = false
	pitch_scale = lerp(pitch_scale,pitchy,0.05)
